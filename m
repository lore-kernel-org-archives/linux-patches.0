Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B8F1A682B;
	Fri,  9 Oct 2026 14:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555955; cv=none; b=T3cFfEST0z93k5GehlKQEPmfwCPOVvTo/9iluM98z1E7JiVomn7xGb8QffImKoiZXlnpcIG1zh6dD1sOVwA/RcV19ElxDOmqB3GfDY75n0/Q2QbbSbpKCJ797KvMBAWX1hBEELGMdjfBIXUyCgEVDZruf5/oCBA3h2ciLV2LrKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555955; c=relaxed/simple;
	bh=gjXxuJu+Gzde2CYQgcWQC1G/AKWYvGIJDzLjKT3kfmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dewpNZwUFZTn8dvjtb3vQx+sEie52yBA4lsu+Z5Mfx5NHASklagbJLVlZ1SjVUwXu7J6h7Z3+VfWjzRDo2ekHfpamfsUdqbDP4onuSfeeXolSTmOx/bubUqbfGN/u/SG9EkhTv+K2foLPq2pgLcqFx91xN9tm7njdIwZorfsevs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sy6V9vZX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sy6V9vZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF12B1F000FF;
	Fri,  9 Oct 2026 14:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555954;
	bh=VHuzgnhHuuuguBrwv8wAN26wd8HZCM7kaFFWzqUd4RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sy6V9vZXSiBYZNLKTOu6ejVDQBHJzXx+ORVcPYQYnh2X0/no5BTtMDuv2FByyzgZy
	 MhIm5mbu/0gTVW5xu234esa1SG8OPsxQPmAtzIhw/zo8u+EFf8i8OQWbXib4Q8CLCo
	 KCBIfifwJRbE/B9fqRYZGks/DcYEoO2aAmYHRrP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Shengming Hu <hu.shengming@zte.com.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 096/428] mm/slab: handle the !allow_spin case in kfree_rcu_sheaf()
Date: Fri,  9 Oct 2026 16:07:13 +0200
Message-ID: <20261009140948.317645444@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Yoo (Oracle) <harry@kernel.org>

[ Upstream commit f3521fbec2b2839698eba2b7013ed20119416e6d ]

Teach kfree_rcu_sheaf() how to handle the !allow_spin case. Try to get
an empty sheaf from pcs->spare or the barn even when spinning is not
allowed. Unlike __pcs_replace_full_main(), try harder to allocate
an empty sheaf because the fallback path will be more expensive than
kfree_nolock().

Now that slab has internal alloc_flags to describe context, introduce
free_flags analogously and convert free_flags to alloc_flags when
allocating memory in the free path.

When trylock fails or the kernel observes non-NULL pcs->rcu_free after
lock acquisition, free the sheaf instead of putting it to the barn.
This is rare and not worth complicating the code.

Since call_rcu() cannot be called in an unknown context,
kfree_rcu_sheaf() fails when the rcu sheaf becomes full.

Link: https://lore.kernel.org/linux-mm/872bd673-3d45-4111-8a41-31185db3ece5@kernel.org
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
Link: https://patch.msgid.link/20260729-kfree_rcu_nolock-v5-2-a28cdcda9673@kernel.org
Reviewed-by: Shengming Hu <hu.shengming@zte.com.cn>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Stable-dep-of: af2fb3ee6679 ("mm/slab: do not wake up kswapd in __kfree_rcu_sheaf()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slab.h        | 18 +++++++++++++++++-
 mm/slab_common.c |  2 +-
 mm/slub.c        | 34 ++++++++++++++++++++++++++--------
 3 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index f5e336b6b6b04..ba08da09da361 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -24,11 +24,27 @@
 #define SLAB_ALLOC_NO_RECURSE	0x04 /* prevent kmalloc() recursion */
 #define SLAB_ALLOC_NO_OBJ_EXT	0x08 /* prevent obj_exts array allocation */
 
+#define SLAB_FREE_DEFAULT	0x00 /* no flags */
+#define SLAB_FREE_NOLOCK	0x01 /* spinning not allowed */
+
+static inline unsigned int to_alloc_flags(unsigned int free_flags)
+{
+	if (free_flags & SLAB_FREE_NOLOCK)
+		return SLAB_ALLOC_NOLOCK;
+	else
+		return SLAB_ALLOC_DEFAULT;
+}
+
 static inline bool alloc_flags_allow_spinning(const unsigned int alloc_flags)
 {
 	return !(alloc_flags & SLAB_ALLOC_NOLOCK);
 }
 
+static inline bool free_flags_allow_spinning(const unsigned int free_flags)
+{
+	return !(free_flags & SLAB_FREE_NOLOCK);
+}
+
 void *__kmalloc_flags_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags,
 				  unsigned int alloc_flags, int node)
 				  __assume_kmalloc_alignment __alloc_size(1);
