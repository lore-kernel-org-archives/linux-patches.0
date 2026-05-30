Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDED034575D;
	Sat, 30 May 2026 16:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158472; cv=none; b=rUG0D+/7SORcDq+dh80EWt+K95Em6GskmXKXUrNPoepkBvdQLOqjeUTaZrSV6KOgdHf0tbp5vetrPAQWCWc0wOL7F/ecKezxAFLHX6Vs6PxZOdo+jIJWF1R4LiIm7xFjYCTz0PpDVWflX6vHEZdlXTQPjBCN/xvmz4OF/aATwoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158472; c=relaxed/simple;
	bh=73IgEOqY8IEoSGritJLo/FL1iRP83ezqMpnIxzJkjnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6oFn+0GfRIrFpi0xgmXUZ//9zGdBEgqThSUGX9IbGVCsjvLN3uI6v76IcUFI5oPlht+nGbBgSsiU+bUblHWwQ8l3FGVPRdmt4Wk8ORRZi41haijEyxg7vKLhNsG+RerxHvfGR+n89+G3movLHnOBkTXO08NQXQ5dlMHUelKAoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDDvpkz8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDDvpkz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF39A1F00893;
	Sat, 30 May 2026 16:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158470;
	bh=brEq7ii3CJkZxxCoV/wEOjF1w63Sw2ugKsnxBYs8KY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gDDvpkz8GCFYx/hL+Ht1Zi5srMhsNyJgCUChtLThlH/dzvxjUA6Wgwe1IWOzz9xuN
	 F1nKlNNqA2qcL4syzatxl2kY7D1zqkh4XU7/wuGhAo13IqJqtPca7PGqVj2w/WdUks
	 cV9R0TdtvKKNvY3WTB1vfcy4OMLF6py/P9CzIJ8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/969] ALSA: usb-audio: Improve Focusrite sample rate filtering
Date: Sat, 30 May 2026 17:52:58 +0200
Message-ID: <20260530160301.888290661@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geoffrey D. Bennett <g@b4.vu>

[ Upstream commit 24d2d3c5f94007a5a0554065ab7349bb69e28bcb ]

Replace the bLength == 10 max_rate check in
focusrite_valid_sample_rate() with filtering that also examines the
bmControls VAL_ALT_SETTINGS bit.

When VAL_ALT_SETTINGS is readable, the device uses strict
per-altsetting rate filtering (only the highest rate pair for that
altsetting is valid). When it is not readable, all rates up to
max_rate are valid.

For devices without the bLength == 10 Format Type descriptor extension
but with VAL_ALT_SETTINGS readable and multiple altsettings (only seen
in Scarlett 18i8 3rd Gen playback), fall back to the Focusrite
convention: alt 1 = 48kHz, alt 2 = 96kHz, alt 3 = 192kHz.

This produces correct rate tables for all tested Focusrite devices
(all Scarlett 2nd, 3rd, and 4th Gen, Clarett+, and Vocaster) using
only USB descriptors, allowing QUIRK_FLAG_VALIDATE_RATES to be removed
for Focusrite in the next commit.

Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/7e18c1f393a6ecb6fc75dd867a2c4dbe135e3e22.1771594828.git.g@b4.vu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/format.c | 86 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 74 insertions(+), 12 deletions(-)

