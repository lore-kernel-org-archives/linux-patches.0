Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B32251993B;
	Wed, 30 Sep 2026 17:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790111; cv=none; b=RAyoG2yoYjMjluZXucfNQrJZ1FGKW0HM4lLvgABsq3azTEO4WEW9OcpToJUyBC6W5VH2Fcg6gekvVz2IOD8Cc8Q2neKfneympi50IusNy+7IqYHg8ZnIp0xSaPdimeNGJfCdi8Crp8AGg4BUoF8mi7CfqxsVB9jTp+p5R65SbAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790111; c=relaxed/simple;
	bh=bkNjFMThCQczQ3mavv2Aa0zhKvGvm67TvioVFzmdCCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOgV54n1pFltQjmqS9TkbzmxcsinOvVHyp8NN29WvOUMMLdnCFoQZFoZJV8PrwczmoP3H4IldgtA7SHMQBOvlIh4PEPlab2HeEU7FBIHYmMzh3Iuhhj1Vz+UrGuzx+PHSUK7EQLcJWOeu3z5l4EwX6KPJ3E1Wi+WM+3Ou2oRHjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HzArnOW3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HzArnOW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B91A1F000FF;
	Wed, 30 Sep 2026 17:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790110;
	bh=iSz3sPs2fss7XK561FgbVH3krBVSUYGfOG7qfmb6TQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HzArnOW3YRLV9LR5eAEoBI68wbOD1rx8gkrghWAtJJYPyU9D5MYwKlHv6xZb/j7YL
	 kptZTWKTOyiwm0pstEhQr1gv2kEzjezRNPnUjI6Kl566jn+k44q+TOfIl1wG6uT34d
	 mUFq2y+5PYr128Jzj1NGS/Z2ml3adY67PCf4i3bY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	Mateusz Guzik <mjguzik@gmail.com>,
	Bradley Morgan <include@grrlz.net>,
	Oleg Nesterov <oleg@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 714/877] reboot: fix cad_pid use-after-free race
Date: Wed, 30 Sep 2026 17:27:05 +0200
Message-ID: <20260930152430.094261002@linuxfoundation.org>
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

From: "Cen Zhang (Microsoft)" <blbllhy@gmail.com>

[ Upstream commit 5a88f78df753993469dab4d1831f8fb4256a9468 ]

cad_pid is a single kernel-wide struct pid pointer. proc_do_cad_pid()
reads it and passes it to pid_vnr() without protecting the lifetime of
the referenced struct pid. A concurrent writer can replace cad_pid and
drop the final reference to the old struct pid after the reader has
loaded the pointer but before pid_vnr() has finished dereferencing it,
causing a use-after-free.

kill_cad_pid() has the same lifetime race when it passes cad_pid to
kill_pid().

At the time this issue was reported, an unprivileged user could reach the
sysctl through user and PID namespaces because cad_pid was registered in
pid_table[]. Moving cad_pid back to the global reboot sysctl table
corrected that namespace and permission mismatch, but did not fix the
underlying lifetime race.

Fix this by treating cad_pid as an RCU-protected pointer at both read
sites and by waiting for a grace period before dropping the old reference
on the write side.

call_rcu(&old_pid->rcu, ...) cannot be used here because free_pid()
also queues pid->rcu; queueing the same rcu_head twice can corrupt the
RCU callback list.

Original KASAN crash stack:
  kernel/pid.c:545 pid_nr_ns()        # reads freed pid->level
  kernel/pid.c:556 pid_vnr()          # calls pid_nr_ns()
  kernel/pid.c:775 proc_do_cad_pid()  # calls pid_vnr(cad_pid)

