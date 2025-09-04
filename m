Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9F74C8F
	for <patches@lists.linux.dev>; Thu,  4 Sep 2025 00:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756944125; cv=none; b=FYljn2sr6DB0Ceqa0zS/loK32eReoE3nZNJDDPdt6uzpUrbGIbtIhJFjBkQQVh8vetUrglj79clCEeFSpkMocIYE1GGp6MiWf/0tC857J1nmTIDffTK7r/9BRIlN8yMQGGgaxtY863Z+vWfKVlHA/mLcUsV7c6CgkH4EdvUwPZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756944125; c=relaxed/simple;
	bh=SzxgatobiZzPplZrL2+A3LpEZR/wAdZIy9qFRn7ExvE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b1r5D27nQc+R02MptaYsTQMv3lGzhuB81MbPZIK/KDZ3tLzq6P1whubOxI+HymSCRIDXEp7MK+nlWmPLVEh8soEs3FHyyt0RLDEvHqH516wQp9yXGCEO/it6aBIu7jjh/q8kueVzayu0Lx/PRjyQsHLskickoixB+cV4Pmhvzh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ovfo8f2N; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ovfo8f2N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=+8tPAsjlGZ5Z0ljd+fI7xGD7emkuc45doegXrKHrqkg=; b=ovfo8f2NA6dCAegJqP1gsqPUKH
	8A2s736nnpVFzjvwZlEgBJj6qOGMZq6Ysw1QLGX+M7/wo59oWB+pJE8PxRbux3bPULwTFVOK6pI1h
	VqSMme219RwAYXUOHdiinVwyazWNdUjMBcKKWJjuMYfUlIuTJmvedilLS4ZJtcs7qPzT8Z3C+H/il
	HHLjo2FbQx3sYEHnkULC2OpCQ2EtTjkEf+N2oKRfZKsi+5JUnAqjzxgiyqqXcOp7kiqKlSo/3U0Ah
	LUBlT+QK3ZDj3Ao1p47GMBGxqQGi1spt6dmp1iZKdt4/areoaBAdn5EW3kD+Pyees0naHJmxQI8Rz
	37KbI1LA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1utxQH-00000007wkx-0qAv;
	Thu, 04 Sep 2025 00:01:53 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: dave@stgolabs.net,
	s.prabhu@samsung.com,
	patches@lists.linux.dev
Cc: gost.dev@samsung.com,
	kundan.kumar@samsung.com,
	da.gomez@samsung.com,
	mcgrof@kernel.org
Subject: [PATCH] mm: add compaction success/failure tracepoints and fragmentation tracking
Date: Wed,  3 Sep 2025 17:01:47 -0700
Message-ID: <20250904000147.1894151-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

From: Swarna Prabhu <s.prabhu@samsung.com>

Add extra compaction tracepoints to allow extended memory fragmentation
introspection:

  - mm_compaction_success and
  - mm_compaction_failure

This allows for better introspection of what exactly is happening at
either failure or success of memory compaction, as we try to evaluate
memory fragmentation in extreme situations.

Changes include:

- Add two extra new tracepoints:
  * mm_compaction_success
  * mm_compaction_failure
- Add COMPACTSUCCESS_EXTFRAG vmstat counter to track successful
  compactions that still result in fragmented memory (fragmentation
  index > 0 and <= 1000)
- Export fill_contig_page_info() and __fragmentation_index() from
  vmstat.c to allow fragmentation calculation in page allocation path
  capture detailed compaction outcomes with zone, order, and
  fragmentation data
- Calculate fragmentation index after successful compaction to determine
  if memory remains fragmented despite successful allocation

The fragmentation index calculation helps identify cases where
compaction succeeds but still leaves the zone fragmented. A positive
index (0-1000) indicates some level of fragmentation exists, with
higher values meaning more fragmentation. This data is crucial for
understanding:

- How bad are situations, really?
- At what order did a compaction fail?
- Compaction efficiency in reducing fragmentation
- Whether successful allocations are masking underlying fragmentation
  issues
