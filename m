Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2A21A9B46;
	Thu, 28 May 2026 20:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001549; cv=none; b=flHyOqCQBkShEXV4fg/1cfKiU5slpPuRX/EjJ6zzIbNCB4hZAAFKmBkS7iT39K9FTQTFZBxIPVAiR2Q6HvqwkQqmmShWaiREUhOslKVuQ9RPiXGID89wYiJIwt7uksGMFZ5a8haMgZccvwaQN4V6eXR3qy6tGFhW7/aYwR2yN54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001549; c=relaxed/simple;
	bh=Chot+yQ91bWcrHWRdO7NKYZp3/QXTDmd575pKkkSVm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fx1HKRiCPdQCQ6wQpVyIVHrnII4ZfuT0kGJWWx9AP3Sf3jq0bnB32n0KyvcDcpOz+qzNhmzO2u3vENNd5j2afef24iKd6gdKpyXDOFphHxcq2aX38Zw68Qhz1CndIIx6p9k/1MDof/EsNdt+JjOrsWnx4mGIuUM6H7UdcannhpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PZfMjsB9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZfMjsB9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169E61F000E9;
	Thu, 28 May 2026 20:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001548;
	bh=D9RQiyiXVdhGpF0gzSyAOT04aSujfOreFnX6Y90a0PI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PZfMjsB9VpZaaBdSM0wHvFJSuIceC+l07js9NrqEWlETJH+euct42e5cYBgsEuk6s
	 f5yc3mRxQCw1myyudRNhoDnPEh6WlnXRkZ8gN8Y8o6LPQJ+bVXdkC0IEpKKnh0buJ1
	 2YvhAPacxmLJ/X0h9wS2zFHDbk7Mmhe1VxWVpcGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 167/186] ptrace: Convert ptrace_attach() to use lock guards
Date: Thu, 28 May 2026 21:50:47 +0200
Message-ID: <20260528194933.473272852@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 5431fdd2c181dd2eac218e45b44deb2925fa48f0 ]

Created as testing for the conditional guard infrastructure.
Specifically this makes use of the following form:

  scoped_cond_guard (mutex_intr, return -ERESTARTNOINTR,
		     &task->signal->cred_guard_mutex) {
    ...
  }
  ...
  return 0;

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Link: https://lkml.kernel.org/r/20231102110706.568467727%40infradead.org
Stable-dep-of: 60a1969fae62 ("ALSA: seq: Serialize UMP output teardown with event_input")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/task.h |   2 +
 include/linux/spinlock.h   |  26 ++++++++
 kernel/ptrace.c            | 128 ++++++++++++++++++-------------------
 3 files changed, 89 insertions(+), 67 deletions(-)

diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index 8dbecab4c4000..fc19837c8083e 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -227,4 +227,6 @@ static inline void task_unlock(struct task_struct *p)
 	spin_unlock(&p->alloc_lock);
 }
 
+DEFINE_GUARD(task_lock, struct task_struct *, task_lock(_T), task_unlock(_T))
+
 #endif /* _LINUX_SCHED_TASK_H */
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index ceb56b39c70f7..90bc853cafb6a 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -548,5 +548,31 @@ DEFINE_LOCK_GUARD_1(spinlock_irqsave, spinlock_t,
 DEFINE_LOCK_GUARD_1_COND(spinlock_irqsave, _try,
 			 spin_trylock_irqsave(_T->lock, _T->flags))
 
+DEFINE_LOCK_GUARD_1(read_lock, rwlock_t,
+		    read_lock(_T->lock),
+		    read_unlock(_T->lock))
+
+DEFINE_LOCK_GUARD_1(read_lock_irq, rwlock_t,
+		    read_lock_irq(_T->lock),
+		    read_unlock_irq(_T->lock))
+
+DEFINE_LOCK_GUARD_1(read_lock_irqsave, rwlock_t,
+		    read_lock_irqsave(_T->lock, _T->flags),
+		    read_unlock_irqrestore(_T->lock, _T->flags),
+		    unsigned long flags)
+
+DEFINE_LOCK_GUARD_1(write_lock, rwlock_t,
+		    write_lock(_T->lock),
+		    write_unlock(_T->lock))
+
+DEFINE_LOCK_GUARD_1(write_lock_irq, rwlock_t,
+		    write_lock_irq(_T->lock),
+		    write_unlock_irq(_T->lock))
+
+DEFINE_LOCK_GUARD_1(write_lock_irqsave, rwlock_t,
+		    write_lock_irqsave(_T->lock, _T->flags),
+		    write_unlock_irqrestore(_T->lock, _T->flags),
+		    unsigned long flags)
+
 #undef __LINUX_INSIDE_SPINLOCK_H
 #endif /* __LINUX_SPINLOCK_H */
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 3c7d122a37fb4..6196a495d9c0c 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -396,6 +396,34 @@ static int check_ptrace_options(unsigned long data)
 	return 0;
 }
 
+static inline void ptrace_set_stopped(struct task_struct *task)
+{
+	guard(spinlock)(&task->sighand->siglock);
+
+	/*
+	 * If the task is already STOPPED, set JOBCTL_TRAP_STOP and
+	 * TRAPPING, and kick it so that it transits to TRACED.  TRAPPING
+	 * will be cleared if the child completes the transition or any
+	 * event which clears the group stop states happens.  We'll wait
+	 * for the transition to complete before returning from this
+	 * function.
+	 *
+	 * This hides STOPPED -> RUNNING -> TRACED transition from the
+	 * attaching thread but a different thread in the same group can
+	 * still observe the transient RUNNING state.  IOW, if another
+	 * thread's WNOHANG wait(2) on the stopped tracee races against
+	 * ATTACH, the wait(2) may fail due to the transient RUNNING.
+	 *
+	 * The following task_is_stopped() test is safe as both transitions
+	 * in and out of STOPPED are protected by siglock.
+	 */
+	if (task_is_stopped(task) &&
+	    task_set_jobctl_pending(task, JOBCTL_TRAP_STOP | JOBCTL_TRAPPING)) {
+		task->jobctl &= ~JOBCTL_STOPPED;
+		signal_wake_up_state(task, __TASK_STOPPED);
+	}
+}
+
 static int ptrace_attach(struct task_struct *task, long request,
 			 unsigned long addr,
 			 unsigned long flags)
