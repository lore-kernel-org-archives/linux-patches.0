Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9009EBA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17BD0C433EF;
	Tue,  7 Mar 2023 18:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213575;
	bh=21sn+9+rxw5uP6I6JBvjNsWFCeRI11pHBZQi2jQazpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hUZmBT3Ejg9wAgVvMO5No33eDE0eYPpeSpbCSQ+M7bTl7ZWkE4TB35eD5uFwgSMbn
	 HAkwE/XFphojk7dbeMR7DKXovDk3rBYfDMk8Jt6eawDL5OI4HYzRSTcpFHSS0qxmvN
	 8GkzWKiyqIsWsZWbvZ1iW5W5uP9Azt2zIPjpgGZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang1.zhang@intel.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 551/885] rcu-tasks: Make rude RCU-Tasks work well with CPU hotplug
Date: Tue,  7 Mar 2023 17:58:05 +0100
Message-Id: <20230307170026.421346838@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zqiang <qiang1.zhang@intel.com>

[ Upstream commit ea5c8987fef20a8cca07e428aa28bc64649c5104 ]

The synchronize_rcu_tasks_rude() function invokes rcu_tasks_rude_wait_gp()
to wait one rude RCU-tasks grace period.  The rcu_tasks_rude_wait_gp()
function in turn checks if there is only a single online CPU.  If so, it
will immediately return, because a call to synchronize_rcu_tasks_rude()
is by definition a grace period on a single-CPU system.  (We could
have blocked!)

Unfortunately, this check uses num_online_cpus() without synchronization,
which can result in too-short grace periods.  To see this, consider the
following scenario:

        CPU0                                   CPU1 (going offline)
                                          migration/1 task:
                                      cpu_stopper_thread
                                       -> take_cpu_down
                                          -> _cpu_disable
                                           (dec __num_online_cpus)
                                          ->cpuhp_invoke_callback
                                                preempt_disable
                                                access old_data0
           task1
 del old_data0                                  .....
 synchronize_rcu_tasks_rude()
 task1 schedule out
 ....
 task2 schedule in
 rcu_tasks_rude_wait_gp()
     ->__num_online_cpus == 1
       ->return
 ....
 task1 schedule in
 ->free old_data0
                                                preempt_enable

When CPU1 decrements __num_online_cpus, its value becomes 1.  However,
CPU1 has not finished going offline, and will take one last trip through
the scheduler and the idle loop before it actually stops executing
instructions.  Because synchronize_rcu_tasks_rude() is mostly used for
tracing, and because both the scheduler and the idle loop can be traced,
this means that CPU0's prematurely ended grace period might disrupt the
tracing on CPU1.  Given that this disruption might include CPU1 executing
instructions in memory that was just now freed (and maybe reallocated),
this is a matter of some concern.

This commit therefore removes that problematic single-CPU check from the
rcu_tasks_rude_wait_gp() function.  This dispenses with the single-CPU
optimization, but there is no evidence indicating that this optimization
is important.  In addition, synchronize_rcu_tasks_generic() contains a
similar optimization (albeit only for early boot), which also splats.
(As in exactly why are you invoking synchronize_rcu_tasks_rude() so
early in boot, anyway???)

It is OK for the synchronize_rcu_tasks_rude() function's check to be
unsynchronized because the only times that this check can evaluate to
true is when there is only a single CPU running with preemption
disabled.

While in the area, this commit also fixes a minor bug in which a
call to synchronize_rcu_tasks_rude() would instead be attributed to
synchronize_rcu_tasks().

[ paulmck: Add "synchronize_" prefix and "()" suffix. ]

Signed-off-by: Zqiang <qiang1.zhang@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tasks.h | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index a701001e8b321..0a8824bbfa372 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -560,8 +560,9 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 static void synchronize_rcu_tasks_generic(struct rcu_tasks *rtp)
 {
 	/* Complain if the scheduler has not started.  */
-	WARN_ONCE(rcu_scheduler_active == RCU_SCHEDULER_INACTIVE,
-			 "synchronize_rcu_tasks called too soon");
+	if (WARN_ONCE(rcu_scheduler_active == RCU_SCHEDULER_INACTIVE,
+			 "synchronize_%s() called too soon", rtp->name))
+		return;
 
 	// If the grace-period kthread is running, use it.
 	if (READ_ONCE(rtp->kthread_ptr)) {
@@ -1064,9 +1065,6 @@ static void rcu_tasks_be_rude(struct work_struct *work)
 // Wait for one rude RCU-tasks grace period.
 static void rcu_tasks_rude_wait_gp(struct rcu_tasks *rtp)
 {
-	if (num_online_cpus() <= 1)
-		return;	// Fastpath for only one CPU.
-
 	rtp->n_ipis += cpumask_weight(cpu_online_mask);
 	schedule_on_each_cpu(rcu_tasks_be_rude);
 }
-- 
2.39.2



