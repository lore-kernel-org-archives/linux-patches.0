Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455B428F3
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0AC6C4339B;
	Mon, 30 Jan 2023 14:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088129;
	bh=vJcNEeWJoJG4rsEQ6nzJocth9pgRe8wWCkOZHpZOE2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VJpuxngPBy1s6B1YO11qyGTreMXYjE4igMgyX8NyWQENCwZyteYxHejW56maV0Y7z
	 6bw8aHNF/vfYlaBI2fHaQZfgaqfdSLty+I5TmFfyy4GnUhwDMIH+0/1fFgF6D65Re7
	 l/CWaS1jzZPXJU9JKAi5fAq98yacuryrKm8kvXR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	tangmeng <tangmeng@uniontech.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Eric Biggers <ebiggers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 124/204] kernel/panic: move panic sysctls to its own file
Date: Mon, 30 Jan 2023 14:51:29 +0100
Message-Id: <20230130134321.960740438@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: tangmeng <tangmeng@uniontech.com>

commit 9df918698408fd914493aba0b7858fef50eba63a upstream.

kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
dishes, this makes it very difficult to maintain.

To help with this maintenance let's start by moving sysctls to places
where they actually belong.  The proc sysctl maintainers do not want to
know what sysctl knobs you wish to add for your own piece of code, we
just care about the core logic.

All filesystem syctls now get reviewed by fs folks. This commit
follows the commit of fs, move the oops_all_cpu_backtrace sysctl to
its own file, kernel/panic.c.

Signed-off-by: tangmeng <tangmeng@uniontech.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/panic.h |  6 ------
 kernel/panic.c        | 26 +++++++++++++++++++++++++-
 kernel/sysctl.c       | 11 -----------
 3 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/include/linux/panic.h b/include/linux/panic.h
index f5844908a089..e71161da69c4 100644
--- a/include/linux/panic.h
+++ b/include/linux/panic.h
@@ -15,12 +15,6 @@ extern void oops_enter(void);
 extern void oops_exit(void);
 extern bool oops_may_print(void);
 
-#ifdef CONFIG_SMP
-extern unsigned int sysctl_oops_all_cpu_backtrace;
-#else
-#define sysctl_oops_all_cpu_backtrace 0
-#endif /* CONFIG_SMP */
-
 extern int panic_timeout;
 extern unsigned long panic_print;
 extern int panic_on_oops;
diff --git a/kernel/panic.c b/kernel/panic.c
index cefd7d82366f..5ee281b996f9 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -42,7 +42,9 @@
  * Should we dump all CPUs backtraces in an oops event?
  * Defaults to 0, can be changed via sysctl.
  */
-unsigned int __read_mostly sysctl_oops_all_cpu_backtrace;
+static unsigned int __read_mostly sysctl_oops_all_cpu_backtrace;
+#else
+#define sysctl_oops_all_cpu_backtrace 0
 #endif /* CONFIG_SMP */
 
 int panic_on_oops = CONFIG_PANIC_ON_OOPS_VALUE;
@@ -71,6 +73,28 @@ ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
 
 EXPORT_SYMBOL(panic_notifier_list);
 
+#if defined(CONFIG_SMP) && defined(CONFIG_SYSCTL)
+static struct ctl_table kern_panic_table[] = {
+	{
+		.procname       = "oops_all_cpu_backtrace",
+		.data           = &sysctl_oops_all_cpu_backtrace,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_minmax,
+		.extra1         = SYSCTL_ZERO,
+		.extra2         = SYSCTL_ONE,
+	},
+	{ }
+};
+
+static __init int kernel_panic_sysctls_init(void)
+{
+	register_sysctl_init("kernel", kern_panic_table);
+	return 0;
+}
+late_initcall(kernel_panic_sysctls_init);
+#endif
+
 static long no_blink(int state)
 {
 	return 0;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 34ce5953dbb0..928798f89ca1 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2220,17 +2220,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
-#ifdef CONFIG_SMP
-	{
-		.procname	= "oops_all_cpu_backtrace",
-		.data		= &sysctl_oops_all_cpu_backtrace,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-#endif /* CONFIG_SMP */
 	{
 		.procname	= "pid_max",
 		.data		= &pid_max,
-- 
2.39.0



