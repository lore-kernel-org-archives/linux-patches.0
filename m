Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC037A
	for <patches@lists.linux.dev>; Fri, 15 Apr 2022 21:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=ha38xYsfejbNBgKN9o0wUY9R1DO01ebDOCHytWPPevo=; b=GjZl1h1L1iVuWJIbmNFwpHu0Zu
	UQ8E8pgyj8GGMiBLALRDt9I2MhQ5xumTAS9ZA/7UATWuMTYQKqRPtyWYT7yYepz18wN9DIGLvnypv
	uDo/QYN0jQhKnm8rJ/DCotbg1H1xYcC6xxVfd4fsQZmrTV8Cd88TV0e4hhwyxQMSZXxvTWD5Wld9t
	ayB/2YXkeK1hu2B+C7H2nDz0IEexHPXYhn//c1XyUHdPlCdsIkt1GLloA67v0vPrQHoZ68A5UNAUa
	6Rj1k1i6lRuzwyKClPrsqiI/ri/of/Lo6xvPsLgrdYk+xD382Esvu32HnPeu+iRmYiVTi2hCDKR2x
	4tcpV6VQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nfTtE-00BRMI-5P; Fri, 15 Apr 2022 21:54:04 +0000
Date: Fri, 15 Apr 2022 14:54:04 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: YueHaibing <yuehaibing@huawei.com>, mingo@redhat.com,
	xiaowei66@huawei.com, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH sysctl-next] ftrace: fix building with SYSCTL=n but
 DYNAMIC_FTRACE=y
Message-ID: <YlnpfHuZGC8H0iNZ@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

One can enable dyanmic tracing but disable sysctls.
When this is doen we get the compile kernel warning:

  CC      kernel/trace/ftrace.o
kernel/trace/ftrace.c:3086:13: warning: ‘ftrace_shutdown_sysctl’ defined
but not used [-Wunused-function]
 3086 | static void ftrace_shutdown_sysctl(void)
      |             ^~~~~~~~~~~~~~~~~~~~~~
kernel/trace/ftrace.c:3068:13: warning: ‘ftrace_startup_sysctl’ defined
but not used [-Wunused-function]
 3068 | static void ftrace_startup_sysctl(void)

When CONFIG_DYNAMIC_FTRACE=n the ftrace_startup_sysctl() and
routines ftrace_shutdown_sysctl() still compiles, so these
are actually more just used for when SYSCTL=y.

Fix this then by just moving these routines to when sysctls
are enabled.

Fixes: 7cde53da38a3 ("ftrace: move sysctl_ftrace_enabled to ftrace.c")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---

Steven,

As with the other fixes I can take this in through sysctl-next if you
are OK with that, please let me know.

 kernel/trace/ftrace.c | 71 +++++++++++++++++++++----------------------
 1 file changed, 34 insertions(+), 37 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index db8d553728b6..d9424fd9a183 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3065,40 +3065,6 @@ int ftrace_shutdown(struct ftrace_ops *ops, int command)
 	return 0;
 }
 
-static void ftrace_startup_sysctl(void)
-{
-	int command;
-
-	if (unlikely(ftrace_disabled))
-		return;
-
-	/* Force update next time */
-	saved_ftrace_func = NULL;
-	/* ftrace_start_up is true if we want ftrace running */
-	if (ftrace_start_up) {
-		command = FTRACE_UPDATE_CALLS;
-		if (ftrace_graph_active)
-			command |= FTRACE_START_FUNC_RET;
-		ftrace_startup_enable(command);
-	}
-}
-
-static void ftrace_shutdown_sysctl(void)
-{
-	int command;
-
-	if (unlikely(ftrace_disabled))
-		return;
-
-	/* ftrace_start_up is true if ftrace is running */
-	if (ftrace_start_up) {
-		command = FTRACE_DISABLE_CALLS;
-		if (ftrace_graph_active)
-			command |= FTRACE_STOP_FUNC_RET;
-		ftrace_run_update_code(command);
-	}
-}
-
 static u64		ftrace_update_time;
 unsigned long		ftrace_update_tot_cnt;
 unsigned long		ftrace_number_of_pages;
@@ -7267,9 +7233,6 @@ core_initcall(ftrace_nodyn_init);
 static inline int ftrace_init_dyn_tracefs(struct dentry *d_tracer) { return 0; }
 static inline void ftrace_startup_all(int command) { }
 
-# define ftrace_startup_sysctl()	do { } while (0)
-# define ftrace_shutdown_sysctl()	do { } while (0)
-
 static void ftrace_update_trampoline(struct ftrace_ops *ops)
 {
 }
@@ -7910,6 +7873,40 @@ int unregister_ftrace_function(struct ftrace_ops *ops)
 EXPORT_SYMBOL_GPL(unregister_ftrace_function);
 
 #ifdef CONFIG_SYSCTL
+static void ftrace_startup_sysctl(void)
+{
+	int command;
+
+	if (unlikely(ftrace_disabled))
+		return;
+
+	/* Force update next time */
+	saved_ftrace_func = NULL;
+	/* ftrace_start_up is true if we want ftrace running */
+	if (ftrace_start_up) {
+		command = FTRACE_UPDATE_CALLS;
+		if (ftrace_graph_active)
+			command |= FTRACE_START_FUNC_RET;
+		ftrace_startup_enable(command);
+	}
+}
+
+static void ftrace_shutdown_sysctl(void)
+{
+	int command;
+
+	if (unlikely(ftrace_disabled))
+		return;
+
+	/* ftrace_start_up is true if ftrace is running */
+	if (ftrace_start_up) {
+		command = FTRACE_DISABLE_CALLS;
+		if (ftrace_graph_active)
+			command |= FTRACE_STOP_FUNC_RET;
+		ftrace_run_update_code(command);
+	}
+}
+
 static bool is_permanent_ops_registered(void)
 {
 	struct ftrace_ops *op;
-- 
2.30.2

