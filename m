Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD5E37EFFB;
	Thu, 17 Sep 2026 18:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671514; cv=none; b=Qu9SLw7TRg8o3JzUpC3IwrKcCAzmb3j09VfX9NSgJeFB8SD7Wie8yi6Y3ynSf5vG/9T3JpiV0lfPxIywrMmwufVxrvvloYkJ1L1NAXG7FJDXEBvxWxv1r6BlW9SpKEV8LmdJDtlbB2IwuZZoVPcfUOdRag9k6hFsgCGucAW20lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671514; c=relaxed/simple;
	bh=38wb4U2W1I7oiSfv6pvAIyI8TBFH989qv03MZ8+OfOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/KFM0o3xuduuCV+ahragWi58c9eisZePnQ6dksvL7tCyhHBBksnVVU0wuJFyOD2D0OVpOEPijIj45BcsIiQ6PfyMb4XCXa8F96FPMqOwMdEJ7r83VBbsVSGcn7aDZynv8Ao0UYNICvimNcQ8uxWWQC4+/6c7g10nvLpkAhxYcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ys8CE3Wr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ys8CE3Wr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6425E1F000FF;
	Thu, 17 Sep 2026 18:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671512;
	bh=N3WeCKKQEqwT1EipTCYjlHefsULM6Kb1yGYhKyQIf3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ys8CE3Wr0ehN3s62dtG08lAjkiBfl2aGnljMarFVa2UxODBcBC06zdSUFlgJwdQYL
	 LIccyu3rTTNDi4zvQo3a7ZIbELRD51GUir1S7xtDQKWVObHlMh8yjsOc/6GYakj85T
	 VbYDc40FdJJWDQ/m7eEnbv2IsrPdNcZlZttYea4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@kernel.org>,
	Li Xiasong <lixiasong1@huawei.com>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1000/1102] mm/slub: fix missing debugfs entries for caches created before sysfs init
Date: Thu, 17 Sep 2026 16:15:43 +0100
Message-ID: <20260917151605.847483425@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Li Xiasong <lixiasong1@huawei.com>

[ Upstream commit 7e98f856395618011c517f767fb80ac3fe90de2b ]

slab_debugfs_init() creates the slab debugfs root at device initcall
time, while slab_sysfs_init() moves slab_state to FULL at late initcall
time. SLAB_STORE_USER caches created in this window miss their debugfs
entries because do_kmem_cache_create() skips debugfs_slab_add() when
slab_state <= UP. This was observed with MPTCP's request_sock_subflow_v6
cache, whose slab debugfs directory was missing.

The affected window is:

  slab_debugfs_init()
    slab_debugfs_root = debugfs_create_dir(...)
    list_for_each_entry(s, &slab_caches, list)
      debugfs_slab_add(s)

  kmem_cache_create(..., SLAB_STORE_USER, ...)
    do_kmem_cache_create()
      if (slab_state <= UP)
        return without debugfs entries

  slab_sysfs_init()
    slab_state = FULL

Initialize the debugfs root and add debugfs entries while holding
slab_mutex, walking slab_caches exactly once and handling both sysfs
and debugfs entries in the same pass. This gives the sysfs and debugfs
initialization an explicit order and prevents caches from being
created between the debugfs scan and slab_state reaching FULL.

Gate the new slab_late_init() on either sysfs or debugfs being enabled,
with the slab_kset creation and alias_list processing factored into
helpers that have empty no-sysfs variants, as suggested by Vlastimil
Babka. On slab_kset_init() failure, slab_state stays below FULL so
kmem_cache_create() keeps taking the early-boot path, matching prior
behavior.

Guard debugfs_slab_release() against an uninitialized debugfs root,
since the root is now created later and a cache may be released before
it exists.

