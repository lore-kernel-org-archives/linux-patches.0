Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92A31B424F;
	Sun,  7 Sep 2025 20:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276416; cv=none; b=KPniyrEyi7lznH5I/A+rNn976w/XneO/6+MBGQJI91bvUw0IgfysFHH1lUTCQivVYz3Ffa/BLo9pBLYul0apBS/eMAgy9D3bErV5twxUbGzu0jwAgfVwGVYQu0DJ9zmIYGwxJjNMlciZVo9u2H/n9P2jaIW4pbRHabn0E0Fceac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276416; c=relaxed/simple;
	bh=yuWh1Rhj+MR2c1oMSJSezu2sXAgR1SqzPyo/rRh3QZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e6IAqUgbfimVbkMiSifC/pJrq2l1fCwN4V7VN/KipcDmXAOLREnkCNYvj9aSFnN7OJ/oiTyqzYyxMqEI2zt6L2KXsnGZ90HRYNPk4MekiR9mGa7g6zgSvbg4tmO++Qu687iw+ng4lvcdnYYbwzoYJrCbiriCpaqZeYvm1eiwbTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wFoiiyAl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wFoiiyAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4798CC4CEF0;
	Sun,  7 Sep 2025 20:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276416;
	bh=yuWh1Rhj+MR2c1oMSJSezu2sXAgR1SqzPyo/rRh3QZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wFoiiyAlHxsJ7yI6agzNTAf8HBRRUSvIqKpBpNO4TPWKPndYBGy/kz8n9IV4PlrJb
	 VWsMzmUJvngRSUpLBS6Eao6lzFS+zLZfZoblS3KhUYnmRwy0U1gigYMHY9ZYgvzIY8
	 Oc6+vcPBOQMFCm3emf4IDaAvYLI2IssNtuR9VP+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@linux.ibm.com>,
	Christoph Lameter <cl@linux.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/104] mm, slub: refactor free debug processing
Date: Sun,  7 Sep 2025 21:58:54 +0200
Message-ID: <20250907195610.178941401@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlastimil Babka <vbabka@suse.cz>

[ Upstream commit fa9b88e459d710cadf3b01e8a64eda00cc91cdd6 ]

Since commit c7323a5ad078 ("mm/slub: restrict sysfs validation to debug
caches and make it safe"), caches with debugging enabled use the
free_debug_processing() function to do both freeing checks and actual
freeing to partial list under list_lock, bypassing the fast paths.

We will want to use the same path for CONFIG_SLUB_TINY, but without the
debugging checks, so refactor the code so that free_debug_processing()
does only the checks, while the freeing is handled by a new function
free_to_partial_list().

For consistency, change return parameter alloc_debug_processing() from
int to bool and correct the !SLUB_DEBUG variant to return true and not
false. This didn't matter until now, but will in the following changes.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Stable-dep-of: 850470a8413a ("mm: slub: avoid wake up kswapd in set_track_prepare")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |  154 +++++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 83 insertions(+), 71 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1368,7 +1368,7 @@ static inline int alloc_consistency_chec
 	return 1;
 }
 
