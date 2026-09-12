Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A13F47CC78;
	Sat, 12 Sep 2026 13:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218928; cv=none; b=OnQwbu5w+Xt6H8pZSXn6tf3u9FV5i9vz8dTIuZOhRZ3TBVZQiowLK3oetlYoVV7D5Zk3yBu162geqSEkJRM8reErZnysGTWw/jhTVNYPc39SecaH36bWTAopKazJDE6tafv/AB5Oul+1KHBjuB8jRDqlxzoTQRBPyW3Rc9nGvhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218928; c=relaxed/simple;
	bh=FkQ+43qmHc+C3g07rOUre4IrK216P4QkOPIBlAz7cl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCZr+RIEiLwx0m1PlOxUEoDiEG+nOyL2xnXFJOcKaEapx/K2QtWxPVjrcIL9Eyt/e9bv16IKVl6L185+1cca80KWBSYf2mYDM2weEDDjxZli3FCwwHpdNMc7y4v1r/Yj6n5OkdI5LcsHZK53WQOCP8yEuc/Z9JSFFVpe59HE/hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2vYcLoH9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2vYcLoH9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2997D1F000FF;
	Sat, 12 Sep 2026 13:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218927;
	bh=RNKuLS7v/Mbho6Y/6T+/qwHsvDGKLZZUbmPkeJjOpAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2vYcLoH9ta/O42KSQLOT6d07QlYj3ApCgungeSz1TKQ0DfLvhK71cLlFH5IPxQa1X
	 tbG5/GfGV5nVjlTf/ZGsQPqSfo9p6i9E0KWC+oZnJ66xyN1TLsUf8rNkCD+Fi+WkLE
	 Ubb/uPoO4JoMZt9GtvQj1R6Q66opiD74ocwbKrog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1244/1376] xsk: Get rid of xdp_buff_xsk::orig_addr
Date: Sat, 12 Sep 2026 09:01:10 +0200
Message-ID: <20260912065635.270020700@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit bea14124bacbe5c9366381e62635eed28ac892ae ]

Continue the process of dieting xdp_buff_xsk by removing orig_addr
member. It can be calculated from xdp->data_hard_start where it was
previously used, so it is not anything that has to be carried around in
struct used widely in hot path.

This has been used for initializing xdp_buff_xsk::frame_dma during pool
setup and as a shortcut in xp_get_handle() to retrieve address provided
to xsk Rx queue.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/bpf/20241007122458.282590-4-maciej.fijalkowski@intel.com
Stable-dep-of: e37b2abca804 ("xsk: fix NULL pointer dereference in __xsk_rcv()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xsk_buff_pool.h | 19 +++++++++++--------
 net/xdp/xsk.c               |  2 +-
 net/xdp/xsk_buff_pool.c     |  4 +++-
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index e21062cf62294..0b6d6cd16e3b3 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -28,7 +28,6 @@ struct xdp_buff_xsk {
 	dma_addr_t dma;
 	dma_addr_t frame_dma;
 	struct xsk_buff_pool *pool;
-	u64 orig_addr;
 	struct list_head list_node;
 };
 
@@ -121,7 +120,6 @@ void xp_free(struct xdp_buff_xsk *xskb);
 static inline void xp_init_xskb_addr(struct xdp_buff_xsk *xskb, struct xsk_buff_pool *pool,
 				     u64 addr)
 {
-	xskb->orig_addr = addr;
 	xskb->xdp.data_hard_start = pool->addrs + addr + pool->headroom;
 }
 
@@ -223,14 +221,19 @@ static inline void xp_release(struct xdp_buff_xsk *xskb)
 		xskb->pool->free_heads[xskb->pool->free_heads_cnt++] = xskb;
 }
 
-static inline u64 xp_get_handle(struct xdp_buff_xsk *xskb)
+static inline u64 xp_get_handle(struct xdp_buff_xsk *xskb,
+				struct xsk_buff_pool *pool)
 {
-	u64 offset = xskb->xdp.data - xskb->xdp.data_hard_start;
+	u64 orig_addr = xskb->xdp.data - pool->addrs;
+	u64 offset;
 
-	offset += xskb->pool->headroom;
-	if (!xskb->pool->unaligned)
-		return xskb->orig_addr + offset;
-	return xskb->orig_addr + (offset << XSK_UNALIGNED_BUF_OFFSET_SHIFT);
+	if (!pool->unaligned)
+		return orig_addr;
+
+	offset = xskb->xdp.data - xskb->xdp.data_hard_start;
+	orig_addr -= offset;
+	offset += pool->headroom;
+	return orig_addr + (offset << XSK_UNALIGNED_BUF_OFFSET_SHIFT);
 }
 
 static inline bool xp_tx_metadata_enabled(const struct xsk_buff_pool *pool)
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 76675ce70f03d..c070b6db26d82 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -141,7 +141,7 @@ static int __xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff_xsk *xskb, u32 len,
 	u64 addr;
 	int err;
 
-	addr = xp_get_handle(xskb);
+	addr = xp_get_handle(xskb, xskb->pool);
 	err = xskq_prod_reserve_desc(xs->rx, addr, len, flags);
 	if (err) {
 		xs->rx_queue_full++;
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 04fe499f76782..a22cedd280cbb 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -442,8 +442,10 @@ static int xp_init_dma_info(struct xsk_buff_pool *pool, struct xsk_dma_map *dma_
 
 		for (i = 0; i < pool->heads_cnt; i++) {
 			struct xdp_buff_xsk *xskb = &pool->heads[i];
+			u64 orig_addr;
 
-			xp_init_xskb_dma(xskb, pool, dma_map->dma_pages, xskb->orig_addr);
+			orig_addr = xskb->xdp.data_hard_start - pool->addrs - pool->headroom;
+			xp_init_xskb_dma(xskb, pool, dma_map->dma_pages, orig_addr);
 		}
 	}
 
-- 
2.53.0



