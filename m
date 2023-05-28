Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6CF611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E89C433D2;
	Sun, 28 May 2023 19:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301597;
	bh=fJwZ26EO3pHDJLEftD1Cveew5vqrw5UYuE6jiOoMwxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PKwjvPZe8zhbyHuyEACgrvlGUh5kMt6HepafoUEFBwJMZFu2S3prA2ovMqUZ63+Ma
	 XPhjFpvSVjKmFC8W/PFKOLvfeQsYul9We6PKmCsnBmSeCQChuPZN2d0yCSgCOHHhsG
	 3V32HYF3mwmOcpBkuJbzoaGtyRtxvVSQVQfKLTv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 093/132] ALSA: hda/realtek - Add headset Mic support for Lenovo ALC897 platform
Date: Sun, 28 May 2023 20:10:32 +0100
Message-Id: <20230528190836.469028505@linuxfoundation.org>
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

[ Upstream commit d7f32791a9fcf0dae8b073cdea9b79e29098c5f4 ]

Lenovo ALC897 platform had headset Mic.
This patch enable supported headset Mic.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/baab2c2536cb4cc18677a862c6f6d840@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 90670ef774a8 ("ALSA: hda/realtek: Add a quirk for HP EliteDesk 805")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 40 +++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 1f535504ee907..564851086125f 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8573,6 +8573,27 @@ static void alc671_fixup_hp_headset_mic2(struct hda_codec *codec,
 	}
 }
 
+static void alc897_hp_automute_hook(struct hda_codec *codec,
+					 struct hda_jack_callback *jack)
+{
+	struct alc_spec *spec = codec->spec;
+	int vref;
+
+	snd_hda_gen_hp_automute(codec, jack);
+	vref = spec->gen.hp_jack_present ? (PIN_HP | AC_PINCTL_VREF_100) : PIN_HP;
+	snd_hda_codec_write(codec, 0x1b, 0, AC_VERB_SET_PIN_WIDGET_CONTROL,
+			    vref);
+}
+
+static void alc897_fixup_lenovo_headset_mic(struct hda_codec *codec,
+				     const struct hda_fixup *fix, int action)
+{
+	struct alc_spec *spec = codec->spec;
+	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
+		spec->gen.hp_automute_hook = alc897_hp_automute_hook;
+	}
+}
+
 static const struct coef_fw alc668_coefs[] = {
 	WRITE_COEF(0x01, 0xbebe), WRITE_COEF(0x02, 0xaaaa), WRITE_COEF(0x03,    0x0),
 	WRITE_COEF(0x04, 0x0180), WRITE_COEF(0x06,    0x0), WRITE_COEF(0x07, 0x0f80),
@@ -8653,6 +8674,8 @@ enum {
 	ALC668_FIXUP_ASUS_NO_HEADSET_MIC,
 	ALC668_FIXUP_HEADSET_MIC,
 	ALC668_FIXUP_MIC_DET_COEF,
+	ALC897_FIXUP_LENOVO_HEADSET_MIC,
+	ALC897_FIXUP_HEADSET_MIC_PIN,
 };
 
 static const struct hda_fixup alc662_fixups[] = {
@@ -9052,6 +9075,19 @@ static const struct hda_fixup alc662_fixups[] = {
 			{}
 		},
 	},
+	[ALC897_FIXUP_LENOVO_HEADSET_MIC] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc897_fixup_lenovo_headset_mic,
+	},
+	[ALC897_FIXUP_HEADSET_MIC_PIN] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x1a, 0x03a11050 },
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC897_FIXUP_LENOVO_HEADSET_MIC
+	},
 };
 
 static const struct snd_pci_quirk alc662_fixup_tbl[] = {
@@ -9095,6 +9131,10 @@ static const struct snd_pci_quirk alc662_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x144d, 0xc051, "Samsung R720", ALC662_FIXUP_IDEAPAD),
 	SND_PCI_QUIRK(0x14cd, 0x5003, "USI", ALC662_FIXUP_USI_HEADSET_MODE),
 	SND_PCI_QUIRK(0x17aa, 0x1036, "Lenovo P520", ALC662_FIXUP_LENOVO_MULTI_CODECS),
+	SND_PCI_QUIRK(0x17aa, 0x32ca, "Lenovo ThinkCentre M80", ALC897_FIXUP_HEADSET_MIC_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x32cb, "Lenovo ThinkCentre M70", ALC897_FIXUP_HEADSET_MIC_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x32cf, "Lenovo ThinkCentre M950", ALC897_FIXUP_HEADSET_MIC_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x32f7, "Lenovo ThinkCentre M90", ALC897_FIXUP_HEADSET_MIC_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x38af, "Lenovo Ideapad Y550P", ALC662_FIXUP_IDEAPAD),
 	SND_PCI_QUIRK(0x17aa, 0x3a0d, "Lenovo Ideapad Y550", ALC662_FIXUP_IDEAPAD),
 	SND_PCI_QUIRK(0x1849, 0x5892, "ASRock B150M", ALC892_FIXUP_ASROCK_MOBO),
-- 
2.39.2



