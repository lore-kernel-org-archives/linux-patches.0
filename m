Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26AD339387;
	Fri,  7 Aug 2026 15:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116873; cv=none; b=uEc2K9d6a3e7Kh/WfO2t+Aje1MJenSuyMvM3I1meeLR85UECOUDu5RCRLslesmP6Jx3jR11JCJQAVGPTFuQKf0sAqaO1dIWDi0RxBp/jDKhMk6fRX5vLVKu8R18O4kOgbNjwhBmae5pwHYX7mrFnO1YSwsAax5+QGc0m3NkbFxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116873; c=relaxed/simple;
	bh=3GOXiM0oKEPbiCtqv1K/CWEHucMMXK06Adw5kZ5k818=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fn2GytXtc9ZcRwoxgTXrXJ8SP46GQVpIJXXOpcCRnq+ztw687dIUufb7yb3dVf0Mddb6YSba0Mxp22YRqcGidYWrvblKqKzcgANe1Lkg5/lWfRtLlGBHfzkkizsFwNBD51xhoNrp1+IK7ntPB/NMbajSRZrnlsPrw3aQdlJcJzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cwV7Tysx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cwV7Tysx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242E91F00A3D;
	Fri,  7 Aug 2026 15:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116871;
	bh=2YlGWROLayWOSHUTsnE7T3dWPCHuav2UFwjudALjwvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cwV7TysxXTjCvXsuCzooeQo+0CjoCSy1RuDBzQISYmZPc6mKqriiuJQGXQwnfcG7M
	 zb5kH+LIj0ZMA/gP7sUOzBALIKQQ5SKSwv9IfFvKmEjQ9gU9tzmNoIX7yHNzFYRDQy
	 3txzA97PNLyOg52/PnfmHmsGypvd8LShys/5ABOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 075/438] xsk: provide sufficient space in pool->tx_descs
Date: Fri,  7 Aug 2026 16:34:31 +0200
Message-ID: <20260807143429.583215015@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xsk_buff_pool.h |  6 ++++--
 net/xdp/xsk.c               | 10 +++++++---
 net/xdp/xsk_buff_pool.c     | 12 ++++++++----
 3 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index ccb3b350001f2..f5e737a830559 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -102,12 +102,14 @@ struct xsk_buff_pool {
 
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
index 8dadc39ca81f3..161ec3d47f053 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -1524,7 +1524,8 @@ static int xsk_bind(struct socket *sock, struct sockaddr_unsized *addr, int addr
 			 * and/or device.
 			 */
 			xs->pool = xp_create_and_assign_umem(xs,
-							     umem_xs->umem);
+							     umem_xs->umem,
+							     dev->xdp_zc_max_segs);
 			if (!xs->pool) {
 				err = -ENOMEM;
 				sockfd_put(sock);
@@ -1556,7 +1557,8 @@ static int xsk_bind(struct socket *sock, struct sockaddr_unsized *addr, int addr
 			 * utilizes
 			 */
 			if (xs->tx && !xs->pool->tx_descs) {
-				err = xp_alloc_tx_descs(xs->pool, xs);
+				err = xp_alloc_tx_descs(xs->pool, xs,
+							dev->xdp_zc_max_segs);
 				if (err) {
 					xp_put_pool(xs->pool);
 					xs->pool = NULL;
@@ -1574,7 +1576,9 @@ static int xsk_bind(struct socket *sock, struct sockaddr_unsized *addr, int addr
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
index d981cfdd85357..419dc0ffbf7ef 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -42,9 +42,12 @@ void xp_destroy(struct xsk_buff_pool *pool)
 	kvfree(pool);
 }
 
-int xp_alloc_tx_descs(struct xsk_buff_pool *pool, struct xdp_sock *xs)
+int xp_alloc_tx_descs(struct xsk_buff_pool *pool, struct xdp_sock *xs,
+		      u32 max_segs)
 {
-	pool->tx_descs = kvzalloc_objs(*pool->tx_descs, xs->tx->nentries);
+	u32 nentries = max(xs->tx->nentries, max_segs);
+
+	pool->tx_descs = kvzalloc_objs(*pool->tx_descs, nentries);
 	if (!pool->tx_descs)
 		return -ENOMEM;
 
@@ -52,7 +55,8 @@ int xp_alloc_tx_descs(struct xsk_buff_pool *pool, struct xdp_sock *xs)
 }
 
 struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
-						struct xdp_umem *umem)
+						struct xdp_umem *umem,
+						u32 max_segs)
 {
 	bool unaligned = umem->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG;
 	struct xsk_buff_pool *pool;
@@ -69,7 +73,7 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 		goto out;
 
 	if (xs->tx)
-		if (xp_alloc_tx_descs(pool, xs))
+		if (xp_alloc_tx_descs(pool, xs, max_segs))
 			goto out;
 
 	pool->chunk_mask = ~((u64)umem->chunk_size - 1);
-- 
2.53.0



