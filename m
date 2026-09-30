Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E1E5187EE;
	Wed, 30 Sep 2026 17:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788107; cv=none; b=Edqy0cHiZa5v5uo/8We9lytUsVvcZ8qJmZ2/FPxI7VR8793suY++6lVwtqCkzKROXP3BqB1thh6MDIbtAI82Cu81E+62zNN5fKSgyau1sAgGsI0CV2IB7BswUzpxFcebQB5WfTnyafqlHR0vycoSAYy1YoT4Jpm+0zjpiq3qH24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788107; c=relaxed/simple;
	bh=JmlPi3KfP8srTsMW08RaVemM3VVnO9ffW0rxHWZaDo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RB8jflP+E7t4PNrJ0lpwN1HAsIJHEvM90HdRY8WNsvPl0DHalxaVORFZLks/4bc/WqBrMTWkwqeZe/I7o4U9B9mhydGd3mCMQsDLo7Cr3u3dmJHlmAbF7tpFsN9UFUba6fR7qLHs6q5LibpnE/pfNdTtJHyV+2m8LwCZf/2n4HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Va2Dk0VM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Va2Dk0VM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E851F00899;
	Wed, 30 Sep 2026 17:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788106;
	bh=tBKzs3an3L7zxd6UBZNhkQtAhJWsICrhJjGqyl3UwHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Va2Dk0VMlhqHTi6T3gNRI2FQiUJw0+RbGRWtrWJHywqPuSt4otY/NveHV2Q0G67xE
	 ZXnaMgZvtRTuxLz2UytP0kgb4wZpU+98Cx80JpBjz0JqH0+2PPrvGUJwmmcUceQ2fZ
	 bdGKctTFCpNc4/JpOlg8ahWtRBPQpV5wM0I1YxbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 001/877] Revert "hwmon: (emc1403) Drop hysteresis for low limit temperature"
Date: Wed, 30 Sep 2026 17:15:12 +0200
Message-ID: <20260930152414.776092591@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

This reverts commit 5cc075ffa1c986474c1f56ba6f869dcc41a363d4.

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
index 39f69adb88c25..ccce948a4306e 100644
--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -305,9 +305,10 @@ static int emc1403_get_hyst(struct thermal_data *data, int channel,
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
 
@@ -323,6 +324,9 @@ static int emc1403_temp_read(struct thermal_data *data, u32 attr, int channel, l
 	case hwmon_temp_input:
 		ret = emc1403_get_temp(data, channel, ema1403_temp_map[attr], val);
 		break;
+	case hwmon_temp_min_hyst:
+		ret = emc1403_get_hyst(data, channel, temp_min, val);
+		break;
 	case hwmon_temp_max_hyst:
 		ret = emc1403_get_hyst(data, channel, temp_max, val);
 		break;
@@ -544,6 +548,7 @@ static umode_t emc1403_temp_is_visible(const void *_data, u32 attr, int channel)
 	case hwmon_temp_max_alarm:
 	case hwmon_temp_crit_alarm:
 	case hwmon_temp_fault:
+	case hwmon_temp_min_hyst:
 	case hwmon_temp_max_hyst:
 		return 0444;
 	case hwmon_temp_min:
@@ -586,35 +591,35 @@ static const struct hwmon_channel_info * const emc1403_info[] = {
 	HWMON_CHANNEL_INFO(chip, HWMON_C_UPDATE_INTERVAL),
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



