Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88A1611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B00C433EF;
	Sun, 28 May 2023 19:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301652;
	bh=l99n+/hFTNadIblDlaaa9YkgJKmajgwzcYzJmMQlkp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gCSLYfYrLgPsU13dPtpWC/ciRg0Nxl2o8n0apa4w+Hy8fKcLiQ4eZStq7G1vl3Z42
	 yMcgaLOjYFMmb0vgbj22Lo4e2gVPufTuEJQghztX2iIYhmGch64ImHSy52p6Y0kwNv
	 zm/VqmhcqlVVJom1kIOtfrQ+Tsbfu5dqomF3rAic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Bostandzhyan <jin@mediatomb.cc>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 086/132] Add Acer Aspire Ethos 8951G model quirk
Date: Sun, 28 May 2023 20:10:25 +0100
Message-Id: <20230528190836.190608940@linuxfoundation.org>
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

From: Sergey Bostandzhyan <jin@mediatomb.cc>

[ Upstream commit 00066e9733f629e536f6b7957de2ce11a85fe15a ]

This notebook has 6 built in speakers for 5.1 surround support, however
only two got autodetected and have also not been assigned correctly.

This patch enables all speakers and also fixes muting when headphones are
plugged in.

The speaker layout is as follows:

pin 0x15 Front Left / Front Right
pin 0x18 Front Center / Subwoofer
pin 0x1b Rear Left / Rear Right (Surround)

The quirk will be enabled automatically on this hardware, but can also be
activated manually via the model=aspire-ethos module parameter.

Caveat: pin 0x1b is shared between headphones jack and surround speakers.
When headphones are plugged in, the surround speakers get muted
automatically by the hardware, however all other speakers remain
unmuted. Currently it's not possible to make use of the generic automute
function in the driver, because such shared pins are not supported.

If we would change the pin settings to identify the pin as headphones,
the surround channel and thus the ability to select 5.1 profiles would
get lost.

This quirk solves the above problem by monitoring jack state of 0x1b and
by connecting/disconnecting all remaining speaker pins when something
gets plugged in or unplugged from the headphones jack port.

Signed-off-by: Sergey Bostandzhyan <jin@mediatomb.cc>
Link: https://lore.kernel.org/r/20190906093343.GA7640@xn--80adja5bqm.su
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 90670ef774a8 ("ALSA: hda/realtek: Add a quirk for HP EliteDesk 805")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 71 +++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 546872e724275..98b6e93084e5e 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8511,6 +8511,45 @@ static void alc662_fixup_usi_headset_mic(struct hda_codec *codec,
 	}
 }
 
