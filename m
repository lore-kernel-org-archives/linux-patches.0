Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268B93B2FCA;
	Sat, 17 Oct 2026 17:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259614; cv=none; b=jDEgiiFhQzEKUaxKGMy8zO/FIwoCsUD1Tg/V1DfDAYMlKBRKhYCHF4mzEq8dqoqGfoFyWeKuT6ARSB398iFXY7osmWHvjv7JGTmIjaC8o+H+PC529Z8bV6kGT6jjS/a+Iul4+mT4oya4Z78uQgbDRnhzF7pHJ9kvOGvgWOus2Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259614; c=relaxed/simple;
	bh=u8BumOEQ9Zh6IjFCewjYHfRAxqT1ejBUaso0LRMNETM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dkvOMWRXrN3/Xln0xkYCKMlkohXMHSKVB6ddFhJEPZUnrpySqddx8KEJQ2BrU2AQ1QguFW7c1LXXz4uF8qGyEyYuJKyXm4UX+AyGTL+Ss7QP+m/0PF3WjP1FX7fjT+vmwp1Flo+SZJw1gvEU9wX8eJvHSRYs+4CnRNqLl2xiyDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=svLz2bLq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="svLz2bLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8311F000C4;
	Sat, 17 Oct 2026 17:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259613;
	bh=4s16Xj7qRyFyEA3voID/ovRqTg6vn3ZYsNNU6iINpgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=svLz2bLqXdlexZZKt9PgEIdmIzukzh9m9QYvS+f1OwyyLinJDGnBBvgUs0SuHdTok
	 B+8tVEHCUn4yApDQe7AGgDmnMGQxjl1QX5Na9PJ11O0UZQItm4rLXYBYbGsRxZ2G1P
	 1ZOoU31mgNiY7OWBajEHfy0RQNqbn9QXbAUWEOnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianing Li <m13940358460@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1271/1674] power: supply: max17040: propagate register read errors
Date: Sat, 17 Oct 2026 17:59:03 +0200
Message-ID: <20261017160503.765866462@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianing Li <m13940358460@163.com>

[ Upstream commit 659cc3d8d5ef246263873fce72c8cadeeed073cc ]

max17040_get_vcell() and max17040_get_soc() ignore errors returned by
regmap_read().  When an I2C transfer fails, the uninitialized register
value is converted and reported to userspace as a valid voltage or state
of charge.  The polling worker can also replace the cached state of charge
with the bogus value and emit a spurious change event.

Propagate read errors through the power supply get_property callback and
keep the last valid cached state of charge when polling fails.

Fixes: c6f4a42de60b ("Add MAX17040 Fuel Gauge driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jianing Li <m13940358460@163.com>
Link: https://patch.msgid.link/20260727064825.948-1-m13940358460@163.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/max17040_battery.c | 27 ++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/power/supply/max17040_battery.c b/drivers/power/supply/max17040_battery.c
index 2814327c8e7d3..3fe8f499f29aa 100644
--- a/drivers/power/supply/max17040_battery.c
+++ b/drivers/power/supply/max17040_battery.c
@@ -190,8 +190,11 @@ static int max17040_raw_vcell_to_uvolts(struct max17040_chip *chip, u16 vcell)
 static int max17040_get_vcell(struct max17040_chip *chip)
 {
 	u32 vcell;
+	int ret;
 
-	regmap_read(chip->regmap, MAX17040_VCELL, &vcell);
+	ret = regmap_read(chip->regmap, MAX17040_VCELL, &vcell);
+	if (ret)
+		return ret;
 
 	return max17040_raw_vcell_to_uvolts(chip, vcell);
 }
@@ -199,8 +202,11 @@ static int max17040_get_vcell(struct max17040_chip *chip)
 static int max17040_get_soc(struct max17040_chip *chip)
 {
 	u32 soc;
+	int ret;
 
-	regmap_read(chip->regmap, MAX17040_SOC, &soc);
+	ret = regmap_read(chip->regmap, MAX17040_SOC, &soc);
+	if (ret)
+		return ret;
 
 	return soc >> (chip->quirk_double_soc ? 9 : 8);
 }
@@ -259,7 +265,11 @@ static int max17040_get_of_data(struct max17040_chip *chip)
 
 static void max17040_check_changes(struct max17040_chip *chip)
 {
-	chip->soc = max17040_get_soc(chip);
+	int soc;
+
+	soc = max17040_get_soc(chip);
+	if (soc >= 0)
+		chip->soc = soc;
 }
 
 static void max17040_queue_work(struct max17040_chip *chip)
@@ -386,16 +396,23 @@ static int max17040_get_property(struct power_supply *psy,
 			    union power_supply_propval *val)
 {
 	struct max17040_chip *chip = power_supply_get_drvdata(psy);
+	int ret;
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_ONLINE:
 		val->intval = max17040_get_online(chip);
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-		val->intval = max17040_get_vcell(chip);
+		ret = max17040_get_vcell(chip);
+		if (ret < 0)
+			return ret;
+		val->intval = ret;
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
-		val->intval = max17040_get_soc(chip);
+		ret = max17040_get_soc(chip);
+		if (ret < 0)
+			return ret;
+		val->intval = ret;
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY_ALERT_MIN:
 		val->intval = chip->low_soc_alert;
-- 
2.53.0