-static noinline int alloc_debug_processing(struct kmem_cache *s,
+static noinline bool alloc_debug_processing(struct kmem_cache *s,
 			struct slab *slab, void *object, int orig_size)
 {
 	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
@@ -1380,7 +1380,7 @@ static noinline int alloc_debug_processi
 	trace(s, slab, object, 1);
 	set_orig_size(s, object, orig_size);
 	init_object(s, object, SLUB_RED_ACTIVE);
-	return 1;
+	return true;
 
 bad:
 	if (folio_test_slab(slab_folio(slab))) {
@@ -1393,7 +1393,7 @@ bad:
 		slab->inuse = slab->objects;
 		slab->freelist = NULL;
 	}
-	return 0;
+	return false;
 }
 
 static inline int free_consistency_checks(struct kmem_cache *s,
@@ -1646,17 +1646,17 @@ static inline void setup_object_debug(st
 static inline
 void setup_slab_debug(struct kmem_cache *s, struct slab *slab, void *addr) {}
 
-static inline int alloc_debug_processing(struct kmem_cache *s,
-	struct slab *slab, void *object, int orig_size) { return 0; }
+static inline bool alloc_debug_processing(struct kmem_cache *s,
+	struct slab *slab, void *object, int orig_size) { return true; }
 
-static inline void free_debug_processing(
-	struct kmem_cache *s, struct slab *slab,
-	void *head, void *tail, int bulk_cnt,
-	unsigned long addr) {}
+static inline bool free_debug_processing(struct kmem_cache *s,
+	struct slab *slab, void *head, void *tail, int *bulk_cnt,
+	unsigned long addr, depot_stack_handle_t handle) { return true; }
 
 static inline void slab_pad_check(struct kmem_cache *s, struct slab *slab) {}
 static inline int check_object(struct kmem_cache *s, struct slab *slab,
 			void *object, u8 val) { return 1; }
+static inline depot_stack_handle_t set_track_prepare(void) { return 0; }
 static inline void set_track(struct kmem_cache *s, void *object,
 			     enum track_item alloc, unsigned long addr) {}
 static inline void add_full(struct kmem_cache *s, struct kmem_cache_node *n,
@@ -2833,38 +2833,28 @@ static inline unsigned long node_nr_objs
 }
 
 /* Supports checking bulk free of a constructed freelist */
-static noinline void free_debug_processing(
-	struct kmem_cache *s, struct slab *slab,
-	void *head, void *tail, int bulk_cnt,
-	unsigned long addr)
+static inline bool free_debug_processing(struct kmem_cache *s,
+	struct slab *slab, void *head, void *tail, int *bulk_cnt,
+	unsigned long addr, depot_stack_handle_t handle)
 {
-	struct kmem_cache_node *n = get_node(s, slab_nid(slab));
-	struct slab *slab_free = NULL;
+	bool checks_ok = false;
 	void *object = head;
 	int cnt = 0;
-	unsigned long flags;
-	bool checks_ok = false;
-	depot_stack_handle_t handle = 0;
-
-	if (s->flags & SLAB_STORE_USER)
-		handle = set_track_prepare();
-
-	spin_lock_irqsave(&n->list_lock, flags);
 
 	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
 		if (!check_slab(s, slab))
 			goto out;
 	}
 
-	if (slab->inuse < bulk_cnt) {
+	if (slab->inuse < *bulk_cnt) {
 		slab_err(s, slab, "Slab has %d allocated objects but %d are to be freed\n",
-			 slab->inuse, bulk_cnt);
+			 slab->inuse, *bulk_cnt);
 		goto out;
 	}
 
 next_object:
 
-	if (++cnt > bulk_cnt)
+	if (++cnt > *bulk_cnt)
 		goto out_cnt;
 
 	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
@@ -2886,57 +2876,18 @@ next_object:
 	checks_ok = true;
 
 out_cnt:
-	if (cnt != bulk_cnt)
+	if (cnt != *bulk_cnt) {
 		slab_err(s, slab, "Bulk free expected %d objects but found %d\n",
-			 bulk_cnt, cnt);
-
-out:
-	if (checks_ok) {
-		void *prior = slab->freelist;
-
-		/* Perform the actual freeing while we still hold the locks */
-		slab->inuse -= cnt;
-		set_freepointer(s, tail, prior);
-		slab->freelist = head;
-
-		/*
-		 * If the slab is empty, and node's partial list is full,
-		 * it should be discarded anyway no matter it's on full or
-		 * partial list.
-		 */
-		if (slab->inuse == 0 && n->nr_partial >= s->min_partial)
-			slab_free = slab;
-
-		if (!prior) {
-			/* was on full list */
-			remove_full(s, n, slab);
-			if (!slab_free) {
-				add_partial(n, slab, DEACTIVATE_TO_TAIL);
-				stat(s, FREE_ADD_PARTIAL);
-			}
-		} else if (slab_free) {
-			remove_partial(n, slab);
-			stat(s, FREE_REMOVE_PARTIAL);
-		}
+			 *bulk_cnt, cnt);
+		*bulk_cnt = cnt;
 	}
 
-	if (slab_free) {
-		/*
-		 * Update the counters while still holding n->list_lock to
-		 * prevent spurious validation warnings
-		 */
-		dec_slabs_node(s, slab_nid(slab_free), slab_free->objects);
-	}
-
-	spin_unlock_irqrestore(&n->list_lock, flags);
+out:
 
 	if (!checks_ok)
 		slab_fix(s, "Object at 0x%p not freed", object);
 
-	if (slab_free) {
-		stat(s, FREE_SLAB);
-		free_slab(s, slab_free);
-	}
+	return checks_ok;
 }
 #endif /* CONFIG_SLUB_DEBUG */
 
@@ -3453,6 +3404,67 @@ void *kmem_cache_alloc_node(struct kmem_
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node);
 
+static noinline void free_to_partial_list(
+	struct kmem_cache *s, struct slab *slab,
+	void *head, void *tail, int bulk_cnt,
+	unsigned long addr)
+{
+	struct kmem_cache_node *n = get_node(s, slab_nid(slab));
+	struct slab *slab_free = NULL;
+	int cnt = bulk_cnt;
+	unsigned long flags;
+	depot_stack_handle_t handle = 0;
+
+	if (s->flags & SLAB_STORE_USER)
+		handle = set_track_prepare();
+
+	spin_lock_irqsave(&n->list_lock, flags);
+
+	if (free_debug_processing(s, slab, head, tail, &cnt, addr, handle)) {
+		void *prior = slab->freelist;
+
+		/* Perform the actual freeing while we still hold the locks */
+		slab->inuse -= cnt;
+		set_freepointer(s, tail, prior);
+		slab->freelist = head;
+
+		/*
+		 * If the slab is empty, and node's partial list is full,
+		 * it should be discarded anyway no matter it's on full or
+		 * partial list.
+		 */
+		if (slab->inuse == 0 && n->nr_partial >= s->min_partial)
+			slab_free = slab;
+
+		if (!prior) {
+			/* was on full list */
+			remove_full(s, n, slab);
+			if (!slab_free) {
+				add_partial(n, slab, DEACTIVATE_TO_TAIL);
+				stat(s, FREE_ADD_PARTIAL);
+			}
+		} else if (slab_free) {
+			remove_partial(n, slab);
+			stat(s, FREE_REMOVE_PARTIAL);
+		}
+	}
+
+	if (slab_free) {
+		/*
+		 * Update the counters while still holding n->list_lock to
+		 * prevent spurious validation warnings
+		 */
+		dec_slabs_node(s, slab_nid(slab_free), slab_free->objects);
+	}
+
+	spin_unlock_irqrestore(&n->list_lock, flags);
+
+	if (slab_free) {
+		stat(s, FREE_SLAB);
+		free_slab(s, slab_free);
+	}
+}
+
 /*
  * Slow path handling. This may still be called frequently since objects
  * have a longer lifetime than the cpu slabs in most processing loads.
@@ -3479,7 +3491,7 @@ static void __slab_free(struct kmem_cach
 		return;
 
 	if (kmem_cache_debug(s)) {
-		free_debug_processing(s, slab, head, tail, cnt, addr);
+		free_to_partial_list(s, slab, head, tail, cnt, addr);
 		return;
 	}
 


