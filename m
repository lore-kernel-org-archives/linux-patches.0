Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8573846AA6B;
	Tue, 21 Jul 2026 15:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648416; cv=none; b=UnBc2CfRx72pYYL3Yrlbb2a0Vn3Rqkp4q/viijGMvkH3ESSFE7LG3599UKDG/fu23/TcpuPBTyoYYOLGuLf/3tEzXYruHafhWrqYhSdwoloXXZeRM7SOsOzgo5HSCs5u2H7G4A/ilV4xNKIh0vtgGDRk7i7MgpVoYpGWI3a4rW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648416; c=relaxed/simple;
	bh=as3w5O0xny0DbgeA2jE1VDciOwdoUKyE2GxhcR9iS1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dwt3VUM4Qkcvjhmqw48uDJZt8IHga/MCSe6eK+uFs7gknLKa4arOGBAVpW9V/7Dumt6r+W0CbcVSswaUZ/KFv2DDPXw+qMrQ+FZ67TW80Eg/9St3+nc8lEb+13qgKe1t96BwBGsdaY2SSKgx/u6QkJ9J5yIA1L4eU1ZahafIBT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oFAZQd/w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oFAZQd/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68701F000E9;
	Tue, 21 Jul 2026 15:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648415;
	bh=pwI2PY/pLaP1c72/mbUWTJW6aF+Y8pmAxsrhFv4NCUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oFAZQd/wuOy/fOU78BWm5U/kpmltXGLXUTMn5HIHvxxyDJg2qnyZTGpwwcyLElcSW
	 PdGt4ZZLV/GQzOzN8zPHQr2UzwLCHZTGNHRWjJfEFBNrwcFRbk72TYouERdN/rHAOI
	 DhB5IZVRr35c1CVzyDTHOfQs7iJx7hH9sI9hW54Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Hocko <mhocko@suse.com>,
	syzbot+5af806780f38a5fe691f@syzkaller.appspotmail.com,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0192/2077] rhashtable: give each instance its own lockdep class
Date: Tue, 21 Jul 2026 16:57:45 +0200
Message-ID: <20260721152557.212920951@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 060d4e94b8d400b62453890821bd7feecd4cde2c ]

syzbot reported a possible circular locking dependency between
&ht->mutex and fs_reclaim:

  CPU0 (kswapd0)                    CPU1 (kworker)
  --------------                    --------------
  fs_reclaim                        ht->mutex
    shmem_evict_inode                 rhashtable_rehash_alloc
      simple_xattrs_free                bucket_table_alloc(GFP_KERNEL)
        rhashtable_free_and_destroy       __kvmalloc_node
          mutex_lock(&ht->mutex)            might_alloc -> fs_reclaim

The two halves of the splat refer to two different events on
&ht->mutex.

The kswapd0 path is unambiguous: shmem_evict_inode at mm/shmem.c:1429
calls simple_xattrs_free(), which calls rhashtable_free_and_destroy()
on the per-inode simple_xattrs rhashtable being torn down with the
inode.

The previously-recorded ht->mutex -> fs_reclaim edge comes from
rht_deferred_worker -> rhashtable_rehash_alloc ->
bucket_table_alloc(GFP_KERNEL) -> __kvmalloc_node ->
might_alloc -> fs_reclaim. That stack stops at generic library code:
there is no subsystem-specific frame above rht_deferred_worker, so
the splat does not identify which rhashtable's worker recorded the
edge -- only that some rhashtable in the system did.

Whether or not that recording happened on the same simple_xattrs ht
that is now being destroyed, the predicted deadlock cannot occur:
rhashtable_free_and_destroy() does cancel_work_sync(&ht->run_work)
before taking ht->mutex, so the deferred worker cannot be running on
the instance being torn down. If the recording was on a different
rhashtable instance, the two ht->mutex acquisitions are on distinct
mutex objects and cannot deadlock either.

Lockdep flags a cycle regardless because mutex_init(&ht->mutex) lives
on a single source line in rhashtable_init_noprof(), so every
ht->mutex in the kernel shares one static lockdep class. Lockdep
matches by class, not by instance, and collapses all of these into
one node.

Lift the lockdep key out of rhashtable_init_noprof() and into the
caller. The user-visible rhashtable_init_noprof() /
rhltable_init_noprof() identifiers become macros that declare a
per-call-site static lock_class_key.

