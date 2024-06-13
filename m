Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556706EB56;
	Thu, 13 Jun 2024 12:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280597; cv=none; b=Wncigz9dkUo2Nh4xu4wNL58hpOHVsuMplzgpYgm479vZgSjs3zJL7PebZTcc1xPlfCFJfPo16p+/E4E91m8FtA18TaV89LkSEzR9i43w6pG0LsnDhhZ2TJPBpjzJ2ugyx0AJsOWxyHd61FNLBe5slni8YQ7i1v0fPjS+Cmvq6L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280597; c=relaxed/simple;
	bh=xz1bYvj9zgwYYosoF9EsLPMSwCvfmewCIt2Hod78WKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhsw11JNb+TY1xnqQD3y9ClDofM+U9zqJ+hMP8dxqTWtdd9a+ZVHtfCx/kZ7hKTDpgDZYEUHiYqXOV5ZuzXuzOGoYB3K5P3/LmlN2ECOrs//v/KAp4sGS9MBwPADv+FyJM/bMADyjgb6OFwMiwg+tFKzSwV6onyTbfR8fe2nB9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GzZuCO7D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GzZuCO7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CE6C2BBFC;
	Thu, 13 Jun 2024 12:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280597;
	bh=xz1bYvj9zgwYYosoF9EsLPMSwCvfmewCIt2Hod78WKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GzZuCO7D2ZUwLsWrGoq4GScZe4/rE3PJ6HlUWL+fKDV7TaMTKzTD2xxPf6NtXGh+I
	 bLqOHiPJObUKTVVNjs71UskyzO1YHpdE47HX6l4W3BNnNjeDGGO50FdvIklOcvKVHr
	 k30ztkvqao/4uu/GD+LaF7Z4h5gL6PZWSZzTASSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Steev Klimaszewski <steev@kali.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.6 077/137] HID: i2c-hid: elan: fix reset suspend current leakage
Date: Thu, 13 Jun 2024 13:34:17 +0200
Message-ID: <20240613113226.282758054@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 0eafc58f2194dbd01d4be40f99a697681171995b upstream.

The Elan eKTH5015M touch controller found on the Lenovo ThinkPad X13s
shares the VCC33 supply with other peripherals that may remain powered
during suspend (e.g. when enabled as wakeup sources).

The reset line is also wired so that it can be left deasserted when the
supply is off.

This is important as it avoids holding the controller in reset for
extended periods of time when it remains powered, which can lead to
increased power consumption, and also avoids leaking current through the
X13s reset circuitry during suspend (and after driver unbind).

Use the new 'no-reset-on-power-off' devicetree property to determine
when reset needs to be asserted on power down.

Notably this also avoids wasting power on machine variants without a
touchscreen for which the driver would otherwise exit probe with reset
asserted.

Fixes: bd3cba00dcc6 ("HID: i2c-hid: elan: Add support for Elan eKTH6915 i2c-hid touchscreens")
Cc: <stable@vger.kernel.org>	# 6.0
Cc: Douglas Anderson <dianders@chromium.org>
Tested-by: Steev Klimaszewski <steev@kali.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20240507144821.12275-5-johan+linaro@kernel.org
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/i2c-hid/i2c-hid-of-elan.c |   59 +++++++++++++++++++++++++++-------
 1 file changed, 47 insertions(+), 12 deletions(-)

--- a/drivers/hid/i2c-hid/i2c-hid-of-elan.c
+++ b/drivers/hid/i2c-hid/i2c-hid-of-elan.c
@@ -31,6 +31,7 @@ struct i2c_hid_of_elan {
 	struct regulator *vcc33;
 	struct regulator *vccio;
 	struct gpio_desc *reset_gpio;
+	bool no_reset_on_power_off;
 	const struct elan_i2c_hid_chip_data *chip_data;
 };
 
