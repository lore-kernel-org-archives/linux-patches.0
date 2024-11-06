Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B731CCB5F;
	Wed,  6 Nov 2024 13:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899292; cv=none; b=dBZXMAeGB0BdbCHM0jDReWyutc6omlz9GhgoxSKuuoIn22szu/FCq9/wGb6lnuKNKP/S9nGKBYq1r8j0uDWYb9aIoXg9wNi4MvJd53OykJOWLk9vyqqzoTt6elF6UMLa/qbwDPqi5Fum9d1uFciWHe4Lqesh2+VKFjGnzTFm65o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899292; c=relaxed/simple;
	bh=5XiAO6yltwbxj2u/fguORInEodbqYkJ6rb8pCWh/tio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRKwH9Yoo85LzSkCWldeTyDUftB32orx+gcU+MgQSiXwq2zT3Xd4DM7FVYi7tlnxZXVrPtxXPuZ/WvvY7HMjnPBu0vfesIbcib6AaSQI1Nzhn8N8Jvmy9+Vofq5id8EMOKwDFOhxOxbD/wKgxHoKsgliRhFzsFyYDY687iuomv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hdv8Ozma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hdv8Ozma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DBEC4CECD;
	Wed,  6 Nov 2024 13:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899292;
	bh=5XiAO6yltwbxj2u/fguORInEodbqYkJ6rb8pCWh/tio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hdv8OzmaMO+YPLsvf06tV6WhBkzCrAafzExZzEwcma56JbIHPA8rdkkeYaan60+Bd
	 CI2l0sCYYjFkWEdTFgXtw4iyl1IHdAHA29zmGbDC8DYzVl5YKGX3ZKpxV09ggDpWSZ
	 Qa8muQfXnmanJJJHxF8aIyq0TdmBaQ/L7YMHAz9I=
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
Subject: [PATCH 5.15 64/73] mm/page_alloc: let GFP_ATOMIC order-0 allocs access highatomic reserves
Date: Wed,  6 Nov 2024 13:06:08 +0100
Message-ID: <20241106120301.862530583@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 404cee30dcc26..6a64a75184888 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3620,12 +3620,12 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
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



