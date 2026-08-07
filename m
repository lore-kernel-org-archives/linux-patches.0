Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E9F40EB9D;
	Fri,  7 Aug 2026 14:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113890; cv=none; b=InvoGpENBAVSV9JT/18YhQCWDiMkS5lSM18hZCzd0CHMU5DUJgNZHbbh/njMsOQAxCnnBJ6aIhYsXQB4t3ReLcMatN17H2qjsHqB+y8rzOE46D1ZheiuPI8l802yBdToF9Os97L9Fn20W/SmCoI5qkTbmztgQ/HLd6si6w1RAy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113890; c=relaxed/simple;
	bh=ilAgG5SeEIK51He05ZHTcjqNvsR525lXs9FzRFn1qdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oYxMoYQILJryW+hvpC73xm10HsuXl/47WDGC0eKqLXucp3wgjU+On7XkzbbhIEMb3CexyFBVXBuLqpDtZbCqITyJ+7phsaE6pV9ILeFMCgnVV6jWgoCXCa68rduQRA3hmRcR5u/8lR/06Xj+k6pA9w04tahDp8JeY7UygKyOCvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TcTyKIdz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TcTyKIdz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615E41F00A3E;
	Fri,  7 Aug 2026 14:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113879;
	bh=3v/1NasXlAQs4e1vg0ctJV5/xD0nM/tDDIKO7+uQQjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TcTyKIdzr1f8ljKYKluCYwll1tm/lAbOkgyNcMjfAAW6GAym+cE/uhkr930KDENHO
	 GUo8RHQIKqYZh2Bh7d0j80d3XN+o7j/Eh33lLyeIkpvEmm4j2R3WgtECKW9M3vI0aN
	 EzILVy8FEw0PAjQV23qqR8ndVK8T+DcE+jvL1/qU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Rebmann <jre@pengutronix.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/337] hwmon: (ina2xx) Shift INA234 shunt and current registers
Date: Fri,  7 Aug 2026 16:34:29 +0200
Message-ID: <20260807143419.942850604@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Rebmann <jre@pengutronix.de>

[ Upstream commit eeca1114d1e2cc0eacaebb80f3f2afbaebfc60be ]

The INA219 has the lowest three bits of the bus voltage register
zero-reserved, the bus_voltage_shift ina2xx_config field was introduced
to accommodate for that.

The INA234 has four bits of the bus voltage, of the shunt voltage, and
of the current registers zero-reserved but the latter two were
implemented by choosing a 16x higher shunt_div instead of a separate
field specifying a bit shift.

This is possible because shunt voltage and current are divided by
shunt_div, hence a 16x higher shunt_div results in a 16x smaller LSB for
both the shunt voltage and the current register, perfectly accounting
for the missing bit shift.

For consistency and correctness, account for the reserved bits via
shunt_voltage_shift and current_shift configuration fields as already
done for voltage registers and use the conversion constants given in the
INA234 datasheet.

Signed-off-by: Jonas Rebmann <jre@pengutronix.de>
Link: https://lore.kernel.org/r/20260303-ina234-shift-v1-2-318c33ac4480@pengutronix.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: e6c80061ca23 ("hwmon: (ina2xx) Fix various overflow issues")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ina2xx.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index be6e214fae21f..d671d546b2054 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -151,9 +151,11 @@ struct ina2xx_config {
 	bool has_update_interval;
 	int calibration_value;
 	int shunt_div;
+	int shunt_voltage_shift;
 	int bus_voltage_shift;
 	int bus_voltage_lsb;	/* uV */
 	int power_lsb_factor;
