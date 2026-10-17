Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398C936AB6B;
	Sat, 17 Oct 2026 16:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255260; cv=none; b=W9k8NCzv4woKediBmM63SC8LpeZ4ptyv1t4YA6GiQc9CijNKB+rQOUHQp5ABe+/y5FeRf5gahcR3UOCHt8Vc6DuDJr6rJikXALquclhvMuo094hW9U1Rk5ZADNYJBWyJOwYsIVatyifurLgI1+vT1ELvAUILVIlJiZ8LtQYRdAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255260; c=relaxed/simple;
	bh=cPpESyurlGm/28McZxWKGVg0deI/vNh3fAK8g2Ak1uU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNnZLfWRKKLEg104f9YKkC8qIzQyBSG27XO0O5uK9n69kN0qcqXjb4ItignkdNgmyVJFAVCHmJ5t397bZA9q1c6L24Et5oJ/0FA5TOrC+nvOlvviyJYUCPnJuCaZmpxnI9deQtGIrBhxQF5ptRgqFCNtYIxakHGzNyTQ0Ura6nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fu0/szQr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fu0/szQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194CD1F000C5;
	Sat, 17 Oct 2026 16:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255259;
	bh=x+BN4ws32yVt0VnFn3te+vdqiyloSvR1L123wcYRhXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fu0/szQrGgfTzle+DCMHZ+VVgggc1sdIEvEW5R8MKDEeWfYEskft/mBy6Ved4Vn8H
	 22zk0C2QdmT5wGnPGJ0FFEwQgqgPRfiIqsHlJH8LYB1kxRi9gGgj4RMlCJEvaTSYpD
	 xVNXbjqCGXS1yfTGFpU1JAu0M9VYC5jTHqrfPj9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <songmuchun@bytedance.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	David Hildenbrand <david@kernel.org>,
	Frank van der Linden <fvdl@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Oscar Salvador (SUSE)" <osalvador@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 718/869] mm/hugetlb: initialize gigantic bootmem hugepage struct pages earlier
Date: Sat, 17 Oct 2026 17:59:19 +0200
Message-ID: <20261017160055.369691081@linuxfoundation.org>
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

[ Upstream commit b1b7c045e808c761b1cc8c19b3040fadedda3fef ]

Gigantic bootmem HugeTLB pages are currently initialized from
hugetlb_init(), but page_alloc_init_late() runs earlier and walks
pageblocks to determine zone contiguity.

If a bootmem HugeTLB region is marked noinit, set_zone_contiguous() can
observe still-uninitialized struct pages through
__pageblock_pfn_to_page().  This may not trigger an immediate failure, but
it can make set_zone_contiguous() compute the wrong zone contiguity state.
If extra poisoned-page checks are added in this path, such as
PF_POISONED_CHECK() in page_zone_id(), it can also trigger an early boot
panic.

Initialize gigantic bootmem HugeTLB struct pages from
page_alloc_init_late(), before zone contiguity is evaluated, so later page
allocator setup only sees valid struct page state.  This also makes the
initialization order more natural, as struct pages should be initialized
before later code inspects them.

Link: https://lore.kernel.org/20260612035903.2468601-5-songmuchun@bytedance.com
Fixes: fde1c4ecf916 ("mm: hugetlb: skip initialization of gigantic tail struct pages if freed by HVO")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hugetlb.h | 6 ++++++
 mm/hugetlb.c            | 9 ++++++---
 mm/mm_init.c            | 2 ++
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index dfea039a1dc89..7eaabacdf1105 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -172,6 +172,8 @@ struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio);
 extern int sysctl_hugetlb_shm_group;
 extern struct list_head huge_boot_pages[MAX_NUMNODES];
 
+void hugetlb_bootmem_struct_page_init(void);
+
 /* arch callbacks */
 
 #ifndef CONFIG_HIGHPTE
@@ -1265,6 +1267,10 @@ static inline bool hugetlbfs_pagecache_present(
 {
 	return false;
 }
+
+static inline void hugetlb_bootmem_struct_page_init(void)
+{
+}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 7fccb866dab96..68e0cc0748cac 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3260,6 +3260,10 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 	struct huge_bootmem_page *m;
 	struct hstate *h = NULL, *prev_h = NULL;
 
+	/* The lists are only initialized once a gigantic hstate was allocated. */
+	if (!huge_boot_pages[nid].next)
+		return;
+
 	list_for_each_entry(m, &huge_boot_pages[nid], list) {
 		struct page *page = virt_to_page(m);
 		struct folio *folio = (void *)page;
@@ -3302,7 +3306,7 @@ static void __init gather_bootmem_prealloc_parallel(unsigned long start,
 		gather_bootmem_prealloc_node(nid);
 }
 
-static void __init gather_bootmem_prealloc(void)
+void __init hugetlb_bootmem_struct_page_init(void)
 {
 	struct padata_mt_job job = {
 		.thread_fn	= gather_bootmem_prealloc_parallel,
@@ -3457,7 +3461,7 @@ static unsigned long __init hugetlb_pages_alloc_boot(struct hstate *h)
  * - For gigantic pages, this is called early in the boot process and
  *   pages are allocated from memblock allocated or something similar.
  *   Gigantic pages are actually added to pools later with the routine
- *   gather_bootmem_prealloc.
+ *   hugetlb_bootmem_struct_page_init.
  * - For non-gigantic pages, this is called later in the boot process after
  *   all of mm is up and functional.  Pages are allocated from buddy and
  *   then added to hugetlb pools.
@@ -4496,7 +4500,6 @@ static int __init hugetlb_init(void)
 
 	hugetlb_cma_check();
 	hugetlb_init_hstates();
-	gather_bootmem_prealloc();
 	report_hugepages();
 
 	hugetlb_sysfs_init();
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 65f997ddd740d..77f5f62628b71 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -29,6 +29,7 @@
 #include <linux/cma.h>
 #include <linux/crash_dump.h>
 #include <linux/execmem.h>
+#include <linux/hugetlb.h>
 #include <linux/vmstat.h>
 #include "internal.h"
 #include "slab.h"
@@ -2320,6 +2321,7 @@ void __init page_alloc_init_late(void)
 	/* Reinit limits that are based on free pages after the kernel is up */
 	files_maxfiles_init();
 #endif
+	hugetlb_bootmem_struct_page_init();
 
 	/* Accounting of total+free memory is stable at this point. */
 	mem_init_print_info();
-- 
2.53.0



