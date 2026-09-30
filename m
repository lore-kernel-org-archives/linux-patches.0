Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E82243956;
	Wed, 30 Sep 2026 16:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785848; cv=none; b=A5DPZ6dnubWoU7SccG0LpccUdBDNRAFxJ0rPqmz8b2oPLoadxY3FL/KGPj7QmdbwTSmLvRgxsn8AnbY9JkXu0FLd8OFbfYQbbUbcAS2AMCLqqAb6WXo4K+HHr02vO0a7CHYVgI4vbo1MECtXQDSP1o2czT9+4BNiQgBH0orzuYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785848; c=relaxed/simple;
	bh=E3VYhllpxCPNnbs0YQNAzjXV7wj1yYRfLrfl83+nMd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RxNOCRiTUnjBhCTLs527o/WO4O703wtaeWVKs7tDUKOIfGez4SuLvooUa9YoKGO5p065EtneajvVy2UzTIqTLXU+LbfKV3nsFvtmB8XHJ1pKjGb2aV5T+VLYwDIdZ0ArUNpdWLA+BYGqfF+oVTW1jVZJUs0Dfy27zzNndL2bIlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WFiPpS8L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFiPpS8L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4321F000FF;
	Wed, 30 Sep 2026 16:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785847;
	bh=Hvk/DNMl79fqqL39DA0D4HQxRdXcQdcpTcL8XxGpejg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WFiPpS8LImV20vd+zXX4zBum+I2DQMuiy2iHZSUEoExmbJrhfszFoWphP000rh+J1
	 2oYn4mgORYyRxJ3Nfo67so71NQwNogm9/oItDEfUe1M7wpsFPBpbVmp5Kj4XNr8UO6
	 9ODGNUSyH6M58MPW5oL/3/nze/dBq8ATHFp/bKMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+19da64013c46df87f971@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 654/982] ALSA: pcm: set timer->private_data before registering the PCM timer
Date: Wed, 30 Sep 2026 17:23:10 +0200
Message-ID: <20260930152430.814399011@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

[ Upstream commit 1e713f9bb2ac583521f06b0eb4e22440b1e3d078 ]

snd_pcm_timer_init() calls snd_device_register() to link the new
struct snd_timer into the global timer list while it still carries
hw.c_resolution = snd_pcm_timer_resolution (and hw.start/hw.stop),
and only afterwards sets timer->private_data = substream.

Once the timer is on the list under register_mutex, a concurrent
reader can already reach it through the same mutex and invoke these
callbacks. /proc/asound/timers does this via c_resolution(), and
snd_timer_open()+snd_timer_start() reach start()/stop() the same way.
All three dereference timer->private_data, which for this brief
window is NULL, giving a NULL-pointer dereference:

  substream = timer->private_data;
  return substream->runtime ? ...   // substream is NULL

Move the private_data/private_free assignment before
snd_device_register() so the timer is never visible on the list
without its private_data set. On the snd_device_register() failure
path, private_free() (snd_pcm_timer_free()) can now run, but it only
does substream->timer = NULL, which is already NULL at that point
since substream->timer is set to the new timer just once, after a
successful registration -- so the failure path stays safe.

Reported-by: syzbot+19da64013c46df87f971@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=19da64013c46df87f971
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Link: https://patch.msgid.link/20260913134446.114724-1-ngocthang2710.1999@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_timer.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/core/pcm_timer.c b/sound/core/pcm_timer.c
index c43484b22b34c..725a7272cd076 100644
--- a/sound/core/pcm_timer.c
+++ b/sound/core/pcm_timer.c
@@ -112,12 +112,15 @@ void snd_pcm_timer_init(struct snd_pcm_substream *substream)
 				"capture" : "playback",
 			tid.card, tid.device, tid.subdevice);
 	timer->hw = snd_pcm_timer;
+	/* Set before registering: a concurrent reader can invoke our hw
+	 * callbacks as soon as the timer is on the global list.
+	 */
+	timer->private_data = substream;
+	timer->private_free = snd_pcm_timer_free;
 	if (snd_device_register(timer->card, timer) < 0) {
 		snd_device_free(timer->card, timer);
 		return;
 	}
-	timer->private_data = substream;
-	timer->private_free = snd_pcm_timer_free;
 	substream->timer = timer;
 }
 
-- 
2.53.0



