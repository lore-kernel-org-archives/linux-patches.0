Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2176F13AA2F;
	Tue, 12 Aug 2025 18:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024259; cv=none; b=mDTDWPyHJPJcZTCF6qqVTzcRUNSGgSCxpuN6DHCbEZpSmi7KokM8IXmwCMfpFqZk6eBf1gBPt8QeKpWvbpm0zKAqUM0j1jo1/SlVwtOLc4VMIDbIGl3AjIwtfAI9ySWdmdxLmCBS1nqARgpFaGp5qIaf9r1IbD9sjsAN2J5S+b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024259; c=relaxed/simple;
	bh=pAauepJRloQDRfFh4QTR2XirpFDONKN290OpfclVB9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WxMhs5WKXdhvn6meEcnJCqh0lH28Rx/0a5QSxQIQB7VldyzyKce+pbD6IALOycgxxyjhCJApcFtEaDkFmDheABXHe+MwF/ihUBAHeQgfYINp2i7QDz4TdC6zYZZf28YuE0sPMv0+X82pgce+LfF56coacB9FcryGghPPYpqh6Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zp90NixY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zp90NixY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DE4C4CEF0;
	Tue, 12 Aug 2025 18:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024259;
	bh=pAauepJRloQDRfFh4QTR2XirpFDONKN290OpfclVB9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zp90NixYL3IV0g7m2wDRI9sAL/jT2yWh2z8iFzCgwp1xbe3+/agfLIhYcKUhE5TbR
	 aJbP0ZCK5A9AFqkPv+J6hk8iOT5QEl5iSJN0hRI9CBvK8u6h1qu0C1uAqHXi5hgmga
	 VSUSF7UnA6oyM29ODvhI6W2dIvaoWFLE4vpF2iLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Antoine <t.antoine@uclouvain.be>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 321/627] power: supply: max1720x correct capacity computation
Date: Tue, 12 Aug 2025 19:30:16 +0200
Message-ID: <20250812173431.509538459@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



