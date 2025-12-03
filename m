Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7A9340D90;
	Wed,  3 Dec 2025 16:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778972; cv=none; b=P9EyfsbdUuPoqNlI5TwQ5qHd145oBOSu8bCTqt1dRUsmqULSyBMisxYCCftQ5ctAkSbz82wAAPYfXv+ex8pqqyYUU2VDnPvIdkfFIazkzM5IcUaguEmVSQnfT/iiTXQLN0QXPzOjAWMlQDU7jYbTyKOVBLa2FyfQVpMy1tpTa1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778972; c=relaxed/simple;
	bh=jpIjWsmDwTMZ/W8ihHZC1g57auSypON0DZ5Hkw+fQQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gbrfxzHrTOUPH3NfGw6hB5ZEnx+DmatNcJZUt7/XyG3UGNqxPqB3Iy2vgXoXDJhHTFP5dNOlAs28KGA1yp2Xad9MD1AqqQYGfNsluP91RB+BJQgjZGnPIbp00gTp2RdyX6awTkEyBlMQG7oqYb32supKjvG6ABFqJ8BTOe5kPy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xkJuZQaW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xkJuZQaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A25C4CEF5;
	Wed,  3 Dec 2025 16:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778971;
	bh=jpIjWsmDwTMZ/W8ihHZC1g57auSypON0DZ5Hkw+fQQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xkJuZQaW0pqV/CquS/M0QnZl4UVyU+7XzoS/6t5HKymDrxQVjS0FM3ppgYVMfe/Q+
	 IKC4bhSdMtxOaWnuWZu5UQ8JODaOPoQyWKiNZfzeuu74ErpKo+6ZB6Lswg2crSZ7Me
	 mD+U30q6SFSvoT7mc3jp9IaXo1b/ae8RQ2el9p/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jann@thejh.net>,
	Pranav Tyagi <pranav.tyagi03@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 117/568] futex: Dont leak robust_list pointer on exec race
Date: Wed,  3 Dec 2025 16:21:59 +0100
Message-ID: <20251203152445.020050228@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 kernel/futex/syscalls.c | 106 +++++++++++++++++++++-------------------
 1 file changed, 56 insertions(+), 50 deletions(-)

diff --git a/kernel/futex/syscalls.c b/kernel/futex/syscalls.c
index a8074079b09e8..48feaa545b3c7 100644
--- a/kernel/futex/syscalls.c
+++ b/kernel/futex/syscalls.c
@@ -40,6 +40,56 @@ SYSCALL_DEFINE2(set_robust_list, struct robust_list_head __user *, head,
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
@@ -50,36 +100,14 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
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
@@ -322,36 +350,14 @@ COMPAT_SYSCALL_DEFINE3(get_robust_list, int, pid,
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



