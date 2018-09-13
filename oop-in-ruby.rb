class TrainStation
  attr_reader :station_name, :trains

  def initialize(station_name)
    @station_name = station_name
    @trains = []
    puts "Создана станция #{station_name}"
  end

  def get_train(train)
    trains << train
    puts "На станцию #{station_name} прибыл поезд #{train.number}"
  end

  def send_train(train)
    trains.delete(train)
    train.station = 0
    puts "Со станции #{station_name} отправился поезд под номером: #{train.number}"
  end


  def show_trains(type = nil)
      if type
        puts "Поезда на станции #{station_name} типа #{type}: "
        trains.each{|train| puts train.number if train.type == type}
      else
        puts "Поезда на станции #{station_name}: "
        trains.each{|train| puts train.number}
      end
  end

end


class Route
  attr_accessor :stations, :from, :to

  def initialize (from, to)
    @stations = [from, to]
    puts "Создан маршрут следования #{from.station_name} - #{to.station_name}"
  end

  def add_station(station)
    self.stations.insert(-2, station)
    puts "К маршруту #{stations.first.station_name} - #{stations.last.station_name} добавлена станция #{station.station_name}"
  end

  def remove_station(station)
    if [stations.first, stations.last].include?(station)
      puts "Первую и последнюю станции маршрута удалять нельзя!"
    else
      self.stations.delete(station)
      puts "Из маршрутного листа #{stations.first.station_name} - #{stations.last.station_name} удалена станция #{station.station_name}"
    end
  end

  def show_stations
    puts "В маршрутный лист #{stations.first.station_name} - #{stations.last.station_name} входят станции с именами: "
    stations.each{|station| puts " #{station.station_name}" }
  end
end

class Train
  attr_accessor :speed, :number, :car_count, :route, :station
  attr_reader :type

  def initialize(number, type, car_count)
    @number = number
    @type = type
    @car_count = car_count
    @speed = 0
    puts "Создан поезд с номером #{number}. Тип: #{type}. Количество вагонов: #{car_count}."
  end

  def stop
    self.speed = 0
  end

  def add_car
    if speed.zero?
      self.car_count += 1
      puts "К поезду с номером #{number} прицепили вагон. Теперь их #{car_count}."
    else
      puts "Для прицепкт вагонов, поезд должен стоять."
    end
  end

  def remove_car
    if car_count.zero?
      puts "Вагонов уже не осталось."
    elsif speed.zero?
      self.car_count -= 1
      puts "От поезда с номером #{number} отцепили вагон. Теперь их #{car_count}."
    else
      puts "На ходу нельзя отцеплять вагоны!"
    end
  end

  def take_route(route)
    self.route = route
    puts "Поезду с номером #{number} задан маршрут #{route.stations.first.station_name} - #{route.stations.last.station_name}"
  end

  def go_to(station)
    if route.nil?
      puts "Без маршрута следования поезд не может отправиться."
    elsif @station == station
      puts "Поезд с номером #{@number} и так на станции #{@station.station_name}"
    elsif route.stations.include?(station)
      @station.send_train(self) if @station
      @station = station
      station.get_train(self)
    else
      puts "Станция #{station.station_name} не входит в маршрут поезда с номером#{number}"
    end
  end

  def stations_around
    if route.nil?
      puts "Маршрут следования поезда не задан."
    else
      station_index = route.stations.index(station)
      puts "Сейчас поезд на станции #{station.station_name}."
      puts "Предыдущая станция - #{route.stations[station_index - 1].station_name}." if station_index != 0
      puts "Следующая - #{route.stations[station_index + 1].station_name}." if station_index != route.stations.size - 1
    end
  end
end
