Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591613;
	b=3guRrwLw4bYjbg8YBtzpJ+kHLyY8KIDOv/hpbAS8KcKpp82jYF2BOxZVxmOks3a0OPyN
	 JoToUPoUagdOEQq9VVEBb84rkDziCZLqWSxmjrPnzLSsIE42UsGDMunSv3ANOB3M1Dhv6
	 7ST4cIOeZnV/BjROpfyydYVi4CJrm2mRINQpVyZC8zO8uNIDDqjJ7arCKFcKxk/XKMMvc
	 9qFI0zYFXLp9JfaY6qaSoKKIBCJf/xMY7h+WqPP32knb5BYnqnA/PiPi1JrqGIWcya/CN
	 RQlJ5EL3dpYRQN98GIKVae+3TLoNjahe4yIoFuW4NTAC8PrE6dJmAsLkfAluesCeoqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591613;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f46/pTyIyj5/dP+8QNkGgqHZhQxNzUxcLWwS8sOSp1M=;
	b=OctDvX3feNu2bmTnzzh/1QxKbVufJX17P2Nhy2DQgUPGBrclh/TYuAzLhJTtRB60UAFJ
	 zBYpNmG/2eMuZmSTqa4UpMswrDVBKj8AbqUJOTCoe7/5gQatD1C4iwHSalkedTUzXDOmZ
	 M6mxcv+bL0+icoJ/6fKSu9NJlDzXxrTGD2u4cp+KJL0HxcOzDQolMTyZugFexrS3ZZF54
	 nvSwoWBV85jSXbwxvZVJC0PPKTWgA69EpQggOC/ObTLivwvfsFgPUBYCRF7NGdT/lfMCy
	 /NOwWGq3x2Q733UUYaYwG9ELt3z6SOs3k6T/9zhx45Sj2Bu/7X5NXLqe4C+00l5E5CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2veIM+O4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF566606B47A;
	Fri, 13 Nov 2026 17:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2veIM+O4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30001F000C4;
	Fri, 13 Nov 2026 17:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591612;
	bh=f46/pTyIyj5/dP+8QNkGgqHZhQxNzUxcLWwS8sOSp1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2veIM+O4INsKGd/clNo+g2SQ93FCfvutSmbMbw+Sc0Qpt6caK4TXtMRvev9vFc/Xh
	 xgqiJBc0n1PxzeTdXwWES639AA7lqb8OLLsXArvJNDmFc3nQKxqA9eQTOk8Xx2srP5
	 QZqvWzBM6wnlS/AUjGofcg64p9cJ0HowOlY6WjuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Xi <xiqi2@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Michal Hocko <mhocko@suse.com>,
	Nanyong Sun <sunnanyong@huawei.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 612/670] mm/page_isolation: fix UBSAN shift-out-of-bounds warning
Date: Fri, 13 Nov 2026 10:52:56 -0500
Message-ID: <20261113153832.554911251@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qi Xi <xiqi2@huawei.com>

[ Upstream commit eba0e6297edd60a85bc96ff5cfb734d066af62dd ]

Patch series "mm/page_isolation: fix UBSAN shift-out-of-bounds in
isolate_single_pageblock", v3.

Patch 1 fixes a UBSAN shift-out-of-bounds warning in the PageBuddy branch
of isolate_single_pageblock() triggered by concurrent buddy allocation.

Patch 2 addresses the same class of issue in the PageCompound branch,
where racy compound_order() and compound_head() reads could lead to
out-of-range shifts or incorrect page skipping.

This patch (of 2):

A contig-range allocation racing with buddy allocation on the adjacent
pageblock can trigger:

 UBSAN: shift-out-of-bounds in mm/page_isolation.c:393:15
 shift exponent -749042176 is negative
 Call trace:
  isolate_single_pageblock
  start_isolate_page_range
  alloc_contig_frozen_range_noprof
  alloc_contig_range_noprof

isolate_single_pageblock() first calls set_migratetype_isolate() with
zone->lock held, which marks the pageblock MIGRATE_ISOLATE and moves any
free page straddling the boundary out of the way.  Once the lock is
dropped, it scans the MAX_ORDER_NR_PAGES-aligned window [start_pfn,
boundary_pfn) locklessly, only to skip the free pages already handled
above and to detect in-use pages straddling the boundary.  Since this
scan only reads page state to decide how far to skip and returns -EBUSY
on a straddling in-use page, it does not take the lock.

The window also covers the adjacent pageblock, whose free pages stay on
the normal movable/CMA freelist and can be allocated concurrently.  So
after the scan observes PageBuddy(page), another CPU can allocate the
page, leaving a stale value in page->private that makes "1 << order" shift
out of range.

Use buddy_order_unsafe() with READ_ONCE to read the order, and validate
it is within MAX_PAGE_ORDER before shifting to prevent UBSAN warnings.

Since pageblock_isolate_and_move_free_pages() already handles free pages
straddling boundary_pfn under zone->lock, bail out with -EBUSY instead
of VM_WARN_ON_ONCE() when a PageBuddy page appears to cross the boundary
during the lockless scan.

Link: https://lore.kernel.org/20260825120549.966271-2-xiqi2@huawei.com
Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock granularity")
Signed-off-by: Qi Xi <xiqi2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: <stable@vger.kernel.org>
[ sashal: Adjusted the comment to name move_freepages_block_isolate() instead of pageblock_isolate_and_move_free_pages(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_isolation.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 702db2e28a77c..b5ceebc8e7447 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -376,13 +376,19 @@ static int isolate_single_pageblock(unsigned long boundary_pfn, int flags,
 		}
 
 		if (PageBuddy(page)) {
-			int order = buddy_order(page);
+			unsigned int order = buddy_order_unsafe(page);
 
-			/* move_freepages_block_isolate() handled this */
-			VM_WARN_ON_ONCE(pfn + (1 << order) > boundary_pfn);
-
-			pfn += 1UL << order;
-			continue;
+			/* buddy_order_unsafe() is racy. Validate the order before shifting. */
+			if (order <= MAX_PAGE_ORDER &&
+				/*
+				 * move_freepages_block_isolate() splits
+				 * cross-boundary PageBuddy, verify it.
+				 */
+			    pfn + (1UL << order) <= boundary_pfn) {
+				pfn += 1UL << order;
+				continue;
+			}
+			goto failed;
 		}
 
 		/*
-- 
2.53.0



