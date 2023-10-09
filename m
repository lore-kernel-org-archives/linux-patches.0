Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59930199B1
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d436xI/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7638C433C9;
	Mon,  9 Oct 2023 13:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857346;
	bh=lS8nt3SlMj51xfXWOCpwmrPU3ihyu2Ffi9FtA2mRcWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d436xI/QbgGOPcKNm0aHq7LzF6dJFOWH9mYGR27xcY7kdjg7qJGu1I2gPR0Mjhltw
	 AvdyaAke4t6K6SsQL7ia7fsXyTQMIoD9RN0sx/XB7iB+B6YK2XpMW9U2TYIEykzFpO
	 m3aXvcfUbuUC9UZWfpRP4J6LKTGMIS5Y9WYog+0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SungHwan Jung <onenowy@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/162] ALSA: hda/realtek: Add quirk for HP Victus 16-d1xxx to enable mute LED
Date: Mon,  9 Oct 2023 14:59:45 +0200
Message-ID: <20231009130123.071240045@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

From: SungHwan Jung <onenowy@gmail.com>

[ Upstream commit 93dc18e11b1ab2d485b69f91c973e6b83e47ebd0 ]

This quirk enables mute LED on HP Victus 16-d1xxx (8A25) laptops, which
use ALC245 codec.

Signed-off-by: SungHwan Jung <onenowy@gmail.com>
Link: https://lore.kernel.org/r/20230823114051.3921-1-onenowy@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 41b07476da38 ("ALSA: hda/realtek - ALC287 Realtek I2S speaker platform support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 7d549229d0b95..e81bc0c026eba 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4639,6 +4639,22 @@ static void alc236_fixup_hp_mute_led_coefbit2(struct hda_codec *codec,
 	}
 }
 
+static void alc245_fixup_hp_mute_led_coefbit(struct hda_codec *codec,
+					  const struct hda_fixup *fix,
+					  int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
+		spec->mute_led_polarity = 0;
+		spec->mute_led_coef.idx = 0x0b;
+		spec->mute_led_coef.mask = 3 << 2;
+		spec->mute_led_coef.on = 2 << 2;
+		spec->mute_led_coef.off = 1 << 2;
+		snd_hda_gen_add_mute_led_cdev(codec, coef_mute_led_set);
+	}
+}
+
 /* turn on/off mic-mute LED per capture hook by coef bit */
 static int coef_micmute_led_set(struct led_classdev *led_cdev,
 				enum led_brightness brightness)
@@ -7289,6 +7305,7 @@ enum {
 	ALC236_FIXUP_DELL_DUAL_CODECS,
 	ALC287_FIXUP_CS35L41_I2C_2_THINKPAD_ACPI,
 	ALC287_FIXUP_TAS2781_I2C,
+	ALC245_FIXUP_HP_MUTE_LED_COEFBIT,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -9364,6 +9381,10 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC269_FIXUP_THINKPAD_ACPI,
 	},
+	[ALC245_FIXUP_HP_MUTE_LED_COEFBIT] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc245_fixup_hp_mute_led_coefbit,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -9630,6 +9651,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x89c6, "Zbook Fury 17 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x89ca, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x89d3, "HP EliteBook 645 G9 (MB 89D2)", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8a25, "HP Victus 16-d1xxx (MB 8A25)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8a78, "HP Dev One", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x103c, 0x8aa0, "HP ProBook 440 G9 (MB 8A9E)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8aa3, "HP ProBook 450 G9 (MB 8AA1)", ALC236_FIXUP_HP_GPIO_LED),
-- 
2.40.1



