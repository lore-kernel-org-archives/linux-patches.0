Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A673AAF60;
	Sat, 17 Oct 2026 17:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258348; cv=none; b=pT8SF/sgwbg2OISZcqfX2LyqTo6nrrnM1e7Vty7ttJFHVfhUopIFEz0pGJFbQfeqN9Z28WA5ApXsCg+BzMeZaBCJXfY2Qc35PA7bPIjyhhnui52ZHWuYvXckRzt2hyfMMEk8tHnAvkN8DmCQc4HI2goANKnnqm9YfXFGCTCnWjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258348; c=relaxed/simple;
	bh=97CcMNBekm+AZaDS2WXiK5YWJggNZJNWE780hdO89vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hC1+XUP26MytWlKKNRUZLm6ZeL9MmgVsVmkITmrAHGwKaXCIvOvUd1v6xb+KA1c9K4Vw2KWCUiUHDfXUSrglKViaziBdTy0sxLxAKrknq0YWt4iTNdATIWvv4oH7Fi4QxXJPwct2DSTdfJuzRWQEqp8USdMY6YnpYCyVWp7IlYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YapbTHZ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YapbTHZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAF91F000C4;
	Sat, 17 Oct 2026 17:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258347;
	bh=Y26H7Jg9NuiynmfEwy1oclC6VxZ5yJH16oLZY7JIgTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YapbTHZ6JF3M+vtVPXZvKkhOek71XiVjb6JLlxslHQslDzXzgUUXjp2EMnMsaqNU6
	 N6Pzh7UT/z4dUjiFENYzw5V3vdMTlg/qoB4yK0mJlNQ3Fc/DyKhHXLiwGxJCMgJyfh
	 YuSLXgDsL7McI/05ALponofMAmxxEqyiyOtHJxgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6db0415d6d5c635f72cb@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0855/1674] ALSA: usb-audio: Prevent excessive number of frames
Date: Sat, 17 Oct 2026 17:52:07 +0200
Message-ID: <20261017160453.068507490@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
 sound/usb/pcm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 08bf535ed1632..5aadd1221f725 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1505,7 +1505,8 @@ static int prepare_playback_urb(struct snd_usb_substream *subs,
 
 	for (i = 0; i < ctx->packets; i++) {
 		counts = snd_usb_endpoint_next_packet_size(ep, ctx, i, avail);
-		if (counts < 0)
+		if (counts < 0 ||
+		    (frames + counts) * stride > ctx->buffer_size)
 			break;
 		/* set up descriptor */
 		urb->iso_frame_desc[i].offset = frames * stride;
-- 
2.53.0



