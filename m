Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FBA1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:32:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDDEC433C7;
	Tue, 25 Jul 2023 11:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284755;
	bh=sCoQrF7gS+7+s61ZCyrSgQOLRLxmGESyrD8tTdjWuPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fD/iKUMq1Vj4BkmN5h6OZCu7MAO2Ea5y6z3G2sae3h8vzIgw38VeTjhVekQsBXzTm
	 AvEFHnvysut9zzbBdgNehl/nNnvD7/Hp6fSNJ0iDuh8Df7JgIn2Cl1N1yLbxrmGP2R
	 rRAycQYSTwp4aoFgzZ5cZctJdC/mEgVcxTWT6o2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luka Guzenko <l.guzenko@web.de>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 441/509] ALSA: hda/realtek: Enable Mute LED on HP Laptop 15s-eq2xxx
Date: Tue, 25 Jul 2023 12:46:20 +0200
Message-ID: <20230725104613.934180357@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luka Guzenko <l.guzenko@web.de>

commit 0659400f18c0e6c0c69d74fe5d09e7f6fbbd52a2 upstream.

The HP Laptop 15s-eq2xxx uses ALC236 codec and controls the mute LED using
COEF 0x07 index 1. No existing quirk covers this configuration.
Adds a new quirk and enables it for the device.

Signed-off-by: Luka Guzenko <l.guzenko@web.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230718161241.393181-1-l.guzenko@web.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4559,6 +4559,21 @@ static void alc236_fixup_hp_mute_led_coe
 	}
 }
 
+static void alc236_fixup_hp_mute_led_coefbit2(struct hda_codec *codec,
+					  const struct hda_fixup *fix, int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
+		spec->mute_led_polarity = 0;
+		spec->mute_led_coef.idx = 0x07;
+		spec->mute_led_coef.mask = 1;
+		spec->mute_led_coef.on = 1;
+		spec->mute_led_coef.off = 0;
+		snd_hda_gen_add_mute_led_cdev(codec, coef_mute_led_set);
+	}
+}
+
 /* turn on/off mic-mute LED per capture hook by coef bit */
 static int coef_micmute_led_set(struct led_classdev *led_cdev,
 				enum led_brightness brightness)
@@ -6878,6 +6893,7 @@ enum {
 	ALC285_FIXUP_HP_GPIO_LED,
 	ALC285_FIXUP_HP_MUTE_LED,
 	ALC285_FIXUP_HP_SPECTRE_X360_MUTE_LED,
+	ALC236_FIXUP_HP_MUTE_LED_COEFBIT2,
 	ALC236_FIXUP_HP_GPIO_LED,
 	ALC236_FIXUP_HP_MUTE_LED,
 	ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF,
@@ -8250,6 +8266,10 @@ static const struct hda_fixup alc269_fix
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc285_fixup_hp_spectre_x360_mute_led,
 	},
+	[ALC236_FIXUP_HP_MUTE_LED_COEFBIT2] = {
+	    .type = HDA_FIXUP_FUNC,
+	    .v.func = alc236_fixup_hp_mute_led_coefbit2,
+	},
 	[ALC236_FIXUP_HP_GPIO_LED] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc236_fixup_hp_gpio_led,
@@ -9004,6 +9024,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x886d, "HP ZBook Fury 17.3 Inch G8 Mobile Workstation PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8870, "HP ZBook Fury 15.6 Inch G8 Mobile Workstation PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8873, "HP ZBook Studio 15.6 Inch G8 Mobile Workstation PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
+	SND_PCI_QUIRK(0x103c, 0x887a, "HP Laptop 15s-eq2xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x888d, "HP ZBook Power 15.6 inch G8 Mobile Workstation PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8895, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_SPEAKERS_MICMUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8896, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_MUTE_LED),


