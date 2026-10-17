Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B386A3BFE26;
	Sat, 17 Oct 2026 16:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255669; cv=none; b=dhVewyfZedOMr26QpS5UZgF3mM3R+/vcL6HX7uI7rLEqHl4Mdq0nGdYVNZkigE3EYW6FsfvKb3CT5HDkUy8ucaFe3l6B/OSDrtq0tCtMSkqNNXp2c8fXJN4gOU98hgTOk6XMdqAh4xQOKZ4NuXpqIjJRuhaPBhrakSzPJ6NGTeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255669; c=relaxed/simple;
	bh=SEhUSnKgjKYfzUfW3B+5IP2u1b4ddP6HjZIZpk0ugkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjzYAY/JeHAYKx/hOkNKDCHLe6OfzKPto7093YYGOlaps1KCVlOz+TDFMFdBxgnNoS38wtvfkTZkRoN9izjsSd4aMRK29i8sbWbEZmogQdy8e3ZarNNlj8VjzfVh7X9E9VYctSHt9jtBOt0xZepebcX6I1LKewlA/IktmznsFeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YVU9iXtx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YVU9iXtx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FFCB1F000C4;
	Sat, 17 Oct 2026 16:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255668;
	bh=Hblcead7fs1ZFVgPMswU1wwRVLM2+IknxcHeIO2/OYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YVU9iXtxss+1LRj6Z8r6TcY2vf6HhOrKzYGAT6zwgPKTW44tcHz/SgcFv+D0J+h2F
	 9iFaNyqVr5x88wX76O7d1DJB7/Z/Li1J7FiIq3Z7zzYKdCoOCAf02o+I8lOVKaZASe
	 Zku5z+xmEXmckgI8mr4BAwc17n4PEihgDYdH0P7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <songmuchun@bytedance.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Oscar Salvador (SUSE)" <osalvador@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 853/869] mm/hugetlb_vmemmap: fix incorrect vmemmap restore in rollback
Date: Sat, 17 Oct 2026 18:01:34 +0200
Message-ID: <20261017160058.733797021@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Muchun Song <songmuchun@bytedance.com>

[ Upstream commit c7bde43f6daf70e05a64fbca7efdf6fa93e057dc ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb_vmemmap.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 1394c13c1516f..52e68a7df2c88 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -207,6 +207,8 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 
 	/* Remapping the head page requires r/w */
 	if (unlikely(walk->nr_walked == 0 && walk->vmemmap_head)) {
+		VM_WARN_ON_ONCE(!PageHead((const struct page *)addr));
+
 		list_del(&walk->vmemmap_head->lru);
 
 		/*
@@ -218,6 +220,8 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 
 		entry = mk_pte(walk->vmemmap_head, PAGE_KERNEL);
 	} else {
+		VM_WARN_ON_ONCE(!PageTail((const struct page *)addr));
+
 		/*
 		 * Remap the tail pages as read-only to catch illegal write
 		 * operation to the tail pages.
@@ -232,33 +236,28 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
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
@@ -324,6 +323,7 @@ static int vmemmap_remap_free(unsigned long start, unsigned long end,
 	 */
 	walk = (struct vmemmap_remap_walk) {
 		.remap_pte	= vmemmap_restore_pte,
+		.vmemmap_tail	= vmemmap_tail,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= 0,
 	};
-- 
2.53.0



