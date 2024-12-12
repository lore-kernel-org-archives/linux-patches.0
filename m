Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29AB22A812;
	Thu, 12 Dec 2024 17:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022823; cv=none; b=cCLT0Y93ZaoR3k7nkIyJ3gbL2kpTs+WnlS59C7Oas3ZeMJKg8G6EQLp71dGl/+M7Xn5UlGgn+kl/rtKPf17YmvdKVNx/Z6Z9GrWWtK7K3OBkETnNo+Kl1p7vdLblyNQXWaxvKQzPjkISqa0wBA5AyR0N9nZ5DHFf1IIlYXFr/QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022823; c=relaxed/simple;
	bh=Y72spprLL4YjfijZgUGtWTJPRz1tykkb4zxdO/zLXzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlRoARGir20YS4U0uaglJXa07p61wJ0n8QNwwc3AV+VLpqnIuSmQWfjKQXnUpkP4pWOBa1ghhnJwg+WaW2J9t3Xzybq6gZhhczr6xzB2YshJ8IfxBGxjqjoEeGXLV9NebXVa/T+MLOWxhDo2vcCMoUsrxr/lSVABDUN7mZNFYFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v687F5Xr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v687F5Xr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5811C4CECE;
	Thu, 12 Dec 2024 17:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022823;
	bh=Y72spprLL4YjfijZgUGtWTJPRz1tykkb4zxdO/zLXzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v687F5XrV8MOCi+PxpdpB/YuiA3PWH+pTabsPDK17z6Nn2N7gJiTANVFQh8rnhjK1
	 l/jTzHkPKP5oTjWjjT72jb1ARx/9IG9h6T/9uQn2TfgPM7usT4dtGTjPgDDm0jmToR
	 YyC8sexzOtWp5yvF/C8b0qdKG0a5axAVE48d8Qas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 344/565] ALSA: hda/realtek: Update ALC225 depop procedure
Date: Thu, 12 Dec 2024 15:58:59 +0100
Message-ID: <20241212144325.197153106@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit 1fd50509fe14a9adc9329e0454b986157a4c155a upstream.

Old procedure has a chance to meet Headphone no output.

Fixes: da911b1f5e98 ("ALSA: hda/realtek - update ALC225 depop optimize")
Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/5a27b016ba9d42b4a4e6dadce50a3ba4@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   95 +++++++++++++++++++-----------------------
 1 file changed, 43 insertions(+), 52 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3748,33 +3748,28 @@ static void alc225_init(struct hda_codec
 	hp1_pin_sense = snd_hda_jack_detect(codec, hp_pin);
 	hp2_pin_sense = snd_hda_jack_detect(codec, 0x16);
 
-	if (hp1_pin_sense || hp2_pin_sense)
+	if (hp1_pin_sense || hp2_pin_sense) {
 		msleep(2);
+		alc_update_coefex_idx(codec, 0x57, 0x04, 0x0007, 0x1); /* Low power */
 
-	alc_update_coefex_idx(codec, 0x57, 0x04, 0x0007, 0x1); /* Low power */
+		if (hp1_pin_sense)
+			snd_hda_codec_write(codec, hp_pin, 0,
+				    AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT);
+		if (hp2_pin_sense)
+			snd_hda_codec_write(codec, 0x16, 0,
+				    AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT);
+		msleep(75);
+
+		if (hp1_pin_sense)
+			snd_hda_codec_write(codec, hp_pin, 0,
+				    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE);
+		if (hp2_pin_sense)
+			snd_hda_codec_write(codec, 0x16, 0,
+				    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE);
 
-	if (hp1_pin_sense || spec->ultra_low_power)
-		snd_hda_codec_write(codec, hp_pin, 0,
-			    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE);
-	if (hp2_pin_sense)
-		snd_hda_codec_write(codec, 0x16, 0,
-			    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE);
-
-	if (hp1_pin_sense || hp2_pin_sense || spec->ultra_low_power)
-		msleep(85);
-
-	if (hp1_pin_sense || spec->ultra_low_power)
-		snd_hda_codec_write(codec, hp_pin, 0,
-			    AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT);
-	if (hp2_pin_sense)
-		snd_hda_codec_write(codec, 0x16, 0,
-			    AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT);
-
-	if (hp1_pin_sense || hp2_pin_sense || spec->ultra_low_power)
-		msleep(100);
-
-	alc_update_coef_idx(codec, 0x4a, 3 << 10, 0);
-	alc_update_coefex_idx(codec, 0x57, 0x04, 0x0007, 0x4); /* Hight power */
+		msleep(75);
+		alc_update_coefex_idx(codec, 0x57, 0x04, 0x0007, 0x4); /* Hight power */
+	}
 }
 
 static void alc225_shutup(struct hda_codec *codec)
