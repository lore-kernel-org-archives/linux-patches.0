Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7547C21CA07;
	Mon,  2 Jun 2025 15:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877263; cv=none; b=AQily8Ofo/g7m84sRHUy0J/aLwmibzqUoddS3XWwrg5YzRXElk4VKjS/pEtgc58Lxis0dKl8UxPz6fZo32hJw7xP991k2R7p63MGXFwlQawzrxiiOjotfhmyQxOWrGErf60Bgc05DnGtRaokCz5JStV1OpkQ0/ob4uv470XP0R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877263; c=relaxed/simple;
	bh=eDW3cKcM2Ps7fk/8kufLYGfPUsmgX2MOVGyHwTwmHXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CS/yxfd5hs99lFdXds94+/qrCdyIkunQtoV05hkn6WmVoNBSqTFJhvHuLxxjtGjgKmKTzvINl4Md9Mf0l4AKrjup3z4NmR+WRLP1MMb8Z4WKXNoJaCd+EC2DFMWZMnj7+71ulrbYKT7Vke/OPnsNN3tRj5thF6BSPWpF8jCxOxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rTVqmIdu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rTVqmIdu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9036C4CEEB;
	Mon,  2 Jun 2025 15:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877263;
	bh=eDW3cKcM2Ps7fk/8kufLYGfPUsmgX2MOVGyHwTwmHXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rTVqmIdu5WE4VB5DA8APa/KnXO/VxPSTWaE4et0l9ikjKa+MbaJC6UPc/HH5/HNCG
	 KiopgyK5a9Ap7mhnfWtbncFZiUjQI+QUvY6ZxOLt6gA0gvOX6Ad98lrSbbZd1NDpHm
	 lCp1y1gpcQCtpIrHkkDCWsLWFLYULB3oIqPiE6Sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 223/325] ALSA: hda/realtek: Add quirk for HP Spectre x360 15-df1xxx
Date: Mon,  2 Jun 2025 15:48:19 +0200
Message-ID: <20250602134328.845781095@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit be0c40da888840fe91b45474cb70779e6cbaf7ca ]

HP Spectre x360 15-df1xxx with SSID 13c:863e requires similar
workarounds that were applied to another HP Spectre x360 models;
it has a mute LED only, no micmute LEDs, and needs the speaker GPIO
seup.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220054
Link: https://patch.msgid.link/20250427081035.11567-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 42 +++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 2f67cd955d651..682ae18e211c5 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6787,6 +6787,41 @@ static void alc285_fixup_hp_spectre_x360_eb1(struct hda_codec *codec,
 	}
 }
 
+/* GPIO1 = amplifier on/off */
+static void alc285_fixup_hp_spectre_x360_df1(struct hda_codec *codec,
+					     const struct hda_fixup *fix,
+					     int action)
+{
+	struct alc_spec *spec = codec->spec;
+	static const hda_nid_t conn[] = { 0x02 };
+	static const struct hda_pintbl pincfgs[] = {
+		{ 0x14, 0x90170110 },  /* front/high speakers */
+		{ 0x17, 0x90170130 },  /* back/bass speakers */
+		{ }
+	};
+
+	// enable mute led
+	alc285_fixup_hp_mute_led_coefbit(codec, fix, action);
+
+	switch (action) {
+	case HDA_FIXUP_ACT_PRE_PROBE:
+		/* needed for amp of back speakers */
+		spec->gpio_mask |= 0x01;
+		spec->gpio_dir |= 0x01;
+		snd_hda_apply_pincfgs(codec, pincfgs);
+		/* share DAC to have unified volume control */
+		snd_hda_override_conn_list(codec, 0x14, ARRAY_SIZE(conn), conn);
+		snd_hda_override_conn_list(codec, 0x17, ARRAY_SIZE(conn), conn);
+		break;
+	case HDA_FIXUP_ACT_INIT:
+		/* need to toggle GPIO to enable the amp of back speakers */
+		alc_update_gpio_data(codec, 0x01, true);
+		msleep(100);
+		alc_update_gpio_data(codec, 0x01, false);
+		break;
+	}
+}
+
 static void alc285_fixup_hp_spectre_x360(struct hda_codec *codec,
 					  const struct hda_fixup *fix, int action)
 {
@@ -7326,6 +7361,7 @@ enum {
 	ALC280_FIXUP_HP_9480M,
 	ALC245_FIXUP_HP_X360_AMP,
 	ALC285_FIXUP_HP_SPECTRE_X360_EB1,
+	ALC285_FIXUP_HP_SPECTRE_X360_DF1,
 	ALC285_FIXUP_HP_ENVY_X360,
 	ALC288_FIXUP_DELL_HEADSET_MODE,
 	ALC288_FIXUP_DELL1_MIC_NO_PRESENCE,
@@ -9322,6 +9358,10 @@ static const struct hda_fixup alc269_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc285_fixup_hp_spectre_x360_eb1
 	},
+	[ALC285_FIXUP_HP_SPECTRE_X360_DF1] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc285_fixup_hp_spectre_x360_df1
+	},
 	[ALC285_FIXUP_HP_ENVY_X360] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc285_fixup_hp_envy_x360,
@@ -9882,6 +9922,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x86c1, "HP Laptop 15-da3001TU", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x86e7, "HP Spectre x360 15-eb0xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
+	SND_PCI_QUIRK(0x103c, 0x863e, "HP Spectre x360 15-df1xxx", ALC285_FIXUP_HP_SPECTRE_X360_DF1),
 	SND_PCI_QUIRK(0x103c, 0x86e8, "HP Spectre x360 15-eb0xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
 	SND_PCI_QUIRK(0x103c, 0x86f9, "HP Spectre x360 13-aw0xxx", ALC285_FIXUP_HP_SPECTRE_X360_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8716, "HP Elite Dragonfly G2 Notebook PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
@@ -10591,6 +10632,7 @@ static const struct hda_model_fixup alc269_fixup_models[] = {
 	{.id = ALC295_FIXUP_HP_OMEN, .name = "alc295-hp-omen"},
 	{.id = ALC285_FIXUP_HP_SPECTRE_X360, .name = "alc285-hp-spectre-x360"},
 	{.id = ALC285_FIXUP_HP_SPECTRE_X360_EB1, .name = "alc285-hp-spectre-x360-eb1"},
+	{.id = ALC285_FIXUP_HP_SPECTRE_X360_DF1, .name = "alc285-hp-spectre-x360-df1"},
 	{.id = ALC285_FIXUP_HP_ENVY_X360, .name = "alc285-hp-envy-x360"},
 	{.id = ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP, .name = "alc287-ideapad-bass-spk-amp"},
 	{.id = ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN, .name = "alc287-yoga9-bass-spk-pin"},
-- 
2.39.5



