Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E47611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB7FC433D2;
	Sun, 28 May 2023 19:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301657;
	bh=5SwkV9Fyc+pMn5c/0udN8Wpbq8gKJk34Z5uELUpsFY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=azEMayzWRGT1+H6LlzwlzG3LBTWA7cZtfLymmmCVfNfIwJvq0xwXFRK6/GWIG2Zwv
	 LZFHhiEkrqejt77zuEK79ov61KbSTRWCva2PoPe0DmX1kKpz7G5IHuuDLQm2/nJXFM
	 K/yMNmge13tP9xatmaY0ZZl/m0zR6pKQah2gBlPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 088/132] ALSA: hda/realtek - Add Headset Mic supported for HP cPC
Date: Sun, 28 May 2023 20:10:27 +0100
Message-Id: <20230528190836.265770722@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190833.565872088@linuxfoundation.org>
References: <20230528190833.565872088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit 5af29028fd6db9438b5584ab7179710a0a22569d ]

HP ALC671 need to support Headset Mic.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/r/06a9d2b176e14706976d6584cbe2d92a@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 90670ef774a8 ("ALSA: hda/realtek: Add a quirk for HP EliteDesk 805")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 44 +++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 3916f2eb5384a..a47946b4b22e1 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8550,6 +8550,29 @@ static void alc662_fixup_aspire_ethos_hp(struct hda_codec *codec,
 	}
 }
 
+static void alc671_fixup_hp_headset_mic2(struct hda_codec *codec,
+					     const struct hda_fixup *fix, int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	static const struct hda_pintbl pincfgs[] = {
+		{ 0x19, 0x02a11040 }, /* use as headset mic, with its own jack detect */
+		{ 0x1b, 0x0181304f },
+		{ }
+	};
+
+	switch (action) {
+	case HDA_FIXUP_ACT_PRE_PROBE:
+		spec->gen.mixer_nid = 0;
+		spec->parse_flags |= HDA_PINCFG_HEADSET_MIC;
+		snd_hda_apply_pincfgs(codec, pincfgs);
+		break;
+	case HDA_FIXUP_ACT_INIT:
+		alc_write_coef_idx(codec, 0x19, 0xa054);
+		break;
+	}
+}
+
 static const struct coef_fw alc668_coefs[] = {
 	WRITE_COEF(0x01, 0xbebe), WRITE_COEF(0x02, 0xaaaa), WRITE_COEF(0x03,    0x0),
 	WRITE_COEF(0x04, 0x0180), WRITE_COEF(0x06,    0x0), WRITE_COEF(0x07, 0x0f80),
@@ -8624,6 +8647,7 @@ enum {
 	ALC669_FIXUP_ACER_ASPIRE_ETHOS,
 	ALC669_FIXUP_ACER_ASPIRE_ETHOS_SUBWOOFER,
 	ALC669_FIXUP_ACER_ASPIRE_ETHOS_HEADSET,
+	ALC671_FIXUP_HP_HEADSET_MIC2,
 };
 
 static const struct hda_fixup alc662_fixups[] = {
@@ -8977,6 +9001,10 @@ static const struct hda_fixup alc662_fixups[] = {
 		.chained = true,
 		.chain_id = ALC669_FIXUP_ACER_ASPIRE_ETHOS_SUBWOOFER
 	},
+	[ALC671_FIXUP_HP_HEADSET_MIC2] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc671_fixup_hp_headset_mic2,
+	},
 };
 
 static const struct snd_pci_quirk alc662_fixup_tbl[] = {
@@ -9158,6 +9186,22 @@ static const struct snd_hda_pin_quirk alc662_pin_fixup_tbl[] = {
 		{0x12, 0x90a60130},
 		{0x14, 0x90170110},
 		{0x15, 0x0321101f}),
+	SND_HDA_PIN_QUIRK(0x10ec0671, 0x103c, "HP cPC", ALC671_FIXUP_HP_HEADSET_MIC2,
+		{0x14, 0x01014010},
+		{0x17, 0x90170150},
+		{0x1b, 0x01813030},
+		{0x21, 0x02211020}),
+	SND_HDA_PIN_QUIRK(0x10ec0671, 0x103c, "HP cPC", ALC671_FIXUP_HP_HEADSET_MIC2,
+		{0x14, 0x01014010},
+		{0x18, 0x01a19040},
+		{0x1b, 0x01813030},
+		{0x21, 0x02211020}),
+	SND_HDA_PIN_QUIRK(0x10ec0671, 0x103c, "HP cPC", ALC671_FIXUP_HP_HEADSET_MIC2,
+		{0x14, 0x01014020},
+		{0x17, 0x90170110},
+		{0x18, 0x01a19050},
+		{0x1b, 0x01813040},
+		{0x21, 0x02211030}),
 	{}
 };
 
-- 
2.39.2



