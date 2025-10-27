Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768D62D8DB9;
	Mon, 27 Oct 2025 18:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590423; cv=none; b=YVyKcPzzUaIHsi4QTceFvc/fJx9nKWx3/b2iniuFPoeX91CXFR0LavH7sAdBck9JN37QI7cfnJXu/6ix66pNanHyYrvXGovWvtzSH5nhd258BIwURWpx/BXTgj2IkkmpYAT0bAAGqE+ZQFF+Tdn+/x+jn0jq9JNi4ZhjtWXi+hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590423; c=relaxed/simple;
	bh=qv3KqFWUE8YsvdANCtb4lPe1BF9MUY34PL7Od3K3n5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZubFzfjQQ9y9L4uEiZUoi3X+ZbHMGXabomIQ0Qp/gdZc9RVwmpxV5YzoVeN4wQCS4xH9dKg3qeAJojnoTaicxX0MrJdO51OXUQN+lSuMwGskwygJx2f+9u3o2GcEm4Qr8e53HoSQst3WuN+Qa+u+CKEEeCWvpaGpyyPhHOBNG+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wpc/ETmH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wpc/ETmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58CDC4CEF1;
	Mon, 27 Oct 2025 18:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590423;
	bh=qv3KqFWUE8YsvdANCtb4lPe1BF9MUY34PL7Od3K3n5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wpc/ETmH89sVJMLrvj1c9EK0UyxamWtfMZQZt/ukXLXax09FpJ9RfKNE/B87c4Rmm
	 iehsBNPRWN6mp6saRfop1hs3kru09fxmrwtMV/QcFTRjZCi0LgHzg4zJtgru3S9puA
	 4Tg8v1Zjlr1JmYcthsaYMcfxx3t7FhwC05eoKFHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Flavius Georgescu <pretoriano.mp@gmail.com>,
	Chris Vandomelen <chris@sightworks.com>,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 007/224] media: rc: Add support for another iMON 0xffdc device
Date: Mon, 27 Oct 2025 19:32:33 +0100
Message-ID: <20251027183509.176655491@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Flavius Georgescu <pretoriano.mp@gmail.com>

[ Upstream commit cf330691668a3bee37b8ac8212709b3ccdd87997 ]

The device it's an iMON UltraBay (0x98 in config byte) with LCD,
IR and dual-knobs front panel.

To work properly the device also require its own key table,
and repeat suppression for all buttons.

Signed-off-by: Flavius Georgescu <pretoriano.mp@gmail.com>
Co-developed-by: Chris Vandomelen <chris@sightworks.com>
Signed-off-by: Chris Vandomelen <chris@sightworks.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Stable-dep-of: fa0f61cc1d82 ("media: rc: fix races with imon_disconnect()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/imon.c |   61 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 51 insertions(+), 10 deletions(-)

--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -83,6 +83,7 @@ struct imon_usb_dev_descr {
 	__u16 flags;
 #define IMON_NO_FLAGS 0
 #define IMON_NEED_20MS_PKT_DELAY 1
+#define IMON_SUPPRESS_REPEATED_KEYS 2
 	struct imon_panel_key_table key_table[];
 };
 
@@ -149,8 +150,9 @@ struct imon_context {
 	struct timer_list ttimer;	/* touch screen timer */
 	int touch_x;			/* x coordinate on touchscreen */
 	int touch_y;			/* y coordinate on touchscreen */
-	struct imon_usb_dev_descr *dev_descr; /* device description with key
-						 table for front panels */
+	const struct imon_usb_dev_descr *dev_descr;
+					/* device description with key */
+					/* table for front panels */
 };
 
 #define TOUCH_TIMEOUT	(HZ/30)
@@ -315,6 +317,32 @@ static const struct imon_usb_dev_descr i
 	}
 };
 