@@ -403,17 +431,17 @@ static int ptrace_attach(struct task_struct *task, long request,
 	bool seize = (request == PTRACE_SEIZE);
 	int retval;
 
-	retval = -EIO;
 	if (seize) {
 		if (addr != 0)
-			goto out;
+			return -EIO;
 		/*
 		 * This duplicates the check in check_ptrace_options() because
 		 * ptrace_attach() and ptrace_setoptions() have historically
 		 * used different error codes for unknown ptrace options.
 		 */
 		if (flags & ~(unsigned long)PTRACE_O_MASK)
-			goto out;
+			return -EIO;
+
 		retval = check_ptrace_options(flags);
 		if (retval)
 			return retval;
@@ -424,88 +452,54 @@ static int ptrace_attach(struct task_struct *task, long request,
 
 	audit_ptrace(task);
 
-	retval = -EPERM;
 	if (unlikely(task->flags & PF_KTHREAD))
-		goto out;
+		return -EPERM;
 	if (same_thread_group(task, current))
-		goto out;
+		return -EPERM;
 
 	/*
 	 * Protect exec's credential calculations against our interference;
 	 * SUID, SGID and LSM creds get determined differently
 	 * under ptrace.
 	 */
-	retval = -ERESTARTNOINTR;
-	if (mutex_lock_interruptible(&task->signal->cred_guard_mutex))
-		goto out;
+	scoped_cond_guard (mutex_intr, return -ERESTARTNOINTR,
+			   &task->signal->cred_guard_mutex) {
 
-	task_lock(task);
-	retval = __ptrace_may_access(task, PTRACE_MODE_ATTACH_REALCREDS);
-	task_unlock(task);
-	if (retval)
-		goto unlock_creds;
+		scoped_guard (task_lock, task) {
+			retval = __ptrace_may_access(task, PTRACE_MODE_ATTACH_REALCREDS);
+			if (retval)
+				return retval;
+		}
 
-	write_lock_irq(&tasklist_lock);
-	retval = -EPERM;
-	if (unlikely(task->exit_state))
-		goto unlock_tasklist;
-	if (task->ptrace)
-		goto unlock_tasklist;
+		scoped_guard (write_lock_irq, &tasklist_lock) {
+			if (unlikely(task->exit_state))
+				return -EPERM;
+			if (task->ptrace)
+				return -EPERM;
 
-	task->ptrace = flags;
+			task->ptrace = flags;
 
-	ptrace_link(task, current);
+			ptrace_link(task, current);
 
-	/* SEIZE doesn't trap tracee on attach */
-	if (!seize)
-		send_sig_info(SIGSTOP, SEND_SIG_PRIV, task);
+			/* SEIZE doesn't trap tracee on attach */
+			if (!seize)
+				send_sig_info(SIGSTOP, SEND_SIG_PRIV, task);
 
-	spin_lock(&task->sighand->siglock);
+			ptrace_set_stopped(task);
+		}
+	}
 
 	/*
-	 * If the task is already STOPPED, set JOBCTL_TRAP_STOP and
-	 * TRAPPING, and kick it so that it transits to TRACED.  TRAPPING
-	 * will be cleared if the child completes the transition or any
-	 * event which clears the group stop states happens.  We'll wait
-	 * for the transition to complete before returning from this
-	 * function.
-	 *
-	 * This hides STOPPED -> RUNNING -> TRACED transition from the
-	 * attaching thread but a different thread in the same group can
-	 * still observe the transient RUNNING state.  IOW, if another
-	 * thread's WNOHANG wait(2) on the stopped tracee races against
-	 * ATTACH, the wait(2) may fail due to the transient RUNNING.
-	 *
-	 * The following task_is_stopped() test is safe as both transitions
-	 * in and out of STOPPED are protected by siglock.
+	 * We do not bother to change retval or clear JOBCTL_TRAPPING
+	 * if wait_on_bit() was interrupted by SIGKILL. The tracer will
+	 * not return to user-mode, it will exit and clear this bit in
+	 * __ptrace_unlink() if it wasn't already cleared by the tracee;
+	 * and until then nobody can ptrace this task.
 	 */
-	if (task_is_stopped(task) &&
-	    task_set_jobctl_pending(task, JOBCTL_TRAP_STOP | JOBCTL_TRAPPING)) {
-		task->jobctl &= ~JOBCTL_STOPPED;
-		signal_wake_up_state(task, __TASK_STOPPED);
-	}
-
-	spin_unlock(&task->sighand->siglock);
-
-	retval = 0;
-unlock_tasklist:
-	write_unlock_irq(&tasklist_lock);
-unlock_creds:
-	mutex_unlock(&task->signal->cred_guard_mutex);
-out:
-	if (!retval) {
-		/*
-		 * We do not bother to change retval or clear JOBCTL_TRAPPING
-		 * if wait_on_bit() was interrupted by SIGKILL. The tracer will
-		 * not return to user-mode, it will exit and clear this bit in
-		 * __ptrace_unlink() if it wasn't already cleared by the tracee;
-		 * and until then nobody can ptrace this task.
-		 */
-		wait_on_bit(&task->jobctl, JOBCTL_TRAPPING_BIT, TASK_KILLABLE);
-		proc_ptrace_connector(task, PTRACE_ATTACH);
-	}
+	wait_on_bit(&task->jobctl, JOBCTL_TRAPPING_BIT, TASK_KILLABLE);
+	proc_ptrace_connector(task, PTRACE_ATTACH);
 
-	return retval;
+	return 0;
 }
 
 /**
-- 
2.53.0



