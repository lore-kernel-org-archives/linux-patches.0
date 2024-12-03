Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803781F759C;
	Tue,  3 Dec 2024 16:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242115; cv=none; b=Hy4MaBwb2F+37xbvIvUNx5z5EFUBE3VHfAjB1fI2eLAuf/jaI+/4xq2lD7vJOs/SX2m33BND1r1I7G3rbklJaN1qowzW+2W1DMA94UfdkOLJEXftSnFRB4W1kYqareAT26NXx85R1J+E9vLBhjvS6/zcwmgyCUhqhvoug2Z3D84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242115; c=relaxed/simple;
	bh=P9OG11fpTVjY6dD/SZMxnZbCbhmNYuybSrwnpFATZtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfvQ7ROKzcSh9OPJ8yDkWVSRStoNyrGAQBXDSrejdqAf6vvW1bsiGMQyXjC256GgCUau1SCrRTDIGC37I8tfL+eF/c5cIFyAsC/zMsALridBpg4vQscsOSvQEIW6AN0KCusH+G0cTBWoslbQDw1BmYu9CRgoTbpYlLeETKYj3pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YQaBkkio; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YQaBkkio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D44FC4CECF;
	Tue,  3 Dec 2024 16:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242115;
	bh=P9OG11fpTVjY6dD/SZMxnZbCbhmNYuybSrwnpFATZtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQaBkkiodp9WiSWzZ8ttp3L3v2rmOg7NkafCRAoCxO4EbQaqGm+3E5mWNAdHrDkJO
	 1JFVC6ubidND0pwRILmx0X6YtWtU05G4JMhU884GWaFlQ7ZSOvY3vkJSqYK/UGGdgY
	 OfMI57lmyr6RgXJD76Xwr0tRTjafzWXyvuznNZOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 611/826] ALSA: hda/realtek: Update ALC256 depop procedure
Date: Tue,  3 Dec 2024 15:45:38 +0100
Message-ID: <20241203144807.586750502@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit cc3d0b5dd989d3238d456f9fd385946379a9c13d ]

Old procedure has a chance to meet Headphone no output.

Fixes: 4a219ef8f370 ("ALSA: hda/realtek - Add ALC256 HP depop function")
Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/463c5f93715d4714967041a0a8cec28e@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 42 ++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 24b4fe99304a4..61d7d8b937676 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3613,25 +3613,22 @@ static void alc256_init(struct hda_codec *codec)
 
 	hp_pin_sense = snd_hda_jack_detect(codec, hp_pin);
 
-	if (hp_pin_sense)
+	if (hp_pin_sense) {
 		msleep(2);
+		alc_update_coefex_idx(codec, 0x57, 0x04, 0x0007, 0x1); /* Low power */
 
-	alc_update_coefex_idx(codec, 0x57, 0x04, 0x0007, 0x1); /* Low power */
-
-	snd_hda_codec_write(codec, hp_pin, 0,
-			    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE);
-
-	if (hp_pin_sense || spec->ultra_low_power)
-		msleep(85);
-
-	snd_hda_codec_write(codec, hp_pin, 0,
+		snd_hda_codec_write(codec, hp_pin, 0,
 			    AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT);
 
-	if (hp_pin_sense || spec->ultra_low_power)
-		msleep(100);
+		msleep(75);
+
+		snd_hda_codec_write(codec, hp_pin, 0,
+			    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE);
 
+		msleep(75);
+		alc_update_coefex_idx(codec, 0x57, 0x04, 0x0007, 0x4); /* Hight power */
+	}
 	alc_update_coef_idx(codec, 0x46, 3 << 12, 0);
-	alc_update_coefex_idx(codec, 0x57, 0x04, 0x0007, 0x4); /* Hight power */
 	alc_update_coefex_idx(codec, 0x53, 0x02, 0x8000, 1 << 15); /* Clear bit */
 	alc_update_coefex_idx(codec, 0x53, 0x02, 0x8000, 0 << 15);
 	/*
@@ -3655,29 +3652,28 @@ static void alc256_shutup(struct hda_codec *codec)
 	alc_update_coefex_idx(codec, 0x57, 0x04, 0x0007, 0x1); /* Low power */
 	hp_pin_sense = snd_hda_jack_detect(codec, hp_pin);
 
-	if (hp_pin_sense)
+	if (hp_pin_sense) {
 		msleep(2);
 
-	snd_hda_codec_write(codec, hp_pin, 0,
+		snd_hda_codec_write(codec, hp_pin, 0,
 			    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE);
 
-	if (hp_pin_sense || spec->ultra_low_power)
-		msleep(85);
+		msleep(75);
 
 	/* 3k pull low control for Headset jack. */
 	/* NOTE: call this before clearing the pin, otherwise codec stalls */
 	/* If disable 3k pulldown control for alc257, the Mic detection will not work correctly
 	 * when booting with headset plugged. So skip setting it for the codec alc257
 	 */
-	if (spec->en_3kpull_low)
-		alc_update_coef_idx(codec, 0x46, 0, 3 << 12);
+		if (spec->en_3kpull_low)
+			alc_update_coef_idx(codec, 0x46, 0, 3 << 12);
 
-	if (!spec->no_shutup_pins)
-		snd_hda_codec_write(codec, hp_pin, 0,
+		if (!spec->no_shutup_pins)
+			snd_hda_codec_write(codec, hp_pin, 0,
 				    AC_VERB_SET_PIN_WIDGET_CONTROL, 0x0);
 
-	if (hp_pin_sense || spec->ultra_low_power)
-		msleep(100);
+		msleep(75);
+	}
 
 	alc_auto_setup_eapd(codec, false);
 	alc_shutup_pins(codec);
-- 
2.43.0



