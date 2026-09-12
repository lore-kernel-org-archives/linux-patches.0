Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC0034250E;
	Sat, 12 Sep 2026 15:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226260; cv=none; b=SDe5nkB02InSxWfddGBZby7EaTG8ShmvmnowMPtAkYZutaY8GStG0OQ3dt4lC1BlGKmWjj0r9s1XqPTB4zVFgFhOkRkHrWdC81BrkDnIPO7Pw/Az8DXMVl7m+lgZmI/Hx3jrF1PCXk6LhtbcGyel0KmeNgD6NXLmXMM8xsCHDYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226260; c=relaxed/simple;
	bh=70ByrvePGGNyFWYnegxRn0s99gfETwKHi5jg5/gQSrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBI2AwG/3ijD0aWFUzGthLeNpFUtA98LtNnZUQ+9Be4V8g3R5Ux8ZE9sKFpj03TVRgK+c17WDklsTxrfv8E/chYiKobg2JcbJr3fhPLEkG/fBsOcX6mrsV8gFQSYxGjVfA1zSp0j9OI207XEOAUhssdcIfAQrUvZHnl/R10sqz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bDJtaUf1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bDJtaUf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83991F000FF;
	Sat, 12 Sep 2026 15:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226259;
	bh=LjdwKtSvOozTPSVY0BlKw5+37FqqyKtv5ThZIjp506g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bDJtaUf1gszFIw+gQByGKuvKXTs+QsbSQx0JblqS47jneDDHmTYcqHNyKFk63+3H0
	 y+PMrLM4bNW/4fcM1gQuDcYUQyY238mHWIILK/QGPqzH9F9Hkdleejw2NILQAQpJhF
	 11YBagw0MEoyXFxUMXv7a9c0Ke4PBjctklaYGldo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1324/1424] xsk: Get rid of xdp_buff_xsk::orig_addr
Date: Sat, 12 Sep 2026 09:02:36 +0200
Message-ID: <20260912065636.909792551@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 97392fd7712c6..1bddbf543dc00 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -27,7 +27,6 @@ struct xdp_buff_xsk {
 	dma_addr_t dma;
 	dma_addr_t frame_dma;
 	struct xsk_buff_pool *pool;
-	u64 orig_addr;
 	struct list_head list_node;
 };
 
@@ -119,7 +118,6 @@ void xp_free(struct xdp_buff_xsk *xskb);
 static inline void xp_init_xskb_addr(struct xdp_buff_xsk *xskb, struct xsk_buff_pool *pool,
 				     u64 addr)
 {
-	xskb->orig_addr = addr;
 	xskb->xdp.data_hard_start = pool->addrs + addr + pool->headroom;
 }
 
@@ -224,14 +222,19 @@ static inline void xp_release(struct xdp_buff_xsk *xskb)
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
 
 #endif /* XSK_BUFF_POOL_H_ */
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index aed8338d591de..c10619ef2d3b0 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -142,7 +142,7 @@ static int __xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff_xsk *xskb, u32 len,
 	u64 addr;
 	int err;
 
-	addr = xp_get_handle(xskb);
+	addr = xp_get_handle(xskb, xskb->pool);
 	err = xskq_prod_reserve_desc(xs->rx, addr, len, flags);
 	if (err) {
 		xs->rx_queue_full++;
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index bb9dfbe419e7c..9dc809ed99270 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -424,8 +424,10 @@ static int xp_init_dma_info(struct xsk_buff_pool *pool, struct xsk_dma_map *dma_
 
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



