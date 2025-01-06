Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3326F8635E;
	Mon,  6 Jan 2025 15:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176954; cv=none; b=HjapQrwA3Vi++oFEYjrZwbGyn7IU3yLLhG9uzNViZwR+dDyHTAymwNUBucKe4G2f8jqJeI6/nFkeMz5M33cAH7n525c4mDRlBzntk3f9gEZl3Lbj77ac9nVvRSXG/PWdx32rbg/74W8GB1Qa7rwHJiPXpYNDp6ISP+nQ3sUtCUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176954; c=relaxed/simple;
	bh=2zgGxaI9h6VFYRZ+B1tDEIwZXZ7JaWdQtT+WwUYj+6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8bTHudeyaYrRDR7489MV0yXhPnbCaqZ4nQjx2iB6P0VDEqhjCHWC1S+Ok4PMKtg/sUjN9IldgNlvd0y6Vvz66mYSykqLl4wXTO2hPeF56i1O9/CNepWmjboYI5XApQ24Zr6H5F9aqTorgAjO6RjHpWWaBhTay1l3iv94OG+goE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EFYxwXgc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EFYxwXgc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE75CC4CED2;
	Mon,  6 Jan 2025 15:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176954;
	bh=2zgGxaI9h6VFYRZ+B1tDEIwZXZ7JaWdQtT+WwUYj+6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EFYxwXgcSNOAlsk/8OtTVyuhX0x8mSIUJ/Nyyy8+MmrsL8cVSlcFMCbUyrmB6Naw/
	 o2rWSfAMHS8GRTueXY6fEnd7SdQwcTzc1chBnvSAebfvyOsCQuOFFQ24mv5+a+SdBB
	 Kbs8pugOlU/e4xF9J3s+oC2yDKbmyaNbEbpsEoT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.com>,
	Adrian Ratiu <adrian.ratiu@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 58/81] sound: usb: format: dont warn that raw DSD is unsupported
Date: Mon,  6 Jan 2025 16:16:30 +0100
Message-ID: <20250106151131.625550325@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



