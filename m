Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8043915AC5
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:51:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00627C433C7;
	Tue, 25 Jul 2023 10:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282310;
	bh=oJGWT27rp3FxOi80Utut0owPSONAljeUEAlP0O5vah8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KHW8CI0NRxqnN+RnrK3WD3w4xUrVoGK0X3cCb+eq1kve4rSEVL9dQ+6jZUhW93rep
	 kRxA0uosTMoL7XZIbS+TvW/yG83YB+7LvxbSv4nTsgmTQmkZsntR2tJRyFyQNuLBFb
	 ReJKwTFDqypuFY1B+HcgLKjVQbd43rfuTLIxRSLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Anderson <ruinairas1992@gmail.com>,
	Philip Mueller <philm@manjaro.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 083/227] [PATCH AUTOSEL 5.4 08/12] ALSA: hda/realtek: Add quirks for ROG ALLY CS35l41 audio
Date: Tue, 25 Jul 2023 12:44:10 +0200
Message-ID: <20230725104518.185233473@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

[ Upstream commit 724418b84e6248cd27599607b7e5fac365b8e3f5 ]

This requires a patched ACPI table or a firmware from ASUS to work because
the system does not come with the _DSD field for the CSC3551.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217550
Signed-off-by: Matthew Anderson <ruinairas1992@gmail.com>
Tested-by: Philip Mueller <philm@manjaro.org>
Link: https://lore.kernel.org/r/20230621161714.9442-1-ruinairas1992@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c |   46 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7136,6 +7136,10 @@ enum {
 	ALC294_FIXUP_ASUS_DUAL_SPK,
 	ALC285_FIXUP_THINKPAD_X1_GEN7,
 	ALC285_FIXUP_THINKPAD_HEADSET_JACK,
+	ALC294_FIXUP_ASUS_ALLY,
+	ALC294_FIXUP_ASUS_ALLY_PINS,
+	ALC294_FIXUP_ASUS_ALLY_VERBS,
+	ALC294_FIXUP_ASUS_ALLY_SPEAKER,
 	ALC294_FIXUP_ASUS_HPE,
 	ALC294_FIXUP_ASUS_COEF_1B,
 	ALC294_FIXUP_ASUS_GX502_HP,
@@ -8449,6 +8453,47 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC294_FIXUP_SPK2_TO_DAC1
 	},
+	[ALC294_FIXUP_ASUS_ALLY] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = cs35l41_fixup_i2c_two,
+		.chained = true,
+		.chain_id = ALC294_FIXUP_ASUS_ALLY_PINS
+	},
+	[ALC294_FIXUP_ASUS_ALLY_PINS] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x03a11050 },
+			{ 0x1a, 0x03a11c30 },
+			{ 0x21, 0x03211420 },
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC294_FIXUP_ASUS_ALLY_VERBS
+	},
+	[ALC294_FIXUP_ASUS_ALLY_VERBS] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x45 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x5089 },
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x46 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x0004 },
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x47 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0xa47a },
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x49 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x0049},
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x4a },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x201b },
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x6b },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x4278},
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC294_FIXUP_ASUS_ALLY_SPEAKER
+	},
+	[ALC294_FIXUP_ASUS_ALLY_SPEAKER] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc285_fixup_speaker2_to_dac1,
+	},
 	[ALC285_FIXUP_THINKPAD_X1_GEN7] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc285_fixup_thinkpad_x1_gen7,
@@ -9557,6 +9602,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x16e3, "ASUS UX50", ALC269_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x1740, "ASUS UX430UA", ALC295_FIXUP_ASUS_DACS),
 	SND_PCI_QUIRK(0x1043, 0x17d1, "ASUS UX431FL", ALC294_FIXUP_ASUS_DUAL_SPK),
+	SND_PCI_QUIRK(0x1043, 0x17f3, "ROG Ally RC71L_RC71L", ALC294_FIXUP_ASUS_ALLY),
 	SND_PCI_QUIRK(0x1043, 0x1881, "ASUS Zephyrus S/M", ALC294_FIXUP_ASUS_GX502_PINS),
 	SND_PCI_QUIRK(0x1043, 0x18b1, "Asus MJ401TA", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x18f1, "Asus FX505DT", ALC256_FIXUP_ASUS_HEADSET_MIC),


