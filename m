Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9AD199B3
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JluD7le7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CADC433CC;
	Mon,  9 Oct 2023 13:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857375;
	bh=E1EE3gLV+GgDFYLBQJmzKj7Sqqiq8nulcGZD42YNvno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JluD7le7GgenPexyvrYqT8YWc/gd1slmYXhVZuT5mTGKpz4Aebc7uaeM0Dh0vxZQA
	 dqGZ1XwORSwHXaLhg6PlRSj+G9DOojeY1zsttudxupQyZjp2oiPU78T3OO7DLtEN/q
	 3rKUDgccU4z9RrHAkpr0K13qxo1LebwhzuObqrUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Jane Chu <jane.chu@oracle.com>,
	"Yin, Fengwei" <fengwei.yin@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/162] mm/mempolicy: convert queue_pages_pte_range() to queue_folios_pte_range()
Date: Mon,  9 Oct 2023 15:00:07 +0200
Message-ID: <20231009130123.666544471@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vishal Moola (Oracle) <vishal.moola@gmail.com>

[ Upstream commit 3dae02bbd07f40e37bbfec2d77119628db461eaa ]

This function now operates on folios associated with ptes instead of
pages.

This change is in preparation for the conversion of queue_pages_required()
to queue_folio_required() and migrate_page_add() to migrate_folio_add().

Link: https://lkml.kernel.org/r/20230130201833.27042-4-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: "Yin, Fengwei" <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 24526268f4e3 ("mm: mempolicy: keep VMA walk if both MPOL_MF_STRICT and MPOL_MF_MOVE are specified")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mempolicy.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 3a291026e1896..2ae6c8f18aba1 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -491,19 +491,19 @@ static int queue_folios_pmd(pmd_t *pmd, spinlock_t *ptl, unsigned long addr,
  * Scan through pages checking if pages follow certain conditions,
  * and move them to the pagelist if they do.
  *
- * queue_pages_pte_range() has three possible return values:
- * 0 - pages are placed on the right node or queued successfully, or
+ * queue_folios_pte_range() has three possible return values:
+ * 0 - folios are placed on the right node or queued successfully, or
  *     special page is met, i.e. zero page.
- * 1 - there is unmovable page, and MPOL_MF_MOVE* & MPOL_MF_STRICT were
+ * 1 - there is unmovable folio, and MPOL_MF_MOVE* & MPOL_MF_STRICT were
  *     specified.
- * -EIO - only MPOL_MF_STRICT was specified and an existing page was already
+ * -EIO - only MPOL_MF_STRICT was specified and an existing folio was already
  *        on a node that does not follow the policy.
  */
-static int queue_pages_pte_range(pmd_t *pmd, unsigned long addr,
+static int queue_folios_pte_range(pmd_t *pmd, unsigned long addr,
 			unsigned long end, struct mm_walk *walk)
 {
 	struct vm_area_struct *vma = walk->vma;
-	struct page *page;
+	struct folio *folio;
 	struct queue_pages *qp = walk->private;
 	unsigned long flags = qp->flags;
 	bool has_unmovable = false;
@@ -521,16 +521,16 @@ static int queue_pages_pte_range(pmd_t *pmd, unsigned long addr,
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
 		if (!pte_present(*pte))
 			continue;
-		page = vm_normal_page(vma, addr, *pte);
-		if (!page || is_zone_device_page(page))
+		folio = vm_normal_folio(vma, addr, *pte);
+		if (!folio || folio_is_zone_device(folio))
 			continue;
 		/*
-		 * vm_normal_page() filters out zero pages, but there might
-		 * still be PageReserved pages to skip, perhaps in a VDSO.
+		 * vm_normal_folio() filters out zero pages, but there might
+		 * still be reserved folios to skip, perhaps in a VDSO.
 		 */
-		if (PageReserved(page))
+		if (folio_test_reserved(folio))
 			continue;
-		if (!queue_pages_required(page, qp))
+		if (!queue_pages_required(&folio->page, qp))
 			continue;
 		if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) {
 			/* MPOL_MF_STRICT must be specified if we get here */
@@ -544,7 +544,7 @@ static int queue_pages_pte_range(pmd_t *pmd, unsigned long addr,
 			 * temporary off LRU pages in the range.  Still
 			 * need migrate other LRU pages.
 			 */
-			if (migrate_page_add(page, qp->pagelist, flags))
+			if (migrate_page_add(&folio->page, qp->pagelist, flags))
 				has_unmovable = true;
 		} else
 			break;
@@ -705,7 +705,7 @@ static int queue_pages_test_walk(unsigned long start, unsigned long end,
 
 static const struct mm_walk_ops queue_pages_walk_ops = {
 	.hugetlb_entry		= queue_pages_hugetlb,
-	.pmd_entry		= queue_pages_pte_range,
+	.pmd_entry		= queue_folios_pte_range,
 	.test_walk		= queue_pages_test_walk,
 };
 
-- 
2.40.1



