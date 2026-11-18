Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038574;
	b=xMZ722CczJ5WwXZ/HdDVNOd1M21f4MS5daeHm4OdRmPXg7YJqtTViy4j4Uw+WjbyUypW
	 QKHF4p4TTLClMLEYh1EQJK0WVnZQNKoZPoZNlOGVirtdAp19MdIp7IS8NezneA/Jr4PTp
	 nV9C74LGsE7zw+ZhamJQ7iYspe72wbvdhMuJDUZONkUmwlE+oUuxTOk/S/G6ttqO8evDR
	 RUhyduI3RleYZJjn5xReGwoY8tdO+MS92dxrI4hsIpp5YPYTxjv1nrj4n+e41HDGX383x
	 rqI+2RFPatlw8XTFFthrOStEQseQfzGZOwf1CBUFKKTNLR/Kmi87R+djw6x2SkfPwWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038574;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WoDW2L8ZjO2vSjle95FJP2a4ABaFRe+G4rvRj0Wkl2o=;
	b=K2RifwNjEJw870Od4lzlv1CVG1wIjZN+upRHI6QthdU7taZTFpPh9n+PTEPrP8fXRN0A
	 7+3a3mwQctjGqp31dHReI5UpUk0/j+yBrshvZfOQcsqeq1V2URhiv0fxB8Sejp7LJJ8Uj
	 BVJi3bGz2w74A49kB5VSBYr0fAfNYUcH1R17EZnmqSvxCR9V2tMcmEDwcxH8xZ1gxPq6u
	 N1tqxwQv+XkMUP8DFmcJMxRqlB7g9ymxIPYSVmIVtLJzxMrR8GX7FQZSjMZvEv7SU2d00
	 Z8hvG9zUpjJkngn3xVSCTRfwLyovDxEXVPXTelI/6WzBtQaCxghOzrAAhohnq0hFcsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="c/FfMccb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64FA606A31C;
	Wed, 18 Nov 2026 21:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c/FfMccb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1786F1F000C5;
	Wed, 18 Nov 2026 21:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038573;
	bh=WoDW2L8ZjO2vSjle95FJP2a4ABaFRe+G4rvRj0Wkl2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c/FfMccbQ29uVDM1JKDWh3QsjZ4aR/GObKWbmkVLtuIxrdcVydUtGGMtxlr1hRfYX
	 kjT7QFUYd014a4Lrn6fDDPu17IZUvnh0Slj9/1DNFA0utHDgkTSKJISX+FOyFp0K36
	 m0RUqL5HfMVJzjxADyxatM9HpLoyl+gIN2RbMKHg=
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
Subject: [PATCH 6.6 1792/3318] mm/page_isolation: fix UBSAN shift-out-of-bounds warning
Date: Wed, 18 Nov 2026 15:40:14 +0100
Message-ID: <20261118150415.618435450@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Retained split_free_page() with retry handling for blocks crossing pageblock boundaries instead of rejecting them. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_isolation.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index bcf99ba747a05..5b98147a13507 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -372,7 +372,11 @@ static int isolate_single_pageblock(unsigned long boundary_pfn, int flags,
 		 * always be in the range.
 		 */
 		if (PageBuddy(page)) {
-			int order = buddy_order(page);
+			unsigned int order = buddy_order_unsafe(page);
+
+			/* buddy_order_unsafe() is racy. Validate the order before shifting. */
+			if (order > MAX_ORDER)
+				goto failed;
 
 			if (pfn + (1UL << order) > boundary_pfn) {
 				/* free page changed before split, check it again */
-- 
2.53.0



