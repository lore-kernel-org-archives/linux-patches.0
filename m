Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F105278F32;
	Tue, 27 May 2025 17:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365283; cv=none; b=uKgg7k7LUTdkaE+63LMCBND+imnT96pNKrxl81BwbfzscdgDmbnCs7ZOmsaxuNseTry9n+Nytjq6p2gjts7zNJogiC9LcEW91osZmK+/58UZTA5vRHQY9QDK2DoPCwckuBStYVLLwEx46zIwCrCP39iUQf7hVcFMb7H7om9gloI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365283; c=relaxed/simple;
	bh=IGE1ycXy760b7teWMdtI7ETRkFsGP/XPJ/A9YmhagBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qljlorHkNUQR82gHWPTm72dkcJGdX1vIw1xDbuXb+GG575w7Jpk1Sn9d71gtebm4/DzTnGX3INEwI7MPMKsXA+ZD/fPv3V6bUb2I9ejMpCn1nkppJTHjFMvSiCcBpbHmavDC8kNRXfGqlvJBjMUPrZv9SnfhZ3EfQriUkEVfozA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BebNG3E/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BebNG3E/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F002C4CEE9;
	Tue, 27 May 2025 17:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365282;
	bh=IGE1ycXy760b7teWMdtI7ETRkFsGP/XPJ/A9YmhagBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BebNG3E/fQWIq4cH4Grh3GLyoCfdb3NMhGV3A0yjclJz2DRD6B7d5P48Ejm6KMO9/
	 FdxKC4xSfyVvaUKFUdbsBLId+O5iIfDC3bK9M75lyywPWe4IoGDFA6egk/1LOt+p5W
	 JxLj7WO0all7aA9Ja2AA6X5LNcUqfeaxltyY/DTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Philippe Simons <simons.philippe@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 326/626] power: supply: axp20x_battery: Update temp sensor for AXP717 from device tree
Date: Tue, 27 May 2025 18:23:39 +0200
Message-ID: <20250527162458.279195251@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Chris Morgan <macromorgan@hotmail.com>

[ Upstream commit bbcfe510ecd47f2db4c8653c7dfa9dc7a55b1583 ]

Allow a boolean property of "x-powers,no-thermistor" to specify devices
where the ts pin is not connected to anything. This works around an
issue found with some devices where the efuse is not programmed
correctly from the factory or when the register gets set erroneously.

Signed-off-by: Chris Morgan <macromorgan@hotmail.com>
Tested-by: Philippe Simons <simons.philippe@gmail.com>
Link: https://lore.kernel.org/r/20250204155835.161973-4-macroalpha82@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/axp20x_battery.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/power/supply/axp20x_battery.c b/drivers/power/supply/axp20x_battery.c
index 57eba1ddb17ba..88fbae613e8bc 100644
--- a/drivers/power/supply/axp20x_battery.c
+++ b/drivers/power/supply/axp20x_battery.c
@@ -89,6 +89,8 @@
 #define AXP717_BAT_CC_MIN_UA		0
 #define AXP717_BAT_CC_MAX_UA		3008000
 
+#define AXP717_TS_PIN_DISABLE		BIT(4)
+
 struct axp20x_batt_ps;
 
 struct axp_data {
@@ -117,6 +119,7 @@ struct axp20x_batt_ps {
 	/* Maximum constant charge current */
 	unsigned int max_ccc;
 	const struct axp_data	*data;
+	bool ts_disable;
 };
 
 static int axp20x_battery_get_max_voltage(struct axp20x_batt_ps *axp20x_batt,
@@ -983,6 +986,24 @@ static void axp717_set_battery_info(struct platform_device *pdev,
 	int ccc = info->constant_charge_current_max_ua;
 	int val;
 
+	axp_batt->ts_disable = (device_property_read_bool(axp_batt->dev,
+							  "x-powers,no-thermistor"));
+
+	/*
+	 * Under rare conditions an incorrectly programmed efuse for
+	 * the temp sensor on the PMIC may trigger a fault condition.
+	 * Allow users to hard-code if the ts pin is not used to work
+	 * around this problem. Note that this requires the battery
+	 * be correctly defined in the device tree with a monitored
+	 * battery node.
+	 */
+	if (axp_batt->ts_disable) {
+		regmap_update_bits(axp_batt->regmap,
+				   AXP717_TS_PIN_CFG,
+				   AXP717_TS_PIN_DISABLE,
+				   AXP717_TS_PIN_DISABLE);
+	}
+
 	if (vmin > 0 && axp717_set_voltage_min_design(axp_batt, vmin))
 		dev_err(&pdev->dev,
 			"couldn't set voltage_min_design\n");
-- 
2.39.5



