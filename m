Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018246;
	b=LJa6M2GcrvwBQI2gTKRxspt2pTh0n4LfyGCALyXC7LsOtLDBF2CYPWJ7KwOgDhE5jDQH
	 aqztTz7Lrcpeq6s6D8MsW3/dcnbhOfcyyOLzaJrowQEUHLApFpvQNIjltK/Wy5dP+t0Gs
	 /RFAk3+0fZkEHuLywK9tBAEa+HwVKqXxb/qfyUwTbjLliCDcq+brSYcByv4j0x/uot4KF
	 3smqE3wVteInHGCp95AZG49/j59Nk/Nk7bTuWl3P2CiXWnHX26vVaSVE+dmZdYKd4bq3b
	 8GhGDOhh437LSGWrFUf0odl+TljZcs7aXxss/sRDypf+sVavhdkbnp/rc7H5/F9PxJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018246;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D+DKaIfjwESnS/fewD6pHQkoUkFs4EFaxkdvZPTkJNQ=;
	b=bTa/P5x5wjzpKUF+jJV/b/0QSMuZ9nLhUdFbuiEhkTlWgDNenEaNkqBzxkmifZcete57
	 qAioTRA9fM+SwVvtrhfyBGKXgoq+06i7nIZJn2F4GKEjTidX2mLjbU0n3Z23ELw6btWg/
	 sF0CIX8rivhqldXtfKkU8O+lFfbnvAAv/YX+df72QoZ+rFw9uvwMc4fopNqXMbFD0Unzz
	 S2w8tP2RGnt6+usgqBWrhkcxVmE62sshb2Jw9PUfXQzQ4t0vsgi119GGW5+RctWQ2SK16
	 2T5+BvfI+F0xd5NAdBpdaQnIZzr3b+E5uMLLKY1WcRLSxhHLtQktTTHb/3FkwU695cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xAZdl88x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0A3606A31C;
	Wed, 18 Nov 2026 16:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xAZdl88x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019461F000C4;
	Wed, 18 Nov 2026 16:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018246;
	bh=D+DKaIfjwESnS/fewD6pHQkoUkFs4EFaxkdvZPTkJNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xAZdl88xPJPLT9LuCsVkPcrhocHCQgPEltq9lNqVICTW9kCtYO43Zc/nArOAYFt40
	 IRgyY4s/NyZhnbIkYm5c2mvYu7+f9KkXYmTWWTES74ZBhtowvNtE+Ai7OPVE0dghfx
	 toxa/DvnLkZIWUKqhGr2MQtMmh5Pg2DoN4T1hxo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1170/2651] bpf: Use an llist for page allocations
Date: Wed, 18 Nov 2026 15:40:10 +0100
Message-ID: <20261118150330.130549153@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Tsalapatis <emil@etsalapatis.com>

[ Upstream commit 11de29f38a3455e5785c5fd5f38d93c413c5e822 ]

bpf_map_alloc_pages() does not use its map argument. Storing allocated
pages in an array also forces arena callers to allocate a separate
pointer array.

Expose the single-page allocator as bpf_alloc_page(), rename the bulk
helper to bpf_alloc_pages(), and return bulk allocations through an
llist using page->pcp_llist. Add bpf_free_pages() to safely release all
pages remaining on such a list.

