Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFBB8837;
	Mon, 28 Oct 2024 06:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097945; cv=none; b=VoeSR3RjZL6/aCBbuHsMm/duT46GkxKq/X/lIrL2ARaGqBofXBAq28K+MDKHppstQCLOLHRMWURt4Dj/ZTaMqfXtatE+ztdVd68VrgsSirA6lekGoX75v8BFklaXdAw12pNTDuPlm4KmpAm34NqNuV5+oUQ6DS8IB6rXmFTCmc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097945; c=relaxed/simple;
	bh=y0kvvuSeXEF0Ssw+Hc8LfeNaM63BSCovxk2tKnA+L5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SdCv7e2+FavWeqxsYRr4Zvg48Kesm3M6QcM3eT1Y6aYeXplQZfNl7amXK2sOusfvZ+1Q8dMIkcg+TNsn95Ydf+Nz79o+/RAQN9YEr5b70ngjmCU3R7zWx8b9Lgr1Ufpn523hutqOerkwofRCtmRXRf5qhZHyHnWe7cRs6rJtzTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fbh28xS7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fbh28xS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2448C4CEC3;
	Mon, 28 Oct 2024 06:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097945;
	bh=y0kvvuSeXEF0Ssw+Hc8LfeNaM63BSCovxk2tKnA+L5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fbh28xS71lm+VB5tLP8RkGbyPwV/chIdzfJpry5ocFNVaQPdbaCBScHJVhS2w0uhw
	 ioiipNV/ZFmpyS5aqVUTQr0mCDb14FxqGx3iAiVVR0+rEl+0SmweUQhpB4uTkszTPj
	 O5+f+JETID9l/O/xdKK/adXzDfl7j6mmlymq5tfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Grech <bgrech@redhat.com>,
	Wander Lairson Costa <wander.lairson@gmail.com>,
	Wander Lairson Costa <wander@redhat.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 001/261] bpf: Use raw_spinlock_t in ringbuf
Date: Mon, 28 Oct 2024 07:22:23 +0100
Message-ID: <20241028062312.045413781@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index e20b90c361316..de3b681d1d13d 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -29,7 +29,7 @@ struct bpf_ringbuf {
 	u64 mask;
 	struct page **pages;
 	int nr_pages;
-	spinlock_t spinlock ____cacheline_aligned_in_smp;
+	raw_spinlock_t spinlock ____cacheline_aligned_in_smp;
 	/* For user-space producer ring buffers, an atomic_t busy bit is used
 	 * to synchronize access to the ring buffers in the kernel, rather than
 	 * the spinlock that is used for kernel-producer ring buffers. This is
@@ -173,7 +173,7 @@ static struct bpf_ringbuf *bpf_ringbuf_alloc(size_t data_sz, int numa_node)
 	if (!rb)
 		return NULL;
 
-	spin_lock_init(&rb->spinlock);
+	raw_spin_lock_init(&rb->spinlock);
 	atomic_set(&rb->busy, 0);
 	init_waitqueue_head(&rb->waitq);
 	init_irq_work(&rb->work, bpf_ringbuf_notify);
@@ -421,10 +421,10 @@ static void *__bpf_ringbuf_reserve(struct bpf_ringbuf *rb, u64 size)
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
@@ -450,7 +450,7 @@ static void *__bpf_ringbuf_reserve(struct bpf_ringbuf *rb, u64 size)
 	 */
 	if (new_prod_pos - cons_pos > rb->mask ||
 	    new_prod_pos - pend_pos > rb->mask) {
-		spin_unlock_irqrestore(&rb->spinlock, flags);
+		raw_spin_unlock_irqrestore(&rb->spinlock, flags);
 		return NULL;
 	}
 
@@ -462,7 +462,7 @@ static void *__bpf_ringbuf_reserve(struct bpf_ringbuf *rb, u64 size)
 	/* pairs with consumer's smp_load_acquire() */
 	smp_store_release(&rb->producer_pos, new_prod_pos);
 
-	spin_unlock_irqrestore(&rb->spinlock, flags);
+	raw_spin_unlock_irqrestore(&rb->spinlock, flags);
 
 	return (void *)hdr + BPF_RINGBUF_HDR_SZ;
 }
-- 
2.43.0



