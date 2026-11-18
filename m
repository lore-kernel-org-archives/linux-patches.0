Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043920;
	b=GegjH7JdAFrQid3d2BErtdRipXP7qk1uiJNNdvN3dQpfccqICfUZV+ot9Novc3uqM6JZ
	 55mJstptqiA9KHEwYD0hIIYsv6kEucZ4QIusFnjDkNChXjLNUlWpae3NJ6SLlolQX2UXv
	 FGvZar7C+zFSpM8VX2NMdgmaEdflatEvFvOcHCFOlgEhj7uOupEmpHhvB/jWnVGuazh11
	 5uwWDkuMBiTkrHS9u5akzrrRdyw5fUHB3Gz147dhyOktIhoTkUstbdnAAAoHrmv6Gx1p6
	 HWoNNrxUXF38mAjaOhRl6FRarvJND8WKwafznkacssqS9RjrTF0MRTLQRSnhbffVMuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043920;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9nZz5oizFDrTVdUIhF86Hv37FfcIDZZxtNQifQrhHE4=;
	b=b0aM4FnRhxGwP59rD59ILhuYR5oxNDjlEY/85A0fNaYO4Q2RQI92xIyv8gcvin0mNSA9
	 8EyJgukI2UqJLud0V4ymKlga7iAtMWyYSM02qW3mkEllF+6CicM6ty3LhQXwGkX1LLn+4
	 rpejjkPf8W6GxWWi749+oJyxynsm545MZoYEHw9fSq5pcgMDSakp4Pvy0+89IgsbMIq6e
	 UwLQyOiyhCtEoCnorQC5bz8d07WW2iXG0CQ2JyjvZ7yJ5y6Yn6tM1bMfpvO2tFPv4/qOW
	 aCYFEKC2EE9Tr5V24MBJzkRo253S3hUpyIzZPkOjGMUtzptl1YTSLqHSUKkr02gRCrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LfhYc3oP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C97606A32A;
	Wed, 18 Nov 2026 23:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LfhYc3oP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D33B1F000C4;
	Wed, 18 Nov 2026 23:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043920;
	bh=9nZz5oizFDrTVdUIhF86Hv37FfcIDZZxtNQifQrhHE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LfhYc3oPmJqafpWCVL1fghqqU5esHe5r4GLhapWK0d/KSWlPxZAQikbaggC6sKRVZ
	 uK+k01hTYoewvVv/gqIGSnt2zvV6Arkbj/RycK3Q4KgLkSyl+ws8PnGIh3O2TX7he5
	 0otjg2UzQ6heGhmzipdkaSEEvfVbjsatYVWgCElQ=
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
Subject: [PATCH 6.1 0383/2857] reboot: fix cad_pid use-after-free race
Date: Wed, 18 Nov 2026 15:23:37 +0100
Message-ID: <20261118150215.195095834@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang (Microsoft) <blbllhy@gmail.com>

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
[ sashal: Moved proc_do_cad_pid() changes into kernel/sysctl.c with the older non-const ctl_table API, since there is no kern_reboot_table in kernel/reboot.c, and adjusted context in sched.h and signal.c. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h        |  2 +-
 include/linux/sched/signal.h |  5 +----
 init/main.c                  |  2 +-
 kernel/reboot.c              |  5 +++--
 kernel/signal.c              | 12 ++++++++++++
 kernel/sysctl.c              | 13 +++++++++++--
 6 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3cd897f572af0..50fd0b4e7dd9e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1724,7 +1724,7 @@ static inline int is_global_init(struct task_struct *tsk)
 	return task_tgid_nr(tsk) == 1;
 }
 
-extern struct pid *cad_pid;
+extern struct pid __rcu *cad_pid;
 
 /*
  * Per process flags
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 66e125dc12aaa..85f7a09fd1288 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -591,10 +591,7 @@ static inline sigset_t *sigmask_to_save(void)
 	return res;
 }
 
-static inline int kill_cad_pid(int sig, int priv)
-{
-	return kill_pid(cad_pid, sig, priv);
-}
+int kill_cad_pid(int sig, int priv);
 
 /* These can be the second arg to send_sig_info/send_group_sig_info.  */
 #define SEND_SIG_NOINFO ((struct kernel_siginfo *) 0)
diff --git a/init/main.c b/init/main.c
index 6acfd5a78bd7a..78d0e33cb6ee6 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1575,7 +1575,7 @@ static noinline void __init kernel_init_freeable(void)
 	 */
 	set_mems_allowed(node_states[N_MEMORY]);
 
-	cad_pid = get_pid(task_pid(current));
+	rcu_assign_pointer(cad_pid, get_pid(task_pid(current)));
 
 	smp_prepare_cpus(setup_max_cpus);
 
diff --git a/kernel/reboot.c b/kernel/reboot.c
index 6ebef11c88760..f4a2721e47724 100644
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
diff --git a/kernel/signal.c b/kernel/signal.c
index 1c169fa294860..73745319f1c70 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1937,6 +1937,18 @@ int kill_pid(struct pid *pid, int sig, int priv)
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
 /*
  * These functions support sending signals using preallocated sigqueue
  * structures.  This is needed "because realtime applications cannot
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index eaa2691caf492..5dd6fd4b48c81 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1348,10 +1348,13 @@ static int proc_do_cad_pid(struct ctl_table *table, int write, void *buffer,
 		size_t *lenp, loff_t *ppos)
 {
 	struct pid *new_pid;
+	struct pid *old_pid;
 	pid_t tmp;
 	int r;
 
-	tmp = pid_vnr(cad_pid);
+	rcu_read_lock();
+	tmp = pid_vnr(rcu_dereference(cad_pid));
+	rcu_read_unlock();
 
 	r = __do_proc_dointvec(&tmp, table, write, buffer,
 			       lenp, ppos, NULL, NULL);
@@ -1362,7 +1365,13 @@ static int proc_do_cad_pid(struct ctl_table *table, int write, void *buffer,
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
 
-- 
2.53.0



