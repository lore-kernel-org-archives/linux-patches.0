Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE722CA6F;
	Sat, 12 Sep 2026 11:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211415; cv=none; b=VO7Rp8PRf6R0sccCAg941PgzuZOfm5w/45/w0IF/SvcS4iYgBHanGIWSGAH1BY+aSOPV51txQ+TrUPBlT/HY1J6EJxYZGSY06rhYxlDOfF9smt8kMCpVLLS17Np2nVmX5yqd8y6YqnEuwSWrjz/7dl+5TrmpQVJ2HS0amES1l98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211415; c=relaxed/simple;
	bh=CM1qizAf8ZGrtc49VA2+tMZuLHGYASlE+R7QQzvTGHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDt58Q9eBV0oV5x9r1PYrDDBTMn0oCnLYCYAn166LRlMzjC7ELDiO0LfQCGI0oSOuS7lsOc+pAc53b6Jk9go+6Niy2dvOGPI666fUcvRTLIGEZczhTyXVsYZTQiBVYKr85cUe4KXn1TLcIJZ8Nj/kXT2wAgTdkCU1OGUT7F1ajU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Slbvfa+b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Slbvfa+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B353D1F000FF;
	Sat, 12 Sep 2026 11:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211413;
	bh=3AFzM/hygfZ4Mbvq1RWcswstUx+NTm8Mcss9g5+FDtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Slbvfa+bYECiOGrtKBnASzJdIZnchpCrqPlFTOL9ePLQZUCcCr0EDW8eio4alUqSx
	 C1OrPKxxw9qJ1OYAj2dC3U+Tt4od8AOPqqObUirRuzV7BMUKAhKV+HCiXMLq3oKBNL
	 Dz+pCFxrpUJ+EYEmjyH5t9J52L9qDFfXhq64kajQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marius Cristea <marius.cristea@microchip.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1225/1518] hwmon: (emc1403) Drop hysteresis for low limit temperature
Date: Sat, 12 Sep 2026 08:56:34 +0200
Message-ID: <20260912065651.215145887@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marius Cristea <marius.cristea@microchip.com>

[ Upstream commit 75f2c0b3690702c90863c2e138cb5520670845ea ]

Remove the hysteresis for low temperature limit, in hardware
the hysteresis is applied only to the maxim limit and the
critical limit temperature.

Fixes: 54392ce4446e3 ("hwmon: (emc1403) Add support for min_hyst attributes")
Signed-off-by: Marius Cristea <marius.cristea@microchip.com>
Link: https://lore.kernel.org/r/20260813-emc1403_remove_min_hyst-v1-1-43a0d05d9f49@microchip.com
[groeck: Updated subject]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/emc1403.rst |  8 ++++----
 drivers/hwmon/emc1403.c         | 27 +++++++++++----------------
 2 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/Documentation/hwmon/emc1403.rst b/Documentation/hwmon/emc1403.rst
index 57f833b1a800e..ebf2435a76a62 100644
--- a/Documentation/hwmon/emc1403.rst
+++ b/Documentation/hwmon/emc1403.rst
@@ -71,10 +71,10 @@ and EMC14x8 support eight sensors (one internal, seven external).
 
 The chips implement three limits for each sensor: low (tempX_min), high
 (tempX_max) and critical (tempX_crit.) The chips also implement an
-hysteresis mechanism which applies to all limits. The relative difference
-is stored in a single register on the chip, which means that the relative
-difference between the limit and its hysteresis is always the same for
-all three limits.
+hysteresis mechanism which applies to high and critical limits. The relative
+difference is stored in a single register on the chip, which means that the
+relative difference between the limit and its hysteresis is always the same
+for high and critical limits.
 
 This implementation detail implies the following:
 
diff --git a/drivers/hwmon/emc1403.c b/drivers/hwmon/emc1403.c
index ccce948a4306e..39f69adb88c25 100644
--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -305,10 +305,9 @@ static int emc1403_get_hyst(struct thermal_data *data, int channel,
 	ret = regmap_read(data->regmap, 0x21, &hyst);
 	if (ret < 0)
 		return ret;
-	if (map == temp_min)
-		*val = limit + hyst * 1000;
-	else
-		*val = limit - hyst * 1000;
+
+	*val = limit - hyst * 1000;
+
 	return 0;
 }
 
