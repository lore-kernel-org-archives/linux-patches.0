Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209361;
	b=Y7ITcEIopX8/59P3TWFj0ZoiG+oz546cBHMVMVi4EeMkJUdqzKbsY6Am/TxyoND+qwNT
	 MyhYg8R5qJDt7mi9dGLifDFsfo38cLzyZQ9lH74QaWlpqoWJ96XK5XMAgCUdAQ6PgfQ8v
	 K6HNWz5uXhRDPmRSqqu2Jhgf4isljBjKgAZSF/YmucUlEi3kRoI2pnx2jtA42lbweGqQ4
	 6hAPbrIX1tzd6QCTu86MFTjdPNSIZxppv9yCWJHMI4UoXyTiRxVh+wk3qsar/N4GGA1oM
	 5ghFskP0A4pZ1Q+mXmb6cGbOLWB+7/LzgrVesh1gZEvOEkrDVglEicxRxtST+CmCqRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209361;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rz+A38KH/8LJTIOpvte7jgCfCVGrC+9ja1Tr/Ab3nzU=;
	b=EmLxSm+sqSBGTV9pln8uBPS+IRukNK3Zp1e1ogTO7G95zZQFz2QmLoqOfKCNewwT2GAv
	 ZAcNxKccFOTnlQqpFZTs6CoDs4aqeNHDK6l6wXMPU65Ezz5ahx8w03zY2H0knNpe6fEqc
	 AiojTSMGmGi1ixhOceBjMNaLfuA+TjjdnsIG3D2TwEjaz4xp63OA3zTQU/29Ve5l2Fbc0
	 koirIQ4JuBbV5bCd59cG4+BB7IDZm7yP5tobAQhOb29f4L/f01CEomXDHzQ/cVH+9Y95e
	 W5upVr42OKttUWQKH4ORnpJTMQe46VIgVP00O+BAdybrOtMD7cBRK8bp1XveBFOcdkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oqx4JAkF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21925606A31C;
	Wed, 28 Oct 2026 17:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oqx4JAkF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7233F1F01825;
	Wed, 28 Oct 2026 17:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209361;
	bh=Rz+A38KH/8LJTIOpvte7jgCfCVGrC+9ja1Tr/Ab3nzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oqx4JAkF9pq4ivtR1VV8d8qEv3gCMJWXSRtaiB3cz0J1oW7ctOPclPX9SEFFll22f
	 6yWdVgIFSZSUieG8yTjyRWfBybaqmWy8ulf18mjNA2SJRbgTr6bllTeknAtJWDK0md
	 voJO12wgrnpUk7YjrV1zvLvtbevNkgEZAEIEjZB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 444/516] clone: add CLONE_AUTOREAP
Date: Wed, 28 Oct 2026 17:59:56 +0100
Message-ID: <20261028170014.000614958@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 12ae2c81b21cfaa193db2faf035d495807edc3a7 ]

Add a new clone3() flag CLONE_AUTOREAP that makes a child process
auto-reap on exit without ever becoming a zombie. This is a per-process
property in contrast to the existing auto-reap mechanism via
SA_NOCLDWAIT or SIG_IGN for SIGCHLD which applies to all children of a
given parent.

Currently the only way to automatically reap children is to set
SA_NOCLDWAIT or SIG_IGN on SIGCHLD. This is a parent-scoped property
affecting all children which makes it unsuitable for libraries or
applications that need selective auto-reaping of specific children while
still being able to wait() on others.

CLONE_AUTOREAP stores an autoreap flag in the child's signal_struct.
When the child exits do_notify_parent() checks this flag and causes
exit_notify() to transition the task directly to EXIT_DEAD. Since the
flag lives on the child it survives reparenting: if the original parent
exits and the child is reparented to a subreaper or init the child still
auto-reaps when it eventually exits.

CLONE_AUTOREAP can be combined with CLONE_PIDFD to allow the parent to
monitor the child's exit via poll() and retrieve exit status via
PIDFD_GET_INFO. Without CLONE_PIDFD it provides a fire-and-forget
pattern where the parent simply doesn't care about the child's exit
status. No exit signal is delivered so exit_signal must be zero.

CLONE_AUTOREAP is rejected in combination with CLONE_PARENT. If a
CLONE_AUTOREAP child were to clone(CLONE_PARENT) the new grandchild
would inherit exit_signal == 0 from the autoreap parent's group leader
but without signal->autoreap. This grandchild would become a zombie that
never sends a signal and is never autoreaped - confusing and arguably
broken behavior.

The flag is not inherited by the autoreap process's own children. Each
child that should be autoreaped must be explicitly created with
CLONE_AUTOREAP.