@@ -436,7 +452,7 @@ static inline bool is_kmalloc_normal(struct kmem_cache *s)
 	return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACCOUNT|SLAB_NO_OBJ_EXT));
 }
 
-bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj);
+bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags);
 void flush_all_rcu_sheaves(void);
 void flush_rcu_sheaves_on_cache(struct kmem_cache *s);
 
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 03ecac12cd865..2475fc0e5e419 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1622,7 +1622,7 @@ static bool kfree_rcu_sheaf(void *obj)
 
 	s = slab->slab_cache;
 	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id()))
-		return __kfree_rcu_sheaf(s, obj);
+		return __kfree_rcu_sheaf(s, obj, SLAB_FREE_DEFAULT);
 
 	return false;
 }
diff --git a/mm/slub.c b/mm/slub.c
index 3791d69ba6f90..d8b6d80def1de 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2777,7 +2777,8 @@ static inline struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s,
 	return __alloc_empty_sheaf(s, gfp, alloc_flags, s->sheaf_capacity);
 }
 
-static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
+static void __free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
+			       unsigned int free_flags)
 {
 	/*
 	 * If the sheaf was created with SLAB_ALLOC_NO_RECURSE flag then its
@@ -2789,11 +2790,20 @@ static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
 		mark_obj_codetag_empty(sheaf);
 
 	VM_WARN_ON_ONCE(sheaf->size > 0);
-	kfree(sheaf);
+
+	if (unlikely(free_flags & SLAB_FREE_NOLOCK))
+		kfree_nolock(sheaf);
+	else
+		kfree(sheaf);
 
 	stat(s, SHEAF_FREE);
 }
 
+static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
+{
+	__free_empty_sheaf(s, sheaf, SLAB_FREE_DEFAULT);
+}
+
 static unsigned int
 refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
 	       unsigned int max);
@@ -6038,10 +6048,11 @@ static void rcu_free_sheaf(struct rcu_head *head)
  */
 static DEFINE_WAIT_OVERRIDE_MAP(kfree_rcu_sheaf_map, LD_WAIT_CONFIG);
 
-bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
+bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
 {
 	struct slub_percpu_sheaves *pcs;
 	struct slab_sheaf *rcu_sheaf;
+	bool allow_spin = free_flags_allow_spinning(free_flags);
 
 	if (WARN_ON_ONCE(IS_ENABLED(CONFIG_PREEMPT_RT)))
 		return false;
@@ -6054,9 +6065,10 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
 	if (unlikely(!pcs->rcu_free)) {
-
 		struct slab_sheaf *empty;
 		struct node_barn *barn;
+		unsigned int alloc_flags = to_alloc_flags(free_flags);
+		gfp_t gfp = allow_spin ? GFP_NOWAIT : __GFP_NOWARN;
 
 		/* Bootstrap or debug cache, fall back */
 		if (unlikely(!cache_has_sheaves(s))) {
@@ -6076,7 +6088,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 			goto fail;
 		}
 
-		empty = barn_get_empty_sheaf(barn, true);
+		empty = barn_get_empty_sheaf(barn, allow_spin);
 
 		if (empty) {
 			pcs->rcu_free = empty;
@@ -6085,20 +6097,20 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 
 		local_unlock(&s->cpu_sheaves->lock);
 
-		empty = alloc_empty_sheaf(s, GFP_NOWAIT, SLAB_ALLOC_DEFAULT);
+		empty = alloc_empty_sheaf(s, gfp, alloc_flags);
 
 		if (!empty)
 			goto fail;
 
 		if (!local_trylock(&s->cpu_sheaves->lock)) {
-			barn_put_empty_sheaf(barn, empty);
+			__free_empty_sheaf(s, empty, free_flags);
 			goto fail;
 		}
 
 		pcs = this_cpu_ptr(s->cpu_sheaves);
 
 		if (unlikely(pcs->rcu_free))
-			barn_put_empty_sheaf(barn, empty);
+			__free_empty_sheaf(s, empty, free_flags);
 		else
 			pcs->rcu_free = empty;
 	}
@@ -6116,6 +6128,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 	if (likely(rcu_sheaf->size < s->sheaf_capacity)) {
 		rcu_sheaf = NULL;
 	} else {
+		if (unlikely(!allow_spin)) {
+			/* call_rcu() cannot be called in an unknown context */
+			rcu_sheaf->size--;
+			local_unlock(&s->cpu_sheaves->lock);
+			goto fail;
+		}
 		pcs->rcu_free = NULL;
 		rcu_sheaf->node = numa_node_id();
 	}
-- 
2.53.0



