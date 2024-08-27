Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD291C57BD;
	Tue, 27 Aug 2024 14:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769979; cv=none; b=WYlZh+jpi2wdTtnA7jKVL+F8h0MidqowKmCL8IbWhvT0p5nJMciCCj3RFMwL9gA3NvteB1Lq6/jzeclbuC8TthyfZ9A9/D7vhdg3S+iGM9VZq5gs9X3KztravMA5TmoqXpVbiK4RVIi6xlkv57ef6fcq7wn5T4GiLUc85MrVahU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769979; c=relaxed/simple;
	bh=D2zNgj9LymxCHkZ8DpXhBfooev9xhtvRhJCFMaw4OEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmT2itTFGB703bt42dGlCUyBhwUl/fYW7QDKisHE3Jsi06I+0moIxc3YDfnDLbA41Sywowor/qpTfFxtVk3N03QF1uCVmL3EDe/T2s9LtM3d6rYaRpwZjgvCBV9jo5GHlUI7anY2bZObmmwenLUdu7K8zsbkxrKh6vzdntXbaZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CuzJ9zLh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CuzJ9zLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018A6C61077;
	Tue, 27 Aug 2024 14:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769979;
	bh=D2zNgj9LymxCHkZ8DpXhBfooev9xhtvRhJCFMaw4OEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CuzJ9zLhr4NC2vmf+X5iS4DIzfMj9G0whhqCEy2gTVc1g4VpEZnMelRuEco42dWBY
	 1TG54HiUbFr1axQuwUFbW1UEpXLnPZE98Ef9oxPqqZtjUk0Zae3PnuhPIhmDTdPZST
	 +pQlFSUeqLLfubgmG36pr6mSi3NVnUr5B89xtNL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/341] rcu: Dump memory object info if callback function is invalid
Date: Tue, 27 Aug 2024 16:35:23 +0200
Message-ID: <20240827143846.907543843@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 2cbc482d325ee58001472c4359b311958c4efdd1 ]

When a structure containing an RCU callback rhp is (incorrectly) freed
and reallocated after rhp is passed to call_rcu(), it is not unusual for
rhp->func to be set to NULL. This defeats the debugging prints used by
__call_rcu_common() in kernels built with CONFIG_DEBUG_OBJECTS_RCU_HEAD=y,
which expect to identify the offending code using the identity of this
function.

And in kernels build without CONFIG_DEBUG_OBJECTS_RCU_HEAD=y, things
are even worse, as can be seen from this splat:

Unable to handle kernel NULL pointer dereference at virtual address 0
... ...
PC is at 0x0
LR is at rcu_do_batch+0x1c0/0x3b8
... ...
 (rcu_do_batch) from (rcu_core+0x1d4/0x284)
 (rcu_core) from (__do_softirq+0x24c/0x344)
 (__do_softirq) from (__irq_exit_rcu+0x64/0x108)
 (__irq_exit_rcu) from (irq_exit+0x8/0x10)
 (irq_exit) from (__handle_domain_irq+0x74/0x9c)
 (__handle_domain_irq) from (gic_handle_irq+0x8c/0x98)
 (gic_handle_irq) from (__irq_svc+0x5c/0x94)
 (__irq_svc) from (arch_cpu_idle+0x20/0x3c)
 (arch_cpu_idle) from (default_idle_call+0x4c/0x78)
 (default_idle_call) from (do_idle+0xf8/0x150)
 (do_idle) from (cpu_startup_entry+0x18/0x20)
 (cpu_startup_entry) from (0xc01530)

This commit therefore adds calls to mem_dump_obj(rhp) to output some
information, for example:

  slab kmalloc-256 start ffff410c45019900 pointer offset 0 size 256

This provides the rough size of the memory block and the offset of the
rcu_head structure, which as least provides at least a few clues to help
locate the problem. If the problem is reproducible, additional slab
debugging can be enabled, for example, CONFIG_DEBUG_SLAB=y, which can
provide significantly more information.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcu.h      | 7 +++++++
 kernel/rcu/srcutiny.c | 1 +
 kernel/rcu/srcutree.c | 1 +
 kernel/rcu/tasks.h    | 1 +
 kernel/rcu/tiny.c     | 1 +
 kernel/rcu/tree.c     | 1 +
 6 files changed, 12 insertions(+)

diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
index 3d1851f82dbb6..de0afabfbd440 100644
--- a/kernel/rcu/rcu.h
+++ b/kernel/rcu/rcu.h
@@ -10,6 +10,7 @@
 #ifndef __LINUX_RCU_H
 #define __LINUX_RCU_H
 
+#include <linux/slab.h>
 #include <trace/events/rcu.h>
 
 /*
@@ -248,6 +249,12 @@ static inline void debug_rcu_head_unqueue(struct rcu_head *head)
 }
 #endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 
+static inline void debug_rcu_head_callback(struct rcu_head *rhp)
+{
+	if (unlikely(!rhp->func))
+		kmem_dump_obj(rhp);
+}
+
 extern int rcu_cpu_stall_suppress_at_boot;
 
 static inline bool rcu_stall_is_suppressed_at_boot(void)
diff --git a/kernel/rcu/srcutiny.c b/kernel/rcu/srcutiny.c
index 336af24e0fe35..c38e5933a5d69 100644
--- a/kernel/rcu/srcutiny.c
+++ b/kernel/rcu/srcutiny.c
@@ -138,6 +138,7 @@ void srcu_drive_gp(struct work_struct *wp)
 	while (lh) {
 		rhp = lh;
 		lh = lh->next;
+		debug_rcu_head_callback(rhp);
 		local_bh_disable();
 		rhp->func(rhp);
 		local_bh_enable();
diff --git a/kernel/rcu/srcutree.c b/kernel/rcu/srcutree.c
index 25285893e44e7..2f770a9a2a13a 100644
--- a/kernel/rcu/srcutree.c
+++ b/kernel/rcu/srcutree.c
@@ -1735,6 +1735,7 @@ static void srcu_invoke_callbacks(struct work_struct *work)
 	rhp = rcu_cblist_dequeue(&ready_cbs);
 	for (; rhp != NULL; rhp = rcu_cblist_dequeue(&ready_cbs)) {
 		debug_rcu_head_unqueue(rhp);
+		debug_rcu_head_callback(rhp);
 		local_bh_disable();
 		rhp->func(rhp);
 		local_bh_enable();
diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index ff8d539ee22be..df81506cf2bde 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -538,6 +538,7 @@ static void rcu_tasks_invoke_cbs(struct rcu_tasks *rtp, struct rcu_tasks_percpu
 	raw_spin_unlock_irqrestore_rcu_node(rtpcp, flags);
 	len = rcl.len;
 	for (rhp = rcu_cblist_dequeue(&rcl); rhp; rhp = rcu_cblist_dequeue(&rcl)) {
+		debug_rcu_head_callback(rhp);
 		local_bh_disable();
 		rhp->func(rhp);
 		local_bh_enable();
diff --git a/kernel/rcu/tiny.c b/kernel/rcu/tiny.c
index 42f7589e51e09..fec804b790803 100644
--- a/kernel/rcu/tiny.c
+++ b/kernel/rcu/tiny.c
@@ -97,6 +97,7 @@ static inline bool rcu_reclaim_tiny(struct rcu_head *head)
 
 	trace_rcu_invoke_callback("", head);
 	f = head->func;
+	debug_rcu_head_callback(head);
 	WRITE_ONCE(head->func, (rcu_callback_t)0L);
 	f(head);
 	rcu_lock_release(&rcu_callback_map);
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 583cc29080764..c7cb465e2e0c7 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2185,6 +2185,7 @@ static void rcu_do_batch(struct rcu_data *rdp)
 		trace_rcu_invoke_callback(rcu_state.name, rhp);
 
 		f = rhp->func;
+		debug_rcu_head_callback(rhp);
 		WRITE_ONCE(rhp->func, (rcu_callback_t)0L);
 		f(rhp);
 
-- 
2.43.0



