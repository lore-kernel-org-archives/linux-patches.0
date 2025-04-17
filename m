Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEBA25B69B;
	Thu, 17 Apr 2025 18:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914936; cv=none; b=LJ5WSBSZdTS30vyE+SdWEFv+yn8x/+2x4nbyYVJeDI2RVQz6dDwAkkFBgaNl5lc9i8e8nzrsngC6w2qxUa4Zxu+kv9v2g0P8p8BvrVvUMrnYdRiypo7ZifatQF/+Xn2Ks5AB8aoARkW+gB5V7HTzdvyiDoG9RrZNjEbYaxRzOzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914936; c=relaxed/simple;
	bh=5ZdwEhQYx1a0TwlL4ZdUS7/2v9+KnWabB1vYabwvJmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j49671Je6wOCuubjJPySQtv7LLQmBX+SO2NFXQpcgugOecA6sRP76bzrTsUuB1RvxWuXDUdw0SI1JX1Jvd4cVZYUfa5LmF7E6dYdO/I5EzEgsU4HaUKSHQPhflCHYv5GV/1+wbFRDrvIstgg+tzZZRJmgPC4IMbvmHaHAN/HApA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R2J/bzGG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R2J/bzGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF21C4CEE4;
	Thu, 17 Apr 2025 18:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914936;
	bh=5ZdwEhQYx1a0TwlL4ZdUS7/2v9+KnWabB1vYabwvJmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R2J/bzGGPUMGZNymZ6vt+fr7lYZbhYEWJmxTo32ByH6Vb2yYNtZuznUBJ+fZbwsV/
	 JRhQb98Ur8I+PzHohGuGxejiu0pkyXERQ2P33vXKotyopwIQLwwJfkjD9CWNKEr13X
	 2tK7pZlT+bJzJa2aXUIewAm+ao1jISuTBVuMhyv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <serge@hallyn.com>,
	Tahera Fahimi <fahimitahera@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.13 372/414] landlock: Always allow signals between threads of the same process
Date: Thu, 17 Apr 2025 19:52:10 +0200
Message-ID: <20250417175126.425181498@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

commit 18eb75f3af40be1f0fc2025d4ff821711222a2fd upstream.

Because Linux credentials are managed per thread, user space relies on
some hack to synchronize credential update across threads from the same
process.  This is required by the Native POSIX Threads Library and
implemented by set*id(2) wrappers and libcap(3) to use tgkill(2) to
synchronize threads.  See nptl(7) and libpsx(3).  Furthermore, some
runtimes like Go do not enable developers to have control over threads
[1].

To avoid potential issues, and because threads are not security
boundaries, let's relax the Landlock (optional) signal scoping to always
allow signals sent between threads of the same process.  This exception
is similar to the __ptrace_may_access() one.

hook_file_set_fowner() now checks if the target task is part of the same
process as the caller.  If this is the case, then the related signal
triggered by the socket will always be allowed.

Scoping of abstract UNIX sockets is not changed because kernel objects
(e.g. sockets) should be tied to their creator's domain at creation
time.

Note that creating one Landlock domain per thread puts each of these
threads (and their future children) in their own scope, which is
probably not what users expect, especially in Go where we do not control
threads.  However, being able to drop permissions on all threads should
not be restricted by signal scoping.  We are working on a way to make it
possible to atomically restrict all threads of a process with the same
domain [2].

Add erratum for signal scoping.

Closes: https://github.com/landlock-lsm/go-landlock/issues/36
Fixes: 54a6e6bbf3be ("landlock: Add signal scoping")
Fixes: c8994965013e ("selftests/landlock: Test signal scoping for threads")
Depends-on: 26f204380a3c ("fs: Fix file_set_fowner LSM hook inconsistencies")
Link: https://pkg.go.dev/kernel.org/pub/linux/libs/security/libcap/psx [1]
Link: https://github.com/landlock-lsm/linux/issues/2 [2]
Cc: Günther Noack <gnoack@google.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: Tahera Fahimi <fahimitahera@gmail.com>
Cc: stable@vger.kernel.org
Acked-by: Christian Brauner <brauner@kernel.org>
Link: https://lore.kernel.org/r/20250318161443.279194-6-mic@digikod.net
[mic: Add extra pointer check and RCU guard, and ease backport]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/landlock/errata/abi-6.h                      |   19 ++++++++
 security/landlock/fs.c                                |   39 +++++++++++++++---
 security/landlock/task.c                              |   12 +++++
 tools/testing/selftests/landlock/scoped_signal_test.c |    2 
 4 files changed, 65 insertions(+), 7 deletions(-)
 create mode 100644 security/landlock/errata/abi-6.h