Fixes: 9ec52099e4b8 ("[PATCH] replace cad_pid by a struct pid")
Reported-by: AutonomousCodeSecurity@microsoft.com
Closes: https://lore.kernel.org/all/20260717210143.4734-1-blbllhy@gmail.com/
Link: https://lore.kernel.org/all/alz5ZYLE4kaq_v2P@redhat.com/
Link: https://lore.kernel.org/all/al4ICz9biJKtdZc4@redhat.com/
Suggested-by: Mateusz Guzik <mjguzik@gmail.com>
Suggested-by: Bradley Morgan <include@grrlz.net>
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Suggested-by: Eric W. Biederman <ebiederm@xmission.com>
Suggested-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: stable@vger.kernel.org
Signed-off-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
Link: https://patch.msgid.link/20260814040944.16561-1-blbllhy@gmail.com
Reviewed-by: Bradley Morgan <include@grrlz.net>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sched.h        |    2 +-
 include/linux/sched/signal.h |    5 +----
 init/main.c                  |    2 +-
 kernel/reboot.c              |   19 +++++++++++++++----
 kernel/signal.c              |   12 ++++++++++++
 5 files changed, 30 insertions(+), 10 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1683,7 +1683,7 @@ static inline void kick_process(struct t
 }
 #endif
 
-extern struct pid *cad_pid;
+extern struct pid __rcu *cad_pid;
 
 /*
  * Per process flags
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -558,10 +558,7 @@ static inline sigset_t *sigmask_to_save(
 	return res;
 }
 
-static inline int kill_cad_pid(int sig, int priv)
-{
-	return kill_pid(cad_pid, sig, priv);
-}
+int kill_cad_pid(int sig, int priv);
 
 /* These can be the second arg to send_sig_info/send_group_sig_info.  */
 #define SEND_SIG_NOINFO ((struct kernel_siginfo *) 0)
--- a/init/main.c
+++ b/init/main.c
@@ -1523,7 +1523,7 @@ static noinline void __init kernel_init_
 	 */
 	set_mems_allowed(node_states[N_MEMORY]);
 
-	cad_pid = get_pid(task_pid(current));
+	rcu_assign_pointer(cad_pid, get_pid(task_pid(current)));
 
 	smp_prepare_cpus(setup_max_cpus);
 
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -13,7 +13,9 @@
 #include <linux/kexec.h>
 #include <linux/kmod.h>
 #include <linux/kmsg_dump.h>
+#include <linux/rcupdate.h>
 #include <linux/reboot.h>
+#include <linux/sched/signal.h>
 #include <linux/suspend.h>
 #include <linux/syscalls.h>
 #include <linux/syscore_ops.h>
@@ -24,8 +26,7 @@
  */
 
 static int C_A_D = 1;
-struct pid *cad_pid;
-EXPORT_SYMBOL(cad_pid);
+struct pid __rcu *cad_pid;
 
 #if defined(CONFIG_ARM)
 #define DEFAULT_REBOOT_MODE		= REBOOT_HARD
@@ -1288,10 +1289,14 @@ static int proc_do_cad_pid(const struct
 {
 	struct ctl_table tmp_table = *table;
 	struct pid *new_pid;
+	struct pid *old_pid;
 	pid_t tmp_pid;
 	int r;
 
-	tmp_pid = pid_vnr(cad_pid);
+	rcu_read_lock();
+	tmp_pid = pid_vnr(rcu_dereference(cad_pid));
+	rcu_read_unlock();
+
 	tmp_table.data = &tmp_pid;
 
 	r = proc_dointvec(&tmp_table, write, buffer, lenp, ppos);
@@ -1302,7 +1307,13 @@ static int proc_do_cad_pid(const struct
 	if (!new_pid)
 		return -ESRCH;
 
-	put_pid(xchg(&cad_pid, new_pid));
+	old_pid = unrcu_pointer(xchg(&cad_pid, RCU_INITIALIZER(new_pid)));
+	/*
+	 * Wait for cad_pid readers before put_pid().  We cannot use
+	 * call_rcu() here because free_pid() already owns pid->rcu.
+	 */
+	synchronize_rcu();
+	put_pid(old_pid);
 	return 0;
 }
 
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1936,6 +1936,18 @@ int kill_pid(struct pid *pid, int sig, i
 }
 EXPORT_SYMBOL(kill_pid);
 
+int kill_cad_pid(int sig, int priv)
+{
+	int ret;
+
+	rcu_read_lock();
+	ret = kill_pid(rcu_dereference(cad_pid), sig, priv);
+	rcu_read_unlock();
+
+	return ret;
+}
+EXPORT_SYMBOL(kill_cad_pid);
+
 #ifdef CONFIG_POSIX_TIMERS
 /*
  * These functions handle POSIX timer signals. POSIX timers use


