Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A6830C160;
	Fri,  4 Sep 2026 05:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498465; cv=none; b=LFP36Ft0FXCi5lB5axAsnhc4hZ5xlS+733PPJkuepoVShSWveefHIcGxKstFrkbp000Ym/p3E97D01S0VDSO2LGhywQ3B6tHc8C2hoXtYJPEOWIb6e9KSzb9DTk5weLMN5hKjZ0J2JpQ6+xN1sF3HMv6xaqbg7ZeeyN4fdp6IPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498465; c=relaxed/simple;
	bh=hHJE3RiTNCKvdKD4AqRPky2OCrxGt188VikLZjJciMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8hHaJgk0OFqIr/fCcb9KywcnDabnNb30Uc0qq7KtWO5nlz3RkH0FmCzPrq5qo5ZsHCPBKarnfGA2saHZhwaTXj5Q/honmgat2emFtAY2EjTrE3SmIhrIxsXtttPjpeJXRlVy/7JagrtE9n3Po1+Oo3v9qFyWMX/1vP/hIUBb54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TB9mTqbz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TB9mTqbz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77CCB1F00A3D;
	Fri,  4 Sep 2026 05:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498464;
	bh=a/dVP2cRGvBcObyofnCrwwYEVNzbD9+w0q2TIEPhUY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TB9mTqbzX15LiEOuBeGofF2oZK/eDARoykgjxF41AXM9gJ/Gg8NA5EVXySzIM03t8
	 aSAtzsjfSLoHfi2X3H/dzRm0ESl1VRV/MmFAPhTc+3Md6OIHqEqs3IzXUw+M0iqG/E
	 bWcgodk7K6Nvc5JYL6KnSXlUliHMdA5aeTbgxmRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 071/713] mm: compaction: support non-movable compaction for pageblock requests
Date: Fri,  4 Sep 2026 06:50:39 +0200
Message-ID: <20260904045805.432085610@linuxfoundation.org>
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

From: Johannes Weiner <hannes@cmpxchg.org>

commit 1b4b697a5743e624cc259d6c31a8d8716b796305 upstream.

While trying to fix a reclaim storm in defrag_mode, I noticed that
non-movable direct compaction is extremely inefficient.

When searching for space to evacuate, compaction only allows blocks of the
same type as the incoming request.  This is to prevent migratetype
pollution, where a small non-movable request frees space in a movable
block and provokes the allocator to fall back and pollute it.

This protection is reasonable on one hand, but the downside is that it
makes non-movable direct compaction nearly useless: if we get the type
annotations right, by definition there aren't any movable pages inside the
non-movable blocks it is allowed to scan.

With defrag_mode, the goal is the production of whole blocks, which are
essentially type neutral: __rmqueue_claim() will convert them wholesale on
alloc.  This makes type mixing and pollution a non-issue.

Fix the pollution gates to take the requested order into account, and
allow whole-block requests to scan blocks of other types.

The only exception is CMA blocks.  That type is sticky and these blocks
cannot be claimed to other types.  Continue to be strict with them, and
allow only explicit ALLOC_CMA requests and kcompactd to evacuate them.

Link: https://lore.kernel.org/20260722150006.3848560-3-hannes@cmpxchg.org
Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Gregory Price <gourry@gourry.net>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/compaction.c |   46 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 7 deletions(-)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1381,12 +1381,44 @@ static bool suitable_migration_source(st
 	if (pageblock_skip_persistent(page))
 		return false;
 
-	if ((cc->mode != MIGRATE_ASYNC) || !cc->direct_compaction)
+	/*
+	 * Background compaction produces blocks for the zone at
+	 * large, with no particular allocation context. Allow all
+	 * block types, including CMA.
+	 */
+	if (!cc->direct_compaction)
 		return true;
 
 	block_mt = get_pageblock_migratetype(page);
 
-	if (cc->migratetype == MIGRATE_MOVABLE)
+	/*
+	 * CMA pages can only be taken by ALLOC_CMA requests. For anybody
+	 * else, vacating a CMA block consumes free pages the caller
+	 * could have used, and produces free pages it cannot.
+	 */
+	if (is_migrate_cma(block_mt) && !(cc->alloc_flags & ALLOC_CMA))
+		return false;
+
+	/*
+	 * Per default, scans are restricted to blocks compatible with
+	 * the request, to prevent cross-contamination. Once
+	 * compaction priority escalates to synchronous scans, though,
+	 * scan all blocks to try to make forward progress. For
+	 * movable request, this likely helps little: there shouldn't
+	 * be many migratable pages inside non-movable blocks besides
+	 * allocator fallbacks. For non-movable requests, this helps a
+	 * lot, as they can finally scan movable blocks.
+	 */
+	if (cc->mode != MIGRATE_ASYNC)
+		return true;
+
+	/*
+	 * Prevent <pageblock_order unmovable/reclaimable requests from
+	 * polluting movable blocks through fallbacks. Whole-block production
+	 * (directly requested, or defrag_mode) is exempt as the allocator
+	 * claims and converts these.
+	 */
+	if (cc->migratetype == MIGRATE_MOVABLE || cc->order >= pageblock_order)
 		return is_migrate_movable(block_mt);
 	else
 		return block_mt == cc->migratetype;
@@ -1974,12 +2006,12 @@ static unsigned long fast_find_migratebl
 		return pfn;
 
 	/*
-	 * Only allow kcompactd and direct requests for movable pages to
-	 * quickly clear out a MOVABLE pageblock for allocation. This
-	 * reduces the risk that a large movable pageblock is freed for
-	 * an unmovable/reclaimable small allocation.
+	 * Prevent <pageblock_order unmovable/reclaimable requests from
+	 * polluting movable blocks through fallbacks. Whole-block production
+	 * is exempt as the allocator claims and converts these.
 	 */
-	if (cc->direct_compaction && cc->migratetype != MIGRATE_MOVABLE)
+	if (cc->direct_compaction && cc->migratetype != MIGRATE_MOVABLE &&
+	    cc->order < pageblock_order)
 		return pfn;
 
 	/*


