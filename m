Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B631474B8;
	Thu, 13 Jun 2024 11:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279452; cv=none; b=DDc3JdsgODgpZLw48r1RIUVii3P+acOsYE4aFUQu+KEL3duSybFzFi/vPeL7VZSiLSWqW0B4HdaCDxYsso35XgNgyFjjJORrQgSSHkcH2pgReY1pIfO//ZeNQFbkUf+8tyAx3uefX+FMOo0CfqVlUqaYk8734hZZbK44K1ZOnAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279452; c=relaxed/simple;
	bh=PTSrmsBtAYIMpNPav9e9sSC4u8kNCVHUccrMuURHuGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjMYfPNP+ZzfGYrByOoPejTLGap/atlbOzTumWyJbN6XpPXGU1V9O17a4zX+OICgChkqF2LZbZhm+aK1BzgtS1JDW22TUzy6SdxMIvv2TdgI48Oz1Kp62fLeYpPinp+jW7WUfegmYlZr7jV2SgBAyd+rCfJVjbITkh1eTw5DK00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DRr6ynXA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DRr6ynXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D8DC4AF1D;
	Thu, 13 Jun 2024 11:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279451;
	bh=PTSrmsBtAYIMpNPav9e9sSC4u8kNCVHUccrMuURHuGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DRr6ynXA85svRANnxP5VONHk8L6QAJw5F+qUDiG4a8fyW0GGiiymTJGB+GVF4KmZy
	 LnFakd17jrjWiU6r0O8DQ+UAoEnZVzKeiDeRHjMY+7EgpqwMPtms5ayJdyLAGbXM7+
	 5VgPIbMWOto1MyBfwN/IegGo7tFd4KQ+UnoHCXfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Steev Klimaszewski <steev@kali.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.9 080/157] HID: i2c-hid: elan: fix reset suspend current leakage
Date: Thu, 13 Jun 2024 13:33:25 +0200
Message-ID: <20240613113230.519063554@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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


