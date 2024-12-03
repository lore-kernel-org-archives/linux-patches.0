Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359F61E3DED;
	Tue,  3 Dec 2024 15:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239812; cv=none; b=PeqWFg7XIu2UJsG/KAVUzjxU1ie9ccZqn+JbklnxEI2xHhWchETbj36o1AdaNLxK4PahLoYXVgdaTU08alLeFFhjVs0xzNhduvuR2P589QGV8uEG8lZQ4jK7y6m4xYeo4GQdJcJzFF3g+Vh7QxWdMROlu6ftTuqC7XTON3+VvoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239812; c=relaxed/simple;
	bh=ND44qf7IMPjdjNGMZBFV16bzYxKDuNo5jHqyt1TboqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEoSg8gqqioBFp+o/0snQOXruhR8g4Ck1CYWsYDJO926KndJ/pHsC067RDLVfaWphaf6qF/ZtJ4N4oYVY4DgaVZc1e+6wA+LqjSUfya70VCipQiStc8mfhSxvjtC1erilkzV3gvqvCaTYTgTn4KCAXG9gAmXGXQUgNBqZaiB+f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LniK3hVN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LniK3hVN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BB9C4CECF;
	Tue,  3 Dec 2024 15:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239812;
	bh=ND44qf7IMPjdjNGMZBFV16bzYxKDuNo5jHqyt1TboqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LniK3hVNSlEB7lTprkl9Vr7uXHsyyuUERCUOZ7LICyRZH1o6LZIsZWzYZgFSB5N9C
	 iFO3vs/lDEHC3YVUFqIprQCU2uEOAcHcva0qxjr3P+lJLB4f2gVuCQt2eBYVkf20wM
	 ML6+N9rt+78AEIO5+Ln2f0yW15TimA/NPTaMAFcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.11 741/817] ALSA: hda/realtek: Update ALC225 depop procedure
Date: Tue,  3 Dec 2024 15:45:13 +0100
Message-ID: <20241203144024.921089278@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3757,33 +3757,28 @@ static void alc225_init(struct hda_codec
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
@@ -3795,36 +3790,35 @@ static void alc225_shutup(struct hda_cod
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
@@ -3835,9 +3829,6 @@ static void alc225_shutup(struct hda_cod
 		alc_update_coef_idx(codec, 0x4a, 3<<4, 2<<4);
 		msleep(30);
 	}
-
-	alc_update_coef_idx(codec, 0x4a, 3 << 10, 0);
-	alc_enable_headset_jack_key(codec);
 }
 
 static void alc_default_init(struct hda_codec *codec)


