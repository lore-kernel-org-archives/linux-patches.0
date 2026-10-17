Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD003CD8A4;
	Sat, 17 Oct 2026 18:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260798; cv=none; b=JgED3twr4Hswt2SI/VmFgoWH2Ou2PP2a/Ato5eh2V6tHO8CaoRz/PSO2nYu/MSuh0fp386tL5XF21oPflPYCH/YQ2rLsbaLzoHTMecBdr1rTU8L0q3FX3Ku9Ykhch47XKxGlbeO9vqcdSUQvSAublxWdzCfwbRtaOAzFdIylagA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260798; c=relaxed/simple;
	bh=ztT45uwqMuobaKfESqkSKSDV9dwK8QjQpGZ2CYi2Fio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZ1q5kxJHHBH03IL3BFgU2ebOXbfdUPe6hYRR9tfIfXIimJaTYmCYncBkcb1VrNA6lGNoE5TWY81viPbTWhOECmFBjmagzDpopToY/C8NNyNa7N1mQsdjo57pV/4Gz4jlntWsvtL7bBXSWgahNuROdk1OLYojYXViAYe4wfFGpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aCNanCuu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aCNanCuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F941F000C4;
	Sat, 17 Oct 2026 18:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260797;
	bh=D6krphR9yaPC/ftXvGdskgMZdPMgW/ltYqkFoyM4Rks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aCNanCuuDNzJpfZKqUcErCh+y8VzRsqSE96PuQblBzFfPRmMjjuuRbsC1lC0NrIXA
	 OP8Aj5+Gs7iNusLYukXAHS/uIngvt9qTGYr1KFJGVekLMdKCbTjH+cUHM5aR77Xf22
	 3IFraKryq+7Xuv1lrPSEcE+T0kz9Y6CJSN2HWrtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1662/1674] ALSA: hda/realtek: Fix headset mic on ASUS Zenbook 14
Date: Sat, 17 Oct 2026 18:05:34 +0200
Message-ID: <20261017160513.732214075@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasiliy Kovalev <kovalev@altlinux.org>

[ Upstream commit 018f659753fd38bb6fdba7fa8c751121b495e1f4 ]

Add a PCI quirk to enable microphone input on the headphone jack on
the ASUS Zenbook 14 UM3406HA laptop.

This model uses an ALC294 codec with CS35L41 amplifiers over I2C,
and the existing fixup for it did not enable the headset microphone.
A new fix is introduced to get the mic working while keeping the
amplifier settings correct.

Fixes: 61cbc08fdb04 ("ALSA: hda/realtek: Add quirks for ASUS 2024 Zenbooks")
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Link: https://patch.msgid.link/20250818204243.247297-1-kovalev@altlinux.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 99e266f017487..c7f392c0dd73c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7511,6 +7511,7 @@ enum {
 	ALC286_FIXUP_ACER_AIO_MIC_NO_PRESENCE,
 	ALC294_FIXUP_ASUS_MIC,
 	ALC294_FIXUP_ASUS_HEADSET_MIC,
+	ALC294_FIXUP_ASUS_I2C_HEADSET_MIC,
 	ALC294_FIXUP_ASUS_SPK,
 	ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE,
 	ALC285_FIXUP_LENOVO_PC_BEEP_IN_NOISE,
@@ -8824,6 +8825,15 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC269_FIXUP_HEADSET_MIC
 	},
+	[ALC294_FIXUP_ASUS_I2C_HEADSET_MIC] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x03a19020 }, /* use as headset mic */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC287_FIXUP_CS35L41_I2C_2
+	},
 	[ALC294_FIXUP_ASUS_SPK] = {
 		.type = HDA_FIXUP_VERBS,
 		.v.verbs = (const struct hda_verb[]) {
@@ -10359,7 +10369,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1b13, "Asus U41SV", ALC269_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x1b93, "ASUS G614JVR/JIR", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1bbd, "ASUS Z550MA", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
-	SND_PCI_QUIRK(0x1043, 0x1c03, "ASUS UM3406HA", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1043, 0x1c03, "ASUS UM3406HA", ALC294_FIXUP_ASUS_I2C_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1c23, "Asus X55U", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x1043, 0x1c33, "ASUS UX5304MA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1c43, "ASUS UX8406MA", ALC245_FIXUP_CS35L41_SPI_2),
-- 
2.53.0



