Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88868189902;
	Fri, 15 Nov 2024 06:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653511; cv=none; b=N3DD+fU9llDTjWjN6uOs3capHpDbW20nEgfhCGzQxzYxuX/T5UqthXHbtNjPrLZu1GjVQTlncGKt5caR0Co+1SWub34gjax5mCsL4z9fBV751CnmBetEiyvuQRTBltj2hW7bGrkloTRl+4SMNW7q5x8eIa0uj1J4tJoxqHnpv7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653511; c=relaxed/simple;
	bh=5aX9A2gsendM5xbgFkf4BiXbcT7IDTSwA7SCXHN/mAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+pvZsb/cb1JbkJyVZV3+jntWSt7PZqGutz2Guzu3b0QdvP8arDOIyS6sUWXwJrQYjGlubH+aCE6MtlPnSN4PTrMXjaibiJv8G2KUAqItW1es2TXPk5G/acDEVZp1UgfFPuH9gjwcG1hAsHq/jFdtI8bO08oCHknwO3HS0QPlIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DV9PGC0p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DV9PGC0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA033C4CECF;
	Fri, 15 Nov 2024 06:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653511;
	bh=5aX9A2gsendM5xbgFkf4BiXbcT7IDTSwA7SCXHN/mAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DV9PGC0pGx92sF6TjTJD8+pQkF+87lTzdquoS1tNkzHDGkcBYzjxDiZxZonzm0CVJ
	 HGwRgqPa3Ivg4tnIgqQOMYOJmOIbqq0qzaZkBEb33JIcu6Ca90hA81jH2gD/XS6PFd
	 +xIJbZoli6u+CqGpL0mcQ+i3o/HIKTirKaZSkOV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <shy828301@gmail.com>,
	Yu Zhao <yuzhao@google.com>,
	Zach OKeefe <zokeefe@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 44/48] mm: support order-1 folios in the page cache
Date: Fri, 15 Nov 2024 07:38:33 +0100
Message-ID: <20241115063724.551353741@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
References: <20241115063722.962047137@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

commit 8897277acfef7f70fdecc054073bea2542fc7a1b upstream.

Folios of order 1 have no space to store the deferred list.  This is not a
problem for the page cache as file-backed folios are never placed on the
deferred list.  All we need to do is prevent the core MM from touching the
deferred list for order 1 folios and remove the code which prevented us
from allocating order 1 folios.

Link: https://lore.kernel.org/linux-mm/90344ea7-4eec-47ee-5996-0c22f42d6a6a@google.com/
Link: https://lkml.kernel.org/r/20240226205534.1603748-3-zi.yan@sent.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Michal Koutny <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c     |    2 --
 mm/huge_memory.c |   19 +++++++++++++++----
 mm/internal.h    |    3 +--
 mm/readahead.c   |    3 ---
 4 files changed, 16 insertions(+), 11 deletions(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1957,8 +1957,6 @@ no_page:
 			gfp_t alloc_gfp = gfp;
 
 			err = -ENOMEM;
-			if (order == 1)
-				order = 0;
 			if (order > 0)
 				alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
 			folio = filemap_alloc_folio(alloc_gfp, order);
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -569,8 +569,10 @@ struct deferred_split *get_deferred_spli
 
 void folio_prep_large_rmappable(struct folio *folio)
 {
-	VM_BUG_ON_FOLIO(folio_order(folio) < 2, folio);
-	INIT_LIST_HEAD(&folio->_deferred_list);
+	if (!folio || !folio_test_large(folio))
+		return;
+	if (folio_order(folio) > 1)
+		INIT_LIST_HEAD(&folio->_deferred_list);
 	folio_set_large_rmappable(folio);
 }
 
@@ -2720,7 +2722,8 @@ int split_huge_page_to_list(struct page
 	/* Prevent deferred_split_scan() touching ->_refcount */
 	spin_lock(&ds_queue->split_queue_lock);
 	if (folio_ref_freeze(folio, 1 + extra_pins)) {
-		if (!list_empty(&folio->_deferred_list)) {
+		if (folio_order(folio) > 1 &&
+		    !list_empty(&folio->_deferred_list)) {
 			ds_queue->split_queue_len--;
 			list_del(&folio->_deferred_list);
 		}
@@ -2771,6 +2774,9 @@ void folio_undo_large_rmappable(struct f
 	struct deferred_split *ds_queue;
 	unsigned long flags;
 
+	if (folio_order(folio) <= 1)
+		return;
+
 	/*
 	 * At this point, there is no one trying to add the folio to
 	 * deferred_list. If folio is not in deferred_list, it's safe
@@ -2796,7 +2802,12 @@ void deferred_split_folio(struct folio *
 #endif
 	unsigned long flags;
 
-	VM_BUG_ON_FOLIO(folio_order(folio) < 2, folio);
+	/*
+	 * Order 1 folios have no space for a deferred list, but we also
+	 * won't waste much memory by not adding them to the deferred list.
+	 */
+	if (folio_order(folio) <= 1)
+		return;
 
 	/*
 	 * The try_to_unmap() in page reclaim path might reach here too,
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -419,8 +419,7 @@ static inline struct folio *page_rmappab
 {
 	struct folio *folio = (struct folio *)page;
 
-	if (folio && folio_order(folio) > 1)
-		folio_prep_large_rmappable(folio);
+	folio_prep_large_rmappable(folio);
 	return folio;
 }
 
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -519,9 +519,6 @@ void page_cache_ra_order(struct readahea
 		/* Don't allocate pages past EOF */
 		while (index + (1UL << order) - 1 > limit)
 			order--;
-		/* THP machinery does not support order-1 */
-		if (order == 1)
-			order = 0;
 		err = ra_alloc_folio(ractl, index, mark, order, gfp);
 		if (err)
 			break;


