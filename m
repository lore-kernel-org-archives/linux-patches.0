Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06ADF255E34;
	Thu, 17 Apr 2025 18:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914411; cv=none; b=btpnbHFdDBvzwS7mz0aivEo7TYkvAcfvNMYcfnk6IOGsFt8FPpDdbJhrVqoXwd09e4pUNlIanCj/kaC1OhGoEJgiHWgp7FmOZOXsgLEqE9pWEnfs7fmIrM6ib2v/Nj3b5kVWdFkQ+uhcCECnGeeHJsHOo8XA1JNGo0PPHq0sdOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914411; c=relaxed/simple;
	bh=qmGTXssZA9PRmw2Av/e3vbcSs1Z9hNcMGDZ+YbLoe5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uCDtz2dInXsKDZIbdnEbNofkfBoWHYoL6ylZ5+NxObjq4uOI0xLblE6BpXTN5VJSotcuKL0OZpk7BLVLCdjp+FriAnRbyJk5xRyaFaMSXqutAId/kSCPvH/dy0QJ8OgbrKB16PIUAPn7fxFLh5MEE9DPNjLprlyntwHyngxQaps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1p5l/hQX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1p5l/hQX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D21C4CEE4;
	Thu, 17 Apr 2025 18:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914410;
	bh=qmGTXssZA9PRmw2Av/e3vbcSs1Z9hNcMGDZ+YbLoe5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1p5l/hQXPWueQ7bZST6XE6OKIittcRhZwxWsroNLIvnC4FSBo+RwctvjfZw8VAPfB
	 kkdavAZgBs5qvdiyARaWhUHd2NiCJX63v1P26j5re6VsYrWG3yLvvcqAhkWXCVMEbv
	 X8uhUP0MWO+ma8snTyzphtpSug1RlGUwQO0rituI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Makarenko Oleg <oleg@makarenk.ooo>,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	=?UTF-8?q?Micha=C5=82=20Kope=C4=87?= <michal@nozomi.space>,
	Paul Dino Jones <paul@spacefreak18.xyz>,
	=?UTF-8?q?Crist=C3=B3ferson=20Bueno?= <cbueno81@gmail.com>,
	Pablo Cisneros <patchkez@protonmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 179/414] HID: pidff: Rescale time values to match field units
Date: Thu, 17 Apr 2025 19:48:57 +0200
Message-ID: <20250417175118.643457372@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit 8713107221a8ce4021ec5fa12bb50ecc8165cf08 ]

PID devices can use different exponents for time fields, while Linux
Force Feedback API only supports miliseconds.

Read the exponent of a given time field and scale its value accordingly.

Changes in v7:
- Rescale all time fields, not only period

changes in v9:
- Properly assign fade_lenght, not attack_length to PID_FADE_TIME

Co-developed-by: Makarenko Oleg <oleg@makarenk.ooo>
Signed-off-by: Makarenko Oleg <oleg@makarenk.ooo>
Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Reviewed-by: Michał Kopeć <michal@nozomi.space>
Reviewed-by: Paul Dino Jones <paul@spacefreak18.xyz>
Tested-by: Paul Dino Jones <paul@spacefreak18.xyz>
Tested-by: Cristóferson Bueno <cbueno81@gmail.com>
Tested-by: Pablo Cisneros <patchkez@protonmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-pidff.c | 69 ++++++++++++++++++++++++++--------
 1 file changed, 54 insertions(+), 15 deletions(-)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index bd913d57e4d75..180b2cf66e4c7 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -22,6 +22,9 @@
 #define	PID_EFFECTS_MAX		64
 #define	PID_INFINITE		0xffff
 
+/* Linux Force Feedback API uses miliseconds as time unit */
+#define FF_TIME_EXPONENT	-3
+
 /* Report usage table used to put reports into an array */
 
 #define PID_SET_EFFECT		0
@@ -231,6 +234,24 @@ static int pidff_rescale_signed(int i, struct hid_field *field)
 	    field->logical_minimum / -0x8000;
 }
 
+/*
+ * Scale time value from Linux default (ms) to field units
+ */
+static u32 pidff_rescale_time(u16 time, struct hid_field *field)
+{
+	u32 scaled_time = time;
+	int exponent = field->unit_exponent;
+	pr_debug("time field exponent: %d\n", exponent);
+
+	for (;exponent < FF_TIME_EXPONENT; exponent++)
+		scaled_time *= 10;
+	for (;exponent > FF_TIME_EXPONENT; exponent--)
+		scaled_time /= 10;
+
+	pr_debug("time calculated from %d to %d\n", time, scaled_time);
+	return scaled_time;
+}
+
 static void pidff_set(struct pidff_usage *usage, u16 value)
 {
 	usage->value[0] = pidff_rescale(value, 0xffff, usage->field);
@@ -252,6 +273,27 @@ static void pidff_set_signed(struct pidff_usage *usage, s16 value)
 	pr_debug("calculated from %d to %d\n", value, usage->value[0]);
 }
 
