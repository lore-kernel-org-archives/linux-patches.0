Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96971A6808;
	Mon, 23 Mar 2026 14:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275415; cv=none; b=MLMC30bXLy5MVRq9sIWR4HNWRs16+0FG7u8oNAhP4RZBsJdX9lLccm3D35fmeR5zbY1I2Tr+/t2k0E2dWvyW9luD6BQL0YafpNRdyD2Amu3JdlaHe1thVKukQa/xn7oNf5sXAAJFihFOMuL2r6SMMqfyrdO4lUFvVomNl6izuLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275415; c=relaxed/simple;
	bh=a1XwNuptPJfvTol7yBPLNsAExnd/etJYt6U4hDv+Fxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ejeMHJdLvRHcGj2nSjw43w5Emihre7p6TrGFkATrumi/bXmFnhE3J7/QcWvzxexMQ3m+iVlScL/fQxCLG4BCAnoVhNzGWj7lC43FTKgMp8H3ydacNMnXRyx3/mS7JsprO/G4HOn5kOMZTSpnSmJAGAEnUBtgyNjB5dK+ZErZXW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cAGt2T3M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cAGt2T3M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4937FC4CEF7;
	Mon, 23 Mar 2026 14:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275414;
	bh=a1XwNuptPJfvTol7yBPLNsAExnd/etJYt6U4hDv+Fxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cAGt2T3MOrUdgDLuqhNoApwdMKdV+htNo6EIsJTK7dErUtQFiOlNhC4QSDD9olNO+
	 Yo80HN/7HUXaMGu3ryRpFqxPUvvyoHa41M8iakOWU6Od5h+qPfzgOotIBU4iGMIdUz
	 Qhtlbyffkb7UxL8SqMI8r3xCgkwR/Fws3uKs/kNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehul Rao <mehulrao@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 090/460] ALSA: pcm: fix use-after-free on linked stream runtime in snd_pcm_drain()
Date: Mon, 23 Mar 2026 14:41:26 +0100
Message-ID: <20260323134528.880376602@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2144,6 +2144,10 @@ static int snd_pcm_drain(struct snd_pcm_
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
@@ -2163,16 +2167,25 @@ static int snd_pcm_drain(struct snd_pcm_
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


