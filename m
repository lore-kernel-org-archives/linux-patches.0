Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4521B1D88D7;
	Tue, 27 May 2025 17:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366562; cv=none; b=QTZRZIYkoW5qnnsd4RRy504fCF4UliX1U9heWzQXnFtzL0v2XCZqSyT4zNNuZh7YGyl7jvCcqwcucRshGeEjEZUZs3jWpF35Sg6FAZcRxeQb43MUrtzFGBFUCa91P305kPQXMZazvtcXFBeS3rtD2D76MQiSJGkWGIZE997juvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366562; c=relaxed/simple;
	bh=cN6KySt55OoLmne0xHNEB01DfRL4DtU3g95yjoxQadY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRy9d/I9Oe6Exo3sHM+n9RO4mfyEVcgvdbClylg0C51+GJoz2QukLnm8nhaGl8495F0caBcHFc7MdwwINnQsnfCKtNvY2Nlo1X5992af6A9aFpJIHehoT0SfcuILv+8X2klQ/dY8KsJctmcqSIx/qMHlPmNkUHaPFdqzPdVebQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ecsacMfg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ecsacMfg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BFEC4CEE9;
	Tue, 27 May 2025 17:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366562;
	bh=cN6KySt55OoLmne0xHNEB01DfRL4DtU3g95yjoxQadY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ecsacMfgEcwDW2jlVLPx9qhySIJw1T9C1PPBrg7mdvoCV+OlSEISGyN9MJ4djwRL0
	 BQKPeBDTXWGrYGtSfYaTv1Oy2iHq6mMO7cmgARxQaqV0XESHduPhxEAqenVGC+PICt
	 BBK0XwZrW/5NNOeeeDZKyf8eB/99tMsicBCFoRrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 108/783] pidfs: improve multi-threaded exec and premature thread-group leader exit polling
Date: Tue, 27 May 2025 18:18:25 +0200
Message-ID: <20250527162517.551678301@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 0fb482728ba1ee2130eaa461bf551f014447997c ]

This is another attempt trying to make pidfd polling for multi-threaded
exec and premature thread-group leader exit consistent.

A quick recap of these two cases:

(1) During a multi-threaded exec by a subthread, i.e., non-thread-group
    leader thread, all other threads in the thread-group including the
    thread-group leader are killed and the struct pid of the
    thread-group leader will be taken over by the subthread that called
    exec. IOW, two tasks change their TIDs.

(2) A premature thread-group leader exit means that the thread-group
    leader exited before all of the other subthreads in the thread-group
    have exited.

Both cases lead to inconsistencies for pidfd polling with PIDFD_THREAD.
Any caller that holds a PIDFD_THREAD pidfd to the current thread-group
leader may or may not see an exit notification on the file descriptor
depending on when poll is performed. If the poll is performed before the
exec of the subthread has concluded an exit notification is generated
for the old thread-group leader. If the poll is performed after the exec
of the subthread has concluded no exit notification is generated for the
old thread-group leader.

The correct behavior would be to simply not generate an exit
notification on the struct pid of a subhthread exec because the struct
pid is taken over by the subthread and thus remains alive.

But this is difficult to handle because a thread-group may exit
prematurely as mentioned in (2). In that case an exit notification is
reliably generated but the subthreads may continue to run for an
indeterminate amount of time and thus also may exec at some point.

So far there was no way to distinguish between (1) and (2) internally.
This tiny series tries to address this problem by discarding
PIDFD_THREAD notification on premature thread-group leader exit.

If that works correctly then no exit notifications are generated for a
PIDFD_THREAD pidfd for a thread-group leader until all subthreads have
been reaped. If a subthread should exec aftewards no exit notification
will be generated until that task exits or it creates subthreads and
repeates the cycle.

Co-Developed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Link: https://lore.kernel.org/r/20250320-work-pidfs-thread_group-v4-1-da678ce805bf@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pidfs.c      |    9 +++++----
 kernel/exit.c   |    6 +++---
 kernel/signal.c |    3 +--
 3 files changed, 9 insertions(+), 9 deletions(-)

--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -188,20 +188,21 @@ static void pidfd_show_fdinfo(struct seq
 static __poll_t pidfd_poll(struct file *file, struct poll_table_struct *pts)
 {
 	struct pid *pid = pidfd_pid(file);
-	bool thread = file->f_flags & PIDFD_THREAD;
 	struct task_struct *task;
 	__poll_t poll_flags = 0;
 
 	poll_wait(file, &pid->wait_pidfd, pts);
 	/*
-	 * Depending on PIDFD_THREAD, inform pollers when the thread
-	 * or the whole thread-group exits.
+	 * Don't wake waiters if the thread-group leader exited
+	 * prematurely. They either get notified when the last subthread
+	 * exits or not at all if one of the remaining subthreads execs
+	 * and assumes the struct pid of the old thread-group leader.
 	 */
 	guard(rcu)();
 	task = pid_task(pid, PIDTYPE_PID);
 	if (!task)
 		poll_flags = EPOLLIN | EPOLLRDNORM | EPOLLHUP;
-	else if (task->exit_state && (thread || thread_group_empty(task)))
+	else if (task->exit_state && !delay_group_leader(task))
 		poll_flags = EPOLLIN | EPOLLRDNORM;
 
 	return poll_flags;
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -741,10 +741,10 @@ static void exit_notify(struct task_stru
 
 	tsk->exit_state = EXIT_ZOMBIE;
 	/*
-	 * sub-thread or delay_group_leader(), wake up the
-	 * PIDFD_THREAD waiters.
+	 * Ignore thread-group leaders that exited before all
+	 * subthreads did.
 	 */
-	if (!thread_group_empty(tsk))
+	if (!delay_group_leader(tsk))
 		do_notify_pidfd(tsk);
 
 	if (unlikely(tsk->ptrace)) {
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2180,8 +2180,7 @@ bool do_notify_parent(struct task_struct
 	WARN_ON_ONCE(!tsk->ptrace &&
 	       (tsk->group_leader != tsk || !thread_group_empty(tsk)));
 	/*
-	 * tsk is a group leader and has no threads, wake up the
-	 * non-PIDFD_THREAD waiters.
+	 * Notify for thread-group leaders without subthreads.
 	 */
 	if (thread_group_empty(tsk))
 		do_notify_pidfd(tsk);


