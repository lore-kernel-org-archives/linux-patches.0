Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876B61DC998;
	Tue, 27 May 2025 17:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367479; cv=none; b=DwFN+VamwAOqbBgoXxmMxDQ4AHBRpS/3pjLqVEHR7Mvw/DmJovRDTMo4k4ZJIzzrjoREVmk/l/JYYb4Lws1Ezd9jo3Y3kW3DbwQlFAVbx9cHLa0hQpTYIWj8NPL0QDkLyjkNGHd/NZrYx54PSi5A6V9RE7w8B2SPDzlqlc7YNDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367479; c=relaxed/simple;
	bh=wvppdJ1uOzfS2Tg2HJS4PiqHaQHBaplRfeS0AbiQcxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfxbO4Wnr8mAn0YLFW4I/T9CW5uCeJ3Un99Oxu8vXAyMl0bCOwXJlDAOWI2b33zlz3TOkZ1P8p5EJJy7BVZf3rHQVjUBVWM29argOmrLN8sUpwU8c9ub8mrZrgk+PCG8Ots4uye52fAjhIATNDtC/maEuxKt2vtPbRzYy7YYU4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MT88/lxZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MT88/lxZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1925BC4CEE9;
	Tue, 27 May 2025 17:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367479;
	bh=wvppdJ1uOzfS2Tg2HJS4PiqHaQHBaplRfeS0AbiQcxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MT88/lxZHA27davFaUc+kTL4n2SYQPjTZxDnKubF1/8e5w96jdb7sVgdqLeq5H+Sg
	 f6Vkpppi4qqNkEBsfIDObB7ZynDIylO04itJ4OLLYItFXuaQ0TWmKSIhRyQG9U9j8P
	 /NMdT4NotOTKKNoFibnSihRFIllTwvvFK7nb2ZEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Philippe Simons <simons.philippe@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 401/783] power: supply: axp20x_battery: Update temp sensor for AXP717 from device tree
Date: Tue, 27 May 2025 18:23:18 +0200
Message-ID: <20250527162529.424710705@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 3c3158f31a484..f4cf129a0b683 100644
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
@@ -984,6 +987,24 @@ static void axp717_set_battery_info(struct platform_device *pdev,
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



