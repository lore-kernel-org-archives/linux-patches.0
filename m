Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C082533E36A;
	Sat, 30 May 2026 17:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162738; cv=none; b=gs/gxvr7fdkCKHQ2a/nfBArp2UJa155jIb8kfwkdF1fmncHF0eGgWjhnVGDmu5can10L1/fSvae22y7mRZRzj6KnK2eFY4ifKLubaJ+7RPQ30R73ZWKISM0+wMYhY3aAKhceDybUDqnYbJv3twJqDkSpIeidQWrVyZB1nNVBjIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162738; c=relaxed/simple;
	bh=TfqGJXRkOZZO991WZuAQxViFuZUY68kviWKulQH5b1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WjIN+Y+4iZ0NspOtWLD3tUbzo2BBOQj4T9PJDBGdjnx+eQaxEL7OMFjHCKWJ3G17VQcsxBE7t81CqX4j0WTRUEvwwMJk1SFosNWlCZj4oCVGT83vce1cLVketwXppWcMBLco44Iw0DCE6r7KeHErhRlGOxxAq1m6n79UjkAGZIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zAu7nXSN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zAu7nXSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0C41F00893;
	Sat, 30 May 2026 17:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162737;
	bh=8l0ujVIvhI2DYomQmmVW6zEyp1NsMuVJCAdMesQB9Go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zAu7nXSNAPi1dOqkEyhaUrRQVtFdL8x/6O7C/ZMXTBpOJwSvzD60D3ij+DF/VI7uR
	 TeCkdXuAI3Hx1/0WAE+ihjun4F2Ek9HKKLzIvdxiqTzQ6J+OXkkHBSgNcdVvU1+nRS
	 M7fQTPUMdSeahf7dZX/MFrWC5p/SpzP9rwvAO8cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jussi Laako <jussi@sonarnerd.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/776] ALSA: usb-audio: Update for native DSD support quirks
Date: Sat, 30 May 2026 17:56:03 +0200
Message-ID: <20260530160241.573644941@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jussi Laako <jussi@sonarnerd.net>

[ Upstream commit f7fea075edfa085c25eb34c44ceacf3602537f98 ]

Maintenance patch for native DSD support.

Remove incorrect T+A device quirks. Move set of device quirks to vendor
quirks. Add set of missing device and vendor quirks.

