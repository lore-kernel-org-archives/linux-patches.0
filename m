Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062011;
	b=S8f1iKFTYTWmkLoMbqgsWpD4WAmtGCg7+Cqx/jcxeBaFwngrYM2IOiOnlBq2ONMAgvVN
	 dOlDJDm89YJlPcrt8037ZeF7wKdXw0SL5e3mukUdBv/i5fQiLprBJuCJutjsGqap1pcOh
	 jxF4+JRyw3CzgB7kUaw7RMgsG7kGxgdQNluDj8JM/KsZ8YklysTGx6gpDM3mkkqMXIyPD
	 CRFsKsEoC5UaqL2ziVj91HXzVrPRjahyx0z52EGLedM3iT5UvpxVfy7FXeDxmF4vxnhNO
	 JI3zaGqT+iBRQHTdfgU2QRvNJw9fSJQqbaxiP8iklXUELskEvp1uCtBXhJauojH0l9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062011;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3YXxmZX4l1kyP5HTX3h8KNOkMGQG7NHNYCtSDOi4q+s=;
	b=ag84JUEfzy7c36EFYFtuiEGqY5jEbc0hbjTZW+qs9GAfJlxvUcXwUqcjD3pfb/jJMnD1
	 NaPnurAYGlNaKxOhQJ4ce3c6P1k628xx6KsyJ6pen3eNlHAxTS5Ajq+Ernb538j9Tr9Q7
	 ZZ+OLJuP8ahxoEQA3SAybq6vhx2aU+R+T6JOhVyhsSXW1ubXULuRiF7238Czt1WFiJkA9
	 8eVUkWgdjNcOzX5yx3TK7qhAmKvs7c9rKjbGava8RPDMBGWSRzHviEK09wGnaFntZKCBv
	 AtgTLN8MJvxSra1bwMvMou9oCVQZB/60vnAPzqjSd5Tu2FbrHuQi3/EOHzBM2lxDuiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jj4T5i4V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6FE606A326;
	Thu, 19 Nov 2026 04:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jj4T5i4V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EF01F000C5;
	Thu, 19 Nov 2026 04:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062011;
	bh=3YXxmZX4l1kyP5HTX3h8KNOkMGQG7NHNYCtSDOi4q+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jj4T5i4VMuy+pF3ZHnk/t4m69uGoxabI8Crhiu4V4QIFIRp93gzPX3o9pXM6fiwqk
	 MSyufi8JjQM//7/neD8N+QhwQ/3bSY4tKcGBLjMkymWkQ1Wq4ee9Ktxju73g+RUXdr
	 PyPMkhbVRq409w7ZD6M/FGvDay74qI/kR0quPD+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	tangmeng <tangmeng@uniontech.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1731/1848] timers: Move timer sysctl into the timer code
Date: Wed, 18 Nov 2026 16:02:49 +0100
Message-ID: <20261118150032.050795140@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: tangmeng <tangmeng@uniontech.com>

[ Upstream commit efaa0227f6c6a5073951b20cf2f8c63c4155306c ]

This is part of the effort to reduce kernel/sysctl.c to only contain the
core logic.

Signed-off-by: tangmeng <tangmeng@uniontech.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20220215065019.7520-1-tangmeng@uniontech.com
Stable-dep-of: e7cad586d732 ("timers: Clear pending_map on CPU hotplug")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/timer.h |  8 -------
 kernel/sysctl.c       | 11 ---------
 kernel/time/timer.c   | 53 +++++++++++++++++++++++++++++++------------
 3 files changed, 38 insertions(+), 34 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index a3d04c4f1263a..cdfd7d138da6a 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -205,14 +205,6 @@ extern void run_local_timers(void);
 struct hrtimer;
 extern enum hrtimer_restart it_real_fn(struct hrtimer *);
 
-#if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ_COMMON)
-struct ctl_table;
-
-extern unsigned int sysctl_timer_migration;
-int timer_migration_handler(struct ctl_table *table, int write,
-			    void *buffer, size_t *lenp, loff_t *ppos);
-#endif
-
 unsigned long __round_jiffies(unsigned long j, int cpu);
 unsigned long __round_jiffies_relative(unsigned long j, int cpu);
 unsigned long round_jiffies(unsigned long j);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c2870c9cae14a..2bad36c33c1b2 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2735,17 +2735,6 @@ static struct ctl_table kern_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
-#if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ_COMMON)
-	{
-		.procname	= "timer_migration",
-		.data		= &sysctl_timer_migration,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= timer_migration_handler,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-#endif
 #ifdef CONFIG_BPF_SYSCALL
 	{
 		.procname	= "unprivileged_bpf_disabled",
diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index f12201988af47..2b1afc00e3184 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -44,6 +44,7 @@
 #include <linux/slab.h>
 #include <linux/compat.h>
 #include <linux/random.h>
+#include <linux/sysctl.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -223,7 +224,7 @@ static void timer_update_keys(struct work_struct *work);
 static DECLARE_WORK(timer_update_work, timer_update_keys);
 
 #ifdef CONFIG_SMP
-unsigned int sysctl_timer_migration = 1;
+static unsigned int sysctl_timer_migration = 1;
 
 DEFINE_STATIC_KEY_FALSE(timers_migration_enabled);
 
@@ -234,7 +235,42 @@ static void timers_update_migration(void)
 	else
 		static_branch_disable(&timers_migration_enabled);
 }
-#else
+
+#ifdef CONFIG_SYSCTL
+static int timer_migration_handler(struct ctl_table *table, int write,
+			    void *buffer, size_t *lenp, loff_t *ppos)
+{
+	int ret;
+
+	mutex_lock(&timer_keys_mutex);
+	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	if (!ret && write)
+		timers_update_migration();
+	mutex_unlock(&timer_keys_mutex);
+	return ret;
+}
+
+static struct ctl_table timer_sysctl[] = {
+	{
+		.procname	= "timer_migration",
+		.data		= &sysctl_timer_migration,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= timer_migration_handler,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+	{}
+};
+
+static int __init timer_sysctl_init(void)
+{
+	register_sysctl("kernel", timer_sysctl);
+	return 0;
+}
+device_initcall(timer_sysctl_init);
+#endif /* CONFIG_SYSCTL */
+#else /* CONFIG_SMP */
 static inline void timers_update_migration(void) { }
 #endif /* !CONFIG_SMP */
 
@@ -251,19 +287,6 @@ void timers_update_nohz(void)
 	schedule_work(&timer_update_work);
 }
 
-int timer_migration_handler(struct ctl_table *table, int write,
-			    void *buffer, size_t *lenp, loff_t *ppos)
-{
-	int ret;
-
-	mutex_lock(&timer_keys_mutex);
-	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
-	if (!ret && write)
-		timers_update_migration();
-	mutex_unlock(&timer_keys_mutex);
-	return ret;
-}
-
 static inline bool is_timers_nohz_active(void)
 {
 	return static_branch_unlikely(&timers_nohz_active);
-- 
2.53.0



