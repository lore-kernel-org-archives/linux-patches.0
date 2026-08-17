Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C153C8C65;
	Mon, 17 Aug 2026 13:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974065; cv=none; b=KCdA0Y8A8pHqENiuwOm9F8w9Fj0dk4XifvPlUlJQVpHFYZcGh10mDt64aNJkqEK40RSt81V9LUmn1eA8UQd1hlwIHgRBJ7x0YB30NuVWpd6JaWtSzXc+hmGDg/B99G8GHRkcCoj7KqGQUKrTZ4vL3yV28WEa/ZmB77ZSJ/MJbeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974065; c=relaxed/simple;
	bh=vtCR+JHUc9DGCzkM5GaPHFGO5hDdnCWwHOqEhRvB8qM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUq3LwK46AAGGSfNl2UffPx7KyZe99u0hM6+e6x5PxfkvtBJGS/EMsZB7smy6dOOghyakxLR1tMHvSkVO3fw9h6fijwwCv+MMAUNkXwMw25aVWmaGcjatuyumwqZsdvo7ey3uRuou7HNdjl6FgaP4WvqPdfk7sCACs2GQ2NKYCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dR+7UeZx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dR+7UeZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3EA1F00AC4;
	Mon, 17 Aug 2026 13:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974057;
	bh=vEp9GhYBwv4e6OoQ05AzD6ybg3FTTntt11ptDLuUD+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dR+7UeZxtcgmZqGTK/EtiQgKH9xGbs2Ddix+2tpJe1oqW15KdjjfnfmB6SQ/Qddbw
	 AF7CeGJSpHQtx7/JxSYGgDmGnHNgiMWVLGfyAUECKHOUIdHDqflm0KpsL7kbtNLpgj
	 RmvChXthizZ+6376mFLzGfzR4Mz4vl7PC1zrNPhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 073/271] xsk: pass TX metadata pointer by reference
Date: Mon, 17 Aug 2026 15:29:58 +0200
Message-ID: <20260817132539.746948061@linuxfoundation.org>
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

[ Upstream commit 19366db6dfccac9b0867a151678cd7b89fb8fd99 ]

Completion handling needs to know whether a timestamp was requested when
the metadata was processed. Let xsk_tx_metadata_request() update the
caller's metadata pointer so that decision can be carried forward without
rereading user-controlled flags.

This only changes the interface; behavior remains unchanged.

Fixes: ca4419f15abd ("xsk: Add launch time hardware offload support to XDP Tx metadata")
Cc: Cen Zhang (Microsoft) <blbllhy@gmail.com>
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20260727161959.885642-3-sdf@fomichev.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c          |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   | 14 +++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |  2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  2 +-
 include/net/libeth/xsk.h                           |  2 +-
 include/net/xdp_sock.h                             |  8 +++++---
 8 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index c0508d2615923..13ddf6cc52eea 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3082,7 +3082,7 @@ static void igc_xdp_xmit_zc(struct igc_ring *ring)
 		meta_req.tx_buffer = bi;
 		meta_req.meta = meta;
 		meta_req.used_desc = 0;
-		xsk_tx_metadata_request(meta, &igc_xsk_tx_metadata_ops,
+		xsk_tx_metadata_request(&meta, &igc_xsk_tx_metadata_ops,
 					&meta_req);
 
 		/* xsk_tx_metadata_request() may have updated next_to_use */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 6867a5aed42c0..822859c360e75 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -483,7 +483,7 @@ typedef int (*mlx5e_fp_xmit_xdp_frame_check)(struct mlx5e_xdpsq *);
 typedef bool (*mlx5e_fp_xmit_xdp_frame)(struct mlx5e_xdpsq *,
 					struct mlx5e_xmit_data *,
 					int,
-					struct xsk_tx_metadata *);
+					struct xsk_tx_metadata **);
 
 struct mlx5e_xdpsq {
 	/* data path */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index d8c7cb8837d74..dac5e9d4c8bdb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -452,11 +452,11 @@ INDIRECT_CALLABLE_SCOPE int mlx5e_xmit_xdp_frame_check_mpwqe(struct mlx5e_xdpsq
 
 INDIRECT_CALLABLE_SCOPE bool
 mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
-		     int check_result, struct xsk_tx_metadata *meta);
+		     int check_result, struct xsk_tx_metadata **meta);
 
 INDIRECT_CALLABLE_SCOPE bool
 mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
-			   int check_result, struct xsk_tx_metadata *meta)
+			   int check_result, struct xsk_tx_metadata **meta)
 {
 	struct mlx5e_tx_mpwqe *session = &sq->mpwqe;
 	struct mlx5e_xdpsq_stats *stats = sq->stats;
@@ -504,7 +504,10 @@ mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptx
 		 * and it's safe to complete it at any time.
 		 */
 		mlx5e_xdp_mpwqe_session_start(sq);
-		xsk_tx_metadata_request(meta, &mlx5e_xsk_tx_metadata_ops, &session->wqe->eth);
+		if (meta)
+			xsk_tx_metadata_request(meta,
+						&mlx5e_xsk_tx_metadata_ops,
+						&session->wqe->eth);
 	}
 
 	mlx5e_xdp_mpwqe_add_dseg(sq, p, stats);
