Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A568713B592;
	Mon,  6 Jan 2025 15:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178504; cv=none; b=cRSsPs6UYuLO6jFp8Td4aCb7D3V1yZrtwAmYys70PWixivmgjOrPZdcg4cwXp9Zg3YXaHmuMsTbNGozqDG3dogGrk1uRteIV15PHNSEA5fI6OUU8jZURdQnuH+kG9PUpP2tCcpgd/2YH/sfhWAakK5SBRRd/pFCJz+uDn57Nrds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178504; c=relaxed/simple;
	bh=VHlgCjQ25kzWdW4J7BQGLJu0/A9Ws2UFxhPAEpOwtWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PP5GjTgL0wObTvkvtTnJc7MrVo9JvyjW5r9zBt87uBBvHLz4aVwKp+2Cfdu0+lZ0nHBLSmTl3Geb4cyZ1aGOeeW8Nae+G+n10BBe8F/zN7xwE3YkZ0CewLxZITncQ00OopvD/TZrIA7S66MOo3CrWi2VYiCNfQ70oj88hiHJH5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mhpbRAwb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mhpbRAwb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06353C4CED2;
	Mon,  6 Jan 2025 15:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178504;
	bh=VHlgCjQ25kzWdW4J7BQGLJu0/A9Ws2UFxhPAEpOwtWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mhpbRAwbEZEyy60j15YAxZhjZ8WdA5TxxfAMvequHGwSROJAbxxqGpvw/2S45yg11
	 E4aBylaYEsHSYHznXOCYkKRNsJzmDcS8oY92jHAD8Y8wr8yfHNlTA8B4iackANsvQp
	 k92OM7Vx7a5wzFVAVwHQLh+cKg7Cxyc+Ybq5Fy34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.com>,
	Adrian Ratiu <adrian.ratiu@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 124/138] sound: usb: format: dont warn that raw DSD is unsupported
Date: Mon,  6 Jan 2025 16:17:28 +0100
Message-ID: <20250106151137.926857583@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 29ed301c6f06..552094012c49 100644
--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -61,6 +61,8 @@ static u64 parse_audio_format_i_type(struct snd_usb_audio *chip,
 			pcm_formats |= SNDRV_PCM_FMTBIT_SPECIAL;
 			/* flag potentially raw DSD capable altsettings */
 			fp->dsd_raw = true;
+			/* clear special format bit to avoid "unsupported format" msg below */
+			format &= ~UAC2_FORMAT_TYPE_I_RAW_DATA;
 		}
 
 		format <<= 1;
@@ -72,8 +74,11 @@ static u64 parse_audio_format_i_type(struct snd_usb_audio *chip,
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



