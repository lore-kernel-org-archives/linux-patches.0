Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D130A3A8F4
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JSX/qTl4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CF4C433C8;
	Wed, 15 Nov 2023 19:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077905;
	bh=wY4KKMCvOEt/uvf/zM+tto7SXHEL6MjXhfYxNbUvsEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JSX/qTl4vbMTVMlR+gBcHj7LmlyAKj/g2Et2i3BcU5hvTUnRvEHsKtdqmuB3I03Io
	 ZBx5e8LDk8j8MIhENTBCaBXAutMuZEjVZHo78bXJfarCI3IfXVS28kHy9fpBjk3CZ+
	 2hvQlLVWeVjPK0qn8uHxpnn4PGFPjiZ3qKICK25A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 592/603] ALSA: hda/realtek: Add support dual speaker for Dell
Date: Wed, 15 Nov 2023 14:18:57 -0500
Message-ID: <20231115191652.178300070@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit f0d9da19d7de9e845e7a93a901c4b9658df6b492 ]

Dell new platform support dual speaker. But BIOS verb table only show one speaker.
It will fill verb table for second speaker. Then bind with CS AMP model.

Fixes: de90f5165b1c ("ALSA: hda/realtek: Add support for DELL Oasis 13/14/16 laptops")
Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/r/4dd390a77bf742b8a518ac2deee00b0f@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 40 +++++++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 9677c09cf7a98..3ed2cba5ee8ad 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7262,8 +7262,10 @@ enum {
 	ALC256_FIXUP_ASUS_MIC_NO_PRESENCE,
 	ALC299_FIXUP_PREDATOR_SPK,
 	ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE,
+	ALC289_FIXUP_DELL_SPK1,
 	ALC289_FIXUP_DELL_SPK2,
 	ALC289_FIXUP_DUAL_SPK,
+	ALC289_FIXUP_RTK_AMP_DUAL_SPK,
 	ALC294_FIXUP_SPK2_TO_DAC1,
 	ALC294_FIXUP_ASUS_DUAL_SPK,
 	ALC285_FIXUP_THINKPAD_X1_GEN7,
@@ -7363,6 +7365,7 @@ enum {
 	ALC287_FIXUP_THINKPAD_I2S_SPK,
 	ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD,
 	ALC2XX_FIXUP_HEADSET_MIC,
+	ALC289_FIXUP_DELL_CS35L41_SPI_2,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -8589,6 +8592,15 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC256_FIXUP_ASUS_HEADSET_MODE
 	},
+	[ALC289_FIXUP_DELL_SPK1] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x14, 0x90170140 },
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC269_FIXUP_DELL4_MIC_NO_PRESENCE
+	},
 	[ALC289_FIXUP_DELL_SPK2] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -8604,6 +8616,12 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC289_FIXUP_DELL_SPK2
 	},
+	[ALC289_FIXUP_RTK_AMP_DUAL_SPK] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc285_fixup_speaker2_to_dac1,
+		.chained = true,
+		.chain_id = ALC289_FIXUP_DELL_SPK1
+	},
 	[ALC294_FIXUP_SPK2_TO_DAC1] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc285_fixup_speaker2_to_dac1,
@@ -9471,6 +9489,12 @@ static const struct hda_fixup alc269_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc_fixup_headset_mic,
 	},
+	[ALC289_FIXUP_DELL_CS35L41_SPI_2] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = cs35l41_fixup_spi_two,
+		.chained = true,
+		.chain_id = ALC289_FIXUP_DUAL_SPK
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -9581,13 +9605,15 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x0c1c, "Dell Precision 3540", ALC236_FIXUP_DELL_DUAL_CODECS),
 	SND_PCI_QUIRK(0x1028, 0x0c1d, "Dell Precision 3440", ALC236_FIXUP_DELL_DUAL_CODECS),
 	SND_PCI_QUIRK(0x1028, 0x0c1e, "Dell Precision 3540", ALC236_FIXUP_DELL_DUAL_CODECS),
-	SND_PCI_QUIRK(0x1028, 0x0cbd, "Dell Oasis 13 CS MTL-U", ALC245_FIXUP_CS35L41_SPI_2),
-	SND_PCI_QUIRK(0x1028, 0x0cbe, "Dell Oasis 13 2-IN-1 MTL-U", ALC245_FIXUP_CS35L41_SPI_2),
-	SND_PCI_QUIRK(0x1028, 0x0cbf, "Dell Oasis 13 Low Weight MTU-L", ALC245_FIXUP_CS35L41_SPI_2),
-	SND_PCI_QUIRK(0x1028, 0x0cc1, "Dell Oasis 14 MTL-H/U", ALC245_FIXUP_CS35L41_SPI_2),
-	SND_PCI_QUIRK(0x1028, 0x0cc2, "Dell Oasis 14 2-in-1 MTL-H/U", ALC245_FIXUP_CS35L41_SPI_2),
-	SND_PCI_QUIRK(0x1028, 0x0cc3, "Dell Oasis 14 Low Weight MTL-U", ALC245_FIXUP_CS35L41_SPI_2),
-	SND_PCI_QUIRK(0x1028, 0x0cc4, "Dell Oasis 16 MTL-H/U", ALC245_FIXUP_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1028, 0x0cbd, "Dell Oasis 13 CS MTL-U", ALC289_FIXUP_DELL_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1028, 0x0cbe, "Dell Oasis 13 2-IN-1 MTL-U", ALC289_FIXUP_DELL_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1028, 0x0cbf, "Dell Oasis 13 Low Weight MTU-L", ALC289_FIXUP_DELL_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1028, 0x0cc0, "Dell Oasis 13", ALC289_FIXUP_RTK_AMP_DUAL_SPK),
+	SND_PCI_QUIRK(0x1028, 0x0cc1, "Dell Oasis 14 MTL-H/U", ALC289_FIXUP_DELL_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1028, 0x0cc2, "Dell Oasis 14 2-in-1 MTL-H/U", ALC289_FIXUP_DELL_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1028, 0x0cc3, "Dell Oasis 14 Low Weight MTL-U", ALC289_FIXUP_DELL_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1028, 0x0cc4, "Dell Oasis 16 MTL-H/U", ALC289_FIXUP_DELL_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1028, 0x0cc5, "Dell Oasis 14", ALC289_FIXUP_RTK_AMP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x164a, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x164b, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1586, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC2),
-- 
2.42.0



