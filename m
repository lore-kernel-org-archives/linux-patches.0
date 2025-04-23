Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6A21A9B39;
	Wed, 23 Apr 2025 14:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419623; cv=none; b=FYPA/ZGjuAYGwkt+GrsFVE8uLh34s8VpPJppMVrnWNNntMEMIW92UDiRkuXT8Uy+eN6GPnHd7yiJrDlHp4gNmZaz2CVyBSyshT9j6n7NO6Aa+7E13M6NniWRYc3X1gLHG7R240z+7NqCk1Z9pyT/9UupIkmUPzObtH0ZVVDxrj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419623; c=relaxed/simple;
	bh=DrVNhr77YpxdqZSu3bmJzyuy0wfyZlTslwRq4YE3dZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qtG2QI1HjngXpM95G+fs4RVsr/1xvWT6ddXfDFIMWKeFAFGUew50jFrl1eQa6X7b7ZR0kgJFypFgpa1s1iNDilxQUAD9WWPHAAOCpxiGnwJ8c5GPeMg1Tozh/t71h3M+aUobKjvePX8AdIJ0BDE7FxbFtcfUTlKqjuJBcwJG2UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cN87owDQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cN87owDQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E22C4CEE2;
	Wed, 23 Apr 2025 14:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419623;
	bh=DrVNhr77YpxdqZSu3bmJzyuy0wfyZlTslwRq4YE3dZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cN87owDQ7z83HVMuO4TTJU5ZZOwIfX+dhfFFtmJ768abue1KESdSzO41q+P0lvm4G
	 kvOMVQtOAshYh0V5tu5P9J5uxToN2GvAkPbPCAxeP5d7k2xAVNu3YiTmwf6pmqFacg
	 eBZ8kD6jOngKf+iC5K7ieg7E8xqohDJoMao1K3Ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/223] ALSA: hda/realtek - Fixed ASUS platform headset Mic issue
Date: Wed, 23 Apr 2025 16:41:36 +0200
Message-ID: <20250423142618.101175233@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit b5458fcabd96ce29adbf7225c1741ecdfff70a91 ]

ASUS platform Headset Mic was disable by default.
Assigned verb table for Mic pin will enable it.

Fixes: 7ab61d0a9a35 ("ALSA: hda/realtek: Add support for ASUS B3405 and B3605 Laptops using CS35L41 HDA")
Fixes: c86dd79a7c33 ("ALSA: hda/realtek: Add support for ASUS B5405 and B5605 Laptops using CS35L41 HDA")
Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/0fe3421a6850461fb0b7012cb28ef71d@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index b660bbfc6b0cc..4171aa22747c3 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7910,6 +7910,7 @@ enum {
 	ALC233_FIXUP_MEDION_MTL_SPK,
 	ALC294_FIXUP_BASS_SPEAKER_15,
 	ALC283_FIXUP_DELL_HP_RESUME,
+	ALC294_FIXUP_ASUS_CS35L41_SPI_2,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -10252,6 +10253,12 @@ static const struct hda_fixup alc269_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc283_fixup_dell_hp_resume,
 	},
+	[ALC294_FIXUP_ASUS_CS35L41_SPI_2] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = cs35l41_fixup_spi_two,
+		.chained = true,
+		.chain_id = ALC294_FIXUP_ASUS_HEADSET_MIC,
+	},
 };
 
 static const struct hda_quirk alc269_fixup_tbl[] = {
@@ -10715,7 +10722,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x12a0, "ASUS X441UV", ALC233_FIXUP_EAPD_COEF_AND_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x12a3, "Asus N7691ZM", ALC269_FIXUP_ASUS_N7601ZM),
 	SND_PCI_QUIRK(0x1043, 0x12af, "ASUS UX582ZS", ALC245_FIXUP_CS35L41_SPI_2),
-	SND_PCI_QUIRK(0x1043, 0x12b4, "ASUS B3405CCA / P3405CCA", ALC245_FIXUP_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1043, 0x12b4, "ASUS B3405CCA / P3405CCA", ALC294_FIXUP_ASUS_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x12e0, "ASUS X541SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x12f0, "ASUS X541UV", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1313, "Asus K42JZ", ALC269VB_FIXUP_ASUS_MIC_NO_PRESENCE),
@@ -10804,14 +10811,14 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1fb3, "ASUS ROG Flow Z13 GZ302EA", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x3011, "ASUS B5605CVA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),
-	SND_PCI_QUIRK(0x1043, 0x3061, "ASUS B3405CCA", ALC245_FIXUP_CS35L41_SPI_2),
-	SND_PCI_QUIRK(0x1043, 0x3071, "ASUS B5405CCA", ALC245_FIXUP_CS35L41_SPI_2),
-	SND_PCI_QUIRK(0x1043, 0x30c1, "ASUS B3605CCA / P3605CCA", ALC245_FIXUP_CS35L41_SPI_2),
-	SND_PCI_QUIRK(0x1043, 0x30d1, "ASUS B5405CCA", ALC245_FIXUP_CS35L41_SPI_2),
-	SND_PCI_QUIRK(0x1043, 0x30e1, "ASUS B5605CCA", ALC245_FIXUP_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1043, 0x3061, "ASUS B3405CCA", ALC294_FIXUP_ASUS_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1043, 0x3071, "ASUS B5405CCA", ALC294_FIXUP_ASUS_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1043, 0x30c1, "ASUS B3605CCA / P3605CCA", ALC294_FIXUP_ASUS_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1043, 0x30d1, "ASUS B5405CCA", ALC294_FIXUP_ASUS_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1043, 0x30e1, "ASUS B5605CCA", ALC294_FIXUP_ASUS_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x31d0, "ASUS Zen AIO 27 Z272SD_A272SD", ALC274_FIXUP_ASUS_ZEN_AIO_27),
-	SND_PCI_QUIRK(0x1043, 0x31e1, "ASUS B5605CCA", ALC245_FIXUP_CS35L41_SPI_2),
-	SND_PCI_QUIRK(0x1043, 0x31f1, "ASUS B3605CCA", ALC245_FIXUP_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1043, 0x31e1, "ASUS B5605CCA", ALC294_FIXUP_ASUS_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1043, 0x31f1, "ASUS B3605CCA", ALC294_FIXUP_ASUS_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x3a20, "ASUS G614JZR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
 	SND_PCI_QUIRK(0x1043, 0x3a30, "ASUS G814JVR/JIR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
 	SND_PCI_QUIRK(0x1043, 0x3a40, "ASUS G814JZR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
-- 
2.39.5