diff --git a/sound/usb/format.c b/sound/usb/format.c
index f33d25a4e4cc7..682adbdf7ee79 100644
--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -304,9 +304,37 @@ static bool s1810c_valid_sample_rate(struct audioformat *fp,
 }
 
 /*
- * Many Focusrite devices supports a limited set of sampling rates per
- * altsetting. Maximum rate is exposed in the last 4 bytes of Format Type
- * descriptor which has a non-standard bLength = 10.
+ * Focusrite devices use rate pairs: 44100/48000, 88200/96000, and
+ * 176400/192000. Return true if rate is in the pair for max_rate.
+ */
+static bool focusrite_rate_pair(unsigned int rate,
+				unsigned int max_rate)
+{
+	switch (max_rate) {
+	case 48000:  return rate == 44100 || rate == 48000;
+	case 96000:  return rate == 88200 || rate == 96000;
+	case 192000: return rate == 176400 || rate == 192000;
+	default:     return true;
+	}
+}
+
+/*
+ * Focusrite devices report all supported rates in a single clock
+ * source but only a subset is valid per altsetting.
+ *
+ * Detection uses two descriptor features:
+ *
+ * 1. Format Type descriptor bLength == 10: non-standard extension
+ *    with max sample rate in bytes 6..9.
+ *
+ * 2. bmControls VAL_ALT_SETTINGS readable bit: when set, the device
+ *    only supports the highest rate pair for that altsetting, and when
+ *    clear, all rates up to max_rate are valid.
+ *
+ * For devices without the bLength == 10 extension but with
+ * VAL_ALT_SETTINGS readable and multiple altsettings (only seen in
+ * Scarlett 18i8 3rd Gen playback), fall back to the Focusrite
+ * convention: alt 1 = 48kHz, alt 2 = 96kHz, alt 3 = 192kHz.
  */
 static bool focusrite_valid_sample_rate(struct snd_usb_audio *chip,
 					struct audioformat *fp,
@@ -314,8 +342,10 @@ static bool focusrite_valid_sample_rate(struct snd_usb_audio *chip,
 {
 	struct usb_interface *iface;
 	struct usb_host_interface *alts;
+	struct uac2_as_header_descriptor *as;
 	unsigned char *fmt;
 	unsigned int max_rate;
+	bool val_alt;
 
 	iface = usb_ifnum_to_if(chip->dev, fp->iface);
 	if (!iface)
@@ -327,26 +357,58 @@ static bool focusrite_valid_sample_rate(struct snd_usb_audio *chip,
 	if (!fmt)
 		return true;
 
+	as = snd_usb_find_csint_desc(alts->extra, alts->extralen,
+				     NULL, UAC_AS_GENERAL);
+	if (!as)
+		return true;
+
+	val_alt = uac_v2v3_control_is_readable(as->bmControls,
+					       UAC2_AS_VAL_ALT_SETTINGS);
+
 	if (fmt[0] == 10) { /* bLength */
 		max_rate = combine_quad(&fmt[6]);
 
-		/* Validate max rate */
-		if (max_rate != 48000 &&
-		    max_rate != 96000 &&
-		    max_rate != 192000 &&
-		    max_rate != 384000) {
-
+		if (val_alt)
+			return focusrite_rate_pair(rate, max_rate);
+
+		/* No val_alt: rates fall through from higher */
+		switch (max_rate) {
+		case 192000:
+			if (rate == 176400 || rate == 192000)
+				return true;
+			fallthrough;
+		case 96000:
+			if (rate == 88200 || rate == 96000)
+				return true;
+			fallthrough;
+		case 48000:
+			return (rate == 44100 || rate == 48000);
+		default:
 			usb_audio_info(chip,
 				"%u:%d : unexpected max rate: %u\n",
 				fp->iface, fp->altsetting, max_rate);
-
 			return true;
 		}
+	}
 
-		return rate <= max_rate;
+	if (!val_alt)
+		return true;
+
+	/* Multi-altsetting device with val_alt but no max_rate
+	 * in the format descriptor. Use Focusrite convention:
+	 * alt 1 = 48kHz, alt 2 = 96kHz, alt 3 = 192kHz.
+	 */
+	if (iface->num_altsetting <= 2)
+		return true;
+
+	switch (fp->altsetting) {
+	case 1:		max_rate = 48000; break;
+	case 2:		max_rate = 96000; break;
+	case 3:		max_rate = 192000; break;
+	default:	return true;
 	}
 
-	return true;
+	return focusrite_rate_pair(rate, max_rate);
 }
 
 /*
-- 
2.53.0



