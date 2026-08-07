Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB6737F8C2;
	Fri,  7 Aug 2026 15:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116852; cv=none; b=DP26f1oC/ewSMV7uZZP0w2WE7HEjCHgHujxNzSzLGTdG84WC2rHPRs47wgYO7ZbzHboo0Vd3fU9HUUvRmSuYQm9fsAY4Lx8EZNwTeSh+2kqGxCvECrSNvJxxNpezr3iofgrnL0JolX4kCO/nx4EesGjnUxwj+y0shasvQbBcA8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116852; c=relaxed/simple;
	bh=40/nEbV86efH7u9O5he+ia6+2+7tjztGABUVwBaorwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIpTiIqUSa3S5fW3grTGpCIF7fD1LpDKbQ0Y5EAnaVfyPsaUTf4TBa1y2l91Uoca6XDx7PrOXaPV+ay3bAj751ZAcFO/vLdauHVOsWv3Zgf0ZVTshTx/qsfeE4grnYQsXM8xa4TzhTFSRscnkrAWWifH/4XwCCuZGXeCc2H3ehY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nla8Pxln; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nla8Pxln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D700A1F00A3A;
	Fri,  7 Aug 2026 15:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116851;
	bh=/b+ymRV7Au6cwyJzOy1FOUJPp6Qy71yDL54q+RiPPLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nla8PxlnH0cMuO17GHe7MWKD6sOGrLGoNf/r0f/bDKJEqW9PWy8scLuPgUl2iqme6
	 T2lo9EbUB1mxs8FhMTxAmmAUJzRSPMpNNuUvT3OvXCrQXFjsJhm524yWYafu4VevB5
	 43zGjmRCYamOSDhYjRvYLBj4q0baY+vJiQsxINiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Joyner <eric.joyner@amd.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 111/438] ethtool: Embed FEC hist ranges as buffer in struct
Date: Fri,  7 Aug 2026 16:35:07 +0200
Message-ID: <20260807143430.361352461@linuxfoundation.org>
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

From: Eric Joyner <eric.joyner@amd.com>

[ Upstream commit 97ac08560d236ca17f6606d9e671118e5eae5721 ]

When a driver's .get_fec_stats() handler is called and the driver
supports FEC histogram stats, the driver supplies the histogram bin
ranges via a pointer.  This pointer is assigned while under the netdev
ops lock in fec_prepare_data(), but the actual data is only read after
the lock is released; so this allows the driver to change the ranges
(e.g. from another .get_fec_stats() call) while the current call chain
is reading them in fec_fill_reply().

Fix this by adding an ethtool core-owned buffer, ranges_buf, to struct
ethtool_fec_hist. Drivers whose ranges are built dynamically (currently
just mlx5) fill ranges_buf and then point the existing ranges pointer at
it, giving ethtool a consistent copy that stays valid after the netdev
ops lock is dropped and later in fec_fill_reply(). Drivers whose ranges
are compile-time constants (bnxt, netdevsim) are unaffected by the
potential race and keep setting the existing ranges pointer to their
constant array, without making copies.

