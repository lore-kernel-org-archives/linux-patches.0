Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AF226B096;
	Thu, 13 Feb 2025 15:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459454; cv=none; b=dYfLCpuyz8zaLL0SkfyPbvTN+xtcHIAISglAKypifqh0p4D8RqKMKdFdN/26/OIe5+GyV1R/rwtaMvYchN19gVEcPBOpNACVs5In7QXj14jlL5Ik5PaSodZKQzvUyPB0BRsknX/EgndTqI8wCVOL8D57q23eNQ8E+LtPsA/NJBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459454; c=relaxed/simple;
	bh=0W/PCscFnfh/RhipbY/Ty+awdut2cBkuQcaxbpXkuPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WFxnAbPZFE8Fwu9urrqDayOrCrPMKJXA1AINtf5ZPrCz06n14zBUBIsJ/bS6xavIEmuhA/2Fv0qv9L6tRpvcizrYghHpgqYjm1ezxsXoCQUXs/gIfcChCWsoa/3j8V0nNOJ0q7DyavV+eTjEWFPcjn+eAaEJn3l3wMHYf7wmMO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zn8Os/Ds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zn8Os/Ds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A380C4CED1;
	Thu, 13 Feb 2025 15:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459454;
	bh=0W/PCscFnfh/RhipbY/Ty+awdut2cBkuQcaxbpXkuPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zn8Os/Ds6/CBiXP9vRFvez4dFDnMGgUq0OdIw0cDchQq/5RQE84B5ulnxAlmQLs77
	 gM/affL8vlrhhKZZjwkQGDJ23Srxl6xXKi1RwlOo968onxd4WY/5abTB5tnUTIgZVv
	 auwfzVz2Z7J9n5VdI4eK8ezgg3aEQJsIU6UwybAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Samantha Glocker <iam@anislandsomewhere.com>
Subject: [PATCH 6.13 268/443] ALSA: hda/realtek: Fix quirk matching for Legion Pro 7
Date: Thu, 13 Feb 2025 15:27:13 +0100
Message-ID: <20250213142450.955288760@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 0f3a822ae2254a1e7ce3a130a1efd94e2cab73ee upstream.

The recent cleanup of the quirk table entries with the codec ID
matching caused a regression on some Lenovo Legion 7 models with PCI
SSID 17aa:386f: it assumed wrongly as if the codec SSID on the machine
were also 17aa:386f, but in this case, it was 17aa:38a8.  This made
the binding with a wrong sub-codec, instead of TAS2781, the Cirrus
codec was bound.

For addressing the regression, correct the quirk entry to the right
value 17aa:38a8.

Note that this makes the entry appearing in an unsorted position.
This exception is needed because the entry must match before the PCI
SSID 17aa:386f.

Also there is another entry for 17aa:38a8, but the latter is for PCI
SSID matching while the new entry is for the codec SSID matching.

Fixes: 504f052aa343 ("ALSA: hda/realtek: Use codec SSID matching for Lenovo devices")
Reported-and-tested-by: Samantha Glocker <iam@anislandsomewhere.com>
Closes: https://lore.kernel.org/CAGPQRHYd48U__UKYj2jJnT4+dnNNoWRBi+wj6zPRn=JpNMBUrg@mail.gmail.com
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250125120519.16420-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10890,7 +10890,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x17aa, 0x3869, "Lenovo Yoga7 14IAL7", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	HDA_CODEC_QUIRK(0x17aa, 0x386e, "Legion Y9000X 2022 IAH7", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x386e, "Yoga Pro 7 14ARP8", ALC285_FIXUP_SPEAKER2_TO_DAC1),
-	HDA_CODEC_QUIRK(0x17aa, 0x386f, "Legion Pro 7 16ARX8H", ALC287_FIXUP_TAS2781_I2C),
+	HDA_CODEC_QUIRK(0x17aa, 0x38a8, "Legion Pro 7 16ARX8H", ALC287_FIXUP_TAS2781_I2C), /* this must match before PCI SSID 17aa:386f below */
 	SND_PCI_QUIRK(0x17aa, 0x386f, "Legion Pro 7i 16IAX7", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3870, "Lenovo Yoga 7 14ARB7", ALC287_FIXUP_YOGA7_14ARB7_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3877, "Lenovo Legion 7 Slim 16ARHA7", ALC287_FIXUP_CS35L41_I2C_2),


