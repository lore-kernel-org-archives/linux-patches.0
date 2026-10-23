Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774811;
	b=AXxuv4ZVLdjmt3zq3TSPORb7dgskM+tIIpoocrnPbDGIiUW8gOkl+GEsvkYobwXK8wKB
	 ejPuN1E5/Ozts4smDhzZ31asb8qUoIRvSlOcZFeFFrmLIfY4S9YYmdXeCpEISeSItVkio
	 EVjh2wjaY8cINDXgCXN0AvniMMYrnEYy7WD6tR1TPF/jC+4pry/wiMCluLr4B3HqBx8Ly
	 8qlyG5Gw1BMZZqrfEm1TT0G8dQdYAe0cKrVgy3g3WnEccjvS3t2l+SXBz2vchyyHqlSf1
	 tKbAl2KyVurdUhLKAbDQ4ekyPJDNgG1isE/9s90frC38T0erKts57CklFur8Kz2gsug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jSMDH0V7LTaXIaOMJHvylQzsSfaDyuMt72bejhZjG8w=;
	b=WzrMyheagUBrFZYIBLvYfjbReIqpQ2Phrio0Uaetev868Ugd5pnjk5M9pZPDfStkjakM
	 SdTVnGAKv96MSGA3/un26LN8lCyVHGB34OZQh9sf8erMFzIzsWydyh6F8KYe1avP2madK
	 mp77L74H1Xk6J1xFob1SpEDRBbOnQ01FyGSkak0fcrdG18oXVYVSVtu9ndGVGfjBp3upD
	 hxcLYvfSMunQGRzDiy5z7//McEI2irdyIibI5rRKbDiM+5b5+QdfqHw4EyeBdaBhJvpr1
	 4Hia5/xG1MVURXtYgCmEiHwEtI+7Cbp6ffjapcv2cHFUXcYlYaCEVosfPTfevsRoC9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SiPJGtNZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA87F606A31F;
	Fri, 23 Oct 2026 17:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SiPJGtNZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04CA11F01825;
	Fri, 23 Oct 2026 17:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774810;
	bh=jSMDH0V7LTaXIaOMJHvylQzsSfaDyuMt72bejhZjG8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SiPJGtNZDLqRfasG5vGTdsY2Y+O+91GBFNGJ0HgWadvec314clN3JYhHFnuiBZjlR
	 fMUr/CYMlmguszCttGr8mUrOMdVARFjhCgmwLFrErNLcilVri48Sc/jZda8tEB/P/s
	 /MC7V4Y+6kah/YIg+2TPnK4txvdz8EzV9c9qWxH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Hui Su <sh_def@163.com>
Subject: [PATCH 7.2 165/242] sched_ext: Fix use-after-free of a destroyed user DSQ by a deferred reenqueue
Date: Fri, 23 Oct 2026 18:40:07 +0200
Message-ID: <20261023163717.686264679@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 069403dff337feb192bfc70fb28ddc8a171e20c1 upstream.

A deferred reenqueue can read a freed user DSQ. The request stays on its
CPU's deferred list until run_deferred() takes it, and the RCU callback that
frees the DSQ assumes that the grace period has flushed it, so exit_dsq()
checks the per-CPU node without the deferred list lock. A grace period waits
for readers in flight, not for a pending run_deferred(). A run_deferred()
which starts after the grace period began can detach the request right
before the callback looks and then read the freed DSQ's id.

Cancel the pending requests before the grace period instead. The irq work
that frees the DSQ unlinks every CPU's request under the per-CPU deferred
list lock, and schedule_dsq_reenq() ignores a new request under the same
lock once the id is invalid. Only a run_deferred() that started before the
grace period can hold a request, and it runs with IRQs disabled, so the
grace period waits for it and nothing touches the DSQ after the callback.

Fixes: 84b1a0ea0b7c ("sched_ext: Implement scx_bpf_dsq_reenq() for user DSQs")
Cc: stable@vger.kernel.org # v7.1+
Reported-and-tested-by: Hui Su <sh_def@163.com>
Link: https://lore.kernel.org/all/20261008024753.4096008-1-sh_def@163.com/
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext/ext.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -1274,6 +1274,10 @@ static void schedule_dsq_reenq(struct sc
 
 			guard(raw_spinlock_irqsave)(&rq->scx.deferred_reenq_lock);
 
+			/* @dsq is being destroyed, see free_dsq_irq_workfn() */
+			if (unlikely(READ_ONCE(dsq->id) == SCX_DSQ_INVALID))
+				return;
+
 			if (list_empty(&dru->node))
 				list_move_tail(&dru->node, &rq->scx.deferred_reenq_users);
 			WRITE_ONCE(dru->flags, dru->flags | reenq_flags);
@@ -4899,8 +4903,8 @@ static void exit_dsq(struct scx_dispatch
 		struct rq *rq = cpu_rq(cpu);
 
 		/*
-		 * There must have been a RCU grace period since the last
-		 * insertion and @dsq should be off the deferred list by now.
+		 * free_dsq_irq_workfn() cancelled the reenqs before the grace
+		 * period and schedule_dsq_reenq() queues nothing after that.
 		 */
 		if (WARN_ON_ONCE(!list_empty(&dru->node))) {
 			guard(raw_spinlock_irqsave)(&rq->scx.deferred_reenq_lock);
@@ -4924,8 +4928,26 @@ static void free_dsq_irq_workfn(struct i
 	struct llist_node *to_free = llist_del_all(&dsqs_to_free);
 	struct scx_dispatch_q *dsq, *tmp_dsq;
 
-	llist_for_each_entry_safe(dsq, tmp_dsq, to_free, free_node)
+	llist_for_each_entry_safe(dsq, tmp_dsq, to_free, free_node) {
+		s32 cpu;
+
+		/*
+		 * Cancel pending reenqs. Only a run_deferred() that started
+		 * before the grace period can hold one, and it keeps IRQs off,
+		 * so the grace period waits for it. After this sweep,
+		 * schedule_dsq_reenq() sees the invalid id under the same lock
+		 * and queues nothing.
+		 */
+		for_each_possible_cpu(cpu) {
+			struct scx_dsq_pcpu *pcpu = per_cpu_ptr(dsq->pcpu, cpu);
+			struct rq *rq = cpu_rq(cpu);
+
+			guard(raw_spinlock_irqsave)(&rq->scx.deferred_reenq_lock);
+			list_del_init(&pcpu->deferred_reenq_user.node);
+		}
+
 		call_rcu(&dsq->rcu, free_dsq_rcufn);
+	}
 }
 
 static DEFINE_IRQ_WORK(free_dsq_irq_work, free_dsq_irq_workfn);