--- /dev/null
+++ b/security/landlock/errata/abi-6.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+/**
+ * DOC: erratum_2
+ *
+ * Erratum 2: Scoped signal handling
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * This fix addresses an issue where signal scoping was overly restrictive,
+ * preventing sandboxed threads from signaling other threads within the same
+ * process if they belonged to different domains.  Because threads are not
+ * security boundaries, user space might assume that any thread within the same
+ * process can send signals between themselves (see :manpage:`nptl(7)` and
+ * :manpage:`libpsx(3)`).  Consistent with :manpage:`ptrace(2)` behavior, direct
+ * interaction between threads of the same process should always be allowed.
+ * This change ensures that any thread is allowed to send signals to any other
+ * thread within the same process, regardless of their domain.
+ */
+LANDLOCK_ERRATUM(2)
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -27,7 +27,9 @@
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/path.h>
+#include <linux/pid.h>
 #include <linux/rcupdate.h>
+#include <linux/sched/signal.h>
 #include <linux/spinlock.h>
 #include <linux/stat.h>
 #include <linux/types.h>
@@ -1623,21 +1625,46 @@ static int hook_file_ioctl_compat(struct
 	return -EACCES;
 }
 
-static void hook_file_set_fowner(struct file *file)
+/*
+ * Always allow sending signals between threads of the same process.  This
+ * ensures consistency with hook_task_kill().
+ */
+static bool control_current_fowner(struct fown_struct *const fown)
 {
-	struct landlock_ruleset *new_dom, *prev_dom;
+	struct task_struct *p;
 
 	/*
 	 * Lock already held by __f_setown(), see commit 26f204380a3c ("fs: Fix
 	 * file_set_fowner LSM hook inconsistencies").
 	 */
-	lockdep_assert_held(&file_f_owner(file)->lock);
-	new_dom = landlock_get_current_domain();
-	landlock_get_ruleset(new_dom);
+	lockdep_assert_held(&fown->lock);
+
+	/*
+	 * Some callers (e.g. fcntl_dirnotify) may not be in an RCU read-side
+	 * critical section.
+	 */
+	guard(rcu)();
+	p = pid_task(fown->pid, fown->pid_type);
+	if (!p)
+		return true;
+
+	return !same_thread_group(p, current);
+}
+
+static void hook_file_set_fowner(struct file *file)
+{
+	struct landlock_ruleset *prev_dom;
+	struct landlock_ruleset *new_dom = NULL;
+
+	if (control_current_fowner(file_f_owner(file))) {
+		new_dom = landlock_get_current_domain();
+		landlock_get_ruleset(new_dom);
+	}
+
 	prev_dom = landlock_file(file)->fown_domain;
 	landlock_file(file)->fown_domain = new_dom;
 
-	/* Called in an RCU read-side critical section. */
+	/* May be called in an RCU read-side critical section. */
 	landlock_put_ruleset_deferred(prev_dom);
 }
 
--- a/security/landlock/task.c
+++ b/security/landlock/task.c
@@ -13,6 +13,7 @@
 #include <linux/lsm_hooks.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
+#include <linux/sched/signal.h>
 #include <net/af_unix.h>
 #include <net/sock.h>
 
@@ -264,6 +265,17 @@ static int hook_task_kill(struct task_st
 		/* Dealing with USB IO. */
 		dom = landlock_cred(cred)->domain;
 	} else {
+		/*
+		 * Always allow sending signals between threads of the same process.
+		 * This is required for process credential changes by the Native POSIX
+		 * Threads Library and implemented by the set*id(2) wrappers and
+		 * libcap(3) with tgkill(2).  See nptl(7) and libpsx(3).
+		 *
+		 * This exception is similar to the __ptrace_may_access() one.
+		 */
+		if (same_thread_group(p, current))
+			return 0;
+
 		dom = landlock_get_current_domain();
 	}
 	dom = landlock_get_applicable_domain(dom, signal_scope);
--- a/tools/testing/selftests/landlock/scoped_signal_test.c
+++ b/tools/testing/selftests/landlock/scoped_signal_test.c
@@ -281,7 +281,7 @@ TEST(signal_scoping_threads)
 	/* Restricts the domain after creating the first thread. */
 	create_scoped_domain(_metadata, LANDLOCK_SCOPE_SIGNAL);
 
-	ASSERT_EQ(EPERM, pthread_kill(no_sandbox_thread, 0));
+	ASSERT_EQ(0, pthread_kill(no_sandbox_thread, 0));
 	ASSERT_EQ(1, write(thread_pipe[1], ".", 1));
 
 	ASSERT_EQ(0, pthread_create(&scoped_thread, NULL, thread_func, NULL));


