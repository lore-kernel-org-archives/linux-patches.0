Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F297DA7F;
	Wed,  6 Nov 2024 12:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896361; cv=none; b=PiaMmS2w/dR4D2TdYMjiez25fIukAnkUAZCdL42i+hE2EETsL45EAa1C7UZUhGFvsfZLEnw8VLaVlwNdzoPrn+U/UL4vHkpe5SLY+9O/ADNMeSdwMid84ks7obxBlqhynvE+hyT0fnlf/XBRFOCk83yL8qOygmHTBv0MGl7XoZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896361; c=relaxed/simple;
	bh=g9gw8P4YtUt6Jb3hUfIw7pqS0hzCblkIAuiTOZdRdaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RpqogDLiX35URKFvR1jajrbb4YMozKCKJJCuECWdlJMzjgxzqB7qiePzbY4QFdI61mWCPZAh9ArU84lblhluqJ6yiir6oIfpis23sCb1ogKTtFrq+6iqgCwP60ddrw/8KzShPuc3lWEy9dfrLWUf+kvgUvoODDlOfDu04SfDRYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O4nX0k38; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O4nX0k38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2545C4CECD;
	Wed,  6 Nov 2024 12:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896361;
	bh=g9gw8P4YtUt6Jb3hUfIw7pqS0hzCblkIAuiTOZdRdaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O4nX0k38N4Vha/41tulTjpR1COUeyps27nQhvQKiMtrckU+ThA0HcAMfXIN9Mi1QU
	 TaBxkqQxoNBY7UB+ACqncxV6jVbuiH8QQ0IdIjebEJvffqZg9dFxNJ6NjpYsBdS+Pw
	 U5bbbqYOPkGZABg3l0l1WY2NFaIeHXv6u1XTRuoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Fleming <mfleming@cloudflare.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mel Gorman <mgorman@techsingularity.net>,
	Michal Hocko <mhocko@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 176/245] mm/page_alloc: let GFP_ATOMIC order-0 allocs access highatomic reserves
Date: Wed,  6 Nov 2024 13:03:49 +0100
Message-ID: <20241106120323.570324244@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Fleming <mfleming@cloudflare.com>

[ Upstream commit 281dd25c1a018261a04d1b8bf41a0674000bfe38 ]

Under memory pressure it's possible for GFP_ATOMIC order-0 allocations to
fail even though free pages are available in the highatomic reserves.
GFP_ATOMIC allocations cannot trigger unreserve_highatomic_pageblock()
since it's only run from reclaim.

Given that such allocations will pass the watermarks in
__zone_watermark_unusable_free(), it makes sense to fallback to highatomic
reserves the same way that ALLOC_OOM can.

This fixes order-0 page allocation failures observed on Cloudflare's fleet
when handling network packets:

  kswapd1: page allocation failure: order:0, mode:0x820(GFP_ATOMIC),
  nodemask=(null),cpuset=/,mems_allowed=0-7
  CPU: 10 PID: 696 Comm: kswapd1 Kdump: loaded Tainted: G           O 6.6.43-CUSTOM #1
  Hardware name: MACHINE
  Call Trace:
   <IRQ>
   dump_stack_lvl+0x3c/0x50
   warn_alloc+0x13a/0x1c0
   __alloc_pages_slowpath.constprop.0+0xc9d/0xd10
   __alloc_pages+0x327/0x340
   __napi_alloc_skb+0x16d/0x1f0
   bnxt_rx_page_skb+0x96/0x1b0 [bnxt_en]
   bnxt_rx_pkt+0x201/0x15e0 [bnxt_en]
   __bnxt_poll_work+0x156/0x2b0 [bnxt_en]
   bnxt_poll+0xd9/0x1c0 [bnxt_en]
   __napi_poll+0x2b/0x1b0
   bpf_trampoline_6442524138+0x7d/0x1000
   __napi_poll+0x5/0x1b0
   net_rx_action+0x342/0x740
   handle_softirqs+0xcf/0x2b0
   irq_exit_rcu+0x6c/0x90
   sysvec_apic_timer_interrupt+0x72/0x90
   </IRQ>

[mfleming@cloudflare.com: update comment]
  Link: https://lkml.kernel.org/r/20241015125158.3597702-1-matt@readmodwrite.com
Link: https://lkml.kernel.org/r/20241011120737.3300370-1-matt@readmodwrite.com
Link: https://lore.kernel.org/all/CAGis_TWzSu=P7QJmjD58WWiu3zjMTVKSzdOwWE8ORaGytzWJwQ@mail.gmail.com/
Fixes: 1d91df85f399 ("mm/page_alloc: handle a missing case for memalloc_nocma_{save/restore} APIs")
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_alloc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 91ace8ca97e21..ec459522c2934 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2874,12 +2874,12 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			page = __rmqueue(zone, order, migratetype, alloc_flags);
 
 			/*
-			 * If the allocation fails, allow OOM handling access
-			 * to HIGHATOMIC reserves as failing now is worse than
-			 * failing a high-order atomic allocation in the
-			 * future.
+			 * If the allocation fails, allow OOM handling and
+			 * order-0 (atomic) allocs access to HIGHATOMIC
+			 * reserves as failing now is worse than failing a
+			 * high-order atomic allocation in the future.
 			 */
-			if (!page && (alloc_flags & ALLOC_OOM))
+			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
 				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
 
 			if (!page) {
-- 
2.43.0