- The relationship between allocation success and zone health

The new tracepoints provide runtime visibility into:

- Which zones and orders are experiencing compaction events
- The resulting fragmentation state after successful compaction
- Failure patterns for specific allocation orders

This instrumentation will help us build visualizations of compaction
over time.

Signed-off-by: Swarna Prabhu <s.prabhu@samsung.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---

Just posting this for posterity so its public, and also here's a branch
which carries both this patch and my folio migration debugfs stats
patch, they are based on v6.17-rc4:

https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/log/?h=20250903-compaction-tracepoints

This should help us test memory managmement intensive workflows. I've
also put this tree up to help visualize things:

https://github.com/mcgrof/plot-fragmentation

I'll move on to integrate to kdevops now.

  Luis

 include/linux/vm_event_item.h     |  2 +-
 include/linux/vmstat.h            | 11 +++++
 include/trace/events/page_alloc.h | 71 +++++++++++++++++++++++++++++++
 mm/page_alloc.c                   | 20 ++++++++-
 mm/vmstat.c                       | 11 ++---
 5 files changed, 105 insertions(+), 10 deletions(-)
 create mode 100644 include/trace/events/page_alloc.h

diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 9e15a088ba38..a26e790cd485 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -76,7 +76,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 #ifdef CONFIG_COMPACTION
 		COMPACTMIGRATE_SCANNED, COMPACTFREE_SCANNED,
 		COMPACTISOLATED,
-		COMPACTSTALL, COMPACTFAIL, COMPACTSUCCESS,
+		COMPACTSTALL, COMPACTFAIL, COMPACTSUCCESS, COMPACTSUCCESS_EXTFRAG,
 		KCOMPACTD_WAKE,
 		KCOMPACTD_MIGRATE_SCANNED, KCOMPACTD_FREE_SCANNED,
 #endif
diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index c287998908bf..e6560ed87953 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -269,6 +269,17 @@ static inline void fold_vm_numa_events(void)
 }
 #endif /* CONFIG_NUMA */
 
+#ifdef CONFIG_COMPACTION
+struct contig_page_info {
+	unsigned long free_pages;
+	unsigned long free_blocks_total;
+	unsigned long free_blocks_suitable;
+};
+void fill_contig_page_info(struct zone *zone, unsigned int suitable_order,struct contig_page_info *info);
+int __fragmentation_index(unsigned int order, struct contig_page_info *info);
+
+#endif /*CONFIG_COMPACTION*/
+
 #ifdef CONFIG_SMP
 void __mod_zone_page_state(struct zone *, enum zone_stat_item item, long);
 void __inc_zone_page_state(struct page *, enum zone_stat_item);
diff --git a/include/trace/events/page_alloc.h b/include/trace/events/page_alloc.h
new file mode 100644
index 000000000000..f9125c1a9442
--- /dev/null
+++ b/include/trace/events/page_alloc.h
@@ -0,0 +1,71 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM page_alloc
+
+#if !defined(_TRACE_PAGE_ALLOC_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_PAGE_ALLOC_H
+/*
+#include <linux/types.h>
+#include <linux/list.h>
+*/
+#include <linux/tracepoint.h>
+
+
+
+#ifdef CONFIG_COMPACTION
+TRACE_EVENT(mm_compaction_success,
+    TP_PROTO(
+		struct zone *zone,
+		unsigned int order,
+		int ret),
+
+	TP_ARGS(zone, order, ret),
+
+    TP_STRUCT__entry(
+		__field(int, nid)
+		__field(enum zone_type, idx)
+		__field(unsigned int, order)
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		__entry->nid = zone_to_nid(zone);
+		__entry->idx = zone_idx(zone);
+		__entry->order = order;
+		__entry->ret = ret;
+	),
+
+	TP_printk("node=%d zone=%-8s order=%u, res_index=%d",
+		__entry->nid,
+		__print_symbolic(__entry->idx, ZONE_TYPE),
+		__entry->order,
+		__entry->ret
+		)
+);
+
+TRACE_EVENT(mm_compaction_failure,
+    TP_PROTO(
+		unsigned int order),
+
+	TP_ARGS( order),
+
+    TP_STRUCT__entry(
+		__field(unsigned int, order)
+	),
+
+	TP_fast_assign(
+		__entry->order = order;
+	),
+
+	TP_printk("order=%u",
+		__entry->order
+		)
+);
+
+
+
+#endif /* CONFIG_COMPACTION */
+
+#endif /* _TRACE_PAGEALLOC_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d1d037f97c5f..17ea91febacf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -56,10 +56,17 @@
 #include <linux/cacheinfo.h>
 #include <linux/pgalloc_tag.h>
 #include <asm/div64.h>
