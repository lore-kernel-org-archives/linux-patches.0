Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413F28F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA459C433C8;
	Sun, 16 Jul 2023 19:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537423;
	bh=j3E/ItlzibZLH621om9kna0FmEXYkwZ5ml6F+947IlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fj1QJI6lJdIvwIfR5zXDvllWqJDIGM9NWasvarnYNoRkBJmy/yCN0j0Cj7HkNZ8ij
	 +1cCFPm+Vb2wmrGGsGi7G6KOlRGcosoTpaLQ4iQ8CHlsBY3Vt5h3cvi0ZPaeARqwzI
	 Og1NHLzPYQctMqDP1FVYe8Wgz9CHqvx/mxdxFVKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 083/800] rcu-tasks: Stop rcu_tasks_invoke_cbs() from using never-onlined CPUs
Date: Sun, 16 Jul 2023 21:38:56 +0200
Message-ID: <20230716194951.036517887@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 401b0de3ae4fa49d1014c8941e26d9a25f37e7cf ]

The rcu_tasks_invoke_cbs() function relies on queue_work_on() to silently
fall back to WORK_CPU_UNBOUND when the specified CPU is offline.  However,
the queue_work_on() function's silent fallback mechanism relies on that
CPU having been online at some time in the past.  When queue_work_on()
is passed a CPU that has never been online, workqueue lockups ensue,
which can be bad for your kernel's general health and well-being.

This commit therefore checks whether a given CPU has ever been online,
and, if not substitutes WORK_CPU_UNBOUND in the subsequent call to
queue_work_on().  Why not simply omit the queue_work_on() call entirely?
Because this function is flooding callback-invocation notifications
to all CPUs, and must deal with possibilities that include a sparse
cpu_possible_mask.

This commit also moves the setting of the rcu_data structure's
->beenonline field to rcu_cpu_starting(), which executes on the
incoming CPU before that CPU has ever enabled interrupts.  This ensures
that the required workqueues are present.  In addition, because the
incoming CPU has not yet enabled its interrupts, there cannot yet have
been any softirq handlers running on this CPU, which means that the
WARN_ON_ONCE(!rdp->beenonline) within the RCU_SOFTIRQ handler cannot
have triggered yet.

Fixes: d363f833c6d88 ("rcu-tasks: Use workqueues for multiple rcu_tasks_invoke_cbs() invocations")
Reported-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcu.h   |  6 ++++++
 kernel/rcu/tasks.h |  7 +++++--
 kernel/rcu/tree.c  | 12 +++++++++++-
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
index 4a1b9622598be..98c1544cf572b 100644
--- a/kernel/rcu/rcu.h
+++ b/kernel/rcu/rcu.h
@@ -642,4 +642,10 @@ void show_rcu_tasks_trace_gp_kthread(void);
 static inline void show_rcu_tasks_trace_gp_kthread(void) {}
 #endif
 
+#ifdef CONFIG_TINY_RCU
+static inline bool rcu_cpu_beenfullyonline(int cpu) { return true; }
+#else
+bool rcu_cpu_beenfullyonline(int cpu);
+#endif
+
 #endif /* __LINUX_RCU_H */
diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index 5f4fc8184dd0b..8f08c087142b0 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -463,6 +463,7 @@ static void rcu_tasks_invoke_cbs(struct rcu_tasks *rtp, struct rcu_tasks_percpu
 {
 	int cpu;
 	int cpunext;
+	int cpuwq;
 	unsigned long flags;
 	int len;
 	struct rcu_head *rhp;
@@ -473,11 +474,13 @@ static void rcu_tasks_invoke_cbs(struct rcu_tasks *rtp, struct rcu_tasks_percpu
 	cpunext = cpu * 2 + 1;
 	if (cpunext < smp_load_acquire(&rtp->percpu_dequeue_lim)) {
 		rtpcp_next = per_cpu_ptr(rtp->rtpcpu, cpunext);
-		queue_work_on(cpunext, system_wq, &rtpcp_next->rtp_work);
+		cpuwq = rcu_cpu_beenfullyonline(cpunext) ? cpunext : WORK_CPU_UNBOUND;
+		queue_work_on(cpuwq, system_wq, &rtpcp_next->rtp_work);
 		cpunext++;
 		if (cpunext < smp_load_acquire(&rtp->percpu_dequeue_lim)) {
 			rtpcp_next = per_cpu_ptr(rtp->rtpcpu, cpunext);
-			queue_work_on(cpunext, system_wq, &rtpcp_next->rtp_work);
+			cpuwq = rcu_cpu_beenfullyonline(cpunext) ? cpunext : WORK_CPU_UNBOUND;
+			queue_work_on(cpuwq, system_wq, &rtpcp_next->rtp_work);
 		}
 	}
 
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index d5c9afa8adfbd..ce51f85f0d5e4 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -4283,7 +4283,6 @@ int rcutree_prepare_cpu(unsigned int cpu)
 	 */
 	rnp = rdp->mynode;
 	raw_spin_lock_rcu_node(rnp);		/* irqs already disabled. */
-	rdp->beenonline = true;	 /* We have now been online. */
 	rdp->gp_seq = READ_ONCE(rnp->gp_seq);
 	rdp->gp_seq_needed = rdp->gp_seq;
 	rdp->cpu_no_qs.b.norm = true;
@@ -4310,6 +4309,16 @@ static void rcutree_affinity_setting(unsigned int cpu, int outgoing)
 	rcu_boost_kthread_setaffinity(rdp->mynode, outgoing);
 }
 
+/*
+ * Has the specified (known valid) CPU ever been fully online?
+ */
+bool rcu_cpu_beenfullyonline(int cpu)
+{
+	struct rcu_data *rdp = per_cpu_ptr(&rcu_data, cpu);
+
+	return smp_load_acquire(&rdp->beenonline);
+}
+
 /*
  * Near the end of the CPU-online process.  Pretty much all services
  * enabled, and the CPU is now very much alive.
@@ -4413,6 +4422,7 @@ void rcu_cpu_starting(unsigned int cpu)
 		raw_spin_unlock_rcu_node(rnp);
 	}
 	arch_spin_unlock(&rcu_state.ofl_lock);
+	smp_store_release(&rdp->beenonline, true);
 	smp_mb(); /* Ensure RCU read-side usage follows above initialization. */
 }
 
-- 
2.39.2



