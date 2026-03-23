Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F43F258EE9;
	Mon, 23 Mar 2026 15:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278297; cv=none; b=Ei+8u/RgVOQz2iXX9X34B8zVIN70OVJVMSmoIECp0516ba8CJaS7lO5rlNfSic8+2qb+gQxEojFIG5aHI4mxVOo8CZUgbofPFTCMytK6v5FDmQZkw9TokUFjCf8H+esGWu7E08R2VoJT1o86FeBK0mFtZEWe0bUAwGSNJG0eNPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278297; c=relaxed/simple;
	bh=WgBE758EYTpk/L+J04ljxDzEis7UK2/CYEk+QdgnCe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E0hGkSByvZNUL1HBZAE1swfIqfU7WDURcyBagx7Gly1xrX9Q++z8JyEKlh/ZcEAk9x/FXd9sesP5lPVeAwhs5Ctsu0chFiH5fU238QdI+n8y9rGWo7k+JCCY+s6WvF4+ctQtX57vVjmjH4DXHxC1Q497i9OKDNAZfwZ3xucB2BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YHKTtzM6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YHKTtzM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65FAC4CEF7;
	Mon, 23 Mar 2026 15:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278297;
	bh=WgBE758EYTpk/L+J04ljxDzEis7UK2/CYEk+QdgnCe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YHKTtzM6p1kky2lmb9Xy78cJrgzMJDiL67VYbydWy/FzdpSK7o/IiJnZ/GEyLqO9M
	 UhVHMsP5DALQWRVZCAb9IKZThCJhak8AL3LDiVp0PGriiiqfR2AeaPhMAQ6q72hxeG
	 QJyGpb8otE7rNzyS4I7SSCZNoe/R0nCDpzjOUC0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehul Rao <mehulrao@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 262/567] ALSA: pcm: fix use-after-free on linked stream runtime in snd_pcm_drain()
Date: Mon, 23 Mar 2026 14:43:02 +0100
Message-ID: <20260323134540.311735501@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mehul Rao <mehulrao@gmail.com>

commit 9b1dbd69ba6f8f8c69bc7b77c2ce3b9c6ed05ba6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/pcm_native.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -2148,6 +2148,10 @@ static int snd_pcm_drain(struct snd_pcm_
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
@@ -2167,16 +2171,25 @@ static int snd_pcm_drain(struct snd_pcm_
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