Signed-off-by: Emil Tsalapatis <emil@etsalapatis.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261002105218.6171-2-emil@etsalapatis.com
Stable-dep-of: 5316ede1f5d0 ("bpf: Add sleepable arena page allocation path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h  |  6 ++-
 kernel/bpf/arena.c   | 95 +++++++++++++++++++-------------------------
 kernel/bpf/syscall.c | 39 ++++++++++--------
 3 files changed, 67 insertions(+), 73 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index d71cbd920a036..3d6589a74993c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2821,8 +2821,10 @@ struct bpf_map *bpf_map_get_curr_or_next(u32 *id);
 struct bpf_prog *bpf_prog_get_curr_or_next(u32 *id);
 
 
-int bpf_map_alloc_pages(const struct bpf_map *map, int nid,
-			unsigned long nr_pages, struct page **page_array);
+struct page *bpf_alloc_page(int nid);
+int bpf_alloc_pages(int nid, unsigned long nr_pages,
+		    struct llist_head *pages);
+void bpf_free_pages(struct llist_head *pages);
 #ifdef CONFIG_MEMCG
 void bpf_map_memcg_enter(const struct bpf_map *map, struct mem_cgroup **old_memcg,
 			 struct mem_cgroup **new_memcg);
diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index c6369ea5e2082..de4f7c7f68f52 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -146,7 +146,7 @@ static long compute_pgoff(struct bpf_arena *arena, long uaddr)
 
 struct apply_range_data {
 	struct bpf_arena *arena;
-	struct page **pages;
+	struct llist_head *pages;
 	int i;
 };
 
@@ -158,13 +158,17 @@ struct clear_range_data {
 static int apply_range_set_cb(pte_t *pte, unsigned long addr, void *data)
 {
 	struct apply_range_data *d = data;
+	struct llist_node *node;
 	struct page *page;
 	pte_t pteval;
 
 	if (!data)
 		return 0;
 
-	page = d->pages[d->i];
+	node = READ_ONCE(d->pages->first);
+	if (WARN_ON_ONCE(!node))
+		return -EINVAL;
+	page = llist_entry(node, struct page, pcp_llist);
 	/* paranoia, similar to vmap_pages_pte_range() */
 	if (WARN_ON_ONCE(!pfn_valid(page_to_pfn(page))))
 		return -EINVAL;
@@ -197,6 +201,7 @@ static int apply_range_set_cb(pte_t *pte, unsigned long addr, void *data)
 		return -EBUSY;
 	set_pte_at(&init_mm, addr, pte, pteval);
 #endif
+	WARN_ON_ONCE(llist_del_first(d->pages) != node);
 	d->i++;
 	WRITE_ONCE(d->arena->nr_pages, d->arena->nr_pages + 1);
 	return 0;
@@ -312,8 +317,8 @@ static struct bpf_map *arena_map_alloc(union bpf_attr *attr)
 	INIT_WORK(&arena->free_work, arena_free_worker);
 	bpf_map_init_from_attr(&arena->map, attr);
 
-	err = bpf_map_alloc_pages(&arena->map, NUMA_NO_NODE, 1, &arena->scratch_page);
-	if (err)
+	arena->scratch_page = bpf_alloc_page(NUMA_NO_NODE);
+	if (!arena->scratch_page)
 		goto err_free_arena;
 
 	range_tree_init(&arena->rt);
@@ -481,7 +486,9 @@ static vm_fault_t arena_vm_fault(struct vm_fault *vmf)
 	struct bpf_map *map = vmf->vma->vm_file->private_data;
 	struct bpf_arena *arena = container_of(map, struct bpf_arena, map);
 	struct mem_cgroup *new_memcg, *old_memcg;
+	LLIST_HEAD(pages);
 	struct page *page, *new_page = NULL;
+	struct apply_range_data data;
 	vm_fault_t fault_ret;
 	long kbase, kaddr;
 	unsigned long flags;
@@ -543,8 +550,8 @@ static vm_fault_t arena_vm_fault(struct vm_fault *vmf)
 		 * The probed page was freed meanwhile or preallocation failed;
 		 * try the non-blocking allocator, we cannot sleep here.
 		 */
-		ret = bpf_map_alloc_pages(map, map->numa_node, 1, &new_page);
-		if (ret) {
+		new_page = bpf_alloc_page(map->numa_node);
+		if (!new_page) {
 			fault_ret = VM_FAULT_SIGBUS;
 			goto out_err_locked_memcg;
 		}
@@ -555,12 +562,14 @@ static vm_fault_t arena_vm_fault(struct vm_fault *vmf)
 		fault_ret = VM_FAULT_SIGBUS;
 		goto out_err_locked_memcg;
 	}
-	struct apply_range_data data = {
-		.arena = arena, .pages = &new_page, .i = 0
-	};
+	llist_add(&new_page->pcp_llist, &pages);
+	data.arena = arena;
+	data.pages = &pages;
+	data.i = 0;
 
 	ret = apply_to_page_range(&init_mm, kaddr, PAGE_SIZE, apply_range_set_cb, &data);
 	if (ret) {
+		llist_del_first(&pages);
 		range_tree_set(&arena->rt, vmf->pgoff, 1);
 		fault_ret = VM_FAULT_SIGBUS;
 		goto out_err_locked_memcg;
@@ -716,13 +725,12 @@ static long arena_alloc_pages(struct bpf_arena *arena, long uaddr, long page_cnt
 	u64 kern_vm_start = bpf_arena_get_kern_vm_start(arena);
 	struct mem_cgroup *new_memcg, *old_memcg;
 	struct apply_range_data data;
-	struct page **pages = NULL;
-	long remaining, mapped = 0;
-	long alloc_pages;
+	LLIST_HEAD(pages);
+	long mapped = 0;
 	unsigned long flags;
 	long pgoff = 0;
 	u32 uaddr32;
-	int ret, i;
+	int ret;
 
 	if (node_id != NUMA_NO_NODE &&
 	    ((unsigned int)node_id >= nr_node_ids || !node_online(node_id)))
@@ -741,15 +749,9 @@ static long arena_alloc_pages(struct bpf_arena *arena, long uaddr, long page_cnt
 	}
 
 	bpf_map_memcg_enter(&arena->map, &old_memcg, &new_memcg);
-	/* Cap allocation size to KMALLOC_MAX_CACHE_SIZE so kmalloc_nolock() can succeed. */
-	alloc_pages = min(page_cnt, KMALLOC_MAX_CACHE_SIZE / sizeof(struct page *));
-	pages = kmalloc_nolock(alloc_pages * sizeof(struct page *), __GFP_ACCOUNT, NUMA_NO_NODE);
-	if (!pages) {
-		bpf_map_memcg_exit(old_memcg, new_memcg);
-		return 0;
-	}
 	data.arena = arena;
-	data.pages = pages;
+	data.pages = &pages;
+	data.i = 0;
 
 	if (raw_res_spin_lock_irqsave(&arena->spinlock, flags))
 		goto out_free_pages;
@@ -767,45 +769,28 @@ static long arena_alloc_pages(struct bpf_arena *arena, long uaddr, long page_cnt
 	if (ret)
 		goto out_unlock_free_pages;
 
-	remaining = page_cnt;
 	uaddr32 = (u32)(arena->user_vm_start + pgoff * PAGE_SIZE);
 
-	while (remaining) {
-		long this_batch = min(remaining, alloc_pages);
-
-		/* zeroing is needed, since alloc_pages_bulk() only fills in non-zero entries */
-		memset(pages, 0, this_batch * sizeof(struct page *));
-
-		ret = bpf_map_alloc_pages(&arena->map, node_id, this_batch, pages);
-		if (ret)
-			goto out;
+	ret = bpf_alloc_pages(node_id, page_cnt, &pages);
+	if (ret)
+		goto out;
 
-		/*
-		 * Earlier checks made sure that uaddr32 + page_cnt * PAGE_SIZE - 1
-		 * will not overflow 32-bit. Lower 32-bit need to represent
-		 * contiguous user address range.
-		 * Map these pages at kern_vm_start base.
-		 * kern_vm_start + uaddr32 + page_cnt * PAGE_SIZE - 1 can overflow
-		 * lower 32-bit and it's ok.
-		 */
-		data.i = 0;
-		ret = apply_to_page_range(&init_mm,
-					  kern_vm_start + uaddr32 + (mapped << PAGE_SHIFT),
-					  this_batch << PAGE_SHIFT, apply_range_set_cb, &data);
-		if (ret) {
-			/* data.i pages were mapped, account them and free the remaining */
-			mapped += data.i;
-			for (i = data.i; i < this_batch; i++)
-				free_pages_nolock(pages[i], 0);
-			goto out;
-		}
+	/*
+	 * Earlier checks made sure that uaddr32 + page_cnt * PAGE_SIZE - 1
+	 * will not overflow 32-bit. Lower 32-bit need to represent
+	 * contiguous user address range.
+	 * Map these pages at kern_vm_start base.
+	 * kern_vm_start + uaddr32 + page_cnt * PAGE_SIZE - 1 can overflow
+	 * lower 32-bit and it's ok.
+	 */
+	ret = apply_to_page_range(&init_mm, kern_vm_start + uaddr32,
+				  page_cnt << PAGE_SHIFT, apply_range_set_cb, &data);
+	mapped = data.i;
+	if (ret)
+		goto out;
 
-		mapped += this_batch;
-		remaining -= this_batch;
-	}
 	flush_vmap_cache(kern_vm_start + uaddr32, mapped << PAGE_SHIFT);
 	raw_res_spin_unlock_irqrestore(&arena->spinlock, flags);
-	kfree_nolock(pages);
 	bpf_map_memcg_exit(old_memcg, new_memcg);
 	return clear_lo32(arena->user_vm_start) + uaddr32;
 out:
@@ -819,7 +804,7 @@ static long arena_alloc_pages(struct bpf_arena *arena, long uaddr, long page_cnt
 out_unlock_free_pages:
 	raw_res_spin_unlock_irqrestore(&arena->spinlock, flags);
 out_free_pages:
-	kfree_nolock(pages);
+	bpf_free_pages(&pages);
 	bpf_map_memcg_exit(old_memcg, new_memcg);
 	return 0;
 }
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 12bd6a05907ac..d35b2a8ae7695 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -602,7 +602,7 @@ static bool can_alloc_pages(void)
 		!IS_ENABLED(CONFIG_PREEMPT_RT);
 }
 
-static struct page *__bpf_alloc_page(int nid)
+struct page *bpf_alloc_page(int nid)
 {
 	if (!can_alloc_pages())
 		return alloc_pages_nolock(__GFP_ACCOUNT, nid, 0);
@@ -613,27 +613,34 @@ static struct page *__bpf_alloc_page(int nid)
 				0);
 }
 
-int bpf_map_alloc_pages(const struct bpf_map *map, int nid,
-			unsigned long nr_pages, struct page **pages)
+void bpf_free_pages(struct llist_head *pages)
 {
-	unsigned long i, j;
+	struct llist_node *node;
+	struct page *page, *tmp;
+
+	node = llist_del_all(pages);
+	llist_for_each_entry_safe(page, tmp, node, pcp_llist)
+		free_pages_nolock(page, 0);
+}
+
+int bpf_alloc_pages(int nid, unsigned long nr_pages,
+		    struct llist_head *pages)
+{
+	unsigned long i;
 	struct page *pg;
-	int ret = 0;
 
 	for (i = 0; i < nr_pages; i++) {
-		pg = __bpf_alloc_page(nid);
-
-		if (pg) {
-			pages[i] = pg;
-			continue;
-		}
-		for (j = 0; j < i; j++)
-			free_pages_nolock(pages[j], 0);
-		ret = -ENOMEM;
-		break;
+		pg = bpf_alloc_page(nid);
+		if (!pg)
+			goto free_pages;
+		llist_add(&pg->pcp_llist, pages);
 	}
 
-	return ret;
+	return 0;
+
+free_pages:
+	bpf_free_pages(pages);
+	return -ENOMEM;
 }
 
 static int btf_field_cmp(const void *a, const void *b)
-- 
2.53.0



