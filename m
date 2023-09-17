Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F5B6FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1A3C433C7;
	Sun, 17 Sep 2023 19:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979987;
	bh=2b8h522Iq/j8vlRMIZ1+/knXYBytK5wCLci1C44bsF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sK57dlKPqEhvypnr9ZB4RkqMEdLVhpZyY4N+73+uy8Lz8naHh5XayH6UkIcs13GZB
	 EhYlNnlmmz+oTbMCQq5BNZNFfnKnI7euCo5Qe11Q/zyHHZQwrRgMqlG+ghPAOlQIsx
	 3wMA5vi6OgtWPJfSSRQ2NetUUzqN8Il9YAtYK+24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <songmuchun@bytedance.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.5 036/285] mm: hugetlb_vmemmap: fix a race between vmemmap pmd split
Date: Sun, 17 Sep 2023 21:10:36 +0200
Message-ID: <20230917191052.917825850@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muchun Song <songmuchun@bytedance.com>

commit 3ce2c24cb68f228590a053d6058a5901cd31af61 upstream.

The local variable @page in __split_vmemmap_huge_pmd() to obtain a pmd
page without holding page_table_lock may possiblely get the page table
page instead of a huge pmd page.

The effect may be in set_pte_at() since we may pass an invalid page
struct, if set_pte_at() wants to access the page struct (e.g.
CONFIG_PAGE_TABLE_CHECK is enabled), it may crash the kernel.

So fix it.  And inline __split_vmemmap_huge_pmd() since it only has one
user.

Link: https://lkml.kernel.org/r/20230707033859.16148-1-songmuchun@bytedance.com
Fixes: d8d55f5616cf ("mm: sparsemem: use page table lock to protect kernel pmd operations")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb_vmemmap.c |   34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -36,14 +36,22 @@ struct vmemmap_remap_walk {
 	struct list_head	*vmemmap_pages;
 };
 
-static int __split_vmemmap_huge_pmd(pmd_t *pmd, unsigned long start)
+static int split_vmemmap_huge_pmd(pmd_t *pmd, unsigned long start)
 {
 	pmd_t __pmd;
 	int i;
 	unsigned long addr = start;
-	struct page *page = pmd_page(*pmd);
-	pte_t *pgtable = pte_alloc_one_kernel(&init_mm);
+	struct page *head;
+	pte_t *pgtable;
+
+	spin_lock(&init_mm.page_table_lock);
+	head = pmd_leaf(*pmd) ? pmd_page(*pmd) : NULL;
+	spin_unlock(&init_mm.page_table_lock);
 
+	if (!head)
+		return 0;
+
+	pgtable = pte_alloc_one_kernel(&init_mm);
 	if (!pgtable)
 		return -ENOMEM;
 
@@ -53,7 +61,7 @@ static int __split_vmemmap_huge_pmd(pmd_
 		pte_t entry, *pte;
 		pgprot_t pgprot = PAGE_KERNEL;
 
-		entry = mk_pte(page + i, pgprot);
+		entry = mk_pte(head + i, pgprot);
 		pte = pte_offset_kernel(&__pmd, addr);
 		set_pte_at(&init_mm, addr, pte, entry);
 	}
@@ -65,8 +73,8 @@ static int __split_vmemmap_huge_pmd(pmd_
 		 * be treated as indepdenent small pages (as they can be freed
 		 * individually).
 		 */
-		if (!PageReserved(page))
-			split_page(page, get_order(PMD_SIZE));
+		if (!PageReserved(head))
+			split_page(head, get_order(PMD_SIZE));
 
 		/* Make pte visible before pmd. See comment in pmd_install(). */
 		smp_wmb();
@@ -80,20 +88,6 @@ static int __split_vmemmap_huge_pmd(pmd_
 	return 0;
 }
 
-static int split_vmemmap_huge_pmd(pmd_t *pmd, unsigned long start)
-{
-	int leaf;
-
-	spin_lock(&init_mm.page_table_lock);
-	leaf = pmd_leaf(*pmd);
-	spin_unlock(&init_mm.page_table_lock);
-
-	if (!leaf)
-		return 0;
-
-	return __split_vmemmap_huge_pmd(pmd, start);
-}
-
 static void vmemmap_pte_range(pmd_t *pmd, unsigned long addr,
 			      unsigned long end,
 			      struct vmemmap_remap_walk *walk)


