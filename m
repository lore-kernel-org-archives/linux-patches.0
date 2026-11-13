Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590180;
	b=hwfeKfk9YoNxG2El+JivnS5QJUwvUoh8B2aAaywxv8A8KkXW+s8/hSK60JhN82eydBLV
	 dfrW26m30BhkFqTi6yfyg2FmDlG0pwBYe2wOVHvhSTbH2gnO3CwXhS9V/zJWOAGHkkDci
	 KedJW1rghMCuH0+o2wDh3WwmfN6fcnx9Zcx9PW1pFtjiA7eigN1+/ShtcHZOuOs7mRn4n
	 P3d5d3m25v+t7tErgPxkcu9IKBrYoiFpxjQiYGgetJkIxgwCVhpnRCBOifF8CN+NXOaTs
	 53sJv8oKg4oJLDAVmqlp/A2WRcCfZXn64bA6QhBwsQxym37frGvdGumNDSD14ZpcC/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=illX00wi8K3FErzruICMxjmjF9GomoFloYf14DZyhuU=;
	b=FkuAbHK130r/NKeIQbrekw5ULL0sKV5tpDXt0degITDGdyPu6RUgAhBq14GuF9gMj49p
	 fR8VwxvMIHRwhXViOFxq2BedqdXJMv+mzuDRUIrNRMDesww+GFoeDP7eiXyfaNCUBWIgD
	 kOp5OxxOcms4MFu20lJqteIO+thi4mxo8tuntUkNk7gMBK42ckQtCn3UOj7TfYBrqdLCG
	 mSHI46FUalOXZ6mL7f6y035tanR8FJNpUGWk1h/hjxVdDN2cZJh5gIBuV5HPkh55IGaOw
	 VAWPVQ+tko2jYA1ZjEqgvb0oQBERRvSfaiX+hX2CE9lKKugS6vOfX432/BoriGOKCrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HoVUgj35;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3422607143E;
	Fri, 13 Nov 2026 17:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HoVUgj35
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B781F000C4;
	Fri, 13 Nov 2026 17:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590179;
	bh=illX00wi8K3FErzruICMxjmjF9GomoFloYf14DZyhuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HoVUgj3577qV767FB2iRRmU2wacQW+4+FZk0Qow0m/zuUfzzrRnUL/VyjQDE2J+KR
	 4Cyx3gZNTr2PxJtZ7DT6jOHmtQwdO1womAmA89Ok7qKWPiDj95LMg86WWz3yQwnCxk
	 S0ykmdX1lvScq5R/mdkwkJkENhiRWAwQ7XXI1cTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Usama Arif <usama.arif@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 145/686] mm: page_alloc: make defrag_mode retries follow the promoted order
Date: Fri, 13 Nov 2026 10:44:38 -0500
Message-ID: <20261113153825.716941935@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiryl Shutsemau (Meta) <kas@kernel.org>

commit 4cd78a2dcfbb13f049f841b98763896a3d1d7750 upstream.

