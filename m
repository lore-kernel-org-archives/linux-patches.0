Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9247E1EE003;
	Wed,  6 Nov 2024 12:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897185; cv=none; b=ROWoYyEVmsd9IN3Y/ca9CfHfRwinGZvy1omI4u5El0uKosmjXBJylU7sOqsdCzLv2R7jOfhCo4ygMRUk4nLApoFbkZk81d/4z3FQFdAHpymcQ+b82gB5INzGk/npChzaQmVyDpWKPFDqvkan17e1l31pVuJJJJn6VEvAG15Jzcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897185; c=relaxed/simple;
	bh=wUsOnw+zi2XAqKlwnGmU9LlwIDtjE0RfdyBrOI19Z9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fi5ZEguCgWhvn6eFaUY1pqOAt+kWL9faEjRIwUrt9fWqt5G6kGxwNJ6TmHVkQFl0pr99DAc8lQCC8SNGVyWWJ/7mMiao/MpFijlALeJGoR/eKRD0uTdjtNeX6dfw+zKQL/iU2oSyzR8uPtvuZagbQeApal+z+OyfKI0t2temC/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MdgctKfL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MdgctKfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167D1C4CECD;
	Wed,  6 Nov 2024 12:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897185;
	bh=wUsOnw+zi2XAqKlwnGmU9LlwIDtjE0RfdyBrOI19Z9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MdgctKfLcAjXj7SUpPb6UcD8mEl779ih81c6XT/C1HU/Xi/S4hkpXZ/mVaSx0Yi0I
	 EieoTkLp+2J0SjmKb/f7zalTKePeNAISZIg4soVRXLH0wrG8dPVu5ylUUy8cmt+gIt
	 KHu/yODNItwK8B95lPocUYbrONiCAqZxcD6tl/XY=
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
Subject: [PATCH 6.1 095/126] mm/page_alloc: let GFP_ATOMIC order-0 allocs access highatomic reserves
Date: Wed,  6 Nov 2024 13:04:56 +0100
Message-ID: <20241106120308.635618691@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 49dc4ba88c278..b87b350b2f405 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3719,12 +3719,12 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
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



