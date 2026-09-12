Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D7D35F602;
	Sat, 12 Sep 2026 09:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203625; cv=none; b=GQAvVkO/ynJaGGEMjRd+SrUPtGzo02lwTbeNGL5vNiZBrBSDBlqdbmwPgSMEmvTMgT/E687SSorxYNd3Q97tyAYgC8zBs92nswXhAZ+LnYFJUsXpk9TLezV9I6uLwZDmmb/DZob0bdRCHnQve/QHcDHDnuwyNjet5H3/cQVtOI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203625; c=relaxed/simple;
	bh=9W5nc+6cckyvaJ3lBbUF5N1Q3Ia+wi9JHVFomYK53jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WSVUQB6YRR8K4Jo2bUSDODeLf3EKnkipdC/0k+nlY0Wg0Hyf/uy/GQPM89yDao1WV2U6kNv5zrAt/lE9hrP7OHfxWyb3PJjCHbzgJlFTscXhQ6+VB+M7MuapXWMLU5+Qci88zuZSivzkSlll2xUCizNNoql35vBzo6CIUTHhQP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tZwYozj0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tZwYozj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523CA1F000FF;
	Sat, 12 Sep 2026 09:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203624;
	bh=fmzjk8bf7hP5KjxLuis/u1bpk4m2CaUYN2pD8mz9VXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tZwYozj035oIOV9myQkm8erHo1gHQJhHOcsI+KILNrWOS6Nrn8yLRE/YJh+Hzv8zy
	 DJT7EzWawBG6qk1AKXxxj2GPNKJ9vsjvCbmIbw44EpJ5emviQCMVUzv5PCnqIiZrk9
	 lMPsPtsaKWeXA/7iSc6IQ/CdXvaMj7iIrF3NjbhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mina Almasry <almasrymina@google.com>,
	Jijie Shao <shaojijie@huawei.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1445/1815] net: page_pool: fix UAF in __page_pool_release_netmem_dma on xa_cmpxchg race
Date: Sat, 12 Sep 2026 08:53:15 +0200
Message-ID: <20260912065722.939112285@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jijie Shao <shaojijie@huawei.com>

[ Upstream commit 24ef02f934eeb48830cff6b739abc3c62b1d107b ]

This bug was discovered while testing the hns3 driver under channel
reconfiguration (`ethtool -L` / `ethtool -G`) with iperf3 traffic on
arm64. The race is intermittently triggered when page_pool_destroy()
runs page_pool_scrub() concurrently with page return via
page_pool_put_netmem() on a different CPU. A WARN in
page_pool_clear_pp_info() surfaced the dangling DMA index bits left
by the cmpxchg loser, which led to the investigation.

page_pool_scrub() iterates pool->dma_mapped via xa_for_each() with no
page ref held. __page_pool_release_netmem_dma() currently reads and
writes netmem fields (dma_addr, DMA index bits in pp_magic) after
xa_cmpxchg() returns. The unref path calls put_page() unconditionally
regardless of the cmpxchg outcome; when it loses the cmpxchg, it still
frees the page before the scrub winner finishes these netmem accesses,
so scrub touches a freed page -- a Use-After-Free.

Fix this by splitting the DMA release into two functions:

1. __page_pool_unmap_netmem_dma() caches dma_addr before xa_cmpxchg(),
   does the cmpxchg to remove the DMA mapping, and calls dma_unmap on
   the cached address. It never touches netmem fields after the cmpxchg,
   making it safe for the scrub path which holds no page ref.

2. __page_pool_release_netmem_dma() wraps the above and additionally
   clears dma_addr and DMA index bits in netmem fields. This is safe
   only when the caller holds a page ref, so it is used by the return
   path (page_pool_return_netmem).

The scrub path calls __page_pool_unmap_netmem_dma() directly; the return
path calls __page_pool_release_netmem_dma().

