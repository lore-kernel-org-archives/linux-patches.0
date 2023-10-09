Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365189CA7B
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="db4Hxos+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818D7C433C7;
	Mon,  9 Oct 2023 13:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696856850;
	bh=oDXdg/kKm23+GmUZ+TsLYv7GhClBxscqZeFt268V1t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=db4Hxos+R/ZggKJTomWt8Hu6agy9AvY7z8CtCyIhyBxaRbx0sdSnsRwKPORDPvyls
	 wgjPPNiJa392jFaQaDflcI9RwPAH7xjsaKoAIO+9gzRHY3G+dv/Ef3168oqulq2hY8
	 OCB6JAbP9PgZ9wSFxWRLccbmqMNTQeXJgvCADPCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson@lenovo.com>,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 004/163] ALSA: hda/realtek - ALC287 I2S speaker platform support
Date: Mon,  9 Oct 2023 14:59:28 +0200
Message-ID: <20231009130124.144934262@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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
Stable-dep-of: 41b07476da38 ("ALSA: hda/realtek - ALC287 Realtek I2S speaker platform support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 57bd11c6057d5..b040889b22880 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7049,6 +7049,27 @@ static void alc295_fixup_dell_inspiron_top_speakers(struct hda_codec *codec,
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
@@ -7311,6 +7332,7 @@ enum {
 	ALC287_FIXUP_TAS2781_I2C,
 	ALC245_FIXUP_HP_MUTE_LED_COEFBIT,
 	ALC245_FIXUP_HP_X360_MUTE_LEDS,
+	ALC287_FIXUP_THINKPAD_I2S_SPK,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -9405,6 +9427,10 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC245_FIXUP_HP_GPIO_LED
 	},
+	[ALC287_FIXUP_THINKPAD_I2S_SPK] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc287_fixup_bind_dacs,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -10537,6 +10563,10 @@ static const struct snd_hda_pin_quirk alc269_pin_fixup_tbl[] = {
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



