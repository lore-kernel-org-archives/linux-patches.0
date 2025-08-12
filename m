Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD464188715;
	Tue, 12 Aug 2025 19:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026114; cv=none; b=fM4BAEFX1C3aHVkgCMfvAbeoqfpO/spb38xYRuGxe4cK0JWtBKKaANqEaRCptjUqVD3butEl8xszEJDzcw7exaZK56BFTcNzTzPuWvG244B/UKrZelSbkkPdHt62TJOgbRx9RPCDPWUCqMLNYSSq0ONy1AU0FzSh9xIOaMvO6nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026114; c=relaxed/simple;
	bh=wTezWlRpxhn7RYrik/XGPJQ+A8DU2lWhBNoNRrMhU8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UTeHlkYg3oH2c91gIpLYdEkUVCJ6noupZMOaB0lO9IikYjjixlQvZwPGIWBLPqBesK6FkLWdqo6z6AtniRAhfsf1nzs0rMRbusOR/qE88XLT5EpOpNScFaNPkIyUetI20yEcKLnAyZ8wpJVTvN6HL65+IV45bp67SVMh2lyES2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BkwaGGbP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BkwaGGbP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1008AC4CEF0;
	Tue, 12 Aug 2025 19:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026114;
	bh=wTezWlRpxhn7RYrik/XGPJQ+A8DU2lWhBNoNRrMhU8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BkwaGGbPrhBL/Y7Bccz7+u68A9/sx88I4I4fhk0t2p0t6SIkHzSjSjInF2jWPf9k4
	 ljcmWQZqG0sKQwiqXLXKE3ZEXpGzJiLgt/tT1xxrIN2vyLwjPSBMkDi62j9inJpnBS
	 CbD++aFAYnNtatw6vSSyLQZ3T4xOWw9KD6+6rJF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Antoine <t.antoine@uclouvain.be>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 240/480] power: supply: max1720x correct capacity computation
Date: Tue, 12 Aug 2025 19:47:28 +0200
Message-ID: <20250812174407.352955015@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Antoine <t.antoine@uclouvain.be>

[ Upstream commit 58ae036172b5f051a19a32eba94a3e5eb37bf47e ]

>From the datasheet of the MAX17201/17205, the LSB should be "5.0μVh/RSENSE".
The current computation sets it at 0.5mAh=5.0μVh/10mOhm, which does not take
into account the value of rsense (which is in 10µV steps) which can be
different from 10mOhm.

Change the computation to fit the specs.

Fixes: 479b6d04964b ("power: supply: add support for MAX1720x standalone fuel gauge")
Signed-off-by: Thomas Antoine <t.antoine@uclouvain.be>
Link: https://lore.kernel.org/r/20250523-b4-gs101_max77759_fg-v4-1-b49904e35a34@uclouvain.be
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/max1720x_battery.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/power/supply/max1720x_battery.c b/drivers/power/supply/max1720x_battery.c
index ea3912fd1de8..68b5314ecf3a 100644
--- a/drivers/power/supply/max1720x_battery.c
+++ b/drivers/power/supply/max1720x_battery.c
@@ -288,9 +288,10 @@ static int max172xx_voltage_to_ps(unsigned int reg)
 	return reg * 1250;	/* in uV */
 }
 
-static int max172xx_capacity_to_ps(unsigned int reg)
+static int max172xx_capacity_to_ps(unsigned int reg,
+				   struct max1720x_device_info *info)
 {
-	return reg * 500;	/* in uAh */
+	return reg * (500000 / info->rsense);	/* in uAh */
 }
 
 /*
@@ -394,11 +395,11 @@ static int max1720x_battery_get_property(struct power_supply *psy,
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
 		ret = regmap_read(info->regmap, MAX172XX_DESIGN_CAP, &reg_val);
-		val->intval = max172xx_capacity_to_ps(reg_val);
+		val->intval = max172xx_capacity_to_ps(reg_val, info);
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_AVG:
 		ret = regmap_read(info->regmap, MAX172XX_REPCAP, &reg_val);
-		val->intval = max172xx_capacity_to_ps(reg_val);
+		val->intval = max172xx_capacity_to_ps(reg_val, info);
 		break;
 	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG:
 		ret = regmap_read(info->regmap, MAX172XX_TTE, &reg_val);
@@ -422,7 +423,7 @@ static int max1720x_battery_get_property(struct power_supply *psy,
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_FULL:
 		ret = regmap_read(info->regmap, MAX172XX_FULL_CAP, &reg_val);
-		val->intval = max172xx_capacity_to_ps(reg_val);
+		val->intval = max172xx_capacity_to_ps(reg_val, info);
 		break;
 	case POWER_SUPPLY_PROP_MODEL_NAME:
 		ret = regmap_read(info->regmap, MAX172XX_DEV_NAME, &reg_val);
-- 
2.39.5



