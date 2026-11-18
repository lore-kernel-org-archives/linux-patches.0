Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027067;
	b=TPL0ubi1dt8YdJ8+oNr4Ow6uFAU3Fg9YzQ3HmewQGUXRnI+x/M8rbsPMQlMKYoepsVi2
	 HPiVxYjGgG6ZsrzR01F+2E1oJCXebZsH/8ozz3C40qiQ1FV6bkrAPoPSZPt0yl7qEmILZ
	 ilNHrv0tBpP++GERdALu/SLmlMvkJh+TYDAHQdqF9SPlWFWjYUadaNlvtpBNgVjcrwzZi
	 +SV5kEtX/mVESIk6szUC4Nz+ZZBK/Zx/h45xfwVtN3TDzDdjW3z/Gb6l4WgsI1oUnNg6P
	 NV3ZsGsvJq1xBjUrjkd4aa96pwUWq4uS+ANxixKSrZibqgFXLnc/Q8Axb8O7REaTgpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027067;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kd85A7Wj7Qd0DW83cKYHppJvMooYOzqDW+yqpyBe688=;
	b=pixF2fV5LPbwfGzHZAawPBREO9Ul/YhqU0tAnd4KGKTsa96m7gRdpE8wvH2o/DUMtPPH
	 T06vPT2T0y5c3l4IJyrBo48MkGpJITrbH+e+0V/BYa05tTc2F6sG7UuttCwg+hxfllxVu
	 wdlIImhXmE5Lvwf6BtkuQdUJtb15XOWPziE2a4fDQoRBVCvq7vACxKJmpSpi+kVmv7I28
	 HCE42auQjmSsslSuMyClA1430WzzP5Drr9CBkcdFa+UqGAqRqKTZtOGDycG+tkFm4vHcE
	 XUIEv2vG3CsPBLTVtBr+KxZtIYY9PZWSMmYH5zVnEe2/ZAHXb326oeRfZdJnDkTsTGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D8Wd7VBH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1944606A32A;
	Wed, 18 Nov 2026 18:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D8Wd7VBH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F71D1F000C4;
	Wed, 18 Nov 2026 18:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027066;
	bh=kd85A7Wj7Qd0DW83cKYHppJvMooYOzqDW+yqpyBe688=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D8Wd7VBHMIQls47CvU8/hlgQLYItxcrTSPaBBhLTnmnjtK/WLBuXF6vodHEe2k1Rw
	 FMvT4VWAw51qISCJ5LBh+RMkpc3ZDwGtAmwMFvfDMk183RR+WeasWB1ZyTPMk4KOf9
	 S1UhOTrLtzNqWp6Mv1gT9JusPnaB7HYV+zN6VwJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yun Lu <luyun@kylinos.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1659/2151] bpf: Prevent task work context reuse while irq_work is busy
Date: Wed, 18 Nov 2026 15:56:34 +0100
Message-ID: <20261118150222.275981986@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 12f21abb0ea20..8476f9bab6bc3 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -4123,6 +4123,7 @@ static struct bpf_task_work_ctx *bpf_task_work_fetch_ctx(struct bpf_task_work *t
 	memset(ctx, 0, sizeof(*ctx));
 	refcount_set(&ctx->refcnt, 1); /* map's own ref */
 	ctx->state = BPF_TW_STANDBY;
+	init_irq_work(&ctx->irq_work, bpf_task_work_irq);
 
 	old_ctx = cmpxchg(&twk->ctx, NULL, ctx);
 	if (old_ctx) {
@@ -4165,6 +4166,18 @@ static struct bpf_task_work_ctx *bpf_task_work_acquire_ctx(struct bpf_task_work
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
@@ -4214,7 +4227,6 @@ static int bpf_task_work_schedule(struct task_struct *task, struct bpf_task_work
 	ctx->map = map;
 	ctx->map_val = (void *)tw - map->record->task_work_off;
 	init_task_work(&ctx->work, bpf_task_work_callback);
-	init_irq_work(&ctx->irq_work, bpf_task_work_irq);
 
 	irq_work_queue(&ctx->irq_work);
 	return 0;
-- 
2.53.0



