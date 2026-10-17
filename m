Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8EF394785;
	Sat, 17 Oct 2026 16:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253627; cv=none; b=rLh0MUd0dSqjkh2dJo5WuFodKZrDyTf2TvQI2mCv+10ZsGNSU4+0w3mavJjM25/Tgoo2yqBuD0KyN5ot0t+qHt3y+CPc8Y+gdTZianYpDGjpsfOqHeL2fv0Y34icUpUZZxq7SvJEDotu4EN3utQDiZRt6HMNe3rZr4wbBMowGvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253627; c=relaxed/simple;
	bh=bBF98VwzL2r4JiFm4xx0W9BMTaXGIOjeBgIQutcOHq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7V3NIPz6NX3hrGdLgpmtwCGDVuG5ZCuFDZpaxHlRZWWO90r3kbWGqRnaSPuXwkuOJ9kkPAVyEGDfVAWLM+kxyl/hatVTCJbQmM6Ibm/It1EjOvJDjdlCbcxVAouEJOsB0Nq53hQLddJQvQBrQCrXz5Thmu2vVh6r0couP2FD2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j0499+57; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j0499+57"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277CB1F000C4;
	Sat, 17 Oct 2026 16:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253625;
	bh=csN/Vwpj7OkOhCBh0SmFxpc4H3htS8hjL2lddFRnsuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j0499+57YM/SwvOtu2VweM9+tNCZxxzpSoDlwYhfajjC9a+5+xCEe1fagFB3RkGSk
	 evMzpRk4za9VrRUQ2OXca/hSgJCfJYvE7sa+MhsssqyflQLMww/33sj2NddxtKlLMN
	 KOxpzz+ERwaq9oUSPlglyiKBZu4FIRILVp5Vrkug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6db0415d6d5c635f72cb@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 180/869] ALSA: usb-audio: Prevent excessive number of frames
Date: Sat, 17 Oct 2026 17:50:21 +0200
Message-ID: <20261017160041.668026403@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 08bf535ed1632..3a4666e3bf277 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1505,7 +1505,7 @@ static int prepare_playback_urb(struct snd_usb_substream *subs,
 
 	for (i = 0; i < ctx->packets; i++) {
 		counts = snd_usb_endpoint_next_packet_size(ep, ctx, i, avail);
-		if (counts < 0)
+		if (counts < 0 || frames + counts >= ep->max_urb_frames)
 			break;
 		/* set up descriptor */
 		urb->iso_frame_desc[i].offset = frames * stride;
-- 
2.53.0



