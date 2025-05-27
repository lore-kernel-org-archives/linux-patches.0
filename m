Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F057194A67;
	Tue, 27 May 2025 16:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365143; cv=none; b=Rrmc5drtW4e+YCp1Kc+YHYvxv4CU4/YDqWAHDU3wpRqceIlGhvUodqqjzH5VB0pSxOCFFCb0Zi9DFxKgfUuIQBYM4CbyPPkp1pPdnNRzSLosfLqdAHXH847CLUZF1fHuA0fGzxbXtcu+8qiwfK8pPNmF99WwOZaN02J1tuDCaXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365143; c=relaxed/simple;
	bh=4TFcD+TKH1b7Y9cVJQ9+o+3RJjGTaBdVl/vEZrVcPzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+Ouo7G5ZL/3YYNxghMX/cEWB0unWQ2fKR9LxG053Rl1VCrfCWGcPR1Xo25+zBEBZimc/VDMuDQgrY306H3TgIG8u5QoSzlyLWVIBPlB6LtHL1CMMjso5ZF0PuhfsUrs4Gr4rmUWH/WUpt4mPCLiJI3rmz3ZZ4pM3h1cLk8aa68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A57oaZus; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A57oaZus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069A8C4CEEB;
	Tue, 27 May 2025 16:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365143;
	bh=4TFcD+TKH1b7Y9cVJQ9+o+3RJjGTaBdVl/vEZrVcPzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A57oaZusUP+Ec3TiJcdxbvuzK+T8PzaeefTkG10B/0dujHZjFiyPqD/PyttGiRgrL
	 /Y5MRUACap/830zXyrl970IhWLSdi5WygXFhXQtIFrohdP36kLPJPdaI/daGqMRZAP
	 lFIWKOnSvvFFSJeO6W0NGFHWamr4K7z9au1r/8DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
	kailang@realtek.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 250/626] ALSA: hda/realtek: Enable PC beep passthrough for HP EliteBook 855 G7
Date: Tue, 27 May 2025 18:22:23 +0200
Message-ID: <20250527162455.169304384@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Maciej S. Szmigiero <mail@maciej.szmigiero.name>

[ Upstream commit aa85822c611aef7cd4dc17d27121d43e21bb82f0 ]

PC speaker works well on this platform in BIOS and in Linux until sound
card drivers are loaded. Then it stops working.

There seems to be a beep generator node at 0x1a in this CODEC
(ALC269_TYPE_ALC215) but it seems to be only connected to capture mixers
at nodes 0x22 and 0x23.
If I unmute the mixer input for 0x1a at node 0x23 and start recording
from its "ALC285 Analog" capture device I can clearly hear beeps in that
recording.

So the beep generator is indeed working properly, however I wasn't able to
figure out any way to connect it to speakers.

However, the bits in the "Passthrough Control" register (0x36) seems to
work at least partially: by zeroing "B" and "h" and setting "S" I can at
least make the PIT PC speaker output appear either in this laptop speakers
or headphones (depending on whether they are connected or not).

There are some caveats, however:
* If the CODEC gets runtime-suspended the beeps stop so it needs HDA beep
device for keeping it awake during beeping.

* If the beep generator node is generating any beep the PC beep passthrough
seems to be temporarily inhibited, so the HDA beep device has to be
prevented from using the actual beep generator node - but the beep device
is still necessary due to the previous point.

* In contrast with other platforms here beep amplification has to be
disabled otherwise the beeps output are WAY louder than they were on pure
BIOS setup.

Unless someone (from Realtek probably) knows how to make the beep generator
node output appear in speakers / headphones using PC beep passthrough seems
to be the only way to make PC speaker beeping actually work on this
platform.

Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
Acked-by: kailang@realtek.com
Link: https://patch.msgid.link/7461f695b4daed80f2fc4b1463ead47f04f9ad05.1739741254.git.mail@maciej.szmigiero.name
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hda_codec.h     |  1 +
 sound/pci/hda/hda_beep.c      | 15 +++++++++------
 sound/pci/hda/patch_realtek.c | 34 +++++++++++++++++++++++++++++++++-
 3 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/include/sound/hda_codec.h b/include/sound/hda_codec.h
index 575e55aa08ca9..c1fe6290d04dc 100644
--- a/include/sound/hda_codec.h
+++ b/include/sound/hda_codec.h
@@ -195,6 +195,7 @@ struct hda_codec {
 	/* beep device */
 	struct hda_beep *beep;
 	unsigned int beep_mode;
+	bool beep_just_power_on;
 
 	/* widget capabilities cache */
 	u32 *wcaps;
diff --git a/sound/pci/hda/hda_beep.c b/sound/pci/hda/hda_beep.c
index e51d475725576..13a7d92e8d8d0 100644
--- a/sound/pci/hda/hda_beep.c
+++ b/sound/pci/hda/hda_beep.c
@@ -31,8 +31,9 @@ static void generate_tone(struct hda_beep *beep, int tone)
 			beep->power_hook(beep, true);
 		beep->playing = 1;
 	}
