Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88909188A0D;
	Mon,  6 Jan 2025 15:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177508; cv=none; b=SvlaBSLOErLGmAOuQHq0+T3gWXWiIad1V4/xQJMo3TyncTTTStZjtb6cXUFwVSJLAFftCEOaZglC4jhW/FWXhr3SdRmrfMWH3wX9c2taAjnSJbi4EqhnS2MKWXCaMoQSalPZ8GbHbkzxWigVPL67Uohp5m7uQMtPI+aRE/5VXM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177508; c=relaxed/simple;
	bh=6bxAKJaufLSLNtwoVnQ7GJz2AgY4CwciLME2jXQ0jOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azDlJw4OY2k3i9ZxRj8bjSJ1IQiYlxU7PeEqX5519Cdzrbbb1dceB2Fn/r/k5JhK5VvGROIowU3sQi9e0/0V6WSrjqoPz1jIgXw1wgHIMoCWzQx7EDqWKmxkkSPLgRoqiMr28pb3T6A0wqzeHzAxtQnzOfiycM83BtQid3QmNzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kydjh+6e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kydjh+6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11249C4CED6;
	Mon,  6 Jan 2025 15:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177507;
	bh=6bxAKJaufLSLNtwoVnQ7GJz2AgY4CwciLME2jXQ0jOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kydjh+6e4iBL46UgAOIOTCd+bjtzr7caPiV1Zbt2uwYlf729km7q8FacqJvbvPyE0
	 GMvXnGbLHN0fZtGyMCDqIzybFs34IicPuRA8NVo4Wm3LCF7wKer3Hmy9o2kFghjYHD
	 c8XpVYfwcQCpYQGwYLPgLFxNG/vnH2Nbv1IwYiYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.com>,
	Adrian Ratiu <adrian.ratiu@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 185/222] sound: usb: format: dont warn that raw DSD is unsupported
Date: Mon,  6 Jan 2025 16:16:29 +0100
Message-ID: <20250106151157.768256954@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Ratiu <adrian.ratiu@collabora.com>

[ Upstream commit b50a3e98442b8d72f061617c7f7a71f7dba19484 ]

UAC 2 & 3 DAC's set bit 31 of the format to signal support for a
RAW_DATA type, typically used for DSD playback.

This is correctly tested by (format & UAC*_FORMAT_TYPE_I_RAW_DATA),
fp->dsd_raw = true; and call snd_usb_interface_dsd_format_quirks(),
however a confusing and unnecessary message gets printed because
the bit is not properly tested in the last "unsupported" if test:
if (format & ~0x3F) { ... }

For example the output:

usb 7-1: new high-speed USB device number 5 using xhci_hcd
usb 7-1: New USB device found, idVendor=262a, idProduct=9302, bcdDevice=0.01
usb 7-1: New USB device strings: Mfr=1, Product=2, SerialNumber=6
usb 7-1: Product: TC44C
usb 7-1: Manufacturer: TC44C
usb 7-1: SerialNumber: 5000000001
hid-generic 0003:262A:9302.001E: No inputs registered, leaving
hid-generic 0003:262A:9302.001E: hidraw6: USB HID v1.00 Device [DDHIFI TC44C] on usb-0000:08:00.3-1/input0
usb 7-1: 2:4 : unsupported format bits 0x100000000

This last "unsupported format" is actually wrong: we know the
format is a RAW_DATA which we assume is DSD, so there is no need
to print the confusing message.

This we unset bit 31 of the format after recognizing it, to avoid
the message.

Suggested-by: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Adrian Ratiu <adrian.ratiu@collabora.com>
Link: https://patch.msgid.link/20241209090529.16134-2-adrian.ratiu@collabora.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/format.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/usb/format.c b/sound/usb/format.c
index 3b45d0ee7693..3b3a5ea6fcbf 100644
--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -60,6 +60,8 @@ static u64 parse_audio_format_i_type(struct snd_usb_audio *chip,
 			pcm_formats |= SNDRV_PCM_FMTBIT_SPECIAL;
 			/* flag potentially raw DSD capable altsettings */
 			fp->dsd_raw = true;
+			/* clear special format bit to avoid "unsupported format" msg below */
+			format &= ~UAC2_FORMAT_TYPE_I_RAW_DATA;
 		}
 
 		format <<= 1;
@@ -71,8 +73,11 @@ static u64 parse_audio_format_i_type(struct snd_usb_audio *chip,
 		sample_width = as->bBitResolution;
 		sample_bytes = as->bSubslotSize;
 
-		if (format & UAC3_FORMAT_TYPE_I_RAW_DATA)
+		if (format & UAC3_FORMAT_TYPE_I_RAW_DATA) {
 			pcm_formats |= SNDRV_PCM_FMTBIT_SPECIAL;
+			/* clear special format bit to avoid "unsupported format" msg below */
+			format &= ~UAC3_FORMAT_TYPE_I_RAW_DATA;
+		}
 
 		format <<= 1;
 		break;
-- 
2.39.5



