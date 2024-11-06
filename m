Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFA41F9A8C;
	Wed,  6 Nov 2024 12:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896693; cv=none; b=p+BM2UYPqStARhV60WQ9bbIEo1nyc8CY3fp6YgeIpGsddpJz42teiL5M14kmWIGgFywxce6hZ17rlhCaOXp7Ns0GZDEfIKviWOZgXwGWioFGv7RIB3PA9qzYlLpV6ZPsHveZN5a/qJ+2ZxeVzJx5TgLOFfSXWNxt4boAOQrWG4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896693; c=relaxed/simple;
	bh=7GWTWRgHJjCCRBJ/R1TcG5us2woWagZqUHRhO5sVD9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=scuI8ZvjKbeqgZFpm9pYUa2yvS/9iwP0WCYeyT6Gt4xtLh3yGt060g8RM+zfDXq2yw5tTOApu+c3w7Ejphcri1v/AuKsIT3lOfnder2XtExwnz4dpKe9p3CJthUqtizph3nGtZymzWwfZyNRthjIVxO/Om1lvK36PLRIkX6xG7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MaZiR8G3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MaZiR8G3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12576C4CED4;
	Wed,  6 Nov 2024 12:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896693;
	bh=7GWTWRgHJjCCRBJ/R1TcG5us2woWagZqUHRhO5sVD9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MaZiR8G3Bet/A6OsAUuOUYtJOz89CCq0QDwvfshgg7FQsUc5RYslW1H22ifh5d62a
	 zEqseve6yaxVagTy5U1YtCopRgw8ikOInWpO+9vGLCnPBTW/VrLr/4F73j/DeV57kK
	 VT7xLhICl+O7fDruUirEpt2FcG0/WPNPPxyDZDbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/110] ALSA: hda/realtek: Update default depop procedure
Date: Wed,  6 Nov 2024 13:04:08 +0100
Message-ID: <20241106120304.363960693@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 05a2442cfc656..2ccc1f7e424db 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3789,20 +3789,18 @@ static void alc_default_init(struct hda_codec *codec)
 
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
@@ -3818,22 +3816,20 @@ static void alc_default_shutup(struct hda_codec *codec)
 
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



