Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4580836DA0F;
	Sat, 28 Feb 2026 17:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301474; cv=none; b=I2piZ7uEvs6R834L40bK1zpr3Q48QY9IXBzIewBzxJbsoG2Lnmybhf21C3+05lYmb2W0mH4V7LOlBg5Tsu7QdsbvbBBFn+WKGWVUsk84QMX4o8bEuoBozTespxMZmoGLR3sSF4zFGeW/W/ORMWXSQsmA4B2m8dfCL5rKGjwE97s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301474; c=relaxed/simple;
	bh=UozqtKQrHd6OH1xXYz4EOc4mnpzJGmPXZa1zqKGYeVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CVZTTARfgrVDG3Hmh0MxOmIt5uZ0Kol2drr586aiokY7gQh4WB3v4tuzqux0q2S4mx0azhZ2QTCydnYQE5I1yF/mRyPjwBLbysIV4P1RHF5Tvj1//ykoOKdF3C/xT8hVLSikaYE2Ps4X2oWObTDm2kY7yd7ESRw8A6qBfvpoWuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rB2bd8iO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rB2bd8iO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694A6C19423;
	Sat, 28 Feb 2026 17:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301474;
	bh=UozqtKQrHd6OH1xXYz4EOc4mnpzJGmPXZa1zqKGYeVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rB2bd8iO6eIiq8itcrxIMZjV7HxVrxwp5e8n9msvfstNnKkQwfCmumMvxsdydyKw+
	 h/Qrij8HfZUwiv/FdrYHHHmz2PjIOUbcjz7cfQgLIhP5pfvXtjb8VJKTK2AJo8FlPQ
	 nwEec1i1iLVWIqrwbQYgHny+4U6mJ2BeMi+BQdBxxfa8IUfIyv+fx/M+BKizSJo93m
	 KVN2BJyNibFyGOeU3gVagWuEh6DrpSB4s4cxry8Km0hAIOkiCBj9cLu1NtYc+fhKUv
	 1I5ozmiJyp8bjp1ns7R43Nw/3rGv+NHfHw/XplZgXr59zQf9nAdVHegNClyL+jxJK4
	 AczA3KH0bT6/g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Harry Yoo <harry.yoo@oracle.com>,
	kernel test robot <oliver.sang@intel.com>,
	stable@vger.kernel.org,
	Hao Li <hao.li@linux.dev>,
	Vlastimil Babka <vbabka@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 659/752] mm/slab: avoid allocating slabobj_ext array from its own slab
Date: Sat, 28 Feb 2026 12:46:10 -0500
Message-ID: <20260228174750.1542406-659-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Harry Yoo <harry.yoo@oracle.com>

[ Upstream commit 280ea9c3154b2af7d841f992c9fc79e9d6534e03 ]

When allocating slabobj_ext array in alloc_slab_obj_exts(), the array
can be allocated from the same slab we're allocating the array for.
This led to obj_exts_in_slab() incorrectly returning true [1],
although the array is not allocated from wasted space of the slab.

Vlastimil Babka observed that this problem should be fixed even when
ignoring its incompatibility with obj_exts_in_slab(), because it creates
slabs that are never freed as there is always at least one allocated
object.

To avoid this, use the next kmalloc size or large kmalloc when
the array can be allocated from the same cache we're allocating
the array for.

In case of random kmalloc caches, there are multiple kmalloc caches
for the same size and the cache is selected based on the caller address.
Because it is fragile to ensure the same caller address is passed to
kmalloc_slab(), kmalloc_noprof(), and kmalloc_node_noprof(), bump the
size to (s->object_size + 1) when the sizes are equal, instead of
directly comparing the kmem_cache pointers.

