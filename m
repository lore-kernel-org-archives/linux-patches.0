Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149D52248A4;
	Thu, 12 Dec 2024 17:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025441; cv=none; b=obr3E8R6ggRX0HDOyaNyvfcu28YaaB9+crU9z8wzyfDJRfs+c9XCYIWL2Fm/8NLrhCBzsqXyL85VQNG9q6/0aUWuQ5hMSEyi8GRfLmcfgqfOLA2+vEfk201+iw7rDbTSonAlent/Hz0hEgsJfsBeD3Rba6poKmOOiz8Xd1vqeWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025441; c=relaxed/simple;
	bh=xPom0Tp9/HTIaEgnga5/2Gdz+y+0D9+GqF7amVtT0zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=md2Tc1jgeF7ujA4TrPFmxDjSzAMaY5yxqqrqcCNGHImCALVgDTzxkEZOAR1Hyc+uonOD0n/AE/TXk3C7Dea0pQIHJ5Bcfi0zOJWu09ZudRRdqZHK0SR7pbEf9V3bPyQiz8KRhKGrOzX9Cl+UGP8Ts/b63znaS4UckUwJrBfizSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wXtuP0FP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wXtuP0FP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA6BC4CED0;
	Thu, 12 Dec 2024 17:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025440;
	bh=xPom0Tp9/HTIaEgnga5/2Gdz+y+0D9+GqF7amVtT0zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wXtuP0FPVYDxR26WGjlnd5dvTKPrkSIynMRgqgshM3WntVAM5XvOuBUq6eTul9riQ
	 ZgxbZD8PaLd/2lMnSjqlUjnDDrImC4N2Godl8dOJ0vsfY6k6qxBtojWDVIhhZBNLJy
	 Yhs3jzprRoBYMqYc5rF3gL6senOVaJ/0bHz0IsXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 169/321] ALSA: hda/realtek: Update ALC225 depop procedure
Date: Thu, 12 Dec 2024 16:01:27 +0100
Message-ID: <20241212144236.656672756@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3634,33 +3634,28 @@ static void alc225_init(struct hda_codec
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
@@ -3672,36 +3667,35 @@ static void alc225_shutup(struct hda_cod
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
@@ -3712,9 +3706,6 @@ static void alc225_shutup(struct hda_cod
 		alc_update_coef_idx(codec, 0x4a, 3<<4, 2<<4);
 		msleep(30);
 	}
-
-	alc_update_coef_idx(codec, 0x4a, 3 << 10, 0);
-	alc_enable_headset_jack_key(codec);
 }
 
 static void alc_default_init(struct hda_codec *codec)


