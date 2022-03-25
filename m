Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A221FB7
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 01:09:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F87C340F5;
	Fri, 25 Mar 2022 01:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648170599;
	bh=ATcCivuhwQnlP2bMCElzAjOsnX7Ojw/eGItvGDod9DA=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=R5QQn3kjaRBe8f/YHYbAgP5ghgVVCmH1q05VOvMDUvEh3iBoD3SlFfszLC/nbSP2P
	 749Aq1c+/ExV19L3RH/vjnvSmZx+vI25t3rET749kgTESAfuUWPLkW44lh9DDkaqoa
	 HW0LCkx0kagc+6xePU8vMzNVOrPu0zWqqqfNwwUk=
Date: Thu, 24 Mar 2022 18:09:58 -0700
To: ziy@nvidia.com,willy@infradead.org,rostedt@goodmis.org,paulus@samba.org,naoya.horiguchi@nec.com,mpe@ellerman.id.au,mingo@redhat.com,jhubbard@nvidia.com,anshuman.khandual@arm.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 028/114] mm/migration: add trace events for THP migrations
Message-Id: <20220325010959.20F87C340F5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/migration: add trace events for THP migrations

Patch series "mm/migration: Add trace events", v3.

This adds trace events for all migration scenarios including base page,
THP and HugeTLB.


This patch (of 3):

This adds two trace events for PMD based THP migration without split. 
These events closely follow the implementation details like setting and
removing of PMD migration entries, which are essential operations for THP
migration.  This moves CREATE_TRACE_POINTS into generic THP from powerpc
for these new trace events to be available on other platforms as well.

Link: https://lkml.kernel.org/r/1643368182-9588-1-git-send-email-anshuman.khandual@arm.com
Link: https://lkml.kernel.org/r/1643368182-9588-2-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/book3s64/trace.c |    1 -
 include/trace/events/thp.h       |   27 +++++++++++++++++++++++++++
 mm/huge_memory.c                 |    5 +++++
 3 files changed, 32 insertions(+), 1 deletion(-)

--- a/arch/powerpc/mm/book3s64/trace.c~mm-migration-add-trace-events-for-thp-migrations
+++ a/arch/powerpc/mm/book3s64/trace.c
@@ -3,6 +3,5 @@
  * This file is for defining trace points and trace related helpers.
  */
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-#define CREATE_TRACE_POINTS
 #include <trace/events/thp.h>
 #endif
--- a/include/trace/events/thp.h~mm-migration-add-trace-events-for-thp-migrations
+++ a/include/trace/events/thp.h
@@ -48,6 +48,33 @@ TRACE_EVENT(hugepage_update,
 	    TP_printk("hugepage update at addr 0x%lx and pte = 0x%lx clr = 0x%lx, set = 0x%lx", __entry->addr, __entry->pte, __entry->clr, __entry->set)
 );
 
+DECLARE_EVENT_CLASS(migration_pmd,
+
+		TP_PROTO(unsigned long addr, unsigned long pmd),
+
+		TP_ARGS(addr, pmd),
+
+		TP_STRUCT__entry(
+			__field(unsigned long, addr)
+			__field(unsigned long, pmd)
+		),
+
+		TP_fast_assign(
+			__entry->addr = addr;
+			__entry->pmd = pmd;
+		),
+		TP_printk("addr=%lx, pmd=%lx", __entry->addr, __entry->pmd)
+);
+
+DEFINE_EVENT(migration_pmd, set_migration_pmd,
+	TP_PROTO(unsigned long addr, unsigned long pmd),
+	TP_ARGS(addr, pmd)
+);
+
+DEFINE_EVENT(migration_pmd, remove_migration_pmd,
+	TP_PROTO(unsigned long addr, unsigned long pmd),
+	TP_ARGS(addr, pmd)
+);
 #endif /* _TRACE_THP_H */
 
 /* This part must be outside protection */
--- a/mm/huge_memory.c~mm-migration-add-trace-events-for-thp-migrations
+++ a/mm/huge_memory.c
@@ -40,6 +40,9 @@
 #include <asm/pgalloc.h>
 #include "internal.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/thp.h>
+
 /*
  * By default, transparent hugepage support is disabled in order to avoid
  * risking an increased memory footprint for applications that are not
@@ -3131,6 +3134,7 @@ void set_pmd_migration_entry(struct page
 	set_pmd_at(mm, address, pvmw->pmd, pmdswp);
 	page_remove_rmap(page, vma, true);
 	put_page(page);
+	trace_set_migration_pmd(address, pmd_val(pmdswp));
 }
 
 void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
@@ -3163,5 +3167,6 @@ void remove_migration_pmd(struct page_vm
 
 	/* No need to invalidate - it was non-present before */
 	update_mmu_cache_pmd(vma, address, pvmw->pmd);
+	trace_remove_migration_pmd(address, pmd_val(pmde));
 }
 #endif
_