+#include <linux/vmstat.h>
+#include <linux/debugfs.h>
+#include <linux/cpumask.h>
 #include "internal.h"
 #include "shuffle.h"
 #include "page_reporting.h"
 
+#if defined CONFIG_COMPACTION
+#define CREATE_TRACE_POINTS
+#include <trace/events/page_alloc.h>
+#endif
 /* Free Page Internal flags: for internal, non-pcp variants of free_pages(). */
 typedef int __bitwise fpi_t;
 
@@ -4088,10 +4095,20 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 
 	if (page) {
 		struct zone *zone = page_zone(page);
-
 		zone->compact_blockskip_flush = false;
 		compaction_defer_reset(zone, order, true);
+
+		struct contig_page_info info;
+		int res_index;
+
+		fill_contig_page_info(zone, order, &info);
+		res_index = __fragmentation_index(order, &info);
+
 		count_vm_event(COMPACTSUCCESS);
+		trace_mm_compaction_success(zone, order, res_index); /* success trace point captured */
+		if (res_index > 0 && res_index <= 1000) {
+			count_vm_event(COMPACTSUCCESS_EXTFRAG);
+		}
 		return page;
 	}
 
@@ -4100,6 +4117,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	 * is that pages exist, but not enough to satisfy watermarks.
 	 */
 	count_vm_event(COMPACTFAIL);
+        trace_mm_compaction_failure(order); /*failure trace point captured */
 
 	cond_resched();
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 71cd1ceba191..ce82ddb5afcc 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1056,12 +1056,6 @@ void memmap_pages_add(long delta)
 
 #ifdef CONFIG_COMPACTION
 
-struct contig_page_info {
-	unsigned long free_pages;
-	unsigned long free_blocks_total;
-	unsigned long free_blocks_suitable;
-};
-
 /*
  * Calculate the number of free pages in a zone, how many contiguous
  * pages are free and how many are large enough to satisfy an allocation of
@@ -1070,7 +1064,7 @@ struct contig_page_info {
  * migrated. Calculating that is possible, but expensive and can be
  * figured out from userspace
  */
-static void fill_contig_page_info(struct zone *zone,
+void fill_contig_page_info(struct zone *zone,
 				unsigned int suitable_order,
 				struct contig_page_info *info)
 {
@@ -1109,7 +1103,7 @@ static void fill_contig_page_info(struct zone *zone,
  * The value can be used to determine if page reclaim or compaction
  * should be used
  */
-static int __fragmentation_index(unsigned int order, struct contig_page_info *info)
+int __fragmentation_index(unsigned int order, struct contig_page_info *info)
 {
 	unsigned long requested = 1UL << order;
 
@@ -1380,6 +1374,7 @@ const char * const vmstat_text[] = {
 	[I(COMPACTSTALL)]			= "compact_stall",
 	[I(COMPACTFAIL)]			= "compact_fail",
 	[I(COMPACTSUCCESS)]			= "compact_success",
+	[I(COMPACTSUCCESS_EXTFRAG)]		= "compact_success_extfrag",
 	[I(KCOMPACTD_WAKE)]			= "compact_daemon_wake",
 	[I(KCOMPACTD_MIGRATE_SCANNED)]		= "compact_daemon_migrate_scanned",
 	[I(KCOMPACTD_FREE_SCANNED)]		= "compact_daemon_free_scanned",
-- 
2.45.2

