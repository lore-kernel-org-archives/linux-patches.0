Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF293876D7;
	Tue, 10 Mar 2026 11:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141944; cv=none; b=jKKs+H7yAj4+WFRiYUew77ZIbXwV0W8JMI6mtftWXxEEwsa3Ca1IAme3Y8MXlIO2KpxGUSs6w2vtXE7g3y5aAOM4lbgDO58Y1p7KZyz85OqJXxInumFL7Q4AOl9fgT51Z15K+HvFCtbYcozVhHHGaK7JPqzFXK/oeGpTJ5D1D/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141944; c=relaxed/simple;
	bh=DuRU24/3gYBwVF8RFptVoluofBFVcuaE+PCabeowO5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dLEJ0BjMWzVq0WJl/iEXNCOVtwVJtSfdDB5FeiT+HN1cfEDBnK4YNdlwDr5jw8GjDckjA9jC9SBEPPv48DvipjsLLqlIv5/T9FUKpHtNSOFhAU8YtUxvbqQrvnSc6iwq3Ay/nenDd30sxOhVBGWlqgpPLDKG1xzvuwbiqgYdclg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WwqedNHN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WwqedNHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC81C19423;
	Tue, 10 Mar 2026 11:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141944;
	bh=DuRU24/3gYBwVF8RFptVoluofBFVcuaE+PCabeowO5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WwqedNHN+We6i/gjlTS2qM5UAD9sCukPKE+uVTjyNayWkHxmrDQgzlS3grbpGDORN
	 CCxgx5VC1gmVMcuhXaipDcoONIzB6paomQfF9Zh2ROt2TidNEseh9CGakosXmf2mOc
	 FCRnxLUt6VjemKMcg3Yph4NOW8rAFMzFicHIgR+i3lDM+4j2zyqL5m5HSqsHpj/xgu
	 clRH+no6eEs3h7gaaiETWNLawlS0GQN6pYXhNvc6NPDHoORE6EU/pz9bB/+uZgUJco
	 0r6CEXHC+x8VFmVsXTChQbefYb3mOaPIJQle2Ymq590B1gymFHRWqIM5fDvlaBcq8V
	 PCIYcMicDZHWQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
	syzbot+2b3391f44313b3983e91@syzkaller.appspotmail.com,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 068/314] bpf: Fix race in cpumap on PREEMPT_RT
Date: Tue, 10 Mar 2026 07:15:27 -0400
Message-ID: <036d5398a416001222e3695f54ef0cb18a55e18c.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jiayuan Chen <jiayuan.chen@shopee.com>

[ Upstream commit 869c63d5975d55e97f6b168e885452b3da20ea47 ]

On PREEMPT_RT kernels, the per-CPU xdp_bulk_queue (bq) can be accessed
concurrently by multiple preemptible tasks on the same CPU.

The original code assumes bq_enqueue() and __cpu_map_flush() run
atomically with respect to each other on the same CPU, relying on
local_bh_disable() to prevent preemption. However, on PREEMPT_RT,
local_bh_disable() only calls migrate_disable() (when
PREEMPT_RT_NEEDS_BH_LOCK is not set) and does not disable
preemption, which allows CFS scheduling to preempt a task during
bq_flush_to_queue(), enabling another task on the same CPU to enter
bq_enqueue() and operate on the same per-CPU bq concurrently.

This leads to several races:

1. Double __list_del_clearprev(): after bq->count is reset in
   bq_flush_to_queue(), a preempting task can call bq_enqueue() ->
   bq_flush_to_queue() on the same bq when bq->count reaches
   CPU_MAP_BULK_SIZE. Both tasks then call __list_del_clearprev()
   on the same bq->flush_node, the second call dereferences the
   prev pointer that was already set to NULL by the first.

2. bq->count and bq->q[] races: concurrent bq_enqueue() can corrupt
   the packet queue while bq_flush_to_queue() is processing it.

The race between task A (__cpu_map_flush -> bq_flush_to_queue) and
task B (bq_enqueue -> bq_flush_to_queue) on the same CPU:

  Task A (xdp_do_flush)          Task B (cpu_map_enqueue)
  ----------------------         ------------------------
  bq_flush_to_queue(bq)
    spin_lock(&q->producer_lock)
    /* flush bq->q[] to ptr_ring */
    bq->count = 0
    spin_unlock(&q->producer_lock)
                                   bq_enqueue(rcpu, xdpf)
    <-- CFS preempts Task A -->      bq->q[bq->count++] = xdpf
                                     /* ... more enqueues until full ... */
                                     bq_flush_to_queue(bq)
                                       spin_lock(&q->producer_lock)
                                       /* flush to ptr_ring */
                                       spin_unlock(&q->producer_lock)
                                       __list_del_clearprev(flush_node)
                                         /* sets flush_node.prev = NULL */
    <-- Task A resumes -->
    __list_del_clearprev(flush_node)
      flush_node.prev->next = ...
      /* prev is NULL -> kernel oops */