Fixes: cc2f08129925 ("ethtool: add FEC bins histogram report")
Signed-off-by: Eric Joyner <eric.joyner@amd.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20260723041342.39238-1-eric.joyner@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 -
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  7 -------
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 19 +++++++++----------
 include/linux/ethtool.h                       |  1 +
 4 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index d507289096c20..6867a5aed42c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -984,7 +984,6 @@ struct mlx5e_priv {
 	struct mlx5e_mqprio_rl    *mqprio_rl;
 	struct dentry             *dfs_root;
 	struct mlx5_devcom_comp_dev *devcom;
-	struct ethtool_fec_hist_range *fec_ranges;
 };
 
 static inline u16 mlx5e_stats_nch_read(const struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index fd442109aea8c..7d1063c7bf649 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -6374,14 +6374,8 @@ int mlx5e_priv_init(struct mlx5e_priv *priv,
 	if (!priv->channel_stats)
 		goto err_free_tx_rates;
 
-	priv->fec_ranges = kzalloc_objs(*priv->fec_ranges, ETHTOOL_FEC_HIST_MAX);
-	if (!priv->fec_ranges)
-		goto err_free_channel_stats;
-
 	return 0;
 
-err_free_channel_stats:
-	kfree(priv->channel_stats);
 err_free_tx_rates:
 	kfree(priv->tx_rates);
 err_free_txq2sq_stats:
@@ -6406,7 +6400,6 @@ void mlx5e_priv_cleanup(struct mlx5e_priv *priv)
 	if (!priv->mdev)
 		return;
 
-	kfree(priv->fec_ranges);
 	for (i = 0; i < priv->stats_nch; i++)
 		kvfree(priv->channel_stats[i]);
 	kfree(priv->channel_stats);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 8632b73179cbc..bba51e198d731 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -1551,7 +1551,7 @@ static bool fec_rs_validate_hist_type(int mode, int hist_type)
 
 static u8
 fec_rs_histogram_fill_ranges(struct mlx5e_priv *priv, int mode,
-			     const struct ethtool_fec_hist_range **ranges)
+			     struct ethtool_fec_hist_range *ranges)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
 	u32 out[MLX5_ST_SZ_DW(pphcr_reg)] = {0};
@@ -1559,8 +1559,6 @@ fec_rs_histogram_fill_ranges(struct mlx5e_priv *priv, int mode,
 	int sz = MLX5_ST_SZ_BYTES(pphcr_reg);
 	u8 hist_type, num_of_bins;
 
-	memset(priv->fec_ranges, 0,
-	       ETHTOOL_FEC_HIST_MAX * sizeof(*priv->fec_ranges));
 	MLX5_SET(pphcr_reg, in, local_port, 1);
 	if (mlx5_core_access_reg(mdev, in, sz, out, sz, MLX5_REG_PPHCR, 0, 0))
 		return 0;
@@ -1576,12 +1574,11 @@ fec_rs_histogram_fill_ranges(struct mlx5e_priv *priv, int mode,
 	for (int i = 0; i < num_of_bins; i++) {
 		void *bin_range = MLX5_ADDR_OF(pphcr_reg, out, bin_range[i]);
 
-		priv->fec_ranges[i].high = MLX5_GET(bin_range_layout, bin_range,
-						    high_val);
-		priv->fec_ranges[i].low = MLX5_GET(bin_range_layout, bin_range,
-						   low_val);
+		ranges[i].high = MLX5_GET(bin_range_layout, bin_range,
+					  high_val);
+		ranges[i].low = MLX5_GET(bin_range_layout, bin_range,
+					 low_val);
 	}
-	*ranges = priv->fec_ranges;
 
 	return num_of_bins;
 }
@@ -1623,10 +1620,12 @@ static void fec_set_histograms_stats(struct mlx5e_priv *priv, int mode,
 	case MLX5E_FEC_LLRS_272_257_1:
 	case MLX5E_FEC_RS_544_514_INTERLEAVED_QUAD:
 		num_of_bins =
-			fec_rs_histogram_fill_ranges(priv, mode, &hist->ranges);
-		if (num_of_bins)
+			fec_rs_histogram_fill_ranges(priv, mode, hist->ranges_buf);
+		if (num_of_bins) {
+			hist->ranges = hist->ranges_buf;
 			return fec_rs_histogram_fill_stats(priv, num_of_bins,
 							   hist);
+		}
 		break;
 	default:
 		return;
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 1cb0740ba3310..091d382f0a2d3 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -560,6 +560,7 @@ struct ethtool_fec_hist {
 		u64 per_lane[ETHTOOL_MAX_LANES];
 	} values[ETHTOOL_FEC_HIST_MAX];
 	const struct ethtool_fec_hist_range *ranges;
+	struct ethtool_fec_hist_range ranges_buf[ETHTOOL_FEC_HIST_MAX];
 };
 /**
  * struct ethtool_fec_stats - statistics for IEEE 802.3 FEC
-- 
2.53.0



