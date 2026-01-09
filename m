Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BCF2FBDF5;
	Fri,  9 Jan 2026 11:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959367; cv=none; b=SVL2cr17iLif1Zigea3Z7FmUY1ABvqBTYEy3lEtiK6m6jYyZQiuJa39rRhNXzZdEcsRj5ugFPFQajvoONTo8BkebgobXWJyCzZ3qOFfMdxh6t4VL3CbKuAQ8BMAbp99CbEtf55sFZji6qt257fZi55AjrfBiTn0qvbP0Yt/+W2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959367; c=relaxed/simple;
	bh=l8wf6lhljYxjQWa2t+w05AaaQzv23xBb9bKHjRnUhVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRNFdTqtfOIY3tBYVc1DRiV2hJ6LjOgUEuhkHDy3m+wIpb+mKDblAxwcTtB14NQBIKcR3ym8qPU9NpmOILrnTM53r6iXSmDChhN7QhUar7nb1Ft6VeFugvq3n01TxpwYS15DlQCr2SL3Jb5LwQXWtIqRMr8OhxRY38VW57f4ekY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P0A8ApRO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P0A8ApRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC95C4CEF1;
	Fri,  9 Jan 2026 11:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959367;
	bh=l8wf6lhljYxjQWa2t+w05AaaQzv23xBb9bKHjRnUhVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P0A8ApROXshlzde50U22S+1yQ59cAwEi+FjFXyqOHzp2PK54KHcdbv3HhBpTKOIJb
	 5dovR1jsqmX2jC1Ki90PWQnX3zIB2fDOs5CaBXFGeTUUus2d41p43bQDTd6Ht3NF1X
	 dRgvIG2uGSaIpXNDiHJji9E+3YWGiBV61jfOA67s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lushih Hsieh <bruce@mail.kh.edu.tw>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/737] ALSA: usb-audio: Add native DSD quirks for PureAudio DAC series
Date: Fri,  9 Jan 2026 12:32:46 +0100
Message-ID: <20260109112135.017778085@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lushih Hsieh <bruce@mail.kh.edu.tw>

[ Upstream commit 21a9ab5b90b3716a631d559e62818029b4e7f5b7 ]

The PureAudio APA DAC and Lotus DAC5 series are USB Audio
2.0 Class devices that support native Direct Stream Digital (DSD)
playback via specific vendor protocols.

Without these quirks, the devices may only function in standard
PCM mode, or fail to correctly report their DSD format capabilities
to the ALSA framework, preventing native DSD playback under Linux.

This commit adds new quirk entries for the mentioned DAC models
based on their respective Vendor/Product IDs (VID:PID), for example:
0x16d0:0x0ab1 (APA DAC), 0x16d0:0xeca1 (DAC5 series), etc.

The quirk ensures correct DSD format handling by setting the required
SNDRV_PCM_FMTBIT_DSD_U32_BE format bit and defining the DSD-specific
Audio Class 2.0 (AC2.0) endpoint configurations. This allows the ALSA
DSD API to correctly address the device for high-bitrate DSD streams,
bypassing the need for DoP (DSD over PCM).

Test on APA DAC and Lotus DAC5 SE under Arch Linux.

Tested-by: Lushih Hsieh <bruce@mail.kh.edu.tw>
Signed-off-by: Lushih Hsieh <bruce@mail.kh.edu.tw>
Link: https://patch.msgid.link/20251114052053.54989-1-bruce@mail.kh.edu.tw
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 68238e62020b0..44274f39d6937 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1922,6 +1922,8 @@ u64 snd_usb_interface_dsd_format_quirks(struct snd_usb_audio *chip,
 	case USB_ID(0x16d0, 0x09d8): /* NuPrime IDA-8 */
 	case USB_ID(0x16d0, 0x09db): /* NuPrime Audio DAC-9 */
 	case USB_ID(0x16d0, 0x09dd): /* Encore mDSD */
+	case USB_ID(0x16d0, 0x0ab1): /* PureAudio APA DAC */
+	case USB_ID(0x16d0, 0xeca1): /* PureAudio Lotus DAC5, DAC5 SE, DAC5 Pro */
 	case USB_ID(0x1db5, 0x0003): /* Bryston BDA3 */
 	case USB_ID(0x20a0, 0x4143): /* WaveIO USB Audio 2.0 */
 	case USB_ID(0x22e1, 0xca01): /* HDTA Serenade DSD */
@@ -2189,6 +2191,10 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_IGNORE_CLOCK_SOURCE),
 	DEVICE_FLG(0x1686, 0x00dd, /* Zoom R16/24 */
 		   QUIRK_FLAG_TX_LENGTH | QUIRK_FLAG_CTL_MSG_DELAY_1M),
+	DEVICE_FLG(0x16d0, 0x0ab1, /* PureAudio APA DAC */
+		   QUIRK_FLAG_DSD_RAW),
+	DEVICE_FLG(0x16d0, 0xeca1, /* PureAudio Lotus DAC5, DAC5 SE and DAC5 Pro */
+		   QUIRK_FLAG_DSD_RAW),
 	DEVICE_FLG(0x17aa, 0x1046, /* Lenovo ThinkStation P620 Rear Line-in, Line-out and Microphone */
 		   QUIRK_FLAG_DISABLE_AUTOSUSPEND),
 	DEVICE_FLG(0x17aa, 0x104d, /* Lenovo ThinkStation P620 Internal Speaker + Front Headset */
-- 
2.51.0



