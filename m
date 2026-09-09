Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B3329346F;
	Wed,  9 Sep 2026 14:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964883; cv=none; b=TT6LmYlvOyafSizuMme/Ea37SRwI7ObNxP2VqoF8vR/qtH1t13HXtJ0Cgk5gajQgIw86C7b9POdhF2d6tB1TwZHhhipUjOzJNREQ2cCCkOUUIpuK5HybquwG1IMHjDsAhpmbhhQDh5KmIWnPyPBKJIaTF8WbUHl4ORRLi8chRqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964883; c=relaxed/simple;
	bh=MdqDNtI5ZY6U1/m26Punv4lsxLiYSkKi8fJbc/vaELw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hy1hRR5I2d2gdS7VkIZH8p+e241A17HyMOuvFBSNdHK6hO8BGakSUwYyfwzSR9xbXpgGpnanfMkv8cW3e4GXR9ouMIU7zwr/p+7Jnuhb+HIfiSbDcwmCOAeq4JDuDaG1B19MErjRXkNO5VhJM+g9HjIdcHwyjLE68SexS6qvZ+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJsrDHbi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJsrDHbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF591F00A3A;
	Wed,  9 Sep 2026 14:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964881;
	bh=V0WhVbgBsHicqjFe5sxAex7KsG29AbwXJG8Gz6RVTk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bJsrDHbiOriVhfzNhY7Qg7g4iLGWlYp+8WQNaOr4B4wx1p9q1PM5G5QsTnwPp7gkQ
	 8edobYo+OuNIjc0e5b37o9CQocxCWWhtt+D2JrGSFcDnI4kxu9ROJdqaVi++oZwteZ
	 Jkib3tGsYaRqeTVZJuwQ2UtqHvnpCehpFnAqsZX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Wei Yang <richard.weiyang@gmail.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lance Yang <lance.yang@linux.dev>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Nico Pache <npache@redhat.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 576/583] mm: thp: use folio_batch to handle THP splitting in deferred_split_scan()
Date: Wed,  9 Sep 2026 15:44:21 +0200
Message-ID: <20260909134257.771177460@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Muchun Song <songmuchun@bytedance.com>

[ Upstream commit 776bde7caf80f6af72b087cafe7d9f607b14716d ]

The maintenance of the folio->_deferred_list is intricate because it's
reused in a local list.

Here are some peculiarities:

   1) When a folio is removed from its split queue and added to a local
      on-stack list in deferred_split_scan(), the ->split_queue_len isn't
      updated, leading to an inconsistency between it and the actual
      number of folios in the split queue.

   2) When the folio is split via split_folio() later, it's removed from
      the local list while holding the split queue lock. At this time,
      the lock is not needed as it is not protecting anything.

   3) To handle the race condition with a third-party freeing or migrating
      the preceding folio, we must ensure there's always one safe (with
      raised refcount) folio before by delaying its folio_put(). More
      details can be found in commit e66f3185fa04 ("mm/thp: fix deferred
      split queue not partially_mapped"). It's rather tricky.

We can use the folio_batch infrastructure to handle this clearly.  In this
case, ->split_queue_len will be consistent with the real number of folios
in the split queue.  If list_empty(&folio->_deferred_list) returns false,
it's clear the folio must be in its split queue (not in a local list
anymore).

In the future, we will reparent LRU folios during memcg offline to
eliminate dying memory cgroups, which requires reparenting the split queue
to its parent first.  So this patch prepares for using
folio_split_queue_lock_irqsave() as the memcg may change then.

