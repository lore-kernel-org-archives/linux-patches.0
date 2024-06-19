Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7662014B967;
	Wed, 19 Jun 2024 13:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803763; cv=none; b=raWJxADV/dvgqT4c/kVGrSuTAPVGcjXzZQ3gIjt+5DrGAbZngZoKXvgm+RJbALrTZArtj0GQEk6W4olfAEiffU0+7eHOX/c9DtF9P9gw//XyjL4PpH8M6xHfD5fFTdokfBhMG+LLYNfP0SINRznLQDy0cOxMb69ifdeV4DU2XG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803763; c=relaxed/simple;
	bh=w/FwBrh5SY3GXQKfFRL3I27lVLECUBKYQ3aCCpgFhXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2+HjrG2FPc4ErqmGz+Kf76opHm+40L7kyGRPzIip6fryzq4kbWdlNNAOmXzGWRHVDCITm5k2lKjb+gKjoEydZXiXYe14I2XlHQq8k6df1KFw2YgJHCZ+DqpEf1Wh9/AScoWjk8iNdxnzgIKyq3GMIBaKJPcQFZk48DEImLaR0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fjetkQek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fjetkQek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8A0C4AF49;
	Wed, 19 Jun 2024 13:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803763;
	bh=w/FwBrh5SY3GXQKfFRL3I27lVLECUBKYQ3aCCpgFhXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fjetkQekMyfYgK/7S16hfwG8kp/k2VnkaA7nRfp0KeC7546gUDYXPctxmSotNuNSs
	 IbmB72aD8Lfo9EdMP5ypwNEu9VlGpq4RUM18c41buoFuGTz/cNqrojrSZhPfdbTAn8
	 kAYyrrhFg6xy83tBaq/idXN7cJr7z9Jc9+sfQB0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Cong Yang <yangcong5@huaqin.corp-partner.google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/217] HID: i2c-hid: elan: Add ili9882t timing
Date: Wed, 19 Jun 2024 14:55:11 +0200
Message-ID: <20240619125559.307572092@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Yang <yangcong5@huaqin.corp-partner.google.com>

[ Upstream commit f2f43bf15d7aa3286eced18d5199ee579e2c2614 ]

The ili9882t is a TDDI IC (Touch with Display Driver). The
datasheet specifies there should be 60ms between touch SDA
sleep and panel RESX. Doug's series[1] allows panels and
touchscreens to power on/off together, so we can add the 65 ms
delay in i2c_hid_core_suspend before panel_unprepare.

Because ili9882t touchscrgeen is a panel follower, and
needs to use vccio-supply instead of vcc33-supply, so set
it NULL to ili9882t_chip_data, then not use vcc33 regulator.

