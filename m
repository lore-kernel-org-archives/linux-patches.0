Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1ECE3A0E85;
	Sat, 17 Oct 2026 16:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254917; cv=none; b=TfwIj5sPrVR1M7/yqzK9jzKzXS57+iOiJPbJMy33yxex0JTA+gIpuoHsdnrm38V5VO7s89BqkRS8IzbvjHPTTfFhrpjwY/Au5rxb2AIVQE4e+CarX/XDVKFI/lEdhau6gfzwfk1g8UuBBnoe8TAGsiQTQgEZxS01CCrf6otoX0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254917; c=relaxed/simple;
	bh=+GoKF6mGNfsHSI5TvmC4O7oBltPG97CzH2qXjPBUXKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1Ix0AA0TSGMTB96Td+pbdiYodP6/R/0KvkDkA6Dhlu5kEN0zaSPWNSLr0YfTpuvRdB4/wuBXe+S2qXvq7Z7ttwmJmpir3thU8xbjpx40TRO9d/XHvR7xitGoBsT75LjMNABaF3lzp0snECJMwtVAhQOY4Tc0ea1dZ0JCf0w0zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q5ePx2Qn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q5ePx2Qn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF791F000C5;
	Sat, 17 Oct 2026 16:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254915;
	bh=ZdbUR6YVS7ADBHOmwveqAOCXBmaoYaLDQz97VpccsqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q5ePx2QnCx+ugKivo6MPVsSkwD+YDrf5U/VfiknCpQLmaEeF0J4S8XsCSDldpPiMw
	 U40kN+QwykV4pSSXtapTFTPUTS7HNaINisZYg3zkuBgeH+hnNsYg8mIl2gJhIO6QqJ
	 dezKiegOv4U8O84xqkOxo83HkDfjCawM+glCCAHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 602/869] xsk: honor XDP_TX_METADATA in zero-copy path
Date: Sat, 17 Oct 2026 17:57:23 +0200
Message-ID: <20261017160052.478370889@linuxfoundation.org>
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

From: Stanislav Fomichev <sdf.kernel@gmail.com>

[ Upstream commit a6e4b9a6deb9362ef7a0706c70d674e92fe1411a ]

The zero-copy path reads TX metadata whenever the UMEM has metadata space,
even if the descriptor does not set XDP_TX_METADATA. Pass descriptor
options through the metadata helpers and ignore metadata unless the option
is set.

This does not fix the existing per-WQE metadata handling for mlx5 MPWQEs.
Only the descriptor that starts a session passes through
xsk_tx_metadata_request() and configures offload state shared by the batch.
Metadata on descriptors joining an open session is therefore not validated
and does not configure its requested offloads. In addition, a non-NULL
metadata pointer from such a descriptor is treated as a timestamp
completion request even when XDP_TXMD_FLAGS_TIMESTAMP is not set, so its
metadata union can be overwritten with an unrequested timestamp. Fixing
mixed metadata states within one MPWQE requires a separate change.

Fixes: 48eb03dd2630 ("xsk: Add TX timestamp and TX checksum offload support")
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Link: https://patch.msgid.link/20260819160535.1472459-3-sdf@fomichev.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c           | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c | 4 ++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c   | 4 +++-
 include/net/xdp_sock_drv.h                          | 6 +++---
 4 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index e4a4d930dd226..ae5aebfd6be10 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3002,7 +3002,8 @@ static void igc_xdp_xmit_zc(struct igc_ring *ring)
 		olinfo_status = xdp_desc.len << IGC_ADVTXD_PAYLEN_SHIFT;
 
 		dma = xsk_buff_raw_get_dma(pool, xdp_desc.addr);
-		meta = xsk_buff_get_metadata(pool, xdp_desc.addr);
+		meta = xsk_buff_get_metadata(pool, xdp_desc.addr,
+					     xdp_desc.options);
 		xsk_buff_raw_dma_sync_for_device(pool, dma, xdp_desc.len);
 		bi = &ring->tx_buffer_info[ntu];
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index a59199ed590da..0cc1d40c40b75 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -97,7 +97,7 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 		xdptxd.dma_addr = xsk_buff_raw_get_dma(pool, desc.addr);
 		xdptxd.data = xsk_buff_raw_get_data(pool, desc.addr);
 		xdptxd.len = desc.len;
-		meta = xsk_buff_get_metadata(pool, desc.addr);
+		meta = xsk_buff_get_metadata(pool, desc.addr, desc.options);
 
 		xsk_buff_raw_dma_sync_for_device(pool, xdptxd.dma_addr, xdptxd.len);
 
@@ -112,7 +112,7 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 		} else {
 			mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, xdpi);
 			if (xp_tx_metadata_enabled(sq->xsk_pool)) {
-				struct xsk_tx_metadata_compl compl;
+				struct xsk_tx_metadata_compl compl = {};
 
 				xsk_tx_metadata_to_compl(meta, &compl);
 				XSK_TX_COMPL_FITS(void *);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index dfab95896adde..73f079a7cb537 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2521,7 +2521,8 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 			tx_desc = tx_q->dma_tx + entry;
 
 		dma_addr = xsk_buff_raw_get_dma(pool, xdp_desc.addr);
-		meta = xsk_buff_get_metadata(pool, xdp_desc.addr);
+		meta = xsk_buff_get_metadata(pool, xdp_desc.addr,
+					     xdp_desc.options);
 		xsk_buff_raw_dma_sync_for_device(pool, dma_addr, xdp_desc.len);
 
 		tx_q->tx_skbuff_dma[entry].buf_type = STMMAC_TXBUF_T_XSK_TX;
@@ -2566,6 +2567,7 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 
 		stmmac_enable_dma_transmission(priv, priv->ioaddr, queue);
 
+		tx_q->tx_skbuff_dma[entry].xsk_meta.tx_timestamp = NULL;
 		xsk_tx_metadata_to_compl(meta,
 					 &tx_q->tx_skbuff_dma[entry].xsk_meta);
 
diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 8d254e4b35716..71e219a749747 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -232,11 +232,11 @@ xsk_buff_valid_tx_metadata(const struct xsk_tx_metadata *meta)
 	return !(meta->flags & ~XDP_TXMD_FLAGS_VALID);
 }
 
-static inline struct xsk_tx_metadata *xsk_buff_get_metadata(struct xsk_buff_pool *pool, u64 addr)
+static inline struct xsk_tx_metadata *xsk_buff_get_metadata(struct xsk_buff_pool *pool, u64 addr, u32 options)
 {
 	struct xsk_tx_metadata *meta;
 
-	if (!pool->tx_metadata_len)
+	if (!pool->tx_metadata_len || !(options & XDP_TX_METADATA))
 		return NULL;
 
 	meta = xp_raw_get_data(pool, addr) - pool->tx_metadata_len;
@@ -426,7 +426,7 @@ static inline bool xsk_buff_valid_tx_metadata(struct xsk_tx_metadata *meta)
 	return false;
 }
 
-static inline struct xsk_tx_metadata *xsk_buff_get_metadata(struct xsk_buff_pool *pool, u64 addr)
+static inline struct xsk_tx_metadata *xsk_buff_get_metadata(struct xsk_buff_pool *pool, u64 addr, u32 options)
 {
 	return NULL;
 }
-- 
2.53.0



