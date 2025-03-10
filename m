Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15672226D0B;
	Mon, 10 Mar 2025 17:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627327; cv=none; b=reG1FNPhUWJwsErkeq0vFHcdcWWxhKsAAJccvGhuj44GgBz0seu+KOVFy7XT2Q/ulIuZz6Lsus0vBpQDQn7VkMg0hdszCzx/NisSKTAB3XM+ojBcyZOpuMOUUf7U8vm+CVA/vGWdK6SGz7ROOrTUcmgNOGFBETr4latG1XcMcdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627327; c=relaxed/simple;
	bh=5wUBcl3z/WZGyTd0FiOdtpYRmdrNOrX8HNbT9MBb8wA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1rUAkoOzPUu7IdRi/jjw8fXgFjOIyElwYk0MheImyIBLjjPzMZdUkzwhEsrYc2t5eR7uBYev6SbjiMs4NT9ONXRSh/Sgll/qwH5rNDNK9379yXPB5JqKGieZ7T6HuRbW9Onu2AL3ZqBAN/ddea04SgKobsZiH4ZOgJnP33ygjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ECDoX0f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ECDoX0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B05BC4CEE5;
	Mon, 10 Mar 2025 17:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627326;
	bh=5wUBcl3z/WZGyTd0FiOdtpYRmdrNOrX8HNbT9MBb8wA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ECDoX0fGfj3jlQwXLVNKxJGc5x+Y2PaGM/rtkdlVCCfN5FuWN+NgWCvtXupRyl1D
	 pvsCCS/7G1quwnFh6X3nBtPJvjjrtCEO6gyZf6EQYFxBqfABUllIl/K2YKULJ18F3l
	 WcfPjrL1hLR6v3eh5UdgZRppccNAO4wBdh48aE9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 092/269] ALSA: hda/realtek: update ALC222 depop optimize
Date: Mon, 10 Mar 2025 18:04:05 +0100
Message-ID: <20250310170501.379339036@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit ca0dedaff92307591f66c9206933fbdfe87add10 upstream.

Add ALC222 its own depop functions for alc_init and alc_shutup.

[note: this fixes pop noise issues on the models with two headphone
 jacks -- tiwai ]

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   76 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3845,6 +3845,79 @@ static void alc225_shutup(struct hda_cod
 	}
 }
 
+static void alc222_init(struct hda_codec *codec)
+{
+	struct alc_spec *spec = codec->spec;
+	hda_nid_t hp_pin = alc_get_hp_pin(spec);
+	bool hp1_pin_sense, hp2_pin_sense;
+
+	if (!hp_pin)
+		return;
+
+	msleep(30);
+
+	hp1_pin_sense = snd_hda_jack_detect(codec, hp_pin);
+	hp2_pin_sense = snd_hda_jack_detect(codec, 0x14);
+
+	if (hp1_pin_sense || hp2_pin_sense) {
+		msleep(2);
+
+		if (hp1_pin_sense)
+			snd_hda_codec_write(codec, hp_pin, 0,
+				    AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT);
+		if (hp2_pin_sense)
+			snd_hda_codec_write(codec, 0x14, 0,
+				    AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT);
+		msleep(75);
+
+		if (hp1_pin_sense)
+			snd_hda_codec_write(codec, hp_pin, 0,
+				    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE);
+		if (hp2_pin_sense)
+			snd_hda_codec_write(codec, 0x14, 0,
+				    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE);
+
+		msleep(75);
+	}
+}
+
+static void alc222_shutup(struct hda_codec *codec)
+{
+	struct alc_spec *spec = codec->spec;
+	hda_nid_t hp_pin = alc_get_hp_pin(spec);
+	bool hp1_pin_sense, hp2_pin_sense;
+
+	if (!hp_pin)
+		hp_pin = 0x21;
+
+	hp1_pin_sense = snd_hda_jack_detect(codec, hp_pin);
+	hp2_pin_sense = snd_hda_jack_detect(codec, 0x14);
+
+	if (hp1_pin_sense || hp2_pin_sense) {
+		msleep(2);
+
+		if (hp1_pin_sense)
+			snd_hda_codec_write(codec, hp_pin, 0,
+				    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE);
+		if (hp2_pin_sense)
+			snd_hda_codec_write(codec, 0x14, 0,
+				    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE);
+
+		msleep(75);
+
+		if (hp1_pin_sense)
+			snd_hda_codec_write(codec, hp_pin, 0,
+				    AC_VERB_SET_PIN_WIDGET_CONTROL, 0x0);
+		if (hp2_pin_sense)
+			snd_hda_codec_write(codec, 0x14, 0,
+				    AC_VERB_SET_PIN_WIDGET_CONTROL, 0x0);
+
+		msleep(75);
+	}
+	alc_auto_setup_eapd(codec, false);
+	alc_shutup_pins(codec);
+}
+
 static void alc_default_init(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
@@ -11856,8 +11929,11 @@ static int patch_alc269(struct hda_codec
 		spec->codec_variant = ALC269_TYPE_ALC300;
 		spec->gen.mixer_nid = 0; /* no loopback on ALC300 */
 		break;
+	case 0x10ec0222:
 	case 0x10ec0623:
 		spec->codec_variant = ALC269_TYPE_ALC623;
+		spec->shutup = alc222_shutup;
+		spec->init_hook = alc222_init;
 		break;
 	case 0x10ec0700:
 	case 0x10ec0701:


