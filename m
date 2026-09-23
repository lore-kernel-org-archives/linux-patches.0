Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31888417BF9;
	Wed, 23 Sep 2026 14:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175236; cv=none; b=bOny+pKW0Wgc08vNMoaF24FpGu0rCq6DV0l6rxD/tw03BF7ms/I9AbNjizfhv5AG2r8AEWzWwOWo0o5yCfuZiUgEgvlyajEzjVhg1L7ShoHAdI0Hzb+FwJD6FYbqHzPts1f/xElDsFxIlw/z2GfSF9qWJY5+QQyLNp7B0z2oS6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175236; c=relaxed/simple;
	bh=ZT6XYtNgiCzJiv6p0lVG8OQBm6s2hd5+DxOlN8fn1d0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AliTObzqLC3t+MzHsapSsl6vBmPZFY5mxG9bJcwriwP+L+cky+dIbE7Um+9qccwK+hwmCfOXb+s3P3UyHvbK8fExiIt1bXbR9ccquxWpypAogivm9dqgYosZ1G3x4hYzhaku4imiO6ZgkOj+gpy85XmwNw0AQFVZYdklWn7DwNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MEOY6orZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MEOY6orZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4DF1F00893;
	Wed, 23 Sep 2026 14:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175235;
	bh=EiTMdQTwOZkgF7FayjcFczMgPIbunAuKutpZyk7Igcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MEOY6orZ6PYI0q10maMEF6446oOJ6/Chfy6hDOd/hV5Z9nD5nIbgidpeJbs50VTG7
	 eJUfI/sTIL0etozkuyVXTpIu0fNk50nh+M2XtwMfrxaDZyeWOzw/Z07O1RRKNhDYJu
	 ApxzuMxyP1blp+KFBNQMptRUv7ZAh4dNhbcKrbow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Kijo Park <red993688@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 364/398] signal: Prevent exec() race
Date: Wed, 23 Sep 2026 16:07:18 +0200
Message-ID: <20260923140652.867674106@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@kernel.org>

[ Upstream commit d2710c8d938ae6a825a6463158e6e6f31eac792a ]

Hyunwoo debugged the following KASAN UAF splat:

  BUG: KASAN: slab-use-after-free in __send_signal_locked+0xb27/0xba0
  Write of size 8 at addr ffff888007ed80c8 by task poc/79
  ...
  Call Trace:
   __send_signal_locked+0xb27/0xba0
   do_send_sig_info+0xa7/0x160
   do_send_specific+0x76/0xa0
   __x64_sys_tgkill+0x193/0x270
  ...
  Allocated by task 80:
   do_timer_create+0x1a4/0x1030
   __x64_sys_timer_create+0x145/0x190
  ...
  Freed by task 12:
   kmem_cache_free_bulk+0x1f8/0x4a0
   kvfree_rcu_bulk+0x14f/0x1c0
   kfree_rcu_work+0x128/0x1a0
  ...
  Last potentially related work creation:
   kvfree_call_rcu+0x39/0x390
   __flush_itimer_signals+0x211/0x320
   flush_itimer_signals+0x47/0x90
   begin_new_exec+0xa6b/0x28c0

It turned out that this happens with a non-leader exec() as Hyunwoo
explained:

de_thread() calls exchange_tids() before release_task(leader), so the
struct pid held by a SIGEV_THREAD_ID timer created against the leader's tid
now points to the thread which called execve(). pid_task() returns that
thread and lock_task_sighand() on it succeeds.

If the timer signal is blocked, its sigqueue stays queued on the leader's
task::pending. The next expiry of that timer can then run while
release_task() flushes the queue.

posixtimer_send_sigqueue() checks whether the sigqueue is already queued
with a plain list_empty(), which only reads list_head::next.
list_del_init() is not atomic and INIT_LIST_HEAD() stores list_head::next
before list_head::prev, so the check can pass in between. list_add_tail()
queues the entry on the task::pending of the live thread, and the
list_head::prev store from the flush then overwrites the list_head::prev
link that list_add_tail() has just set.

__flush_itimer_signals() does not undo that either. With list_head::prev
pointing at the entry itself, its list_del_init() only stores the same
values again, so the entry is not removed from the list. It is still there
after the last reference is dropped and the timer is freed by RCU, and the
list_add_tail() of a later tgkill() follows that list_head::prev into the
freed timer.

This problem surfaced with the recent commit which moved the sigqueue flush
out of the sighand lock held region.

Hyonwoo proposed to fix this by using list_del_init_careful(), but that
just papers over the problem. After some disucssions and various attempts
to solve it, Eric pointed out that there is no reason to flush
task::pending late in release_task() and it should be done in
exit_signals() already.

As nothing can collect and deliver signals which are queued in a dying
task's pending queue, there is no reason to delay it further.

But it has to be ensured that no signals can be queued into it after that
point. exit_signals() sets PF_EXITING in task::flags, which can be used as
an indicator for this.

Cure it by:

  - Preventing signal queueing for task private signals (PIDTYPE_PID) when
    the task has PF_EXITING set in __send_signal_locked() and in
    posixtimer_send_sigqueue().

  - Protecting the unlocked setting of PF_EXITING in exit_signals() for the
    task group empty and the group exit case with sighand lock

  - Flushing task::pending signals right there.

    Optimize that by moving the whole pending list to an on-stack list head
    under sighand lock and free the signals without the lock held.

There has been quite some discussion about the lockless flush and the
non-leader exec case on weakly ordered systems. The problem is that a third
party which tries to send a posix timer signal relies on the PID lookup to
find the target task and that lookup might result in the new leader when
the signal was originaly directed to the old leader. In case that the
signal was queued on the old leader then the lockless flush raised a
concern over the following situation:

   old_leader		new_leader              third party

A: flush_list()	// list_del_init() stores to sigqueue

   LOCK (tasklist)
   old_leader->exit_state = EXIT_ZOMBIE;
B: UNLOCK (tasklist)

C:			LOCK (tasklist)
			if (old_leader->exit_state)
			   transfer_tids()
D:			     store PID
						posix_timer_send_sigqueue()
						// Observes #D so t = new_leader
E:						t = get_target()

F:						LOCK (sighand)

G:						   if (list_empty(sigqueue))
							list_add(sigqueue)

The concern was that the third party might observe #D but not observe #A
and therefore would proceed to #G while the list_del() stores (#A) in
flush_list() are not visible yet, which could result in list corruption.

That would be possible if looking at it solely from a RELEASE+ACQUIRE
ordering point of view, but B-C is a UNLOCK+LOCK hand-over, which is not
the same as RELEASE+ACQUIRE:

  RELEASE+ACQUIRE: RCpc,  only the CPUs involved agree on the ordering
  UNLOCK+LOCK:     RCtso, the hand-over is store-ordering

As B-C is UNLOCK+LOCK, which is RCtso and that does impose store order,
A stores must happen before the D store.

Combine with E-F, which has a data dependency from the LOAD to the LOCK and
thereby constraints later LOADs, those sigqueue loads in G that come after
F must in fact observe the A stores.

Fixes: fb3bbcfe344e ("exit: change the release_task() paths to call flush_sigqueue() lockless")
Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Debugged-by: Hyunwoo Kim <imv4bel@gmail.com>
Suggested-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Tested-by: Kijo Park <red993688@gmail.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260911090541.572536604@kernel.org
Closes: https://patch.msgid.link/aok1rdkBgZsynHZB@v4bel
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/exit.c   |   11 ++---
 kernel/signal.c |  117 +++++++++++++++++++++++++++++++++++++++++---------------
 2 files changed, 92 insertions(+), 36 deletions(-)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -304,12 +304,13 @@ repeat:
 	free_pids(post.pids);
 	release_thread(p);
 	/*
-	 * This task was already removed from the process/thread/pid lists
-	 * and lock_task_sighand(p) can't succeed. Nobody else can touch
-	 * ->pending or, if group dead, signal->shared_pending. We can call
-	 * flush_sigqueue() lockless.
+	 * This task was already removed from the process/thread/pid lists and
+	 * lock_task_sighand(p) can't succeed. If it's the group leader then
+	 * flush tsk->signal->shared_pending. tsk->pending has been flushed
+	 * already in exit_signals(). Nothing else can touch
+	 * signal->shared_pending anymore, so flush_sigqueue() can be invoked
+	 * lockless.
 	 */
