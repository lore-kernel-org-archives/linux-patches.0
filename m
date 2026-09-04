Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8EF0415B8F;
	Fri,  4 Sep 2026 05:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500094; cv=none; b=ZEIKXv1eofB4XZn9FzJ5OZyMwEZbzZ/WFQXS8dzNaDqD9oRXePZjCewIqn5Kav34kFMZZhVd3UxZJXLfmMtCLwrT2W4PJBavyjYECgAnph0IgmEZLGacKF4sH5EHbyim36ZyV9eAvf54Ivz4LLRDBj420JURtZHOeGHrpAng4Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500094; c=relaxed/simple;
	bh=bJhX70mAic6lzRcwXHdW/DoxNpn1CM/1HxKqU01tqmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVCsfKnwgMP0X1GP4/iVqxJ76fh2Q2SKCJj5VXpHdi8sTsxDh0xExwnsbl0L3IR2Yc5aiyfpb6/pmkaeTCLrHuPLgsLCAd4fkYq2P48JwLqOtF6F5/GMLnhZanRmyF05GjJUz4Pmn+9vSmqbqwaTU4TfcCYGPNklFmjEBYpgYw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZL4JoA5j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZL4JoA5j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40781F00A3D;
	Fri,  4 Sep 2026 05:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500092;
	bh=GNAOUvf8MOGbTHSsFzqcjbPnHrLcfue6H+h1HgyKov8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZL4JoA5jtVfHRS0nt8VVgLk4jUfJ73chDCW9q/dESb8IeEYx8tFBmRHhZGpJUcqUh
	 pQG+ANdqHj9xRg2PS+3uR0wsmTagwsCdcfWkjTtfW+DPyG/kFNf+1V6PYSq8Le8P6U
	 5vI2Xwhalyoq/SyGtgm3+V8jqdtJTHUCKbcOoRY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 649/713] ALSA: hda/realtek: Fix Lenovo Yoga Slim 7 14AKP10 quirk ordering
Date: Fri,  4 Sep 2026 07:00:17 +0200
Message-ID: <20260904045818.381210474@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

commit 75dc2eda659f6be4a370734f11baf25df8a9fd80 upstream.

The Yoga Slim 7 14AKP10 has a PCI SSID of 17aa:38b4 but a codec SSID of
17aa:391a. The current quirk table contains a PCI quirk for 17aa:38b4
(for the Legion Slim 7 16IRH8) which matches first, so the codec-specific
quirk for 17aa:391a is never applied.

This results in the wrong fixup being used (CS35L41_I2C_2 instead of the
correct bass speaker fixup), leaving the internal speakers misconfigured
or silent.

Remove the 17aa:391a entry from its PCI-SSID-sorted position and add it as
an HDA_CODEC_QUIRK directly before the 17aa:38b4 entry, because it must
match on the codec subsystem ID rather than the PCI SSID and it has to win
over the colliding PCI quirk for the Legion Slim 7 16IRH8.  A comment is
added to explain the out-of-order placement, following the same style
already used for the 17aa:38bb and 17aa:38f9 codec-SSID overrides.

With this change, the correct ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN is
applied, restoring speaker output and auto-mute functionality.

The original quirk added in commit e6c888202297 ("ALSA: hda/realtek: Add
quirk for Lenovo Yoga Slim 7 14AKP10") matched on the PCI SSID 17aa:391a,
but this model actually exposes PCI SSID 17aa:38b4 (shared with the Legion
Slim 7 16IRH8), so that quirk never matched and the bass speaker remained
silent.  Fix it by matching on the codec SSID and placing the entry before
the colliding 17aa:38b4 PCI quirk.

Fixes: e6c888202297 ("ALSA: hda/realtek: Add quirk for Lenovo Yoga Slim 7 14AKP10")
Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=221298
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260817094708.222154-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7950,6 +7950,10 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x17aa, 0x38a8, "Y780P AMD VECO dual", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38a9, "Thinkbook 16P", ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x38ab, "Thinkbook 16P", ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD),
+	/* Lenovo Yoga Slim 7 14AKP10 shares PCI SSID 17aa:38b4 with Legion Slim 7
+	 * 16IRH8; use codec SSID to distinguish them
+	 */
+	HDA_CODEC_QUIRK(0x17aa, 0x391a, "Lenovo Yoga Slim 7 14AKP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x38b4, "Legion Slim 7 16IRH8", ALC287_FIXUP_CS35L41_I2C_2),
 	HDA_CODEC_QUIRK(0x17aa, 0x391c, "Lenovo Yoga 7 2-in-1 14AKP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	HDA_CODEC_QUIRK(0x17aa, 0x391d, "Lenovo Yoga 7 2-in-1 16AKP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
@@ -7990,7 +7994,6 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x17aa, 0x3911, "Lenovo Yoga Pro 7 14IAH10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3912, "Lenovo Xiaoxin 14 GT", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3913, "Lenovo 145", ALC236_FIXUP_LENOVO_INV_DMIC),
-	SND_PCI_QUIRK(0x17aa, 0x391a, "Lenovo Yoga Slim 7 14AKP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x391f, "Yoga S990-16 pro Quad YC Quad", ALC287_FIXUP_TXNW2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3920, "Yoga S990-16 pro Quad VECO Quad", ALC287_FIXUP_TXNW2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3929, "Thinkbook 13x Gen 5", ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD),


