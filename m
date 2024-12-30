Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAE415E8B;
	Mon, 30 Dec 2024 15:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573690; cv=none; b=jfmGu+sCpGSyvMmgn1xNlsbNtHAvpMoGy6XTNk/FIHPzqmrK6BbSgozeh2gD+AQenW/UhH6Tm2JG+/bVVPatbVbShU6iIvbb8d4G9K4EU4Ud6Ao3blEoKVdxTIM8FTBX+BmQRJ9WulmM/FZT+WT4/stZBM/9YSii7lBtgg8JuHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573690; c=relaxed/simple;
	bh=RutteTemFOGwt4NXmL8GFVnSxQFy50i4i9Fk19QhK7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TIwHXoQ0JIHg3YbwBoWtowu2Mksx0IYUSiMCWATWoavRnssbyEeLx9yAA12h/scFpm4hOUT0BlITZJn4U8bPFaFsJGoAl83Al2ke0LyzD2GS06xadm/rI4bvVuc1sdfRv6VtAYCkDlcSeaBZQxuIv32MIyYlHri48CuV3Mwaebg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w1iQ/+7j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w1iQ/+7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44294C4CED0;
	Mon, 30 Dec 2024 15:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573690;
	bh=RutteTemFOGwt4NXmL8GFVnSxQFy50i4i9Fk19QhK7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w1iQ/+7jg+ZfUbpIj8jgKlvhXVrvD3k2Nrr2ibFr8gX0ioVd1fzpk3jK/Bbq0BW5v
	 ffSQSWAz7RTSKj+B6gKhElfvke6QWcpFa50pgUdGB0aSCzY41T0/rqknen0v1pi9RC
	 kSODmldMTwPsYan8T7/vZ+TX1bItK/bBvbvTozbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Zhixu Liu <zhixu.liu@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.1 59/60] Revert "rcu-tasks: Fix access non-existent percpu rtpcp variable in rcu_tasks_need_gpcb()"
Date: Mon, 30 Dec 2024 16:43:09 +0100
Message-ID: <20241230154209.518961110@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 224fd631c41b81697aa622d38615bfbf446b91cf which is
commit fd70e9f1d85f5323096ad313ba73f5fe3d15ea41 upstream.

It is reported to cause problems in testing, so revert it for now.

Link: https://lore.kernel.org/r/20241216-comic-handling-3bcf108cc465@wendy
Reported-by: Conor Dooley <conor.dooley@microchip.com>
CC: Zhixu Liu <zhixu.liu@gmail.com>
Cc: Zqiang <qiang.zhang1211@gmail.com>
Cc: Neeraj Upadhyay <neeraj.upadhyay@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/tasks.h |   82 ++++++++++++++++++-----------------------------------
 1 file changed, 28 insertions(+), 54 deletions(-)