Fixes: 1a5ad30b89b4 ("mm: slub: make slab_sysfs_init() a late_initcall")
Cc: stable@vger.kernel.org
Suggested-by: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Li Xiasong <lixiasong1@huawei.com>
Link: https://patch.msgid.link/20260729101849.3734287-1-lixiasong1@huawei.com
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |   76 +++++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 48 insertions(+), 28 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -333,14 +333,20 @@ enum track_item { TRACK_ALLOC, TRACK_FRE
 
 #ifdef SLAB_SUPPORTS_SYSFS
 static int sysfs_slab_add(struct kmem_cache *);
+static int __init slab_kset_init(void);
+static void __init slab_sysfs_process_aliases(void);
 #else
 static inline int sysfs_slab_add(struct kmem_cache *s) { return 0; }
+static inline int slab_kset_init(void) { return 0; }
+static inline void slab_sysfs_process_aliases(void) { }
 #endif
 
 #if defined(CONFIG_DEBUG_FS) && defined(CONFIG_SLUB_DEBUG)
 static void debugfs_slab_add(struct kmem_cache *);
+static void __init slab_debugfs_root_init(void);
 #else
 static inline void debugfs_slab_add(struct kmem_cache *s) { }
+static inline void slab_debugfs_root_init(void) { }
 #endif
 
 enum stat_item {
@@ -7247,28 +7253,20 @@ int sysfs_slab_alias(struct kmem_cache *
 	return 0;
 }
 
-static int __init slab_sysfs_init(void)
+static int __init slab_kset_init(void)
 {
-	struct kmem_cache *s;
-	int err;
-
-	mutex_lock(&slab_mutex);
-
 	slab_kset = kset_create_and_add("slab", NULL, kernel_kobj);
 	if (!slab_kset) {
-		mutex_unlock(&slab_mutex);
 		pr_err("Cannot register slab subsystem.\n");
 		return -ENOMEM;
 	}
 
-	slab_state = FULL;
+	return 0;
+}
 
-	list_for_each_entry(s, &slab_caches, list) {
-		err = sysfs_slab_add(s);
-		if (err)
-			pr_err("SLUB: Unable to add boot slab %s to sysfs\n",
-			       s->name);
-	}
+static void __init slab_sysfs_process_aliases(void)
+{
+	int err;
 
 	while (alias_list) {
 		struct saved_alias *al = alias_list;
@@ -7280,12 +7278,41 @@ static int __init slab_sysfs_init(void)
 			       al->name);
 		kfree(al);
 	}
+}
+#endif /* SLAB_SUPPORTS_SYSFS */
+
+#if defined(SLAB_SUPPORTS_SYSFS) || \
+	(defined(CONFIG_SLUB_DEBUG) && defined(CONFIG_DEBUG_FS))
+static int __init slab_late_init(void)
+{
+	struct kmem_cache *s;
+	int err;
 
+	mutex_lock(&slab_mutex);
+
+	err = slab_kset_init();
+	if (err)
+		goto out;
+
+	slab_debugfs_root_init();
+	slab_state = FULL;
+
+	list_for_each_entry(s, &slab_caches, list) {
+		if (sysfs_slab_add(s))
+			pr_err("SLUB: Unable to add boot slab %s to sysfs\n",
+			       s->name);
+
+		if (s->flags & SLAB_STORE_USER)
+			debugfs_slab_add(s);
+	}
+
+	slab_sysfs_process_aliases();
+out:
 	mutex_unlock(&slab_mutex);
-	return 0;
+	return err;
 }
-late_initcall(slab_sysfs_init);
-#endif /* SLAB_SUPPORTS_SYSFS */
+late_initcall(slab_late_init);
+#endif
 
 #if defined(CONFIG_SLUB_DEBUG) && defined(CONFIG_DEBUG_FS)
 static int slab_debugfs_show(struct seq_file *seq, void *v)
@@ -7483,23 +7510,16 @@ static void debugfs_slab_add(struct kmem
 
 void debugfs_slab_release(struct kmem_cache *s)
 {
+	if (unlikely(!slab_debugfs_root))
+		return;
+
 	debugfs_lookup_and_remove(s->name, slab_debugfs_root);
 }
 
-static int __init slab_debugfs_init(void)
+static void __init slab_debugfs_root_init(void)
 {
-	struct kmem_cache *s;
-
 	slab_debugfs_root = debugfs_create_dir("slab", NULL);
-
-	list_for_each_entry(s, &slab_caches, list)
-		if (s->flags & SLAB_STORE_USER)
-			debugfs_slab_add(s);
-
-	return 0;
-
 }
-__initcall(slab_debugfs_init);
 #endif
 /*
  * The /proc/slabinfo ABI


