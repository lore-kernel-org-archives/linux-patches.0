Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4085F360EE1;
	Sat, 12 Sep 2026 09:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206639; cv=none; b=rE2i/42p7EHBQCNyU0U/qc2cxlUrUtGR3w8gFP8QuSW+z20DDofX3w0weVK7r6nhZ+Jb+2xgEHnJl7H+GdmvgYNdZr4R/Wt2Xe2vCuS9Ss/gzXlFZ8pfnzyZNFXqeY5Y+NFDDQS100bcYWk4ZW0WpP3ZkUYZLelfZTxyAH51xwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206639; c=relaxed/simple;
	bh=LYsnDebREs0hzBuSsZcfNUzIOmwOpJiiJeUTrZK86wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NqLeFwlEIUOl3RKt/aP5WN0KWdtUC19pYrSH4gumxPlY60u7jKvXV5735YVcMCpt0G12WuCKcERGCsqSWbkXSPzNLuCWLWKlF0E7S44ix47bP2BWqxdKKFtu3Z8rPRUBZHKewlQGhBOAEab1gJit8/d1jfJ2bLjI2lMhYCjmau0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m1/BppZ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m1/BppZ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB461F000FF;
	Sat, 12 Sep 2026 09:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206638;
	bh=KrFJn8z+5zL2KtZ+BJfWj0IKP3RfHXHYSXw0i6xvaHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m1/BppZ9Qr5j5L2iGzFIMt/lDWMbqtZAnoCEyTxhzUlHtxV2zduLiQtwu1bXXATUf
	 yoyRcVTZgorOfod53EZL6WXC3Ky9F4gVI2d3hseplV9RfEildA3eJ+sGLP5+KG7UCF
	 MnO4lcQf1Emm7wWwBLaKw31j7GV0GkmUcTmlq2YY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0248/1518] timens: Remove dependency on the vDSO
Date: Sat, 12 Sep 2026 08:40:17 +0200
Message-ID: <20260912065629.093403177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 1b6c89285d37114d7efe8ab04102a542581cd7da ]

Previously, missing time namespace support in the vDSO meant that time
namespaces needed to be disabled globally. This was expressed in a hard
dependency on the generic vDSO library. This also meant that architectures
without any vDSO or only a stub vDSO could not enable time namespaces.
Now that all architectures using a real vDSO are using the generic library,
that dependency is not necessary anymore.

Remove the dependency and let all architectures enable time namespaces.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260326-vdso-timens-decoupling-v2-2-c82693a7775f@linutronix.de
Stable-dep-of: 06aba58e5849 ("time/namespace: Validate nanosecond field in proc_timens_set_offset()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/time_namespace.h   | 28 ++++++++++++++++------------
 init/Kconfig                     |  4 +++-
 kernel/time/Makefile             |  3 ++-
 kernel/time/namespace.c          |  8 ++++----
 kernel/time/namespace_internal.h | 15 +++++++++++++++
 kernel/time/namespace_vdso.c     | 14 ++++++++++++++
 6 files changed, 54 insertions(+), 18 deletions(-)

diff --git a/include/linux/time_namespace.h b/include/linux/time_namespace.h
index 0421bf1b13d7a..c1de21a27c340 100644
--- a/include/linux/time_namespace.h
+++ b/include/linux/time_namespace.h
@@ -25,7 +25,9 @@ struct time_namespace {
 	struct ucounts		*ucounts;
 	struct ns_common	ns;
 	struct timens_offsets	offsets;
+#ifdef CONFIG_TIME_NS_VDSO
 	struct page		*vvar_page;
+#endif
 	/* If set prevents changing offsets after any task joined namespace. */
 	bool			frozen_offsets;
 } __randomize_layout;
@@ -38,7 +40,6 @@ static inline struct time_namespace *to_time_ns(struct ns_common *ns)
 	return container_of(ns, struct time_namespace, ns);
 }
 void __init time_ns_init(void);
