Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A15D2DF132;
	Tue, 17 Mar 2026 17:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768029; cv=none; b=Vjq9daCtxQ9esrHg3gYLX1qZzv48a/qbU4P3jTXb0X1dMzhoQv35exsWrB4v46WcwgWDKvsXJ43s/WHao0L/yhiU3cR2AULYBuO4qqySCYqXT+24qx3dZP4jpkHqF0agYUmBawuXvDBMhYWS4refSW0413lWlXlbi2cgPfzf5fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768029; c=relaxed/simple;
	bh=AqJ+5J3Ad6Is66Y9RfHelIJwiE2H3n14LszFEPa7v44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nsHdU5ff6LTSD/MGS/bbkTD1X6+8KjEvEBhi6e1PqogcHRCHvw0G3CpDXOkKxire1ZLPZKbyorkomCYPh0ftS17mNZYSx9thWgEVtHpDCyFFkxxrMol5JNjsfdjbDuLF8KwWEsXP0grk3IOhyNWj1U4sVssBjJXZIEFm0ccWiPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aaCSkC1S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aaCSkC1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD260C2BCB2;
	Tue, 17 Mar 2026 17:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768029;
	bh=AqJ+5J3Ad6Is66Y9RfHelIJwiE2H3n14LszFEPa7v44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aaCSkC1SUFfWsMjsbltTerpcXHapOUm/G3g5TbDOvpS2eKzX4gjwsP8FDydhrM92g
	 lPBOlF4OU69QEO+6+Zx1jFMVRdYAVmCXne223v614gsYwws5KhgsEydE0tDbRSKoCS
	 h/ghlLWAIE6VYw30av8zzRkAYCQ21Tvs6WCC36d0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 173/333] ALSA: usb-audio: Improve Focusrite sample rate filtering
Date: Tue, 17 Mar 2026 17:33:22 +0100
Message-ID: <20260317163005.773638533@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ec95a063beb10..53b5dc5453b78 100644
--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -302,17 +302,48 @@ static bool s1810c_valid_sample_rate(struct audioformat *fp,
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
@@ -323,9 +354,21 @@ static bool focusrite_valid_sample_rate(struct snd_usb_audio *chip,
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
@@ -341,12 +384,29 @@ static bool focusrite_valid_sample_rate(struct snd_usb_audio *chip,
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



