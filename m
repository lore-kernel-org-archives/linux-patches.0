Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853683876CC;
	Fri,  4 Sep 2026 05:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498401; cv=none; b=gX6KN1+0juBX0be84mcsK0UQ+XoNSxlQo3hhs7GUtYbS136GazsG1VjMqsG3iYoSLH22dBpH8XKlJFz4sK5w3+T33MfAMvihx+tz9Tl665+XFsxLIm7Vnk5jvej0fWFgyVB4+7YrJZwi2aA2CooHHLF933Bb9IqA9RhAqdQXkEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498401; c=relaxed/simple;
	bh=OCDkGUS1gDG2wFkG0nhfAPoAScqhLU05N6C3eMGad1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtMc9D4H8+NWRAD4ZofJtf6Mvrr2TBMSbDBgRiK6XsLbhRyf4j8KGSI3QxmrngcsS+KcV15ZM5W88bqLUDvrhYYGuClVl82zpyoEw0dHFZVXVS7XlU76paxDGR2xwFJwM1mXMkPVuqzNSXNA0J/TStSmFT3ZIpFCvD7q1GPyjt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tmOHGDNR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tmOHGDNR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7531F00A3D;
	Fri,  4 Sep 2026 05:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498400;
	bh=9K1vF+fND/P8CFFOGoalseEq17v5sRzvIZnFO7PCfWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tmOHGDNRWCijSyyqbOFbMry1JarrI6BYu/aYp65UvusHmXfJJncsccmwMqV5kL8t0
	 /4AvBj5HkAPltQ+xveAlNJyLzR5BCvkFF+3Vw03DlRtd3XZqt+heO0Xgm2Sz3pUoh+
	 HPh/vnwt6RSDeYkjSGKJZSojw8fajDukgXukWDE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <songmuchun@bytedance.com>,
	Oscar Salvador <osalvador@suse.de>,
	Michal Clapinski <mclapinski@google.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Frank van der Linden <fvdl@google.com>,
	"Oscar Salvador (SUSE)" <osalvador@kernel.org>,
	Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 050/713] mm/hugetlb: fix boot panic with CONFIG_DEBUG_VM and HVO bootmem pages
Date: Fri,  4 Sep 2026 06:50:18 +0200
Message-ID: <20260904045804.952650336@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muchun Song <songmuchun@bytedance.com>

commit c0caeceb0c3899dc42844d3979093b27d1434108 upstream.

Patch series "mm: Refactor bootmem gigantic hugepage allocation", v4.

This series is split out from the earlier larger series "mm: Generalize
HVO for HugeTLB and device DAX" [1].  It collects the first 19 patches of
that series as a standalone set of fixes and preparatory cleanups around
bootmem HugeTLB handling, sparse initialization ordering, and related
vmemmap setup.

The first patches fix a few bugs found while reviewing the existing code,
including incorrect bootmem HVO handling, wrong vmemmap registration
arguments, a powerpc compound-vmemmap tracking bug, and too-late
initialization of gigantic bootmem HugeTLB struct pages.

The rest of the series reorders early memory initialization so the
relevant zone state is available before sparse and HugeTLB boot-time setup
runs, then simplifies the remaining bootmem gigantic hugepage allocation
path and removes code made obsolete by that rework.

At a high level:
  - patches [1-4] fix boot-time and arch-specific bugs
  - patches [5-12] reorder and simplify sparse/mm/hugetlb early init
  - patches [13-19] refactor bootmem gigantic hugepage allocation and
    remove obsolete helpers and state


This patch (of 19):

Commit 622026e87c40 ("mm/hugetlb: remove fake head pages") switched
HVO to reuse per-zone shared tail pages from zone->vmemmap_tails[].

Those shared tail pages were initialized in hugetlb_vmemmap_init(), but
bootmem HugeTLB folios are prepared earlier from
gather_bootmem_prealloc().  With hugetlb_free_vmemmap=on,
prep_and_add_bootmem_folios() can access pageblock flags on bootmem
HugeTLB pages whose mirrored tail struct pages already point to the shared
tail page.  On CONFIG_DEBUG_VM kernels, get_pfnblock_bitmap_bitidx() then
dereferences the still-uninitialized shared tail page and can panic during
boot.

Initialize zone->vmemmap_tails[] from gather_bootmem_prealloc(), before
bootmem HugeTLB folios are processed, and drop the later initialization
from hugetlb_vmemmap_init().

This bug only affects CONFIG_DEBUG_VM kernels, where the relevant
assertion is evaluated.

Link: https://lore.kernel.org/20260612035903.2468601-1-songmuchun@bytedance.com
Link: https://lore.kernel.org/20260612035903.2468601-2-songmuchun@bytedance.com
Fixes: 622026e87c40 ("mm/hugetlb: remove fake head pages")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Tested-by: Michal Clapinski <mclapinski@google.com>
Reviewed-by: Michal Clapinski <mclapinski@google.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c         | 25 +++++++++++++++++++++++++
 mm/hugetlb_vmemmap.c | 17 -----------------
 mm/sparse-vmemmap.c  |  2 +-
 3 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b75774455d65..4c234611e7a0 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3365,6 +3365,31 @@ static void __init gather_bootmem_prealloc(void)
 		.max_threads	= num_node_state(N_MEMORY),
 		.numa_aware	= true,
 	};
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+	struct zone *zone;
+
+	for_each_zone(zone) {
+		for (int i = 0; i < NR_VMEMMAP_TAILS; i++) {
+			struct page *tail, *p;
+			unsigned int order;
+
+			tail = zone->vmemmap_tails[i];
+			if (!tail)
+				continue;
+
+			order = i + VMEMMAP_TAIL_MIN_ORDER;
+			p = page_to_virt(tail);
+			/*
+			 * prep_and_add_bootmem_folios() can access pageblock
+			 * flags on bootmem HugeTLB pages, so initialize the
+			 * shared tail struct pages here before bootmem folios
+			 * start using them.
+			 */
+			for (int j = 0; j < PAGE_SIZE / sizeof(struct page); j++)
+				init_compound_tail(p + j, NULL, order, zone);
+		}
+	}
+#endif
 
 	padata_do_multithreaded(&job);
 }
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 133b46dfb09f..c713c0d2593a 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -870,27 +870,10 @@ static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
 static int __init hugetlb_vmemmap_init(void)
 {
 	const struct hstate *h;
-	struct zone *zone;
 
 	/* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct pages */
 	BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
 
-	for_each_zone(zone) {
-		for (int i = 0; i < NR_VMEMMAP_TAILS; i++) {
-			struct page *tail, *p;
-			unsigned int order;
-
-			tail = zone->vmemmap_tails[i];
-			if (!tail)
-				continue;
-
-			order = i + VMEMMAP_TAIL_MIN_ORDER;
-			p = page_to_virt(tail);
-			for (int j = 0; j < PAGE_SIZE / sizeof(struct page); j++)
-				init_compound_tail(p + j, NULL, order, zone);
-		}
-	}
-
 	for_each_hstate(h) {
 		if (hugetlb_vmemmap_optimizable(h)) {
 			register_sysctl_init("vm", hugetlb_vmemmap_sysctls);
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index ebd3ac997f64..dff8da23eabb 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -342,7 +342,7 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
 	 *
 	 * Any initialization done here will be overwritten by memmap_init().
 	 *
-	 * hugetlb_vmemmap_init() will take care of initialization after
+	 * gather_bootmem_prealloc() will take care of initialization after
 	 * memmap_init().
 	 */
 
-- 
2.55.0



