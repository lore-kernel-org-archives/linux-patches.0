Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A50542188D;
	Wed,  4 Feb 2026 14:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217164; cv=none; b=hboSCf4HkLXOFXNZzrY9h8ktu50AOEfNcfFnKNBC6BES33C1RZJWJDeb76bEXM4W7hB0WwLGIl1QlKuYz0AaZrDSuer8dw+eqI5RJwsg/AQFHIW4G9/wvqpRF/SqVugByesW2b8JLA1qxMGtiyaBim0Jc+d6yepsW4vhl3qiNNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217164; c=relaxed/simple;
	bh=qapa0ksVn6XNNXxpwTU2kavTfMbZsdrCvc9Ohwb3g3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQMS++dZGOhoI7bI/S/2tPcP/ihCdZEkKtS++LzLoeS7e7LH26XmNvC3dnO1o7TSd3yqWBX9fg09d+5whrKH3reLTVW3Eeot7iCuuU9fMroOeSKkl+rv8qJIV7Qd6f44nre1w05dDHYYji+5hoTdLfTHwJ2oY5u3DCRY+TlMBOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nErPCBpi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nErPCBpi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FDEC4CEF7;
	Wed,  4 Feb 2026 14:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217164;
	bh=qapa0ksVn6XNNXxpwTU2kavTfMbZsdrCvc9Ohwb3g3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nErPCBpiZakoqCufzP2HZEwUTkxEAtkQ8HkLU7AbXZy9dEYYWhnjht48L90dkLqf8
	 /+EGFmIbiGeGugxn7lNqWkxMf6N1teU1kKauNCr1u8ItWAeMtgo68drIaD8d1mgHOF
	 qiCnJjTX9JV3oo/J3SKtoCDG05jDqTyJCpd5NyIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 143/206] net/mlx5e: Expose rx_oversize_pkts_buffer counter
Date: Wed,  4 Feb 2026 15:39:34 +0100
Message-ID: <20260204143903.355486220@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 16ab85e78439bab1201ff26ba430231d1574b4ae ]

Add the rx_oversize_pkts_buffer counter to ethtool statistics.
This counter exposes the number of dropped received packets due to
length which arrived to RQ and exceed software buffer size allocated by
the device for incoming traffic. It might imply that the device MTU is
larger than the software buffers size.

Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 476681f10cc1 ("net/mlx5e: Account for netdev stats in ndo_get_stats64")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  3 ++-
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 21 ++++++++++++++++++-
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  4 ++++
 include/linux/mlx5/mlx5_ifc.h                 |  8 +++++--
 4 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ba36e500c1ff1..b4e6a467409be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3190,7 +3190,8 @@ mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	stats->rx_length_errors =
 		PPORT_802_3_GET(pstats, a_in_range_length_errors) +
 		PPORT_802_3_GET(pstats, a_out_of_range_length_field) +
-		PPORT_802_3_GET(pstats, a_frame_too_long_errors);
+		PPORT_802_3_GET(pstats, a_frame_too_long_errors) +
+		VNIC_ENV_GET(&priv->stats.vnic, eth_wqe_too_small);
 	stats->rx_crc_errors =
 		PPORT_802_3_GET(pstats, a_frame_check_sequence_errors);
 	stats->rx_frame_errors = PPORT_802_3_GET(pstats, a_alignment_errors);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 5a5c6eda29d28..75c3b2ac7e24e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -567,17 +567,26 @@ static const struct counter_desc vnic_env_stats_dev_oob_desc[] = {
 		VNIC_ENV_OFF(vport_env.internal_rq_out_of_buffer) },
 };
 