Link: https://lkml.kernel.org/r/59cb6b6fb5ffcff9d23b81890b252960139ad8e7.1762762324.git.zhengqi.arch@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: c299a2285d9d ("mm/huge_memory: use folio's memcg inside __folio_split()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |  134 +++++++++++++++++++++++++++----------------------------
 1 file changed, 68 insertions(+), 66 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3688,19 +3688,21 @@ static int __folio_split(struct folio *f
 	bool is_anon = folio_test_anon(folio);
 	struct address_space *mapping = NULL;
 	struct anon_vma *anon_vma = NULL;
-	int order = folio_order(folio);
+	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
+	int extra_pins;
 	int nr_shmem_dropped = 0;
-	int remap_flags = 0;
-	int extra_pins, ret;
-	pgoff_t end;
-	bool is_hzp;
+	enum ttu_flags ttu_flags = 0;
+	pgoff_t end = 0;
+	int ret;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
 
-	if (folio != page_folio(split_at) || folio != page_folio(lock_at))
-		return -EINVAL;
+	if (folio != page_folio(split_at) || folio != page_folio(lock_at)) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	/*
 	 * Folios that just got truncated cannot get split. Signal to the
@@ -3712,14 +3714,12 @@ static int __folio_split(struct folio *f
 	if (!is_anon && !folio->mapping)
 		return -EBUSY;
 
-	if (new_order >= folio_order(folio))
-		return -EINVAL;
-
-	if (!folio_split_supported(folio, new_order, uniform_split, /* warn = */ true))
-		return -EINVAL;
+	if (new_order >= old_order) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-	is_hzp = is_huge_zero_folio(folio);
-	if (is_hzp) {
+	if (is_huge_zero_folio(folio)) {
 		pr_warn_ratelimited("Called split_huge_page for huge zero page\n");
 		return -EBUSY;
 	}
@@ -3727,6 +3727,13 @@ static int __folio_split(struct folio *f
 	if (folio_test_writeback(folio))
 		return -EBUSY;
 
+	ret = folio_split_supported(folio, new_order, uniform_split,
+				    /* warns = */ false) ? 0 : -EINVAL;
+	if (ret) {
+		VM_WARN_ONCE(ret == -EINVAL, "Tried to split an unsplittable folio");
+		goto out;
+	}
+
 	if (is_anon) {
 		/*
 		 * The caller does not necessarily hold an mmap_lock that would
@@ -3819,21 +3826,22 @@ static int __folio_split(struct folio *f
 		struct lruvec *lruvec;
 		int expected_refs;
 
-		if (folio_order(folio) > 1 &&
-		    !list_empty(&folio->_deferred_list)) {
-			ds_queue->split_queue_len--;
+		if (folio_order(folio) > 1) {
+			if (!list_empty(&folio->_deferred_list)) {
+				ds_queue->split_queue_len--;
+				/*
+				 * Reinitialize page_deferred_list after removing the
+				 * page from the split_queue, otherwise a subsequent
+				 * split will see list corruption when checking the
+				 * page_deferred_list.
+				 */
+				list_del_init(&folio->_deferred_list);
+			}
 			if (folio_test_partially_mapped(folio)) {
 				folio_clear_partially_mapped(folio);
 				mod_mthp_stat(folio_order(folio),
 					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 			}
-			/*
-			 * Reinitialize page_deferred_list after removing the
-			 * page from the split_queue, otherwise a subsequent
-			 * split will see list corruption when checking the
-			 * page_deferred_list.
-			 */
-			list_del_init(&folio->_deferred_list);
 		}
 		split_queue_unlock(ds_queue);
 		if (mapping) {
@@ -3943,8 +3951,8 @@ fail:
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
 
 	if (!ret && is_anon)
-		remap_flags = RMP_USE_SHARED_ZEROPAGE;
-	remap_page(folio, 1 << order, remap_flags);
+		ttu_flags = (enum ttu_flags)RMP_USE_SHARED_ZEROPAGE;
+	remap_page(folio, 1 << old_order, ttu_flags);
 
 	/*
 	 * Drop the mapping while the inode is still pinned. @folio stays
@@ -3987,9 +3995,9 @@ out_unlock:
 		i_mmap_unlock_read(mapping);
 out:
 	xas_destroy(&xas);
-	if (order == HPAGE_PMD_ORDER)
+	if (old_order == HPAGE_PMD_ORDER)
 		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
-	count_mthp_stat(order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);
+	count_mthp_stat(old_order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);
 	return ret;
 }
 
@@ -4232,35 +4240,40 @@ static unsigned long deferred_split_scan
 {
 	struct deferred_split *ds_queue;
 	unsigned long flags;
-	LIST_HEAD(list);
-	struct folio *folio, *next, *prev = NULL;
-	int split = 0, removed = 0;
+	struct folio *folio, *next;
+	int split = 0, i;
+	struct folio_batch fbatch;
+
+	folio_batch_init(&fbatch);
 
+retry:
 	ds_queue = split_queue_lock_irqsave(sc->nid, sc->memcg, &flags);
 	/* Take pin on all head pages to avoid freeing them under us */
 	list_for_each_entry_safe(folio, next, &ds_queue->split_queue,
 							_deferred_list) {
 		if (folio_try_get(folio)) {
-			list_move(&folio->_deferred_list, &list);
-		} else {
+			folio_batch_add(&fbatch, folio);
+		} else if (folio_test_partially_mapped(folio)) {
 			/* We lost race with folio_put() */
-			if (folio_test_partially_mapped(folio)) {
-				folio_clear_partially_mapped(folio);
-				mod_mthp_stat(folio_order(folio),
-					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
-			}
-			list_del_init(&folio->_deferred_list);
-			ds_queue->split_queue_len--;
+			folio_clear_partially_mapped(folio);
+			mod_mthp_stat(folio_order(folio),
+				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 		}
+		list_del_init(&folio->_deferred_list);
+		ds_queue->split_queue_len--;
 		if (!--sc->nr_to_scan)
 			break;
+		if (!folio_batch_space(&fbatch))
+			break;
 	}
 	split_queue_unlock_irqrestore(ds_queue, flags);
 
-	list_for_each_entry_safe(folio, next, &list, _deferred_list) {
+	for (i = 0; i < folio_batch_count(&fbatch); i++) {
 		bool did_split = false;
 		bool underused = false;
+		struct deferred_split *fqueue;
 
+		folio = fbatch.folios[i];
 		if (!folio_test_partially_mapped(folio)) {
 			/*
 			 * See try_to_map_unused_to_zeropage(): we cannot
@@ -4283,39 +4296,28 @@ static unsigned long deferred_split_scan
 		}
 		folio_unlock(folio);
 next:
+		if (did_split || !folio_test_partially_mapped(folio))
+			continue;
 		/*
-		 * split_folio() removes folio from list on success.
 		 * Only add back to the queue if folio is partially mapped.
 		 * If thp_underused returns false, or if split_folio fails
 		 * in the case it was underused, then consider it used and
 		 * don't add it back to split_queue.
 		 */
-		if (did_split) {
-			; /* folio already removed from list */
-		} else if (!folio_test_partially_mapped(folio)) {
-			list_del_init(&folio->_deferred_list);
-			removed++;
-		} else {
-			/*
-			 * That unlocked list_del_init() above would be unsafe,
-			 * unless its folio is separated from any earlier folios
-			 * left on the list (which may be concurrently unqueued)
-			 * by one safe folio with refcount still raised.
-			 */
-			swap(folio, prev);
-		}
-		if (folio)
-			folio_put(folio);
+		fqueue = folio_split_queue_lock_irqsave(folio, &flags);
+		if (list_empty(&folio->_deferred_list)) {
+			list_add_tail(&folio->_deferred_list, &fqueue->split_queue);
+			fqueue->split_queue_len++;
+		}
+		split_queue_unlock_irqrestore(fqueue, flags);
+	}
+	folios_put(&fbatch);
+
+	if (sc->nr_to_scan && !list_empty(&ds_queue->split_queue)) {
+		cond_resched();
+		goto retry;
 	}
 
-	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
-	list_splice_tail(&list, &ds_queue->split_queue);
-	ds_queue->split_queue_len -= removed;
-	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
-
-	if (prev)
-		folio_put(prev);
-
 	/*
 	 * Stop shrinker if we didn't split any page, but the queue is empty.
 	 * This can happen if pages were freed under us.