--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -31,7 +31,6 @@ typedef void (*postgp_func_t)(struct rcu
  * @barrier_q_head: RCU callback for barrier operation.
  * @rtp_blkd_tasks: List of tasks blocked as readers.
  * @cpu: CPU number corresponding to this entry.
- * @index: Index of this CPU in rtpcp_array of the rcu_tasks structure.
  * @rtpp: Pointer to the rcu_tasks structure.
  */
 struct rcu_tasks_percpu {
@@ -44,7 +43,6 @@ struct rcu_tasks_percpu {
 	struct rcu_head barrier_q_head;
 	struct list_head rtp_blkd_tasks;
 	int cpu;
-	int index;
 	struct rcu_tasks *rtpp;
 };
 
@@ -70,7 +68,6 @@ struct rcu_tasks_percpu {
  * @postgp_func: This flavor's post-grace-period function (optional).
  * @call_func: This flavor's call_rcu()-equivalent function.
  * @rtpcpu: This flavor's rcu_tasks_percpu structure.
- * @rtpcp_array: Array of pointers to rcu_tasks_percpu structure of CPUs in cpu_possible_mask.
  * @percpu_enqueue_shift: Shift down CPU ID this much when enqueuing callbacks.
  * @percpu_enqueue_lim: Number of per-CPU callback queues in use for enqueuing.
  * @percpu_dequeue_lim: Number of per-CPU callback queues in use for dequeuing.
@@ -103,7 +100,6 @@ struct rcu_tasks {
 	postgp_func_t postgp_func;
 	call_rcu_func_t call_func;
 	struct rcu_tasks_percpu __percpu *rtpcpu;
-	struct rcu_tasks_percpu **rtpcp_array;
 	int percpu_enqueue_shift;
 	int percpu_enqueue_lim;
 	int percpu_dequeue_lim;
@@ -168,8 +164,6 @@ module_param(rcu_task_contend_lim, int,
 static int rcu_task_collapse_lim __read_mostly = 10;
 module_param(rcu_task_collapse_lim, int, 0444);
 
-static int rcu_task_cpu_ids;
-
 /* RCU tasks grace-period state for debugging. */
 #define RTGS_INIT		 0
 #define RTGS_WAIT_WAIT_CBS	 1
@@ -234,8 +228,6 @@ static void cblist_init_generic(struct r
 	unsigned long flags;
 	int lim;
 	int shift;
-	int maxcpu;
-	int index = 0;
 
 	raw_spin_lock_irqsave(&rtp->cbs_gbl_lock, flags);
 	if (rcu_task_enqueue_lim < 0) {
@@ -246,9 +238,14 @@ static void cblist_init_generic(struct r
 	}
 	lim = rcu_task_enqueue_lim;
 
-	rtp->rtpcp_array = kcalloc(num_possible_cpus(), sizeof(struct rcu_tasks_percpu *), GFP_KERNEL);
-	BUG_ON(!rtp->rtpcp_array);
-
+	if (lim > nr_cpu_ids)
+		lim = nr_cpu_ids;
+	shift = ilog2(nr_cpu_ids / lim);
+	if (((nr_cpu_ids - 1) >> shift) >= lim)
+		shift++;
+	WRITE_ONCE(rtp->percpu_enqueue_shift, shift);
+	WRITE_ONCE(rtp->percpu_dequeue_lim, lim);
+	smp_store_release(&rtp->percpu_enqueue_lim, lim);
 	for_each_possible_cpu(cpu) {
 		struct rcu_tasks_percpu *rtpcp = per_cpu_ptr(rtp->rtpcpu, cpu);
 
@@ -261,33 +258,16 @@ static void cblist_init_generic(struct r
 		INIT_WORK(&rtpcp->rtp_work, rcu_tasks_invoke_cbs_wq);
 		rtpcp->cpu = cpu;
 		rtpcp->rtpp = rtp;
-		rtpcp->index = index;
-		rtp->rtpcp_array[index] = rtpcp;
-		index++;
 		if (!rtpcp->rtp_blkd_tasks.next)
 			INIT_LIST_HEAD(&rtpcp->rtp_blkd_tasks);
 		raw_spin_unlock_rcu_node(rtpcp); // irqs remain disabled.
-		maxcpu = cpu;
 	}
 	raw_spin_unlock_irqrestore(&rtp->cbs_gbl_lock, flags);
 
 	if (rcu_task_cb_adjust)
 		pr_info("%s: Setting adjustable number of callback queues.\n", __func__);
 
-	rcu_task_cpu_ids = maxcpu + 1;
-	if (lim > rcu_task_cpu_ids)
-		lim = rcu_task_cpu_ids;
-	shift = ilog2(rcu_task_cpu_ids / lim);
-	if (((rcu_task_cpu_ids - 1) >> shift) >= lim)
-		shift++;
-	WRITE_ONCE(rtp->percpu_enqueue_shift, shift);
-	WRITE_ONCE(rtp->percpu_dequeue_lim, lim);
-	smp_store_release(&rtp->percpu_enqueue_lim, lim);
-
-	pr_info("%s: Setting shift to %d and lim to %d rcu_task_cb_adjust=%d rcu_task_cpu_ids=%d.\n",
-			rtp->name, data_race(rtp->percpu_enqueue_shift), data_race(rtp->percpu_enqueue_lim),
-			rcu_task_cb_adjust, rcu_task_cpu_ids);
-
+	pr_info("%s: Setting shift to %d and lim to %d.\n", __func__, data_race(rtp->percpu_enqueue_shift), data_race(rtp->percpu_enqueue_lim));
 }
 
 // IRQ-work handler that does deferred wakeup for call_rcu_tasks_generic().
@@ -327,7 +307,7 @@ static void call_rcu_tasks_generic(struc
 			rtpcp->rtp_n_lock_retries = 0;
 		}
 		if (rcu_task_cb_adjust && ++rtpcp->rtp_n_lock_retries > rcu_task_contend_lim &&
-		    READ_ONCE(rtp->percpu_enqueue_lim) != rcu_task_cpu_ids)
+		    READ_ONCE(rtp->percpu_enqueue_lim) != nr_cpu_ids)
 			needadjust = true;  // Defer adjustment to avoid deadlock.
 	}
 	if (!rcu_segcblist_is_enabled(&rtpcp->cblist)) {
@@ -340,10 +320,10 @@ static void call_rcu_tasks_generic(struc
 	raw_spin_unlock_irqrestore_rcu_node(rtpcp, flags);
 	if (unlikely(needadjust)) {
 		raw_spin_lock_irqsave(&rtp->cbs_gbl_lock, flags);
-		if (rtp->percpu_enqueue_lim != rcu_task_cpu_ids) {
+		if (rtp->percpu_enqueue_lim != nr_cpu_ids) {
 			WRITE_ONCE(rtp->percpu_enqueue_shift, 0);
-			WRITE_ONCE(rtp->percpu_dequeue_lim, rcu_task_cpu_ids);
-			smp_store_release(&rtp->percpu_enqueue_lim, rcu_task_cpu_ids);
+			WRITE_ONCE(rtp->percpu_dequeue_lim, nr_cpu_ids);
+			smp_store_release(&rtp->percpu_enqueue_lim, nr_cpu_ids);
 			pr_info("Switching %s to per-CPU callback queuing.\n", rtp->name);
 		}
 		raw_spin_unlock_irqrestore(&rtp->cbs_gbl_lock, flags);
@@ -414,8 +394,6 @@ static int rcu_tasks_need_gpcb(struct rc
 	int needgpcb = 0;
 
 	for (cpu = 0; cpu < smp_load_acquire(&rtp->percpu_dequeue_lim); cpu++) {
-		if (!cpu_possible(cpu))
-			continue;
 		struct rcu_tasks_percpu *rtpcp = per_cpu_ptr(rtp->rtpcpu, cpu);
 
 		/* Advance and accelerate any new callbacks. */
@@ -448,7 +426,7 @@ static int rcu_tasks_need_gpcb(struct rc
 	if (rcu_task_cb_adjust && ncbs <= rcu_task_collapse_lim) {
 		raw_spin_lock_irqsave(&rtp->cbs_gbl_lock, flags);
 		if (rtp->percpu_enqueue_lim > 1) {
-			WRITE_ONCE(rtp->percpu_enqueue_shift, order_base_2(rcu_task_cpu_ids));
+			WRITE_ONCE(rtp->percpu_enqueue_shift, order_base_2(nr_cpu_ids));
 			smp_store_release(&rtp->percpu_enqueue_lim, 1);
 			rtp->percpu_dequeue_gpseq = get_state_synchronize_rcu();
 			gpdone = false;
@@ -463,9 +441,7 @@ static int rcu_tasks_need_gpcb(struct rc
 			pr_info("Completing switch %s to CPU-0 callback queuing.\n", rtp->name);
 		}
 		if (rtp->percpu_dequeue_lim == 1) {
-			for (cpu = rtp->percpu_dequeue_lim; cpu < rcu_task_cpu_ids; cpu++) {
-				if (!cpu_possible(cpu))
-					continue;
+			for (cpu = rtp->percpu_dequeue_lim; cpu < nr_cpu_ids; cpu++) {
 				struct rcu_tasks_percpu *rtpcp = per_cpu_ptr(rtp->rtpcpu, cpu);
 
 				WARN_ON_ONCE(rcu_segcblist_n_cbs(&rtpcp->cblist));
@@ -480,32 +456,30 @@ static int rcu_tasks_need_gpcb(struct rc
 // Advance callbacks and invoke any that are ready.
 static void rcu_tasks_invoke_cbs(struct rcu_tasks *rtp, struct rcu_tasks_percpu *rtpcp)
 {
+	int cpu;
+	int cpunext;
 	int cpuwq;
 	unsigned long flags;
 	int len;
-	int index;
 	struct rcu_head *rhp;
 	struct rcu_cblist rcl = RCU_CBLIST_INITIALIZER(rcl);
 	struct rcu_tasks_percpu *rtpcp_next;
 
-	index = rtpcp->index * 2 + 1;
-	if (index < num_possible_cpus()) {
-		rtpcp_next = rtp->rtpcp_array[index];
-		if (rtpcp_next->cpu < smp_load_acquire(&rtp->percpu_dequeue_lim)) {
-			cpuwq = rcu_cpu_beenfullyonline(rtpcp_next->cpu) ? rtpcp_next->cpu : WORK_CPU_UNBOUND;
+	cpu = rtpcp->cpu;
+	cpunext = cpu * 2 + 1;
+	if (cpunext < smp_load_acquire(&rtp->percpu_dequeue_lim)) {
+		rtpcp_next = per_cpu_ptr(rtp->rtpcpu, cpunext);
+		cpuwq = rcu_cpu_beenfullyonline(cpunext) ? cpunext : WORK_CPU_UNBOUND;
+		queue_work_on(cpuwq, system_wq, &rtpcp_next->rtp_work);
+		cpunext++;
+		if (cpunext < smp_load_acquire(&rtp->percpu_dequeue_lim)) {
+			rtpcp_next = per_cpu_ptr(rtp->rtpcpu, cpunext);
+			cpuwq = rcu_cpu_beenfullyonline(cpunext) ? cpunext : WORK_CPU_UNBOUND;
 			queue_work_on(cpuwq, system_wq, &rtpcp_next->rtp_work);
-			index++;
-			if (index < num_possible_cpus()) {
-				rtpcp_next = rtp->rtpcp_array[index];
-				if (rtpcp_next->cpu < smp_load_acquire(&rtp->percpu_dequeue_lim)) {
-					cpuwq = rcu_cpu_beenfullyonline(rtpcp_next->cpu) ? rtpcp_next->cpu : WORK_CPU_UNBOUND;
-					queue_work_on(cpuwq, system_wq, &rtpcp_next->rtp_work);
-				}
-			}
 		}
 	}
 
-	if (rcu_segcblist_empty(&rtpcp->cblist))
+	if (rcu_segcblist_empty(&rtpcp->cblist) || !cpu_possible(cpu))
 		return;
 	raw_spin_lock_irqsave_rcu_node(rtpcp, flags);
 	rcu_segcblist_advance(&rtpcp->cblist, rcu_seq_current(&rtp->tasks_gp_seq));


