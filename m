Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1886FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D58C433D2;
	Tue, 10 Jan 2023 18:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375089;
	bh=sVh5f78YFyFM5ve39ol/U1lRIpkjMfBJAHGHZ4yXHTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vbk8PTOxd5GYU/cjhYwDL7gcSurdJPDWex7eKtxPmFOqWBVTXu1e6nZnjftwE1ibH
	 E/mTtRTcdLSE9F0I/OtMc1229Zmrl4tqZywXBa61YiD5AGTcznZNsbWSuYUq8Nh073
	 wDrFSUIPEVztdzjYYDsyn3mlKHlxAhgotV/OeIqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Jungkamp <p.jungkamp@gmx.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/290] ALSA: patch_realtek: Fix Dell Inspiron Plus 16
Date: Tue, 10 Jan 2023 19:02:47 +0100
Message-Id: <20230110180034.225892754@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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
index 79c65da1b4ee..f74c49987f1a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6709,6 +6709,34 @@ static void alc256_fixup_mic_no_presence_and_resume(struct hda_codec *codec,
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
@@ -6940,6 +6968,7 @@ enum {
 	ALC285_FIXUP_LEGION_Y9000X_SPEAKERS,
 	ALC285_FIXUP_LEGION_Y9000X_AUTOMUTE,
 	ALC285_FIXUP_HP_SPEAKERS_MICMUTE_LED,
+	ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -8766,6 +8795,12 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC285_FIXUP_HP_MUTE_LED,
 	},
+	[ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc295_fixup_dell_inspiron_top_speakers,
+		.chained = true,
+		.chain_id = ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -8865,6 +8900,8 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
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