Link: https://patch.msgid.link/20260427-work-rhashtable-lockdep-v1-1-f69e8bd91cb2@kernel.org
Fixes: c6307674ed82 ("mm: kvmalloc: add non-blocking support for vmalloc")
Acked-by: Michal Hocko <mhocko@suse.com>
Reported-by: syzbot+5af806780f38a5fe691f@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/69e798fe.050a0220.24bfd3.0032.GAE@google.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rhashtable-types.h | 22 ++++++++++++++++++----
 lib/rhashtable.c                 | 17 ++++++++++-------
 2 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/include/linux/rhashtable-types.h b/include/linux/rhashtable-types.h
index fc2f596a6df1bf..57c11ec9dc645c 100644
--- a/include/linux/rhashtable-types.h
+++ b/include/linux/rhashtable-types.h
@@ -136,12 +136,26 @@ struct rhashtable_iter {
 	bool end_of_table;
 };
 
-int rhashtable_init_noprof(struct rhashtable *ht,
-		    const struct rhashtable_params *params);
+int __rhashtable_init_noprof(struct rhashtable *ht,
+		    const struct rhashtable_params *params,
+		    struct lock_class_key *key);
+#define rhashtable_init_noprof(ht, params)				\
+({									\
+	static struct lock_class_key __key;				\
+									\
+	__rhashtable_init_noprof(ht, params, &__key);			\
+})
 #define rhashtable_init(...)	alloc_hooks(rhashtable_init_noprof(__VA_ARGS__))
 
-int rhltable_init_noprof(struct rhltable *hlt,
-		  const struct rhashtable_params *params);
+int __rhltable_init_noprof(struct rhltable *hlt,
+		  const struct rhashtable_params *params,
+		  struct lock_class_key *key);
+#define rhltable_init_noprof(hlt, params)				\
+({									\
+	static struct lock_class_key __key;				\
+									\
+	__rhltable_init_noprof(hlt, params, &__key);			\
+})
 #define rhltable_init(...)	alloc_hooks(rhltable_init_noprof(__VA_ARGS__))
 
 #endif /* _LINUX_RHASHTABLE_TYPES_H */
diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 04b3a808fca9f2..c0ba34eadb3978 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -1057,8 +1057,9 @@ static u32 rhashtable_jhash2(const void *key, u32 length, u32 seed)
  *	.obj_hashfn = my_hash_fn,
  * };
  */
-int rhashtable_init_noprof(struct rhashtable *ht,
-		    const struct rhashtable_params *params)
+int __rhashtable_init_noprof(struct rhashtable *ht,
+		    const struct rhashtable_params *params,
+		    struct lock_class_key *key)
 {
 	struct bucket_table *tbl;
 	size_t size;
@@ -1068,7 +1069,7 @@ int rhashtable_init_noprof(struct rhashtable *ht,
 		return -EINVAL;
 
 	memset(ht, 0, sizeof(*ht));
-	mutex_init(&ht->mutex);
+	mutex_init_with_key(&ht->mutex, key);
 	spin_lock_init(&ht->lock);
 	memcpy(&ht->p, params, sizeof(*params));
 
@@ -1120,7 +1121,7 @@ int rhashtable_init_noprof(struct rhashtable *ht,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(rhashtable_init_noprof);
+EXPORT_SYMBOL_GPL(__rhashtable_init_noprof);
 
 /**
  * rhltable_init - initialize a new hash list table
@@ -1131,15 +1132,17 @@ EXPORT_SYMBOL_GPL(rhashtable_init_noprof);
  *
  * See documentation for rhashtable_init.
  */
-int rhltable_init_noprof(struct rhltable *hlt, const struct rhashtable_params *params)
+int __rhltable_init_noprof(struct rhltable *hlt,
+			   const struct rhashtable_params *params,
+			   struct lock_class_key *key)
 {
 	int err;
 
-	err = rhashtable_init_noprof(&hlt->ht, params);
+	err = __rhashtable_init_noprof(&hlt->ht, params, key);
 	hlt->ht.rhlist = true;
 	return err;
 }
-EXPORT_SYMBOL_GPL(rhltable_init_noprof);
+EXPORT_SYMBOL_GPL(__rhltable_init_noprof);
 
 static void rhashtable_free_one(struct rhashtable *ht, struct rhash_head *obj,
 				void (*free_fn)(void *ptr, void *arg),
-- 
2.53.0



