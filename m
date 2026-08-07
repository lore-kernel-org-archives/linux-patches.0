Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1655228E0;
	Fri,  7 Aug 2026 14:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113876; cv=none; b=orAoCIhGfnlv++qTm2SMOEP/+/XK/BbXQmPT/zgmzGQxDyxqzsw/LziQUOGy59d2gA6p+hDvf2lUFmMnZQTCStlja3Xeb4Zx+iIu6/HIEYiS8wc4sBanoBnk2972b59ybLp6JPL6EOYexciZW0QNSrMXh+uhJRZfPd/fAy3Gl54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113876; c=relaxed/simple;
	bh=Mf+tok6goaHLf6gNgTbsHUEl6piaYRS2fUfAha5j5NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjfbDBsey6En3wEIdjnmujLO0OCHFv1Jk12B1UdtoQtXArVs3WHdaPwM1+APzKH9KOBY9TOLB+ZpLZRRz+KdFqLBuv9mni7dvBYn3iJPr1Rj1TttYhLa4F7S/95NsQzBVOSujFTe1sNojrEkcM5eAIlTd5hTThbu1cWYPyXivBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cxZF7sGx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cxZF7sGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2551F00A3E;
	Fri,  7 Aug 2026 14:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113865;
	bh=2eEkjNvbhvWk4j8SOpOLjsmCwqrs42g6zltQ4J+h/5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cxZF7sGxnDLw83Una7ZwOq5jHATYYwmjwPjSTT6nNGhBnyJCVmJPqGizE9TXgqAof
	 m7blZPJUIucACzbj/Iz0xUKewSOQ0RIfZVN6bf18lg8InoqHyuI0tgpCB5IQR0efBo
	 atF1Ytogy4G5WbKVwL4Q69ZUO7jlZ2RZW69spMA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/337] hwmon: (ina2xx) Add support for has_alerts configuration flag
Date: Fri,  7 Aug 2026 16:34:24 +0200
Message-ID: <20260807143419.835604708@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit de0da6ae1908b43b23782d64b4564b5ca3119f7f ]

Add configuration flag indicating if the chip supports alerts and limits
to prepare for adding INA260 support.

Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: e6c80061ca23 ("hwmon: (ina2xx) Fix various overflow issues")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ina2xx.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index f0fa6d073627f..03a011c9b73da 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -129,6 +129,7 @@ enum ina2xx_ids { ina219, ina226 };
 
 struct ina2xx_config {
 	u16 config_default;
+	bool has_alerts;	/* chip supports alerts and limits */
 	int calibration_value;
 	int shunt_div;
 	int bus_voltage_shift;
@@ -155,6 +156,7 @@ static const struct ina2xx_config ina2xx_config[] = {
 		.bus_voltage_shift = 3,
 		.bus_voltage_lsb = 4000,
 		.power_lsb_factor = 20,
+		.has_alerts = false,
 	},
 	[ina226] = {
 		.config_default = INA226_CONFIG_DEFAULT,
@@ -163,6 +165,7 @@ static const struct ina2xx_config ina2xx_config[] = {
 		.bus_voltage_shift = 0,
 		.bus_voltage_lsb = 1250,
 		.power_lsb_factor = 25,
+		.has_alerts = true,
 	},
 };
 
@@ -624,6 +627,7 @@ static umode_t ina2xx_is_visible(const void *_data, enum hwmon_sensor_types type
 				 u32 attr, int channel)
 {
 	const struct ina2xx_data *data = _data;
+	bool has_alerts = data->config->has_alerts;
 	enum ina2xx_ids chip = data->chip;
 
 	switch (type) {
@@ -633,12 +637,12 @@ static umode_t ina2xx_is_visible(const void *_data, enum hwmon_sensor_types type
 			return 0444;
 		case hwmon_in_lcrit:
 		case hwmon_in_crit:
-			if (chip == ina226)
+			if (has_alerts)
 				return 0644;
 			break;
 		case hwmon_in_lcrit_alarm:
 		case hwmon_in_crit_alarm:
-			if (chip == ina226)
+			if (has_alerts)
 				return 0444;
 			break;
 		default:
@@ -651,12 +655,12 @@ static umode_t ina2xx_is_visible(const void *_data, enum hwmon_sensor_types type
 			return 0444;
 		case hwmon_curr_lcrit:
 		case hwmon_curr_crit:
-			if (chip == ina226)
+			if (has_alerts)
 				return 0644;
 			break;
 		case hwmon_curr_lcrit_alarm:
 		case hwmon_curr_crit_alarm:
-			if (chip == ina226)
+			if (has_alerts)
 				return 0444;
 			break;
 		default:
@@ -668,11 +672,11 @@ static umode_t ina2xx_is_visible(const void *_data, enum hwmon_sensor_types type
 		case hwmon_power_input:
 			return 0444;
 		case hwmon_power_crit:
-			if (chip == ina226)
+			if (has_alerts)
 				return 0644;
 			break;
 		case hwmon_power_crit_alarm:
-			if (chip == ina226)
+			if (has_alerts)
 				return 0444;
 			break;
 		default:
@@ -802,7 +806,7 @@ static int ina2xx_init(struct device *dev, struct ina2xx_data *data)
 	if (ret < 0)
 		return ret;
 
-	if (data->chip == ina226) {
+	if (data->config->has_alerts) {
 		bool active_high = device_property_read_bool(dev, "ti,alert-polarity-active-high");
 
 		regmap_update_bits(regmap, INA226_MASK_ENABLE,
-- 
2.53.0



