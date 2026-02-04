Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A82C264614;
	Wed,  4 Feb 2026 14:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216565; cv=none; b=rUfMh+UF4lgI9xrhweNPzPJbpecwuwh+wTZZQNQqPNAsdVPcLR+BymKTQnasdbNivY08swvFdr53cMHy3I2xRUIGsONvW4XTEHa95BsgXF8xI584nTOOQKOCpYZBev1tnu80PYMmnPDoR8ENp6R+g3xYSEXoUbjbU2w8ckvk2/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216565; c=relaxed/simple;
	bh=tY5/dpotl4JgKHgJIPrTGrhpzxxfXtMrZ4xKq7XvWFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6VtXD8IgUDTm9kuel//IuKGPNXOV1ZbTfnXUkf9U+ce8tjUvo3ZBaLCAuPJlLpE7Hq6epmcD8jpRLCiATqqrM3OJPGF1oic/AxCc3vElY5fU//SKHuT0/oe1LCq5iw+cNylrD10Ch9CmktDRRJ9n2xF+WEEuCaJxBNt9D2mvus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Du4ZJPq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Du4ZJPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55548C4CEF7;
	Wed,  4 Feb 2026 14:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216564;
	bh=tY5/dpotl4JgKHgJIPrTGrhpzxxfXtMrZ4xKq7XvWFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Du4ZJPqFp7NkMEgokpwDfFDlQzVdXq63w7IFRTo8+z2crXFv8QOFmPeVov87sA68
	 unhVRjYoJt2sCMLvd5hg2mB6oCEbxse/JjaPKaW8eN113ZMJojZXKNxambdk899J4V
	 1t86fsRPIzlVb4BObpgAXfWKgdq0IQgbVTA7iXec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 125/161] net/mlx5e: Expose rx_oversize_pkts_buffer counter
Date: Wed,  4 Feb 2026 15:39:48 +0100
Message-ID: <20260204143856.242697773@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c3ff1fc577a7c..af98d9e59626d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3700,7 +3700,8 @@ mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
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
index ff4f10d0f090b..96d537bc0b8fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -489,17 +489,26 @@ static const struct counter_desc vnic_env_stats_dev_oob_desc[] = {
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
@@ -513,6 +522,11 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(vnic_env)
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
 
@@ -527,6 +541,11 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(vnic_env)
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
index 162daaadb0d8a..8813989f3f109 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -239,6 +239,10 @@ struct mlx5e_qcounter_stats {
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
index 303cbf0355a2e..705d8798bed5f 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1282,7 +1282,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         reserved_at_120[0xa];
 	u8         log_max_ra_req_dc[0x6];
-	u8         reserved_at_130[0x9];
+	u8         reserved_at_130[0x2];
+	u8         eth_wqe_too_small[0x1];
+	u8         reserved_at_133[0x6];
 	u8         vnic_env_cq_overrun[0x1];
 	u8         log_max_ra_res_dc[0x6];
 
@@ -3147,7 +3149,9 @@ struct mlx5_ifc_vnic_diagnostic_statistics_bits {
 
 	u8         cq_overrun[0x20];
 
-	u8         reserved_at_220[0xde0];
+	u8         eth_wqe_too_small[0x20];
+
+	u8         reserved_at_220[0xdc0];
 };
 
 struct mlx5_ifc_traffic_counter_bits {
-- 
2.51.0