@@ -3786,36 +3781,35 @@ static void alc225_shutup(struct hda_cod
 	if (!hp_pin)
 		hp_pin = 0x21;
 
-	alc_disable_headset_jack_key(codec);
-	/* 3k pull low control for Headset jack. */
-	alc_update_coef_idx(codec, 0x4a, 0, 3 << 10);
-
 	hp1_pin_sense = snd_hda_jack_detect(codec, hp_pin);
 	hp2_pin_sense = snd_hda_jack_detect(codec, 0x16);
 
-	if (hp1_pin_sense || hp2_pin_sense)
+	if (hp1_pin_sense || hp2_pin_sense) {
+		alc_disable_headset_jack_key(codec);
+		/* 3k pull low control for Headset jack. */
+		alc_update_coef_idx(codec, 0x4a, 0, 3 << 10);
 		msleep(2);
 
-	if (hp1_pin_sense || spec->ultra_low_power)
-		snd_hda_codec_write(codec, hp_pin, 0,
-			    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE);
-	if (hp2_pin_sense)
-		snd_hda_codec_write(codec, 0x16, 0,
-			    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE);
-
-	if (hp1_pin_sense || hp2_pin_sense || spec->ultra_low_power)
-		msleep(85);
-
-	if (hp1_pin_sense || spec->ultra_low_power)
-		snd_hda_codec_write(codec, hp_pin, 0,
-			    AC_VERB_SET_PIN_WIDGET_CONTROL, 0x0);
-	if (hp2_pin_sense)
-		snd_hda_codec_write(codec, 0x16, 0,
-			    AC_VERB_SET_PIN_WIDGET_CONTROL, 0x0);
-
-	if (hp1_pin_sense || hp2_pin_sense || spec->ultra_low_power)
-		msleep(100);
-
+		if (hp1_pin_sense)
+			snd_hda_codec_write(codec, hp_pin, 0,
+				    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE);
+		if (hp2_pin_sense)
+			snd_hda_codec_write(codec, 0x16, 0,
+				    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE);
+
+		msleep(75);
+
+		if (hp1_pin_sense)
+			snd_hda_codec_write(codec, hp_pin, 0,
+				    AC_VERB_SET_PIN_WIDGET_CONTROL, 0x0);
+		if (hp2_pin_sense)
+			snd_hda_codec_write(codec, 0x16, 0,
+				    AC_VERB_SET_PIN_WIDGET_CONTROL, 0x0);
+
+		msleep(75);
+		alc_update_coef_idx(codec, 0x4a, 3 << 10, 0);
+		alc_enable_headset_jack_key(codec);
+	}
 	alc_auto_setup_eapd(codec, false);
 	alc_shutup_pins(codec);
 	if (spec->ultra_low_power) {
@@ -3826,9 +3820,6 @@ static void alc225_shutup(struct hda_cod
 		alc_update_coef_idx(codec, 0x4a, 3<<4, 2<<4);
 		msleep(30);
 	}
-
-	alc_update_coef_idx(codec, 0x4a, 3 << 10, 0);
-	alc_enable_headset_jack_key(codec);
 }
 
 static void alc_default_init(struct hda_codec *codec)