+static void alc662_aspire_ethos_mute_speakers(struct hda_codec *codec,
+					struct hda_jack_callback *cb)
+{
+	/* surround speakers at 0x1b already get muted automatically when
+	 * headphones are plugged in, but we have to mute/unmute the remaining
+	 * channels manually:
+	 * 0x15 - front left/front right
+	 * 0x18 - front center/ LFE
+	 */
+	if (snd_hda_jack_detect_state(codec, 0x1b) == HDA_JACK_PRESENT) {
+		snd_hda_set_pin_ctl_cache(codec, 0x15, 0);
+		snd_hda_set_pin_ctl_cache(codec, 0x18, 0);
+	} else {
+		snd_hda_set_pin_ctl_cache(codec, 0x15, PIN_OUT);
+		snd_hda_set_pin_ctl_cache(codec, 0x18, PIN_OUT);
+	}
+}
+
+static void alc662_fixup_aspire_ethos_hp(struct hda_codec *codec,
+					const struct hda_fixup *fix, int action)
+{
+    /* Pin 0x1b: shared headphones jack and surround speakers */
+	if (!is_jack_detectable(codec, 0x1b))
+		return;
+
+	switch (action) {
+	case HDA_FIXUP_ACT_PRE_PROBE:
+		snd_hda_jack_detect_enable_callback(codec, 0x1b,
+				alc662_aspire_ethos_mute_speakers);
+		break;
+	case HDA_FIXUP_ACT_INIT:
+		/* Make sure to start in a correct state, i.e. if
+		 * headphones have been plugged in before powering up the system
+		 */
+		alc662_aspire_ethos_mute_speakers(codec, NULL);
+		break;
+	}
+}
+
 static struct coef_fw alc668_coefs[] = {
 	WRITE_COEF(0x01, 0xbebe), WRITE_COEF(0x02, 0xaaaa), WRITE_COEF(0x03,    0x0),
 	WRITE_COEF(0x04, 0x0180), WRITE_COEF(0x06,    0x0), WRITE_COEF(0x07, 0x0f80),
@@ -8582,6 +8621,9 @@ enum {
 	ALC662_FIXUP_USI_FUNC,
 	ALC662_FIXUP_USI_HEADSET_MODE,
 	ALC662_FIXUP_LENOVO_MULTI_CODECS,
+	ALC669_FIXUP_ACER_ASPIRE_ETHOS,
+	ALC669_FIXUP_ACER_ASPIRE_ETHOS_SUBWOOFER,
+	ALC669_FIXUP_ACER_ASPIRE_ETHOS_HEADSET,
 };
 
 static const struct hda_fixup alc662_fixups[] = {
@@ -8908,6 +8950,33 @@ static const struct hda_fixup alc662_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc233_alc662_fixup_lenovo_dual_codecs,
 	},
+	[ALC669_FIXUP_ACER_ASPIRE_ETHOS_HEADSET] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc662_fixup_aspire_ethos_hp,
+	},
+	[ALC669_FIXUP_ACER_ASPIRE_ETHOS_SUBWOOFER] = {
+		.type = HDA_FIXUP_VERBS,
+		/* subwoofer needs an extra GPIO setting to become audible */
+		.v.verbs = (const struct hda_verb[]) {
+			{0x01, AC_VERB_SET_GPIO_MASK, 0x02},
+			{0x01, AC_VERB_SET_GPIO_DIRECTION, 0x02},
+			{0x01, AC_VERB_SET_GPIO_DATA, 0x00},
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC669_FIXUP_ACER_ASPIRE_ETHOS_HEADSET
+	},
+	[ALC669_FIXUP_ACER_ASPIRE_ETHOS] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x15, 0x92130110 }, /* front speakers */
+			{ 0x18, 0x99130111 }, /* center/subwoofer */
+			{ 0x1b, 0x11130012 }, /* surround plus jack for HP */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC669_FIXUP_ACER_ASPIRE_ETHOS_SUBWOOFER
+	},
 };
 
 static const struct snd_pci_quirk alc662_fixup_tbl[] = {
@@ -8953,6 +9022,7 @@ static const struct snd_pci_quirk alc662_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x19da, 0xa130, "Zotac Z68", ALC662_FIXUP_ZOTAC_Z68),
 	SND_PCI_QUIRK(0x1b0a, 0x01b8, "ACER Veriton", ALC662_FIXUP_ACER_VERITON),
 	SND_PCI_QUIRK(0x1b35, 0x2206, "CZC P10T", ALC662_FIXUP_CZC_P10T),
+	SND_PCI_QUIRK(0x1025, 0x0566, "Acer Aspire Ethos 8951G", ALC669_FIXUP_ACER_ASPIRE_ETHOS),
 
 #if 0
 	/* Below is a quirk table taken from the old code.
@@ -9045,6 +9115,7 @@ static const struct hda_model_fixup alc662_fixup_models[] = {
 	{.id = ALC892_FIXUP_ASROCK_MOBO, .name = "asrock-mobo"},
 	{.id = ALC662_FIXUP_USI_HEADSET_MODE, .name = "usi-headset"},
 	{.id = ALC662_FIXUP_LENOVO_MULTI_CODECS, .name = "dual-codecs"},
+	{.id = ALC669_FIXUP_ACER_ASPIRE_ETHOS, .name = "aspire-ethos"},
 	{}
 };
 
-- 
2.39.2



