Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC25614012;
	Mon, 24 Feb 2025 14:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408526; cv=none; b=R7vAKN+vqk28PPIo8SHmq20lj5IlhB3G7XuTi9RmKZ0J8YWCTWWkiiM0I0dpRtVdDhJgJMieL6AyuxtTm+JFRCx1n96NYGGYZhkFZFKA2gxdt4VkFJ+sGc4KEZQTmz+SJ0h+kphHqqrIOg9lG8i58kd8OU0qUwFQ3B6AHr+xn1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408526; c=relaxed/simple;
	bh=eCI8lSAWwjb+rFDzsjq+ED/mH/KHtHRhWfMDk0lLuDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGmt4/DoAVYviSQwDnzP4wszYUFtVvJC4lfdQfrbhAbAZWt3d87k8ELXbvVMRNF1jMG1iwkOHwKlIrkeZgs/Cwv9Cp55HbkoxP052iSF5LMXB99VMWDwt/q+aeTi3/XCPrOEQW8zLcxEUFAxyX2EdnVHKXptf17bGcClxh1HAL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n6TXvU7z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n6TXvU7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57188C4CED6;
	Mon, 24 Feb 2025 14:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408525;
	bh=eCI8lSAWwjb+rFDzsjq+ED/mH/KHtHRhWfMDk0lLuDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n6TXvU7zuRLcXQKjJp4F4y+GxUCGkRGxkjuql2fLlUWfCS5dMy31MR63Zvg5J6cuG
	 W2r3Z8L9YoN1jGV2w57EqL/g/TKRZeCbCeHv6gH2gDoJSmUBLMCayQZ68k0qZf0jFA
	 qj5c0vmxfiFRDqrMpah7L1r9MofWrqaGkFiR0MFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/154] power: supply: axp20x_battery: Fix fault handling for AXP717
Date: Mon, 24 Feb 2025 15:34:42 +0100
Message-ID: <20250224142610.327708763@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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
index f71cc90fea127..57eba1ddb17ba 100644
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



