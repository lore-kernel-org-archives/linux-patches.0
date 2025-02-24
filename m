Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921252192E7;
	Mon, 24 Feb 2025 14:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409068; cv=none; b=uqYE8GMS7z2H7U/BU3CjFF3AF0w/YQnIWrF0LIMnK1t4gV3ZZnG9rEAJ+iz28ZWRMHXUsu6tGmzSNznlA8oYZ1JYhlcII4ZXUN9P8ghAGEANKZabdjwYRt56hPzugI7UVDXhNOaH+O3C1MvvKhEJ1wUKRihUH2hh9xhBMHg1TlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409068; c=relaxed/simple;
	bh=HgXc2Y60s/zDHCY+7Y7HVNmIZTSGUOleSg0a+yB2YGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OydgpmC35RMIfVrUw6FN0EpNk5k7mrCuiWOu0aAaasnKFmYOiUIF55TrAtNYQ7a8IHSZMGRxp7/h2P94Sq4cZsNtF29VdegTN+iNAKV+I2Hru/mgwCk1pMDwOhAfLa3Fy1bQCghxjRy8lHRniuI+j2r/fYR8aoxTpb59/W6iiTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+0n99DR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+0n99DR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1621C4CEE6;
	Mon, 24 Feb 2025 14:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409068;
	bh=HgXc2Y60s/zDHCY+7Y7HVNmIZTSGUOleSg0a+yB2YGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+0n99DRCaYn+5qpfjqZsosvsuXyr8gcoDPa96CY/CNdg6e+BztA9TLDjleBVy99w
	 +pY00oV9pT+xzFfPRVDYwwGDurGThbzv1kderXt0ngyH7u1jxquZRtrD72GijUaTlS
	 wuqbNfEj8S5UcIRNwOHBXM7tiOb4vf2Q6t+/PHcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 060/138] power: supply: axp20x_battery: Fix fault handling for AXP717
Date: Mon, 24 Feb 2025 15:34:50 +0100
Message-ID: <20250224142606.840168671@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Morgan <macromorgan@hotmail.com>

[ Upstream commit 98380110bd48fbfd6a798ee11fffff893d36062c ]

Correct the fault handling for the AXP717 by changing the i2c write
from regmap_update_bits() to regmap_write_bits(). The update bits
function does not work properly on a RW1C register where we must
write a 1 back to an existing register to clear it.

Additionally, as part of this testing I confirmed the behavior of
errors reappearing, so remove comment about assumptions.

Fixes: 6625767049c2 ("power: supply: axp20x_battery: add support for AXP717")
Signed-off-by: Chris Morgan <macromorgan@hotmail.com>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Link: https://lore.kernel.org/r/20250131231455.153447-2-macroalpha82@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/axp20x_battery.c | 31 +++++++++++++--------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/power/supply/axp20x_battery.c b/drivers/power/supply/axp20x_battery.c
index fa27195f074e7..3c3158f31a484 100644
--- a/drivers/power/supply/axp20x_battery.c
+++ b/drivers/power/supply/axp20x_battery.c
@@ -466,10 +466,9 @@ static int axp717_battery_get_prop(struct power_supply *psy,
 
 	/*
 	 * If a fault is detected it must also be cleared; if the
-	 * condition persists it should reappear (This is an
-	 * assumption, it's actually not documented). A restart was
-	 * not sufficient to clear the bit in testing despite the
-	 * register listed as POR.
+	 * condition persists it should reappear. A restart was not
+	 * sufficient to clear the bit in testing despite the register
+	 * listed as POR.
 	 */
 	case POWER_SUPPLY_PROP_HEALTH:
 		ret = regmap_read(axp20x_batt->regmap, AXP717_PMU_FAULT,
@@ -480,26 +479,26 @@ static int axp717_battery_get_prop(struct power_supply *psy,
 		switch (reg & AXP717_BATT_PMU_FAULT_MASK) {
 		case AXP717_BATT_UVLO_2_5V:
 			val->intval = POWER_SUPPLY_HEALTH_DEAD;
-			regmap_update_bits(axp20x_batt->regmap,
-					   AXP717_PMU_FAULT,
-					   AXP717_BATT_UVLO_2_5V,
-					   AXP717_BATT_UVLO_2_5V);
+			regmap_write_bits(axp20x_batt->regmap,
+					  AXP717_PMU_FAULT,
+					  AXP717_BATT_UVLO_2_5V,
+					  AXP717_BATT_UVLO_2_5V);
 			return 0;
 
 		case AXP717_BATT_OVER_TEMP:
 			val->intval = POWER_SUPPLY_HEALTH_HOT;
-			regmap_update_bits(axp20x_batt->regmap,
-					   AXP717_PMU_FAULT,
-					   AXP717_BATT_OVER_TEMP,
-					   AXP717_BATT_OVER_TEMP);
+			regmap_write_bits(axp20x_batt->regmap,
+					  AXP717_PMU_FAULT,
+					  AXP717_BATT_OVER_TEMP,
+					  AXP717_BATT_OVER_TEMP);
 			return 0;
 
 		case AXP717_BATT_UNDER_TEMP:
 			val->intval = POWER_SUPPLY_HEALTH_COLD;
-			regmap_update_bits(axp20x_batt->regmap,
-					   AXP717_PMU_FAULT,
-					   AXP717_BATT_UNDER_TEMP,
-					   AXP717_BATT_UNDER_TEMP);
+			regmap_write_bits(axp20x_batt->regmap,
+					  AXP717_PMU_FAULT,
+					  AXP717_BATT_UNDER_TEMP,
+					  AXP717_BATT_UNDER_TEMP);
 			return 0;
 
 		default:
-- 
2.39.5



