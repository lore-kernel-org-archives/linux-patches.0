Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7F523ED76;
	Thu, 12 Dec 2024 16:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020002; cv=none; b=V9BEXV4JNp+bYw4sVCyLW6lrkxuQETQKWJ9JSf8I9EH0NnFxOT0J3dasj7I08Q7GPCBwJ9V0j/k2igO2bp+FfRK/i10IPB0x3KYcNYmSaTagoYhWGFr3ilMCYHh5cRyWJU78Pi7gtiXJUA/YuhFsrfzfwsNf1YA5qdEpYjALY+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020002; c=relaxed/simple;
	bh=owS4ER3FJcPTRmONNSDCHtmqSpusGuejyWaZX+ImufE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBchSHLafuthTsSbuUDzpoa1BSh5OFf6r5sAIf/dHt1JzxPVBJDDKUC/zgZya6mBwZyKk69kiKlSkuNSBShFv3OsLZEOTPOqiVo7TQ56vstAiaLshiHdpjRiCEnWYTyM3j14jknov0QoOsTciH6Ce7V+kM3akMJh6oAOKW65sZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9ONdgoV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9ONdgoV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86CB0C4CED3;
	Thu, 12 Dec 2024 16:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020002;
	bh=owS4ER3FJcPTRmONNSDCHtmqSpusGuejyWaZX+ImufE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X9ONdgoVfkW4TNqUurbD9DV/h92nCNa/fDtk5R9wklcEqWzcll0gNUSsPrjqWP9yy
	 +CJxu8B4XtxcAqTN/9cTqr3lNpM7RJcd8J2uxnJLWPDu22xz+R0hOKa19Kx0JC60tZ
	 pwHvycw9z1If+5rt94HbAcBD6J1hJ6AoX0niYv/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhixu Liu <zhixu.liu@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.1 351/772] rcu-tasks: Fix access non-existent percpu rtpcp variable in rcu_tasks_need_gpcb()
Date: Thu, 12 Dec 2024 15:54:56 +0100
Message-ID: <20241212144404.411736948@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Zqiang <qiang.zhang1211@gmail.com>

commit fd70e9f1d85f5323096ad313ba73f5fe3d15ea41 upstream.

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
[Xiangyu: BP to fix CVE:CVE-2024-49926, minor conflict resolution]
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/tasks.h |   82 ++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 54 insertions(+), 28 deletions(-)

