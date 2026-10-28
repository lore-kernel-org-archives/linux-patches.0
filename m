Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216110;
	b=p3dXOl7X5iJ5hAUT6tUtyve5NszSY33/lZ0kKa7Ox/g2xJpIzBQjDMxE/g93UTa5+AC9
	 82fsljDiwmYQp3cZDPev+zDBYtcmSup9P6sI45ifeYJmU6lbLbh0DHdfNWQ5rRqWmY7WP
	 WPcX+dIh7305zGf//Xz9Rp6mzmr5R+NfuPjT30gXPZsN1865MRL1oH3slEt1h63i4VYh9
	 dFjGYiD2eqTDBGyZkp0FBHD9W1Hay3BVexVW7Uk+AD3hNW7XX+L9GLGx8UKJqLyN2gJLq
	 h+PwtQ794/C4QKNAr1HcN8eRoo7170D50x4H1Y3E7OV1eM/s4qtwiv1C2BnJDVxaysQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tRu/UxajtLaT0nkHHx2FA1Cv0YMmXpIFtnE8XcBCrQw=;
	b=5CdKcfyvhmXrtsGH+8sbVUmyennRV2G5cACVTEGjJ6+kYgw9Grw0VenlWghQyRoJjNxL
	 Z901habrOUt/x3OWWssanZG32MCjP+EC8G3Ch3B6szE1zAmHD4e67ggQ6O5aEnPDIhksW
	 oQtLpDI6Bhc+sX0HGXiQsBh9FqsoJwnvGg6t5L6uiz/k4lvLoC3b4B4szPAMda4+DzocD
	 +nXAAfv5ezNgr9hZ2/RF1B0ZegWdDM9w+f6l+g8rWQaLP51JnNVp72C3wjKefu/j2ZKD5
	 +1lgd/NJ0Qxi3FORjV+BRgVTQWBX5IY45z0xxSlCCvy/qkj87i26LDxstGxFl5OUKmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cnlb+au5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124E9606A31A;
	Wed, 28 Oct 2026 19:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cnlb+au5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E4D1F01828;
	Wed, 28 Oct 2026 19:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216109;
	bh=tRu/UxajtLaT0nkHHx2FA1Cv0YMmXpIFtnE8XcBCrQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cnlb+au5X7E1RDP0eM+Tu0PB9q1Az+4YBDN8r38hoKAsBS2coGTc+msnNRHd5NbxC
	 bPHnxFED7QJcS8CChoCrLr0jytcVhIdK5j/j8aJAJ4o5+2wjByk4LRI7qRsF9THROp
	 3dgzdhrRtk6lq14Oy09GiGm2xVjOa6gEK97if0xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhixu Liu <zhixu.liu@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1443/1887] rcu-tasks: Fix access non-existent percpu rtpcp variable in rcu_tasks_need_gpcb()
Date: Wed, 28 Oct 2026 17:58:59 +0100
Message-ID: <20261028170532.296357302@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zqiang <qiang.zhang1211@gmail.com>

[ Upstream commit fd70e9f1d85f5323096ad313ba73f5fe3d15ea41 ]

For kernels built with CONFIG_FORCE_NR_CPUS=y, the nr_cpu_ids is
defined as NR_CPUS instead of the number of possible cpus, this
will cause the following system panic:

