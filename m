Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2170424649;
	Fri,  4 Sep 2026 06:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502649; cv=none; b=ccDdnJG84wELHtV0KyZFz+DNqazMQk3fsEv5AqBGJkQm21z4t8nYzg+g8aw5xCRtLELykaM+DPyQH52ftIi8QyUyN709ook9w1sju/gtYcwxR72JWkDKujxrwW7rUV8xc+HT8sWw49nU/cJ0+6+kiSR6Xaqbbe+f3X/Fm/O4yEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502649; c=relaxed/simple;
	bh=BLOB2X0HRu+g1pu1nkfLm23sorQPPteYioqYw3b52gE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nVv+beU2aD5pA8kbfxwnZ+oVRaRVw9lSaCaWXNFt0z5aVSyJGfGQm/Aiipysb+l/0nMjQRFw9BN6+otLAPudgb2MHsZWDDU8dDOdsao0yJhlnOiSXitlsHQvcJTqMQlmuFKDVOwOMN0qrYOLRMK1SssoLEKlgjU1o3ja97UaDL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ybrFT77M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ybrFT77M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1639C1F00A3D;
	Fri,  4 Sep 2026 06:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502647;
	bh=oMCWSImzIVtmFWOJPF375nkqinvGMOO+Y3kq3Wsotzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ybrFT77MHcNgabnLJ3YyL5YT1AYCA3NwJbqDGC8tQv7JyZrneaYBHikcHjzWafW01
	 nzG7Q1v5ckVE6r8lpw017jgNS83jp1Z7Ww+dHSefRUsWEORjXcRfgK8CTHlDjCiH5l
	 8buLnQ2J3e6Op2+V7k+TGxcwZEm8PPmUBCoYQ++8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianing Li <m13940358460@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.12 282/403] power: supply: max17040: propagate register read errors
Date: Fri,  4 Sep 2026 07:01:25 +0200
Message-ID: <20260904045741.270005543@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Jianing Li <m13940358460@163.com>

commit 659cc3d8d5ef246263873fce72c8cadeeed073cc upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/max17040_battery.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

--- a/drivers/power/supply/max17040_battery.c
+++ b/drivers/power/supply/max17040_battery.c
@@ -192,8 +192,11 @@ static int max17040_raw_vcell_to_uvolts(
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
@@ -201,8 +204,11 @@ static int max17040_get_vcell(struct max
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
@@ -261,7 +267,11 @@ static int max17040_get_of_data(struct m
 
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
@@ -396,10 +406,16 @@ static int max17040_get_property(struct
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


