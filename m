Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8539B188CC1;
	Tue, 10 Sep 2024 09:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961379; cv=none; b=L09C/TC8P14/Va0+frpvKyF9nX6tSSRo8fdLuKmxZleZWh17jn0klFnbzSXipHxLhvGfIqSFddkorjjb8TGOg+bo+eFM5dDauSTGjRRyAsVbqo4NSPpSufBOAp2eVeWBJWJL2pOPmtvqCrSnpsHuaseYzSqOnf3QCMVB5vrcp4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961379; c=relaxed/simple;
	bh=TeawhWoxNzzzIKseA8wA7aZs4RPWiBZ38Z4XnPy6wFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLOsYdrz/adM8leFSq/cjBIjFF70ruLgCtdJerrcwMkTqSqf11yNl4Zd9eQIAfJIoq754hhWMx2vauvO85lzyOPO7/xq8bvqkERF9CCDlSHQ5aW5o0z8Q5KpqquwgCNEvkWaXwezl+Ne1QOr7IXRmVj7INai8wBfnRaCa5ndG8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ge+WX5Eq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ge+WX5Eq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C34C4CEC3;
	Tue, 10 Sep 2024 09:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961379;
	bh=TeawhWoxNzzzIKseA8wA7aZs4RPWiBZ38Z4XnPy6wFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ge+WX5EqmwL+WOCjd5wjyVnf7Rn076Jgk+wRPkusrktkeQybJDif0FUhHPwySwpMP
	 ucVPX64l5Hk0cDVMW3jX0dFluVPxXfr0kWrF9ma81IKgkGEcqVCIt9BfjgesHUsm55
	 DQNdmBFB5y1g2nOqS2aDseW3tLdMi951fXwVfwv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Cheong <htcheong@chromium.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 012/375] ALSA: hda/realtek: add patch for internal mic in Lenovo V145
Date: Tue, 10 Sep 2024 11:26:49 +0200
Message-ID: <20240910092622.672159617@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Terry Cheong <htcheong@chromium.org>

commit ef27e89e7f3015be2b3c124833fbd6d2e4686561 upstream.

Lenovo V145 is having phase inverted dmic but simply applying inverted
dmic fixups does not work. Chaining up verb fixes for ALC283 enables
inverting dmic fixup to work properly.

Signed-off-by: Terry Cheong <htcheong@chromium.org>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240830-lenovo-v145-fixes-v3-1-f7b7265068fa@chromium.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7428,6 +7428,7 @@ enum {
 	ALC236_FIXUP_HP_GPIO_LED,
 	ALC236_FIXUP_HP_MUTE_LED,
 	ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF,
+	ALC236_FIXUP_LENOVO_INV_DMIC,
 	ALC298_FIXUP_SAMSUNG_AMP,
 	ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET,
 	ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET,
@@ -9049,6 +9050,12 @@ static const struct hda_fixup alc269_fix
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc236_fixup_hp_mute_led_micmute_vref,
 	},
+	[ALC236_FIXUP_LENOVO_INV_DMIC] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc_fixup_inv_dmic,
+		.chained = true,
+		.chain_id = ALC283_FIXUP_INT_MIC,
+	},
 	[ALC298_FIXUP_SAMSUNG_AMP] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc298_fixup_samsung_amp,
@@ -10609,6 +10616,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x38f9, "Thinkbook 16P Gen5", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x38fa, "Thinkbook 16P Gen5", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
+	SND_PCI_QUIRK(0x17aa, 0x3913, "Lenovo 145", ALC236_FIXUP_LENOVO_INV_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x3977, "IdeaPad S210", ALC283_FIXUP_INT_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3978, "Lenovo B50-70", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x3bf8, "Quanta FL1", ALC269_FIXUP_PCM_44K),
@@ -10860,6 +10868,7 @@ static const struct hda_model_fixup alc2
 	{.id = ALC623_FIXUP_LENOVO_THINKSTATION_P340, .name = "alc623-lenovo-thinkstation-p340"},
 	{.id = ALC255_FIXUP_ACER_HEADPHONE_AND_MIC, .name = "alc255-acer-headphone-and-mic"},
 	{.id = ALC285_FIXUP_HP_GPIO_AMP_INIT, .name = "alc285-hp-amp-init"},
+	{.id = ALC236_FIXUP_LENOVO_INV_DMIC, .name = "alc236-fixup-lenovo-inv-mic"},
 	{}
 };
 #define ALC225_STANDARD_PINS \


