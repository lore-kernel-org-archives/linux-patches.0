Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022445;
	b=fXqFwzdFMYfi79O6JXuVdPcSiJBKvBPMj9JYX1j+FPOadIS0/lG6W2+9KlN/OHjKzW1f
	 0NU1kSWxJwUPStCzyWoQqzLHDVN32xNMyRhxDOIZLPP8523pl7Rj6AlE8xRJuCkHpMP++
	 sRakTRPNic47Kv6vHqti2qG7ZyF1YmCctd1w83Rso6DHS41pquwb2L+acUmVVcq5x51B0
	 e5qFZItrpGIEem7LsjQyGhmYRaz0PnAcGtjhAk0VS6PIqnTiGrxOW8OwR1RQMk+mDhvw5
	 8TzzQcn9hczTf5Kgmz9Nz1CKN80n9smQ8/Z1fmm1m+BkYKbjoPcZH1KK+Y9onTaSqRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kKjlHljqg0lyko9DTudiISOTgewpL8hExPAT5GJUwEU=;
	b=Swn3Uh9ylC1M1L1sFArD2RGH/53yEcfY9WSEI6r/4npBCEQvBoy9djprdzCPSRMDe9zA
	 R1OJelJDW26zwvk7zQOZk8ZnhPxjD134CPgRv8yX2xDg8bZdnP0i651lD0R7gPITCIbkQ
	 5KXfHYCLlRiqJzqtPPWvlERkVO7UvkMKwZ3xhQrTUkRaIZ8DBuTumLYc51W9+0/0M5MnX
	 qHTjAeouULzHf+hH9LcG/ly9KvOrPXeDpK41iL1TumMMAL5Yr9kr0d+aUudjYMvLJXoSu
	 uOHHFrCS1sjz49VR4XRV7dQ9ZQz2SqaeIELYMPpClFAJbJ6B7dwB5nj4YgkLldg1MPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lb+dg3Fp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2117060A2600;
	Wed, 18 Nov 2026 17:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lb+dg3Fp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714221F000C7;
	Wed, 18 Nov 2026 17:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022445;
	bh=kKjlHljqg0lyko9DTudiISOTgewpL8hExPAT5GJUwEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lb+dg3FpMoYeAmth396iUM3WNom23lYo7YAgqVjs7HAAC1HIUz8I9cYTEsVjVuf11
	 E+2Gz34rsZeQeYIkpbR0nyWokrFCj86yiUXYWLITgMMc+PQh/1mNik8fZGhgbsBDOT
	 fUG2J+qFf4O1+q7azrpS+0s5QtnBd9Z+X1fUROms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0016/2151] pidfs: dont let PIDFD_GET_INFO miss a reaped task
Date: Wed, 18 Nov 2026 15:29:11 +0100
Message-ID: <20261118150122.234649031@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 172658cf600904ff6121e240f69a0ccb36e65d6b ]

PIDFD_GET_INFO describes the task while there is one, and with
PIDFD_INFO_EXIT its exit status once it has been reaped.  pidfd_info()
looks at the two in the wrong order and can miss both:

  pidfd_info()                          release_task()
    PIDFS_ATTR_BIT_EXIT is not set
                                          pidfs_exit()
                                          __unhash_process()
    get_pid_task() == NULL
    goto copy_out

The ioctl succeeds with neither PIDFD_INFO_PID nor PIDFD_INFO_EXIT in the
mask.  If the task is unhashed a little later, after get_pid_task(), its
pid reads as 0 and the ioctl fails with -ESRCH, although the caller asked
for the exit information and it is available by now.

The second case does not even need an exit.  When a sub-thread execs,
de_thread() hands the leader's pid over to it and releases the old leader.
A caller that got hold of the old leader reports the tid of the sub-thread
as the pid, or -ESRCH for a process that is alive.

Look up the task first.  pidfs_exit() runs before the task is unhashed, so
a caller that finds no task finds the exit information; this needs a
barrier on both sides because taking tasklist_lock does not order the
store in pidfs_exit() against the one in detach_pid().  And start over if
the task no longer owns the pid when all the fields have been read: then
there is either exit information or another task.

Go by the pid for that check and for the pid we report, not by
->thread_pid of the task.  exchange_tids() moves the pid to the exec'ing
thread before it updates ->thread_pid of either task.  A caller that
finds the new leader in between would read the old tid of the sub-thread
from ->thread_pid, and a check of ->thread_pid would restart until the
exec'ing thread gets to its store.  On PREEMPT_RT that thread can be
preempted with tasklist_lock held and can't move to another CPU.  If the
RT task that preempted it calls PIDFD_GET_INFO, the ioctl spins until
the exec'ing thread gets the CPU back, and that never happens if the
exec'ing thread is an RT task of lower priority.

