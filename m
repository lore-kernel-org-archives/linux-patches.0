Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36093B27E9;
	Thu, 30 Jul 2026 15:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426854; cv=none; b=VpCigLuCSLgVR+5psHRdRb+/2/qP/khqD7iT529V47cMsXw9Bz/MvyNcdcrbegZYI7Hl8DFOPbLIR6gcp29VDLx+l8NNa/aJPmbyjcuEUBvJarfMMX7SeV3TCW7LYrtTF0yYofHJrldlJRha13w5qENykSsGfVp5w1HI3w3IKmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426854; c=relaxed/simple;
	bh=uH0hOLU9FLUWpYMNUNWLs3hclZSkW9fxihBjFI+XF70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhyDRSlJMvHj/UFZI6kKXKJZJoEpNkEUrs79Ug0AdsZCAN6fr1QPa2UIK3TLMoADmE3TlBhnD1e7rg3Jxs884yMZ+7qhaYM5R8y1pqc7a5a8ucoIP30kXIuVZetHcI1013iOiykcFjVIm1bicmMYW92iVlFT0QhTqnq9shgG21U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nGAtIfnD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nGAtIfnD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301411F000E9;
	Thu, 30 Jul 2026 15:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426852;
	bh=vUTZuWojgZpXjsMg7s16LG/tzLXoAhmPlzUemqB3bOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nGAtIfnD35zo1/m3nYurLmwSqlJSkCjfIsnVp+2p42ZUx1kPye+n3U5rS/F0eArQp
	 xZbC0CNsZmTrGSjPbLwQY2ZYb0EKF6q1RhO6TyxrMF4t/6yAd1ZprDzUozttLlFbu4
	 DcEl/igDCXpp7RkKsYoChO2eRegV2M6pbeN/FTk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <songmuchun@bytedance.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 521/602] mm/mm_init: fix pageblock migratetype for ZONE_DEVICE compound pages
Date: Thu, 30 Jul 2026 16:15:13 +0200
Message-ID: <20260730141446.955221332@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

[ Upstream commit 94405c6136839f7c462249c8b4b957bcb9527a9d ]

The memmap_init_zone_device() function only initializes the migratetype of
the first pageblock of a compound page.  If the compound page size exceeds
pageblock_nr_pages (e.g., 1GB hugepages with 2MB pageblocks), subsequent
pageblocks in the compound page remain uninitialized.

Move the migratetype initialization out of __init_zone_device_page() and
into a separate pageblock_migratetype_init_range() function.  This
iterates over the entire PFN range of the memory, ensuring that all
pageblocks are correctly initialized.

Also remove the stale confusing comment about MEMINIT_HOTPLUG above the
migratetype setting since it is an obsolete relic from commit 966cf44f637e
("mm: defer ZONE_DEVICE page initialization to the point where we init
pgmap") and no longer makes sense here.

Link: https://lore.kernel.org/20260428081855.1249045-6-songmuchun@bytedance.com
Fixes: c4386bd8ee3a ("mm/memremap: add ZONE_DEVICE support for compound pages")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Liam R. Howlett <liam@infradead.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mm_init.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -650,6 +650,20 @@ static inline void fixup_hashdist(void)
 static inline void fixup_hashdist(void) {}
 #endif /* CONFIG_NUMA */
 
+#ifdef CONFIG_ZONE_DEVICE
+static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
+		unsigned long nr_pages, int migratetype)
+{
+	const unsigned long end = pfn + nr_pages;
+
+	for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
+		set_pageblock_migratetype(pfn_to_page(pfn), migratetype);
+		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
+			cond_resched();
+	}
+}
+#endif
+
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 static inline void pgdat_set_deferred_range(pg_data_t *pgdat)
 {
@@ -1000,21 +1014,6 @@ static void __ref __init_zone_device_pag
 	page->zone_device_data = NULL;
 
 	/*
-	 * Mark the block movable so that blocks are reserved for
-	 * movable at startup. This will force kernel allocations
-	 * to reserve their blocks rather than leaking throughout
-	 * the address space during boot when many long-lived
-	 * kernel allocations are made.
-	 *
-	 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
-	 * because this is done early in section_activate()
-	 */
-	if (pageblock_aligned(pfn)) {
-		set_pageblock_migratetype(page, MIGRATE_MOVABLE);
-		cond_resched();
-	}
-
-	/*
 	 * ZONE_DEVICE pages are released directly to the driver page allocator
 	 * which will set the page count to 1 when allocating the page.
 	 */
@@ -1105,6 +1104,9 @@ void __ref memmap_init_zone_device(struc
 
 		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
 
+		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
+			cond_resched();
+
 		if (pfns_per_compound == 1)
 			continue;
 
@@ -1112,6 +1114,8 @@ void __ref memmap_init_zone_device(struc
 				     compound_nr_pages(pfn, altmap, pgmap));
 	}
 
+	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
+
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
 		nr_pages, jiffies_to_msecs(jiffies - start));
 }


