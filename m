Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1F43D3326;
	Wed, 30 Sep 2026 19:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795880; cv=none; b=EGl3Qdh9ofmKlT1R9fjaGQjodwC0yt5OJyMdUCIjfYq6syuKDeESk/mAzbSLyGwPXIvyY+CTnao7sDnoyJCADHK6WNH+lKXKgSzqdgAc5mfnM9UnnuCdq1l8yQnDxUBaGt8KYlDp0b+J7d8TcpykNk/nJqzDylBC8CDVR5G6VK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795880; c=relaxed/simple;
	bh=vZY7nYF846PObgDXRGHmjWAP8XtoVsj5DkP6f3wgWA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHRHU/VrODeGxIl5nTLG5lyI2+jy8Gx/8S5N6eQUy2YfJYU/HfdtCyqcMn0I99PM3j65PCMnNZQ/ybkSUMc2EkQ65S8aC3WgqygS2b1vODuM6+mtbcyLnql4BSoPTSkW94yo7agJ2IPJXw2HPdMrrOyGy1/dfLK0xzrTNfLdtV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkNaD+f2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkNaD+f2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E48B1F000FF;
	Wed, 30 Sep 2026 19:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795878;
	bh=LtYOB/9kFr7kitviBz7osPclohv5tcD73k6KsRGPmEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dkNaD+f2RMvXihNfRiJXYcU263j/f/KL3mpoNtNnaTU/KrCeeD3aLuMysq3VKYPeH
	 x9YptjQrZhvoGckDAZvcmGgqRT6JZ4KGk6yVmPM7Dn5PhA4Znu2ZR8S+JJkbeW9VTS
	 mYmbQ8GJEHmG9kV5N+YMC2VafCx4MbfvYJTL8XlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0709/1193] Revert "hwmon: (emc1403) Drop hysteresis for low limit temperature"
Date: Wed, 30 Sep 2026 17:23:13 +0200
Message-ID: <20260930152450.002565969@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

This reverts commit 9281eb1e4ea31281c0230a5c74aacfc014241d10.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/emc1403.rst |  8 ++++----
 drivers/hwmon/emc1403.c         | 27 ++++++++++++++++-----------
 2 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/Documentation/hwmon/emc1403.rst b/Documentation/hwmon/emc1403.rst
index ebf2435a76a62..57f833b1a800e 100644
--- a/Documentation/hwmon/emc1403.rst
+++ b/Documentation/hwmon/emc1403.rst
@@ -71,10 +71,10 @@ and EMC14x8 support eight sensors (one internal, seven external).
 
 The chips implement three limits for each sensor: low (tempX_min), high
 (tempX_max) and critical (tempX_crit.) The chips also implement an
-hysteresis mechanism which applies to high and critical limits. The relative
-difference is stored in a single register on the chip, which means that the
-relative difference between the limit and its hysteresis is always the same
-for high and critical limits.
+hysteresis mechanism which applies to all limits. The relative difference
+is stored in a single register on the chip, which means that the relative
+difference between the limit and its hysteresis is always the same for
+all three limits.
 
 This implementation detail implies the following:
 
diff --git a/drivers/hwmon/emc1403.c b/drivers/hwmon/emc1403.c
index 288d540ebabf2..ad4fc64824bc4 100644
--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -304,9 +304,10 @@ static int emc1403_get_hyst(struct thermal_data *data, int channel,
 	ret = regmap_read(data->regmap, 0x21, &hyst);
 	if (ret < 0)
 		return ret;
-
-	*val = limit - hyst * 1000;
-
+	if (map == temp_min)
+		*val = limit + hyst * 1000;
+	else
+		*val = limit - hyst * 1000;
 	return 0;
 }
 