+static void pidff_set_time(struct pidff_usage *usage, u16 time)
+{
+	u32 modified_time = pidff_rescale_time(time, usage->field);
+	usage->value[0] = pidff_clamp(modified_time, usage->field);
+}
+
+static void pidff_set_duration(struct pidff_usage *usage, u16 duration)
+{
+	/* Convert infinite length from Linux API (0)
+	   to PID standard (NULL) if needed */
+	if (duration == 0)
+		duration = PID_INFINITE;
+
+	if (duration == PID_INFINITE) {
+		usage->value[0] = PID_INFINITE;
+		return;
+	}
+
+	pidff_set_time(usage, duration);
+}
+
 /*
  * Send envelope report to the device
  */
@@ -270,8 +312,10 @@ static void pidff_set_envelope_report(struct pidff_device *pidff,
 			  0x7fff ? 0x7fff : envelope->fade_level, 0x7fff,
 			  pidff->set_envelope[PID_FADE_LEVEL].field);
 
-	pidff->set_envelope[PID_ATTACK_TIME].value[0] = envelope->attack_length;
-	pidff->set_envelope[PID_FADE_TIME].value[0] = envelope->fade_length;
+	pidff_set_time(&pidff->set_envelope[PID_ATTACK_TIME],
+			envelope->attack_length);
+	pidff_set_time(&pidff->set_envelope[PID_FADE_TIME],
+			envelope->fade_length);
 
 	hid_dbg(pidff->hid, "attack %u => %d\n",
 		envelope->attack_level,
@@ -340,14 +384,12 @@ static void pidff_set_effect_report(struct pidff_device *pidff,
 	pidff->set_effect_type->value[0] =
 		pidff->create_new_effect_type->value[0];
 
-	/* Convert infinite length from Linux API (0)
-	   to PID standard (NULL) if needed */
-	pidff->set_effect[PID_DURATION].value[0] =
-		effect->replay.length == 0 ? PID_INFINITE : effect->replay.length;
+	pidff_set_duration(&pidff->set_effect[PID_DURATION],
+		effect->replay.length);
 
 	pidff->set_effect[PID_TRIGGER_BUTTON].value[0] = effect->trigger.button;
-	pidff->set_effect[PID_TRIGGER_REPEAT_INT].value[0] =
-		effect->trigger.interval;
+	pidff_set_time(&pidff->set_effect[PID_TRIGGER_REPEAT_INT],
+			effect->trigger.interval);
 	pidff->set_effect[PID_GAIN].value[0] =
 		pidff->set_effect[PID_GAIN].field->logical_maximum;
 	pidff->set_effect[PID_DIRECTION_ENABLE].value[0] = 1;
@@ -360,7 +402,8 @@ static void pidff_set_effect_report(struct pidff_device *pidff,
 
 	/* Omit setting delay field if it's missing */
 	if (!(pidff->quirks & HID_PIDFF_QUIRK_MISSING_DELAY))
-		pidff->set_effect[PID_START_DELAY].value[0] = effect->replay.delay;
+		pidff_set_time(&pidff->set_effect[PID_START_DELAY],
+				effect->replay.delay);
 
 	hid_hw_request(pidff->hid, pidff->reports[PID_SET_EFFECT],
 			HID_REQ_SET_REPORT);
@@ -392,15 +435,11 @@ static void pidff_set_periodic_report(struct pidff_device *pidff,
 	pidff_set_signed(&pidff->set_periodic[PID_OFFSET],
 			 effect->u.periodic.offset);
 	pidff_set(&pidff->set_periodic[PID_PHASE], effect->u.periodic.phase);
-
-	/* Clamp period to ensure the device can play the effect */
-	pidff->set_periodic[PID_PERIOD].value[0] =
-		pidff_clamp(effect->u.periodic.period,
-			pidff->set_periodic[PID_PERIOD].field);
+	pidff_set_time(&pidff->set_periodic[PID_PERIOD],
+			effect->u.periodic.period);
 
 	hid_hw_request(pidff->hid, pidff->reports[PID_SET_PERIODIC],
 			HID_REQ_SET_REPORT);
-
 }
 
 /*
-- 
2.39.5



