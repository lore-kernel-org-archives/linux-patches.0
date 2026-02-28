Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5396B3B5315
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301065; cv=none; b=Vg2v++Vn0HSs3HKWmImSUu8/7FvYzJ4wAk0s+fZM1l3vjI+LSKcooxrN/MHwH6MX9cZHi6VO++HsXFToST5Y57Vdt3qtIaVm9/vicc0w9KsGmSBMQhg+219sQZEyYzvtOLUnh8tT4SPxi9iGyuV2Gnca7NnatmTzd4XuxTtgUOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301065; c=relaxed/simple;
	bh=oNf/o6E9qGrNq1UiEnmJf5RGLTAqUoXKqLBoSb6++IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FbMY/qf10qKWx7tddItOP9VecfTpM0sJ6qbROHCyUAg4oCw/U8I+xmpsWlo5sTlYPX5slvmc+lvy6rTg0ceu0Sl7FTNmx58z3E2Lo3aES1O6xfVHeq2l6Z7RaoLOghmoyt/3P2m3lGMKeR5YeLJB5Luvs7GPYldtCZFBGpeRgDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NakiH71y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NakiH71y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A09C116D0;
	Sat, 28 Feb 2026 17:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301065;
	bh=oNf/o6E9qGrNq1UiEnmJf5RGLTAqUoXKqLBoSb6++IA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NakiH71yvbpKkpy6jBwNmLXn7sjII7iqztgDK42/QVG3rElPIabEGcRnvm840F+uP
	 ssip3Cd/vJ3dJQWmLM+ZoPQtuAhKsRNEbwc74aHWf0rLSl3QkDW7d9HngJenGkfCFt
	 Pz8JX67W6JEsre+aujW+HYzLzIiFtuRFzrrVd3Jc1F/Zhcb8t6h/S7tTznAobyP5wN
	 Ew3md/C2t7OzHWzraoLada5OFwCIaB+0j1GzcWtn8JGVgcupibXQyukOaux90lB3+W
	 bHqqpc+9IojueFccAMpk/TOGkree4n/GQYgO1Uz/tYUuN6jKXAu/SmfV+2FLLmefu0
	 FY1t0K9GXJ2TQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Illia Barbashyn <04baril@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 208/752] ALSA: hda/realtek - Enable mute LEDs on HP ENVY x360 15-es0xxx
Date: Sat, 28 Feb 2026 12:38:39 -0500
Message-ID: <20260228174750.1542406-208-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Illia Barbashyn <04baril@gmail.com>

[ Upstream commit ac1ff574bbc09a6c90f4fe8f9e6b8d66c983064c ]

The mute and mic-mute LEDs on HP ENVY x360 Convertible 15-es0xxx
(PCI SSID 103c:88b3) do not work with the current driver.

This model requires a combination of COEFBIT and GPIO fixups to
correctly control the LEDs. Introduce a new fixup function
alc245_fixup_hp_envy_x360_mute_led and add a quirk to apply it.

Signed-off-by: Illia Barbashyn <04baril@gmail.com>
Link: https://patch.msgid.link/20260207221955.24132-1-04baril@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 138570d2da68e..553ffed048ea7 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -1646,6 +1646,13 @@ static void alc285_fixup_hp_spectre_x360_mute_led(struct hda_codec *codec,
 	alc285_fixup_hp_gpio_micmute_led(codec, fix, action);
 }
 
+static void alc245_fixup_hp_envy_x360_mute_led(struct hda_codec *codec,
+				const struct hda_fixup *fix, int action)
+{
+	alc245_fixup_hp_mute_led_v1_coefbit(codec, fix, action);
+	alc245_fixup_hp_gpio_led(codec, fix, action);
+}
+
 static void alc236_fixup_hp_mute_led(struct hda_codec *codec,
 				const struct hda_fixup *fix, int action)
 {
@@ -3810,6 +3817,7 @@ enum {
 	ALC285_FIXUP_HP_GPIO_LED,
 	ALC285_FIXUP_HP_MUTE_LED,
 	ALC285_FIXUP_HP_SPECTRE_X360_MUTE_LED,
+	ALC245_FIXUP_HP_ENVY_X360_MUTE_LED,
 	ALC285_FIXUP_HP_BEEP_MICMUTE_LED,
 	ALC236_FIXUP_HP_MUTE_LED_COEFBIT2,
 	ALC236_FIXUP_HP_GPIO_LED,
@@ -5460,6 +5468,10 @@ static const struct hda_fixup alc269_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc285_fixup_hp_spectre_x360_mute_led,
 	},
+	[ALC245_FIXUP_HP_ENVY_X360_MUTE_LED] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc245_fixup_hp_envy_x360_mute_led,
+	},
 	[ALC285_FIXUP_HP_BEEP_MICMUTE_LED] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc285_fixup_hp_beep,
@@ -6708,6 +6720,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8895, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_SPEAKERS_MICMUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8896, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8898, "HP EliteBook 845 G8 Notebook PC", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
+	SND_PCI_QUIRK(0x103c, 0x88b3, "HP ENVY x360 Convertible 15-es0xxx", ALC245_FIXUP_HP_ENVY_X360_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x88d0, "HP Pavilion 15-eh1xxx (mainboard 88D0)", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x88dd, "HP Pavilion 15z-ec200", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x88eb, "HP Victus 16-e0xxx", ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT),
-- 
2.51.0