Link: https://github.com/uapi-group/kernel-features/issues/45
Link: https://patch.msgid.link/20260226-work-pidfs-autoreap-v5-1-d148b984a989@kernel.org
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 28d2905d77bc ("exit: fix lost-update race on the child_subreaper bitfields")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/signal.h |  1 +
 include/uapi/linux/sched.h   |  5 +++--
 kernel/fork.c                | 17 ++++++++++++++++-
 kernel/ptrace.c              |  3 ++-
 kernel/signal.c              |  4 ++++
 5 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 5e4194e12a7db..80cb96ab7bcb9 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -121,6 +121,7 @@ struct signal_struct {
 	 */
 	unsigned int		is_child_subreaper:1;
 	unsigned int		has_child_subreaper:1;
+	unsigned int		autoreap:1;
 
 #ifdef CONFIG_POSIX_TIMERS
 
diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index 3bac0a8ceab26..ea36620df1c90 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -34,8 +34,9 @@
 #define CLONE_IO		0x80000000	/* Clone io context */
 
 /* Flags for the clone3() syscall. */
-#define CLONE_CLEAR_SIGHAND 0x100000000ULL /* Clear any signal handler and reset to SIG_DFL. */
-#define CLONE_INTO_CGROUP 0x200000000ULL /* Clone into a specific cgroup given the right permissions. */
+#define CLONE_CLEAR_SIGHAND	(1ULL << 32) /* Clear any signal handler and reset to SIG_DFL. */
+#define CLONE_INTO_CGROUP	(1ULL << 33) /* Clone into a specific cgroup given the right permissions. */
+#define CLONE_AUTOREAP		(1ULL << 34) /* Auto-reap child on exit. */
 
 /*
  * cloning flags intersect with CSIGNAL so can be used with unshare and clone3
diff --git a/kernel/fork.c b/kernel/fork.c
index 531de2d1b3bfe..83912c9e0c87c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2024,6 +2024,18 @@ static __latent_entropy struct task_struct *copy_process(
 			return ERR_PTR(-EINVAL);
 	}
 
+	if (clone_flags & CLONE_AUTOREAP) {
+		if (clone_flags & CLONE_THREAD)
+			return ERR_PTR(-EINVAL);
+		if (clone_flags & CLONE_PARENT)
+			return ERR_PTR(-EINVAL);
+		if (args->exit_signal)
+			return ERR_PTR(-EINVAL);
+	}
+
+	if ((clone_flags & CLONE_PARENT) && current->signal->autoreap)
+		return ERR_PTR(-EINVAL);
+
 	/*
 	 * Force any signals received before this point to be delivered
 	 * before the fork happens.  Collect up signals sent to multiple
@@ -2380,6 +2392,8 @@ static __latent_entropy struct task_struct *copy_process(
 			 */
 			p->signal->has_child_subreaper = p->real_parent->signal->has_child_subreaper ||
 							 p->real_parent->signal->is_child_subreaper;
+			if (clone_flags & CLONE_AUTOREAP)
+				p->signal->autoreap = 1;
 			list_add_tail(&p->sibling, &p->real_parent->children);
 			list_add_tail_rcu(&p->tasks, &init_task.tasks);
 			attach_pid(p, PIDTYPE_TGID);
@@ -2803,7 +2817,8 @@ static bool clone3_args_valid(struct kernel_clone_args *kargs)
 {
 	/* Verify that no unknown flags are passed along. */
 	if (kargs->flags &
-	    ~(CLONE_LEGACY_FLAGS | CLONE_CLEAR_SIGHAND | CLONE_INTO_CGROUP))
+	    ~(CLONE_LEGACY_FLAGS | CLONE_CLEAR_SIGHAND | CLONE_INTO_CGROUP |
+	      CLONE_AUTOREAP))
 		return false;
 
 	/*
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index fb21c2bf55c37..11e62a051ed8b 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -583,7 +583,8 @@ static bool __ptrace_detach(struct task_struct *tracer, struct task_struct *p)
 	if (!dead && thread_group_empty(p)) {
 		if (!same_thread_group(p->real_parent, tracer))
 			dead = do_notify_parent(p, p->exit_signal);
-		else if (ignoring_children(tracer->sighand)) {
+		else if (ignoring_children(tracer->sighand) ||
+			 p->signal->autoreap) {
 			__wake_up_parent(p, tracer);
 			dead = true;
 		}
diff --git a/kernel/signal.c b/kernel/signal.c
index d9f2f01db1038..422ac3382f6b2 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2006,6 +2006,10 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 		if (psig->action[SIGCHLD-1].sa.sa_handler == SIG_IGN)
 			sig = 0;
 	}
+	if (!tsk->ptrace && tsk->signal->autoreap) {
+		autoreap = true;
+		sig = 0;
+	}
 	/*
 	 * Send with __send_signal as si_pid and si_uid are in the
 	 * parent's namespaces.
-- 
2.53.0