-	flush_sigqueue(&p->pending);
 	if (thread_group_leader(p))
 		flush_sigqueue(&p->signal->shared_pending);
 
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -475,18 +475,42 @@ static void __sigqueue_free(struct sigqu
 	kmem_cache_free(sigqueue_cachep, q);
 }
 
-void flush_sigqueue(struct sigpending *queue)
+/*
+ * flush_sigqueue_list() can only be invoked without holding sighand::siglock in
+ * the following cases:
+ *
+ *  1) When flushing task::pending _after_ setting task::flags PF_EXITING
+ *
+ *     All functions which try to send a signal to @task will observe PF_EXITING
+ *     and drop the signal.
+ *
+ *  2) When flushing task::signal::shared_pending _after_ the last task in a
+ *     thread group was unhashed and task::sighand is NULL.
+ *
+ *     Nothing can queue a signal anymore because sighand is NULL.
+ */
+static void flush_sigqueue_list(struct list_head *head)
 {
-	struct sigqueue *q;
+	struct sigqueue *q, *tmp;
 
-	sigemptyset(&queue->signal);
-	while (!list_empty(&queue->list)) {
-		q = list_entry(queue->list.next, struct sigqueue , list);
+	list_for_each_entry_safe(q, tmp, head, list) {
 		list_del_init(&q->list);
 		__sigqueue_free(q);
 	}
 }
 
+void flush_sigqueue(struct sigpending *queue)
+{
+	sigemptyset(&queue->signal);
+	flush_sigqueue_list(&queue->list);
+}
+
+static void sigqueue_dequeue_pending(struct sigpending *queue, struct list_head *head)
+{
+	sigemptyset(&queue->signal);
+	list_splice_init(&queue->list, head);
+}
+
 /*
  * Flush all pending signals for this kthread.
  */
@@ -1039,6 +1063,21 @@ static inline bool legacy_queue(struct s
 	return (sig < SIGRTMIN) && sigismember(&signals->signal, sig);
 }
 
+/*
+ * When PF_EXITING is set the task is on the way out and has t::pending
+ * flushed already. Prevent queueing of PIDTYPE_PID signals as they would
+ * be leaked.
+ */
+static inline bool task_can_queue_signal(struct task_struct *t, enum pid_type type)
+{
+	lockdep_assert_held(&t->sighand->siglock);
+
+	if (!(t->flags & PF_EXITING))
+		return true;
+
+	return type != PIDTYPE_PID;
+}
+
 static int __send_signal_locked(int sig, struct kernel_siginfo *info,
 				struct task_struct *t, enum pid_type type, bool force)
 {
@@ -1050,6 +1089,10 @@ static int __send_signal_locked(int sig,
 	lockdep_assert_held(&t->sighand->siglock);
 
 	result = TRACE_SIGNAL_IGNORED;
+
+	if (!task_can_queue_signal(t, type))
+		goto ret;
+
 	if (!prepare_signal(sig, t, force))
 		goto ret;
 
@@ -1993,11 +2036,25 @@ static inline struct task_struct *posixt
 	struct task_struct *t = pid_task(tmr->it_pid, tmr->it_pid_type);
 
 	if (t && tmr->it_pid_type != PIDTYPE_PID &&
-	    same_thread_group(t, current) && !current->exit_state)
+	    same_thread_group(t, current) && !(current->flags & PF_EXITING))
 		t = current;
 	return t;
 }
 
+/*
+ * Find the target task for the POSIX timer signal and prevent that a
+ * PIDTYPE_PID signal is queued on a task which has PF_EXITING set.
+ */
+static inline struct task_struct *posixtimer_get_unignore_target(struct k_itimer *tmr)
+{
+	struct task_struct *t = posixtimer_get_target(tmr);
+
+	if (t && task_can_queue_signal(t, tmr->it_pid_type))
+		return t;
+
+	return NULL;
+}
+
 void posixtimer_send_sigqueue(struct k_itimer *tmr)
 {
 	struct sigqueue *q = &tmr->sigq;
@@ -2015,6 +2072,9 @@ void posixtimer_send_sigqueue(struct k_i
 	if (!likely(lock_task_sighand(t, &flags)))
 		return;
 
+	if (!task_can_queue_signal(t, tmr->it_pid_type))
+		goto unlock;
+
 	/*
 	 * Update @tmr::sigqueue_seq for posix timer signals with sighand
 	 * locked to prevent a race against dequeue_signal().
@@ -2106,6 +2166,7 @@ void posixtimer_send_sigqueue(struct k_i
 	result = TRACE_SIGNAL_DELIVERED;
 out:
 	trace_signal_generate(sig, &q->info, t, tmr->it_pid_type != PIDTYPE_PID, result);
+unlock:
 	unlock_task_sighand(t, &flags);
 }
 
@@ -2161,7 +2222,7 @@ static void posixtimer_sig_unignore(stru
 		 * has exited by now, drop the reference count.
 		 */
 		guard(rcu)();
-		target = posixtimer_get_target(tmr);
+		target = posixtimer_get_unignore_target(tmr);
 		if (target)
 			posixtimer_queue_sigqueue(&tmr->sigq, target, tmr->it_pid_type);
 		else
@@ -3140,42 +3201,36 @@ static void retarget_shared_pending(stru
 
 void exit_signals(struct task_struct *tsk)
 {
+	LIST_HEAD(sigq_list);
 	int group_stop = 0;
-	sigset_t unblocked;
 
 	/*
 	 * @tsk is about to have PF_EXITING set - lock out users which
-	 * expect stable threadgroup.
+	 * expect a stable threadgroup.
 	 */
 	cgroup_threadgroup_change_begin(tsk);
 
-	if (thread_group_empty(tsk) || (tsk->signal->flags & SIGNAL_GROUP_EXIT)) {
+	scoped_guard(spinlock_irq, &tsk->sighand->siglock) {
 		tsk->flags |= PF_EXITING;
-		cgroup_threadgroup_change_end(tsk);
-		return;
-	}
 
-	spin_lock_irq(&tsk->sighand->siglock);
-	/*
-	 * From now this task is not visible for group-wide signals,
-	 * see wants_signal(), do_signal_stop().
-	 */
-	tsk->flags |= PF_EXITING;
+		sigqueue_dequeue_pending(&tsk->pending, &sigq_list);
 
-	cgroup_threadgroup_change_end(tsk);
+		if (task_sigpending(tsk) && !thread_group_empty(tsk) &&
+		    !(tsk->signal->flags & SIGNAL_GROUP_EXIT)) {
+			sigset_t unblocked = tsk->blocked;
+
+			signotset(&unblocked);
+			retarget_shared_pending(tsk, &unblocked);
+
+			if (unlikely(tsk->jobctl & JOBCTL_STOP_PENDING) &&
+			    task_participate_group_stop(tsk))
+				group_stop = CLD_STOPPED;
+		}
+	}
 
-	if (!task_sigpending(tsk))
-		goto out;
+	cgroup_threadgroup_change_end(tsk);
 
-	unblocked = tsk->blocked;
-	signotset(&unblocked);
-	retarget_shared_pending(tsk, &unblocked);
-
-	if (unlikely(tsk->jobctl & JOBCTL_STOP_PENDING) &&
-	    task_participate_group_stop(tsk))
-		group_stop = CLD_STOPPED;
-out:
-	spin_unlock_irq(&tsk->sighand->siglock);
+	flush_sigqueue_list(&sigq_list);
 
 	/*
 	 * If group stop has completed, deliver the notification.  This


