Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8469391512;
	Sat, 17 Oct 2026 16:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254603; cv=none; b=q5O5nd437G3uCAIv5qnDJ7rk56GwbS9SxRgRPliEIsV5otIATC3qwIRpg+NJ+6gW1MYjG8lKYP/oGjH/XjFAkWh/Grc3lDx7RfB18mOcxVOwXEr1Y7hHyqwcj9JrGnv6OaPIPPmomqrB4wGUObcwR3X+2jWzSJcDWCe2xFXrk8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254603; c=relaxed/simple;
	bh=HD4Mkj4OMLkzzcgin4sxaAFxOeNzgZxJlzB43CQPYDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbXVLFWHTmlqA7kclxwZJUE34GtpF9Aqa6laUBymM+dcpSCqzuEBfYHhxLQXmvW+zSwIM2uOK0mB2AQJ7Xi45ZwZ9iRKtg+gI0QfdpRVZNgETOmhcM/pFDoubSu1ZnfNjGZEbcyr9UpVXfnk/S1CpmM9swUtEU2EqVfizQJp0Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DW1coUHO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DW1coUHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA171F000C4;
	Sat, 17 Oct 2026 16:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254601;
	bh=6MZlJoaWRQevrn3f92N2JmDiaCEUA2OxVCGx67wN7EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DW1coUHOU3N7Wsre0X4tzRfQmn1edRD7LDCzRoU6wqEhcfCVR227AUL4T6GDN2JDL
	 bTgIwVDl5N740fTIE4fviRGFDXmTPFjO08Sn5WZw12dV43YUnbYCW5Ge2xRowDFOqi
	 qvmMeiJ3GpJS1NPqrQKz8LYHeLt58yqoEYWiqCyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 500/869] xsk: provide sufficient space in pool->tx_descs
Date: Sat, 17 Oct 2026 17:55:41 +0200
Message-ID: <20261017160049.928019984@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
 net/xdp/xsk_buff_pool.c     | 13 ++++++++-----
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 42e9058d85687..85e07a5a314b5 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -101,12 +101,14 @@ struct xsk_buff_pool {
 
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
index 7054f5fd7f03e..3442941285ec4 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -1317,7 +1317,8 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 			 * and/or device.
 			 */
 			xs->pool = xp_create_and_assign_umem(xs,
-							     umem_xs->umem);
+							     umem_xs->umem,
+							     dev->xdp_zc_max_segs);
 			if (!xs->pool) {
 				err = -ENOMEM;
 				sockfd_put(sock);
@@ -1349,7 +1350,8 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 			 * utilizes
 			 */
 			if (xs->tx && !xs->pool->tx_descs) {
-				err = xp_alloc_tx_descs(xs->pool, xs);
+				err = xp_alloc_tx_descs(xs->pool, xs,
+							dev->xdp_zc_max_segs);
 				if (err) {
 					xp_put_pool(xs->pool);
 					xs->pool = NULL;
@@ -1367,7 +1369,9 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
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
index a22cedd280cbb..dba014f72dc22 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -44,10 +44,12 @@ void xp_destroy(struct xsk_buff_pool *pool)
 	kvfree(pool);
 }
 
-int xp_alloc_tx_descs(struct xsk_buff_pool *pool, struct xdp_sock *xs)
+int xp_alloc_tx_descs(struct xsk_buff_pool *pool, struct xdp_sock *xs,
+		      u32 max_segs)
 {
-	pool->tx_descs = kvcalloc(xs->tx->nentries, sizeof(*pool->tx_descs),
-				  GFP_KERNEL);
+	u32 nentries = max(xs->tx->nentries, max_segs);
+
+	pool->tx_descs = kvcalloc(nentries, sizeof(*pool->tx_descs), GFP_KERNEL);
 	if (!pool->tx_descs)
 		return -ENOMEM;
 
@@ -55,7 +57,8 @@ int xp_alloc_tx_descs(struct xsk_buff_pool *pool, struct xdp_sock *xs)
 }
 
 struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
-						struct xdp_umem *umem)
+						struct xdp_umem *umem,
+						u32 max_segs)
 {
 	bool unaligned = umem->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG;
 	struct xsk_buff_pool *pool;
@@ -72,7 +75,7 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 		goto out;
 
 	if (xs->tx)
-		if (xp_alloc_tx_descs(pool, xs))
+		if (xp_alloc_tx_descs(pool, xs, max_segs))
 			goto out;
 
 	pool->chunk_mask = ~((u64)umem->chunk_size - 1);
-- 
2.53.0



