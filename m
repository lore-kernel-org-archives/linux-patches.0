Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824963D668F;
	Tue, 16 Jun 2026 19:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636530; cv=none; b=so1m/KgSke1+J62mLuYyklUqvHeJSkZGbUHb2BolJemILV9GttJYY5Y7E/7uuqeNs8gRrycK1k6HsytRnSGNN6LUmPQbrJmVBhdgubM0N6lFumJHfyC+bQhsAmYokhUhPMptFkoptD7LiXHJHZfH2IEJyS9TQJHV55G6HRcnQDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636530; c=relaxed/simple;
	bh=h5q87jY3vhagRd0OIa5WOTAjoSvLJgqPI7lKE5shfZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k6Jbguif/wKf3l5JJs11ZA4cRvBnpz0/wCUyAMWUKxi1JSzrNfxXOrmfTLFeOZeKb1q56/gpbptIZKAzmic0R+Fby66KEp0zJOUeKT0oIM4vdHp16S1MewvCHokCRaT7eiZ0khggVGigs6asEXQvraEPL85VcLrn8+4OgXWDA2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uNudtdWX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uNudtdWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3820A1F000E9;
	Tue, 16 Jun 2026 19:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636529;
	bh=3mi4FLn4kTXOAMcMIjbu9FLd7JAlVcUB1+QnA10C75E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uNudtdWX/V6xNiJVbynzlklWWSfxjxrkziJKM6hhZggkSvjkbgAknNNah6c58DNGV
	 JDhe/hjZiBqwZTcPxbWBq1oJLvz8Vie7YYIXA77XSP5Hmvvemte6uJVtmMA6pJb9/D
	 qsnjMsYItIKBT1QLME7n1V4aKHJ/cCKIEX9dBwu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8fa95c41eafbc9d2ff6f@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.com>,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 249/342] ALSA: aloop: Fix peer runtime UAF during format-change stop
Date: Tue, 16 Jun 2026 20:29:05 +0530
Message-ID: <20260616145059.831355928@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit e5c33cdc6f402eab8abd36ecf436b22c9d3a8aff ]

loopback_check_format() may stop the capture side when playback starts
with parameters that no longer match a running capture stream. Commit
826af7fa62e3 ("ALSA: aloop: Fix racy access at PCM trigger") moved
the peer lookup under cable->lock, but the actual snd_pcm_stop() still
runs after dropping that lock.

A concurrent close can clear the capture entry from cable->streams[] and
detach or free its runtime while the playback trigger path still holds a
stale peer substream pointer.

Keep a per-cable count of in-flight peer stops before dropping
cable->lock, and make free_cable() wait for those stops before
detaching the runtime. This preserves the existing behavior while
making the peer runtime lifetime explicit.

Reported-by: syzbot+8fa95c41eafbc9d2ff6f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8fa95c41eafbc9d2ff6f
Fixes: 597603d615d2 ("ALSA: introduce the snd-aloop module for the PCM loopback")
Cc: stable@vger.kernel.org
Suggested-by: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260424-alsa-aloop-peer-stop-uaf-v2-1-94e68101db8a@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ collapsed inc/snd_pcm_stop/dec into the existing inline call site and used spin_lock_irq/unlock_irq instead of scoped_guard ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/drivers/aloop.c |   40 +++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -99,6 +99,9 @@ struct loopback_ops {
 struct loopback_cable {
 	spinlock_t lock;
 	struct loopback_pcm *streams[2];
+	/* in-flight peer stops running outside cable->lock */
+	atomic_t stop_count;
+	wait_queue_head_t stop_wait;
 	struct snd_pcm_hardware hw;
 	/* flags */
 	unsigned int valid;
@@ -342,8 +345,12 @@ static int loopback_check_format(struct
 	if (stream == SNDRV_PCM_STREAM_CAPTURE) {
 		return -EIO;
 	} else {
+		/* close must not free the peer runtime below */
+		atomic_inc(&cable->stop_count);
 		snd_pcm_stop(cable->streams[SNDRV_PCM_STREAM_CAPTURE]->
 					substream, SNDRV_PCM_STATE_DRAINING);
+		if (atomic_dec_and_test(&cable->stop_count))
+			wake_up(&cable->stop_wait);
 	      __notify:
 		runtime = cable->streams[SNDRV_PCM_STREAM_PLAYBACK]->
 							substream->runtime;
@@ -995,24 +1002,29 @@ static void free_cable(struct snd_pcm_su
 	struct loopback *loopback = substream->private_data;
 	int dev = get_cable_index(substream);
 	struct loopback_cable *cable;
+	struct loopback_pcm *dpcm;
+	bool other_alive;
 
 	cable = loopback->cables[substream->number][dev];
 	if (!cable)
 		return;
-	if (cable->streams[!substream->stream]) {
-		/* other stream is still alive */
-		spin_lock_irq(&cable->lock);
-		cable->streams[substream->stream] = NULL;
-		spin_unlock_irq(&cable->lock);
-	} else {
-		struct loopback_pcm *dpcm = substream->runtime->private_data;
 
-		if (cable->ops && cable->ops->close_cable && dpcm)
-			cable->ops->close_cable(dpcm);
-		/* free the cable */
-		loopback->cables[substream->number][dev] = NULL;
-		kfree(cable);
-	}
+	spin_lock_irq(&cable->lock);
+	cable->streams[substream->stream] = NULL;
+	other_alive = cable->streams[!substream->stream] != NULL;
+	spin_unlock_irq(&cable->lock);
+
+	/* Pair with the stop_count increment in loopback_check_format(). */
+	wait_event(cable->stop_wait, !atomic_read(&cable->stop_count));
+	if (other_alive)
+		return;
+
+	dpcm = substream->runtime->private_data;
+	if (cable->ops && cable->ops->close_cable && dpcm)
+		cable->ops->close_cable(dpcm);
+	/* free the cable */
+	loopback->cables[substream->number][dev] = NULL;
+	kfree(cable);
 }
 
 static int loopback_jiffies_timer_open(struct loopback_pcm *dpcm)
@@ -1207,6 +1219,8 @@ static int loopback_open(struct snd_pcm_
 			goto unlock;
 		}
 		spin_lock_init(&cable->lock);
+		atomic_set(&cable->stop_count, 0);
+		init_waitqueue_head(&cable->stop_wait);
 		cable->hw = loopback_pcm_hardware;
 		if (loopback->timer_source)
 			cable->ops = &loopback_snd_timer_ops;


