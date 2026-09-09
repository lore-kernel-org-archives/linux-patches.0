Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D78455409E;
	Wed,  9 Sep 2026 14:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964901; cv=none; b=r9n139KcyTnpJ1o24PE8Y9d+nqx/pgrENcgRhoYYSgjPx4y+nChfj3mJk/p/g28CBF1WNQDjJpt9zMgKryof15ydlOt3y/foLqXhvMh51jRyRHbhPLwI31+ztcKgvSGAggexQaYuimc+Q8ZNJDqxiz/3pkmRr2HfVkVvpiq3EYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964901; c=relaxed/simple;
	bh=gSyochdDwXdOoDvOkzg/DV9JmwFoqv6mS+TOIn+yq44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUqiGaTirkRLJ7DkToa7epXZG/Dsp3R9HtFz68zf0mkxo8IzNjCmQyeKSSbEGi3ILBxCHk6q/Mh0yu5q8on+WVrX48qBz9uzCpSFUL9lUXwOHI7ZLXzCof2G6nKmZRA76xf5nqdiO0covU/JBU46R2NnivOEuzL+AEuj5/PR41M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UnSxV/Vl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UnSxV/Vl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0388D1F00A3D;
	Wed,  9 Sep 2026 14:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964900;
	bh=S4BzLA9cyye+P2igOk+nn/IBZ/ZNHd++D2TzbwKwu2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UnSxV/VlwvucZHfDmaqqEopBQNGIG5wYSTll1HoI+t8wlkHLpZXsSAHBj9FodlFE5
	 avPf0QySNx0KJ6Ez8u73lq6saxSNim90LcsgMAbsaG/3Rz+ESyLyqFN9vt8B8ZeYvz
	 W9YGPVNWhSfZNQ9A7e8txivR7jgius+SK3PnQLB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <songmuchun@bytedance.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Oscar Salvador (SUSE)" <osalvador@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 582/583] mm/hugetlb_vmemmap: fix incorrect vmemmap restore in rollback
Date: Wed,  9 Sep 2026 15:44:27 +0200
Message-ID: <20260909134257.954622721@linuxfoundation.org>
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

commit c7bde43f6daf70e05a64fbca7efdf6fa93e057dc upstream.

vmemmap_restore_pte() rebuilds restored vmemmap pages from a tail-page
template derived from compound_head().  This is wrong when the current PTE
already maps a page whose contents are not tail-page metadata.

In the rollback path of vmemmap_remap_free(), the first restored PTE is
backed by vmemmap_head and contains head-page metadata.  Reconstructing
that page from a tail-page template overwrites the head-page state and
corrupts the restored vmemmap page.

Fix this by copying the full page from the page currently mapped by the
PTE.  Also pass vmemmap_tail to the rollback walk so only PTEs backed by
the shared tail page are restored, while the head PTE remains mapped to
vmemmap_head.  Add VM_WARN_ON_ONCE() checks for unexpected cases.

Link: https://lore.kernel.org/20260525025213.2229628-1-songmuchun@bytedance.com
Fixes: c0b495b91a47 ("mm/hugetlb: refactor code around vmemmap_walk")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb_vmemmap.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -205,6 +205,8 @@ static void vmemmap_remap_pte(pte_t *pte
 
 	/* Remapping the head page requires r/w */
 	if (unlikely(walk->nr_walked == 0 && walk->vmemmap_head)) {
+		VM_WARN_ON_ONCE(!PageHead((const struct page *)addr));
+
 		list_del(&walk->vmemmap_head->lru);
 
 		/*
@@ -216,6 +218,8 @@ static void vmemmap_remap_pte(pte_t *pte
 
 		entry = mk_pte(walk->vmemmap_head, PAGE_KERNEL);
 	} else {
+		VM_WARN_ON_ONCE(!PageTail((const struct page *)addr));
+
 		/*
 		 * Remap the tail pages as read-only to catch illegal write
 		 * operation to the tail pages.
@@ -230,33 +234,28 @@ static void vmemmap_remap_pte(pte_t *pte
 static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
 				struct vmemmap_remap_walk *walk)
 {
-	struct page *page;
-	struct page *from, *to;
-
-	page = list_first_entry(walk->vmemmap_pages, struct page, lru);
-	list_del(&page->lru);
+	struct page *src = pte_page(ptep_get(pte)), *dst;
 
 	/*
-	 * Initialize tail pages in the newly allocated vmemmap page.
-	 *
-	 * There is folio-scope metadata that is encoded in the first few
-	 * tail pages.
-	 *
-	 * Use the value last tail page in the page with the head page
-	 * to initialize the rest of tail pages.
+	 * When rolling back vmemmap_remap_free(), keep the copied head page
+	 * mapping and restore only PTEs currently pointing at the shared tail
+	 * page.
 	 */
-	from = compound_head((struct page *)addr) +
-		PAGE_SIZE / sizeof(struct page) - 1;
-	to = page_to_virt(page);
-	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++, to++)
-		*to = *from;
+	if (walk->vmemmap_tail && walk->vmemmap_tail != src)
+		return;
+
+	VM_WARN_ON_ONCE(PageHead((const struct page *)addr));
+
+	dst = list_first_entry(walk->vmemmap_pages, struct page, lru);
+	list_del(&dst->lru);
+	copy_page(page_to_virt(dst), page_to_virt(src));
 
 	/*
 	 * Makes sure that preceding stores to the page contents become visible
 	 * before the set_pte_at() write.
 	 */
 	smp_wmb();
-	set_pte_at(&init_mm, addr, pte, mk_pte(page, PAGE_KERNEL));
+	set_pte_at(&init_mm, addr, pte, mk_pte(dst, PAGE_KERNEL));
 }
 
 /**
@@ -322,6 +321,7 @@ static int vmemmap_remap_free(unsigned l
 	 */
 	walk = (struct vmemmap_remap_walk) {
 		.remap_pte	= vmemmap_restore_pte,
+		.vmemmap_tail	= vmemmap_tail,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= 0,
 	};