-	snd_hda_codec_write(codec, beep->nid, 0,
-			    AC_VERB_SET_BEEP_CONTROL, tone);
+	if (!codec->beep_just_power_on)
+		snd_hda_codec_write(codec, beep->nid, 0,
+				    AC_VERB_SET_BEEP_CONTROL, tone);
 	if (!tone && beep->playing) {
 		beep->playing = 0;
 		if (beep->power_hook)
@@ -212,10 +213,12 @@ int snd_hda_attach_beep_device(struct hda_codec *codec, int nid)
 	struct hda_beep *beep;
 	int err;
 
-	if (!snd_hda_get_bool_hint(codec, "beep"))
-		return 0; /* disabled explicitly by hints */
-	if (codec->beep_mode == HDA_BEEP_MODE_OFF)
-		return 0; /* disabled by module option */
+	if (!codec->beep_just_power_on) {
+		if (!snd_hda_get_bool_hint(codec, "beep"))
+			return 0; /* disabled explicitly by hints */
+		if (codec->beep_mode == HDA_BEEP_MODE_OFF)
+			return 0; /* disabled by module option */
+	}
 
 	beep = kzalloc(sizeof(*beep), GFP_KERNEL);
 	if (beep == NULL)
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index db72c5fce9d18..0b243adac8cf4 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -28,6 +28,7 @@
 #include <sound/hda_codec.h>
 #include "hda_local.h"
 #include "hda_auto_parser.h"
+#include "hda_beep.h"
 #include "hda_jack.h"
 #include "hda_generic.h"
 #include "hda_component.h"
@@ -7036,6 +7037,30 @@ static void alc285_fixup_hp_envy_x360(struct hda_codec *codec,
 	}
 }
 
+static void alc285_fixup_hp_beep(struct hda_codec *codec,
+				 const struct hda_fixup *fix, int action)
+{
+	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
+		codec->beep_just_power_on = true;
+	} else  if (action == HDA_FIXUP_ACT_INIT) {
+#ifdef CONFIG_SND_HDA_INPUT_BEEP
+		/*
+		 * Just enable loopback to internal speaker and headphone jack.
+		 * Disable amplification to get about the same beep volume as
+		 * was on pure BIOS setup before loading the driver.
+		 */
+		alc_update_coef_idx(codec, 0x36, 0x7070, BIT(13));
+
+		snd_hda_enable_beep_device(codec, 1);
+
+#if !IS_ENABLED(CONFIG_INPUT_PCSPKR)
+		dev_warn_once(hda_codec_dev(codec),
+			      "enable CONFIG_INPUT_PCSPKR to get PC beeps\n");
+#endif
+#endif
+	}
+}
+
 /* for hda_fixup_thinkpad_acpi() */
 #include "thinkpad_helper.c"
 
@@ -7806,6 +7831,7 @@ enum {
 	ALC285_FIXUP_HP_GPIO_LED,
 	ALC285_FIXUP_HP_MUTE_LED,
 	ALC285_FIXUP_HP_SPECTRE_X360_MUTE_LED,
+	ALC285_FIXUP_HP_BEEP_MICMUTE_LED,
 	ALC236_FIXUP_HP_MUTE_LED_COEFBIT2,
 	ALC236_FIXUP_HP_GPIO_LED,
 	ALC236_FIXUP_HP_MUTE_LED,
@@ -9395,6 +9421,12 @@ static const struct hda_fixup alc269_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc285_fixup_hp_spectre_x360_mute_led,
 	},
+	[ALC285_FIXUP_HP_BEEP_MICMUTE_LED] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc285_fixup_hp_beep,
+		.chained = true,
+		.chain_id = ALC285_FIXUP_HP_MUTE_LED,
+	},
 	[ALC236_FIXUP_HP_MUTE_LED_COEFBIT2] = {
 	    .type = HDA_FIXUP_FUNC,
 	    .v.func = alc236_fixup_hp_mute_led_coefbit2,
@@ -10493,7 +10525,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8730, "HP ProBook 445 G7", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8735, "HP ProBook 435 G7", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8736, "HP", ALC285_FIXUP_HP_GPIO_AMP_INIT),
-	SND_PCI_QUIRK(0x103c, 0x8760, "HP", ALC285_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x8760, "HP EliteBook 8{4,5}5 G7", ALC285_FIXUP_HP_BEEP_MICMUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x876e, "HP ENVY x360 Convertible 13-ay0xxx", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x877a, "HP", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x877d, "HP", ALC236_FIXUP_HP_MUTE_LED),
-- 
2.39.5



