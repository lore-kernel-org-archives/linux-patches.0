Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065574;
	b=avfH/xip+1QS1XriCBWz79/KkRjufCkHoxUHmhd6mjiVtARVso2koRTCzJVeTu4ZNfYo
	 mUkXzedjs4KoDlN7jzyfootYNCFndBGzGoS54cdrZRIIU0p4bof35OqTzIOW/sb590vXz
	 CuJIFqmQbR7l9TTa+Of4shaitgAMExXBN80fcX/OB84ev3WvrYDnQaynG4m7S+yGFc5zq
	 CzISsUjSI1ardwVxMav7qOuNa8EroztyLirACRad528UB0sajXvNBb4g5Zha1MbImv0sc
	 f10UxCRulQ2Hu2WTB7Pg5110avu5/Zde4Ev4FbBwfar72lYMVS5FZEr0zpri2a2RelA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065574;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3b4n2GgwBV3X+YGJjOIHNYFo5vQUIR+pmSlgUkM7kKE=;
	b=h5RMLqYKOiYEGlOzwlrbclj/hMmLyVUcA6Flqq0PlOhNzodo3jMj70gi0tyQ9UK53DCN
	 ud7pBkAiKJ5ZCllLCqLdRLd2Vgxs+h36S9FlHtf37khsONt4eU5LS9OLULbDZEt2x/ac+
	 nOxVzS+qmFdR3OdivRWcaWK2rBwWEfHdRGMGnndY4GvK+bxKM53XErh4fBNcCITB3YKKY
	 ohB/qyyeTT+ikSeqUHH0yMR+IufELKKE8i+j5RnFgn1dAqXAcnnvN358o3Rjp+ambHt6l
	 h/pyxaLisjp3y/OxAAAPfkiEMzGnn1t+HMOqpXBWL3drPJ6AlT2+r/vjOuGAawYWLuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NR+rQwzv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B4C606A32C;
	Sat,  7 Nov 2026 15:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NR+rQwzv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718F41F0089F;
	Sat,  7 Nov 2026 15:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065573;
	bh=3b4n2GgwBV3X+YGJjOIHNYFo5vQUIR+pmSlgUkM7kKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NR+rQwzvl5NCiRui8s5VvRCXCBq4g5nmaHYEJ9NW/0iWWk7N+edX+/L2y3GlW6qxO
	 PzpdPRYTwsJqE4YffXOh0KUcifu9oK2+p3+q0D+SVdfknpw7A2cUYqh7TUvWbu0Ok3
	 0QAwge/lOOC4xbf6BuFx+AN5J+ho/qC60coTztpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1235/1257] pidfs: dont let PIDFD_GET_INFO miss a reaped task
Date: Sat,  7 Nov 2026 08:58:51 -0500
Message-ID: <20261107135013.449758097@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pidfs.c | 43 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index a6a643f15d08a..1bd130eb909ab 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -362,6 +362,12 @@ static __u32 pidfs_coredump_mask(enum task_dumpable dumpable)
 			      PIDFD_INFO_COREDUMP_SIGNAL | \
 			      PIDFD_INFO_COREDUMP_CODE)
 
+static bool pidfs_task_owns_pid(struct task_struct *task, struct pid *pid)
+{
+	guard(rcu)();
+	return pid_task(pid, PIDTYPE_PID) == task;
+}
+
 static long pidfd_info(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct pidfd_info __user *uinfo = (struct pidfd_info __user *)arg;
@@ -392,6 +398,16 @@ static long pidfd_info(struct file *file, unsigned int cmd, unsigned long arg)
 		return -EREMOTE;
 
 	attr = READ_ONCE(pid->attr);
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
@@ -414,7 +430,6 @@ static long pidfd_info(struct file *file, unsigned int cmd, unsigned long arg)
 		}
 	}
 
-	task = get_pid_task(pid, PIDTYPE_PID);
 	if (!task) {
 		/*
 		 * If the task has already been reaped, only exit
@@ -468,16 +483,27 @@ static long pidfd_info(struct file *file, unsigned int cmd, unsigned long arg)
 	 * task might return as soon as the copy_to_user finishes, but that's ok
 	 * and userspace expects that might happen and can act accordingly, so
 	 * this is just best-effort. What we can do however is checking that all
-	 * the fields are set correctly, or return ESRCH to avoid providing
-	 * incomplete information. */
+	 * the fields are set correctly, to avoid providing incomplete
+	 * information.
+	 */
 
 	kinfo.ppid = task_ppid_vnr(task);
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
+	if (!pidfs_task_owns_pid(task, pid) || kinfo.tgid == 0) {
+		put_task_struct(task);
+		task = NULL;
+		memset(&kinfo, 0, sizeof(kinfo));
+		goto again;
+	}
 
 copy_out:
 	if (mask & PIDFD_INFO_SUPPORTED_MASK) {
@@ -790,6 +816,11 @@ void pidfs_exit(struct task_struct *tsk)
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



