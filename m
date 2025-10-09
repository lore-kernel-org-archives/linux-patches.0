Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929862F60A6;
	Thu,  9 Oct 2025 16:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025685; cv=none; b=kG0tnsPHCLudfp4wS2Uw7nocecAi5lGwAvJSCikRNHO5JvhYSemv99O8UcWYbWOe5NUSsBj5q6L/dl6xTBUvtj7Ab1FkiHEiISQGRk2zCTZO+YrQo2QbAg5kB6ycno4H6qcki7et9lbWOgfEfpIWGeIQYqQmpgZtcl5xd6Uk2D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025685; c=relaxed/simple;
	bh=1VEe07PAECb0k0tyJxn0lyS28iimlZ6tlQ829bZz/Ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M2t3l4Tz2ngSQrl+EChQajUlD+AAWfOmrG1a1NHMD/JYq5RIBNqLW8DCVYkcGRMFlc/k+VK4kIyRKZJdWlu7LTPiJ90L7S29v3VRVrDxnVLq7i3Y7CGMaYFK/tWTA3kySJ4hCTDw4JCTBm962TjlG2vVww0gI1f1CmUDhslZIEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WO6YGLqY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WO6YGLqY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3C4C4CEF8;
	Thu,  9 Oct 2025 16:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025685;
	bh=1VEe07PAECb0k0tyJxn0lyS28iimlZ6tlQ829bZz/Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WO6YGLqYEePskLhFWzDoSBxtKfM/IsfMdU0MmlpXxhZGyprVVrx3UPXjtjvLsA83W
	 YF5f5hyi0IZiVuymUzZfxPG+i6LiKyGpVW6i8YZaPXC0dXC6PXDVp6MuRUpcXWI7nE
	 D4/j8pP9puXw2n9sq0cHU8eAHqEJBJgP4YQftvs24VHSsOJ0fYYz4bvw63vg2r2cRF
	 Eaj4r5h2EDGmLlFkbX7x3zpq9Q3OPwjNb+r7wpQPp2Cb8J6IBmrUBWaiG3/pX8apzu
	 5ECB4ZiG/r7lf0vkuTlMX4p8U9JuwhGfOF30XzQEd96jAjdw5vMWTwCgKG0E3LVP34
	 bWgnexC+njtFg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pranav Tyagi <pranav.tyagi03@gmail.com>,
	Jann Horn <jann@thejh.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>,
	mingo@redhat.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.1] futex: Don't leak robust_list pointer on exec race
Date: Thu,  9 Oct 2025 11:56:22 -0400
Message-ID: <20251009155752.773732-116-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pranav Tyagi <pranav.tyagi03@gmail.com>

[ Upstream commit 6b54082c3ed4dc9821cdf0edb17302355cc5bb45 ]

sys_get_robust_list() and compat_get_robust_list() use ptrace_may_access()
to check if the calling task is allowed to access another task's
robust_list pointer. This check is racy against a concurrent exec() in the
target process.

During exec(), a task may transition from a non-privileged binary to a
privileged one (e.g., setuid binary) and its credentials/memory mappings
may change. If get_robust_list() performs ptrace_may_access() before
this transition, it may erroneously allow access to sensitive information
after the target becomes privileged.

A racy access allows an attacker to exploit a window during which
ptrace_may_access() passes before a target process transitions to a
privileged state via exec().

For example, consider a non-privileged task T that is about to execute a
setuid-root binary. An attacker task A calls get_robust_list(T) while T
is still unprivileged. Since ptrace_may_access() checks permissions
based on current credentials, it succeeds. However, if T begins exec
immediately afterwards, it becomes privileged and may change its memory
mappings. Because get_robust_list() proceeds to access T->robust_list
without synchronizing with exec() it may read user-space pointers from a
now-privileged process.

This violates the intended post-exec access restrictions and could
expose sensitive memory addresses or be used as a primitive in a larger
exploit chain. Consequently, the race can lead to unauthorized
disclosure of information across privilege boundaries and poses a
potential security risk.

Take a read lock on signal->exec_update_lock prior to invoking
ptrace_may_access() and accessing the robust_list/compat_robust_list.
This ensures that the target task's exec state remains stable during the
check, allowing for consistent and synchronized validation of
credentials.

Suggested-by: Jann Horn <jann@thejh.net>
Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/linux-fsdevel/1477863998-3298-5-git-send-email-jann@thejh.net/
Link: https://github.com/KSPP/linux/issues/119
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Why this matters
- Fixes a real bug: A permission check vs. exec() race can leak a target
  task’s robust_list pointer across a privilege boundary. The old code
  checked permissions without synchronizing with a concurrent exec() and
  then returned the pointer, enabling an info-leak window.
