Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216C34B0492;
	Mon, 17 Aug 2026 13:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974080; cv=none; b=E3Fl8Dfb5SKD+JNSNUoYi6Qru6F1U0b4G/GCqNNB127GIfZSPbXPo9p3Jx/XpiIjFS0Il4LP0ORWSaiZ3mvYWe7U3V2EHx/wxaVUFqJBDQzIWYnR+Xl6obW5z7H/PoqSka2k2h0gFMQjrImS/PiWveuV84jKmZJ9JDzr10QKnbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974080; c=relaxed/simple;
	bh=iiFVrhKJhGLXLTUx9ETQ8I7x2ue6xrkMKojTdzF1klM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V7+yoozUcQzvRSQ/TnjNcVFxNWF8IIQl4zWau4sD4Kl1CkOnzi59zo06Om8X0CAF7VP+sTelWfoJrSQwP+Z6OUtYJOiQiVgG08jdEary8Qs+fFSDV7vTv2jqLkYAxpsPnaMdAh73r0KbMig5te2zKx+b5DEOmEF5i4f+5kTc5Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fGycVP2R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fGycVP2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5B91F00A3A;
	Mon, 17 Aug 2026 13:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974072;
	bh=dcSavmwTb3ClfNOXwqSCT2Z2FGBg5iZ1dkSBhx1zQGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fGycVP2RLSmimTnwo0wnuxwQQUblA02g+KpLV2DC5jW0FCeqdcoCbDD2juTxyidQt
	 8piOd1BaEE6fFy8Jsqf6+taWtSj1sbj6onZiv25WrRwa+nVal7j2eJU8qimOxpOmxe
	 pPkuIH/45PXLHwCKrPI7H0XNcZQZ3bi35RJJa3NE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 077/271] xsk: validate metadata when processing requests
Date: Mon, 17 Aug 2026 15:30:02 +0200
Message-ID: <20260817132539.912107532@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

From: Stanislav Fomichev <sdf.kernel@gmail.com>

[ Upstream commit 849b1664dbda1cf6c63e0fd4f9dec23782b8c851 ]

The zero-copy path validates TX metadata while obtaining the descriptor
context, then reads it again later when preparing the hardware request.
User space can change the metadata between those operations and bypass the
original validation.

Validate the metadata in xsk_tx_metadata_request() and use the resulting
flags snapshot for every feature check. Read request fields once so all
zero-copy drivers process only values observed after successful
validation.

Fixes: ca4419f15abd ("xsk: Add launch time hardware offload support to XDP Tx metadata")
Cc: Cen Zhang (Microsoft) <blbllhy@gmail.com>
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20260727161959.885642-7-sdf@fomichev.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c     |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  5 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  4 +-
 include/net/libeth/xsk.h                      |  2 +-
 include/net/xdp_sock_drv.h                    | 51 ++++++++++---------
 net/xdp/xsk_buff_pool.c                       |  6 +--
 6 files changed, 37 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 13ddf6cc52eea..6525ecb666e4c 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3082,7 +3082,7 @@ static void igc_xdp_xmit_zc(struct igc_ring *ring)
 		meta_req.tx_buffer = bi;
 		meta_req.meta = meta;
 		meta_req.used_desc = 0;