smpboot: Allowing 4 CPUs, 0 hotplug CPUs
...
setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:512 nr_node_ids:1
...
BUG: unable to handle page fault for address: ffffffff9911c8c8
Oops: 0000 [#1] PREEMPT SMP PTI
CPU: 0 PID: 15 Comm: rcu_tasks_trace Tainted: G W
6.6.21 #1 5dc7acf91a5e8e9ac9dcfc35bee0245691283ea6
RIP: 0010:rcu_tasks_need_gpcb+0x25d/0x2c0
RSP: 0018:ffffa371c00a3e60 EFLAGS: 00010082
CR2: ffffffff9911c8c8 CR3: 000000040fa20005 CR4: 00000000001706f0
Call Trace:
<TASK>
? __die+0x23/0x80
? page_fault_oops+0xa4/0x180
? exc_page_fault+0x152/0x180
? asm_exc_page_fault+0x26/0x40
? rcu_tasks_need_gpcb+0x25d/0x2c0
? __pfx_rcu_tasks_kthread+0x40/0x40
rcu_tasks_one_gp+0x69/0x180
rcu_tasks_kthread+0x94/0xc0
kthread+0xe8/0x140
? __pfx_kthread+0x40/0x40
ret_from_fork+0x34/0x80
? __pfx_kthread+0x40/0x40
ret_from_fork_asm+0x1b/0x80
</TASK>

Considering that there may be holes in the CPU numbers, use the
maximum possible cpu number, instead of nr_cpu_ids, for configuring
enqueue and dequeue limits.

[ neeraj.upadhyay: Fix htmldocs build error reported by Stephen Rothwell ]

Closes: https://lore.kernel.org/linux-input/CALMA0xaTSMN+p4xUXkzrtR5r6k7hgoswcaXx7baR_z9r5jjskw@mail.gmail.com/T/#u
Reported-by: Zhixu Liu <zhixu.liu@gmail.com>
Signed-off-by: Zqiang <qiang.zhang1211@gmail.com>
Signed-off-by: Neeraj Upadhyay <neeraj.upadhyay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tasks.h | 82 ++++++++++++++++++++++++++++++----------------
 1 file changed, 54 insertions(+), 28 deletions(-)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index bb6b037ef30fa..a7c86baebce83 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -31,6 +31,7 @@ typedef void (*postgp_func_t)(struct rcu_tasks *rtp);
  * @barrier_q_head: RCU callback for barrier operation.
  * @rtp_blkd_tasks: List of tasks blocked as readers.
  * @cpu: CPU number corresponding to this entry.
+ * @index: Index of this CPU in rtpcp_array of the rcu_tasks structure.
  * @rtpp: Pointer to the rcu_tasks structure.
  */
 struct rcu_tasks_percpu {
@@ -43,6 +44,7 @@ struct rcu_tasks_percpu {
 	struct rcu_head barrier_q_head;
 	struct list_head rtp_blkd_tasks;
 	int cpu;
+	int index;
 	struct rcu_tasks *rtpp;
 };
 
@@ -68,6 +70,7 @@ struct rcu_tasks_percpu {
  * @postgp_func: This flavor's post-grace-period function (optional).
  * @call_func: This flavor's call_rcu()-equivalent function.
  * @rtpcpu: This flavor's rcu_tasks_percpu structure.
+ * @rtpcp_array: Array of pointers to rcu_tasks_percpu structure of CPUs in cpu_possible_mask.
  * @percpu_enqueue_shift: Shift down CPU ID this much when enqueuing callbacks.
  * @percpu_enqueue_lim: Number of per-CPU callback queues in use for enqueuing.
  * @percpu_dequeue_lim: Number of per-CPU callback queues in use for dequeuing.
@@ -100,6 +103,7 @@ struct rcu_tasks {
 	postgp_func_t postgp_func;
 	call_rcu_func_t call_func;
 	struct rcu_tasks_percpu __percpu *rtpcpu;
+	struct rcu_tasks_percpu **rtpcp_array;
 	int percpu_enqueue_shift;
 	int percpu_enqueue_lim;
 	int percpu_dequeue_lim;
@@ -164,6 +168,8 @@ module_param(rcu_task_contend_lim, int, 0444);
 static int rcu_task_collapse_lim __read_mostly = 10;
 module_param(rcu_task_collapse_lim, int, 0444);
 
+static int rcu_task_cpu_ids;
+
 /* RCU tasks grace-period state for debugging. */
 #define RTGS_INIT		 0
 #define RTGS_WAIT_WAIT_CBS	 1
@@ -228,6 +234,13 @@ static void cblist_init_generic(struct rcu_tasks *rtp)
 	unsigned long flags;
 	int lim;
 	int shift;
+	int maxcpu;
+	int index = 0;
+
+	if (!rtp->rtpcp_array) {
+		rtp->rtpcp_array = kcalloc(num_possible_cpus(), sizeof(struct rcu_tasks_percpu *), GFP_ATOMIC);
+		BUG_ON(!rtp->rtpcp_array);
+	}
 
 	raw_spin_lock_irqsave(&rtp->cbs_gbl_lock, flags);
 	if (rcu_task_enqueue_lim < 0) {
@@ -238,14 +251,6 @@ static void cblist_init_generic(struct rcu_tasks *rtp)
 	}
 	lim = rcu_task_enqueue_lim;
 
-	if (lim > nr_cpu_ids)
-		lim = nr_cpu_ids;
-	shift = ilog2(nr_cpu_ids / lim);
-	if (((nr_cpu_ids - 1) >> shift) >= lim)
-		shift++;
-	WRITE_ONCE(rtp->percpu_enqueue_shift, shift);
-	WRITE_ONCE(rtp->percpu_dequeue_lim, lim);
-	smp_store_release(&rtp->percpu_enqueue_lim, lim);
 	for_each_possible_cpu(cpu) {
 		struct rcu_tasks_percpu *rtpcp = per_cpu_ptr(rtp->rtpcpu, cpu);
 
@@ -258,16 +263,31 @@ static void cblist_init_generic(struct rcu_tasks *rtp)
 		INIT_WORK(&rtpcp->rtp_work, rcu_tasks_invoke_cbs_wq);
 		rtpcp->cpu = cpu;
 		rtpcp->rtpp = rtp;
+		rtpcp->index = index;
+		rtp->rtpcp_array[index] = rtpcp;
+		index++;
 		if (!rtpcp->rtp_blkd_tasks.next)
 			INIT_LIST_HEAD(&rtpcp->rtp_blkd_tasks);
+		maxcpu = cpu;
 		raw_spin_unlock_rcu_node(rtpcp); // irqs remain disabled.
 	}
+
+	rcu_task_cpu_ids = maxcpu + 1;
+	if (lim > rcu_task_cpu_ids)
+		lim = rcu_task_cpu_ids;
+	shift = ilog2(rcu_task_cpu_ids / lim);
+	if (((rcu_task_cpu_ids - 1) >> shift) >= lim)
+		shift++;
+	WRITE_ONCE(rtp->percpu_enqueue_shift, shift);
+	WRITE_ONCE(rtp->percpu_dequeue_lim, lim);
+	smp_store_release(&rtp->percpu_enqueue_lim, lim);
 	raw_spin_unlock_irqrestore(&rtp->cbs_gbl_lock, flags);
 
 	if (rcu_task_cb_adjust)
 		pr_info("%s: Setting adjustable number of callback queues.\n", __func__);
 
-	pr_info("%s: Setting shift to %d and lim to %d.\n", __func__, data_race(rtp->percpu_enqueue_shift), data_race(rtp->percpu_enqueue_lim));
+	pr_info("%s: Setting shift to %d and lim to %d rcu_task_cpu_ids=%d.\n", __func__,
+		data_race(rtp->percpu_enqueue_shift), data_race(rtp->percpu_enqueue_lim), rcu_task_cpu_ids);
 }
 
 // IRQ-work handler that does deferred wakeup for call_rcu_tasks_generic().
@@ -307,7 +327,7 @@ static void call_rcu_tasks_generic(struct rcu_head *rhp, rcu_callback_t func,
 			rtpcp->rtp_n_lock_retries = 0;
 		}
 		if (rcu_task_cb_adjust && ++rtpcp->rtp_n_lock_retries > rcu_task_contend_lim &&
-		    READ_ONCE(rtp->percpu_enqueue_lim) != nr_cpu_ids)
+		    READ_ONCE(rtp->percpu_enqueue_lim) != rcu_task_cpu_ids)
 			needadjust = true;  // Defer adjustment to avoid deadlock.
 	}
 	if (!rcu_segcblist_is_enabled(&rtpcp->cblist)) {
@@ -320,10 +340,10 @@ static void call_rcu_tasks_generic(struct rcu_head *rhp, rcu_callback_t func,
 	raw_spin_unlock_irqrestore_rcu_node(rtpcp, flags);
 	if (unlikely(needadjust)) {
 		raw_spin_lock_irqsave(&rtp->cbs_gbl_lock, flags);
-		if (rtp->percpu_enqueue_lim != nr_cpu_ids) {
+		if (rtp->percpu_enqueue_lim != rcu_task_cpu_ids) {
 			WRITE_ONCE(rtp->percpu_enqueue_shift, 0);
-			WRITE_ONCE(rtp->percpu_dequeue_lim, nr_cpu_ids);
-			smp_store_release(&rtp->percpu_enqueue_lim, nr_cpu_ids);
+			WRITE_ONCE(rtp->percpu_dequeue_lim, rcu_task_cpu_ids);
+			smp_store_release(&rtp->percpu_enqueue_lim, rcu_task_cpu_ids);
 			pr_info("Switching %s to per-CPU callback queuing.\n", rtp->name);
 		}
 		raw_spin_unlock_irqrestore(&rtp->cbs_gbl_lock, flags);
@@ -396,6 +416,8 @@ static int rcu_tasks_need_gpcb(struct rcu_tasks *rtp)
 	for (cpu = 0; cpu < smp_load_acquire(&rtp->percpu_dequeue_lim); cpu++) {
 		struct rcu_tasks_percpu *rtpcp = per_cpu_ptr(rtp->rtpcpu, cpu);
 
+		if (!cpu_possible(cpu))
+			continue;
 		/* Advance and accelerate any new callbacks. */
 		if (!rcu_segcblist_n_cbs(&rtpcp->cblist))
 			continue;
@@ -426,7 +448,7 @@ static int rcu_tasks_need_gpcb(struct rcu_tasks *rtp)
 	if (rcu_task_cb_adjust && ncbs <= rcu_task_collapse_lim) {
 		raw_spin_lock_irqsave(&rtp->cbs_gbl_lock, flags);
 		if (rtp->percpu_enqueue_lim > 1) {
-			WRITE_ONCE(rtp->percpu_enqueue_shift, order_base_2(nr_cpu_ids));
+			WRITE_ONCE(rtp->percpu_enqueue_shift, order_base_2(rcu_task_cpu_ids));
 			smp_store_release(&rtp->percpu_enqueue_lim, 1);
 			rtp->percpu_dequeue_gpseq = get_state_synchronize_rcu();
 			gpdone = false;
@@ -441,7 +463,9 @@ static int rcu_tasks_need_gpcb(struct rcu_tasks *rtp)
 			pr_info("Completing switch %s to CPU-0 callback queuing.\n", rtp->name);
 		}
 		if (rtp->percpu_dequeue_lim == 1) {
-			for (cpu = rtp->percpu_dequeue_lim; cpu < nr_cpu_ids; cpu++) {
+			for (cpu = rtp->percpu_dequeue_lim; cpu < rcu_task_cpu_ids; cpu++) {
+				if (!cpu_possible(cpu))
+					continue;
 				struct rcu_tasks_percpu *rtpcp = per_cpu_ptr(rtp->rtpcpu, cpu);
 
 				WARN_ON_ONCE(rcu_segcblist_n_cbs(&rtpcp->cblist));
@@ -456,30 +480,32 @@ static int rcu_tasks_need_gpcb(struct rcu_tasks *rtp)
 // Advance callbacks and invoke any that are ready.
 static void rcu_tasks_invoke_cbs(struct rcu_tasks *rtp, struct rcu_tasks_percpu *rtpcp)
 {
-	int cpu;
-	int cpunext;
 	int cpuwq;
 	unsigned long flags;
 	int len;
+	int index;
 	struct rcu_head *rhp;
 	struct rcu_cblist rcl = RCU_CBLIST_INITIALIZER(rcl);
 	struct rcu_tasks_percpu *rtpcp_next;
 
-	cpu = rtpcp->cpu;
-	cpunext = cpu * 2 + 1;
-	if (cpunext < smp_load_acquire(&rtp->percpu_dequeue_lim)) {
-		rtpcp_next = per_cpu_ptr(rtp->rtpcpu, cpunext);
-		cpuwq = rcu_cpu_beenfullyonline(cpunext) ? cpunext : WORK_CPU_UNBOUND;
-		queue_work_on(cpuwq, system_wq, &rtpcp_next->rtp_work);
-		cpunext++;
-		if (cpunext < smp_load_acquire(&rtp->percpu_dequeue_lim)) {
-			rtpcp_next = per_cpu_ptr(rtp->rtpcpu, cpunext);
-			cpuwq = rcu_cpu_beenfullyonline(cpunext) ? cpunext : WORK_CPU_UNBOUND;
+	index = rtpcp->index * 2 + 1;
+	if (index < num_possible_cpus()) {
+		rtpcp_next = rtp->rtpcp_array[index];
+		if (rtpcp_next->cpu < smp_load_acquire(&rtp->percpu_dequeue_lim)) {
+			cpuwq = rcu_cpu_beenfullyonline(rtpcp_next->cpu) ? rtpcp_next->cpu : WORK_CPU_UNBOUND;
 			queue_work_on(cpuwq, system_wq, &rtpcp_next->rtp_work);
+			index++;
+			if (index < num_possible_cpus()) {
+				rtpcp_next = rtp->rtpcp_array[index];
+				if (rtpcp_next->cpu < smp_load_acquire(&rtp->percpu_dequeue_lim)) {
+					cpuwq = rcu_cpu_beenfullyonline(rtpcp_next->cpu) ? rtpcp_next->cpu : WORK_CPU_UNBOUND;
+					queue_work_on(cpuwq, system_wq, &rtpcp_next->rtp_work);
+				}
+			}
 		}
 	}
 
-	if (rcu_segcblist_empty(&rtpcp->cblist) || !cpu_possible(cpu))
+	if (rcu_segcblist_empty(&rtpcp->cblist))
 		return;
 	raw_spin_lock_irqsave_rcu_node(rtpcp, flags);
 	rcu_segcblist_advance(&rtpcp->cblist, rcu_seq_current(&rtp->tasks_gp_seq));
-- 
2.53.0



