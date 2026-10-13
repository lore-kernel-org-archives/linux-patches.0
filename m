Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62794EC65A;
	Tue, 13 Oct 2026 12:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893751; cv=none; b=OjQWvCbtnH5+BOU78qll6Ypp0BFQ8W+Zvdgz7+yX4U4B6WYwFPAK3ASlTskjTKdhHjtaXzzNLGU7ePPuGELMsyB7ZCrQF4oiQA+12kvE13T4IAKMrqfARk4MuKQWXdQCH4kLH/lNn2QblhtjaSnWlrYEOwM1VHMiNFTAK0IDiKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893751; c=relaxed/simple;
	bh=yqiJAZ8JXaUDcqR5soIToNOb+gMR8eAHSsXeq9nZH/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bVTHUbrsoMvDipQ/fgLp294wV4fyRu1uWmMOnUl//XatQ2asaIhZHkeSeDiRTi/26FTJbqetVpTjtKnv4m6Ddzi6WOrrl9il/K4IEt1K5sg7M+9R4ZLORyJ87i8TzI+AwoUBz7U061je9a9gbgrVSnxdcopeYp1HFE5DsLnvT48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=viUZ5ikP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="viUZ5ikP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4646E1F000FF;
	Tue, 13 Oct 2026 12:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893749;
	bh=1vbHxBaRb4yFY9GcXVfCxGdvRQHiMhJ0P9SVGbyteNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=viUZ5ikPOZAJqkbUa6qqGyVU8c41gU6trZE5OD2VWzy6LQ6utjt9L6vx0XZEFFB1G
	 I3eeFntG0kO1RmhGUVN7C3aZdr6Ykgany/YedLv+AS5vkQj8zIHiilwDZ5cw/XeJpr
	 5y6aCawICdFtsAUAjOaMOwk0Q8JbmsxHLquj73A8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 329/621] xsk: provide sufficient space in pool->tx_descs
Date: Tue, 13 Oct 2026 13:35:24 +0200
Message-ID: <20261013112928.661000148@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 08c9a8e794b4694c100dafcb80e069e29ad81b64 ]

The temporary Tx descriptor array in an XSK buffer pool is currently
sized from the Tx ring of the socket that creates the pool.

This is insufficient for shared-UMEM Tx. A later socket may have a
larger Tx ring and submit a valid multi-buffer packet containing more
descriptors than the first socket's ring, while still remaining within
the device's xdp_zc_max_segs limit.

A packet-framed batch parser bounded by the temporary array cannot reach
the end-of-packet descriptor in that case. It leaves the packet on the
Tx ring and encounters the same packet on every subsequent attempt,
stalling Tx processing for that socket.

Size the temporary descriptor array to the larger of the first Tx ring
and the device's xdp_zc_max_segs capability. This keeps the array large
enough to inspect one maximum-sized valid packet. Larger shared Tx rings
do not require further resizing, as they can be processed over multiple
batches.

Following commit will actually address the data path side.

Fixes: d5581966040f ("xsk: support ZC Tx multi-buffer in batch API")
Reviewed-by: Jason Xing <kernelxing@tencent.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20260719135609.147823-4-maciej.fijalkowski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 72f2b4516faf ("xsk: reclaim invalid Tx descriptors in ZC batch path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xsk_buff_pool.h |  6 ++++--
 net/xdp/xsk.c               | 10 +++++++---
 net/xdp/xsk_buff_pool.c     | 12 ++++++++----
 3 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 10e564d85a90c..a5de5a9cb5ac4 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -107,12 +107,14 @@ struct xsk_buff_pool {
 
 /* AF_XDP core. */
 struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
-						struct xdp_umem *umem);
+						struct xdp_umem *umem,
+						u32 max_segs);
 int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
 		  u16 queue_id, u16 flags);
 int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_sock *umem_xs,
 			 struct net_device *dev, u16 queue_id);
-int xp_alloc_tx_descs(struct xsk_buff_pool *pool, struct xdp_sock *xs);
+int xp_alloc_tx_descs(struct xsk_buff_pool *pool, struct xdp_sock *xs,
+		      u32 max_segs);
 void xp_destroy(struct xsk_buff_pool *pool);
 void xp_get_pool(struct xsk_buff_pool *pool);
 bool xp_put_pool(struct xsk_buff_pool *pool);
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 16723610a52ef..5a0b156069da1 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -1442,7 +1442,8 @@ static int xsk_bind(struct socket *sock, struct sockaddr_unsized *addr, int addr
 			 * and/or device.
 			 */
 			xs->pool = xp_create_and_assign_umem(xs,
-							     umem_xs->umem);
+							     umem_xs->umem,
+							     dev->xdp_zc_max_segs);
 			if (!xs->pool) {
 				err = -ENOMEM;
 				sockfd_put(sock);
@@ -1474,7 +1475,8 @@ static int xsk_bind(struct socket *sock, struct sockaddr_unsized *addr, int addr
 			 * utilizes
 			 */
 			if (xs->tx && !xs->pool->tx_descs) {
-				err = xp_alloc_tx_descs(xs->pool, xs);
+				err = xp_alloc_tx_descs(xs->pool, xs,
+							dev->xdp_zc_max_segs);
 				if (err) {
 					xp_put_pool(xs->pool);
 					xs->pool = NULL;
@@ -1492,7 +1494,9 @@ static int xsk_bind(struct socket *sock, struct sockaddr_unsized *addr, int addr
 		goto out_unlock;
 	} else {
 		/* This xsk has its own umem. */
-		xs->pool = xp_create_and_assign_umem(xs, xs->umem);
+		xs->pool = xp_create_and_assign_umem(xs, xs->umem,
+						     dev->xdp_zc_max_segs);
+
 		if (!xs->pool) {
 			err = -ENOMEM;
 			goto out_unlock;
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 6e9c51b6b4302..ef13b1ef778c6 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -46,9 +46,12 @@ void xp_destroy(struct xsk_buff_pool *pool)
 	kvfree(pool);
 }
 
-int xp_alloc_tx_descs(struct xsk_buff_pool *pool, struct xdp_sock *xs)
+int xp_alloc_tx_descs(struct xsk_buff_pool *pool, struct xdp_sock *xs,
+		      u32 max_segs)
 {
-	pool->tx_descs = kvcalloc(xs->tx->nentries, sizeof(*pool->tx_descs),
+	u32 nentries = max(xs->tx->nentries, max_segs);
+
+	pool->tx_descs = kvcalloc(nentries, sizeof(*pool->tx_descs),
 				  GFP_KERNEL);
 	if (!pool->tx_descs)
 		return -ENOMEM;
@@ -57,7 +60,8 @@ int xp_alloc_tx_descs(struct xsk_buff_pool *pool, struct xdp_sock *xs)
 }
 
 struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
-						struct xdp_umem *umem)
+						struct xdp_umem *umem,
+						u32 max_segs)
 {
 	bool unaligned = umem->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG;
 	struct xsk_buff_pool *pool;
@@ -74,7 +78,7 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 		goto out;
 
 	if (xs->tx)
-		if (xp_alloc_tx_descs(pool, xs))
+		if (xp_alloc_tx_descs(pool, xs, max_segs))
 			goto out;
 
 	pool->chunk_mask = ~((u64)umem->chunk_size - 1);
-- 
2.53.0



