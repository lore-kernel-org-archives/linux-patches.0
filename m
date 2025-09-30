Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102A625D1F7;
	Tue, 30 Sep 2025 15:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245977; cv=none; b=JKnmbTCjmRwM3bLOSMOX1qrWpIYkN5rA5cKDSI31eHDZOuKUJ8kQLcoWbsCkYXxhpV8ogeeLE1ZdmIT3B1iACDxplXzSS+yVf/76CG7x+nfbICPr855o9SQ7FhEmYvmhbtVlQCFYgCU3nbxqOIZgWoAWED2LNwSzXqSi27rTBiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245977; c=relaxed/simple;
	bh=Uq5ozdFwyteRSOrRrAYkx0lqgwBqvbQ/ZRWHEGvWH3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9QHjjyMuH03XI++gxXCoAOm3hftoS6gGGl4wu1Urk5+tLa+SROGU+VTWmtU2PQrwV4qj6vHf6QfqUzC3t9QEqdcbGRT8pX/ScHr54wEi3J5/WZ/7ImOyCLTaBgtokCGHdLc7WLXZj+safSv5c0Qi6PUTkR86Ci9WMrfFrX99Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jHazV7to; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jHazV7to"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CDAC113D0;
	Tue, 30 Sep 2025 15:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245976;
	bh=Uq5ozdFwyteRSOrRrAYkx0lqgwBqvbQ/ZRWHEGvWH3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jHazV7toyWR7kghUFkBcMN1h/9SezoReCBroywk0k7sQbYPWMJ1HnC6G8AX2Y7UMW
	 mL/eIeBjI+87MylTZheWZ06IGMk2q9bUbxzSQoTEvAS9hn0wP3rX5SoIILKkxFolzR
	 ubkinFLJ3Tr9Cz3AakDLpm5s3HVj9HeAaUncux7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 15/89] ALSA: hda/realtek: Add support for ASUS NUC using CS35L41 HDA
Date: Tue, 30 Sep 2025 16:47:29 +0200
Message-ID: <20250930143822.502017013@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5f061d2d9fc96..a41df821e15f7 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7272,6 +7272,11 @@ static void cs35l41_fixup_spi_two(struct hda_codec *codec, const struct hda_fixu
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
@@ -7956,6 +7961,7 @@ enum {
 	ALC287_FIXUP_CS35L41_I2C_2,
 	ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED,
 	ALC287_FIXUP_CS35L41_I2C_4,
+	ALC245_FIXUP_CS35L41_SPI_1,
 	ALC245_FIXUP_CS35L41_SPI_2,
 	ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED,
 	ALC245_FIXUP_CS35L41_SPI_4,
@@ -10067,6 +10073,10 @@ static const struct hda_fixup alc269_fixups[] = {
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
@@ -11001,6 +11011,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x8398, "ASUS P1005", ALC269_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x83ce, "ASUS P1005", ALC269_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x8516, "ASUS X101CH", ALC269_FIXUP_ASUS_X101),
+	SND_PCI_QUIRK(0x1043, 0x88f4, "ASUS NUC14LNS", ALC245_FIXUP_CS35L41_SPI_1),
 	SND_PCI_QUIRK(0x104d, 0x9073, "Sony VAIO", ALC275_FIXUP_SONY_VAIO_GPIO2),
 	SND_PCI_QUIRK(0x104d, 0x907b, "Sony VAIO", ALC275_FIXUP_SONY_HWEQ),
 	SND_PCI_QUIRK(0x104d, 0x9084, "Sony VAIO", ALC275_FIXUP_SONY_HWEQ),
-- 
2.51.0



