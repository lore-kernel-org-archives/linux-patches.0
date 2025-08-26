Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4818635D;
	Tue, 26 Aug 2025 13:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213388; cv=none; b=J3jTFKRHyzmEcKIy0k6SHPqYavOVNkCMI6aHehe4m54+xhEUUChzlIy7VuJNXUxek4phmDE6H0xRa1uKEjAx40lgh8V/aHRepL2z6kF+YwHJix89qA4gjwuyq2EHOi3r8ZG45uvVPEacvPRivKWNdTIE+pSCyJEGVYrVXeGcGkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213388; c=relaxed/simple;
	bh=lOyjNKnxOZqZQe+c6CSNzjXzgGMWWvOgzSU/FtNU31g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=trAW+rNN2xHLi5VIUhbngJEzkDNtChq6hzibqHvLWg1RpxVQD7swuMAdyIkcL6oGsGYkIU84tIvMiv6C/jqSu51ApKkEpthiLbUMpFh/E2SpdeAs9pgjEh78z52B2rdt1jeRk8IwCdldhGOjXKx6oBNh6hj2c3a3lO0Us/r0/+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y74/mWNz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y74/mWNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB4FC4CEF1;
	Tue, 26 Aug 2025 13:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213388;
	bh=lOyjNKnxOZqZQe+c6CSNzjXzgGMWWvOgzSU/FtNU31g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y74/mWNzgbhNkOamNkb2oAWoHtaaHyFbB5jJPIFaGYI4UNepxLEk7JSzszimxmBPa
	 JjbrDAGCB3PnQcAELCa9bFr5IWoERFyWxMEacVdANLuj0vPZNnRIDToXvw7oyUTcQ5
	 u23TGOOcV1cVCurTBsRksSt23nl5k7XmRROJqDLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	"Neeraj Upadhyay (AMD)" <neeraj.upadhyay@kernel.org>
Subject: [PATCH 6.6 328/587] rcu: Fix racy re-initialization of irq_work causing hangs
Date: Tue, 26 Aug 2025 13:07:57 +0200
Message-ID: <20250826111001.259284616@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederic Weisbecker <frederic@kernel.org>

commit 61399e0c5410567ef60cb1cda34cca42903842e3 upstream.

RCU re-initializes the deferred QS irq work everytime before attempting
to queue it. However there are situations where the irq work is
attempted to be queued even though it is already queued. In that case
re-initializing messes-up with the irq work queue that is about to be
handled.

The chances for that to happen are higher when the architecture doesn't
support self-IPIs and irq work are then all lazy, such as with the
following sequence:

1) rcu_read_unlock() is called when IRQs are disabled and there is a
   grace period involving blocked tasks on the node. The irq work
   is then initialized and queued.

2) The related tasks are unblocked and the CPU quiescent state
   is reported. rdp->defer_qs_iw_pending is reset to DEFER_QS_IDLE,
   allowing the irq work to be requeued in the future (note the previous
   one hasn't fired yet).

3) A new grace period starts and the node has blocked tasks.

4) rcu_read_unlock() is called when IRQs are disabled again. The irq work
   is re-initialized (but it's queued! and its node is cleared) and
   requeued. Which means it's requeued to itself.

5) The irq work finally fires with the tick. But since it was requeued
   to itself, it loops and hangs.

Fix this with initializing the irq work only once before the CPU boots.

Fixes: b41642c87716 ("rcu: Fix rcu_read_unlock() deadloop due to IRQ work")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202508071303.c1134cce-lkp@intel.com
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>
Signed-off-by: Neeraj Upadhyay (AMD) <neeraj.upadhyay@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/tree.c        |    2 ++
 kernel/rcu/tree.h        |    1 +
 kernel/rcu/tree_plugin.h |    8 ++++++--
 3 files changed, 9 insertions(+), 2 deletions(-)

--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -4427,6 +4427,8 @@ int rcutree_prepare_cpu(unsigned int cpu
 	rdp->rcu_iw_gp_seq = rdp->gp_seq - 1;
 	trace_rcu_grace_period(rcu_state.name, rdp->gp_seq, TPS("cpuonl"));
 	raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
+
+	rcu_preempt_deferred_qs_init(rdp);
 	rcu_spawn_one_boost_kthread(rnp);
 	rcu_spawn_cpu_nocb_kthread(cpu);
 	WRITE_ONCE(rcu_state.n_online_cpus, rcu_state.n_online_cpus + 1);
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -463,6 +463,7 @@ static int rcu_print_task_exp_stall(stru
 static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp);
 static void rcu_flavor_sched_clock_irq(int user);
 static void dump_blkd_tasks(struct rcu_node *rnp, int ncheck);
+static void rcu_preempt_deferred_qs_init(struct rcu_data *rdp);
 static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags);
 static void rcu_preempt_boost_start_gp(struct rcu_node *rnp);
 static bool rcu_is_callbacks_kthread(struct rcu_data *rdp);
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -687,8 +687,6 @@ static void rcu_read_unlock_special(stru
 			    cpu_online(rdp->cpu)) {
 				// Get scheduler to re-evaluate and call hooks.
 				// If !IRQ_WORK, FQS scan will eventually IPI.
-				rdp->defer_qs_iw =
-					IRQ_WORK_INIT_HARD(rcu_preempt_deferred_qs_handler);
 				rdp->defer_qs_iw_pending = DEFER_QS_PENDING;
 				irq_work_queue_on(&rdp->defer_qs_iw, rdp->cpu);
 			}
@@ -828,6 +826,10 @@ dump_blkd_tasks(struct rcu_node *rnp, in
 	}
 }
 
+static void rcu_preempt_deferred_qs_init(struct rcu_data *rdp)
+{
+	rdp->defer_qs_iw = IRQ_WORK_INIT_HARD(rcu_preempt_deferred_qs_handler);
+}
 #else /* #ifdef CONFIG_PREEMPT_RCU */
 
 /*
@@ -1027,6 +1029,8 @@ dump_blkd_tasks(struct rcu_node *rnp, in
 	WARN_ON_ONCE(!list_empty(&rnp->blkd_tasks));
 }
 
+static void rcu_preempt_deferred_qs_init(struct rcu_data *rdp) { }
+
 #endif /* #else #ifdef CONFIG_PREEMPT_RCU */
 
 /*