+	int current_shift;
 };
 
 struct ina2xx_data {
@@ -173,59 +175,69 @@ static const struct ina2xx_config ina2xx_config[] = {
 		.config_default = INA219_CONFIG_DEFAULT,
 		.calibration_value = 4096,
 		.shunt_div = 100,
+		.shunt_voltage_shift = 0,
 		.bus_voltage_shift = 3,
 		.bus_voltage_lsb = 4000,
 		.power_lsb_factor = 20,
 		.has_alerts = false,
 		.has_ishunt = false,
 		.has_power_average = false,
+		.current_shift = 0,
 		.has_update_interval = false,
 	},
 	[ina226] = {
 		.config_default = INA226_CONFIG_DEFAULT,
 		.calibration_value = 2048,
 		.shunt_div = 400,
+		.shunt_voltage_shift = 0,
 		.bus_voltage_shift = 0,
 		.bus_voltage_lsb = 1250,
 		.power_lsb_factor = 25,
 		.has_alerts = true,
 		.has_ishunt = false,
 		.has_power_average = false,
+		.current_shift = 0,
 		.has_update_interval = true,
 	},
 	[ina234] = {
 		.config_default = INA226_CONFIG_DEFAULT,
 		.calibration_value = 2048,
-		.shunt_div = 400, /* 2.5 µV/LSB raw ADC reading from INA2XX_SHUNT_VOLTAGE */
+		.shunt_div = 25, /* 2.5 µV/LSB raw ADC reading from INA2XX_SHUNT_VOLTAGE */
+		.shunt_voltage_shift = 4,
 		.bus_voltage_shift = 4,
 		.bus_voltage_lsb = 25600,
 		.power_lsb_factor = 32,
 		.has_alerts = true,
 		.has_ishunt = false,
 		.has_power_average = false,
+		.current_shift = 4,
 		.has_update_interval = true,
 	},
 	[ina260] = {
 		.config_default = INA260_CONFIG_DEFAULT,
 		.shunt_div = 400,
+		.shunt_voltage_shift = 0,
 		.bus_voltage_shift = 0,
 		.bus_voltage_lsb = 1250,
 		.power_lsb_factor = 8,
 		.has_alerts = true,
 		.has_ishunt = true,
 		.has_power_average = false,
+		.current_shift = 0,
 		.has_update_interval = true,
 	},
 	[sy24655] = {
 		.config_default = SY24655_CONFIG_DEFAULT,
 		.calibration_value = 4096,
 		.shunt_div = 400,
+		.shunt_voltage_shift = 0,
 		.bus_voltage_shift = 0,
 		.bus_voltage_lsb = 1250,
 		.power_lsb_factor = 25,
 		.has_alerts = true,
 		.has_ishunt = false,
 		.has_power_average = true,
+		.current_shift = 0,
 		.has_update_interval = false,
 	},
 };
@@ -279,7 +291,8 @@ static int ina2xx_get_value(struct ina2xx_data *data, u8 reg,
 	switch (reg) {
 	case INA2XX_SHUNT_VOLTAGE:
 		/* signed register */
-		val = DIV_ROUND_CLOSEST((s16)regval, data->config->shunt_div);
+		val = (s16)regval >> data->config->shunt_voltage_shift;
+		val = DIV_ROUND_CLOSEST(val, data->config->shunt_div);
 		break;
 	case INA2XX_BUS_VOLTAGE:
 		val = (regval >> data->config->bus_voltage_shift) *
@@ -291,7 +304,8 @@ static int ina2xx_get_value(struct ina2xx_data *data, u8 reg,
 		break;
 	case INA2XX_CURRENT:
 		/* signed register, result in mA */
-		val = (s16)regval * data->current_lsb_uA;
+		val = ((s16)regval >> data->config->current_shift) *
+		  data->current_lsb_uA;
 		val = DIV_ROUND_CLOSEST(val, 1000);
 		break;
 	case INA2XX_CALIBRATION:
@@ -385,6 +399,7 @@ static u16 ina226_alert_to_reg(struct ina2xx_data *data, int reg, long val)
 	case INA2XX_SHUNT_VOLTAGE:
 		val = clamp_val(val, 0, SHRT_MAX * data->config->shunt_div);
 		val *= data->config->shunt_div;
+		val <<= data->config->shunt_voltage_shift;
 		return clamp_val(val, 0, SHRT_MAX);
 	case INA2XX_BUS_VOLTAGE:
 		val = clamp_val(val, 0, 200000);
@@ -399,6 +414,7 @@ static u16 ina226_alert_to_reg(struct ina2xx_data *data, int reg, long val)
 		val = clamp_val(val, INT_MIN / 1000, INT_MAX / 1000);
 		/* signed register, result in mA */
 		val = DIV_ROUND_CLOSEST(val * 1000, data->current_lsb_uA);
+		val <<= data->config->current_shift;
 		return clamp_val(val, SHRT_MIN, SHRT_MAX);
 	default:
 		/* programmer goofed */
-- 
2.53.0



