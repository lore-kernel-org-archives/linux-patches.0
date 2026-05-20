Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D8135C1A0;
	Wed, 20 May 2026 17:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297538; cv=none; b=ok+SEAyf/ipBRUdm7C6SOldnAT59LibCV4ET4Bo+buzThRtk/JF7/9pGZ49+TcGpofQsZ10HpLNuqExMiwDd7hs58DxUaJ01ycUdD2lF9Z51InP6m6aOFCXIx8DTZa7cw8NSGLQRY5RHWxyaU4HDFey/Z7gtD8Zk/nxMTO47ksw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297538; c=relaxed/simple;
	bh=pVcq1nDvtkvNK+1fih0BtQRZOt5/YkneZ0GCp2y/PvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sft/Qrul4ME9JlVrmOwi+3BYm85RbZLDos1ubRw7QX5LVRQUTXc1sRdAJGFY3316FBWyAa9eqOviqlIdPN1Sa+g6Ly81EUR6iKglZDhgmjxdYOnobD6izyx6pLXgjQlcX1it6OCgqxpvTrjtGb6GLo6S/c0XfzO9/gwMAxi8QPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yPYtaRSI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yPYtaRSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26FD51F000E9;
	Wed, 20 May 2026 17:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297537;
	bh=AO8MQOYjIr0chSIigcyx2kVLgZhkDKeBvaokTVNAb3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yPYtaRSI4XRAsV9h8DYrWp3Z0+o+5OHNeikFW9q14gGYi9FvXUky/0eAC26zGwnMR
	 BoZWBNSBBUMob91nKkcS+N6byEaR7XijGC0kJU+8OBuKfV1/I9SF//LdXAwvlRX1Wl
	 /jgUZ6tKjapTCSb2HKWtEZ/JClCMN0XwDeMRDr3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 068/957] module: Fix freeing of charp module parameters when CONFIG_SYSFS=n
Date: Wed, 20 May 2026 18:09:11 +0200
Message-ID: <20260520162136.039373598@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Pavlu <petr.pavlu@suse.com>

[ Upstream commit deffe1edba626d474fef38007c03646ca5876a0e ]

When setting a charp module parameter, the param_set_charp() function
allocates memory to store a copy of the input value. Later, when the module
is potentially unloaded, the destroy_params() function is called to free
this allocated memory.

However, destroy_params() is available only when CONFIG_SYSFS=y, otherwise
only a dummy variant is present. In the unlikely case that the kernel is
configured with CONFIG_MODULES=y and CONFIG_SYSFS=n, this results in
a memory leak of charp values when a module is unloaded.

Fix this issue by making destroy_params() always available when
CONFIG_MODULES=y. Rename the function to module_destroy_params() to clarify
that it is intended for use by the module loader.

Fixes: e180a6b7759a ("param: fix charp parameters set via sysfs")
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/moduleparam.h | 11 +++--------
 kernel/module/main.c        |  4 ++--
 kernel/params.c             | 27 ++++++++++++++++++---------
 3 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 6907aedc4f748..77775fd821407 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -414,14 +414,9 @@ extern char *parse_args(const char *name,
 		      void *arg, parse_unknown_fn unknown);
 
 /* Called by module remove. */
-#ifdef CONFIG_SYSFS
-extern void destroy_params(const struct kernel_param *params, unsigned num);
-#else
-static inline void destroy_params(const struct kernel_param *params,
-				  unsigned num)
-{
-}
-#endif /* !CONFIG_SYSFS */
+#ifdef CONFIG_MODULES
+void module_destroy_params(const struct kernel_param *params, unsigned int num);
+#endif
 
 /* All the helper functions */
 /* The macros to do compile-time type checking stolen from Jakub
diff --git a/kernel/module/main.c b/kernel/module/main.c
index 66d4efbddfffe..3745cd02c8479 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1408,7 +1408,7 @@ static void free_module(struct module *mod)
 	module_unload_free(mod);
 
 	/* Free any allocated parameters. */
-	destroy_params(mod->kp, mod->num_kp);
+	module_destroy_params(mod->kp, mod->num_kp);
 
 	if (is_livepatch_module(mod))
 		free_module_elf(mod);
@@ -3519,7 +3519,7 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	mod_sysfs_teardown(mod);
  coming_cleanup:
 	mod->state = MODULE_STATE_GOING;
-	destroy_params(mod->kp, mod->num_kp);
+	module_destroy_params(mod->kp, mod->num_kp);
 	blocking_notifier_call_chain(&module_notify_list,
 				     MODULE_STATE_GOING, mod);
 	klp_module_going(mod);
diff --git a/kernel/params.c b/kernel/params.c
index 7c2242f64bf08..8942884e21c43 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -746,15 +746,6 @@ void module_param_sysfs_remove(struct module *mod)
 }
 #endif
 
-void destroy_params(const struct kernel_param *params, unsigned num)
-{
-	unsigned int i;
-
-	for (i = 0; i < num; i++)
-		if (params[i].ops->free)
-			params[i].ops->free(params[i].arg);
-}
-
 struct module_kobject * __init_or_module
 lookup_or_create_module_kobject(const char *name)
 {
@@ -986,3 +977,21 @@ static int __init param_sysfs_builtin_init(void)
 late_initcall(param_sysfs_builtin_init);
 
 #endif /* CONFIG_SYSFS */
+
+#ifdef CONFIG_MODULES
+
+/*
+ * module_destroy_params - free all parameters for one module
+ * @params: module parameters (array)
+ * @num: number of module parameters
+ */
+void module_destroy_params(const struct kernel_param *params, unsigned int num)
+{
+	unsigned int i;
+
+	for (i = 0; i < num; i++)
+		if (params[i].ops->free)
+			params[i].ops->free(params[i].arg);
+}
+
+#endif /* CONFIG_MODULES */
-- 
2.53.0



