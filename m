Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD70629CE7;
	Wed,  2 Oct 2024 13:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877144; cv=none; b=eeNXGk5VaKnNOLRmZRtInnFVksldA8p20pr09n1WfV+UnIde4xfXo19JZLZxhcsGfWG7D11mBJC2tlFnj7yjiZRFqP2yh0L7bnz8/mdbjd2tHhGhiFdM/xXaRnvfDZ8LQGwWvEK9L2lqQIuARhv5eKPIRc/6jr3XkBEvjN8Y0i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877144; c=relaxed/simple;
	bh=K8lZHbETEWWNoON7+ebc2hoo2sFdmrBoDysDC0q1d+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjyPZ0zg7UYfbh5Du2O4EQU/Lm7vmd+/6mWkKgGMRjNgiPcuk5+Myrh28Gql013egj7bvpkx49EPt6J4bG0cwFbMlXUMyywx3gEKPbKhCheRFcW8NRuOu3P6BBtkQOqH5N6LcnZ2UQlQQH64FExqI8fN8gpCKk57F0SRB2xkexM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z23r6YVa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z23r6YVa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45793C4CEC2;
	Wed,  2 Oct 2024 13:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877144;
	bh=K8lZHbETEWWNoON7+ebc2hoo2sFdmrBoDysDC0q1d+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z23r6YVaBleA0c99dHxGOs1AzJ1PpsNHcyrEj1NOdm3H9kMvfYmk5XemshHj4qeim
	 lF4JqCLi8mkvR/UDJf/wwcD5yM7PFTooAFt+k0uewtizQJMOpLNe0a4X4p6F27OnBf
	 h27rSHUK5aFh7uEoXQTSSHukb892Siz+NSgRK5Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Zhao <yuzhao@google.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 679/695] mm/hugetlb_vmemmap: batch HVO work when demoting
Date: Wed,  2 Oct 2024 15:01:17 +0200
Message-ID: <20241002125849.620782341@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Zhao <yuzhao@google.com>

commit c0f398c3b2cf67976bca216f80668b9c93368385 upstream.

Batch the HVO work, including de-HVO of the source and HVO of the
destination hugeTLB folios, to speed up demotion.

After commit bd225530a4c7 ("mm/hugetlb_vmemmap: fix race with speculative
PFN walkers"), each request of HVO or de-HVO, batched or not, invokes
synchronize_rcu() once.  For example, when not batched, demoting one 1GB
hugeTLB folio to 512 2MB hugeTLB folios invokes synchronize_rcu() 513
times (1 de-HVO plus 512 HVO requests), whereas when batched, only twice
(1 de-HVO plus 1 HVO request).  And the performance difference between the
two cases is significant, e.g.,

  echo 2048kB >/sys/kernel/mm/hugepages/hugepages-1048576kB/demote_size
  time echo 100 >/sys/kernel/mm/hugepages/hugepages-1048576kB/demote

Before this patch:
  real     8m58.158s
  user     0m0.009s
  sys      0m5.900s

After this patch:
  real     0m0.900s
  user     0m0.000s
  sys      0m0.851s

Note that this patch changes the behavior of the `demote` interface when
de-HVO fails.  Before, the interface aborts immediately upon failure; now,
it tries to finish an entire batch, meaning it can make extra progress if
the rest of the batch contains folios that do not need to de-HVO.

Link: https://lkml.kernel.org/r/20240812224823.3914837-1-yuzhao@google.com
Fixes: bd225530a4c7 ("mm/hugetlb_vmemmap: fix race with speculative PFN walkers")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |  156 ++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 92 insertions(+), 64 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3921,101 +3921,125 @@ out:
 	return 0;
 }
 
