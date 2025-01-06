Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18C5155C9E;
	Mon,  6 Jan 2025 15:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177951; cv=none; b=ru45UFwwDc5VB53aM80hy8mPXMV4WmkoPBmTHTkx7Qml2LGZ03N4XuMVJYbaA/MZALRf5gaHsAgVm2AUDgibqffFTyz7R4mUoSCtbVhT1QCFm3wcYybZ1siFA5LEc5H4rXuhHVD2fNPu8obrbH4DvVoKpWFd6V75UV6efJShqFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177951; c=relaxed/simple;
	bh=aeCCfPs+LRtPThuigzjjXVpNa68OhsDxYSaLGOZ12N4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PmIqLxdoYofJILWeJredZJubfYceYKZ79MhmTRJ/J1Dwnemc7ou43WGIzKzOXihxxOy96uAHcBfYoL+XJaZoNgYGcCdgzJ9aUcwQVwOZ5MAxucHE3vImkcUhQnX49b+3u+Wl21fkphcDp69qUgdZyTNs5p9ZakGP+qCMAo2R1eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x0HmCtQD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x0HmCtQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B525C4CEE1;
	Mon,  6 Jan 2025 15:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177950;
	bh=aeCCfPs+LRtPThuigzjjXVpNa68OhsDxYSaLGOZ12N4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x0HmCtQDL+fdDNgH6Iwb3eE7oNCeCS4l0hYCRYjOzHZZ/Exolr1ASCCQXjm/IQxpN
	 RR3NTVVqRccBWmP1TI/+Ye9DcdL9AN/pIykw34hQBbzPxiFvcgXlKnlViDQ3CHotKK
	 +kp2CiJiqwKFOXYn0dPE+2PEko2y+1byzVjxEhQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/156] ALSA: hda/realtek - Add support for ASUS Zen AIO 27 Z272SD_A272SD audio
Date: Mon,  6 Jan 2025 16:16:10 +0100
Message-ID: <20250106151144.896513708@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasiliy Kovalev <kovalev@altlinux.org>

[ Upstream commit 1b452c2de5555d832cd51c46824272a44ad7acac ]

Introduces necessary quirks to enable audio functionality on the
ASUS Zen AIO 27 Z272SD_A272SD:
- configures verbs to activate internal speakers and headphone jack.
- implements adjustments for headset microphone functionality.

The speaker and jack configurations were derived from a dump of
the working Windows driver, while the headset microphone
functionality was fine-tuned through experimental testing.

Link: https://lore.kernel.org/all/CAGGMHBOGDUnMewBTrZgoBKFk_A4sNF4fEXwfH9Ay8SNTzjy0-g@mail.gmail.com/T/
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Link: https://patch.msgid.link/20241205210306.977634-1-kovalev@altlinux.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 192fc75b51e6..e9ec5f79bd45 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7704,6 +7704,7 @@ enum {
 	ALC274_FIXUP_HP_MIC,
 	ALC274_FIXUP_HP_HEADSET_MIC,
 	ALC274_FIXUP_HP_ENVY_GPIO,
+	ALC274_FIXUP_ASUS_ZEN_AIO_27,
 	ALC256_FIXUP_ASUS_HPE,
 	ALC285_FIXUP_THINKPAD_NO_BASS_SPK_HEADSET_JACK,
 	ALC287_FIXUP_HP_GPIO_LED,
@@ -9505,6 +9506,26 @@ static const struct hda_fixup alc269_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc274_fixup_hp_envy_gpio,
 	},
+	[ALC274_FIXUP_ASUS_ZEN_AIO_27] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x10 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0xc420 },
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x40 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x8800 },
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x49 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x0249 },
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x4a },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x202b },
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x62 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0xa007 },
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x6b },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x5060 },
+			{}
+		},
+		.chained = true,
+		.chain_id = ALC2XX_FIXUP_HEADSET_MIC,
+	},
 	[ALC256_FIXUP_ASUS_HPE] = {
 		.type = HDA_FIXUP_VERBS,
 		.v.verbs = (const struct hda_verb[]) {
@@ -10615,6 +10636,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1f62, "ASUS UX7602ZM", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1f92, "ASUS ROG Flow X16", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),
+	SND_PCI_QUIRK(0x1043, 0x31d0, "ASUS Zen AIO 27 Z272SD_A272SD", ALC274_FIXUP_ASUS_ZEN_AIO_27),
 	SND_PCI_QUIRK(0x1043, 0x3a20, "ASUS G614JZR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
 	SND_PCI_QUIRK(0x1043, 0x3a30, "ASUS G814JVR/JIR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
 	SND_PCI_QUIRK(0x1043, 0x3a40, "ASUS G814JZR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
-- 
2.39.5



