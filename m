Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0651DF969;
	Wed,  6 Nov 2024 12:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895730; cv=none; b=GfNXiN6CkJowZApFkmRVjuzKYdE0CkOx3z+DAexaxpqWnBp0zvVC8PdtBWbz+lw6hpkHgjbuP6sgJ8vXYl7v7zoGPCdPbhXGQqW69OeOZKWEygpXwgzSm7ZwSSlEVwv85bzWowPxBxcx/qFZVJZpC7yRyvuVR9n7d+TdOg1LHaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895730; c=relaxed/simple;
	bh=GlBbt9YkB/G0oDj0wT5+rQknOKcCDC84TTETEgna3ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfYm6Vg+X/GdMGCbSsBLoYrbA6BX1Q+lxUIq61nJOjIF/4Xb0hXKJTIwJExh141REuS2XvMc9fKY12OO7d/vC+xJquX9817YIrz5BaZbQq7YEFpsEHD068uk33xwoVU10973A8qVi0KlWfw8T/SHSO3Uq83JHl9Gq62qRBBl1yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9Gv1rvB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9Gv1rvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE2BC4CECD;
	Wed,  6 Nov 2024 12:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895730;
	bh=GlBbt9YkB/G0oDj0wT5+rQknOKcCDC84TTETEgna3ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N9Gv1rvBOk6Xv+vlfRD3TiRR22TNxTbZeBypPbUG2Y0jEXWk6MaWX1R0YGeynIkS0
	 RGzO3M6qO/Cul2MTrDcb9/Y8ZwL5imr5ivyekEOQtMBAVC8Ci/VpJPeaw3XHwMZI65
	 xBHAmpoxnLzeHbKstibHugibnu2J6WQMe2xkt53o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 315/350] ALSA: hda/realtek: Update default depop procedure
Date: Wed,  6 Nov 2024 13:04:03 +0100
Message-ID: <20241106120328.544907684@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit e3ea2757c312e51bbf62ebc434a6f7df1e3a201f ]

Old procedure has a chance to meet Headphone no output.

Fixes: c2d6af53a43f ("ALSA: hda/realtek - Add default procedure for suspend and resume state")
Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/17b717a0a0b04a77aea4a8ec820cba13@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 38 ++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 60dfaf2adaaf5..f33d09d939e14 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3537,20 +3537,18 @@ static void alc_default_init(struct hda_codec *codec)
 
 	hp_pin_sense = snd_hda_jack_detect(codec, hp_pin);
 
-	if (hp_pin_sense)
+	if (hp_pin_sense) {
 		msleep(2);
 
-	snd_hda_codec_write(codec, hp_pin, 0,
-			    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE);
-
-	if (hp_pin_sense)
-		msleep(85);
+		snd_hda_codec_write(codec, hp_pin, 0,
+				    AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT);
 
-	snd_hda_codec_write(codec, hp_pin, 0,
-			    AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT);
+		msleep(75);
 
-	if (hp_pin_sense)
-		msleep(100);
+		snd_hda_codec_write(codec, hp_pin, 0,
+				    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE);
+		msleep(75);
+	}
 }
 
 static void alc_default_shutup(struct hda_codec *codec)
@@ -3566,22 +3564,20 @@ static void alc_default_shutup(struct hda_codec *codec)
 
 	hp_pin_sense = snd_hda_jack_detect(codec, hp_pin);
 
-	if (hp_pin_sense)
+	if (hp_pin_sense) {
 		msleep(2);
 
-	snd_hda_codec_write(codec, hp_pin, 0,
-			    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE);
-
-	if (hp_pin_sense)
-		msleep(85);
-
-	if (!spec->no_shutup_pins)
 		snd_hda_codec_write(codec, hp_pin, 0,
-				    AC_VERB_SET_PIN_WIDGET_CONTROL, 0x0);
+				    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE);
 
-	if (hp_pin_sense)
-		msleep(100);
+		msleep(75);
 
+		if (!spec->no_shutup_pins)
+			snd_hda_codec_write(codec, hp_pin, 0,
+					    AC_VERB_SET_PIN_WIDGET_CONTROL, 0x0);
+
+		msleep(75);
+	}
 	alc_auto_setup_eapd(codec, false);
 	alc_shutup_pins(codec);
 }
-- 
2.43.0



