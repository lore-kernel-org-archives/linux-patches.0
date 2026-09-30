Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502BF50B8A8;
	Wed, 30 Sep 2026 17:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790109; cv=none; b=Qlf0V/b/iCnLt/J/q6fgC/l2mqbkm4CFGDbXfGK9nvb8Y9HHGGDCFoby6RDUgEKM7JOb7uIYhu5etfbH3B7uIp0nA0/uoE1rzeD2tzi5jUVf81krDsFzp2XSP7VEF6L9SODA47Io9FuCi0sMmg/zQCI8MKHcH2ATO33dqLja/5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790109; c=relaxed/simple;
	bh=Buy7sJmOTZczjaoaMnVMCZpNw2qq3965nbOLV0v655k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mW2MwWtdF62PNUnHHUHldXQzaNHqQU38APtSleMZASSGgb/7FdfP4In52VksqCZZrmBi9bQrzO/JwSOVnE4Ms2M5d/gifV8CAPPXqRpM0BhBgotj/ZETnps9YIGLSiudtTdDYqaqDIZUBPANvbNNvnq8tS+0e0sgntEiX0zPOVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJx9rpVA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJx9rpVA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4E21F000FF;
	Wed, 30 Sep 2026 17:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790107;
	bh=RNdh/yHeTUYlI2W/AM5F2m911Vc40e0wy6ZTJhmx+h0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JJx9rpVAlfwk8gDAsKqCNF2ZYnv7Y8hee+sRpwaDtG0Cv+4Y+++9XT1vn1RxhYE4u
	 kyi4fXG0GnQnxerxpEPUwKx/PLCQu23v7MZG14dRQSMlHTpGCB6SXLTvkQxwS4rX9Q
	 9tJckYQw4dpiYONSd+vcXqmEJlXedNzDQHv7I5qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Alexey Gladkov <legion@kernel.org>,
	Bradley Morgan <include@grrlz.net>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Joel Granados <joel.granados@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 713/877] sysctl: move the "cad_pid" entry from pid_table[] to kern_reboot_table[]
Date: Wed, 30 Sep 2026 17:27:04 +0200
Message-ID: <20260930152430.071476132@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

[ Upstream commit 7170ca01623b399c97f2ae9d3e228badc1f25ea3 ]

cad_pid is global, and kill_cad_pid() is only used in the root namespace.

However, due to pid_table_root_permissions(), a non-root user can unshare
pid/user namespaces and modify it from the child namespace. This makes no
sense and is simply wrong.

Move it to kern_reboot_table[] where it logically belongs; this ensures
that only GLOBAL_ROOT_UID can read/modify this sysctl.

Note that this patch doesn't preserve "#ifdef CONFIG_PROC_SYSCTL" around
the "cad_pid"; CONFIG_PROC_SYSCTL selects CONFIG_SYSCTL, so it is always
set when kern_reboot_table[] is compiled.

Cc: stable@vger.kernel.org
Fixes: e054bcbe7e7a ("sysctl: move cad_pid into kernel/pid.c")
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Alexey Gladkov <legion@kernel.org>
Reviewed-by: Bradley Morgan <include@grrlz.net>
Reviewed-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Signed-off-by: Joel Granados <joel.granados@kernel.org>

[6.12 dependency adaptation]
The stable tree still keeps cad_pid in the global kernel/sysctl.c table;
it does not have the upstream per-PID-namespace table. Move the existing
handler and entry directly from kernel/sysctl.c to kernel/reboot.c, using
proc_dointvec() with a local table copy because __do_proc_dointvec() is
private to sysctl.c. Leave kernel/pid.c unchanged and retain the mutable
ctl_table required by the stable registration API.

Make the existing kernel_reboot_sysctls_init() an independent late initcall
outside CONFIG_SYSFS so cad_pid remains available with PROC_SYSCTL=y and
SYSFS=n, and does not depend on sysfs object allocation succeeding.

Prepare context for 5a88f78df753 without importing newer scheduler or timer
implementations: move the existing kick_process() declaration/stub before
cad_pid and expand the empty stub, and guard the existing POSIX-only
sigqueue helpers with CONFIG_POSIX_TIMERS using the upstream comment.
No new functions are introduced, and the target's RCU fix is left for the
target commit.

