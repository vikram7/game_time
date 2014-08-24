require 'pry'
require 'sinatra'

ARRAY_OF_TEAMS_AND_GAMES = [
  {
    home_team: "Patriots",
    away_team: "Broncos",
    home_score: 7,
    away_score: 3
  },
  {
    home_team: "Broncos",
    away_team: "Colts",
    home_score: 3,
    away_score: 0
  },
  {
    home_team: "Patriots",
    away_team: "Colts",
    home_score: 11,
    away_score: 7
  },
  {
    home_team: "Steelers",
    away_team: "Patriots",
    home_score: 7,
    away_score: 21
  }
]


def winner(hash)
  if hash[:home_score] > hash[:away_score]
    return hash[:home_team]
  else
    return hash[:away_team]
  end
end

def get_the_names_of_all_the_teams(array)
  array_of_just_team_names = []
  array.each do |game|
    array_of_just_team_names << game[:home_team]
    array_of_just_team_names << game[:away_team]
  end
array_of_just_team_names.uniq
end

def make_wins_hash(array)
  wins_hash = Hash.new(0)
  get_the_names_of_all_the_teams(ARRAY_OF_TEAMS_AND_GAMES).each do |x|
    wins_hash[x] = 0
  end

  array.each do |game|
    if game[:home_team] == winner(game)
      wins_hash[game[:home_team]] += 1
    else
      wins_hash[game[:away_team]] += 1
    end
  end
wins_hash
end

def make_loss_hash(array)
  loss_hash = Hash.new(0)
  get_the_names_of_all_the_teams(ARRAY_OF_TEAMS_AND_GAMES).each do |x|
    loss_hash[x] = 0
  end

  array.each do |game|
    if game[:home_team] == winner(game)
      loss_hash[game[:away_team]] += 1
    else
      loss_hash[game[:home_team]] += 1
    end
  end
loss_hash
end

get '/' do
  redirect '/leaderboard'
end

get '/leaderboard' do
  @wins_hash = make_wins_hash(ARRAY_OF_TEAMS_AND_GAMES)
  @loss_hash = make_loss_hash(ARRAY_OF_TEAMS_AND_GAMES)

  erb :leaderboard
end

get '/:team' do
  if get_the_names_of_all_the_teams(ARRAY_OF_TEAMS_AND_GAMES).include?(params[:team])

    @wins_hash = make_wins_hash(ARRAY_OF_TEAMS_AND_GAMES)
    @loss_hash = make_loss_hash(ARRAY_OF_TEAMS_AND_GAMES)

    @chosen_team = params[:team]
    @chosen_teams_games = Hash.new
    @chosen_teams_games = ARRAY_OF_TEAMS_AND_GAMES.select {|x| x[:home_team] == @chosen_team || x[:away_team] == @chosen_team}

    erb :team_page

  else
    @no_team = params[:team]
    erb :no_team_page
  end

end


