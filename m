Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C66315AAA8;
	Mon, 29 Jan 2024 17:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548159; cv=none; b=rulFEJTfOHkgWLxNw+EPftZ1Nu3UZwqJfkb0vetRefquxqud/xJqbhg5smRHSWOADMkFlssWj83GK2tldQsuSVjQ/84foCwJL6kzaYDWyK4qng95/ww2j1Q6Qo9ZzzLHFx3Z3A17ssWmbL7MHkWZPrbQ/v0m8C1tS0QYDiWb9dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548159; c=relaxed/simple;
	bh=h0TXZGT++1VJ6unMYuCME4Yru9drFqJoVje+tYYF9BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RF1pybXephroouhRcz5un+h91MhaUTQ5ATn2lOaF9pqgLLb6gbFvar46/Ausf9rgfz8X93xTom+NcpgeYyjancP3a1o3mhhWtcjeA9iAm3mRdbZuST+rchirt6XWq7h6mpOrTrUj+HP+onA8L7t8THhjaAzsHid1HCu6C9JwRNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNslL1EA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNslL1EA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC3DFC43394;
	Mon, 29 Jan 2024 17:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548159;
	bh=h0TXZGT++1VJ6unMYuCME4Yru9drFqJoVje+tYYF9BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zNslL1EAhN8IW+duM6XD9/P0BJVcq4gpN4YrnsP0E1c2Q2HZyd4JfU8iquEkAayFL
	 myJM18W9zLu7mYtn3i+5USPLMxO4p0yXF4gocLFJUMLmX30f/lrQzKwQc+QITmnUZk
	 UyO9fWC7e0/U6nf8kE/xchrFq/Qo6ai6IbgUJQQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Neeraj Upadhyay (AMD)" <neeraj.iitr10@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 198/346] rcu: Defer RCU kthreads wakeup when CPU is dying
Date: Mon, 29 Jan 2024 09:03:49 -0800
Message-ID: <20240129170022.225858624@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit e787644caf7628ad3269c1fbd321c3255cf51710 ]

When the CPU goes idle for the last time during the CPU down hotplug
process, RCU reports a final quiescent state for the current CPU. If
this quiescent state propagates up to the top, some tasks may then be
woken up to complete the grace period: the main grace period kthread
and/or the expedited main workqueue (or kworker).

If those kthreads have a SCHED_FIFO policy, the wake up can indirectly
arm the RT bandwith timer to the local offline CPU. Since this happens
after hrtimers have been migrated at CPUHP_AP_HRTIMERS_DYING stage, the
timer gets ignored. Therefore if the RCU kthreads are waiting for RT
bandwidth to be available, they may never be actually scheduled.

This triggers TREE03 rcutorture hangs:

	 rcu: INFO: rcu_preempt self-detected stall on CPU
	 rcu:     4-...!: (1 GPs behind) idle=9874/1/0x4000000000000000 softirq=0/0 fqs=20 rcuc=21071 jiffies(starved)
	 rcu:     (t=21035 jiffies g=938281 q=40787 ncpus=6)
	 rcu: rcu_preempt kthread starved for 20964 jiffies! g938281 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
	 rcu:     Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
	 rcu: RCU grace-period kthread stack dump:
	 task:rcu_preempt     state:R  running task     stack:14896 pid:14    tgid:14    ppid:2      flags:0x00004000
	 Call Trace:
	  <TASK>
	  __schedule+0x2eb/0xa80
	  schedule+0x1f/0x90
	  schedule_timeout+0x163/0x270
	  ? __pfx_process_timeout+0x10/0x10
	  rcu_gp_fqs_loop+0x37c/0x5b0
	  ? __pfx_rcu_gp_kthread+0x10/0x10
	  rcu_gp_kthread+0x17c/0x200
	  kthread+0xde/0x110
	  ? __pfx_kthread+0x10/0x10
	  ret_from_fork+0x2b/0x40
	  ? __pfx_kthread+0x10/0x10
	  ret_from_fork_asm+0x1b/0x30
	  </TASK>

The situation can't be solved with just unpinning the timer. The hrtimer
infrastructure and the nohz heuristics involved in finding the best
remote target for an unpinned timer would then also need to handle
enqueues from an offline CPU in the most horrendous way.

So fix this on the RCU side instead and defer the wake up to an online
CPU if it's too late for the local one.

Reported-by: Paul E. McKenney <paulmck@kernel.org>
Fixes: 5c0930ccaad5 ("hrtimers: Push pending hrtimers away from outgoing CPU earlier")
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Neeraj Upadhyay (AMD) <neeraj.iitr10@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.c     | 34 +++++++++++++++++++++++++++++++++-
 kernel/rcu/tree_exp.h |  3 +--
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 3ac3c846105f..157f3ca2a9b5 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1013,6 +1013,38 @@ static bool rcu_future_gp_cleanup(struct rcu_node *rnp)
 	return needmore;
 }
 
+static void swake_up_one_online_ipi(void *arg)
+{
+	struct swait_queue_head *wqh = arg;
+
+	swake_up_one(wqh);
+}
+
+static void swake_up_one_online(struct swait_queue_head *wqh)
+{
+	int cpu = get_cpu();
+
+	/*
+	 * If called from rcutree_report_cpu_starting(), wake up
+	 * is dangerous that late in the CPU-down hotplug process. The
+	 * scheduler might queue an ignored hrtimer. Defer the wake up
+	 * to an online CPU instead.
+	 */
+	if (unlikely(cpu_is_offline(cpu))) {
+		int target;
+
+		target = cpumask_any_and(housekeeping_cpumask(HK_TYPE_RCU),
+					 cpu_online_mask);
+
+		smp_call_function_single(target, swake_up_one_online_ipi,
+					 wqh, 0);
+		put_cpu();
+	} else {
+		put_cpu();
+		swake_up_one(wqh);
+	}
+}
+
 /*
  * Awaken the grace-period kthread.  Don't do a self-awaken (unless in an
  * interrupt or softirq handler, in which case we just might immediately
@@ -1037,7 +1069,7 @@ static void rcu_gp_kthread_wake(void)
 		return;
 	WRITE_ONCE(rcu_state.gp_wake_time, jiffies);
 	WRITE_ONCE(rcu_state.gp_wake_seq, READ_ONCE(rcu_state.gp_seq));
-	swake_up_one(&rcu_state.gp_wq);
+	swake_up_one_online(&rcu_state.gp_wq);
 }
 
 /*
diff --git a/kernel/rcu/tree_exp.h b/kernel/rcu/tree_exp.h
index 6d7cea5d591f..2ac440bc7e10 100644
--- a/kernel/rcu/tree_exp.h
+++ b/kernel/rcu/tree_exp.h
@@ -173,7 +173,6 @@ static bool sync_rcu_exp_done_unlocked(struct rcu_node *rnp)
 	return ret;
 }
 
-
 /*
  * Report the exit from RCU read-side critical section for the last task
  * that queued itself during or before the current expedited preemptible-RCU
@@ -201,7 +200,7 @@ static void __rcu_report_exp_rnp(struct rcu_node *rnp,
 			raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
 			if (wake) {
 				smp_mb(); /* EGP done before wake_up(). */
-				swake_up_one(&rcu_state.expedited_wq);
+				swake_up_one_online(&rcu_state.expedited_wq);
 			}
 			break;
 		}
-- 
2.43.0



