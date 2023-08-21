Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1141171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DB2C433C8;
	Mon, 21 Aug 2023 20:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648421;
	bh=/vPbDGYMzZ85BVDSSmFTHH4UXOF7Sf+LHKkwZNZe18Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jX2NNjR9P1m8HEY1X2mw+Fe9QKJNbtt11xE/s/rBs8Tz6/n7J6IUg1v2LcpeitIX4
	 93hd1idSk8sUYd6Vgm1y+LqgEyzZ8/M/k6y7cadXsXE18+F5e4B3IrMS3A3E+QWzA/
	 evSdGDbOWOQg/eFGaEYG6M8My0kaW5AthN/Ea9Eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 170/234] net/mlx5e: XDP, Fix fifo overrun on XDP_REDIRECT
Date: Mon, 21 Aug 2023 21:42:13 +0200
Message-ID: <20230821194136.358490395@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit 34a79876d9f77e971115236bcf7b5d14a8ecf542 ]

Before this fix, running high rate traffic through XDP_REDIRECT
with multibuf could overrun the fifo used to release the
xdp frames after tx completion. This resulted in corrupted data
being consumed on the free side.

The culplirt was a miscalculation of the fifo size: the maximum ratio
between fifo entries / data segments was incorrect. This ratio serves to
calculate the max fifo size for a full sq where each packet uses the
worst case number of entries in the fifo.

This patch fixes the formula and names the constant. It also makes sure
that future values will use a power of 2 number of entries for the fifo
mask to work.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Fixes: 3f734b8c594b ("net/mlx5e: XDP, Use multiple single-entry objects in xdpi_fifo")
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h  | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 8 +++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index 9e8e6184f9e43..ecfe93a479da8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -84,6 +84,8 @@ enum mlx5e_xdp_xmit_mode {
  * MLX5E_XDP_XMIT_MODE_XSK:
  *    none.
  */
+#define MLX5E_XDP_FIFO_ENTRIES2DS_MAX_RATIO 4
+
 union mlx5e_xdp_info {
 	enum mlx5e_xdp_xmit_mode mode;
 	union {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 7e6d0489854e3..975c82df345cd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1298,11 +1298,13 @@ static int mlx5e_alloc_xdpsq_fifo(struct mlx5e_xdpsq *sq, int numa)
 {
 	struct mlx5e_xdp_info_fifo *xdpi_fifo = &sq->db.xdpi_fifo;
 	int wq_sz        = mlx5_wq_cyc_get_size(&sq->wq);
-	int entries = wq_sz * MLX5_SEND_WQEBB_NUM_DS * 2; /* upper bound for maximum num of
-							   * entries of all xmit_modes.
-							   */
+	int entries;
 	size_t size;
 
+	/* upper bound for maximum num of entries of all xmit_modes. */
+	entries = roundup_pow_of_two(wq_sz * MLX5_SEND_WQEBB_NUM_DS *
+				     MLX5E_XDP_FIFO_ENTRIES2DS_MAX_RATIO);
+
 	size = array_size(sizeof(*xdpi_fifo->xi), entries);
 	xdpi_fifo->xi = kvzalloc_node(size, GFP_KERNEL, numa);
 	if (!xdpi_fifo->xi)
-- 
2.40.1



