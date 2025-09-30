Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C94306B08;
	Tue, 30 Sep 2025 15:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244467; cv=none; b=dg+Yy028Axo8dcZ8Eyk5cK8H3FAHBgtqiCDDj51ppvG/Am0PnIfAIqUZxGFlu+gaJCGhaCOTdvE0NJj5edVqHWmSigMA69Z3nWQ4V7uf3Im22YaLYBwbtdw7wllza2Z2K9xBoAuEyOrMPi6nLMGo3mwahLRQ9hMLZL2/ofSAVMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244467; c=relaxed/simple;
	bh=cjS4TuywVrPVWO+yzivs5T6P9Bwyxw8HFOOQAYpenHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HO78tpM0dcatr3G2EqHBE2OoDzpV8p010iu1roTOYXkAMkAx4K6qoWey+cRpGxZAQfV6PQvKvLSkU0kjjnbG/1ql4vepy2riEVon3kS+OTLZ3cNI0s2lqLvTMeUTzu23DDpDVNuehBZXCFrkqL0rppL5WoFs9sJB48S8V2vz/8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Txr2TM+W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Txr2TM+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E63C4CEF0;
	Tue, 30 Sep 2025 15:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244467;
	bh=cjS4TuywVrPVWO+yzivs5T6P9Bwyxw8HFOOQAYpenHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Txr2TM+Wz52/CNrAcBizprMXKSXd6IY8G2O4JWxD9BblWV4F358Flu0xpAOPUIRrb
	 FpuifH8FyaqOu4cyz0LTn44ZOcVIy37YCLc6ntoIhuycqidJuakXjjlaQXuvo2dSgw
	 pKIQ/1H8fbDvDEco/9iJXaF0RU/zOFC9xqo+FCiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 016/143] ALSA: hda/realtek: Add support for ASUS NUC using CS35L41 HDA
Date: Tue, 30 Sep 2025 16:45:40 +0200
Message-ID: <20250930143831.892578455@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit 84fc8896f0d9d1c075e0e08a416faedbd73907fa ]

Add support for ASUS NUC14LNS.

This NUC uses a single CS35L41 Amp in using Internal Boost with SPI.
To support the Single Amp, a new quirk is required.

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Link: https://patch.msgid.link/20250612160029.848104-3-sbinding@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 4819bd332f039..fa28e3e85861c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7298,6 +7298,11 @@ static void cs35l41_fixup_spi_two(struct hda_codec *codec, const struct hda_fixu
 	comp_generic_fixup(codec, action, "spi", "CSC3551", "-%s:00-cs35l41-hda.%d", 2);
 }
 
+static void cs35l41_fixup_spi_one(struct hda_codec *codec, const struct hda_fixup *fix, int action)
+{
+	comp_generic_fixup(codec, action, "spi", "CSC3551", "-%s:00-cs35l41-hda.%d", 1);
+}
+
 static void cs35l41_fixup_spi_four(struct hda_codec *codec, const struct hda_fixup *fix, int action)
 {
 	comp_generic_fixup(codec, action, "spi", "CSC3551", "-%s:00-cs35l41-hda.%d", 4);
@@ -7991,6 +7996,7 @@ enum {
 	ALC287_FIXUP_CS35L41_I2C_2,
 	ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED,
 	ALC287_FIXUP_CS35L41_I2C_4,
+	ALC245_FIXUP_CS35L41_SPI_1,
 	ALC245_FIXUP_CS35L41_SPI_2,
 	ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED,
 	ALC245_FIXUP_CS35L41_SPI_4,
@@ -10120,6 +10126,10 @@ static const struct hda_fixup alc269_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = cs35l41_fixup_spi_two,
 	},
+	[ALC245_FIXUP_CS35L41_SPI_1] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = cs35l41_fixup_spi_one,
+	},
 	[ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = cs35l41_fixup_spi_two,
@@ -11099,6 +11109,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x8398, "ASUS P1005", ALC269_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x83ce, "ASUS P1005", ALC269_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x8516, "ASUS X101CH", ALC269_FIXUP_ASUS_X101),
+	SND_PCI_QUIRK(0x1043, 0x88f4, "ASUS NUC14LNS", ALC245_FIXUP_CS35L41_SPI_1),
 	SND_PCI_QUIRK(0x104d, 0x9073, "Sony VAIO", ALC275_FIXUP_SONY_VAIO_GPIO2),
 	SND_PCI_QUIRK(0x104d, 0x907b, "Sony VAIO", ALC275_FIXUP_SONY_HWEQ),
 	SND_PCI_QUIRK(0x104d, 0x9084, "Sony VAIO", ALC275_FIXUP_SONY_HWEQ),
-- 
2.51.0