+static const struct counter_desc vnic_env_stats_drop_desc[] = {
+	{ "rx_oversize_pkts_buffer",
+		VNIC_ENV_OFF(vport_env.eth_wqe_too_small) },
+};
+
 #define NUM_VNIC_ENV_STEER_COUNTERS(dev) \
 	(MLX5_CAP_GEN(dev, nic_receive_steering_discard) ? \
 	 ARRAY_SIZE(vnic_env_stats_steer_desc) : 0)
 #define NUM_VNIC_ENV_DEV_OOB_COUNTERS(dev) \
 	(MLX5_CAP_GEN(dev, vnic_env_int_rq_oob) ? \
 	 ARRAY_SIZE(vnic_env_stats_dev_oob_desc) : 0)
+#define NUM_VNIC_ENV_DROP_COUNTERS(dev) \
+	(MLX5_CAP_GEN(dev, eth_wqe_too_small) ? \
+	 ARRAY_SIZE(vnic_env_stats_drop_desc) : 0)
 
 static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(vnic_env)
 {
 	return NUM_VNIC_ENV_STEER_COUNTERS(priv->mdev) +
-		NUM_VNIC_ENV_DEV_OOB_COUNTERS(priv->mdev);
+	       NUM_VNIC_ENV_DEV_OOB_COUNTERS(priv->mdev) +
+	       NUM_VNIC_ENV_DROP_COUNTERS(priv->mdev);
 }
 
 static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(vnic_env)
@@ -591,6 +600,11 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(vnic_env)
 	for (i = 0; i < NUM_VNIC_ENV_DEV_OOB_COUNTERS(priv->mdev); i++)
 		strcpy(data + (idx++) * ETH_GSTRING_LEN,
 		       vnic_env_stats_dev_oob_desc[i].format);
+
+	for (i = 0; i < NUM_VNIC_ENV_DROP_COUNTERS(priv->mdev); i++)
+		strcpy(data + (idx++) * ETH_GSTRING_LEN,
+		       vnic_env_stats_drop_desc[i].format);
+
 	return idx;
 }
 
@@ -605,6 +619,11 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(vnic_env)
 	for (i = 0; i < NUM_VNIC_ENV_DEV_OOB_COUNTERS(priv->mdev); i++)
 		data[idx++] = MLX5E_READ_CTR32_BE(priv->stats.vnic.query_vnic_env_out,
 						  vnic_env_stats_dev_oob_desc, i);
+
+	for (i = 0; i < NUM_VNIC_ENV_DROP_COUNTERS(priv->mdev); i++)
+		data[idx++] = MLX5E_READ_CTR32_BE(priv->stats.vnic.query_vnic_env_out,
+						  vnic_env_stats_drop_desc, i);
+
 	return idx;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 139e59f30db00..f31da3699c7b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -256,6 +256,10 @@ struct mlx5e_qcounter_stats {
 	u32 rx_if_down_packets;
 };
 
+#define VNIC_ENV_GET(vnic_env_stats, c) \
+	MLX5_GET(query_vnic_env_out, (vnic_env_stats)->query_vnic_env_out, \
+		 vport_env.c)
+
 struct mlx5e_vnic_env_stats {
 	__be64 query_vnic_env_out[MLX5_ST_SZ_QW(query_vnic_env_out)];
 };
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index c8489aeb74f7e..30251dfbe040c 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1384,7 +1384,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         reserved_at_120[0xa];
 	u8         log_max_ra_req_dc[0x6];
-	u8         reserved_at_130[0x9];
+	u8         reserved_at_130[0x2];
+	u8         eth_wqe_too_small[0x1];
+	u8         reserved_at_133[0x6];
 	u8         vnic_env_cq_overrun[0x1];
 	u8         log_max_ra_res_dc[0x6];
 
@@ -3337,7 +3339,9 @@ struct mlx5_ifc_vnic_diagnostic_statistics_bits {
 
 	u8         cq_overrun[0x20];
 
-	u8         reserved_at_220[0xde0];
+	u8         eth_wqe_too_small[0x20];
+
+	u8         reserved_at_220[0xdc0];
 };
 
 struct mlx5_ifc_traffic_counter_bits {
-- 
2.51.0



