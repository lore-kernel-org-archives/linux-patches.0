Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6141E0084;
	Wed,  6 Nov 2024 12:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897924; cv=none; b=rwdPzy4uSsu4S7enskr0kNbGwOKuu7cakzlqgVM+9bUTKfQra2CuZXyGmQZR/u9Fr1NhcJ2QzlbscSN3hSHf0Nk9tkzeTEbdoG5EaAn6qsl45vlSBC55VCgkiT27cWkjdBUrKn+xDserKyy+xfkPTCSf4Ghw17/RvzIKEDqQUQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897924; c=relaxed/simple;
	bh=QkcGbfjIp0y+YhooyYkdtqfV3ganablzRUWNx1vRMMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0x60x5HHoZSfL9z+hWT6MB6KRKmCf5/2f9NE6ou6JUD0h7CX5rCpL7CTFWUuJHSyIQAKreK5KdvLomh8I5WXcsWeHz0SX0/QnZhOHxIcJazy6F7pcOu5DAbkCcn/u1fKMseOSTHFgqTCRYpnfe9/nkfPRApO2E1SDXRh0MLSE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OYznvUI5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OYznvUI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CF0C4CECD;
	Wed,  6 Nov 2024 12:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897924;
	bh=QkcGbfjIp0y+YhooyYkdtqfV3ganablzRUWNx1vRMMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OYznvUI583RxaoRDpD7V0rn2bAN8lO8HJ2Ya1edM5WKVHepnDje5qDu6lFNcQ7fp1
	 wS0JkbLaWzyHqxYfeg2j265cG7tm0wLm7aacZh6bHN+498JvAyjCcSPnUM6JstKcbt
	 m9ea2gcH9fN7NabYF5D0BEZ7mgYQhrRDtdhLU9Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hermann.Lauer@uni-heidelberg.de,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 064/462] power: supply: axp20x_battery: allow disabling battery charging
Date: Wed,  6 Nov 2024 12:59:17 +0100
Message-ID: <20241106120333.094321891@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hermann Lauer <Hermann.Lauer@iwr.uni-heidelberg.de>

[ Upstream commit 6a0fcc87c9e35191d37a8819fdab9d30e523515b ]

Allow disabling and re-enabling battery charging of an axp209 PMIC
through a writable status property. With the current driver code
charging is always on.

This works on the axp209 of Banana {Pi M1+,Pro} and should work on all
AXP chips.

Signed-off-by: Hermann.Lauer@uni-heidelberg.de
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: 61978807b00f ("power: supply: axp20x_battery: Remove design from min and max voltage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/axp20x_battery.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/axp20x_battery.c b/drivers/power/supply/axp20x_battery.c
index 9fda98b950bab..335e12cc5e2f9 100644
--- a/drivers/power/supply/axp20x_battery.c
+++ b/drivers/power/supply/axp20x_battery.c
@@ -40,6 +40,7 @@
 #define AXP209_FG_PERCENT		GENMASK(6, 0)
 #define AXP22X_FG_VALID			BIT(7)
 
+#define AXP20X_CHRG_CTRL1_ENABLE	BIT(7)
 #define AXP20X_CHRG_CTRL1_TGT_VOLT	GENMASK(6, 5)
 #define AXP20X_CHRG_CTRL1_TGT_4_1V	(0 << 5)
 #define AXP20X_CHRG_CTRL1_TGT_4_15V	(1 << 5)
@@ -467,7 +468,18 @@ static int axp20x_battery_set_prop(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT_MAX:
 		return axp20x_set_max_constant_charge_current(axp20x_batt,
 							      val->intval);
-
+	case POWER_SUPPLY_PROP_STATUS:
+		switch (val->intval) {
+		case POWER_SUPPLY_STATUS_CHARGING:
+			return regmap_update_bits(axp20x_batt->regmap, AXP20X_CHRG_CTRL1,
+				AXP20X_CHRG_CTRL1_ENABLE, AXP20X_CHRG_CTRL1_ENABLE);
+
+		case POWER_SUPPLY_STATUS_DISCHARGING:
+		case POWER_SUPPLY_STATUS_NOT_CHARGING:
+			return regmap_update_bits(axp20x_batt->regmap, AXP20X_CHRG_CTRL1,
+				AXP20X_CHRG_CTRL1_ENABLE, 0);
+		}
+		fallthrough;
 	default:
 		return -EINVAL;
 	}
@@ -490,7 +502,8 @@ static enum power_supply_property axp20x_battery_props[] = {
 static int axp20x_battery_prop_writeable(struct power_supply *psy,
 					 enum power_supply_property psp)
 {
-	return psp == POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN ||
+	return psp == POWER_SUPPLY_PROP_STATUS ||
+	       psp == POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN ||
 	       psp == POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN ||
 	       psp == POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT ||
 	       psp == POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT_MAX;
-- 
2.43.0



