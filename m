Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047145;
	b=M9NGqFMeTe86N8iM8js/u2lnnWOrTANbeUz1aOjEqXE+Rq0fwz+EJGhmCIXxfP966bEY
	 pdb856YQ4U6BTo0+FE2VwIHu6B+LA3ceITnfHQe+hrEufnyquvG0zM4zWrwk2vaVNwSCi
	 ja65QWv4zdbQ0af3sl1Z4BDEU2nQ7mVLcMqVGbx01F3azirO0w0+9uwQKMPQ4UKvhmH5k
	 ushCcBnwzIasXHsncdeboht4ek10mSh6Rq3FRhEeg8NMjhGTRZZgxury3ptlT37284HN/
	 di1vwjOKZqgueRxn8anRYTM4GolFNYg5It4PwzdKlZe8peD6UQ6wdGTp8eDRYOHsJfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047145;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FyTXTjZBX790EVWov6yh+ESQ3EiMqgybBdp1L2+mQxY=;
	b=JkrSklQMKkxBlup/ES/p3odSZRzkYMYR3hA3l2mNm1LdunpDH2KitL5pmzwnd7tLO1Sn
	 8rxzKSUp36IiJ/wYw05svshVW4xo2gfJ/abwCnLcezLk6kMBqWHe0Zd0V3anLwuzy3/P2
	 SiASK+/Ok2OWC/1iOsB7Y5pQV9WbqMcg7lUVazWDisvvJz69Yd1gckeEeUH7VkhjNNAQO
	 mt64znILcyikizDNfu/zB6Qeoaw3G9voXFocGqoGjzQ8vBbDjsl/GzYMjD+RfiUsBNs39
	 ECPVD+A4ghm/lfYmVktqvaNp/7Ft/eB8+hW52/d5RGbmP5nZxY/EL9+a6guiuTe/8fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ik0dhV08;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2C3606A320;
	Thu, 19 Nov 2026 00:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ik0dhV08
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C411F000C4;
	Thu, 19 Nov 2026 00:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047144;
	bh=FyTXTjZBX790EVWov6yh+ESQ3EiMqgybBdp1L2+mQxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ik0dhV08CPA8wUtq84oPmRFovAOYzA0O1t/r8lGgPWmYaDhULMP1IX39GSReszHo0
	 OBRvv/wKUhj6zUloqFajimkDepT0D61gRO2K1UKSbPYP8/lc0eEb7FY2gJ7hL5cjOf
	 KvoB/ak8yuFdgKzjG9wAB2bW8yM+59OSC0Vvz5CM=
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
Subject: [PATCH 6.1 1534/2857] mm/page_isolation: fix UBSAN shift-out-of-bounds warning
Date: Wed, 18 Nov 2026 15:42:48 +0100
Message-ID: <20261118150256.551667459@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted the order check to use MAX_ORDER while preserving existing boundary-split handling ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_isolation.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 47fbc1696466f..bf098a6d863c0 100644
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