Fix this by adding a local_lock_t to xdp_bulk_queue and acquiring it
in bq_enqueue() and __cpu_map_flush(). These paths already run under
local_bh_disable(), so use local_lock_nested_bh() which on non-RT is
a pure annotation with no overhead, and on PREEMPT_RT provides a
per-CPU sleeping lock that serializes access to the bq.

To reproduce, insert an mdelay(100) between bq->count = 0 and
__list_del_clearprev() in bq_flush_to_queue(), then run reproducer
provided by syzkaller.

Fixes: 3253cb49cbad ("softirq: Allow to drop the softirq-BKL lock on PREEMPT_RT")
Reported-by: syzbot+2b3391f44313b3983e91@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69369331.a70a0220.38f243.009d.GAE@google.com/T/
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://lore.kernel.org/r/20260225121459.183121-2-jiayuan.chen@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cpumap.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 703e5df1f4ef9..306bf98378041 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -29,6 +29,7 @@
 #include <linux/sched.h>
 #include <linux/workqueue.h>
 #include <linux/kthread.h>
+#include <linux/local_lock.h>
 #include <linux/completion.h>
 #include <trace/events/xdp.h>
 #include <linux/btf_ids.h>
@@ -52,6 +53,7 @@ struct xdp_bulk_queue {
 	struct list_head flush_node;
 	struct bpf_cpu_map_entry *obj;
 	unsigned int count;
+	local_lock_t bq_lock;
 };
 
 /* Struct for every remote "destination" CPU in map */
@@ -451,6 +453,7 @@ __cpu_map_entry_alloc(struct bpf_map *map, struct bpf_cpumap_val *value,
 	for_each_possible_cpu(i) {
 		bq = per_cpu_ptr(rcpu->bulkq, i);
 		bq->obj = rcpu;
+		local_lock_init(&bq->bq_lock);
 	}
 
 	/* Alloc queue */
@@ -717,6 +720,8 @@ static void bq_flush_to_queue(struct xdp_bulk_queue *bq)
 	struct ptr_ring *q;
 	int i;
 
+	lockdep_assert_held(&bq->bq_lock);
+
 	if (unlikely(!bq->count))
 		return;
 
@@ -744,11 +749,15 @@ static void bq_flush_to_queue(struct xdp_bulk_queue *bq)
 }
 
 /* Runs under RCU-read-side, plus in softirq under NAPI protection.
- * Thus, safe percpu variable access.
+ * Thus, safe percpu variable access. PREEMPT_RT relies on
+ * local_lock_nested_bh() to serialise access to the per-CPU bq.
  */
 static void bq_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_frame *xdpf)
 {
-	struct xdp_bulk_queue *bq = this_cpu_ptr(rcpu->bulkq);
+	struct xdp_bulk_queue *bq;
+
+	local_lock_nested_bh(&rcpu->bulkq->bq_lock);
+	bq = this_cpu_ptr(rcpu->bulkq);
 
 	if (unlikely(bq->count == CPU_MAP_BULK_SIZE))
 		bq_flush_to_queue(bq);
@@ -769,6 +778,8 @@ static void bq_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_frame *xdpf)
 
 		list_add(&bq->flush_node, flush_list);
 	}
+
+	local_unlock_nested_bh(&rcpu->bulkq->bq_lock);
 }
 
 int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_frame *xdpf,
@@ -805,7 +816,9 @@ void __cpu_map_flush(struct list_head *flush_list)
 	struct xdp_bulk_queue *bq, *tmp;
 
 	list_for_each_entry_safe(bq, tmp, flush_list, flush_node) {
+		local_lock_nested_bh(&bq->obj->bulkq->bq_lock);
 		bq_flush_to_queue(bq);
+		local_unlock_nested_bh(&bq->obj->bulkq->bq_lock);
 
 		/* If already running, costs spin_lock_irqsave + smb_mb */
 		wake_up_process(bq->obj->kthread);
-- 
2.51.0

