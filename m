Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EFE332EA7;
	Sat, 30 May 2026 17:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163921; cv=none; b=enilvbwfuaKNxVU84IYTUTaSFRFF7LfvlFPdithDUGffxn8iQ/wi4plDPHxLgXnFFsxXYyAE5togBpmM8IR1fNuVWN4RPmn6deX/66aevFjgAJJLE3u1u1AZATk7iFDXUfLV3iZiNh1vLMxAnX6F4rQCMNtoxOesUH1rRQYR+F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163921; c=relaxed/simple;
	bh=lmVEf9p58E3zLk3G607EQGjPLRyp4PK18cQZwQZgJq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=noXLoi3eY3560Ir5xnYnFxIT2muL4vD73jhkQLVyg3cLTFrIJlnr5itxC2Z5+xxdOv86k7GcK32oQHMgASWExDNgH+vVE1STIvyRWV5xX7zOv9T7u+LpSNOvC6K1hq8rkeKnqb0Oogh9cm5KyjvxSy+Y+f7T4wOLf0y/rIVzvX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dlw43Ckr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dlw43Ckr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5568B1F00893;
	Sat, 30 May 2026 17:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163920;
	bh=ZJujABl5rm7BGQD5tX97CLQQSywD9D99/PnMk5Yqdeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dlw43CkrdCInT2xHa7+w6LDHvKIEmVZTmXEDAJYaj9ExHlnq0jAPp9jjQjnfwE0ku
	 eNHSlZEh3hmGiukRkA0GmujFGjGtEuJ7iW1u5fDEGYDUr2JtY3sGUKvKsPoRW/WWCS
	 t18pmHJ+ku2Z3W8KmPQF4zkZVg92pLdny0Q6cdks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 402/776] module: Fix freeing of charp module parameters when CONFIG_SYSFS=n
Date: Sat, 30 May 2026 18:01:56 +0200
Message-ID: <20260530160250.895366720@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 kernel/module.c             |  4 ++--
 kernel/params.c             | 27 ++++++++++++++++++---------
 3 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 061e19c94a6bc..f73ca4d62683b 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -392,14 +392,9 @@ extern char *parse_args(const char *name,
 				     const char *doing, void *arg));
 
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
diff --git a/kernel/module.c b/kernel/module.c
index 07fa34461fa2f..b6409b0032b85 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2179,7 +2179,7 @@ static void free_module(struct module *mod)
 	module_unload_free(mod);
 
 	/* Free any allocated parameters. */
-	destroy_params(mod->kp, mod->num_kp);
+	module_destroy_params(mod->kp, mod->num_kp);
 
 	if (is_livepatch_module(mod))
 		free_module_elf(mod);
@@ -4166,7 +4166,7 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	mod_sysfs_teardown(mod);
  coming_cleanup:
 	mod->state = MODULE_STATE_GOING;
-	destroy_params(mod->kp, mod->num_kp);
+	module_destroy_params(mod->kp, mod->num_kp);
 	blocking_notifier_call_chain(&module_notify_list,
 				     MODULE_STATE_GOING, mod);
 	klp_module_going(mod);
diff --git a/kernel/params.c b/kernel/params.c
index 9a76f556b898a..1233673b42ecc 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -743,15 +743,6 @@ void module_param_sysfs_remove(struct module *mod)
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
@@ -971,3 +962,21 @@ static int __init param_sysfs_init(void)
 subsys_initcall(param_sysfs_init);
 
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



