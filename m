Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B798B3D3321;
	Thu, 17 Sep 2026 18:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671494; cv=none; b=gWJbT7k0DKo7kebLaatE5cJ3rEpdzdnEIF6SJKHOqIICCnsZ0usigNjQyDkX2kecW67DT2+449KYN+pIW96YfNiw5uMPoqq245rTIk+0SMnqjIy8adV+4EqHHjE3uuAKnUOFUmPhIkFem1ThuZ8vvXMxUQaSxWdbDqXir3gcDF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671494; c=relaxed/simple;
	bh=EX3v97Uo2OXzYSQJ7aOIA8airoKH7N1kYOpgGSTchwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4d/KeYwuky9TFaw5ugy7hCHxKqLTBHQ1ax/wIKTC/mayrB2eEc3WinG/bmmPdZGoDpEmEtTcKpYyZgRaACnp/3U+8o+vE31bbaSGStUQ1uuv14K0zmzB6Z7jAr8XSb2wJy5E8ug41TV32h8rECD+IWTnyvmlemqghYgZQzM/6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lHj9L9lw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lHj9L9lw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73431F000FF;
	Thu, 17 Sep 2026 18:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671492;
	bh=xvIPmxYOfv/AbriqOFE9BDt1df90wcgXALGZGctX05E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lHj9L9lw1/MZ2Qnr7zXVUPb4Xjh2Ddy0APBD25ciANjKnlbnFqffrU8oH0iQKUSxn
	 ASslpnNoVO9Iybu9aCw3elp5gX8e/eYiuhG3lnedzKlirrF9qkpmhCLXuaA+FSa9Oc
	 1ZL3CH5cytfeFaUFN5cRJQUauIAMVg9rjGSHfU3Q=
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
Subject: [PATCH 6.12 0993/1102] mm/hugetlb: initialize gigantic bootmem hugepage struct pages earlier
Date: Thu, 17 Sep 2026 16:15:36 +0100
Message-ID: <20260917151605.648636485@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
[ added a direct hugetlb.h include and omitted a comment for absent HVO shared-tail code. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hugetlb.h |    5 +++++
 mm/hugetlb.c            |    5 ++---
 mm/mm_init.c            |    2 ++
 3 files changed, 9 insertions(+), 3 deletions(-)

--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -172,6 +172,7 @@ struct address_space *hugetlb_folio_mapp
 extern int sysctl_hugetlb_shm_group;
 extern struct list_head huge_boot_pages[MAX_NUMNODES];
 
+void hugetlb_bootmem_struct_page_init(void);
 /* arch callbacks */
 
 #ifndef CONFIG_HIGHPTE
@@ -1265,6 +1266,10 @@ static inline bool hugetlbfs_pagecache_p
 {
 	return false;
 }
+
+static inline void hugetlb_bootmem_struct_page_init(void)
+{
+}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3276,7 +3276,7 @@ static void __init gather_bootmem_preall
 		gather_bootmem_prealloc_node(nid);
 }
 
-static void __init gather_bootmem_prealloc(void)
+void __init hugetlb_bootmem_struct_page_init(void)
 {
 	struct padata_mt_job job = {
 		.thread_fn	= gather_bootmem_prealloc_parallel,
@@ -3431,7 +3431,7 @@ static unsigned long __init hugetlb_page
  * - For gigantic pages, this is called early in the boot process and
  *   pages are allocated from memblock allocated or something similar.
  *   Gigantic pages are actually added to pools later with the routine
- *   gather_bootmem_prealloc.
+ *   hugetlb_bootmem_struct_page_init.
  * - For non-gigantic pages, this is called later in the boot process after
  *   all of mm is up and functional.  Pages are allocated from buddy and
  *   then added to hugetlb pools.
@@ -4470,7 +4470,6 @@ static int __init hugetlb_init(void)
 
 	hugetlb_cma_check();
 	hugetlb_init_hstates();
-	gather_bootmem_prealloc();
 	report_hugepages();
 
 	hugetlb_sysfs_init();
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -30,6 +30,7 @@
 #include <linux/crash_dump.h>
 #include <linux/execmem.h>
 #include <linux/vmstat.h>
+#include <linux/hugetlb.h>
 #include "internal.h"
 #include "slab.h"
 #include "shuffle.h"
@@ -2320,6 +2321,7 @@ void __init page_alloc_init_late(void)
 	/* Reinit limits that are based on free pages after the kernel is up */
 	files_maxfiles_init();
 #endif
+	hugetlb_bootmem_struct_page_init();
 
 	/* Accounting of total+free memory is stable at this point. */
 	mem_init_print_info();