- Security impact: Potential info disclosure across exec transitions
  (e.g., setuid). This is a hardening/security fix, not a feature.

What changed (key deltas)
- Introduces a shared helper and proper exec synchronization:
  - Adds `futex_task_robust_list()` to pick native vs. compat robust
    list pointer (kernel/futex/syscalls.c:42-49).
  - Adds `futex_get_robust_list_common()` that:
    - Looks up the target task under RCU and pins it with
      `get_task_struct()` (kernel/futex/syscalls.c:57-64).
    - Takes `down_read_killable(&p->signal->exec_update_lock)` to
      serialize with exec() (kernel/futex/syscalls.c:66-76).
    - Performs `ptrace_may_access(..., PTRACE_MODE_READ_REALCREDS)` and,
      if allowed, returns the robust_list pointer
      (kernel/futex/syscalls.c:74-83).
    - On error, drops the lock and task ref, returning an ERR_PTR
      (kernel/futex/syscalls.c:85-89).
- Refactors both syscalls to use the helper:
  - `sys_get_robust_list()` now uses the common path and checks
    `IS_ERR()` (kernel/futex/syscalls.c:98-110).
  - `compat_get_robust_list()` does the same for compat
    (kernel/futex/syscalls.c:486-494).
- Removes racy patterns:
  - The removed code only held `rcu_read_lock()` during
    `ptrace_may_access()` and the read of `p->robust_list`, with no
    exec() synchronization, creating the race window. See e.g., v6.1
    code that still shows this pattern at
    v6.1:kernel/futex/syscalls.c:53..72 and :338..344.

Why this is correct
- Holding `signal->exec_update_lock` ensures the credentials and
  mappings checked by `ptrace_may_access()` remain stable across the
  exec boundary. This mirrors established patterns elsewhere, e.g.,
  `pidfd` file access uses the same lock (kernel/pid.c:835-844).
- Taking a task ref under RCU then dropping RCU is standard and safe for
  later operations needing a stable task pointer.
- Only returns the user pointer after permission is validated under the
  lock, closing the leak.

Risk and side effects
- Behavior: May now return `-EINTR` if interrupted while waiting on
  `exec_update_lock` (via `down_read_killable`). This is consistent with
  similar code paths (e.g., kernel/pid.c:835-844) and acceptable for
  stable.
- Contention: Minimal; it uses the read side of a rwsem and only for a
  short critical section.
- Scope: Localized to futex robust-list syscalls, no architectural
  churn.

Backport considerations
- Good targets: 5.11+ branches have `exec_update_lock` and will accept
  this pattern with minimal adaptation. Specifically:
  - v6.6.y: Has `exec_update_lock` and `cleanup.h`’s `scoped_guard`;
    patch applies with trivial context adjustments (path is
    kernel/futex/syscalls.c).
  - v6.1.y: Has `exec_update_lock`, but does not have `scoped_guard`.
    Replace the `scoped_guard(rcu)` with explicit `rcu_read_lock(); ...
    rcu_read_unlock();` and keep the
    `get_task_struct()`/`put_task_struct()` pattern. The file path is
    also kernel/futex/syscalls.c.
  - v5.15.y: Has `exec_update_lock` (rwsem) but syscalls still live in
    `kernel/futex.c`. Apply the same logic in that file and drop
    `scoped_guard` usage in favor of explicit RCU locking.
- Older 5.10.y:
  - `exec_update_lock` is not used in exec on this branch (exec uses
    `cred_guard_mutex`), and `kernel/futex.c` contains the syscalls. A
    faithful backport would either:
    - Use `cred_guard_mutex` (e.g.,
      `mutex_lock_interruptible(&p->signal->cred_guard_mutex)`) around
      `ptrace_may_access()` and pointer fetch to synchronize with exec
      (acceptable for stable despite “deprecated” comment), or
    - Pull in the exec_update_lock infrastructure and convert exec to
      use it first (invasive, not recommended for stable).
  - Thus, 5.10.y needs a targeted, equivalent fix using
    `cred_guard_mutex` to achieve the same serialization with exec.

Fit for stable policy
- Important bug/security fix with documented exploitation window; not a
  feature.
- Small, contained changes to futex syscalls only.
- Follows existing kernel patterns for exec-time synchronization.
- No architectural upheaval; low regression risk.

