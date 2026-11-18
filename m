Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056647;
	b=X2F2sK2g6YzOGTKPKn7bGn22/cH55nXl8tPEJrFAMMpk1BbLbYRIls1N3lafLBCjCRPB
	 DFD5/sKJVRh0CCRNp736tPJ9ahfVjd7JX7lTJuQGrGgYq5ipEH8mY9O6kthNvHK08L+b8
	 FkFyivZphPgSk5pkFDjNlN2p1XpxXDxdlnz79ABVnfOt74nRibs+MkhxLabQq9LTM/46m
	 QDPccAg9JwL0WBGN6o1D35lgUnfbg+k/N1sYUkkcwkIyVw1Kwe778Dl0d+r105TV7dbZZ
	 BGyujHao3n/tfXt4k/j8f3NOtf5ifU0ZAWuKTsleASCxz03dF4DW0C2BkzGyjRm6S8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056647;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B0d+mt6OBLLapUumHSfBIoohBqvImx2ob0b8CM1nWCo=;
	b=ysQL3NKSn5zYWwCLC85qUIdIuTYueOsD/l3844DEOkDeTMqu4v/18YumtkcWjpz9ke1I
	 ySOiE8KuirPs2lbvG5JMN63QFBxDMHmJx8EOQw2ZdwdQLgv1AyVnM/1MZC3lhBC/WNAea
	 4tcRY++ZZtnRlZpXhW4YEk9JvlRrwyOouS7eF/TBqvSBpxFbbZd/BnHvsTUc0u+IFu280
	 iS95417RGXtJu0kovZBHxNFjSxPTZXdbzfJptptrv8Yi0TZzD1lkHoF3ZX4c/X3J/I/vl
	 /JO6mpNsJAV5NF1X56Q0EqHDeqcsS+g+RV+AFhCUG+/Y+702JkZ/pmx54aoZyqvYcYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eI3pvQVS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184F6606A320;
	Thu, 19 Nov 2026 02:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eI3pvQVS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0A81F000C5;
	Thu, 19 Nov 2026 02:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056647;
	bh=B0d+mt6OBLLapUumHSfBIoohBqvImx2ob0b8CM1nWCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eI3pvQVStCoWmDu7zvS/6XUZXj6i9iXrWNvvzmqiCs/CqsZitw5g3yF6Co7oaTsfI
	 heSule2tvK4k7zlq0Hc0TWXkF81xH79Uwzy1FSTdMklYGMC0fXuqWw4Nfd8uBfUr2L
	 JqvnXNyP39YjvXv9E702i2lNZKgXnLNkmdy+OjIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	tangmeng <tangmeng@uniontech.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2062/2214] timers: Move timer sysctl into the timer code
Date: Wed, 18 Nov 2026 16:02:18 +0100
Message-ID: <20261118150133.150169833@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 00ee960be028b..9162f275819a7 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -217,14 +217,6 @@ extern void init_timers(void);
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
index ac16c3084c96c..869f05d418ccf 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2588,17 +2588,6 @@ static struct ctl_table kern_table[] = {
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
index fdf178204775d..c943f0c123aa7 100644
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



