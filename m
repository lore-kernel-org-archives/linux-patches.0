Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729E5271476;
	Tue, 27 May 2025 17:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365529; cv=none; b=gSF6uIbQwwk3AjWuIml6C+KQbnTE9XpV6zkSq5bsVZVZbsy9txTW68dxvWzHFGyYOG9R3/QeGTpedCLu+CWftk0A7QSkat3B/X6CIc0T7k+Yy70y/HVlhtnMMipTdtMKh4mdhMD3d1JU8FuOM97sZRHdByfkjP1OI/ebxISD7yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365529; c=relaxed/simple;
	bh=mFX86gMU7YZHRV7A8LTvPCd7tv3TNNrBnpInNTcwns4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0X0d+yLwfnkKNrBwctBbEaHqxkk3iFJDlYkvYEbNJRAZ597chWn9o1L3FNprvq/VhCLyAi4utionh60+n5qOB+8E2lU8+Q7dr5mo3OwFz8xH6oB5yVAiNWamO+Nxel/1tynbLw4tN3APHqt1dPbgul9AOesOldAhtDwymT068o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MzbBUwtL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MzbBUwtL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E65C4CEE9;
	Tue, 27 May 2025 17:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365529;
	bh=mFX86gMU7YZHRV7A8LTvPCd7tv3TNNrBnpInNTcwns4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MzbBUwtLF4xt3LjpZ5bPr9IDmEIJjWmwFovOQMTgECtxJo5JS2SA5oHxQ/fI1k2jq
	 A0/amuZyBR9tRLw+7JFbKfmzAmgZh7atbjc7f8zKEKLiBqWdhgj4eTo+wG+zDJCGRl
	 ABDG1UlMhoATsbEenuEPmjJJ1CcrfYMb/rgE09XY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Lazar <alazar@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 405/626] net/mlx5: XDP, Enable TX side XDP multi-buffer support
Date: Tue, 27 May 2025 18:24:58 +0200
Message-ID: <20250527162501.471698590@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alexei Lazar <alazar@nvidia.com>

[ Upstream commit 1a9304859b3a4119579524c293b902a8927180f3 ]

In XDP scenarios, fragmented packets can occur if the MTU is larger
than the page size, even when the packet size fits within the linear
part.
If XDP multi-buffer support is disabled, the fragmented part won't be
handled in the TX flow, leading to packet drops.

Since XDP multi-buffer support is always available, this commit removes
the conditional check for enabling it.
This ensures that XDP multi-buffer support is always enabled,
regardless of the `is_xdp_mb` parameter, and guarantees the handling of
fragmented packets in such scenarios.

