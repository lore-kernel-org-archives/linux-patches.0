Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A6A2253EC;
	Thu, 12 Dec 2024 16:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019929; cv=none; b=MEyGLhpbmIZjlh4nK3UZlxr0u7sXfc02DGajafDu+DVx8UevARKWC2RuIxTmltEOGeS3+a8sM067p/oKG26d4UsciqrqWXYS5t3QT/KqPFRA1KP64jnx4BUJE+JL9kzNJW+K+tZqz5X/s/Fi9q+5quZ8rAiKoKNODgqs0vQZblw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019929; c=relaxed/simple;
	bh=MTK/aborMScIfXr+6RfpLaWjGO/sZNS+ZD1ZeKriJlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEyqGvq4to/5wLZtMfouPPaD3Srbg/4bDDTaDqHfB5TDBNJjifUY9rQ9tVx2RvFVFAbn41p0akfriVJ0hVM8BWPVHd/9qcwWzydq5Lbo3zOFZjZHU1eBeqMEkRa7ikzoukDHm6yfopMbQb7Qq6cNy5Bx6U8uum0B2pGyywcmyNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wt/CSrJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wt/CSrJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E78C4CED0;
	Thu, 12 Dec 2024 16:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019929;
	bh=MTK/aborMScIfXr+6RfpLaWjGO/sZNS+ZD1ZeKriJlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wt/CSrJ0F4v9XHCgvgMk1oN2MkRs8q6wxhDBNSCrRhXx3hEMvctk3/C9KfqKHecHa
	 u3kiXUk/LV30HmYwqsTjF+xybJ7eHNwyP2TVmI3AZcZxi6vrzyjOpklHltFZqy6C8z
	 N13pGljs5M9/1RnlwkZZeds3dsf2ctHL+pRIux0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 334/772] ALSA: hda/realtek: Update ALC256 depop procedure
Date: Thu, 12 Dec 2024 15:54:39 +0100
Message-ID: <20241212144403.705110938@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f3e368f82be9b..465d9b7befe56 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3599,25 +3599,22 @@ static void alc256_init(struct hda_codec *codec)
 
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
@@ -3641,29 +3638,28 @@ static void alc256_shutup(struct hda_codec *codec)
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



