Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020622;
	b=Is71iFgSg+ftVEXgIzHNC9HLrYKyWQyw31wkChFp2WOKMYrR9qL+mWVa2gZm7rDM953v
	 XPav8/B5I8Z0vPyfh/m12UuLPktbewe11OdE4M3wbpP5Z0jF6ORUq0Yc1Up4sms8kyJm5
	 BxvnZLlfTuAYG4ZNJqEfIPPbWGFsu1ozBjoLx9sXYHJzOiPGpReiHGoxg1P2yNJnGpu+/
	 3YwMpjN43u07IxkBttqljjK5LGe2cduZ60rNyoQ0ZYmPJKT0sIqvhZ07Xng1nrHJHcjgX
	 Pwa166Nc99ieFM+PpoO41tUkuCiMF26U2zmRHezZYGyL8LKv9PO3dUYbl9QQfeU/YRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020622;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w/ukkHVN+45iEQMUQ429/z02qCbKSYL5Zg0W2yWF8H4=;
	b=LpDPlFX1zRBv6GeH4KSZQSSE53J2t1D3bg0CO5R2WuLKFnEKbtCz+0/ITKPcLdyxA2vD
	 hXrcuPPhLrVNNocIY7ZCDgYBkoh3JwQqymvk83jaVWwtu7H538uR7NNUVp2GrNHrQ9oi+
	 oXiPj2hW8qJNw48TOvS+s3fq5X7WPwglV8h9WTtQjXfVrElG8ufdldd2ya6HSqHT98ajG
	 l9EtBquXS0l66Q6bbZRFsgYTK2PgT2ntvE+2Wwm7Qp63oW8yAeXbOSaNUGxUsMblHWj9D
	 65ks6lq5lIb2UgQzAzMPU8qX7YUCINRUT+F9sVAOrU5QCgOVD+B4UMy8D/3RxjpdT/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vo3D2Ju+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1DF606A32C;
	Wed, 18 Nov 2026 16:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vo3D2Ju+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272AE1F000C6;
	Wed, 18 Nov 2026 16:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020622;
	bh=w/ukkHVN+45iEQMUQ429/z02qCbKSYL5Zg0W2yWF8H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vo3D2Ju+f1KcI5JRap2dlSO0uD+GOednR0ylN75DqNBRrem3slxPVXTNmaLlbE0x/
	 uKE6xjhRGJlTfKO3BA4QoK6zuSBDZygkipnnPRwHYWGRbxxnaOxSIULtBoZ9Mbz2YY
	 TlDUD17mY+Ujb8DoP2L0YfcdP64CRANgWlS56+SM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yun Lu <luyun@kylinos.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2018/2651] bpf: Prevent task work context reuse while irq_work is busy
Date: Wed, 18 Nov 2026 15:54:18 +0100
Message-ID: <20261118150358.877678816@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yun Lu <luyun@kylinos.cn>

[ Upstream commit a36d9afe8d923ca00dd2001409f420202ee672da ]

A bpf_task_work context can return to STANDBY before its scheduling
irq_work handler returns.  Both callback completion and task_work_add()
failure can publish STANDBY while the irq_work is still BUSY.  A new
round can then reinitialize and queue the same irq_work on another CPU
while the old handler is still running.

One concrete interleaving is:

  1. CPU 0 successfully queues ctx->work with task_work_add() and pauses
     before its SCHEDULING-to-SCHEDULED cmpxchg.

  2. The target task on CPU 1 completes the callback, resets ctx->task
     and publishes STANDBY.

  3. CPU 2 starts a new round, changes STANDBY to PENDING and queues the
     same irq_work.  The new handler changes PENDING to SCHEDULING, but
     task_work_add() returns -ESRCH because its target task has exited.
     The handler has not yet reset the context or rolled back the state.

  4. CPU 0 resumes and changes the new round's SCHEDULING to SCHEDULED,
     even though no task work was queued for that round.

  5. The new handler resets ctx->task, but its SCHEDULING-to-STANDBY
     cmpxchg fails.  The context remains SCHEDULED with a NULL task, and
     subsequent attempts to acquire this context fail with -EBUSY.

  6. Map-value deletion observes SCHEDULED and queues asynchronous
     cancellation, which passes the NULL ctx->task to task_work_cancel().

Overlapping invocations also share one BUSY bit.  An invocation can clear
that bit while the other invocation is still running.

Initialize the scheduling irq_work when the context is created and stop
reinitializing it for each round.  After claiming the context with the
STANDBY-to-PENDING cmpxchg, check BUSY and reject reuse with -EBUSY if a
previous invocation is still in progress.  Checking after the cmpxchg
orders the BUSY read after the STANDBY publication.

No irq_work has been queued for the attempted round at this point, so
the rejection can roll PENDING back to STANDBY.  Use cmpxchg for that
rollback to preserve FREED if a concurrent deletion has published it.
Once BUSY clears, scheduling can be retried.

Fixes: 38aa7003e369 ("bpf: task work scheduling kfuncs")
Signed-off-by: Yun Lu <luyun@kylinos.cn>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Mykyta Yatsenko <yatsenko@meta.com>
Link: https://patch.msgid.link/20261012061915.231254-4-luyun_611@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index bd823e17ae696..2a5af794968b1 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -4553,6 +4553,7 @@ static struct bpf_task_work_ctx *bpf_task_work_fetch_ctx(struct bpf_task_work *t
 	memset(ctx, 0, sizeof(*ctx));
 	refcount_set(&ctx->refcnt, 1); /* map's own ref */
 	ctx->state = BPF_TW_STANDBY;
+	init_irq_work(&ctx->irq_work, bpf_task_work_irq);
 
 	old_ctx = cmpxchg(&twk->ctx, NULL, ctx);
 	if (old_ctx) {
@@ -4595,6 +4596,18 @@ static struct bpf_task_work_ctx *bpf_task_work_acquire_ctx(struct bpf_task_work
 		bpf_task_work_ctx_put(ctx);
 		return ERR_PTR(-EBUSY);
 	}
+	/*
+	 * STANDBY can be published before the previous scheduling irq_work
+	 * returns. Claim PENDING before checking BUSY to order the check after
+	 * that publication. No irq_work has been queued for this attempt yet,
+	 * so reject reuse and roll back to STANDBY while BUSY is set. Preserve
+	 * FREED if deletion wins the rollback race.
+	 */
+	if (unlikely(irq_work_is_busy(&ctx->irq_work))) {
+		(void)cmpxchg(&ctx->state, BPF_TW_PENDING, BPF_TW_STANDBY);
+		bpf_task_work_ctx_put(ctx);
+		return ERR_PTR(-EBUSY);
+	}
 
 	/*
 	 * If no process or bpffs is holding a reference to the map, no new callbacks should be
@@ -4644,7 +4657,6 @@ static int bpf_task_work_schedule(struct task_struct *task, struct bpf_task_work
 	ctx->map = map;
 	ctx->map_val = (void *)tw - map->record->task_work_off;
 	init_task_work(&ctx->work, bpf_task_work_callback);
-	init_irq_work(&ctx->irq_work, bpf_task_work_irq);
 
 	irq_work_queue(&ctx->irq_work);
 	return 0;
-- 
2.53.0