+/* imon ultrabay front panel key table */
+static const struct imon_usb_dev_descr ultrabay_table = {
+	.flags = IMON_SUPPRESS_REPEATED_KEYS,
+	.key_table = {
+		{ 0x0000000f0000ffeell, KEY_MEDIA },      /* Go */
+		{ 0x000000000100ffeell, KEY_UP },
+		{ 0x000000000001ffeell, KEY_DOWN },
+		{ 0x000000160000ffeell, KEY_ENTER },
+		{ 0x0000001f0000ffeell, KEY_AUDIO },      /* Music */
+		{ 0x000000200000ffeell, KEY_VIDEO },      /* Movie */
+		{ 0x000000210000ffeell, KEY_CAMERA },     /* Photo */
+		{ 0x000000270000ffeell, KEY_DVD },        /* DVD */
+		{ 0x000000230000ffeell, KEY_TV },         /* TV */
+		{ 0x000000050000ffeell, KEY_PREVIOUS },   /* Previous */
+		{ 0x000000070000ffeell, KEY_REWIND },
+		{ 0x000000040000ffeell, KEY_STOP },
+		{ 0x000000020000ffeell, KEY_PLAYPAUSE },
+		{ 0x000000080000ffeell, KEY_FASTFORWARD },
+		{ 0x000000060000ffeell, KEY_NEXT },       /* Next */
+		{ 0x000100000000ffeell, KEY_VOLUMEUP },
+		{ 0x010000000000ffeell, KEY_VOLUMEDOWN },
+		{ 0x000000010000ffeell, KEY_MUTE },
+		{ 0, KEY_RESERVED },
+	}
+};
+
 /*
  * USB Device ID for iMON USB Control Boards
  *
@@ -1261,9 +1289,11 @@ static u32 imon_mce_key_lookup(struct im
 
 static u32 imon_panel_key_lookup(struct imon_context *ictx, u64 code)
 {
-	int i;
+	const struct imon_panel_key_table *key_table;
 	u32 keycode = KEY_RESERVED;
-	struct imon_panel_key_table *key_table = ictx->dev_descr->key_table;
+	int i;
+
+	key_table = ictx->dev_descr->key_table;
 
 	for (i = 0; key_table[i].hw_code != 0; i++) {
 		if (key_table[i].hw_code == (code | 0xffee)) {
@@ -1547,7 +1577,6 @@ static void imon_incoming_packet(struct
 	u32 kc;
 	u64 scancode;
 	int press_type = 0;
-	long msec;
 	ktime_t t;
 	static ktime_t prev_time;
 	u8 ktype;
@@ -1649,14 +1678,16 @@ static void imon_incoming_packet(struct
 	spin_lock_irqsave(&ictx->kc_lock, flags);
 
 	t = ktime_get();
-	/* KEY_MUTE repeats from knob need to be suppressed */
-	if (ictx->kc == KEY_MUTE && ictx->kc == ictx->last_keycode) {
-		msec = ktime_ms_delta(t, prev_time);
-		if (msec < ictx->idev->rep[REP_DELAY]) {
+	/* KEY repeats from knob and panel that need to be suppressed */
+	if (ictx->kc == KEY_MUTE ||
+	    ictx->dev_descr->flags & IMON_SUPPRESS_REPEATED_KEYS) {
+		if (ictx->kc == ictx->last_keycode &&
+		    ktime_ms_delta(t, prev_time) < ictx->idev->rep[REP_DELAY]) {
 			spin_unlock_irqrestore(&ictx->kc_lock, flags);
 			return;
 		}
 	}
+
 	prev_time = t;
 	kc = ictx->kc;
 
@@ -1844,6 +1875,14 @@ static void imon_get_ffdc_type(struct im
 		dev_info(ictx->dev, "0xffdc iMON Inside, iMON IR");
 		ictx->display_supported = false;
 		break;
+	/* Soundgraph iMON UltraBay */
+	case 0x98:
+		dev_info(ictx->dev, "0xffdc iMON UltraBay, LCD + IR");
+		detected_display_type = IMON_DISPLAY_TYPE_LCD;
+		allowed_protos = RC_PROTO_BIT_IMON | RC_PROTO_BIT_RC6_MCE;
+		ictx->dev_descr = &ultrabay_table;
+		break;
+
 	default:
 		dev_info(ictx->dev, "Unknown 0xffdc device, defaulting to VFD and iMON IR");
 		detected_display_type = IMON_DISPLAY_TYPE_VFD;
@@ -1975,10 +2014,12 @@ out:
 
 static struct input_dev *imon_init_idev(struct imon_context *ictx)
 {
-	struct imon_panel_key_table *key_table = ictx->dev_descr->key_table;
+	const struct imon_panel_key_table *key_table;
 	struct input_dev *idev;
 	int ret, i;
 
+	key_table = ictx->dev_descr->key_table;
+
 	idev = input_allocate_device();
 	if (!idev)
 		goto out;