Note that this doesn't happen when memory allocation profiling is
disabled, as when the allocation of the array is triggered by memory
cgroup (KMALLOC_CGROUP), the array is allocated from KMALLOC_NORMAL.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202601231457.f7b31e09-lkp@intel.com [1]
Cc: stable@vger.kernel.org
Fixes: 4b8736964640 ("mm/slab: add allocation accounting into slab allocation and free paths")
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Link: https://patch.msgid.link/20260126125714.88008-1-harry.yoo@oracle.com
Reviewed-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slub.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 53 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 896421a555573..e8cffd89b73d7 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2099,6 +2099,49 @@ static inline void init_slab_obj_exts(struct slab *slab)
 	slab->obj_exts = 0;
 }
 
+/*
+ * Calculate the allocation size for slabobj_ext array.
+ *
+ * When memory allocation profiling is enabled, the obj_exts array
+ * could be allocated from the same slab cache it's being allocated for.
+ * This would prevent the slab from ever being freed because it would
+ * always contain at least one allocated object (its own obj_exts array).
+ *
+ * To avoid this, increase the allocation size when we detect the array
+ * may come from the same cache, forcing it to use a different cache.
+ */
+static inline size_t obj_exts_alloc_size(struct kmem_cache *s,
+					 struct slab *slab, gfp_t gfp)
+{
+	size_t sz = sizeof(struct slabobj_ext) * slab->objects;
+	struct kmem_cache *obj_exts_cache;
+
+	/*
+	 * slabobj_ext array for KMALLOC_CGROUP allocations
+	 * are served from KMALLOC_NORMAL caches.
+	 */
+	if (!mem_alloc_profiling_enabled())
+		return sz;
+
+	if (sz > KMALLOC_MAX_CACHE_SIZE)
+		return sz;
+
+	if (!is_kmalloc_normal(s))
+		return sz;
+
+	obj_exts_cache = kmalloc_slab(sz, NULL, gfp, 0);
+	/*
+	 * We can't simply compare s with obj_exts_cache, because random kmalloc
+	 * caches have multiple caches per size, selected by caller address.
+	 * Since caller address may differ between kmalloc_slab() and actual
+	 * allocation, bump size when sizes are equal.
+	 */
+	if (s->object_size == obj_exts_cache->object_size)
+		return obj_exts_cache->object_size + 1;
+
+	return sz;
+}
+
 int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 		        gfp_t gfp, bool new_slab)
 {
@@ -2107,26 +2150,26 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 	unsigned long new_exts;
 	unsigned long old_exts;
 	struct slabobj_ext *vec;
+	size_t sz;
 
 	gfp &= ~OBJCGS_CLEAR_MASK;
 	/* Prevent recursive extension vector allocation */
 	gfp |= __GFP_NO_OBJ_EXT;
 
+	sz = obj_exts_alloc_size(s, slab, gfp);
+
 	/*
 	 * Note that allow_spin may be false during early boot and its
 	 * restricted GFP_BOOT_MASK. Due to kmalloc_nolock() only supporting
 	 * architectures with cmpxchg16b, early obj_exts will be missing for
 	 * very early allocations on those.
 	 */
-	if (unlikely(!allow_spin)) {
-		size_t sz = objects * sizeof(struct slabobj_ext);
-
+	if (unlikely(!allow_spin))
 		vec = kmalloc_nolock(sz, __GFP_ZERO | __GFP_NO_OBJ_EXT,
 				     slab_nid(slab));
-	} else {
-		vec = kcalloc_node(objects, sizeof(struct slabobj_ext), gfp,
-				   slab_nid(slab));
-	}
+	else
+		vec = kmalloc_node(sz, gfp | __GFP_ZERO, slab_nid(slab));
+
 	if (!vec) {
 		/*
 		 * Try to mark vectors which failed to allocate.
@@ -2140,6 +2183,9 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 		return -ENOMEM;
 	}
 
+	VM_WARN_ON_ONCE(virt_to_slab(vec) != NULL &&
+			virt_to_slab(vec)->slab_cache == s);
+
 	new_exts = (unsigned long)vec;
 	if (unlikely(!allow_spin))
 		new_exts |= OBJEXTS_NOSPIN_ALLOC;
-- 
2.51.0

