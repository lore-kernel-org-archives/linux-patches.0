Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F6832E738;
	Wed, 17 Sep 2025 12:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113705; cv=none; b=BCbMEKn8NNx/UK+AuVQ1fVR6f+tmjbKQvPSacd3vu4/pF/n7xsHS8mxPftz6GxWAQ5h4huSh6m1HRtc+Ka7D2pVbrrr0KQnkU6pTtikXwE4nKkKiE22IBgNuVWMgPaJRqWb+dAQ4V2ypfEzTHWuTKTl69N382JDgMGxSqPLR9MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113705; c=relaxed/simple;
	bh=ZD6xpIpWA8YozmI8El2czgKHxdTrK1D22dQgufECA5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4OBE528TKbfTnliS2luLeRp/3z8bektJh119UkHsP9jWkrY+npuVtyjiqOBsfZgpgcnHPenxyVtkckLTQDw2IrSG7px7z6PgCRqmSFjV9OmIl2CA5jluEEwWp27uNHcW+WhPtCiHwVC3idt5BfaluUQR7wlmOo6sID7RFoBbGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0duJvGXT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0duJvGXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A385AC4CEF0;
	Wed, 17 Sep 2025 12:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113705;
	bh=ZD6xpIpWA8YozmI8El2czgKHxdTrK1D22dQgufECA5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0duJvGXTYhV+ejNOtG6Pexm79aV59h2jUYL3T89HupQYa8zkSRteWGP9CJyAzipUH
	 m2HbpiqFUd0zQw29iPLJcrVrRn8w42ply5mlbXMnL1cR2VSEw03JwfsGlb1gg7CHfy
	 8huAomSwH28vzLIYNyJydfwwCWXbDxSgHE8Q8EhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Yang Jihong <yangjihong1@huawei.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Tahera Fahimi <taherafahimi@linux.microsoft.com>
Subject: [PATCH 6.6 028/101] rcu-tasks: Eliminate deadlocks involving do_exit() and RCU tasks
Date: Wed, 17 Sep 2025 14:34:11 +0200
Message-ID: <20250917123337.534532339@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

From: Paul E. McKenney <paulmck@kernel.org>

commit 1612160b91272f5b1596f499584d6064bf5be794 upstream.

Holding a mutex across synchronize_rcu_tasks() and acquiring
that same mutex in code called from do_exit() after its call to
exit_tasks_rcu_start() but before its call to exit_tasks_rcu_stop()
results in deadlock.  This is by design, because tasks that are far
enough into do_exit() are no longer present on the tasks list, making
it a bit difficult for RCU Tasks to find them, let alone wait on them
to do a voluntary context switch.  However, such deadlocks are becoming
more frequent.  In addition, lockdep currently does not detect such
deadlocks and they can be difficult to reproduce.

In addition, if a task voluntarily context switches during that time
(for example, if it blocks acquiring a mutex), then this task is in an
RCU Tasks quiescent state.  And with some adjustments, RCU Tasks could
just as well take advantage of that fact.

This commit therefore eliminates these deadlock by replacing the
SRCU-based wait for do_exit() completion with per-CPU lists of tasks
currently exiting.  A given task will be on one of these per-CPU lists for
the same period of time that this task would previously have been in the
previous SRCU read-side critical section.  These lists enable RCU Tasks
to find the tasks that have already been removed from the tasks list,
but that must nevertheless be waited upon.

The RCU Tasks grace period gathers any of these do_exit() tasks that it
must wait on, and adds them to the list of holdouts.  Per-CPU locking
and get_task_struct() are used to synchronize addition to and removal
from these lists.

Link: https://lore.kernel.org/all/20240118021842.290665-1-chenzhongjin@huawei.com/

Reported-by: Chen Zhongjin <chenzhongjin@huawei.com>
Reported-by: Yang Jihong <yangjihong1@huawei.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Tested-by: Yang Jihong <yangjihong1@huawei.com>
Tested-by: Chen Zhongjin <chenzhongjin@huawei.com>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Cc: Tahera Fahimi <taherafahimi@linux.microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/tasks.h |   44 ++++++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 16 deletions(-)

--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -150,8 +150,6 @@ static struct rcu_tasks rt_name =
 }
 
 #ifdef CONFIG_TASKS_RCU
-/* Track exiting tasks in order to allow them to be waited for. */
-DEFINE_STATIC_SRCU(tasks_rcu_exit_srcu);
 
 /* Report delay in synchronize_srcu() completion in rcu_tasks_postscan(). */
 static void tasks_rcu_exit_srcu_stall(struct timer_list *unused);
