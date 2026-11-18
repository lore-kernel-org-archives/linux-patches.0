Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032044;
	b=mKqBrdrf9k6TV9RGa31Yb8ZlCU+6HklDIVwTDSUVy8PZi9ezGTGGSRNKu+uz6zWx26r6
	 Nm1KXuhPvU62jbAyxZiYllPxHUxmLPms4tH6dE0qEB+yOHqLb1qyU6z9nAhCqxAABlQJ0
	 yTzVAnRILFTHGBK362F6v9Ini89cyNbTdZBP4tm2IJskyF0k4E2OOnaaeyGCjCxV9AeGU
	 0/eDQm9bETLeVvu5YPbPuA4CpMaSz4eLGCHqDZE3Z95FG2tD88PGxytWXb0c6d3C4qV/f
	 mTz0fTGWYcjSvQUTT4GtBospxPG6R4zBo5AUXtTwXYhRs1GhPLY6oc2yHKNMrHTvLzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+B1rOdCTb9IbjFMoWiEI8Lk/SKltmubVXBG4GPl/f7I=;
	b=wbjCUhkg2kUSc+ZpbWhz80NJfagL09WcePDeNKuYXt6N6poNImg/KH9s4apeXsqYzWko
	 IHN2tLAvsQbhGzZ6vSxydHXAKCBa6c6GATcL8bbhdpZ60bkKsTYQJQR3hXZFEdevfWs8H
	 o8QEcYFfWkhQoN2IounmSqjzTCLibmDgu7Nl2h4dDKgBMuyHAnaw5ddMwlHgK7FgU7Jtr
	 VjV9KThl3PjHF8ij2M6omAJ1sh10L/aCeSB1tHuXsKAdGyAP4IM6NJdKVaVQd3TIgZT5D
	 60CLyZYqFFYxl8cl8ohii/LFHO3uv8ajHX7R3YkshGAqbL2t8vuaJDzqfF83n6NNH6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m8lhRaVl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205F5606A339;
	Wed, 18 Nov 2026 20:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m8lhRaVl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7157B1F000C4;
	Wed, 18 Nov 2026 20:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032044;
	bh=+B1rOdCTb9IbjFMoWiEI8Lk/SKltmubVXBG4GPl/f7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m8lhRaVlk8Gee60ZNMXr+O7VYa2Uym1w3nsjuiSA6MdjOyYkLSnnAN5FBG/FDM/jN
	 6sjFNApjxc1s0Nt0eDVJRHbMWBdcCa+w3DhUTodgjUJ22Vm1BjJGESiNs29chQKx4x
	 Z5OITilyAxQueC9TXeq0OanAubVY9W0LhHKOC7Eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1271/1756] ALSA: pcm: Add refcount for races between drain and unlink
Date: Wed, 18 Nov 2026 15:56:38 +0100
Message-ID: <20261118150100.230885510@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 91d0048a97e0fdc0a071caa0ba59e659bc6f84df ]

