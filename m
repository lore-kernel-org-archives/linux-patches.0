Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB7932B108;
	Sat, 12 Sep 2026 15:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226596; cv=none; b=RH814s/fcsevn8s5eBBc+0tpJANq3pxUduwJCsa6Do/3eAHapiUxwegay2RDeu9jUXlL6vLzPqqq1OjlnjbXSF5whjfhPBSxXftgus4jLa+hilFsDHz2PfBBXAy8E62Ta0ZMhTTBDzO+5WJO4VS18Quyvvz+r/3+S1rFTJh0EUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226596; c=relaxed/simple;
	bh=j8QmyprU65PvbTQxIJGQ8/8r/1/we56Qhz6WsYfxQ48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t13Tbyv0tHq882cAAqWksYO7pN7j5226EgRuxMux0N+oyS4QdfJJZRHT05ZeM45/Bk6UIksQz/B/cwKSv1RxJdfIJUP4duHE0wWMkG6id0cR3QuN1rygeGabyrmPo3bMRZujr2EyK6cEQLubJxdsn5jAd1Ux1FGihVYwInV/Vz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KlbyqTuE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KlbyqTuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08DE1F000FF;
	Sat, 12 Sep 2026 15:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226594;
	bh=qqnkHIpixUsNB15Ulu8qTPBHGjbJF56AA9OnEJtGxwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KlbyqTuESLsXSGb9YUAQLgnu9IRAPjl5O6649mrSoDJu4hRLj90qyq3JLhGvKkD+1
	 hQszVKlADQGT3LIBQlvYzxo4AMlaNGvhHqU4H0TqCJ6e6df2amikI7t77QK0/C4Xbx
	 tODQqM6kDO+jCRh5dDqL291V8R4OauacS7EQsOaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8fa95c41eafbc9d2ff6f@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.com>,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>
Subject: [PATCH 6.1 0002/1191] ALSA: aloop: Fix peer runtime UAF during format-change stop
Date: Sat, 12 Sep 2026 08:45:30 +0200
Message-ID: <20260912065548.152301343@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ used scoped_guard(spinlock_irq) instead of guard(spinlock_irq) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
[ Karl Mehltretter: 6.12.y commit 03f52a9c1704 applies to 6.1.y/6.6.y
  unchanged; identical patch-id. ]
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/aloop.c | 44 +++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index 67bbadcec02b0..64870381d66ec 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -98,6 +98,9 @@ struct loopback_ops {
 struct loopback_cable {
 	spinlock_t lock;
 	struct loopback_pcm *streams[2];
+	/* in-flight peer stops running outside cable->lock */
+	atomic_t stop_count;
+	wait_queue_head_t stop_wait;
 	struct snd_pcm_hardware hw;
 	/* flags */
 	unsigned int valid;
@@ -347,8 +350,11 @@ static int loopback_check_format(struct loopback_cable *cable, int stream)
 				return 0;
 			if (stream == SNDRV_PCM_STREAM_CAPTURE)
 				return -EIO;
-			else if (cruntime->state == SNDRV_PCM_STATE_RUNNING)
+			else if (cruntime->state == SNDRV_PCM_STATE_RUNNING) {
+				/* close must not free the peer runtime below */
+				atomic_inc(&cable->stop_count);
 				stop_capture = true;
+			}
 		}
 
 		setup = get_setup(dpcm_play);
@@ -371,8 +377,11 @@ static int loopback_check_format(struct loopback_cable *cable, int stream)
 		}
 	}
 
-	if (stop_capture)
+	if (stop_capture) {
 		snd_pcm_stop(dpcm_capt->substream, SNDRV_PCM_STATE_DRAINING);
+		if (atomic_dec_and_test(&cable->stop_count))
+			wake_up(&cable->stop_wait);
+	}
 
 	return 0;
 }
@@ -1004,24 +1013,29 @@ static void free_cable(struct snd_pcm_substream *substream)
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
+	scoped_guard(spinlock_irq, &cable->lock) {
+		cable->streams[substream->stream] = NULL;
+		other_alive = cable->streams[!substream->stream];
 	}
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
@@ -1216,6 +1230,8 @@ static int loopback_open(struct snd_pcm_substream *substream)
 			goto unlock;
 		}
 		spin_lock_init(&cable->lock);
+		atomic_set(&cable->stop_count, 0);
+		init_waitqueue_head(&cable->stop_wait);
 		cable->hw = loopback_pcm_hardware;
 		if (loopback->timer_source)
 			cable->ops = &loopback_snd_timer_ops;
-- 
2.53.0



