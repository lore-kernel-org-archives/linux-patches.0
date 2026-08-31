Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BF7489897;
	Mon, 31 Aug 2026 14:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185005; cv=none; b=ruUC3GUfYySZEdrdrtpAK/izcZ0IY4VJqM7MJ6YcGl1ao9Y9c14T5N4xDMCBMQzhecD46DB3zV0KEPbCCz3pnXuv/vOx5ScrEEJBW4CzCkq99Ew1+b5LWtlBPyQ6CieFvpZgw9X0FIaZafte6zqz0evvzZpGkpIhm/E0pFFTDjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185005; c=relaxed/simple;
	bh=ZwcyEM5nn2EXs284GioWHUqfwcRRFmmmuQLTfmvdrBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wr8cawikfFXk5heVmpR5pXESyNQMjhjnkwqWBQNApbaym9j9Ln0Y2HwVPmOYLkeJ5VdohUM1X2U0VobfXzhlYBHO+ONWOueOwHLowXPeqxx9LUkwDNuZ+XRse3rh8F9+3Z81dIRNyau39Ge51XOgItKOt+2hJXWQyBd473+cGc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0m/4t50K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0m/4t50K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B0B1F000E9;
	Mon, 31 Aug 2026 14:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185004;
	bh=4Kesdolgt3sp+RnJqI0n0cJEkUehGsCU2xU7FktDk2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0m/4t50K6lDLelmpiHYBc/d6ah/BK3GOe/FkfDstpiYP8pFy/fa9jufd9WJhWcT80
	 vMpwoifAsrkwX1CXkkuOepjZdCVsY/yYv4Wl34Qoq2ZLibUilYMzp+/byjpAUCuWgj
	 uvCbJ8RAABYfoN+eBubU0CiLcVjlXf+V6bVLLVS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehul Rao <mehulrao@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 20/69] ALSA: pcm: fix use-after-free on linked stream runtime in snd_pcm_drain()
Date: Mon, 31 Aug 2026 15:34:53 +0200
Message-ID: <20260831133359.454557357@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mehul Rao <mehulrao@gmail.com>

[ Upstream commit 9b1dbd69ba6f8f8c69bc7b77c2ce3b9c6ed05ba6 ]

In the drain loop, the local variable 'runtime' is reassigned to a
linked stream's runtime (runtime = s->runtime at line 2157).  After
releasing the stream lock at line 2169, the code accesses
runtime->no_period_wakeup, runtime->rate, and runtime->buffer_size
(lines 2170-2178) — all referencing the linked stream's runtime without
any lock or refcount protecting its lifetime.

A concurrent close() on the linked stream's fd triggers
snd_pcm_release_substream() → snd_pcm_drop() → pcm_release_private()
→ snd_pcm_unlink() → snd_pcm_detach_substream() → kfree(runtime).
No synchronization prevents kfree(runtime) from completing while the
drain path dereferences the stale pointer.

Fix by caching the needed runtime fields (no_period_wakeup, rate,
buffer_size) into local variables while still holding the stream lock,
and using the cached values after the lock is released.

Fixes: f2b3614cefb6 ("ALSA: PCM - Don't check DMA time-out too shortly")
Cc: stable@vger.kernel.org
Signed-off-by: Mehul Rao <mehulrao@gmail.com>
Link: https://patch.msgid.link/20260305193508.311096-1-mehulrao@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_native.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 831633edb77b6..c835fd0fe315a 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -2144,6 +2144,10 @@ static int snd_pcm_drain(struct snd_pcm_substream *substream,
 	for (;;) {
 		long tout;
 		struct snd_pcm_runtime *to_check;
+		unsigned int drain_rate;
+		snd_pcm_uframes_t drain_bufsz;
+		bool drain_no_period_wakeup;
+
 		if (signal_pending(current)) {
 			result = -ERESTARTSYS;
 			break;
@@ -2163,16 +2167,25 @@ static int snd_pcm_drain(struct snd_pcm_substream *substream,
 		snd_pcm_group_unref(group, substream);
 		if (!to_check)
 			break; /* all drained */
+		/*
+		 * Cache the runtime fields needed after unlock.
+		 * A concurrent close() on the linked stream may free
+		 * its runtime via snd_pcm_detach_substream() once we
+		 * release the stream lock below.
+		 */
+		drain_no_period_wakeup = to_check->no_period_wakeup;
+		drain_rate = to_check->rate;
+		drain_bufsz = to_check->buffer_size;
 		init_waitqueue_entry(&wait, current);
 		set_current_state(TASK_INTERRUPTIBLE);
 		add_wait_queue(&to_check->sleep, &wait);
 		snd_pcm_stream_unlock_irq(substream);
-		if (runtime->no_period_wakeup)
+		if (drain_no_period_wakeup)
 			tout = MAX_SCHEDULE_TIMEOUT;
 		else {
 			tout = 100;
-			if (runtime->rate) {
-				long t = runtime->buffer_size * 1100 / runtime->rate;
+			if (drain_rate) {
+				long t = drain_bufsz * 1100 / drain_rate;
 				tout = max(t, tout);
 			}
 			tout = msecs_to_jiffies(tout);
-- 
2.53.0