@@ -324,9 +323,6 @@ static int emc1403_temp_read(struct thermal_data *data, u32 attr, int channel, l
 	case hwmon_temp_input:
 		ret = emc1403_get_temp(data, channel, ema1403_temp_map[attr], val);
 		break;
-	case hwmon_temp_min_hyst:
-		ret = emc1403_get_hyst(data, channel, temp_min, val);
-		break;
 	case hwmon_temp_max_hyst:
 		ret = emc1403_get_hyst(data, channel, temp_max, val);
 		break;
@@ -548,7 +544,6 @@ static umode_t emc1403_temp_is_visible(const void *_data, u32 attr, int channel)
 	case hwmon_temp_max_alarm:
 	case hwmon_temp_crit_alarm:
 	case hwmon_temp_fault:
-	case hwmon_temp_min_hyst:
 	case hwmon_temp_max_hyst:
 		return 0444;
 	case hwmon_temp_min:
@@ -591,35 +586,35 @@ static const struct hwmon_channel_info * const emc1403_info[] = {
 	HWMON_CHANNEL_INFO(chip, HWMON_C_UPDATE_INTERVAL),
 	HWMON_CHANNEL_INFO(temp,
 			   HWMON_T_INPUT | HWMON_T_MIN | HWMON_T_MAX |
-			   HWMON_T_CRIT | HWMON_T_MIN_HYST | HWMON_T_MAX_HYST |
+			   HWMON_T_CRIT | HWMON_T_MAX_HYST |
 			   HWMON_T_CRIT_HYST | HWMON_T_MIN_ALARM |
 			   HWMON_T_MAX_ALARM | HWMON_T_CRIT_ALARM,
 			   HWMON_T_INPUT | HWMON_T_MIN | HWMON_T_MAX |
-			   HWMON_T_CRIT | HWMON_T_MIN_HYST | HWMON_T_MAX_HYST |
+			   HWMON_T_CRIT | HWMON_T_MAX_HYST |
 			   HWMON_T_CRIT_HYST | HWMON_T_MIN_ALARM |
 			   HWMON_T_MAX_ALARM | HWMON_T_CRIT_ALARM | HWMON_T_FAULT,
 			   HWMON_T_INPUT | HWMON_T_MIN | HWMON_T_MAX |
-			   HWMON_T_CRIT | HWMON_T_MIN_HYST | HWMON_T_MAX_HYST |
+			   HWMON_T_CRIT | HWMON_T_MAX_HYST |
 			   HWMON_T_CRIT_HYST | HWMON_T_MIN_ALARM |
 			   HWMON_T_MAX_ALARM | HWMON_T_CRIT_ALARM | HWMON_T_FAULT,
 			   HWMON_T_INPUT | HWMON_T_MIN | HWMON_T_MAX |
-			   HWMON_T_CRIT | HWMON_T_MIN_HYST | HWMON_T_MAX_HYST |
+			   HWMON_T_CRIT | HWMON_T_MAX_HYST |
 			   HWMON_T_CRIT_HYST | HWMON_T_MIN_ALARM |
 			   HWMON_T_MAX_ALARM | HWMON_T_CRIT_ALARM | HWMON_T_FAULT,
 			   HWMON_T_INPUT | HWMON_T_MIN | HWMON_T_MAX |
-			   HWMON_T_CRIT | HWMON_T_MIN_HYST | HWMON_T_MAX_HYST |
+			   HWMON_T_CRIT | HWMON_T_MAX_HYST |
 			   HWMON_T_CRIT_HYST | HWMON_T_MIN_ALARM |
 			   HWMON_T_MAX_ALARM | HWMON_T_CRIT_ALARM | HWMON_T_FAULT,
 			   HWMON_T_INPUT | HWMON_T_MIN | HWMON_T_MAX |
-			   HWMON_T_CRIT | HWMON_T_MIN_HYST | HWMON_T_MAX_HYST |
+			   HWMON_T_CRIT | HWMON_T_MAX_HYST |
 			   HWMON_T_CRIT_HYST | HWMON_T_MIN_ALARM |
 			   HWMON_T_MAX_ALARM | HWMON_T_CRIT_ALARM | HWMON_T_FAULT,
 			   HWMON_T_INPUT | HWMON_T_MIN | HWMON_T_MAX |
-			   HWMON_T_CRIT | HWMON_T_MIN_HYST | HWMON_T_MAX_HYST |
+			   HWMON_T_CRIT | HWMON_T_MAX_HYST |
 			   HWMON_T_CRIT_HYST | HWMON_T_MIN_ALARM |
 			   HWMON_T_MAX_ALARM | HWMON_T_CRIT_ALARM | HWMON_T_FAULT,
 			   HWMON_T_INPUT | HWMON_T_MIN | HWMON_T_MAX |
-			   HWMON_T_CRIT | HWMON_T_MIN_HYST | HWMON_T_MAX_HYST |
+			   HWMON_T_CRIT | HWMON_T_MAX_HYST |
 			   HWMON_T_CRIT_HYST | HWMON_T_MIN_ALARM |
 			   HWMON_T_MAX_ALARM | HWMON_T_CRIT_ALARM | HWMON_T_FAULT
 			   ),
-- 
2.53.0



