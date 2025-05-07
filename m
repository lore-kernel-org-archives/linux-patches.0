Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2D31FF5EC;
	Wed,  7 May 2025 18:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643912; cv=none; b=m3hc1dmoLGqRgXTvdTHRaJ73AeS2+5557lbR/+QyqJSV7o/dFQoX0596UpOx/ceYalj8VdW1iCdTcZxZLKb1AjnH7I6CTndLEQ7ThctEy4XomDV3LGE4do5lUJRZe1XbcfE9E49heVDF9m4I3dMaTwgHPcTj3Q9y9TJDrR9N/qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643912; c=relaxed/simple;
	bh=nWWH3rWDoY0ULS9buR/v80J+FNoOHsugTKxTmgcNLVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NuFX3v4pOBHCuQdbq40L8KM6GeIDWai6RaHdntyhXKc7VKVE7UD9eylQXMX7M+CqOQYuGwc+MOh2Yj4wl+ly9FkH8PeIizrM81uBbvps66BUb3ri4ZUxiwEaEphFoAaolBnFsC90f+B455CNcfHSXYcBdZvCHBsZTwa8RnmYqWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qKQSyZ6P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qKQSyZ6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42277C4CEE2;
	Wed,  7 May 2025 18:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643912;
	bh=nWWH3rWDoY0ULS9buR/v80J+FNoOHsugTKxTmgcNLVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qKQSyZ6PuS3VtG1ewk5NFkdobuulITPBJg9cd0hrDqjE5F1jvVr0PiMZJlwodpHJT
	 vsDNPsooX2Vp1bLDJ2b6YqAWPp8/Kn2wb4JVJwSdL9XmV2Nc8acoL4xvkl9173l7/Y
	 n8Ch+Nw4fhqJb1RG8GMKe1xmEr4vMmffTZ+wiKsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 059/183] ALSA: hda/realtek - Enable speaker for HP platform
Date: Wed,  7 May 2025 20:38:24 +0200
Message-ID: <20250507183827.076479442@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit 494d0939b1bda4d4ddca7d52a6ce6f808ff2c9a5 ]

The speaker doesn't mute when plugged headphone.
This platform support 4ch speakers.
The speaker pin 0x14 wasn't fill verb table.
After assigned model ALC245_FIXUP_HP_SPECTRE_X360_EU0XXX.
The speaker can mute when headphone was plugged.

Fixes: aa8e3ef4fe53 ("ALSA: hda/realtek: Add quirks for various HP ENVY models")
Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/eb4c14a4d85740069c909e756bbacb0e@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 35c1128ea6b67..263c7be1d4e29 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -440,6 +440,10 @@ static void alc_fill_eapd_coef(struct hda_codec *codec)
 		alc_update_coef_idx(codec, 0x67, 0xf000, 0x3000);
 		fallthrough;
 	case 0x10ec0215:
+	case 0x10ec0236:
+	case 0x10ec0245:
+	case 0x10ec0256:
+	case 0x10ec0257:
 	case 0x10ec0285:
 	case 0x10ec0289:
 		alc_update_coef_idx(codec, 0x36, 1<<13, 0);
@@ -447,12 +451,8 @@ static void alc_fill_eapd_coef(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0233:
 	case 0x10ec0235:
-	case 0x10ec0236:
-	case 0x10ec0245:
 	case 0x10ec0255:
-	case 0x10ec0256:
 	case 0x19e58326:
-	case 0x10ec0257:
 	case 0x10ec0282:
 	case 0x10ec0283:
 	case 0x10ec0286:
@@ -10713,8 +10713,8 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8ca7, "HP ZBook Fury", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8caf, "HP Elite mt645 G8 Mobile Thin Client", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8cbd, "HP Pavilion Aero Laptop 13-bg0xxx", ALC245_FIXUP_HP_X360_MUTE_LEDS),
-	SND_PCI_QUIRK(0x103c, 0x8cdd, "HP Spectre", ALC287_FIXUP_CS35L41_I2C_2),
-	SND_PCI_QUIRK(0x103c, 0x8cde, "HP Spectre", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8cdd, "HP Spectre", ALC245_FIXUP_HP_SPECTRE_X360_EU0XXX),
+	SND_PCI_QUIRK(0x103c, 0x8cde, "HP OmniBook Ultra Flip Laptop 14t", ALC245_FIXUP_HP_SPECTRE_X360_EU0XXX),
 	SND_PCI_QUIRK(0x103c, 0x8cdf, "HP SnowWhite", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ce0, "HP SnowWhite", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8cf5, "HP ZBook Studio 16", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),
-- 
2.39.5



