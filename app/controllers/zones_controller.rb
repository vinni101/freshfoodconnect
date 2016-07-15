class ZonesController < ApplicationController
  def index
    @zones = Zone.all
    @subscription_zipcodes = Subscription.pluck(:zipcode).uniq
  end

  def edit
    @zone = find_zone
  end

  def show
    @zone = find_zone

    if current_scheduled_pickup.present?
      redirect_to zone_scheduled_pickup_url(
        @zone,
        current_scheduled_pickup,
      )
    else
      redirect_to new_zone_scheduled_pickup_url(@zone)
    end
  end

  def create
    @zone = Zone.new(zone_params)

    if @zone.save
      redirect_to @zone
    else
      render :new
    end
  end

  def update
    @zone = find_zone

    @zone.update!(zone_params)

    redirect_to @zone, flash: { success: t(".success") }
  end

  def new
    @zone = Zone.new
  end

  private

  def find_zone
    Zone.find_by!(zipcode: params[:id])
  end

  def current_scheduled_pickup
    @zone.current_scheduled_pickup
  end

  def zone_params
    params.require(:zone).permit(
      :end_hour,
      :start_hour,
      :weekday,
      :zipcode,
    )
  end
end
