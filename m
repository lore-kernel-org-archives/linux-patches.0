Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CB73F54BE;
	Tue, 17 Mar 2026 16:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766128; cv=none; b=GT8aEj0ZaSTtPxILPwGdByLRHMKvIuZIxikOWu4e38TfUYOKpgQ4g/B1U86w7oobOBR4ciw+r9iq6Mb3yefa3Z+SlGfFMK2CI18BXpZfLmGW7Yum00Pdx8gAsXNAi+W9QSRiqbE9kl2A2Uj/lnvd5+5vI/p/GXL86q2tC42ONOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766128; c=relaxed/simple;
	bh=/I6QdEywpKjpgqByAVhycdDGUbjRcLj1g6Ul/fXO88M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgezDRq+4Y2uqdHFt8B2bCeDK/h9YJQQFOwhnWUKTGIxbo8rcaojQ1CEPd7/usqdf9SVUXgjdlQeQGPkOnPJxhwkXGsiDKPWEvhayAa0abGoWAjOG2onevzaebacXOSjiuhcSqQKNmd7xCefbSOflD6GKxqMZPnzu5KyAeIl9kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AB1ffyW/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AB1ffyW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C6CC4CEF7;
	Tue, 17 Mar 2026 16:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766128;
	bh=/I6QdEywpKjpgqByAVhycdDGUbjRcLj1g6Ul/fXO88M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AB1ffyW/F+6N1j0RZXhYyqabCh1op14EyITNMx/FpNet55OS7/MNwAfe5/TBPPekY
	 OY9x1BX6lwcWaA0ywcKMB/7vXAHgd0NcX1TOA7ZsJ4sr8Op3N4wB7tBzLYoB2TqK45
	 AQ97J//IE2mM/cZE8yfgV4YqeIhroJZARK7WhMpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 177/378] ALSA: usb-audio: Improve Focusrite sample rate filtering
Date: Tue, 17 Mar 2026 17:32:14 +0100
Message-ID: <20260317163013.519448655@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
 sound/usb/format.c | 70 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 65 insertions(+), 5 deletions(-)

diff --git a/sound/usb/format.c b/sound/usb/format.c
index 64cfe4a9d8cdf..1207c507882ad 100644
--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -305,17 +305,48 @@ static bool s1810c_valid_sample_rate(struct audioformat *fp,
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
 					unsigned int rate)
 {
+	struct usb_interface *iface;
 	struct usb_host_interface *alts;
+	struct uac2_as_header_descriptor *as;
 	unsigned char *fmt;
 	unsigned int max_rate;
+	bool val_alt;
 
 	alts = snd_usb_get_host_interface(chip, fp->iface, fp->altsetting);
 	if (!alts)
@@ -326,9 +357,21 @@ static bool focusrite_valid_sample_rate(struct snd_usb_audio *chip,
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
 
+		if (val_alt)
+			return focusrite_rate_pair(rate, max_rate);
+
+		/* No val_alt: rates fall through from higher */
 		switch (max_rate) {
 		case 192000:
 			if (rate == 176400 || rate == 192000)
@@ -344,12 +387,29 @@ static bool focusrite_valid_sample_rate(struct snd_usb_audio *chip,
 			usb_audio_info(chip,
 				"%u:%d : unexpected max rate: %u\n",
 				fp->iface, fp->altsetting, max_rate);
-
 			return true;
 		}
 	}
 
-	return true;
+	if (!val_alt)
+		return true;
+
+	/* Multi-altsetting device with val_alt but no max_rate
+	 * in the format descriptor. Use Focusrite convention:
+	 * alt 1 = 48kHz, alt 2 = 96kHz, alt 3 = 192kHz.
+	 */
+	iface = usb_ifnum_to_if(chip->dev, fp->iface);
+	if (!iface || iface->num_altsetting <= 2)
+		return true;
+
+	switch (fp->altsetting) {
+	case 1:		max_rate = 48000; break;
+	case 2:		max_rate = 96000; break;
+	case 3:		max_rate = 192000; break;
+	default:	return true;
+	}
+
+	return focusrite_rate_pair(rate, max_rate);
 }
 
 /*
-- 
2.51.0