Christian Brauner <brauner@kernel.org> says:

Go by @pid instead of ->thread_pid of the task for the reported pid and
for the restart check.

Fixes: 7477d7dce48a ("pidfs: allow to retrieve exit information")
Fixes: cdda1f26e74b ("pidfd: add ioctl to retrieve pid info")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: inlined the RCU-protected ownership check in pidfd_info() instead of adding pidfs_task_owns_pid() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pidfs.c | 41 +++++++++++++++++++++++++++++++++++------
 1 file changed, 35 insertions(+), 6 deletions(-)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index d2afc85b9df37..a014db891aaa8 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -309,6 +309,7 @@ static long pidfd_info(struct file *file, unsigned int cmd, unsigned long arg)
 	struct user_namespace *user_ns;
 	struct pidfs_attr *attr;
 	const struct cred *c;
+	bool task_owns_pid;
 	__u64 mask;
 
 	BUILD_BUG_ON(sizeof(struct pidfd_info) != PIDFD_INFO_SIZE_VER1);
@@ -329,6 +330,17 @@ static long pidfd_info(struct file *file, unsigned int cmd, unsigned long arg)
 		return -EREMOTE;
 
 	attr = READ_ONCE(pid->attr);
+	exit_info = &attr->__pei;
+again:
+	/*
+	 * Look for the task first. pidfs_exit() records the exit information
+	 * before the task is unhashed, so if the task is gone the information
+	 * is there.
+	 */
+	task = get_pid_task(pid, PIDTYPE_PID);
+	if (!task)
+		smp_rmb(); /* pairs with smp_mb__after_atomic() in pidfs_exit() */
+
 	if (mask & PIDFD_INFO_EXIT) {
 		if (test_bit(PIDFS_ATTR_BIT_EXIT, &attr->attr_mask)) {
 			smp_rmb();
@@ -346,7 +358,6 @@ static long pidfd_info(struct file *file, unsigned int cmd, unsigned long arg)
 		kinfo.coredump_mask = READ_ONCE(attr->__pei.coredump_mask);
 	}
 
-	task = get_pid_task(pid, PIDTYPE_PID);
 	if (!task) {
 		/*
 		 * If the task has already been reaped, only exit
@@ -404,16 +415,29 @@ static long pidfd_info(struct file *file, unsigned int cmd, unsigned long arg)
 	 * task might return as soon as the copy_to_user finishes, but that's ok
 	 * and userspace expects that might happen and can act accordingly, so
 	 * this is just best-effort. What we can do however is checking that all
-	 * the fields are set correctly, or return ESRCH to avoid providing
-	 * incomplete information. */
+	 * the fields are set correctly, to avoid providing incomplete
+	 * information.
+	 */
 
 	kinfo.ppid = task_ppid_nr_ns(task, NULL);
 	kinfo.tgid = task_tgid_vnr(task);
-	kinfo.pid = task_pid_vnr(task);
+	kinfo.pid = pid_vnr(pid);
 	kinfo.mask |= PIDFD_INFO_PID;
 
-	if (kinfo.pid == 0 || kinfo.tgid == 0)
-		return -ESRCH;
+	/*
+	 * The task was reaped, or lost @pid to a sub-thread that called exec,
+	 * while we were looking at it. Start over: there is exit information
+	 * now, or a new task. Don't go by ->thread_pid, exchange_tids()
+	 * updates it only after it has moved @pid.
+	 */
+	scoped_guard(rcu)
+		task_owns_pid = pid_task(pid, PIDTYPE_PID) == task;
+	if (!task_owns_pid || kinfo.tgid == 0) {
+		put_task_struct(task);
+		task = NULL;
+		memset(&kinfo, 0, sizeof(kinfo));
+		goto again;
+	}
 
 copy_out:
 	/*
@@ -688,6 +712,11 @@ void pidfs_exit(struct task_struct *tsk)
 	/* Ensure that PIDFD_GET_INFO sees either all or nothing. */
 	smp_wmb();
 	set_bit(PIDFS_ATTR_BIT_EXIT, &attr->attr_mask);
+	/*
+	 * Whoever sees that the task is unhashed must see the bit, see
+	 * pidfd_info(). Taking tasklist_lock does not order the two stores.
+	 */
+	smp_mb__after_atomic();
 }
 
 #ifdef CONFIG_COREDUMP
-- 
2.53.0



