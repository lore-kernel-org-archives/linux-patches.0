Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56060E54A
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F34C433D2;
	Thu,  1 Jun 2023 13:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685625887;
	bh=8N0MHEFgnhJt6rB7dl2xdWtXJ5dtl4GVX2AQ6iZGt0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5iH4UH/1HFBPvDmVmh9tjd5t8T2i3R5f4cPuhlrRDrv500Kv2sz0CE8tSXjB1vv5
	 niXPDdDnLAjMHh/k//eruflk/V9uIE/IquKZ/4PKGv6W8WpSDsXyjtc42WMPBgS23S
	 5TNCkxJ5h5SG4M89W7/GcIbicZ5kVssxWwg40mzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang DENG <qingfang.deng@siflower.com.cn>,
	Felix Fietkau <nbd@nbd.name>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 32/42] net: page_pool: use in_softirq() instead
Date: Thu,  1 Jun 2023 14:21:19 +0100
Message-Id: <20230601131938.155562715@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131936.699199833@linuxfoundation.org>
References: <20230601131936.699199833@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qingfang DENG <qingfang.deng@siflower.com.cn>

[ Upstream commit 542bcea4be866b14b3a5c8e90773329066656c43 ]

We use BH context only for synchronization, so we don't care if it's
actually serving softirq or not.

As a side node, in case of threaded NAPI, in_serving_softirq() will
return false because it's in process context with BH off, making
page_pool_recycle_in_cache() unreachable.

Signed-off-by: Qingfang DENG <qingfang.deng@siflower.com.cn>
Tested-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 368d3cb406cd ("page_pool: fix inconsistency for page_pool_ring_[un]lock()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/page_pool.h | 4 ++--
 net/core/page_pool.c    | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index a4082406a0039..80d987419436e 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -285,7 +285,7 @@ static inline void page_pool_nid_changed(struct page_pool *pool, int new_nid)
 static inline void page_pool_ring_lock(struct page_pool *pool)
 	__acquires(&pool->ring.producer_lock)
 {
-	if (in_serving_softirq())
+	if (in_softirq())
 		spin_lock(&pool->ring.producer_lock);
 	else
 		spin_lock_bh(&pool->ring.producer_lock);
@@ -294,7 +294,7 @@ static inline void page_pool_ring_lock(struct page_pool *pool)
 static inline void page_pool_ring_unlock(struct page_pool *pool)
 	__releases(&pool->ring.producer_lock)
 {
-	if (in_serving_softirq())
+	if (in_softirq())
 		spin_unlock(&pool->ring.producer_lock);
 	else
 		spin_unlock_bh(&pool->ring.producer_lock);
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 1a6978427d6c8..1d520fa1b98a8 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -390,8 +390,8 @@ static void page_pool_return_page(struct page_pool *pool, struct page *page)
 static bool page_pool_recycle_in_ring(struct page_pool *pool, struct page *page)
 {
 	int ret;
-	/* BH protection not needed if current is serving softirq */
-	if (in_serving_softirq())
+	/* BH protection not needed if current is softirq */
+	if (in_softirq())
 		ret = ptr_ring_produce(&pool->ring, page);
 	else
 		ret = ptr_ring_produce_bh(&pool->ring, page);
@@ -446,7 +446,7 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
 			page_pool_dma_sync_for_device(pool, page,
 						      dma_sync_size);
 
-		if (allow_direct && in_serving_softirq() &&
+		if (allow_direct && in_softirq() &&
 		    page_pool_recycle_in_cache(page, pool))
 			return NULL;
 
-- 
2.39.2



