Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056360;
	b=zwHFl1VCNvGqI85BA3GfZRnXDRFj8xcuicbGJqnC8mq3+t7JxxsEUr3Rf/fHTNL51VhE
	 zhg6BqLvEhO+vZke9IWX4XVm2ZlEmxR+IzLezxsoDdfRcXL+1FShzkJSYsFY4zfMCmCCc
	 BaaJVF7+uid3j2pK+wVGYo0XC84uNUntqoiGpstfSKaOyc9QmdBjVUmxrv3taRmnh7PhN
	 YOdIuy1YqJKzc6gBTJBsLOzFpSCwb3gmLbof6ugJ5PvrOqu3YNg5/RJI0Ka9vIuGjw+Fm
	 d5sLJumpg9sSz7cLuqatm9c5Pr2axcCpBUMcenQY2+Q3LWD5pGeCdpxXNBBURd5ukkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056360;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SwgUW/xGOQ+wA9cNMSshsu4Bfhw+otNJ5NnMMh8VQdo=;
	b=xCBtxbcKLvczOLnvRVwP8RBX7fWoqtt4MON+ri2v4ODmbNTckkitAltGkqMCBfVmieMF
	 2ZRbpHQyVhFsIndeMwc/92yl0Fh3jxDOKuU7ABM6ZS41NVCTBiJPBGAfaNNPgJSlFXFcz
	 cXbdNDtQ8Zj6NK1YtlWYug7HOHk7UMv4bSmNe3Ryh6/BKrgw0ZEkjdqdxkSfBp8iDXRoz
	 jkIbmRzi5DpxypJqq21ZI5mWDjjnSeumlXjjVM7/wtC66UQ1SB+wo6EvdxrD8Jira1ePH
	 ZGtTny6WbLPkbOQ6ecGY7ulE0XFmBt4YZy5g0pCYaFqeRzDhQHmx8/eF+0eVhH8ebZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JINzEdVT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F621606A320;
	Thu, 19 Nov 2026 02:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JINzEdVT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47461F000C4;
	Thu, 19 Nov 2026 02:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056360;
	bh=SwgUW/xGOQ+wA9cNMSshsu4Bfhw+otNJ5NnMMh8VQdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JINzEdVTmhrd4IOMSIACNzAIOM31TIKAPpf5WG8/tskRwID58pEM9isXijzGredS/
	 ZOij3aoEIroABNWLyLqTuXIyq9a/gz2c09rCscnYK5M/oFsOyh0X27Swyr1Q5Pvj1P
	 Vo2/5GMXvZ6dVhcsKZovcjcwHkWJtkUF0GqJwFiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1961/2214] ALSA: pcm: Add refcount for races between drain and unlink
Date: Wed, 18 Nov 2026 16:00:37 +0100
Message-ID: <20261118150129.400648254@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9a4cd00b3e221..ae9ce07fc919a 100644
--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -8,6 +8,7 @@
  *                   Abramo Bagnara <abramo@alsa-project.org>
  */
 
+#include <sound/core.h>
 #include <sound/asound.h>
 #include <sound/memalloc.h>
 #include <sound/minors.h>
@@ -398,6 +399,7 @@ struct snd_pcm_runtime {
 	snd_pcm_uframes_t twake; 	/* do transfer (!poll) wakeup if non-zero */
 	wait_queue_head_t sleep;	/* poll sleep */
 	wait_queue_head_t tsleep;	/* transfer sleep */
+	struct snd_refcount refcnt;	/* refcount for draining, etc */
 	struct snd_fasync *fasync;
 	bool stop_operating;		/* sync_stop will be called */
 	struct mutex buffer_mutex;	/* protect for buffer changes */
diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index 927974a7bcf70..73b44235c8373 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -970,6 +970,7 @@ int snd_pcm_attach_substream(struct snd_pcm *pcm, int stream,
 
 	init_waitqueue_head(&runtime->sleep);
 	init_waitqueue_head(&runtime->tsleep);
+	snd_refcount_init(&runtime->refcnt);
 
 	__snd_pcm_set_state(runtime, SNDRV_PCM_STATE_OPEN);
 	mutex_init(&runtime->buffer_mutex);
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 3a792defc3998..d3e347d764ada 100644
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
@@ -2747,6 +2734,7 @@ void snd_pcm_release_substream(struct snd_pcm_substream *substream)
 
 	snd_pcm_drop(substream);
 	if (substream->hw_opened) {
+		snd_refcount_sync(&substream->runtime->refcnt);
 		if (substream->runtime->state != SNDRV_PCM_STATE_OPEN)
 			do_hw_free(substream);
 		substream->ops->close(substream);
-- 
2.53.0