Conclusion
- Backport Status: YES. This should be backported to maintained stable
  trees, with small, branch‑appropriate adaptations:
  - Use `exec_update_lock` where available.
  - Replace `scoped_guard(rcu)` with explicit RCU lock/unlock on
    branches lacking `cleanup.h`.
  - For 5.10.y, use `cred_guard_mutex` to serialize with exec in lieu of
    `exec_update_lock`.

 kernel/futex/syscalls.c | 106 +++++++++++++++++++++-------------------
 1 file changed, 56 insertions(+), 50 deletions(-)

diff --git a/kernel/futex/syscalls.c b/kernel/futex/syscalls.c
index 4b6da9116aa6c..880c9bf2f3150 100644
--- a/kernel/futex/syscalls.c
+++ b/kernel/futex/syscalls.c
@@ -39,6 +39,56 @@ SYSCALL_DEFINE2(set_robust_list, struct robust_list_head __user *, head,
 	return 0;
 }
 
+static inline void __user *futex_task_robust_list(struct task_struct *p, bool compat)
+{
+#ifdef CONFIG_COMPAT
+	if (compat)
+		return p->compat_robust_list;
+#endif
+	return p->robust_list;
+}
+
+static void __user *futex_get_robust_list_common(int pid, bool compat)
+{
+	struct task_struct *p = current;
+	void __user *head;
+	int ret;
+
+	scoped_guard(rcu) {
+		if (pid) {
+			p = find_task_by_vpid(pid);
+			if (!p)
+				return (void __user *)ERR_PTR(-ESRCH);
+		}
+		get_task_struct(p);
+	}
+
+	/*
+	 * Hold exec_update_lock to serialize with concurrent exec()
+	 * so ptrace_may_access() is checked against stable credentials
+	 */
+	ret = down_read_killable(&p->signal->exec_update_lock);
+	if (ret)
+		goto err_put;
+
+	ret = -EPERM;
+	if (!ptrace_may_access(p, PTRACE_MODE_READ_REALCREDS))
+		goto err_unlock;
+
+	head = futex_task_robust_list(p, compat);
+
+	up_read(&p->signal->exec_update_lock);
+	put_task_struct(p);
+
+	return head;
+
+err_unlock:
+	up_read(&p->signal->exec_update_lock);
+err_put:
+	put_task_struct(p);
+	return (void __user *)ERR_PTR(ret);
+}
+
 /**
  * sys_get_robust_list() - Get the robust-futex list head of a task
  * @pid:	pid of the process [zero for current task]
@@ -49,36 +99,14 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
 		struct robust_list_head __user * __user *, head_ptr,
 		size_t __user *, len_ptr)
 {
-	struct robust_list_head __user *head;
-	unsigned long ret;
-	struct task_struct *p;
-
-	rcu_read_lock();
-
-	ret = -ESRCH;
-	if (!pid)
-		p = current;
-	else {
-		p = find_task_by_vpid(pid);
-		if (!p)
-			goto err_unlock;
-	}
-
-	ret = -EPERM;
-	if (!ptrace_may_access(p, PTRACE_MODE_READ_REALCREDS))
-		goto err_unlock;
+	struct robust_list_head __user *head = futex_get_robust_list_common(pid, false);
 
-	head = p->robust_list;
-	rcu_read_unlock();
+	if (IS_ERR(head))
+		return PTR_ERR(head);
 
 	if (put_user(sizeof(*head), len_ptr))
 		return -EFAULT;
 	return put_user(head, head_ptr);
-
-err_unlock:
-	rcu_read_unlock();
-
-	return ret;
 }
 
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
@@ -455,36 +483,14 @@ COMPAT_SYSCALL_DEFINE3(get_robust_list, int, pid,
 			compat_uptr_t __user *, head_ptr,
 			compat_size_t __user *, len_ptr)
 {
-	struct compat_robust_list_head __user *head;
-	unsigned long ret;
-	struct task_struct *p;
-
-	rcu_read_lock();
-
-	ret = -ESRCH;
-	if (!pid)
-		p = current;
-	else {
-		p = find_task_by_vpid(pid);
-		if (!p)
-			goto err_unlock;
-	}
-
-	ret = -EPERM;
-	if (!ptrace_may_access(p, PTRACE_MODE_READ_REALCREDS))
-		goto err_unlock;
+	struct compat_robust_list_head __user *head = futex_get_robust_list_common(pid, true);
 
-	head = p->compat_robust_list;
-	rcu_read_unlock();
+	if (IS_ERR(head))
+		return PTR_ERR(head);
 
 	if (put_user(sizeof(*head), len_ptr))
 		return -EFAULT;
 	return put_user(ptr_to_compat(head), head_ptr);
-
-err_unlock:
-	rcu_read_unlock();
-
-	return ret;
 }
 #endif /* CONFIG_COMPAT */
 
-- 
2.51.0

