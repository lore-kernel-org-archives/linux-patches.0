Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948E0175A87;
	Sat, 28 Feb 2026 17:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301389; cv=none; b=PQI9Pby2w2eXTKjJs7iMCb6yM8ujM8uhvonv6yprvnHroZiOoNeUzEvUd+vIJNhCRJERRpJX82rUGtD+b/drHGkI4arpb1HWwrJP5z25RE7VSG8SkknLBQOmbqY37aGCv2l1Qwl9v8nqKslIvG/eMY/U0ROCMzkaH6mnRb5f9/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301389; c=relaxed/simple;
	bh=0vPLSjmVhgZwwBfqYQxCg75H8Zr+i99tlNv+ksisGgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bsFZt+ljRLmSptvKdyxPkyk3DNqzLdhFiogI+Ydm5yOxND7EuoTMnVAal2nk7gNfZ/gJvKROSGzwO+bm1HIpzf3xgRO2mGURMF4qsvEMVK1ATj+EYiugBzo42CGs7ekmS6LJT3SwdLRJKYVvLUrY4y7sXQvWZIIB5zaBT/LFp2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FWvqaQ0S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FWvqaQ0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FAF3C116D0;
	Sat, 28 Feb 2026 17:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301389;
	bh=0vPLSjmVhgZwwBfqYQxCg75H8Zr+i99tlNv+ksisGgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FWvqaQ0SCyIzjJLjXR1u38JbIs2dCKYa6volXwsLLdzzCVFAKSRDPp2O2ZgzDsCzG
	 62AKe5c8japA0Xuv3YKhw3ZvwzJdGVk/9D0jRDiVppUgJHHCRnzmhxZEJDe1ObmZea
	 v6RBf0c5hzVdbZSYd8sm5qi/4Q06HDv09Sy42jC21AzttOXuTu+3RzuKwg+ztyrigr
	 cvzbjKhk36TJtlLTTMTrUJHWZLOtbToJuSkFioPqU/Fc83ZCDDoxqX5ZvzRN8E2R+Q
	 O8WMkQQBS0fa2erKxuHVKPd55NPQ/309yVRKmotlUXLjEJfycVqHWxzYGUYhmUY4gX
	 BCsxKVb+SiPkw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Zi Yan <ziy@nvidia.com>,
	Brendan Jackman <jackmanb@google.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 577/752] mm, page_alloc, thp: prevent reclaim for __GFP_THISNODE THP allocations
Date: Sat, 28 Feb 2026 12:44:48 -0500
Message-ID: <20260228174750.1542406-577-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Vlastimil Babka <vbabka@suse.cz>

[ Upstream commit 9c9828d3ead69416d731b1238802af31760c823e ]

Since commit cc638f329ef6 ("mm, thp: tweak reclaim/compaction effort of
local-only and all-node allocations"), THP page fault allocations have
settled on the following scheme (from the commit log):

1. local node only THP allocation with no reclaim, just compaction.
2. for madvised VMA's or when synchronous compaction is enabled always - THP
   allocation from any node with effort determined by global defrag setting
   and VMA madvise
3. fallback to base pages on any node

Recent customer reports however revealed we have a gap in step 1 above.
What we have seen is excessive reclaim due to THP page faults on a NUMA
node that's close to its high watermark, while other nodes have plenty of
free memory.

The problem with step 1 is that it promises no reclaim after the
compaction attempt, however reclaim is only avoided for certain compaction
outcomes (deferred, or skipped due to insufficient free base pages), and
not e.g.  when compaction is actually performed but fails (we did see
compact_fail vmstat counter increasing).

THP page faults can therefore exhibit a zone_reclaim_mode-like behavior,
which is not the intention.

Thus add a check for __GFP_THISNODE that corresponds to this exact
situation and prevents continuing with reclaim/compaction once the initial
compaction attempt isn't successful in allocating the page.

Note that commit cc638f329ef6 has not introduced this over-reclaim
possibility; it appears to exist in some form since commit 2f0799a0ffc0
("mm, thp: restore node-local hugepage allocations").  Followup commits
b39d0ee2632d ("mm, page_alloc: avoid expensive reclaim when compaction may
not succeed") and cc638f329ef6 have moved in the right direction, but left
the abovementioned gap.

Link: https://lkml.kernel.org/r/20251219-costly-noretry-thisnode-fix-v1-1-e1085a4a0c34@suse.cz
Fixes: 2f0799a0ffc0 ("mm, thp: restore node-local hugepage allocations")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_alloc.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 623f6e5b583ab..10708f37575d4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4789,6 +4789,20 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 			    compact_result == COMPACT_DEFERRED)
 				goto nopage;
 
+			/*
+			 * THP page faults may attempt local node only first,
+			 * but are then allowed to only compact, not reclaim,
+			 * see alloc_pages_mpol().
+			 *
+			 * Compaction can fail for other reasons than those
+			 * checked above and we don't want such THP allocations
+			 * to put reclaim pressure on a single node in a
+			 * situation where other nodes might have plenty of
+			 * available memory.
+			 */
+			if (gfp_mask & __GFP_THISNODE)
+				goto nopage;
+
 			/*
 			 * Looks like reclaim/compaction is worth trying, but
 			 * sync compaction could be very expensive, so keep
-- 
2.51.0