We added a workaround for the case where a linked substream gets
unlinked during the drain operation by another substream of the same
linked group in the commit 9b1dbd69ba6f ("ALSA: pcm: fix
use-after-free on linked stream runtime in snd_pcm_drain()").
There, we just cached the parameters of the draining substream for
avoiding UAF.

Then, we check the draining substream (to_check) again in the loop and
remove it from the queue only when it's still present.  It means,
however, that the wait queue entry won't be removed if the substream
went out of the link beforehand, hence a stale wq entry remains.
Later on, this can be woken up, and this may hit a UAF, too.
The problem surfaced more due to the recent change to call
snd_pcm_unlink() earlier.

For properly handling both cases above, in this patch, we introduce a
refcount to the snd_pcm_runtime that indicates the substream is being
accessed / used, then at snd_pcm_release_substream(), it's synced
before the actual resource release via snd_refcount_sync().  This
guarantees that the accessors are finished, and safe to release
memories.  Along with the introduction of a refcount, the comments and
the code changes by the former fix were partially reverted as they
don't fit with the updated code flow any longer.

Last but not least, the setup of wait queue entry and
prepare_to_wait() call are moved before the group unref.  With this
change, we can avoid the race between the enqueue and the wakeup, too.

Fixes: 9b1dbd69ba6f ("ALSA: pcm: fix use-after-free on linked stream runtime in snd_pcm_drain()")
Link: https://patch.msgid.link/20261015071838.31082-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/pcm.h     |  2 ++
 sound/core/pcm.c        |  1 +
 sound/core/pcm_native.c | 54 ++++++++++++++++-------------------------
 3 files changed, 24 insertions(+), 33 deletions(-)

diff --git a/include/sound/pcm.h b/include/sound/pcm.h
index 43586392b6134..73a79fe341aed 100644
--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -8,6 +8,7 @@
  *                   Abramo Bagnara <abramo@alsa-project.org>
  */
 
+#include <sound/core.h>
 #include <sound/asound.h>
 #include <sound/memalloc.h>
 #include <sound/minors.h>
@@ -416,6 +417,7 @@ struct snd_pcm_runtime {
 	snd_pcm_uframes_t twake; 	/* do transfer (!poll) wakeup if non-zero */
 	wait_queue_head_t sleep;	/* poll sleep */
 	wait_queue_head_t tsleep;	/* transfer sleep */
+	struct snd_refcount refcnt;	/* refcount for draining, etc */
 	struct snd_fasync *fasync;
 	bool stop_operating;		/* sync_stop will be called */
 	struct mutex buffer_mutex;	/* protect for buffer changes */
diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index 18979f88f7159..bc4f90874ce3a 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -963,6 +963,7 @@ int snd_pcm_attach_substream(struct snd_pcm *pcm, int stream,
 
 	init_waitqueue_head(&runtime->sleep);
 	init_waitqueue_head(&runtime->tsleep);
+	snd_refcount_init(&runtime->refcnt);
 
 	__snd_pcm_set_state(runtime, SNDRV_PCM_STATE_OPEN);
 	mutex_init(&runtime->buffer_mutex);
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 3f977f4d62600..8f023ef792213 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -2156,9 +2156,6 @@ static int snd_pcm_drain(struct snd_pcm_substream *substream,
 	for (;;) {
 		long tout;
 		struct snd_pcm_runtime *to_check;
-		unsigned int drain_rate;
-		snd_pcm_uframes_t drain_bufsz;
-		bool drain_no_period_wakeup;
 
 		if (signal_pending(current)) {
 			result = -ERESTARTSYS;
@@ -2173,45 +2170,35 @@ static int snd_pcm_drain(struct snd_pcm_substream *substream,
 			runtime = s->runtime;
 			if (runtime->state == SNDRV_PCM_STATE_DRAINING) {
 				to_check = runtime;
+				/* pin the draining substream */
+				snd_refcount_get(&to_check->refcnt);
+
+				init_wait_entry(&wait, 0);
+				prepare_to_wait(&to_check->sleep, &wait,
+						TASK_INTERRUPTIBLE);
+				if (to_check->no_period_wakeup) {
+					tout = MAX_SCHEDULE_TIMEOUT;
+				} else {
+					tout = 100;
+					if (to_check->rate) {
+						long t = to_check->buffer_size *
+							1100 / to_check->rate;
+						tout = max(t, tout);
+					}
+					tout = msecs_to_jiffies(tout);
+				}
 				break;
 			}
 		}
 		snd_pcm_group_unref(group, substream);
 		if (!to_check)
 			break; /* all drained */
-		/*
-		 * Cache the runtime fields needed after unlock.
-		 * A concurrent close() on the linked stream may free
-		 * its runtime via snd_pcm_detach_substream() once we
-		 * release the stream lock below.
-		 */
-		drain_no_period_wakeup = to_check->no_period_wakeup;
-		drain_rate = to_check->rate;
-		drain_bufsz = to_check->buffer_size;
-		init_wait_entry(&wait, 0);
-		prepare_to_wait(&to_check->sleep, &wait, TASK_INTERRUPTIBLE);
 		snd_pcm_stream_unlock_irq(substream);
-		if (drain_no_period_wakeup)
-			tout = MAX_SCHEDULE_TIMEOUT;
-		else {
-			tout = 100;
-			if (drain_rate) {
-				long t = drain_bufsz * 1100 / drain_rate;
-				tout = max(t, tout);
-			}
-			tout = msecs_to_jiffies(tout);
-		}
 		tout = schedule_timeout(tout);
-
 		snd_pcm_stream_lock_irq(substream);
-		group = snd_pcm_stream_group_ref(substream);
-		snd_pcm_group_for_each_entry(s, substream) {
-			if (s->runtime == to_check) {
-				finish_wait(&to_check->sleep, &wait);
-				break;
-			}
-		}
-		snd_pcm_group_unref(group, substream);
+		finish_wait(&to_check->sleep, &wait);
+		/* unpin the draining substream again now */
+		snd_refcount_put(&to_check->refcnt);
 
 		if (card->shutdown) {
 			result = -ENODEV;
@@ -2763,6 +2750,7 @@ void snd_pcm_release_substream(struct snd_pcm_substream *substream)
 
 	snd_pcm_drop(substream);
 	if (substream->hw_opened) {
+		snd_refcount_sync(&substream->runtime->refcnt);
 		if (substream->runtime->state != SNDRV_PCM_STATE_OPEN)
 			do_hw_free(substream);
 		substream->ops->close(substream);
-- 
2.53.0