Signed-off-by: Alexei Lazar <alazar@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20250209101716.112774-16-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 -
 .../ethernet/mellanox/mlx5/core/en/params.c   |  1 -
 .../ethernet/mellanox/mlx5/core/en/params.h   |  1 -
 .../mellanox/mlx5/core/en/reporter_tx.c       |  1 -
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 49 ++++++++-----------
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 29 -----------
 6 files changed, 21 insertions(+), 61 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 57b7298a0e793..d6266f6a96d6e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -385,7 +385,6 @@ enum {
 	MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE,
 	MLX5E_SQ_STATE_PENDING_XSK_TX,
 	MLX5E_SQ_STATE_PENDING_TLS_RX_RESYNC,
-	MLX5E_SQ_STATE_XDP_MULTIBUF,
 	MLX5E_NUM_SQ_STATES, /* Must be kept last */
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 31eb99f09c63c..8c4d710e85675 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -1242,7 +1242,6 @@ void mlx5e_build_xdpsq_param(struct mlx5_core_dev *mdev,
 	mlx5e_build_sq_param_common(mdev, param);
 	MLX5_SET(wq, wq, log_wq_sz, params->log_sq_size);
 	param->is_mpw = MLX5E_GET_PFLAG(params, MLX5E_PFLAG_XDP_TX_MPWQE);
-	param->is_xdp_mb = !mlx5e_rx_is_linear_skb(mdev, params, xsk);
 	mlx5e_build_tx_cq_param(mdev, params, &param->cqp);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index 3f8986f9d8629..bd5877acc5b1e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -33,7 +33,6 @@ struct mlx5e_sq_param {
 	struct mlx5_wq_param       wq;
 	bool                       is_mpw;
 	bool                       is_tls;
-	bool                       is_xdp_mb;
 	u16                        stop_room;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index c8adf309ecad0..dbd9482359e1e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -16,7 +16,6 @@ static const char * const sq_sw_state_type_name[] = {
 	[MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE] = "vlan_need_l2_inline",
 	[MLX5E_SQ_STATE_PENDING_XSK_TX] = "pending_xsk_tx",
 	[MLX5E_SQ_STATE_PENDING_TLS_RX_RESYNC] = "pending_tls_rx_resync",
-	[MLX5E_SQ_STATE_XDP_MULTIBUF] = "xdp_multibuf",
 };
 
 static int mlx5e_wait_for_sq_flush(struct mlx5e_txqsq *sq)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 4610621a340e5..08ab0999f7b31 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -546,6 +546,7 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 	bool inline_ok;
 	bool linear;
 	u16 pi;
+	int i;
 
 	struct mlx5e_xdpsq_stats *stats = sq->stats;
 
@@ -612,41 +613,33 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 
 	cseg->opmod_idx_opcode = cpu_to_be32((sq->pc << 8) | MLX5_OPCODE_SEND);
 
-	if (test_bit(MLX5E_SQ_STATE_XDP_MULTIBUF, &sq->state)) {
-		int i;
-
-		memset(&cseg->trailer, 0, sizeof(cseg->trailer));
-		memset(eseg, 0, sizeof(*eseg) - sizeof(eseg->trailer));
-
-		eseg->inline_hdr.sz = cpu_to_be16(inline_hdr_sz);
+	memset(&cseg->trailer, 0, sizeof(cseg->trailer));
+	memset(eseg, 0, sizeof(*eseg) - sizeof(eseg->trailer));
 
-		for (i = 0; i < num_frags; i++) {
-			skb_frag_t *frag = &xdptxdf->sinfo->frags[i];
-			dma_addr_t addr;
+	eseg->inline_hdr.sz = cpu_to_be16(inline_hdr_sz);
 
-			addr = xdptxdf->dma_arr ? xdptxdf->dma_arr[i] :
-				page_pool_get_dma_addr(skb_frag_page(frag)) +
-				skb_frag_off(frag);
+	for (i = 0; i < num_frags; i++) {
+		skb_frag_t *frag = &xdptxdf->sinfo->frags[i];
+		dma_addr_t addr;
 
-			dseg->addr = cpu_to_be64(addr);
-			dseg->byte_count = cpu_to_be32(skb_frag_size(frag));
-			dseg->lkey = sq->mkey_be;
-			dseg++;
-		}
+		addr = xdptxdf->dma_arr ? xdptxdf->dma_arr[i] :
+			page_pool_get_dma_addr(skb_frag_page(frag)) +
+			skb_frag_off(frag);
 
-		cseg->qpn_ds = cpu_to_be32((sq->sqn << 8) | ds_cnt);
+		dseg->addr = cpu_to_be64(addr);
+		dseg->byte_count = cpu_to_be32(skb_frag_size(frag));
+		dseg->lkey = sq->mkey_be;
+		dseg++;
+	}
 
-		sq->db.wqe_info[pi] = (struct mlx5e_xdp_wqe_info) {
-			.num_wqebbs = num_wqebbs,
-			.num_pkts = 1,
-		};
+	cseg->qpn_ds = cpu_to_be32((sq->sqn << 8) | ds_cnt);
 
-		sq->pc += num_wqebbs;
-	} else {
-		cseg->fm_ce_se = 0;
+	sq->db.wqe_info[pi] = (struct mlx5e_xdp_wqe_info) {
+		.num_wqebbs = num_wqebbs,
+		.num_pkts = 1,
+	};
 
-		sq->pc++;
-	}
+	sq->pc += num_wqebbs;
 
 	xsk_tx_metadata_request(meta, &mlx5e_xsk_tx_metadata_ops, eseg);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3e9ad3cb8121d..38055537b12ac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2030,41 +2030,12 @@ int mlx5e_open_xdpsq(struct mlx5e_channel *c, struct mlx5e_params *params,
 	csp.min_inline_mode = sq->min_inline_mode;
 	set_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
 
-	if (param->is_xdp_mb)
-		set_bit(MLX5E_SQ_STATE_XDP_MULTIBUF, &sq->state);
-
 	err = mlx5e_create_sq_rdy(c->mdev, param, &csp, 0, &sq->sqn);
 	if (err)
 		goto err_free_xdpsq;
 
 	mlx5e_set_xmit_fp(sq, param->is_mpw);
 
-	if (!param->is_mpw && !test_bit(MLX5E_SQ_STATE_XDP_MULTIBUF, &sq->state)) {
-		unsigned int ds_cnt = MLX5E_TX_WQE_EMPTY_DS_COUNT + 1;
-		unsigned int inline_hdr_sz = 0;
-		int i;
-
-		if (sq->min_inline_mode != MLX5_INLINE_MODE_NONE) {
-			inline_hdr_sz = MLX5E_XDP_MIN_INLINE;
-			ds_cnt++;
-		}
-
-		/* Pre initialize fixed WQE fields */
-		for (i = 0; i < mlx5_wq_cyc_get_size(&sq->wq); i++) {
-			struct mlx5e_tx_wqe      *wqe  = mlx5_wq_cyc_get_wqe(&sq->wq, i);
-			struct mlx5_wqe_ctrl_seg *cseg = &wqe->ctrl;
-			struct mlx5_wqe_eth_seg  *eseg = &wqe->eth;
-
-			sq->db.wqe_info[i] = (struct mlx5e_xdp_wqe_info) {
-				.num_wqebbs = 1,
-				.num_pkts   = 1,
-			};
-
-			cseg->qpn_ds = cpu_to_be32((sq->sqn << 8) | ds_cnt);
-			eseg->inline_hdr.sz = cpu_to_be16(inline_hdr_sz);
-		}
-	}
-
 	return 0;
 
 err_free_xdpsq:
-- 
2.39.5