@@ -40,17 +41,17 @@ static int elan_i2c_hid_power_up(struct
 		container_of(ops, struct i2c_hid_of_elan, ops);
 	int ret;
 
+	gpiod_set_value_cansleep(ihid_elan->reset_gpio, 1);
+
 	if (ihid_elan->vcc33) {
 		ret = regulator_enable(ihid_elan->vcc33);
 		if (ret)
-			return ret;
+			goto err_deassert_reset;
 	}
 
 	ret = regulator_enable(ihid_elan->vccio);
-	if (ret) {
-		regulator_disable(ihid_elan->vcc33);
-		return ret;
-	}
+	if (ret)
+		goto err_disable_vcc33;
 
 	if (ihid_elan->chip_data->post_power_delay_ms)
 		msleep(ihid_elan->chip_data->post_power_delay_ms);
@@ -60,6 +61,15 @@ static int elan_i2c_hid_power_up(struct
 		msleep(ihid_elan->chip_data->post_gpio_reset_on_delay_ms);
 
 	return 0;
+
+err_disable_vcc33:
+	if (ihid_elan->vcc33)
+		regulator_disable(ihid_elan->vcc33);
+err_deassert_reset:
+	if (ihid_elan->no_reset_on_power_off)
+		gpiod_set_value_cansleep(ihid_elan->reset_gpio, 0);
+
+	return ret;
 }
 
 static void elan_i2c_hid_power_down(struct i2chid_ops *ops)
@@ -67,7 +77,14 @@ static void elan_i2c_hid_power_down(stru
 	struct i2c_hid_of_elan *ihid_elan =
 		container_of(ops, struct i2c_hid_of_elan, ops);
 
-	gpiod_set_value_cansleep(ihid_elan->reset_gpio, 1);
+	/*
+	 * Do not assert reset when the hardware allows for it to remain
+	 * deasserted regardless of the state of the (shared) power supply to
+	 * avoid wasting power when the supply is left on.
+	 */
+	if (!ihid_elan->no_reset_on_power_off)
+		gpiod_set_value_cansleep(ihid_elan->reset_gpio, 1);
+
 	if (ihid_elan->chip_data->post_gpio_reset_off_delay_ms)
 		msleep(ihid_elan->chip_data->post_gpio_reset_off_delay_ms);
 
@@ -79,6 +96,7 @@ static void elan_i2c_hid_power_down(stru
 static int i2c_hid_of_elan_probe(struct i2c_client *client)
 {
 	struct i2c_hid_of_elan *ihid_elan;
+	int ret;
 
 	ihid_elan = devm_kzalloc(&client->dev, sizeof(*ihid_elan), GFP_KERNEL);
 	if (!ihid_elan)
@@ -93,21 +111,38 @@ static int i2c_hid_of_elan_probe(struct
 	if (IS_ERR(ihid_elan->reset_gpio))
 		return PTR_ERR(ihid_elan->reset_gpio);
 
+	ihid_elan->no_reset_on_power_off = of_property_read_bool(client->dev.of_node,
+						"no-reset-on-power-off");
+
 	ihid_elan->vccio = devm_regulator_get(&client->dev, "vccio");
-	if (IS_ERR(ihid_elan->vccio))
-		return PTR_ERR(ihid_elan->vccio);
+	if (IS_ERR(ihid_elan->vccio)) {
+		ret = PTR_ERR(ihid_elan->vccio);
+		goto err_deassert_reset;
+	}
 
 	ihid_elan->chip_data = device_get_match_data(&client->dev);
 
 	if (ihid_elan->chip_data->main_supply_name) {
 		ihid_elan->vcc33 = devm_regulator_get(&client->dev,
 						      ihid_elan->chip_data->main_supply_name);
-		if (IS_ERR(ihid_elan->vcc33))
-			return PTR_ERR(ihid_elan->vcc33);
+		if (IS_ERR(ihid_elan->vcc33)) {
+			ret = PTR_ERR(ihid_elan->vcc33);
+			goto err_deassert_reset;
+		}
 	}
 
-	return i2c_hid_core_probe(client, &ihid_elan->ops,
-				  ihid_elan->chip_data->hid_descriptor_address, 0);
+	ret = i2c_hid_core_probe(client, &ihid_elan->ops,
+				 ihid_elan->chip_data->hid_descriptor_address, 0);
+	if (ret)
+		goto err_deassert_reset;
+
+	return 0;
+
+err_deassert_reset:
+	if (ihid_elan->no_reset_on_power_off)
+		gpiod_set_value_cansleep(ihid_elan->reset_gpio, 0);
+
+	return ret;
 }
 
 static const struct elan_i2c_hid_chip_data elan_ekth6915_chip_data = {