--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -31,6 +31,7 @@ typedef void (*postgp_func_t)(struct rcu
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
@@ -164,6 +168,8 @@ module_param(rcu_task_contend_lim, int,
 static int rcu_task_collapse_lim __read_mostly = 10;
 module_param(rcu_task_collapse_lim, int, 0444);
 
+static int rcu_task_cpu_ids;
+
 /* RCU tasks grace-period state for debugging. */
 #define RTGS_INIT		 0
 #define RTGS_WAIT_WAIT_CBS	 1
@@ -228,6 +234,8 @@ static void cblist_init_generic(struct r
 	unsigned long flags;
 	int lim;
 	int shift;
+	int maxcpu;
+	int index = 0;
 
 	raw_spin_lock_irqsave(&rtp->cbs_gbl_lock, flags);
 	if (rcu_task_enqueue_lim < 0) {
@@ -238,14 +246,9 @@ static void cblist_init_generic(struct r
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
+	rtp->rtpcp_array = kcalloc(num_possible_cpus(), sizeof(struct rcu_tasks_percpu *), GFP_KERNEL);
+	BUG_ON(!rtp->rtpcp_array);
+
 	for_each_possible_cpu(cpu) {
 		struct rcu_tasks_percpu *rtpcp = per_cpu_ptr(rtp->rtpcpu, cpu);
 
@@ -258,16 +261,33 @@ static void cblist_init_generic(struct r
 		INIT_WORK(&rtpcp->rtp_work, rcu_tasks_invoke_cbs_wq);
 		rtpcp->cpu = cpu;
 		rtpcp->rtpp = rtp;
+		rtpcp->index = index;
+		rtp->rtpcp_array[index] = rtpcp;
+		index++;
 		if (!rtpcp->rtp_blkd_tasks.next)
 			INIT_LIST_HEAD(&rtpcp->rtp_blkd_tasks);
 		raw_spin_unlock_rcu_node(rtpcp); // irqs remain disabled.
+		maxcpu = cpu;
 	}
 	raw_spin_unlock_irqrestore(&rtp->cbs_gbl_lock, flags);
 
 	if (rcu_task_cb_adjust)
 		pr_info("%s: Setting adjustable number of callback queues.\n", __func__);
 
-	pr_info("%s: Setting shift to %d and lim to %d.\n", __func__, data_race(rtp->percpu_enqueue_shift), data_race(rtp->percpu_enqueue_lim));
+	rcu_task_cpu_ids = maxcpu + 1;
+	if (lim > rcu_task_cpu_ids)
+		lim = rcu_task_cpu_ids;
+	shift = ilog2(rcu_task_cpu_ids / lim);
+	if (((rcu_task_cpu_ids - 1) >> shift) >= lim)
+		shift++;
+	WRITE_ONCE(rtp->percpu_enqueue_shift, shift);
+	WRITE_ONCE(rtp->percpu_dequeue_lim, lim);
+	smp_store_release(&rtp->percpu_enqueue_lim, lim);
+
+	pr_info("%s: Setting shift to %d and lim to %d rcu_task_cb_adjust=%d rcu_task_cpu_ids=%d.\n",
+			rtp->name, data_race(rtp->percpu_enqueue_shift), data_race(rtp->percpu_enqueue_lim),
+			rcu_task_cb_adjust, rcu_task_cpu_ids);
+
 }
 
 // IRQ-work handler that does deferred wakeup for call_rcu_tasks_generic().
@@ -307,7 +327,7 @@ static void call_rcu_tasks_generic(struc
 			rtpcp->rtp_n_lock_retries = 0;
 		}
 		if (rcu_task_cb_adjust && ++rtpcp->rtp_n_lock_retries > rcu_task_contend_lim &&
-		    READ_ONCE(rtp->percpu_enqueue_lim) != nr_cpu_ids)
+		    READ_ONCE(rtp->percpu_enqueue_lim) != rcu_task_cpu_ids)
 			needadjust = true;  // Defer adjustment to avoid deadlock.
 	}
 	if (!rcu_segcblist_is_enabled(&rtpcp->cblist)) {
@@ -320,10 +340,10 @@ static void call_rcu_tasks_generic(struc
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
@@ -394,6 +414,8 @@ static int rcu_tasks_need_gpcb(struct rc
 	int needgpcb = 0;
 
 	for (cpu = 0; cpu < smp_load_acquire(&rtp->percpu_dequeue_lim); cpu++) {
+		if (!cpu_possible(cpu))
+			continue;
 		struct rcu_tasks_percpu *rtpcp = per_cpu_ptr(rtp->rtpcpu, cpu);
 
 		/* Advance and accelerate any new callbacks. */
@@ -426,7 +448,7 @@ static int rcu_tasks_need_gpcb(struct rc
 	if (rcu_task_cb_adjust && ncbs <= rcu_task_collapse_lim) {
 		raw_spin_lock_irqsave(&rtp->cbs_gbl_lock, flags);
 		if (rtp->percpu_enqueue_lim > 1) {
-			WRITE_ONCE(rtp->percpu_enqueue_shift, order_base_2(nr_cpu_ids));
+			WRITE_ONCE(rtp->percpu_enqueue_shift, order_base_2(rcu_task_cpu_ids));
 			smp_store_release(&rtp->percpu_enqueue_lim, 1);
 			rtp->percpu_dequeue_gpseq = get_state_synchronize_rcu();
 			gpdone = false;
@@ -441,7 +463,9 @@ static int rcu_tasks_need_gpcb(struct rc
 			pr_info("Completing switch %s to CPU-0 callback queuing.\n", rtp->name);
 		}
 		if (rtp->percpu_dequeue_lim == 1) {
-			for (cpu = rtp->percpu_dequeue_lim; cpu < nr_cpu_ids; cpu++) {
+			for (cpu = rtp->percpu_dequeue_lim; cpu < rcu_task_cpu_ids; cpu++) {
+				if (!cpu_possible(cpu))
+					continue;
 				struct rcu_tasks_percpu *rtpcp = per_cpu_ptr(rtp->rtpcpu, cpu);
 
 				WARN_ON_ONCE(rcu_segcblist_n_cbs(&rtpcp->cblist));
@@ -456,30 +480,32 @@ static int rcu_tasks_need_gpcb(struct rc
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