Fixes: ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them when destroying the pool")
Suggested-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://patch.msgid.link/20260807114830.344336-1-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/page_pool.c | 66 +++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 31 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 21dc4a9c8714d..50ee550fef73a 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -500,29 +500,40 @@ static int page_pool_register_dma_index(struct page_pool *pool,
 	return err;
 }
 
-static int page_pool_release_dma_index(struct page_pool *pool,
-				       netmem_ref netmem)
+static void __page_pool_unmap_netmem_dma(struct page_pool *pool,
+					 netmem_ref netmem)
 {
 	struct page *old, *page = netmem_to_page(netmem);
 	unsigned long id;
+	dma_addr_t dma;
 
-	if (unlikely(!PP_DMA_INDEX_BITS))
-		return 0;
-
-	id = netmem_get_dma_index(netmem);
-	if (!id)
-		return -1;
+	if (!pool->dma_map)
+		return;
 
-	if (in_softirq())
-		old = xa_cmpxchg(&pool->dma_mapped, id, page, NULL, 0);
-	else
-		old = xa_cmpxchg_bh(&pool->dma_mapped, id, page, NULL, 0);
-	if (old != page)
-		return -1;
+	/* Cache dma_addr before xa_cmpxchg. The scrub path holds no page ref;
+	 * the unref path calls put_page() regardless of cmpxchg outcome, so
+	 * after the cmpxchg we cannot safely touch netmem fields.
+	 */
+	dma = page_pool_get_dma_addr_netmem(netmem);
 
-	netmem_set_dma_index(netmem, 0);
+	if (likely(PP_DMA_INDEX_BITS)) {
+		id = netmem_get_dma_index(netmem);
+		if (!id)
+			return;
+
+		if (in_softirq())
+			old = xa_cmpxchg(&pool->dma_mapped,
+					 id, page, NULL, 0);
+		else
+			old = xa_cmpxchg_bh(&pool->dma_mapped,
+					    id, page, NULL, 0);
+		if (old != page)
+			return;
+	}
 
-	return 0;
+	dma_unmap_page_attrs(pool->p.dev, dma,
+			     PAGE_SIZE << pool->p.order, pool->p.dma_dir,
+			     DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING);
 }
 
 static bool page_pool_dma_map(struct page_pool *pool, netmem_ref netmem, gfp_t gfp)
@@ -728,24 +739,16 @@ void page_pool_clear_pp_info(netmem_ref netmem)
 static __always_inline void __page_pool_release_netmem_dma(struct page_pool *pool,
 							   netmem_ref netmem)
 {
-	dma_addr_t dma;
-
+	/* Caller must hold a page ref: __page_pool_unmap_netmem_dma() is
+	 * safe without a ref, but the field clears below require it.
+	 */
 	if (!pool->dma_map)
-		/* Always account for inflight pages, even if we didn't
-		 * map them
-		 */
 		return;
 
-	if (page_pool_release_dma_index(pool, netmem))
-		return;
-
-	dma = page_pool_get_dma_addr_netmem(netmem);
-
-	/* When page is unmapped, it cannot be returned to our pool */
-	dma_unmap_page_attrs(pool->p.dev, dma,
-			     PAGE_SIZE << pool->p.order, pool->p.dma_dir,
-			     DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING);
+	__page_pool_unmap_netmem_dma(pool, netmem);
 	page_pool_set_dma_addr_netmem(netmem, 0);
+	if (likely(PP_DMA_INDEX_BITS))
+		netmem_set_dma_index(netmem, 0);
 }
 
 /* Disconnects a page (from a page_pool).  API users can have a need
@@ -1171,8 +1174,9 @@ static void page_pool_scrub(struct page_pool *pool)
 				synchronize_net();
 		}
 
+		/* No page ref, dma-unmap only. */
 		xa_for_each(&pool->dma_mapped, id, ptr)
-			__page_pool_release_netmem_dma(pool, page_to_netmem((struct page *)ptr));
+			__page_pool_unmap_netmem_dma(pool, page_to_netmem((struct page *)ptr));
 	}
 
 	/* No more consumers should exist, but producers could still
-- 
2.53.0