@@ -879,10 +877,12 @@ static void rcu_tasks_wait_gp(struct rcu
 //	number of voluntary context switches, and add that task to the
 //	holdout list.
 // rcu_tasks_postscan():
-//	Invoke synchronize_srcu() to ensure that all tasks that were
-//	in the process of exiting (and which thus might not know to
-//	synchronize with this RCU Tasks grace period) have completed
-//	exiting.
+//	Gather per-CPU lists of tasks in do_exit() to ensure that all
+//	tasks that were in the process of exiting (and which thus might
+//	not know to synchronize with this RCU Tasks grace period) have
+//	completed exiting.  The synchronize_rcu() in rcu_tasks_postgp()
+//	will take care of any tasks stuck in the non-preemptible region
+//	of do_exit() following its call to exit_tasks_rcu_stop().
 // check_all_holdout_tasks(), repeatedly until holdout list is empty:
 //	Scans the holdout list, attempting to identify a quiescent state
 //	for each task on the list.  If there is a quiescent state, the
@@ -895,8 +895,10 @@ static void rcu_tasks_wait_gp(struct rcu
 //	with interrupts disabled.
 //
 // For each exiting task, the exit_tasks_rcu_start() and
-// exit_tasks_rcu_finish() functions begin and end, respectively, the SRCU
-// read-side critical sections waited for by rcu_tasks_postscan().
+// exit_tasks_rcu_finish() functions add and remove, respectively, the
+// current task to a per-CPU list of tasks that rcu_tasks_postscan() must
+// wait on.  This is necessary because rcu_tasks_postscan() must wait on
+// tasks that have already been removed from the global list of tasks.
 //
 // Pre-grace-period update-side code is ordered before the grace
 // via the raw_spin_lock.*rcu_node().  Pre-grace-period read-side code
@@ -960,9 +962,13 @@ static void rcu_tasks_pertask(struct tas
 	}
 }
 
+void call_rcu_tasks(struct rcu_head *rhp, rcu_callback_t func);
+DEFINE_RCU_TASKS(rcu_tasks, rcu_tasks_wait_gp, call_rcu_tasks, "RCU Tasks");
+
 /* Processing between scanning taskslist and draining the holdout list. */
 static void rcu_tasks_postscan(struct list_head *hop)
 {
+	int cpu;
 	int rtsi = READ_ONCE(rcu_task_stall_info);
 
 	if (!IS_ENABLED(CONFIG_TINY_RCU)) {
@@ -976,9 +982,9 @@ static void rcu_tasks_postscan(struct li
 	 * this, divide the fragile exit path part in two intersecting
 	 * read side critical sections:
 	 *
-	 * 1) An _SRCU_ read side starting before calling exit_notify(),
-	 *    which may remove the task from the tasklist, and ending after
-	 *    the final preempt_disable() call in do_exit().
+	 * 1) A task_struct list addition before calling exit_notify(),
+	 *    which may remove the task from the tasklist, with the
+	 *    removal after the final preempt_disable() call in do_exit().
 	 *
 	 * 2) An _RCU_ read side starting with the final preempt_disable()
 	 *    call in do_exit() and ending with the final call to schedule()
@@ -987,7 +993,17 @@ static void rcu_tasks_postscan(struct li
 	 * This handles the part 1). And postgp will handle part 2) with a
 	 * call to synchronize_rcu().
 	 */
-	synchronize_srcu(&tasks_rcu_exit_srcu);
+
+	for_each_possible_cpu(cpu) {
+		struct rcu_tasks_percpu *rtpcp = per_cpu_ptr(rcu_tasks.rtpcpu, cpu);
+		struct task_struct *t;
+
+		raw_spin_lock_irq_rcu_node(rtpcp);
+		list_for_each_entry(t, &rtpcp->rtp_exit_list, rcu_tasks_exit_list)
+			if (list_empty(&t->rcu_tasks_holdout_list))
+				rcu_tasks_pertask(t, hop);
+		raw_spin_unlock_irq_rcu_node(rtpcp);
+	}
 
 	if (!IS_ENABLED(CONFIG_TINY_RCU))
 		del_timer_sync(&tasks_rcu_exit_srcu_stall_timer);
@@ -1055,7 +1071,6 @@ static void rcu_tasks_postgp(struct rcu_
 	 *
 	 * In addition, this synchronize_rcu() waits for exiting tasks
 	 * to complete their final preempt_disable() region of execution,
-	 * cleaning up after synchronize_srcu(&tasks_rcu_exit_srcu),
 	 * enforcing the whole region before tasklist removal until
 	 * the final schedule() with TASK_DEAD state to be an RCU TASKS
 	 * read side critical section.
@@ -1063,9 +1078,6 @@ static void rcu_tasks_postgp(struct rcu_
 	synchronize_rcu();
 }
 
-void call_rcu_tasks(struct rcu_head *rhp, rcu_callback_t func);
-DEFINE_RCU_TASKS(rcu_tasks, rcu_tasks_wait_gp, call_rcu_tasks, "RCU Tasks");
-
 static void tasks_rcu_exit_srcu_stall(struct timer_list *unused)
 {
 #ifndef CONFIG_TINY_RCU


