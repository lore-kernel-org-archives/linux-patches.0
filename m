Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC36A34D4CB;
	Fri, 21 Nov 2025 13:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733563; cv=none; b=QwvQxt+igLiQFyWJVs4IGCBpYHA8GvdaGq0j8fz+9NFFRNa+wjMVLk1WT4dv+dCQc83/VhtDcjLPDnk/10kvzXQklH3KUFkjsJeDZqcWs2hc5+gw1/KVbN/WSGMu8O4YTU4oqhWMP2V3Y+ppyy/iLhPFGiIMzccSujB0Mios4WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733563; c=relaxed/simple;
	bh=JWJoUMNIxrDEKHmdD35A7sDsyaXIwjDqPn01SuOIZsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qiy7HnJ4Z9zk3oHNem37Z4sgPd6W47qJVyqeCV+iHdn8XUr6wXHbaWhpteifYssMyzcaazN7QhfhYJ6GmHCeEdmU4ax0wSAnksyJqXn23WdTGMIyDqktB3VyW8R8Cq9cjuUgk8wclL+G27iqQEniHQ2ORV9DLDXcMO+q4mfaP7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rrcj8kO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rrcj8kO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A839C4CEF1;
	Fri, 21 Nov 2025 13:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733563;
	bh=JWJoUMNIxrDEKHmdD35A7sDsyaXIwjDqPn01SuOIZsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrcj8kO1iT+sWe3b9JHKaSNds4+Nb7sD8NejvXGtVyw3kk8d5buRQvbXRm1Isp1hH
	 pLknLlFbJkGmvyAhSLJKa8/rKgNvdG2SKQxV/aHknp+h12jvhij077EUt+8w/avdvf
	 R/dO338aqZ9vN03eLG2EWBg4q0toFeKA4ak8HLjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Hao <vernhao@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeelb@google.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Leon Huang Fu <leon.huangfu@shopee.com>
Subject: [PATCH 6.6 511/529] mm: memcg: add THP swap out info for anonymous reclaim
Date: Fri, 21 Nov 2025 14:13:30 +0100
Message-ID: <20251121130249.218124865@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Hao <vernhao@tencent.com>

[ Upstream commit 811244a501b967b00fecb1ae906d5dc6329c91e0 ]

At present, we support per-memcg reclaim strategy, however we do not know
the number of transparent huge pages being reclaimed, as we know the
transparent huge pages need to be splited before reclaim them, and they
will bring some performance bottleneck effect.  for example, when two
memcg (A & B) are doing reclaim for anonymous pages at same time, and 'A'
memcg is reclaiming a large number of transparent huge pages, we can
better analyze that the performance bottleneck will be caused by 'A'
memcg.  therefore, in order to better analyze such problems, there add THP
swap out info for per-memcg.

[akpm@linux-foundation.orgL fix swap_writepage_fs(), per Johannes]
  Link: https://lkml.kernel.org/r/20230913213343.GB48476@cmpxchg.org
Link: https://lkml.kernel.org/r/20230913164938.16918-1-vernhao@tencent.com
Signed-off-by: Xin Hao <vernhao@tencent.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Leon Huang Fu <leon.huangfu@shopee.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/cgroup-v2.rst |    9 +++++++++
 mm/memcontrol.c                         |    2 ++
 mm/page_io.c                            |    8 ++++----
 mm/vmscan.c                             |    1 +
 4 files changed, 16 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1532,6 +1532,15 @@ PAGE_SIZE multiple when read back.
 		collapsing an existing range of pages. This counter is not
 		present when CONFIG_TRANSPARENT_HUGEPAGE is not set.
 
+	  thp_swpout (npn)
+		Number of transparent hugepages which are swapout in one piece
+		without splitting.
+
+	  thp_swpout_fallback (npn)
+		Number of transparent hugepages which were split before swapout.
+		Usually because failed to allocate some continuous swap space
+		for the huge page.
+
   memory.numa_stat
 	A read-only nested-keyed file which exists on non-root cgroups.
 
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -704,6 +704,8 @@ static const unsigned int memcg_vm_event
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	THP_FAULT_ALLOC,
 	THP_COLLAPSE_ALLOC,
+	THP_SWPOUT,
+	THP_SWPOUT_FALLBACK,
 #endif
 };
 
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -208,8 +208,10 @@ int swap_writepage(struct page *page, st
 static inline void count_swpout_vm_event(struct folio *folio)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (unlikely(folio_test_pmd_mappable(folio)))
+	if (unlikely(folio_test_pmd_mappable(folio))) {
+		count_memcg_folio_events(folio, THP_SWPOUT, 1);
 		count_vm_event(THP_SWPOUT);
+	}
 #endif
 	count_vm_events(PSWPOUT, folio_nr_pages(folio));
 }
@@ -278,9 +280,6 @@ static void sio_write_complete(struct ki
 			set_page_dirty(page);
 			ClearPageReclaim(page);
 		}
-	} else {
-		for (p = 0; p < sio->pages; p++)
-			count_swpout_vm_event(page_folio(sio->bvec[p].bv_page));
 	}
 
 	for (p = 0; p < sio->pages; p++)
@@ -296,6 +295,7 @@ static void swap_writepage_fs(struct pag
 	struct file *swap_file = sis->swap_file;
 	loff_t pos = page_file_offset(page);
 
+	count_swpout_vm_event(page_folio(page));
 	set_page_writeback(page);
 	unlock_page(page);
 	if (wbc->swap_plug)
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1922,6 +1922,7 @@ retry:
 								folio_list))
 						goto activate_locked;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+					count_memcg_folio_events(folio, THP_SWPOUT_FALLBACK, 1);
 					count_vm_event(THP_SWPOUT_FALLBACK);
 #endif
 					if (!add_to_swap(folio))


