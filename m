Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B359F36B059;
	Wed, 20 May 2026 16:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294653; cv=none; b=bDhOkzc3DYxfbZd/lGUpcH0rs0gRHG2VunSi09miiqGUXagvwFzzPFKFdRAGZfaGsKaWOx38FLCUT2iDYQCfmVsCJ5wlgQFssuMAtHohxNZGf6JY1H1++gi89h9eOMCZNqoyWYxIFQazHRqBrW3csE42HlBy/3cqNh92IVMv3T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294653; c=relaxed/simple;
	bh=lrQTJE/d3DDKM+ws4ghz5V8PEB9Ca7+F4Ccd/5dtxPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pag8sSxefPeyPltDmoMMjmxpZoD5OcVd/M76iYj3j9+XxuJ5D5NABXINE8y4FT12JG9AxiqrwVEp8kn2wuHHbEKVHwNqU4iTM86YsRIaW1qeWNij2XC5s2dDNAMTKfH5nm6eQwgoMqLssZn3KR7uwXBsio2bWMvs9nKiehUcBVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CMAjHdTF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CMAjHdTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B7C1F000E9;
	Wed, 20 May 2026 16:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294650;
	bh=YTm/VOWWSvQE2+qs5EdSAJqFx5Hftr9EFmXQBgfTOf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CMAjHdTFTsCZcaaQkyqswbWKWpIaeUrTcdWQbbx9aYug0qZBXDOaGy73yIuxaB2zf
	 a39gZ+Sc+ej8k0WircUL+yj/QcskUWF+0T6vNmoUy5+QkMYzY5kR8dkk3T38XqEgFY
	 dcu2noySyMOR+Wkt6rhKKpgOxIDp9d1PMtUUEMS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0083/1146] module: Fix freeing of charp module parameters when CONFIG_SYSFS=n
Date: Wed, 20 May 2026 18:05:33 +0200
Message-ID: <20260520162150.230930138@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 7d22d4c4ea2e7..8667f72503d95 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -426,14 +426,9 @@ extern char *parse_args(const char *name,
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
index c3ce106c70af1..ef2e2130972fe 100644
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
index 7188a12dbe864..c6a354d54213d 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -745,15 +745,6 @@ void module_param_sysfs_remove(struct module *mod)
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
@@ -985,3 +976,21 @@ static int __init param_sysfs_builtin_init(void)
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