-static int demote_free_hugetlb_folio(struct hstate *h, struct folio *folio)
+static long demote_free_hugetlb_folios(struct hstate *src, struct hstate *dst,
+				       struct list_head *src_list)
 {
-	int i, nid = folio_nid(folio);
-	struct hstate *target_hstate;
-	struct page *subpage;
-	struct folio *inner_folio;
-	int rc = 0;
+	long rc;
+	struct folio *folio, *next;
+	LIST_HEAD(dst_list);
+	LIST_HEAD(ret_list);
 
-	target_hstate = size_to_hstate(PAGE_SIZE << h->demote_order);
-
-	remove_hugetlb_folio(h, folio, false);
-	spin_unlock_irq(&hugetlb_lock);
-
-	/*
-	 * If vmemmap already existed for folio, the remove routine above would
-	 * have cleared the hugetlb folio flag.  Hence the folio is technically
-	 * no longer a hugetlb folio.  hugetlb_vmemmap_restore_folio can only be
-	 * passed hugetlb folios and will BUG otherwise.
-	 */
-	if (folio_test_hugetlb(folio)) {
-		rc = hugetlb_vmemmap_restore_folio(h, folio);
-		if (rc) {
-			/* Allocation of vmemmmap failed, we can not demote folio */
-			spin_lock_irq(&hugetlb_lock);
-			add_hugetlb_folio(h, folio, false);
-			return rc;
-		}
-	}
-
-	/*
-	 * Use destroy_compound_hugetlb_folio_for_demote for all huge page
-	 * sizes as it will not ref count folios.
-	 */
-	destroy_compound_hugetlb_folio_for_demote(folio, huge_page_order(h));
+	rc = hugetlb_vmemmap_restore_folios(src, src_list, &ret_list);
+	list_splice_init(&ret_list, src_list);
 
 	/*
 	 * Taking target hstate mutex synchronizes with set_max_huge_pages.
 	 * Without the mutex, pages added to target hstate could be marked
 	 * as surplus.
 	 *
-	 * Note that we already hold h->resize_lock.  To prevent deadlock,
+	 * Note that we already hold src->resize_lock.  To prevent deadlock,
 	 * use the convention of always taking larger size hstate mutex first.
 	 */
-	mutex_lock(&target_hstate->resize_lock);
-	for (i = 0; i < pages_per_huge_page(h);
-				i += pages_per_huge_page(target_hstate)) {
-		subpage = folio_page(folio, i);
-		inner_folio = page_folio(subpage);
-		if (hstate_is_gigantic(target_hstate))
-			prep_compound_gigantic_folio_for_demote(inner_folio,
-							target_hstate->order);
-		else
-			prep_compound_page(subpage, target_hstate->order);
-		folio_change_private(inner_folio, NULL);
-		prep_new_hugetlb_folio(target_hstate, inner_folio, nid);
-		free_huge_folio(inner_folio);
+	mutex_lock(&dst->resize_lock);
+
+	list_for_each_entry_safe(folio, next, src_list, lru) {
+		int i;
+
+		if (folio_test_hugetlb_vmemmap_optimized(folio))
+			continue;
+
+		list_del(&folio->lru);
+		/*
+		 * Use destroy_compound_hugetlb_folio_for_demote for all huge page
+		 * sizes as it will not ref count folios.
+		 */
+		destroy_compound_hugetlb_folio_for_demote(folio, huge_page_order(src));
+
+		for (i = 0; i < pages_per_huge_page(src); i += pages_per_huge_page(dst)) {
+			struct page *page = folio_page(folio, i);
+
+			if (hstate_is_gigantic(dst))
+				prep_compound_gigantic_folio_for_demote(page_folio(page),
+									dst->order);
+			else
+				prep_compound_page(page, dst->order);
+			set_page_private(page, 0);
+
+			init_new_hugetlb_folio(dst, page_folio(page));
+			list_add(&page->lru, &dst_list);
+		}
 	}
-	mutex_unlock(&target_hstate->resize_lock);
 
-	spin_lock_irq(&hugetlb_lock);
+	prep_and_add_allocated_folios(dst, &dst_list);
 
-	/*
-	 * Not absolutely necessary, but for consistency update max_huge_pages
-	 * based on pool changes for the demoted page.
-	 */
-	h->max_huge_pages--;
-	target_hstate->max_huge_pages +=
-		pages_per_huge_page(h) / pages_per_huge_page(target_hstate);
+	mutex_unlock(&dst->resize_lock);
 
 	return rc;
 }
 
-static int demote_pool_huge_page(struct hstate *h, nodemask_t *nodes_allowed)
+static long demote_pool_huge_page(struct hstate *src, nodemask_t *nodes_allowed,
+				  unsigned long nr_to_demote)
 	__must_hold(&hugetlb_lock)
 {
 	int nr_nodes, node;
-	struct folio *folio;
+	struct hstate *dst;
+	long rc = 0;
+	long nr_demoted = 0;
 
 	lockdep_assert_held(&hugetlb_lock);
 
 	/* We should never get here if no demote order */
-	if (!h->demote_order) {
+	if (!src->demote_order) {
 		pr_warn("HugeTLB: NULL demote order passed to demote_pool_huge_page.\n");
 		return -EINVAL;		/* internal error */
 	}
+	dst = size_to_hstate(PAGE_SIZE << src->demote_order);
 
-	for_each_node_mask_to_free(h, nr_nodes, node, nodes_allowed) {
-		list_for_each_entry(folio, &h->hugepage_freelists[node], lru) {
+	for_each_node_mask_to_free(src, nr_nodes, node, nodes_allowed) {
+		LIST_HEAD(list);
+		struct folio *folio, *next;
+
+		list_for_each_entry_safe(folio, next, &src->hugepage_freelists[node], lru) {
 			if (folio_test_hwpoison(folio))
 				continue;
-			return demote_free_hugetlb_folio(h, folio);
+
+			remove_hugetlb_folio(src, folio, false);
+			list_add(&folio->lru, &list);
+
+			if (++nr_demoted == nr_to_demote)
+				break;
+		}
+
+		spin_unlock_irq(&hugetlb_lock);
+
+		rc = demote_free_hugetlb_folios(src, dst, &list);
+
+		spin_lock_irq(&hugetlb_lock);
+
+		list_for_each_entry_safe(folio, next, &list, lru) {
+			list_del(&folio->lru);
+			add_hugetlb_folio(src, folio, false);
+
+			nr_demoted--;
 		}
+
+		if (rc < 0 || nr_demoted == nr_to_demote)
+			break;
 	}
 
 	/*
+	 * Not absolutely necessary, but for consistency update max_huge_pages
+	 * based on pool changes for the demoted page.
+	 */
+	src->max_huge_pages -= nr_demoted;
+	dst->max_huge_pages += nr_demoted << (huge_page_order(src) - huge_page_order(dst));
+
+	if (rc < 0)
+		return rc;
+
+	if (nr_demoted)
+		return nr_demoted;
+	/*
 	 * Only way to get here is if all pages on free lists are poisoned.
 	 * Return -EBUSY so that caller will not retry.
 	 */
@@ -4249,6 +4273,8 @@ static ssize_t demote_store(struct kobje
 	spin_lock_irq(&hugetlb_lock);
 
 	while (nr_demote) {
+		long rc;
+
 		/*
 		 * Check for available pages to demote each time thorough the
 		 * loop as demote_pool_huge_page will drop hugetlb_lock.
@@ -4261,11 +4287,13 @@ static ssize_t demote_store(struct kobje
 		if (!nr_available)
 			break;
 
-		err = demote_pool_huge_page(h, n_mask);
-		if (err)
+		rc = demote_pool_huge_page(h, n_mask, nr_demote);
+		if (rc < 0) {
+			err = rc;
 			break;
+		}
 
-		nr_demote--;
+		nr_demote -= rc;
 	}
 
 	spin_unlock_irq(&hugetlb_lock);


