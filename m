Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44FE54765;
	Wed,  6 Nov 2024 13:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898970; cv=none; b=QE8QjL+DxyAH0SfiMOhiW6tZFRl7uXfuVu3gzHpKeSfzoDY0GkmEiSXiRJ0OjkXW07E10fOxiPMUDISvyOZD/GPrZO6mrxenc3i4YuEd/Ka4OhF6jo7hpxVpRzkwZLjIE+iqE5hm+jVCeR6x3PmpcVdOqYORBjMZlsXD2Xf3lKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898970; c=relaxed/simple;
	bh=wW0eZF1IIxopOdQgIXT/QTPcHzUSujoYlfw5bkZ8LVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ea9tgDoIPiwd9tuHq8DIfTJW9i+HqXhh3QwJntMbZgna2qriY8dR5RPlkDbNCp9xnTy9KcaeKgDu9vb3XWEcQepaXIgTA9hZshki9nbcsqZhMaVcNK5TgOzc2EYIEOO9T/E4M3Su/RVAaQTVZSK+/i5kkpXQCHFpEh790d4CzTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ESwpP++K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ESwpP++K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE9CC4CECD;
	Wed,  6 Nov 2024 13:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898970;
	bh=wW0eZF1IIxopOdQgIXT/QTPcHzUSujoYlfw5bkZ8LVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ESwpP++KW8mPp6sddxIfPO8El9yyft5L917rYgXW0F8EWpw23XqZv7tEBvsUmf7t0
	 hr+aW6jbZDXKPQPHC8f7K9aziROOtHISj3YK4tyDPhgpvPsPHczQ3fHlUp2fNhwTfd
	 pybyOwnzSiplJohr0RE391AL9Q0wH09528+8xGVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 416/462] ALSA: hda/realtek: Update default depop procedure
Date: Wed,  6 Nov 2024 13:05:09 +0100
Message-ID: <20241106120341.793287223@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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
index f32c3c3752417..4ed7483087ee6 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3730,20 +3730,18 @@ static void alc_default_init(struct hda_codec *codec)
 
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
@@ -3759,22 +3757,20 @@ static void alc_default_shutup(struct hda_codec *codec)
 
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



