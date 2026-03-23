Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E229935957;
	Mon, 23 Mar 2026 15:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278126; cv=none; b=pdV5KPNfpm5DOpeSiOZRPggv1mpHAiH7liKaX3rbz8rcs3gHmyISUfyXk0IcbhiXs5KMhMPK90U0c3qapghw5rncdST9xPnLtnciPUjvKQaV1wplbA/Uz/xnZZ7T24Oli3llVDzNMxgvpacnTLj0Dor8LMmAQbCfl57rSaV8SuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278126; c=relaxed/simple;
	bh=31PCjpsfA2j79d4tc7ufAySCDf52Ctd4FXHqCzaXn6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KEYHQFLG2etSibvlYD1Oj0KVpgX6AzmWsNmDyaVF8Vi7wPQbWf5KPWQm2olBBZ+XsRJauEFolsJi2xbPPrryrXCnI5jn0Wvpa2C2a6fhbHcXViciyGu0+WMQLO2HPRZjQrOP986YXhvN+FJRlRiJLHLlUhnyUaIvIRQ3yL52thg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SUafuR+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SUafuR+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16644C4CEF7;
	Mon, 23 Mar 2026 15:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278125;
	bh=31PCjpsfA2j79d4tc7ufAySCDf52Ctd4FXHqCzaXn6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SUafuR+CjaSvvcKgentVnY6aWREzvG7BoHCrSyYO32SemscOI0hyy4OkNNgZiOn1d
	 rZViqw6tCOdgpuJhuYWlAUw2i2W499q+vwZ8d/47JDOeinaSuWiLz/7bd3yIhodeQC
	 7fV5MZZ3QkmsnEoi2ZbvXtuVqKXn/4AtnA3IRJ6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 209/567] ALSA: usb-audio: Avoid implicit feedback mode on DIYINHK USB Audio 2.0
Date: Mon, 23 Mar 2026 14:42:09 +0100
Message-ID: <20260323134539.006699604@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit c5bf24c8aba1ff711226ee0f039ff01a5754692b ]

Although DIYINHK USB Audio 2.0 (ID 20b1:2009) shows the implicit
feedback source for the capture stream, this would cause several
problems for the playback.  Namely, the device can get wMaxPackSize
1024 for 24/32 bit format with 6 channels, and when a high sample rate
like 352.8kHz or 384kHz is played, the packet size overflows the max
limit.  Also, the device has another two playback altsets, and those
aren't properly handled with the implicit feedback.

Since the device has been working well even before introducing the
implicit feedback, we can assume that it works fine in the async mode.
This patch adds the explicit skip of the implicit fb detection to make
the playback running in the async mode.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221076
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260225085233.316306-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 15e72c419dbc2..04896ab01f372 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2251,6 +2251,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_SHARE_MEDIA_DEVICE | QUIRK_FLAG_ALIGN_TRANSFER),
 	DEVICE_FLG(0x2040, 0x7281, /* Hauppauge HVR-950Q-MXL */
 		   QUIRK_FLAG_SHARE_MEDIA_DEVICE | QUIRK_FLAG_ALIGN_TRANSFER),
+	DEVICE_FLG(0x20b1, 0x2009, /* XMOS Ltd DIYINHK USB Audio 2.0 */
+		   QUIRK_FLAG_SKIP_IMPLICIT_FB | QUIRK_FLAG_DSD_RAW),
 	DEVICE_FLG(0x2040, 0x8200, /* Hauppauge Woodbury */
 		   QUIRK_FLAG_SHARE_MEDIA_DEVICE | QUIRK_FLAG_ALIGN_TRANSFER),
 	DEVICE_FLG(0x21b4, 0x0081, /* AudioQuest DragonFly */
-- 
2.51.0