Since commit 7e8756d7ad22 ("mm: page_alloc: fix non-movable reclaim storm
in defrag_mode"), direct reclaim and compaction for non-movable requests
under defrag_mode run at pageblock_order, to produce the whole blocks that
ALLOC_NOFRAGMENT needs.  The retry decisions that follow still use the
request order.  An order-0 request can therefore retry indefinitely
without ever reaching the ALLOC_NOFRAGMENT fallback:

- Reclaim at pageblock_order gives up after one pass as soon as a zone
  looks compaction_ready(), and do_try_to_free_pages() then returns 1
  even though nothing was reclaimed. It returns before the retry that
  would reclaim memory.low-protected cgroups, so when most memory is
  protected, the pass that did run finds next to nothing.

- Compaction at pageblock_order fails or is deferred.

- should_reclaim_retry() takes the reported progress as progress for
  the order-0 request and resets no_progress_loops. The request
  retries.

Order 1-3 requests loop the same way, and should_compact_retry() also
checks their pageblock_order compaction result against the request order.

On a production host (64G, defrag_mode, memory.low covering most of the
workload), 95% of direct reclaim runs were order-9 runs that returned 1
with nothing reclaimed, at up to 60k runs per second.  Across ~200M
should_reclaim_retry() calls in a day, no_progress_loops never left 0.
The spinning allocations were SLUB slab refills for inode and dentry
caches.  The time spent registers as memory pressure, and pressure-based
OOM killing takes down both workloads and system services.

For promoted requests:

- Reclaim progress does not reset no_progress_loops, as for costly
  orders.

- should_compact_retry() checks the compaction result at the promoted
  order and does not retry COMPACT_SKIPPED, since the request can fall
  back. The compaction priority floor and the COMPACT_SUCCESS retry
  limit stay those of the request order, so a non-costly request still
  gets its COMPACT_PRIO_SYNC_FULL pass before it falls back.

When a promoted request takes the fallback, reset the retry counters, so
that the fallback attempt gets a full retry budget before the OOM killer
is considered.  A request whose reclaim was not promoted spent its budget
on the request itself and keeps its counters, as Usama Arif pointed out.

__alloc_pages_slowpath() computes the promoted order once per iteration
and keeps it in alloc_context for direct reclaim, direct compaction and
the two retry helpers, so no callee has to recompute it.  Harry Yoo asked
for the promoted order to be explicit rather than derived in each callee,
and Vlastimil Babka suggested alloc_context over new function parameters.

In a VM reproducer (32G, defrag_mode, inode churn under memory.low):

                                        before    after
    should_reclaim_retry() calls           63M     293k
    peak memory pressure (PSI some avg10)  99%      12%

File creation runs 5.7x faster.

[kas@kernel.org: s/order_nofrag_promoted/order_defrag_promoted/, per hannes]
  Link: https://lore.kernel.org/atDL-nSFP2KVU7cI@thinkstation
Link: https://lore.kernel.org/as5q14OsbK2CmOrh@thinkstation
Fixes: 7e8756d7ad22 ("mm: page_alloc: fix non-movable reclaim storm in defrag_mode")
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Assisted-by: LLM
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
[ kas: alloc_context is in mm/internal.h and compaction_zonelist_suitable()
  takes no gfp_mask in 6.18. 6.18 also tries compaction once before the
  retry loop; set reclaim_compact_order there as well, or that attempt
  sees order 0 and is skipped. ]
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/internal.h   |  2 ++
 mm/page_alloc.c | 68 +++++++++++++++++++++++++++++++------------------
 2 files changed, 45 insertions(+), 25 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index ef42eee87c7be..e0adafc45c8c3 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -594,6 +594,8 @@ struct alloc_context {
 	 */
 	enum zone_type highest_zoneidx;
 	bool spread_dirty_pages;
+	/* Set by __alloc_pages_slowpath() before reclaim and compaction */
+	unsigned int reclaim_compact_order;
 };
 
 /*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8bdc35efad26b..8d608699bf508 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4130,6 +4130,12 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	return page;
 }
 
+static inline bool order_defrag_promoted(unsigned int order,
+					 const struct alloc_context *ac)
+{
+	return ac->reclaim_compact_order != order;
+}
+
 /*
  * Maximum number of compaction retries with a progress before OOM
  * killer is consider as the only way to move forward.
@@ -4152,22 +4158,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 		.order = order,
 		.page = NULL,
 	};
-	int compact_order = order;
-
-	/*
-	 * If fallbacks are not permitted (defrag_mode), we either
-	 * need to reclaim space in a block of matching type, or clear
-	 * out an entire block to allow __rmqueue_claim() to convert.
-	 *
-	 * Reclaim by itself is primarily freeing space in movable
-	 * blocks, since that's where the LRU pages live. So this
-	 * works for movable requests, but not for others.
-	 *
-	 * For those, promote the order to help make blocks, instead
-	 * of spinning in reclaim alone unproductively.
-	 */
-	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
-		compact_order = max(order, pageblock_order);
+	int compact_order = ac->reclaim_compact_order;
 
 	if (!compact_order)
 		return NULL;
@@ -4258,7 +4249,7 @@ should_compact_retry(struct alloc_context *ac, int order, int alloc_flags,
 	int retries = *compaction_retries;
 	enum compact_priority priority = *compact_priority;
 
-	if (!order)
+	if (!ac->reclaim_compact_order)
 		return false;
 
 	if (fatal_signal_pending(current))
@@ -4267,9 +4258,11 @@ should_compact_retry(struct alloc_context *ac, int order, int alloc_flags,
 	/*
 	 * Compaction was skipped due to a lack of free order-0
 	 * migration targets. Continue if reclaim can help.
+	 * Promoted requests fall back instead.
 	 */
 	if (compact_result == COMPACT_SKIPPED) {
-		ret = compaction_zonelist_suitable(ac, order, alloc_flags);
+		if (!order_defrag_promoted(order, ac))
+			ret = compaction_zonelist_suitable(ac, order, alloc_flags);
 		goto out;
 	}
 
@@ -4467,11 +4460,7 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 	struct page *page = NULL;
 	unsigned long pflags;
 	bool drained = false;
-	int reclaim_order = order;
-
-	/* Match the slowpath compaction promotion in __alloc_pages_direct_compact */
-	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
-		reclaim_order = max(order, pageblock_order);
+	int reclaim_order = ac->reclaim_compact_order;
 
 	psi_memstall_enter(&pflags);
 	*did_some_progress = __perform_reclaim(gfp_mask, reclaim_order, ac);
@@ -4639,9 +4628,12 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 	/*
 	 * Costly allocations might have made a progress but this doesn't mean
 	 * their order will become available due to high fragmentation so
-	 * always increment the no progress counter for them
+	 * always increment the no progress counter for them. The same goes for
+	 * promoted requests: their reclaim reports progress when it backs off
+	 * for compaction without freeing anything.
 	 */
-	if (did_some_progress && order <= PAGE_ALLOC_COSTLY_ORDER)
+	if (did_some_progress && order <= PAGE_ALLOC_COSTLY_ORDER &&
+	    !order_defrag_promoted(order, ac))
 		*no_progress_loops = 0;
 	else
 		(*no_progress_loops)++;
@@ -4838,6 +4830,11 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 			(costly_order ||
 			   (order > 0 && ac->migratetype != MIGRATE_MOVABLE))
 			&& !gfp_pfmemalloc_allowed(gfp_mask)) {
+		/* Promote as the retry loop below does */
+		ac->reclaim_compact_order = order;
+		if ((alloc_flags & ALLOC_NOFRAGMENT) &&
+		    ac->migratetype != MIGRATE_MOVABLE)
+			ac->reclaim_compact_order = max(order, pageblock_order);
 		page = __alloc_pages_direct_compact(gfp_mask, order,
 						alloc_flags, ac,
 						INIT_COMPACT_PRIORITY,
@@ -4936,6 +4933,22 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	if (current->flags & PF_MEMALLOC)
 		goto nopage;
 
+	/*
+	 * If fallbacks are not permitted (defrag_mode), we either
+	 * need to reclaim space in a block of matching type, or clear
+	 * out an entire block to allow __rmqueue_claim() to convert.
+	 *
+	 * Reclaim by itself is primarily freeing space in movable
+	 * blocks, since that's where the LRU pages live. So this
+	 * works for movable requests, but not for others.
+	 *
+	 * For those, promote the order to help make blocks, instead
+	 * of spinning in reclaim alone unproductively.
+	 */
+	ac->reclaim_compact_order = order;
+	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
+		ac->reclaim_compact_order = max(order, pageblock_order);
+
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags, ac,
 							&did_some_progress);
@@ -4979,6 +4992,11 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	/* Reclaim/compaction failed to prevent the fallback */
 	if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT)) {
 		alloc_flags &= ~ALLOC_NOFRAGMENT;
+		/* Retries went into making blocks, start the fallback afresh */
+		if (order_defrag_promoted(order, ac)) {
+			no_progress_loops = 0;
+			compaction_retries = 0;
+		}
 		goto retry;
 	}
 
-- 
2.53.0



