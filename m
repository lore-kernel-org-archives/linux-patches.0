Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4FA190077;
	Tue, 10 Sep 2024 09:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961409; cv=none; b=P2TMcTGzZZKXi4lIX+z5Pa6ic9zgOu+YWzkebDXu0glygug+L9AlbeHfyTBARNLvduw3sc8hqeyI4aO5w7XJiooxIR0xrC0xmcxM/4+lzdZwTXteTJK2H/kbdj6l1CO7zf3VrYIK4iH7iKABFugN9ScZmX7gDBMOcjPKUWjM9Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961409; c=relaxed/simple;
	bh=XwueBSFHdj5FztlJRUO2AWtiSLqDOOxjpyYC1qORy2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITKCV+xYdiMEtM0CQI2+3Q+XEA2JyXKyi1n5RUzytaH0qTQ/qMDzIDDq1aOQzkD2n/x2tjvVR2IAR35ht7aBXoVYMaOUrsrqD47edeyG41Bh8rR9YIqkXjl5zodH4M/TUr9eY4644+u4xoBOei2ElhjZKDCYmd27keR1Nt13jdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZ5hM/L2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZ5hM/L2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4611DC4CEC3;
	Tue, 10 Sep 2024 09:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961408;
	bh=XwueBSFHdj5FztlJRUO2AWtiSLqDOOxjpyYC1qORy2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZ5hM/L21YZ7k7J+26FQGiXufIUMXkEpRHZFlPkCslm9TIxsIcBjyopqMem8p+jEU
	 2OJWRLBmGnf7oZW0RM3Rg8iU+yDoHQBZkL7DL7oTkI2VkyB+vFIKaxwZOr/Y6FdXpx
	 YX5p2S4nkrhoLcgX3Ly1JrV/pRJ9gJvUKUG2bPL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Usama Arif <usamaarif642@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Bharata B Rao <bharata@amd.com>,
	Breno Leitao <leitao@debian.org>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Rik van Riel <riel@surriel.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Yu Zhao <yuzhao@google.com>,
	Zhaoyang Huang <huangzhaoyang@gmail.com>,
	Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.10 060/375] Revert "mm: skip CMA pages when they are not available"
Date: Tue, 10 Sep 2024 11:27:37 +0200
Message-ID: <20240910092624.239613557@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Usama Arif <usamaarif642@gmail.com>

commit bfe0857c20c663fcc1592fa4e3a61ca12b07dac9 upstream.

This reverts commit 5da226dbfce3 ("mm: skip CMA pages when they are not
available") and b7108d66318a ("Multi-gen LRU: skip CMA pages when they are
not eligible").

lruvec->lru_lock is highly contended and is held when calling
isolate_lru_folios.  If the lru has a large number of CMA folios
consecutively, while the allocation type requested is not MIGRATE_MOVABLE,
isolate_lru_folios can hold the lock for a very long time while it skips
those.  For FIO workload, ~150million order=0 folios were skipped to
isolate a few ZONE_DMA folios [1].  This can cause lockups [1] and high
memory pressure for extended periods of time [2].

Remove skipping CMA for MGLRU as well, as it was introduced in sort_folio
for the same resaon as 5da226dbfce3a2f44978c2c7cf88166e69a6788b.

[1] https://lore.kernel.org/all/CAOUHufbkhMZYz20aM_3rHZ3OcK4m2puji2FGpUpn_-DevGk3Kg@mail.gmail.com/
[2] https://lore.kernel.org/all/ZrssOrcJIDy8hacI@gmail.com/

[usamaarif642@gmail.com: also revert b7108d66318a, per Johannes]
  Link: https://lkml.kernel.org/r/9060a32d-b2d7-48c0-8626-1db535653c54@gmail.com
  Link: https://lkml.kernel.org/r/357ac325-4c61-497a-92a3-bdbd230d5ec9@gmail.com
Link: https://lkml.kernel.org/r/9060a32d-b2d7-48c0-8626-1db535653c54@gmail.com
Fixes: 5da226dbfce3 ("mm: skip CMA pages when they are not available")
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmscan.c |   24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1587,25 +1587,6 @@ static __always_inline void update_lru_s
 
 }
 
-#ifdef CONFIG_CMA
-/*
- * It is waste of effort to scan and reclaim CMA pages if it is not available
- * for current allocation context. Kswapd can not be enrolled as it can not
- * distinguish this scenario by using sc->gfp_mask = GFP_KERNEL
- */
-static bool skip_cma(struct folio *folio, struct scan_control *sc)
-{
-	return !current_is_kswapd() &&
-			gfp_migratetype(sc->gfp_mask) != MIGRATE_MOVABLE &&
-			folio_migratetype(folio) == MIGRATE_CMA;
-}
-#else
-static bool skip_cma(struct folio *folio, struct scan_control *sc)
-{
-	return false;
-}
-#endif
-
 /*
  * Isolating page from the lruvec to fill in @dst list by nr_to_scan times.
  *
@@ -1652,8 +1633,7 @@ static unsigned long isolate_lru_folios(
 		nr_pages = folio_nr_pages(folio);
 		total_scan += nr_pages;
 
-		if (folio_zonenum(folio) > sc->reclaim_idx ||
-				skip_cma(folio, sc)) {
+		if (folio_zonenum(folio) > sc->reclaim_idx) {
 			nr_skipped[folio_zonenum(folio)] += nr_pages;
 			move_to = &folios_skipped;
 			goto move;
@@ -4314,7 +4294,7 @@ static bool sort_folio(struct lruvec *lr
 	}
 
 	/* ineligible */
-	if (zone > sc->reclaim_idx || skip_cma(folio, sc)) {
+	if (zone > sc->reclaim_idx) {
 		gen = folio_inc_gen(lruvec, folio, false);
 		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;