[ sashal: Reduced backport -- upstream 7170ca01623b3 touches 2 file(s), this
  backport carries 4. Not backported here:
  kernel/pid.c
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: 5a88f78df753 ("reboot: fix cad_pid use-after-free race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sched.h |   14 ++++++++------
 kernel/reboot.c       |   40 +++++++++++++++++++++++++++++++++++-----
 kernel/signal.c       |   12 +++++-------
 kernel/sysctl.c       |   31 -------------------------------
 4 files changed, 48 insertions(+), 49 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1675,6 +1675,14 @@ static inline char task_state_to_char(st
 	return task_index_to_char(task_state_index(tsk));
 }
 
+#ifdef CONFIG_SMP
+extern void kick_process(struct task_struct *tsk);
+#else
+static inline void kick_process(struct task_struct *tsk)
+{
+}
+#endif
+
 extern struct pid *cad_pid;
 
 /*
@@ -1953,12 +1961,6 @@ extern int wake_up_state(struct task_str
 extern int wake_up_process(struct task_struct *tsk);
 extern void wake_up_new_task(struct task_struct *tsk);
 
-#ifdef CONFIG_SMP
-extern void kick_process(struct task_struct *tsk);
-#else
-static inline void kick_process(struct task_struct *tsk) { }
-#endif
-
 extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec);
 
 static inline void set_task_comm(struct task_struct *tsk, const char *from)
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -1280,7 +1280,32 @@ static struct attribute *reboot_attrs[]
 	NULL,
 };
 
+#endif /* CONFIG_SYSFS */
+
 #ifdef CONFIG_SYSCTL
+static int proc_do_cad_pid(const struct ctl_table *table, int write, void *buffer,
+			   size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table tmp_table = *table;
+	struct pid *new_pid;
+	pid_t tmp_pid;
+	int r;
+
+	tmp_pid = pid_vnr(cad_pid);
+	tmp_table.data = &tmp_pid;
+
+	r = proc_dointvec(&tmp_table, write, buffer, lenp, ppos);
+	if (r || !write)
+		return r;
+
+	new_pid = find_get_pid(tmp_pid);
+	if (!new_pid)
+		return -ESRCH;
+
+	put_pid(xchg(&cad_pid, new_pid));
+	return 0;
+}
+
 static struct ctl_table kern_reboot_table[] = {
 	{
 		.procname       = "poweroff_cmd",
@@ -1296,16 +1321,23 @@ static struct ctl_table kern_reboot_tabl
 		.mode           = 0644,
 		.proc_handler   = proc_dointvec,
 	},
+	{
+		.procname	= "cad_pid",
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= proc_do_cad_pid,
+	},
 };
 
-static void __init kernel_reboot_sysctls_init(void)
+static int __init kernel_reboot_sysctls_init(void)
 {
 	register_sysctl_init("kernel", kern_reboot_table);
+	return 0;
 }
-#else
-#define kernel_reboot_sysctls_init() do { } while (0)
+late_initcall(kernel_reboot_sysctls_init);
 #endif /* CONFIG_SYSCTL */
 
+#ifdef CONFIG_SYSFS
 static const struct attribute_group reboot_attr_group = {
 	.attrs = reboot_attrs,
 };
@@ -1325,8 +1357,6 @@ static int __init reboot_ksysfs_init(voi
 		return ret;
 	}
 
-	kernel_reboot_sysctls_init();
-
 	return 0;
 }
 late_initcall(reboot_ksysfs_init);
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1936,14 +1936,10 @@ int kill_pid(struct pid *pid, int sig, i
 }
 EXPORT_SYMBOL(kill_pid);
 
+#ifdef CONFIG_POSIX_TIMERS
 /*
- * These functions support sending signals using preallocated sigqueue
- * structures.  This is needed "because realtime applications cannot
- * afford to lose notifications of asynchronous events, like timer
- * expirations or I/O completions".  In the case of POSIX Timers
- * we allocate the sigqueue structure from the timer_create.  If this
- * allocation fails we are able to report the failure to the application
- * with an EAGAIN error.
+ * These functions handle POSIX timer signals. POSIX timers use
+ * preallocated sigqueue structs for sending signals.
  */
 struct sigqueue *sigqueue_alloc(void)
 {
@@ -2043,6 +2039,8 @@ ret:
 	return ret;
 }
 
+#endif /* CONFIG_POSIX_TIMERS */
+
 void do_notify_pidfd(struct task_struct *task)
 {
 	struct pid *pid = task_pid(task);
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1322,28 +1322,6 @@ int proc_dointvec_ms_jiffies(const struc
 				do_proc_dointvec_ms_jiffies_conv, NULL);
 }
 
-static int proc_do_cad_pid(const struct ctl_table *table, int write, void *buffer,
-		size_t *lenp, loff_t *ppos)
-{
-	struct pid *new_pid;
-	pid_t tmp;
-	int r;
-
-	tmp = pid_vnr(cad_pid);
-
-	r = __do_proc_dointvec(&tmp, table, write, buffer,
-			       lenp, ppos, NULL, NULL);
-	if (r || !write)
-		return r;
-
-	new_pid = find_get_pid(tmp);
-	if (!new_pid)
-		return -ESRCH;
-
-	put_pid(xchg(&cad_pid, new_pid));
-	return 0;
-}
-
 /**
  * proc_do_large_bitmap - read/write from/to a large bitmap
  * @table: the sysctl table
@@ -1761,15 +1739,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= sysrq_sysctl_handler,
 	},
 #endif
-#ifdef CONFIG_PROC_SYSCTL
-	{
-		.procname	= "cad_pid",
-		.data		= NULL,
-		.maxlen		= sizeof (int),
-		.mode		= 0600,
-		.proc_handler	= proc_do_cad_pid,
-	},
-#endif
 	{
 		.procname	= "threads-max",
 		.data		= NULL,


