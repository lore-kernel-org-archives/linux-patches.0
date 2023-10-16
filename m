Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F200200D5
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nhCXzATX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C68C433C8;
	Mon, 16 Oct 2023 14:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467546;
	bh=7+Y/Dk9DGt6h6IQ5JJ2EOzJ7pNKZQdr30b1vvE95UXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nhCXzATXFoX/9sRYwdthENafOvcxq/WA4DD6hNlk0ivIWDKUSkJcyasfR3WBhbaZT
	 0cI3xTIurnY1aHU95VOCBPqVKiL0EMWbOktkBjUniFBd1PK+0JxcWNOUgKoMbtZQaV
	 7hir1E4TP5BcDOsxAEnmQWpKBVMI5cN/yPA2fe4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson@lenovo.com>,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 040/191] ALSA: hda/realtek - ALC287 I2S speaker platform support
Date: Mon, 16 Oct 2023 10:40:25 +0200
Message-ID: <20231016084016.344673255@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit e43252db7e207a2e194e6a4883a43a31a776a968 ]

0x17 was only speaker pin, DAC assigned will be 0x03. Headphone
assigned to 0x02.
Playback via headphone will get EQ filter processing. So,it needs to
swap DAC.

Tested-by: Mark Pearson <mpearson@lenovo.com>
Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/r/4e4cfa1b3b4c46838aecafc6e8b6f876@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: d93eeca627db ("ALSA: hda/realtek - ALC287 merge RTK codec with CS CS35L41 AMP")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index bcb48449608a0..963465286bdc6 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6988,6 +6988,27 @@ static void alc295_fixup_dell_inspiron_top_speakers(struct hda_codec *codec,
 	}
 }
 
+/* Forcibly assign NID 0x03 to HP while NID 0x02 to SPK */
+static void alc287_fixup_bind_dacs(struct hda_codec *codec,
+				    const struct hda_fixup *fix, int action)
+{
+	struct alc_spec *spec = codec->spec;
+	static const hda_nid_t conn[] = { 0x02, 0x03 }; /* exclude 0x06 */
+	static const hda_nid_t preferred_pairs[] = {
+		0x17, 0x02, 0x21, 0x03, 0
+	};
+
+	if (action != HDA_FIXUP_ACT_PRE_PROBE)
+		return;
+
+	snd_hda_override_conn_list(codec, 0x17, ARRAY_SIZE(conn), conn);
+	spec->gen.preferred_dacs = preferred_pairs;
+	spec->gen.auto_mute_via_amp = 1;
+	snd_hda_codec_write_cache(codec, 0x14, 0, AC_VERB_SET_PIN_WIDGET_CONTROL,
+			    0x0); /* Make sure 0x14 was disable */
+}
+
+
 enum {
 	ALC269_FIXUP_GPIO2,
 	ALC269_FIXUP_SONY_VAIO,
@@ -7249,6 +7270,7 @@ enum {
 	ALC287_FIXUP_CS35L41_I2C_2_THINKPAD_ACPI,
 	ALC245_FIXUP_HP_MUTE_LED_COEFBIT,
 	ALC245_FIXUP_HP_X360_MUTE_LEDS,
+	ALC287_FIXUP_THINKPAD_I2S_SPK,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -9337,6 +9359,10 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC245_FIXUP_HP_GPIO_LED
 	},
+	[ALC287_FIXUP_THINKPAD_I2S_SPK] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc287_fixup_bind_dacs,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -10455,6 +10481,10 @@ static const struct snd_hda_pin_quirk alc269_pin_fixup_tbl[] = {
 		{0x17, 0x90170111},
 		{0x19, 0x03a11030},
 		{0x21, 0x03211020}),
+	SND_HDA_PIN_QUIRK(0x10ec0287, 0x17aa, "Lenovo", ALC287_FIXUP_THINKPAD_I2S_SPK,
+		{0x17, 0x90170110},
+		{0x19, 0x03a11030},
+		{0x21, 0x03211020}),
 	SND_HDA_PIN_QUIRK(0x10ec0286, 0x1025, "Acer", ALC286_FIXUP_ACER_AIO_MIC_NO_PRESENCE,
 		{0x12, 0x90a60130},
 		{0x17, 0x90170110},
-- 
2.40.1