-		xsk_tx_metadata_request(&meta, &igc_xsk_tx_metadata_ops,
+		xsk_tx_metadata_request(pool, &meta, &igc_xsk_tx_metadata_ops,
 					&meta_req);
 
 		/* xsk_tx_metadata_request() may have updated next_to_use */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index dac5e9d4c8bdb..77ea51bfbaae5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -505,7 +505,7 @@ mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptx
 		 */
 		mlx5e_xdp_mpwqe_session_start(sq);
 		if (meta)
-			xsk_tx_metadata_request(meta,
+			xsk_tx_metadata_request(sq->xsk_pool, meta,
 						&mlx5e_xsk_tx_metadata_ops,
 						&session->wqe->eth);
 	}
@@ -653,7 +653,8 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 	sq->pc += num_wqebbs;
 
 	if (meta)
-		xsk_tx_metadata_request(meta, &mlx5e_xsk_tx_metadata_ops, eseg);
+		xsk_tx_metadata_request(sq->xsk_pool, meta,
+					&mlx5e_xsk_tx_metadata_ops, eseg);
 
 	sq->doorbell_cseg = cseg;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 622f571b30350..b7e3f652501e4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2748,8 +2748,8 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 		meta_req.set_ic = &set_ic;
 		meta_req.tbs = tx_q->tbs;
 		meta_req.edesc = &tx_q->dma_entx[entry];
-		xsk_tx_metadata_request(&meta, &stmmac_xsk_tx_metadata_ops,
-					&meta_req);
+		xsk_tx_metadata_request(pool, &meta,
+					&stmmac_xsk_tx_metadata_ops, &meta_req);
 		if (set_ic) {
 			tx_q->tx_count_frames = 0;
 			stmmac_set_tx_ic(priv, tx_desc);
diff --git a/include/net/libeth/xsk.h b/include/net/libeth/xsk.h
index e2fa6bf6b1b31..5dcc0d7f65b76 100644
--- a/include/net/libeth/xsk.h
+++ b/include/net/libeth/xsk.h
@@ -205,7 +205,7 @@ __libeth_xsk_xmit_fill_buf_md(const struct xdp_desc *xdesc,
 	BUILD_BUG_ON(!__builtin_constant_p(tmo == libeth_xsktmo));
 	tmo = tmo == libeth_xsktmo ? &__libeth_xsktmo : tmo;
 
-	xsk_tx_metadata_request(&ctx.meta, tmo, &desc);
+	xsk_tx_metadata_request(sq->pool, &ctx.meta, tmo, &desc);
 
 	return desc;
 }
diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index f87c4215673ed..b344789f5df83 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -245,7 +245,7 @@ static inline void *xsk_buff_raw_get_data(struct xsk_buff_pool *pool, u64 addr)
  * details.
  *
  * Return: new &xdp_desc_ctx struct containing desc's DMA address and metadata
- * pointer, if it is present and valid (initialized to %NULL otherwise).
+ * pointer, if it is present (initialized to %NULL otherwise).
  */
 static inline struct xdp_desc_ctx
 xsk_buff_raw_get_ctx(const struct xsk_buff_pool *pool, u64 addr)
@@ -274,54 +274,56 @@ xsk_buff_valid_tx_metadata(const struct xsk_buff_pool *pool,
 /**
  *  xsk_tx_metadata_request - Evaluate AF_XDP TX metadata at submission
  *  and call appropriate xsk_tx_metadata_ops operation.
+ *  @pool: pointer to AF_XDP buffer pool, used to validate the metadata
  *  @pmeta: pointer to pointer to AF_XDP metadata area
  *  @ops: pointer to struct xsk_tx_metadata_ops
- *  @priv: pointer to driver-private aread
+ *  @priv: pointer to driver-private area
  *
  *  This function should be called by the networking device when
  *  it prepares AF_XDP egress packet.
  */
-static inline void xsk_tx_metadata_request(struct xsk_tx_metadata **pmeta,
-					   const struct xsk_tx_metadata_ops *ops,
-					   void *priv)
+static inline void
+xsk_tx_metadata_request(const struct xsk_buff_pool *pool,
+			struct xsk_tx_metadata **pmeta,
+			const struct xsk_tx_metadata_ops *ops, void *priv)
 {
 	const struct xsk_tx_metadata *meta = *pmeta;
+	u64 flags;
 
 	if (!meta)
 		return;
 
+	if (unlikely(!xsk_buff_valid_tx_metadata(pool, meta, &flags))) {
+		*pmeta = NULL;
+		return; /* no way to signal the error to the user */
+	}
+
 	if (ops->tmo_request_launch_time)
-		if (meta->flags & XDP_TXMD_FLAGS_LAUNCH_TIME)
-			ops->tmo_request_launch_time(meta->request.launch_time,
-						     priv);
+		if (flags & XDP_TXMD_FLAGS_LAUNCH_TIME)
+			ops->tmo_request_launch_time(
+				READ_ONCE(meta->request.launch_time), priv);
 
 	if (ops->tmo_request_timestamp)
-		if (meta->flags & XDP_TXMD_FLAGS_TIMESTAMP)
+		if (flags & XDP_TXMD_FLAGS_TIMESTAMP)
 			ops->tmo_request_timestamp(priv);
 
 	if (ops->tmo_request_checksum)
-		if (meta->flags & XDP_TXMD_FLAGS_CHECKSUM)
-			ops->tmo_request_checksum(meta->request.csum_start,
-						  meta->request.csum_offset, priv);
+		if (flags & XDP_TXMD_FLAGS_CHECKSUM)
+			ops->tmo_request_checksum(
+				READ_ONCE(meta->request.csum_start),
+				READ_ONCE(meta->request.csum_offset), priv);
 
-	if (!(meta->flags & XDP_TXMD_FLAGS_TIMESTAMP))
+	if (!(flags & XDP_TXMD_FLAGS_TIMESTAMP))
 		*pmeta = NULL;
 }
 
 static inline struct xsk_tx_metadata *
 __xsk_buff_get_metadata(const struct xsk_buff_pool *pool, void *data)
 {
-	struct xsk_tx_metadata *meta;
-	u64 flags;
-
 	if (!pool->tx_metadata_len)
 		return NULL;
 
-	meta = data - pool->tx_metadata_len;
-	if (unlikely(!xsk_buff_valid_tx_metadata(pool, meta, &flags)))
-		return NULL; /* no way to signal the error to the user */
-
-	return meta;
+	return data - pool->tx_metadata_len;
 }
 
 static inline struct xsk_tx_metadata *
@@ -520,9 +522,10 @@ xsk_buff_valid_tx_metadata(const struct xsk_buff_pool *pool,
 	return false;
 }
 
-static inline void xsk_tx_metadata_request(struct xsk_tx_metadata **pmeta,
-					   const struct xsk_tx_metadata_ops *ops,
-					   void *priv)
+static inline void
+xsk_tx_metadata_request(const struct xsk_buff_pool *pool,
+			struct xsk_tx_metadata **pmeta,
+			const struct xsk_tx_metadata_ops *ops, void *priv)
 {
 }
 
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 4538223f44082..f720422607771 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -765,11 +765,11 @@ EXPORT_SYMBOL(xp_raw_get_dma);
  * @addr: desc address (from userspace)
  *
  * Helper for getting desc's DMA address and metadata pointer, if present.
- * Saves one call on hotpath, double calculation of the actual address,
- * and inline checks for metadata presence and sanity.
+ * Saves one call on hotpath and double calculation of the actual address.
+ * Metadata is validated later by xsk_tx_metadata_request().
  *
  * Return: new &xdp_desc_ctx struct containing desc's DMA address and metadata
- * pointer, if it is present and valid (initialized to %NULL otherwise).
+ * pointer, if it is present (initialized to %NULL otherwise).
  */
 struct xdp_desc_ctx xp_raw_get_ctx(const struct xsk_buff_pool *pool, u64 addr)
 {
-- 
2.53.0



