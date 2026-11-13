Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585599;
	b=g7szHRQ61VGkYOpja+Kf60saRFKSRREK9Vztu7qfc0TUGzXA/R7KpzGC2FKdH36owhZi
	 mfTpgJwBU3SfsN5ma4mgCQbcJJl+6Kv08NXp1bmP2AZt4KrKAi7tth97BwOCSGJgZLfyp
	 pwSXRtv0aC6A08Rl+egynfe4nSR7HvaN9Q96sf7TVxJK0Ff40bIE06DTMcX2Of5gaU/MA
	 3eq+xo82jzAVIRPU2jTN/LH6Nw0Wc14rIFtHfBfbzfJ5Du2wN74YeR+mM5jK/spR8ppoh
	 J+Ni4V5hqo95UufEfkXOlO/E1FHoEy+FlpQCJqceNlswkt6zp/RYtEJTAsbKbO8ZiOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e2AhNUbjPWm0bP5ubbLENoZCCjRjQSh8VYKJVApRsu4=;
	b=ezQ2TbgTs+fDda/RFQi9rziAngN4JU3kapMWPEh5yntFflwGVcX2r+JN5JMxZQzIXmsd
	 /7jb+HQgvMXKjtsPTp8ngCypJeelgVtzr+zDcjjLLP64oYOyA7+fVkQMt3geF9CcHQGul
	 d07ydJinHPyWxgqCxGC0PYmEf3UDyZ8nAnv/1JfCdFgUgg4DCkWVkHozkoVb2Qb7i1X64
	 uTYsDkdT+F/AK82iGrOEMpqxGlEXjY26PVXvTPVh8EPRMSWqSyV44bmsGM1h47fqwlms0
	 kvceYvK1KejiihMtQDa0Yfoh9cpN0+KcnuRIQZSTF4fflypEMVLvBg674/NTSuiBmeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K7wSXSiZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87101606FFEC;
	Fri, 13 Nov 2026 15:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K7wSXSiZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381BA1F000C4;
	Fri, 13 Nov 2026 15:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585599;
	bh=e2AhNUbjPWm0bP5ubbLENoZCCjRjQSh8VYKJVApRsu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K7wSXSiZhoG+QdN/b9N3MChnNEwA8fv7B0We6hwwe7CEbQ44lTKHGP37YleRrUvy6
	 lXC1pQWQVDsyh/ZYBTvZZzu6XZiF4mp8M3FR5rP1KiyY5ljk7C2ejp9dblkc1V3Qmy
	 +pDdenxklKMWjYagkNWBaco0XFzKR/n5J22EmtSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chanwon Park <flyinrm@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 225/507] mm/page_alloc: let the highest memory node recover from hopeless state
Date: Fri, 13 Nov 2026 10:48:49 -0500
Message-ID: <20261113153802.138002370@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory Price (Meta) <gourry@gourry.net>

[ Upstream commit 83367658a01087375ede31ae343c99da03f72ac8 ]

free_frozen_page_commit() clears a hopeless node's kswapd failures once
its zone recovers above the high watermark, but only if another memory
node exists for allocations to fall back to.

The test `next_memory_node(nid) < MAX_NUMNODES` finds only memory nodes
with a higher id.  The highest-numbered memory node therefore never
recovers on this path, and its kswapd stays disabled until reclaim on that
node makes progress and balances it, or demotion is re-enabled.

In many cases, direct reclaim many never fully run against a lower node
(CXL/kmem), and that means its kswapd can end up full disabled in rare
situations.

To reproduce, fill the highest memory node with bound, non-THP anonymous
memory and no swap until kswapd gives up, then free it: /proc/zoneinfo
keeps showing node_unreclaimable 1 for that node.  A lower node recovers.

Count the memory nodes instead.  Adding first_memory_node != nid to the
existing test would also work, but a count says directly what the check
means: some other memory node exists.

Link: https://lore.kernel.org/20261019184850.3427905-1-gourry@gourry.net
Fixes: e7a5f249e6db ("mm: re-enable kswapd when memory pressure subsides or demotion is toggled")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chanwon Park <flyinrm@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8ca2289d0491b..319053c6a9c0f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2947,7 +2947,7 @@ static bool free_frozen_page_commit(struct zone *zone,
 		 * kswapd work again by resetting kswapd_failures.
 		 */
 		if (kswapd_test_hopeless(pgdat) &&
-		    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
+		    num_node_state(N_MEMORY) > 1)
 			kswapd_clear_hopeless(pgdat, KSWAPD_CLEAR_HOPELESS_PCP);
 	}
 	return ret;
-- 
2.53.0