[1]: https://lore.kernel.org/all/20230727171750.633410-1-dianders@chromium.org

Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Cong Yang <yangcong5@huaqin.corp-partner.google.com>
Acked-by: Benjamin Tissoires <bentiss@kernel.org>
Link: https://lore.kernel.org/r/20230802071947.1683318-3-yangcong5@huaqin.corp-partner.google.com
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Stable-dep-of: 0eafc58f2194 ("HID: i2c-hid: elan: fix reset suspend current leakage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-of-elan.c | 50 ++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 12 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-of-elan.c b/drivers/hid/i2c-hid/i2c-hid-of-elan.c
index 2d991325e734c..35986e8297095 100644
--- a/drivers/hid/i2c-hid/i2c-hid-of-elan.c
+++ b/drivers/hid/i2c-hid/i2c-hid-of-elan.c
@@ -18,9 +18,11 @@
 #include "i2c-hid.h"
 
 struct elan_i2c_hid_chip_data {
-	unsigned int post_gpio_reset_delay_ms;
+	unsigned int post_gpio_reset_on_delay_ms;
+	unsigned int post_gpio_reset_off_delay_ms;
 	unsigned int post_power_delay_ms;
 	u16 hid_descriptor_address;
+	const char *main_supply_name;
 };
 
 struct i2c_hid_of_elan {
@@ -38,9 +40,11 @@ static int elan_i2c_hid_power_up(struct i2chid_ops *ops)
 		container_of(ops, struct i2c_hid_of_elan, ops);
 	int ret;
 
-	ret = regulator_enable(ihid_elan->vcc33);
-	if (ret)
-		return ret;
+	if (ihid_elan->vcc33) {
+		ret = regulator_enable(ihid_elan->vcc33);
+		if (ret)
+			return ret;
+	}
 
 	ret = regulator_enable(ihid_elan->vccio);
 	if (ret) {
@@ -52,8 +56,8 @@ static int elan_i2c_hid_power_up(struct i2chid_ops *ops)
 		msleep(ihid_elan->chip_data->post_power_delay_ms);
 
 	gpiod_set_value_cansleep(ihid_elan->reset_gpio, 0);
-	if (ihid_elan->chip_data->post_gpio_reset_delay_ms)
-		msleep(ihid_elan->chip_data->post_gpio_reset_delay_ms);
+	if (ihid_elan->chip_data->post_gpio_reset_on_delay_ms)
+		msleep(ihid_elan->chip_data->post_gpio_reset_on_delay_ms);
 
 	return 0;
 }
@@ -64,8 +68,12 @@ static void elan_i2c_hid_power_down(struct i2chid_ops *ops)
 		container_of(ops, struct i2c_hid_of_elan, ops);
 
 	gpiod_set_value_cansleep(ihid_elan->reset_gpio, 1);
+	if (ihid_elan->chip_data->post_gpio_reset_off_delay_ms)
+		msleep(ihid_elan->chip_data->post_gpio_reset_off_delay_ms);
+
 	regulator_disable(ihid_elan->vccio);
-	regulator_disable(ihid_elan->vcc33);
+	if (ihid_elan->vcc33)
+		regulator_disable(ihid_elan->vcc33);
 }
 
 static int i2c_hid_of_elan_probe(struct i2c_client *client,
@@ -90,24 +98,42 @@ static int i2c_hid_of_elan_probe(struct i2c_client *client,
 	if (IS_ERR(ihid_elan->vccio))
 		return PTR_ERR(ihid_elan->vccio);
 
-	ihid_elan->vcc33 = devm_regulator_get(&client->dev, "vcc33");
-	if (IS_ERR(ihid_elan->vcc33))
-		return PTR_ERR(ihid_elan->vcc33);
-
 	ihid_elan->chip_data = device_get_match_data(&client->dev);
 
+	if (ihid_elan->chip_data->main_supply_name) {
+		ihid_elan->vcc33 = devm_regulator_get(&client->dev,
+						      ihid_elan->chip_data->main_supply_name);
+		if (IS_ERR(ihid_elan->vcc33))
+			return PTR_ERR(ihid_elan->vcc33);
+	}
+
 	return i2c_hid_core_probe(client, &ihid_elan->ops,
 				  ihid_elan->chip_data->hid_descriptor_address, 0);
 }
 
 static const struct elan_i2c_hid_chip_data elan_ekth6915_chip_data = {
 	.post_power_delay_ms = 1,
-	.post_gpio_reset_delay_ms = 300,
+	.post_gpio_reset_on_delay_ms = 300,
+	.hid_descriptor_address = 0x0001,
+	.main_supply_name = "vcc33",
+};
+
+static const struct elan_i2c_hid_chip_data ilitek_ili9882t_chip_data = {
+	.post_power_delay_ms = 1,
+	.post_gpio_reset_on_delay_ms = 200,
+	.post_gpio_reset_off_delay_ms = 65,
 	.hid_descriptor_address = 0x0001,
+	/*
+	 * this touchscreen is tightly integrated with the panel and assumes
+	 * that the relevant power rails (other than the IO rail) have already
+	 * been turned on by the panel driver because we're a panel follower.
+	 */
+	.main_supply_name = NULL,
 };
 
 static const struct of_device_id elan_i2c_hid_of_match[] = {
 	{ .compatible = "elan,ekth6915", .data = &elan_ekth6915_chip_data },
+	{ .compatible = "ilitek,ili9882t", .data = &ilitek_ili9882t_chip_data },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, elan_i2c_hid_of_match);
-- 
2.43.0



