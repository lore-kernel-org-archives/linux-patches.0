Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4257EAD49
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38B1C433D2;
	Wed,  4 Jan 2023 16:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672848930;
	bh=59FoIJJEj1zXitnIfp5A/dGlTwWq386wOIRx46/yFto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dcm500dHeGFsS5Djc+lvHnghA9Qn3WjtTEnNBuaRSNpADaqOAbgG6azC1o0799jE+
	 rGHFofuytt+jWQoizrr/FxsfMwjLpMp7z1sYmoxHGfW06SdaM1QNaWHRArrQqcUJJt
	 /7Qwyz6KtWB4O5fE7EYVOh4QHwSiRTGYFkMP0TKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Jungkamp <p.jungkamp@gmx.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 036/177] ALSA: patch_realtek: Fix Dell Inspiron Plus 16
Date: Wed,  4 Jan 2023 17:05:27 +0100
Message-Id: <20230104160508.754980123@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Philipp Jungkamp <p.jungkamp@gmx.net>

[ Upstream commit 2912cdda734d9136615ed05636d9fcbca2a7a3c5 ]

The Dell Inspiron Plus 16, in both laptop and 2in1 form factor, has top
speakers connected on NID 0x17, which the codec reports as unconnected.
These speakers should be connected to the DAC on NID 0x03.

Signed-off-by: Philipp Jungkamp <p.jungkamp@gmx.net>
Link: https://lore.kernel.org/r/20221205163713.7476-1-p.jungkamp@gmx.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: a4517c4f3423 ("ALSA: hda/realtek: Apply dual codec fixup for Dell Latitude laptops")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 37 +++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 94fe84217894..d2f122833830 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6925,6 +6925,34 @@ static void alc287_fixup_yoga9_14iap7_bass_spk_pin(struct hda_codec *codec,
 	}
 }
 
+static void alc295_fixup_dell_inspiron_top_speakers(struct hda_codec *codec,
+					  const struct hda_fixup *fix, int action)
+{
+	static const struct hda_pintbl pincfgs[] = {
+		{ 0x14, 0x90170151 },
+		{ 0x17, 0x90170150 },
+		{ }
+	};
+	static const hda_nid_t conn[] = { 0x02, 0x03 };
+	static const hda_nid_t preferred_pairs[] = {
+		0x14, 0x02,
+		0x17, 0x03,
+		0x21, 0x02,
+		0
+	};
+	struct alc_spec *spec = codec->spec;
+
+	alc_fixup_no_shutup(codec, fix, action);
+
+	switch (action) {
+	case HDA_FIXUP_ACT_PRE_PROBE:
+		snd_hda_apply_pincfgs(codec, pincfgs);
+		snd_hda_override_conn_list(codec, 0x17, ARRAY_SIZE(conn), conn);
+		spec->gen.preferred_dacs = preferred_pairs;
+		break;
+	}
+}
+
 enum {
 	ALC269_FIXUP_GPIO2,
 	ALC269_FIXUP_SONY_VAIO,
@@ -7168,6 +7196,7 @@ enum {
 	ALC287_FIXUP_LEGION_16ITHG6,
 	ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK,
 	ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN,
+	ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -9117,6 +9146,12 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK,
 	},
+	[ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc295_fixup_dell_inspiron_top_speakers,
+		.chained = true,
+		.chain_id = ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -9217,6 +9252,8 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x0a9e, "Dell Latitude 5430", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0b19, "Dell XPS 15 9520", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x0b1a, "Dell Precision 5570", ALC289_FIXUP_DUAL_SPK),
+	SND_PCI_QUIRK(0x1028, 0x0b37, "Dell Inspiron 16 Plus 7620 2-in-1", ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS),
+	SND_PCI_QUIRK(0x1028, 0x0b71, "Dell Inspiron 16 Plus 7620", ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS),
 	SND_PCI_QUIRK(0x1028, 0x164a, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x164b, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1586, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC2),
-- 
2.35.1