Signed-off-by: Jussi Laako <jussi@sonarnerd.net>
Link: https://lore.kernel.org/r/20230726165645.404311-1-jussi@sonarnerd.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: a8cc55bf81a4 ("ALSA: usb-audio: Remove VALIDATE_RATES quirk for Focusrite devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 4cf2f48b401ee..acfad87636277 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1631,8 +1631,10 @@ u64 snd_usb_interface_dsd_format_quirks(struct snd_usb_audio *chip,
 
 	/* XMOS based USB DACs */
 	switch (chip->usb_id) {
-	case USB_ID(0x1511, 0x0037): /* AURALiC VEGA */
-	case USB_ID(0x21ed, 0xd75a): /* Accuphase DAC-60 option card */
+	case USB_ID(0x139f, 0x5504): /* Nagra DAC */
+	case USB_ID(0x20b1, 0x3089): /* Mola-Mola DAC */
+	case USB_ID(0x2522, 0x0007): /* LH Labs Geek Out 1V5 */
+	case USB_ID(0x2522, 0x0009): /* LH Labs Geek Pulse X Inifinity 2V0 */
 	case USB_ID(0x2522, 0x0012): /* LH Labs VI DAC Infinity */
 	case USB_ID(0x2772, 0x0230): /* Pro-Ject Pre Box S2 Digital */
 		if (fp->altsetting == 2)
@@ -1642,14 +1644,18 @@ u64 snd_usb_interface_dsd_format_quirks(struct snd_usb_audio *chip,
 	case USB_ID(0x0d8c, 0x0316): /* Hegel HD12 DSD */
 	case USB_ID(0x10cb, 0x0103): /* The Bit Opus #3; with fp->dsd_raw */
 	case USB_ID(0x16d0, 0x06b2): /* NuPrime DAC-10 */
-	case USB_ID(0x16d0, 0x09dd): /* Encore mDSD */
+	case USB_ID(0x16d0, 0x06b4): /* NuPrime Audio HD-AVP/AVA */
 	case USB_ID(0x16d0, 0x0733): /* Furutech ADL Stratos */
+	case USB_ID(0x16d0, 0x09d8): /* NuPrime IDA-8 */
 	case USB_ID(0x16d0, 0x09db): /* NuPrime Audio DAC-9 */
+	case USB_ID(0x16d0, 0x09dd): /* Encore mDSD */
 	case USB_ID(0x1db5, 0x0003): /* Bryston BDA3 */
+	case USB_ID(0x20a0, 0x4143): /* WaveIO USB Audio 2.0 */
 	case USB_ID(0x22e1, 0xca01): /* HDTA Serenade DSD */
 	case USB_ID(0x249c, 0x9326): /* M2Tech Young MkIII */
 	case USB_ID(0x2616, 0x0106): /* PS Audio NuWave DAC */
 	case USB_ID(0x2622, 0x0041): /* Audiolab M-DAC+ */
+	case USB_ID(0x278b, 0x5100): /* Rotel RC-1590 */
 	case USB_ID(0x27f7, 0x3002): /* W4S DAC-2v2SE */
 	case USB_ID(0x29a2, 0x0086): /* Mutec MC3+ USB */
 	case USB_ID(0x6b42, 0x0042): /* MSB Technology */
@@ -1659,9 +1665,6 @@ u64 snd_usb_interface_dsd_format_quirks(struct snd_usb_audio *chip,
 
 	/* Amanero Combo384 USB based DACs with native DSD support */
 	case USB_ID(0x16d0, 0x071a):  /* Amanero - Combo384 */
-	case USB_ID(0x2ab6, 0x0004):  /* T+A DAC8DSD-V2.0, MP1000E-V2.0, MP2000R-V2.0, MP2500R-V2.0, MP3100HV-V2.0 */
-	case USB_ID(0x2ab6, 0x0005):  /* T+A USB HD Audio 1 */
-	case USB_ID(0x2ab6, 0x0006):  /* T+A USB HD Audio 2 */
 		if (fp->altsetting == 2) {
 			switch (le16_to_cpu(chip->dev->descriptor.bcdDevice)) {
 			case 0x199:
@@ -1817,6 +1820,9 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_IFACE_DELAY),
 	DEVICE_FLG(0x0644, 0x805f, /* TEAC Model 12 */
 		   QUIRK_FLAG_FORCE_IFACE_RESET),
+	DEVICE_FLG(0x0644, 0x806b, /* TEAC UD-701 */
+		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY |
+		   QUIRK_FLAG_IFACE_DELAY),
 	DEVICE_FLG(0x06f8, 0xb000, /* Hercules DJ Console (Windows Edition) */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x06f8, 0xd002, /* Hercules DJ Console (Macintosh Edition) */
@@ -1873,6 +1879,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY),
 	DEVICE_FLG(0x154e, 0x3006, /* Marantz SA-14S1 */
 		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY),
+	DEVICE_FLG(0x154e, 0x300b, /* Marantz SA-KI RUBY / SA-12 */
+		   QUIRK_FLAG_DSD_RAW),
 	DEVICE_FLG(0x154e, 0x500e, /* Denon DN-X1600 */
 		   QUIRK_FLAG_IGNORE_CLOCK_SOURCE),
 	DEVICE_FLG(0x1686, 0x00dd, /* Zoom R16/24 */
@@ -1929,6 +1937,10 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_SHARE_MEDIA_DEVICE | QUIRK_FLAG_ALIGN_TRANSFER),
 	DEVICE_FLG(0x21b4, 0x0081, /* AudioQuest DragonFly */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x21b4, 0x0230, /* Ayre QB-9 Twenty */
+		   QUIRK_FLAG_DSD_RAW),
+	DEVICE_FLG(0x21b4, 0x0232, /* Ayre QX-5 Twenty */
+		   QUIRK_FLAG_DSD_RAW),
 	DEVICE_FLG(0x2522, 0x0007, /* LH Labs Geek Out HD Audio 1V5 */
 		   QUIRK_FLAG_SET_IFACE_FIRST),
 	DEVICE_FLG(0x262a, 0x9302, /* ddHiFi TC44C */
@@ -1971,12 +1983,18 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_VALIDATE_RATES),
 	VENDOR_FLG(0x1235, /* Focusrite Novation */
 		   QUIRK_FLAG_VALIDATE_RATES),
+	VENDOR_FLG(0x1511, /* AURALiC */
+		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x152a, /* Thesycon devices */
 		   QUIRK_FLAG_DSD_RAW),
+	VENDOR_FLG(0x18d1, /* iBasso devices */
+		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x1de7, /* Phoenix Audio */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	VENDOR_FLG(0x20b1, /* XMOS based devices */
 		   QUIRK_FLAG_DSD_RAW),
+	VENDOR_FLG(0x21ed, /* Accuphase Laboratory */
+		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x22d9, /* Oppo */
 		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x23ba, /* Playback Design */
@@ -1992,10 +2010,14 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x2ab6, /* T+A devices */
 		   QUIRK_FLAG_DSD_RAW),
+	VENDOR_FLG(0x2d87, /* Cayin device */
+		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x3336, /* HEM devices */
 		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x3353, /* Khadas devices */
 		   QUIRK_FLAG_DSD_RAW),
+	VENDOR_FLG(0x35f4, /* MSB Technology */
+		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x3842, /* EVGA */
 		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0xc502, /* HiBy devices */
-- 
2.53.0