@@ -535,7 +538,7 @@ INDIRECT_CALLABLE_SCOPE int mlx5e_xmit_xdp_frame_check(struct mlx5e_xdpsq *sq)
 
 INDIRECT_CALLABLE_SCOPE bool
 mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
-		     int check_result, struct xsk_tx_metadata *meta)
+		     int check_result, struct xsk_tx_metadata **meta)
 {
 	struct mlx5e_xmit_data_frags *xdptxdf =
 		container_of(xdptxd, struct mlx5e_xmit_data_frags, xd);
@@ -649,7 +652,8 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 
 	sq->pc += num_wqebbs;
 
-	xsk_tx_metadata_request(meta, &mlx5e_xsk_tx_metadata_ops, eseg);
+	if (meta)
+		xsk_tx_metadata_request(meta, &mlx5e_xsk_tx_metadata_ops, eseg);
 
 	sq->doorbell_cseg = cseg;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index 3c54f8962664f..5b8f4094d5530 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -114,11 +114,11 @@ extern const struct xsk_tx_metadata_ops mlx5e_xsk_tx_metadata_ops;
 INDIRECT_CALLABLE_DECLARE(bool mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq,
 							  struct mlx5e_xmit_data *xdptxd,
 							  int check_result,
-							  struct xsk_tx_metadata *meta));
+							  struct xsk_tx_metadata **meta));
 INDIRECT_CALLABLE_DECLARE(bool mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq,
 						    struct mlx5e_xmit_data *xdptxd,
 						    int check_result,
-						    struct xsk_tx_metadata *meta));
+						    struct xsk_tx_metadata **meta));
 INDIRECT_CALLABLE_DECLARE(int mlx5e_xmit_xdp_frame_check_mpwqe(struct mlx5e_xdpsq *sq));
 INDIRECT_CALLABLE_DECLARE(int mlx5e_xmit_xdp_frame_check(struct mlx5e_xdpsq *sq));
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index 8aeab4b21035c..3d19dad8f8688 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -105,7 +105,7 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 
 		ret = INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
 				      mlx5e_xmit_xdp_frame, sq, &xdptxd,
-				      check_result, meta);
+				      check_result, &meta);
 		if (unlikely(!ret)) {
 			if (sq->mpwqe.wqe)
 				mlx5e_xdp_mpwqe_complete(sq);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index f28367fbcaf81..622f571b30350 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2748,7 +2748,7 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 		meta_req.set_ic = &set_ic;
 		meta_req.tbs = tx_q->tbs;
 		meta_req.edesc = &tx_q->dma_entx[entry];
-		xsk_tx_metadata_request(meta, &stmmac_xsk_tx_metadata_ops,
+		xsk_tx_metadata_request(&meta, &stmmac_xsk_tx_metadata_ops,
 					&meta_req);
 		if (set_ic) {
 			tx_q->tx_count_frames = 0;
diff --git a/include/net/libeth/xsk.h b/include/net/libeth/xsk.h
index 82b5d21aae878..e2fa6bf6b1b31 100644
--- a/include/net/libeth/xsk.h
+++ b/include/net/libeth/xsk.h
@@ -205,7 +205,7 @@ __libeth_xsk_xmit_fill_buf_md(const struct xdp_desc *xdesc,
 	BUILD_BUG_ON(!__builtin_constant_p(tmo == libeth_xsktmo));
 	tmo = tmo == libeth_xsktmo ? &__libeth_xsktmo : tmo;
 
-	xsk_tx_metadata_request(ctx.meta, tmo, &desc);
+	xsk_tx_metadata_request(&ctx.meta, tmo, &desc);
 
 	return desc;
 }
diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 8b51876efbed1..06c081feff42d 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -153,17 +153,19 @@ static inline void xsk_tx_metadata_to_compl(struct xsk_tx_metadata *meta,
 /**
  *  xsk_tx_metadata_request - Evaluate AF_XDP TX metadata at submission
  *  and call appropriate xsk_tx_metadata_ops operation.
- *  @meta: pointer to AF_XDP metadata area
+ *  @pmeta: pointer to pointer to AF_XDP metadata area
  *  @ops: pointer to struct xsk_tx_metadata_ops
  *  @priv: pointer to driver-private aread
  *
  *  This function should be called by the networking device when
  *  it prepares AF_XDP egress packet.
  */
-static inline void xsk_tx_metadata_request(const struct xsk_tx_metadata *meta,
+static inline void xsk_tx_metadata_request(struct xsk_tx_metadata **pmeta,
 					   const struct xsk_tx_metadata_ops *ops,
 					   void *priv)
 {
+	const struct xsk_tx_metadata *meta = *pmeta;
+
 	if (!meta)
 		return;
 
@@ -231,7 +233,7 @@ static inline void xsk_tx_metadata_to_compl(struct xsk_tx_metadata *meta,
 {
 }
 
-static inline void xsk_tx_metadata_request(struct xsk_tx_metadata *meta,
+static inline void xsk_tx_metadata_request(struct xsk_tx_metadata **pmeta,
 					   const struct xsk_tx_metadata_ops *ops,
 					   void *priv)
 {
-- 
2.53.0



