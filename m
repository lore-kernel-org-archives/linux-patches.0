Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EF91C07C2;
	Tue, 15 Oct 2024 12:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997176; cv=none; b=rDkTrxbavV0AVjk/KWmjNRWY0VKQ+wBUA8hceLiVdkQqTxe4vcZC3c3DSa323tbIm4jaPBJWRF2i2YGkEcMeMM0qnTl3nIsW5BKIjzDfZytli4NHB3KLqhjW7UTeB5cXmC6cijcTHiZ5ume87EYJhgOSL5brkcaibU/poaG3o2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997176; c=relaxed/simple;
	bh=NmZ1tICs++Hz6S33NcsAeBjTo3Ty4tEXGAaKLDMwSgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uhF/nwPqGUMWeBY3mcNCXr5bjSZygO9g+9BW1SkjI20MF9ix1b0Sskq/zytJcKgDNPZyebSJeSHc6dghMSO0LMwR4y7BOMzJKziaLVxzL2BOv3jl5vSyo0GUhevgK8TVvDgiQz5ZnW0WdrjzKs/6KiIpX+kuh31Hz5B4U8jvZHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MzO9ZCJE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MzO9ZCJE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398C2C4CEC6;
	Tue, 15 Oct 2024 12:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997176;
	bh=NmZ1tICs++Hz6S33NcsAeBjTo3Ty4tEXGAaKLDMwSgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MzO9ZCJEGvNKyyuURcc4HQEn1ty2ae39mZFKVn0VGfazFthVothuyUP3lcvJasYcP
	 MTmyz2QdMwYctgezk374cwaPjwT+FYNbIGcnbshb4EeihO5J/anfC5txl6lYlXddri
	 cJlxpilyxW6GQG95A4NJOOGOP9VG7q4MoazpnLw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hermann.Lauer@uni-heidelberg.de,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/518] power: supply: axp20x_battery: allow disabling battery charging
Date: Tue, 15 Oct 2024 14:40:13 +0200
Message-ID: <20241015123921.207201168@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