@@ -322,6 +323,9 @@ static int emc1403_temp_read(struct thermal_data *data, u32 attr, int channel, l
 	case hwmon_temp_input:
 		ret = emc1403_get_temp(data, channel, ema1403_temp_map[attr], val);
 		break;
+	case hwmon_temp_min_hyst:
+		ret = emc1403_get_hyst(data, channel, temp_min, val);
+		break;
 	case hwmon_temp_max_hyst:
 		ret = emc1403_get_hyst(data, channel, temp_max, val);
 		break;
@@ -490,6 +494,7 @@ static umode_t emc1403_temp_is_visible(const void *_data, u32 attr, int channel)
 	case hwmon_temp_max_alarm:
 	case hwmon_temp_crit_alarm:
 	case hwmon_temp_fault:
+	case hwmon_temp_min_hyst:
 	case hwmon_temp_max_hyst:
 		return 0444;
 	case hwmon_temp_min:
@@ -519,35 +524,35 @@ static umode_t emc1403_is_visible(const void *data, enum hwmon_sensor_types type
 static const struct hwmon_channel_info * const emc1403_info[] = {
 	HWMON_CHANNEL_INFO(temp,
 			   HWMON_T_INPUT | HWMON_T_MIN | HWMON_T_MAX |
-			   HWMON_T_CRIT | HWMON_T_MAX_HYST |
+			   HWMON_T_CRIT | HWMON_T_MIN_HYST | HWMON_T_MAX_HYST |
 			   HWMON_T_CRIT_HYST | HWMON_T_MIN_ALARM |
 			   HWMON_T_MAX_ALARM | HWMON_T_CRIT_ALARM,
 			   HWMON_T_INPUT | HWMON_T_MIN | HWMON_T_MAX |
-			   HWMON_T_CRIT | HWMON_T_MAX_HYST |
+			   HWMON_T_CRIT | HWMON_T_MIN_HYST | HWMON_T_MAX_HYST |
 			   HWMON_T_CRIT_HYST | HWMON_T_MIN_ALARM |
 			   HWMON_T_MAX_ALARM | HWMON_T_CRIT_ALARM | HWMON_T_FAULT,
 			   HWMON_T_INPUT | HWMON_T_MIN | HWMON_T_MAX |
-			   HWMON_T_CRIT | HWMON_T_MAX_HYST |
+			   HWMON_T_CRIT | HWMON_T_MIN_HYST | HWMON_T_MAX_HYST |
 			   HWMON_T_CRIT_HYST | HWMON_T_MIN_ALARM |
 			   HWMON_T_MAX_ALARM | HWMON_T_CRIT_ALARM | HWMON_T_FAULT,
 			   HWMON_T_INPUT | HWMON_T_MIN | HWMON_T_MAX |
-			   HWMON_T_CRIT | HWMON_T_MAX_HYST |
+			   HWMON_T_CRIT | HWMON_T_MIN_HYST | HWMON_T_MAX_HYST |
 			   HWMON_T_CRIT_HYST | HWMON_T_MIN_ALARM |
 			   HWMON_T_MAX_ALARM | HWMON_T_CRIT_ALARM | HWMON_T_FAULT,
 			   HWMON_T_INPUT | HWMON_T_MIN | HWMON_T_MAX |
-			   HWMON_T_CRIT | HWMON_T_MAX_HYST |
+			   HWMON_T_CRIT | HWMON_T_MIN_HYST | HWMON_T_MAX_HYST |
 			   HWMON_T_CRIT_HYST | HWMON_T_MIN_ALARM |
 			   HWMON_T_MAX_ALARM | HWMON_T_CRIT_ALARM | HWMON_T_FAULT,
 			   HWMON_T_INPUT | HWMON_T_MIN | HWMON_T_MAX |
-			   HWMON_T_CRIT | HWMON_T_MAX_HYST |
+			   HWMON_T_CRIT | HWMON_T_MIN_HYST | HWMON_T_MAX_HYST |
 			   HWMON_T_CRIT_HYST | HWMON_T_MIN_ALARM |
 			   HWMON_T_MAX_ALARM | HWMON_T_CRIT_ALARM | HWMON_T_FAULT,
 			   HWMON_T_INPUT | HWMON_T_MIN | HWMON_T_MAX |
-			   HWMON_T_CRIT | HWMON_T_MAX_HYST |
+			   HWMON_T_CRIT | HWMON_T_MIN_HYST | HWMON_T_MAX_HYST |
 			   HWMON_T_CRIT_HYST | HWMON_T_MIN_ALARM |
 			   HWMON_T_MAX_ALARM | HWMON_T_CRIT_ALARM | HWMON_T_FAULT,
 			   HWMON_T_INPUT | HWMON_T_MIN | HWMON_T_MAX |
-			   HWMON_T_CRIT | HWMON_T_MAX_HYST |
+			   HWMON_T_CRIT | HWMON_T_MIN_HYST | HWMON_T_MAX_HYST |
 			   HWMON_T_CRIT_HYST | HWMON_T_MIN_ALARM |
 			   HWMON_T_MAX_ALARM | HWMON_T_CRIT_ALARM | HWMON_T_FAULT
 			   ),
-- 
2.53.0



