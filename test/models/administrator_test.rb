require 'test_helper'

class AdministratorTest < ActiveSupport::TestCase
  def setup
    @admin = Administrator.new(name: "Example Admin", email: "admin@example.com",
                               password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @admin.valid?
  end

  test "name should be present" do
    @admin.name = "    "
    assert_not @admin.valid?
  end

  test "email should be present" do
    @admin.email = "     "
    assert_not @admin.valid?
  end

  test "name should not be too long" do
    @admin.name = "a" * 51
    assert_not @admin.valid?
  end

  test "email should not be too long" do
    @admin.email = "a" * 244 + "@example.com"
    assert_not @admin.valid?
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @admin.email = invalid_address
      assert_not @admin.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_admin = @admin.dup
    @admin.save
    assert_not duplicate_admin.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @admin.email = mixed_case_email
    @admin.save
    assert_equal mixed_case_email.downcase, @admin.reload.email
  end

  test "password should be present (nonblank)" do
    @admin.password = @admin.password_confirmation = " " * 6
    assert_not @admin.valid?
  end

  test "password should have a minimum length" do
    @admin.password = @admin.password_confirmation = "a" * 5
    assert_not @admin.valid?
  end
end