-extern void timens_commit(struct task_struct *tsk, struct time_namespace *ns);
 
 static inline struct time_namespace *get_time_ns(struct time_namespace *ns)
 {
@@ -51,7 +52,6 @@ struct time_namespace *copy_time_ns(u64 flags,
 				    struct time_namespace *old_ns);
 void free_time_ns(struct time_namespace *ns);
 void timens_on_fork(struct nsproxy *nsproxy, struct task_struct *tsk);
-struct page *find_timens_vvar_page(struct vm_area_struct *vma);
 
 static inline void put_time_ns(struct time_namespace *ns)
 {
@@ -115,11 +115,6 @@ static inline void __init time_ns_init(void)
 {
 }
 
-static inline void timens_commit(struct task_struct *tsk,
-				 struct time_namespace *ns)
-{
-}
-
 static inline struct time_namespace *get_time_ns(struct time_namespace *ns)
 {
 	return NULL;
@@ -146,11 +141,6 @@ static inline void timens_on_fork(struct nsproxy *nsproxy,
 	return;
 }
 
-static inline struct page *find_timens_vvar_page(struct vm_area_struct *vma)
-{
-	return NULL;
-}
-
 static inline void timens_add_monotonic(struct timespec64 *ts) { }
 static inline void timens_add_boottime(struct timespec64 *ts) { }
 
@@ -167,4 +157,18 @@ static inline ktime_t timens_ktime_to_host(clockid_t clockid, ktime_t tim)
 }
 #endif
 
+#ifdef CONFIG_TIME_NS_VDSO
+extern void timens_commit(struct task_struct *tsk, struct time_namespace *ns);
+struct page *find_timens_vvar_page(struct vm_area_struct *vma);
+#else /* !CONFIG_TIME_NS_VDSO */
+static inline void timens_commit(struct task_struct *tsk, struct time_namespace *ns)
+{
+}
+
+static inline struct page *find_timens_vvar_page(struct vm_area_struct *vma)
+{
+	return NULL;
+}
+#endif /* CONFIG_TIME_NS_VDSO */
+
 #endif /* _LINUX_TIMENS_H */
diff --git a/init/Kconfig b/init/Kconfig
index 6ce315af48c15..6e66f327904b8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1366,12 +1366,14 @@ config UTS_NS
 
 config TIME_NS
 	bool "TIME namespace"
-	depends on GENERIC_GETTIMEOFDAY
 	default y
 	help
 	  In this namespace boottime and monotonic clocks can be set.
 	  The time will keep going with the same pace.
 
+config TIME_NS_VDSO
+	def_bool TIME_NS && GENERIC_GETTIMEOFDAY
+
 config IPC_NS
 	bool "IPC namespace"
 	depends on (SYSVIPC || POSIX_MQUEUE)
diff --git a/kernel/time/Makefile b/kernel/time/Makefile
index 662bccb3b7f9a..eaf290c972f95 100644
--- a/kernel/time/Makefile
+++ b/kernel/time/Makefile
@@ -29,6 +29,7 @@ endif
 obj-$(CONFIG_GENERIC_GETTIMEOFDAY)		+= vsyscall.o
 obj-$(CONFIG_DEBUG_FS)				+= timekeeping_debug.o
 obj-$(CONFIG_TEST_UDELAY)			+= test_udelay.o
-obj-$(CONFIG_TIME_NS)				+= namespace.o namespace_vdso.o
+obj-$(CONFIG_TIME_NS)				+= namespace.o
+obj-$(CONFIG_TIME_NS_VDSO)			+= namespace_vdso.o
 obj-$(CONFIG_TEST_CLOCKSOURCE_WATCHDOG)		+= clocksource-wdtest.o
 obj-$(CONFIG_TIME_KUNIT_TEST)			+= time_test.o
diff --git a/kernel/time/namespace.c b/kernel/time/namespace.c
index 0e15a5daa45e7..9191899289fcb 100644
--- a/kernel/time/namespace.c
+++ b/kernel/time/namespace.c
@@ -93,8 +93,8 @@ static struct time_namespace *clone_time_ns(struct user_namespace *user_ns,
 	if (!ns)
 		goto fail_dec;
 
-	ns->vvar_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
-	if (!ns->vvar_page)
+	err = timens_vdso_alloc_vvar_page(ns);
+	if (err)
 		goto fail_free;
 
 	err = ns_common_init(ns);
@@ -109,7 +109,7 @@ static struct time_namespace *clone_time_ns(struct user_namespace *user_ns,
 	return ns;
 
 fail_free_page:
-	__free_page(ns->vvar_page);
+	timens_vdso_free_vvar_page(ns);
 fail_free:
 	kfree(ns);
 fail_dec:
@@ -146,7 +146,7 @@ void free_time_ns(struct time_namespace *ns)
 	dec_time_namespaces(ns->ucounts);
 	put_user_ns(ns->user_ns);
 	ns_common_free(ns);
-	__free_page(ns->vvar_page);
+	timens_vdso_free_vvar_page(ns);
 	/* Concurrent nstree traversal depends on a grace period. */
 	kfree_rcu(ns, ns.ns_rcu);
 }
diff --git a/kernel/time/namespace_internal.h b/kernel/time/namespace_internal.h
index e85da11abb4d9..b37ba179f43b2 100644
--- a/kernel/time/namespace_internal.h
+++ b/kernel/time/namespace_internal.h
@@ -4,10 +4,25 @@
 
 #include <linux/mutex.h>
 
+struct time_namespace;
+
 /*
  * Protects possibly multiple offsets writers racing each other
  * and tasks entering the namespace.
  */
 extern struct mutex timens_offset_lock;
 
+#ifdef CONFIG_TIME_NS_VDSO
+int timens_vdso_alloc_vvar_page(struct time_namespace *ns);
+void timens_vdso_free_vvar_page(struct time_namespace *ns);
+#else /* !CONFIG_TIME_NS_VDSO */
+static inline int timens_vdso_alloc_vvar_page(struct time_namespace *ns)
+{
+	return 0;
+}
+static inline void timens_vdso_free_vvar_page(struct time_namespace *ns)
+{
+}
+#endif /* CONFIG_TIME_NS_VDSO */
+
 #endif /* _TIME_NAMESPACE_INTERNAL_H */
diff --git a/kernel/time/namespace_vdso.c b/kernel/time/namespace_vdso.c
index 0e154f9015012..88c075cd16a36 100644
--- a/kernel/time/namespace_vdso.c
+++ b/kernel/time/namespace_vdso.c
@@ -144,3 +144,17 @@ void timens_commit(struct task_struct *tsk, struct time_namespace *ns)
 	timens_set_vvar_page(tsk, ns);
 	vdso_join_timens(tsk, ns);
 }
+
+int timens_vdso_alloc_vvar_page(struct time_namespace *ns)
+{
+	ns->vvar_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (!ns->vvar_page)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void timens_vdso_free_vvar_page(struct time_namespace *ns)
+{
+	__free_page(ns->vvar_page);
+}
-- 
2.53.0



