Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E101F757D;
	Tue,  3 Dec 2024 15:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239527; cv=none; b=d5z+eNeUQnxiPL7JD+ObCHOKPMkIJo4ed9gfa7RXbZc39HOmwtP2GyXuvWQGBF2I70QcyaWaY4DseTspJD/9mIPrX9+e4YUc6SDsYa1QYFWsIRbglNgBj7bjRdEGM9qweWVtKS6p3KY3Bnw9leN4kS/NszXIP8SHvWtwL5dwmS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239527; c=relaxed/simple;
	bh=OnoN/C5DLREs/+QSMvC1Ss/28PotDfTnRAyr4uPdgJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhgEc2Zgi74v6oG8bgevQRBwnjPOE00kQwICNIYqY7e2bwbFHmn/cphEgt5gq0EVoR60bCCnv1d3vRre0zhjq5E8NjPiVCTgLEaA+RoYqYMusfm7HhHvgUZxGsBFsR1LOfHCSo5yFSgquik2+N1Ys45XNCJBqFMLhUeb3o1Q2GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGyI/9MV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGyI/9MV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FBEC4CECF;
	Tue,  3 Dec 2024 15:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239527;
	bh=OnoN/C5DLREs/+QSMvC1Ss/28PotDfTnRAyr4uPdgJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MGyI/9MV1hWpb6bNTGn5uVT4czhnE/DnOAjCS5TuQzMIg5c/Gsgr1RhzDQi6XPqiK
	 j82+YE7+6au0EQ0EI77VlfwgGO+F4BrsT461GxikywA65Xv2PUHFTk4gQyyN4K4yG5
	 Vb837zmo6p0h7oeSGGcbCxPYBjSFG7W8PeMtTS8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 613/817] ALSA: hda/realtek: Update ALC256 depop procedure
Date: Tue,  3 Dec 2024 15:43:05 +0100
Message-ID: <20241203144019.861558163@linuxfoundation.org>
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
index 149079afa7969..dcbb7981496c9 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3602,25 +3602,22 @@ static void alc256_init(struct hda_codec *codec)
 
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
@@ -3644,29 +3641,28 @@ static void alc256_shutup(struct hda_codec *codec)
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



