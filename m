Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A78A2222B2;
	Mon,  9 Feb 2026 14:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647521; cv=none; b=jyuUjHICaNBA67jYEOSX9LlKUbgdGAJSqDhjndP5ACC8QsN9Us9zEe3fxZnIxVQXSF3ZGBCm+VIFzeYiDRuDK3bvp5V1TBIp1q8F8fzns8glZ3aJUFppX+XCAuK8DBbLF0tv1W6Za81KPdT8gDQ2UUAX1VSGh5etiWObEJN8ATc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647521; c=relaxed/simple;
	bh=R0V81tf7cke0ClPtU+8LOVnnlOnIaTtFUiLRO02Fl/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4q41/lllM0gSNIwBatfqLFaBddEl9MN5zAuxXZCmd0IEZu1dH5Tjqd9NfrRcK4N1nOj5k5tc0s6F3WZNae+my6v+5DCPOPfBD23AJ8p0+A3NFAlZDoRaWoDj8hHrHaJajuwnp7jL5HUA+2sOLxH1E244qgPhduG5iiP+2HoF0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I5SSXfBX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I5SSXfBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC194C19423;
	Mon,  9 Feb 2026 14:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647521;
	bh=R0V81tf7cke0ClPtU+8LOVnnlOnIaTtFUiLRO02Fl/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I5SSXfBXYcXpr2XSHyI8DNNEYRRSZ0sfDQRsUZksDWyO8VxAX08JxT6dJS8RTxJy9
	 S60FG5WIOWH+aFqztVPSqpNRUQObBQBayomiz3QcBAmTw6+UQSnDpElHdJMwKP6Mex
	 5DFe+lbMLrnyrcaVTBMLT+LqNk7+y/73hk8B5oL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6db0415d6d5c635f72cb@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 090/175] ALSA: usb-audio: Prevent excessive number of frames
Date: Mon,  9 Feb 2026 15:22:43 +0100
Message-ID: <20260209142323.669977815@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit ef5749ef8b307bf8717945701b1b79d036af0a15 ]

In this case, the user constructed the parameters with maxpacksize 40
for rate 22050 / pps 1000, and packsize[0] 22 packsize[1] 23. The buffer
size for each data URB is maxpacksize * packets, which in this example
is 40 * 6 = 240; When the user performs a write operation to send audio
data into the ALSA PCM playback stream, the calculated number of frames
is packsize[0] * packets = 264, which exceeds the allocated URB buffer
size, triggering the out-of-bounds (OOB) issue reported by syzbot [1].

Added a check for the number of single data URB frames when calculating
the number of frames to prevent [1].

[1]
BUG: KASAN: slab-out-of-bounds in copy_to_urb+0x261/0x460 sound/usb/pcm.c:1487
Write of size 264 at addr ffff88804337e800 by task syz.0.17/5506
Call Trace:
 copy_to_urb+0x261/0x460 sound/usb/pcm.c:1487
 prepare_playback_urb+0x953/0x13d0 sound/usb/pcm.c:1611
 prepare_outbound_urb+0x377/0xc50 sound/usb/endpoint.c:333

Reported-by: syzbot+6db0415d6d5c635f72cb@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6db0415d6d5c635f72cb
Tested-by: syzbot+6db0415d6d5c635f72cb@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Link: https://patch.msgid.link/tencent_9AECE6CD2C7A826D902D696C289724E8120A@qq.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 54d01dfd820fa..263abb36bb2d1 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1553,7 +1553,7 @@ static int prepare_playback_urb(struct snd_usb_substream *subs,
 
 		for (i = 0; i < ctx->packets; i++) {
 			counts = snd_usb_endpoint_next_packet_size(ep, ctx, i, avail);
-			if (counts < 0)
+			if (counts < 0 || frames + counts >= ep->max_urb_frames)
 				break;
 			/* set up descriptor */
 			urb->iso_frame_desc[i].offset = frames * stride;
-- 
2.51.0



