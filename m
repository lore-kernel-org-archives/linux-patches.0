Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A712718E348;
	Mon, 28 Oct 2024 06:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097158; cv=none; b=ICt8RxFS2wNL9dumG10b7gSphZcIK3sqZU3Sbg4NxDfe54D+fptbmFM/kzuEl1mmv/0smO9pbXeFN2uy7cC3MDYBW5gZTOmD7ZZG1No7r0v2dnqHNMmTWGJc2rMMxX6ju2fwasgGErqFwo18HEUX1tz9gfuUjMjjclsXuJ6Fs70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097158; c=relaxed/simple;
	bh=wZPbY6l/qN0wPYQVyWE0yKb0MBYwFUusnr164yO7cOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/pHscMii6Y+elhsqfc/L3tLKEYEOUWJckJVuyi4ZYnFxcLQuO4PKb6kY/Xp3iEieScCettjtOI6S6VV4aPvvRDKhN35/sTCEVn8GKc2DXKgU5HcqCGSqN8giBxe0RUaGFZ2tnE8OsqL0OYxQ5/r50OmcHqMOIBc/LI1heQ9j7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j8BnKdbl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j8BnKdbl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454C3C4CEE3;
	Mon, 28 Oct 2024 06:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097158;
	bh=wZPbY6l/qN0wPYQVyWE0yKb0MBYwFUusnr164yO7cOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j8BnKdblgHxX3e3ClsmTnt3Ashg3M+duAfi4QtEu9iiLaPa5P68L347XdwdvhYquw
	 lfkhKNoWwDH7OjBBo83mhpnoieYPJFunTrOZrknAYA7foRTUjvN3oh9Aq3SzR6bvH2
	 0pewL6zzoi/PEpQJOcrWTyKSqQ3FajEPvJVBvGpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Grech <bgrech@redhat.com>,
	Wander Lairson Costa <wander.lairson@gmail.com>,
	Wander Lairson Costa <wander@redhat.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 001/137] bpf: Use raw_spinlock_t in ringbuf
Date: Mon, 28 Oct 2024 07:23:58 +0100
Message-ID: <20241028062258.750025400@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Wander Lairson Costa <wander.lairson@gmail.com>

[ Upstream commit 8b62645b09f870d70c7910e7550289d444239a46 ]

The function __bpf_ringbuf_reserve is invoked from a tracepoint, which
disables preemption. Using spinlock_t in this context can lead to a
"sleep in atomic" warning in the RT variant. This issue is illustrated
in the example below:

BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 556208, name: test_progs
preempt_count: 1, expected: 0
RCU nest depth: 1, expected: 1
INFO: lockdep is turned off.
Preemption disabled at:
[<ffffd33a5c88ea44>] migrate_enable+0xc0/0x39c
CPU: 7 PID: 556208 Comm: test_progs Tainted: G
Hardware name: Qualcomm SA8775P Ride (DT)
Call trace:
 dump_backtrace+0xac/0x130
 show_stack+0x1c/0x30
 dump_stack_lvl+0xac/0xe8
 dump_stack+0x18/0x30
 __might_resched+0x3bc/0x4fc
 rt_spin_lock+0x8c/0x1a4
 __bpf_ringbuf_reserve+0xc4/0x254
 bpf_ringbuf_reserve_dynptr+0x5c/0xdc
 bpf_prog_ac3d15160d62622a_test_read_write+0x104/0x238
 trace_call_bpf+0x238/0x774
 perf_call_bpf_enter.isra.0+0x104/0x194
 perf_syscall_enter+0x2f8/0x510
 trace_sys_enter+0x39c/0x564
 syscall_trace_enter+0x220/0x3c0
 do_el0_svc+0x138/0x1dc
 el0_svc+0x54/0x130
 el0t_64_sync_handler+0x134/0x150
 el0t_64_sync+0x17c/0x180

Switch the spinlock to raw_spinlock_t to avoid this error.

Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier support for it")
Reported-by: Brian Grech <bgrech@redhat.com>
Signed-off-by: Wander Lairson Costa <wander.lairson@gmail.com>
Signed-off-by: Wander Lairson Costa <wander@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20240920190700.617253-1-wander@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/ringbuf.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index a1911391a864c..af75c54eb84fb 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -37,7 +37,7 @@ struct bpf_ringbuf {
 	u64 mask;
 	struct page **pages;
 	int nr_pages;
-	spinlock_t spinlock ____cacheline_aligned_in_smp;
+	raw_spinlock_t spinlock ____cacheline_aligned_in_smp;
 	/* For user-space producer ring buffers, an atomic_t busy bit is used
 	 * to synchronize access to the ring buffers in the kernel, rather than
 	 * the spinlock that is used for kernel-producer ring buffers. This is
@@ -170,7 +170,7 @@ static struct bpf_ringbuf *bpf_ringbuf_alloc(size_t data_sz, int numa_node)
 	if (!rb)
 		return NULL;
 
-	spin_lock_init(&rb->spinlock);
+	raw_spin_lock_init(&rb->spinlock);
 	atomic_set(&rb->busy, 0);
 	init_waitqueue_head(&rb->waitq);
 	init_irq_work(&rb->work, bpf_ringbuf_notify);
@@ -407,10 +407,10 @@ static void *__bpf_ringbuf_reserve(struct bpf_ringbuf *rb, u64 size)
 	cons_pos = smp_load_acquire(&rb->consumer_pos);
 
 	if (in_nmi()) {
-		if (!spin_trylock_irqsave(&rb->spinlock, flags))
+		if (!raw_spin_trylock_irqsave(&rb->spinlock, flags))
 			return NULL;
 	} else {
-		spin_lock_irqsave(&rb->spinlock, flags);
+		raw_spin_lock_irqsave(&rb->spinlock, flags);
 	}
 
 	pend_pos = rb->pending_pos;
@@ -436,7 +436,7 @@ static void *__bpf_ringbuf_reserve(struct bpf_ringbuf *rb, u64 size)
 	 */
 	if (new_prod_pos - cons_pos > rb->mask ||
 	    new_prod_pos - pend_pos > rb->mask) {
-		spin_unlock_irqrestore(&rb->spinlock, flags);
+		raw_spin_unlock_irqrestore(&rb->spinlock, flags);
 		return NULL;
 	}
 
@@ -448,7 +448,7 @@ static void *__bpf_ringbuf_reserve(struct bpf_ringbuf *rb, u64 size)
 	/* pairs with consumer's smp_load_acquire() */
 	smp_store_release(&rb->producer_pos, new_prod_pos);
 
-	spin_unlock_irqrestore(&rb->spinlock, flags);
+	raw_spin_unlock_irqrestore(&rb->spinlock, flags);
 
 	return (void *)hdr + BPF_RINGBUF_HDR_SZ;
 }
-- 
2.43.0



