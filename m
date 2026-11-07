Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063151;
	b=GfTVk5RV4PNztM7N8G3CuOxaCWneFTdhNmcK7zJeppk8J4BzXxEPlddRBD2w82OhmP/I
	 gqK1ojb5l2d3b5hn/CyeuwwNKRLCXaBzWP2NuzUto2hnmijLVdByEVM9SWOpRY202wxOW
	 PbMbi3Dgqigi2eoT+HDMKdARnfCLuWuy21rBCoVXjnuN7JqTPxZYyam8VIvLsAZHnRLec
	 YSItkekXaOU0/qnLQkedPIPyb7swuvE28SYrpWROtY90GIP0cw1RLShCTirklCiWvRzM/
	 PAbj+KlO5gmb6AtbtnjszZ1d+eRCoOOIDhowlCQJGmGMSzPjkgLJv6LjkjuhA66kpQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063151;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gCfBofenEKJNhqE4n19dSj/AnjVzBzGIk2fA1hobfrY=;
	b=mPd16Akjq1uf2yN2B8D5EnzTZzlQONs7s2te2JVCf1AOz+5VrsU06h6OXWWDx5LrLMb3
	 GhGR2H6f0955+oVFRTwnE50v3+6vI9s/x6FTwhuSh637w/l/1b/GyT3m36uHvGkTVZ+XM
	 j+nTH0+QoHHc7f9g/Cb/wt5kXTjsV7eehkImlh1VdPrxHVEUSP67HE2RyXBMGV746vEQF
	 LKrO4aSPj2Kf2ckb8GkL/Q/8T5aZjIrqd4K3/zxPykG5ER1Hp4fqNG9IJlOUkCMLaYWR7
	 2hLrtMfZZlFK5sLl8CgHe4hAYDH3o4vA+f6DdPR53RBzIQnY48khHTxsISNWbPAgV8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mbkuiCky;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B954606A331;
	Sat,  7 Nov 2026 14:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mbkuiCky
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B9A1F0089F;
	Sat,  7 Nov 2026 14:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063151;
	bh=gCfBofenEKJNhqE4n19dSj/AnjVzBzGIk2fA1hobfrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mbkuiCkykl6uzaeKrJxzH9DM9R2R0mPpOpf1dol6nTNBHgK1E3oR23TYcXjGMB8jU
	 rWhdsIGanYxwEBp2QjcnGbVippiz8j3xxjUAWnHh7CB0LY2hD144u3NaKelGkKU/w2
	 zMI9fk6tHKAX6T8jqy/gyeWAWNyF/XF6d541SOs0=
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
Subject: [PATCH 6.18 376/869] mm/page_isolation: fix UBSAN shift-out-of-bounds warning
Date: Sat,  7 Nov 2026 08:50:58 -0500
Message-ID: <20261107134905.868910374@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_isolation.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index f72b6cd38b958..2ec974fa9726d 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -380,13 +380,19 @@ static int isolate_single_pageblock(unsigned long boundary_pfn,
 		}
 
 		if (PageBuddy(page)) {
-			int order = buddy_order(page);
+			unsigned int order = buddy_order_unsafe(page);
 
-			/* pageblock_isolate_and_move_free_pages() handled this */
-			VM_WARN_ON_ONCE(pfn + (1 << order) > boundary_pfn);
-
-			pfn += 1UL << order;
-			continue;
+			/* buddy_order_unsafe() is racy. Validate the order before shifting. */
+			if (order <= MAX_PAGE_ORDER &&
+				/*
+				 * pageblock_isolate_and_move_free_pages() splits
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



