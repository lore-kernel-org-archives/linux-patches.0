Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898791D146;
	Mon, 18 Dec 2023 13:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T3q8WGcN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DEDEC433CD;
	Mon, 18 Dec 2023 13:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702907991;
	bh=YoF1fSwRzdSHr7rij/Mkxjyq1zJfkorFmDAcnkZ8xJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T3q8WGcNu0E6PTr8wnhwcc3lh4YsoLvm6WygYdVOFtLGYZ3znvkhoCIao4uHIvUei
	 XxjAg5pWvu1iVqEVsJsz8SY8FMDrUePx0pYjUT8jOdsPuzcWDxPJHBiwXt2xE9CqhD
	 Y1X3wLZpHk4OQ21v99YayJOM7DYXVyDT0Q9IyabQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mi <cmi@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/166] net/mlx5e: Disable IPsec offload support if not FW steering
Date: Mon, 18 Dec 2023 14:49:40 +0100
Message-ID: <20231218135105.584736935@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mi <cmi@nvidia.com>

[ Upstream commit 762a55a54eec4217e4cec9265ab6e5d4c11b61bd ]

IPsec FDB offload can only work with FW steering as of now,
disable the cap upon non FW steering.

And since the IPSec cap is dynamic now based on steering mode.
Cleanup the resources if they exist instead of checking the
IPsec cap again.

Fixes: edd8b295f9e2 ("Merge branch 'mlx5-ipsec-packet-offload-support-in-eswitch-mode'")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 26 ++++++++-----------
 .../mlx5/core/en_accel/ipsec_offload.c        |  8 +++++-
 2 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 0d4b8aef6adda..5834e47e72d82 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -929,9 +929,11 @@ void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv)
 		return;
 
 	mlx5e_accel_ipsec_fs_cleanup(ipsec);
-	if (mlx5_ipsec_device_caps(priv->mdev) & MLX5_IPSEC_CAP_TUNNEL)
+	if (ipsec->netevent_nb.notifier_call) {
 		unregister_netevent_notifier(&ipsec->netevent_nb);
-	if (mlx5_ipsec_device_caps(priv->mdev) & MLX5_IPSEC_CAP_PACKET_OFFLOAD)
+		ipsec->netevent_nb.notifier_call = NULL;
+	}
+	if (ipsec->aso)
 		mlx5e_ipsec_aso_cleanup(ipsec);
 	destroy_workqueue(ipsec->wq);
 	kfree(ipsec);
@@ -1040,6 +1042,12 @@ static int mlx5e_xfrm_validate_policy(struct mlx5_core_dev *mdev,
 		}
 	}
 
+	if (x->xdo.type == XFRM_DEV_OFFLOAD_PACKET &&
+	    !(mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_PACKET_OFFLOAD)) {
+		NL_SET_ERR_MSG_MOD(extack, "Packet offload is not supported");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -1135,14 +1143,6 @@ static const struct xfrmdev_ops mlx5e_ipsec_xfrmdev_ops = {
 	.xdo_dev_state_free	= mlx5e_xfrm_free_state,
 	.xdo_dev_offload_ok	= mlx5e_ipsec_offload_ok,
 	.xdo_dev_state_advance_esn = mlx5e_xfrm_advance_esn_state,
-};
-
-static const struct xfrmdev_ops mlx5e_ipsec_packet_xfrmdev_ops = {
-	.xdo_dev_state_add	= mlx5e_xfrm_add_state,
-	.xdo_dev_state_delete	= mlx5e_xfrm_del_state,
-	.xdo_dev_state_free	= mlx5e_xfrm_free_state,
-	.xdo_dev_offload_ok	= mlx5e_ipsec_offload_ok,
-	.xdo_dev_state_advance_esn = mlx5e_xfrm_advance_esn_state,
 
 	.xdo_dev_state_update_curlft = mlx5e_xfrm_update_curlft,
 	.xdo_dev_policy_add = mlx5e_xfrm_add_policy,
@@ -1160,11 +1160,7 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
 
 	mlx5_core_info(mdev, "mlx5e: IPSec ESP acceleration enabled\n");
 
-	if (mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_PACKET_OFFLOAD)
-		netdev->xfrmdev_ops = &mlx5e_ipsec_packet_xfrmdev_ops;
-	else
-		netdev->xfrmdev_ops = &mlx5e_ipsec_xfrmdev_ops;
-
+	netdev->xfrmdev_ops = &mlx5e_ipsec_xfrmdev_ops;
 	netdev->features |= NETIF_F_HW_ESP;
 	netdev->hw_enc_features |= NETIF_F_HW_ESP;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 55b11d8cba532..ce29e31721208 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -5,6 +5,8 @@
 #include "en.h"
 #include "ipsec.h"
 #include "lib/crypto.h"
+#include "fs_core.h"
+#include "eswitch.h"
 
 enum {
 	MLX5_IPSEC_ASO_REMOVE_FLOW_PKT_CNT_OFFSET,
@@ -37,7 +39,10 @@ u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
 	    MLX5_CAP_ETH(mdev, insert_trailer) && MLX5_CAP_ETH(mdev, swp))
 		caps |= MLX5_IPSEC_CAP_CRYPTO;
 
-	if (MLX5_CAP_IPSEC(mdev, ipsec_full_offload)) {
+	if (MLX5_CAP_IPSEC(mdev, ipsec_full_offload) &&
+	    (mdev->priv.steering->mode == MLX5_FLOW_STEERING_MODE_DMFS ||
+	     (mdev->priv.steering->mode == MLX5_FLOW_STEERING_MODE_SMFS &&
+	     is_mdev_legacy_mode(mdev)))) {
 		if (MLX5_CAP_FLOWTABLE_NIC_TX(mdev,
 					      reformat_add_esp_trasport) &&
 		    MLX5_CAP_FLOWTABLE_NIC_RX(mdev,
@@ -558,6 +563,7 @@ void mlx5e_ipsec_aso_cleanup(struct mlx5e_ipsec *ipsec)
 	dma_unmap_single(pdev, aso->dma_addr, sizeof(aso->ctx),
 			 DMA_BIDIRECTIONAL);
 	kfree(aso);
+	ipsec->aso = NULL;
 }
 
 static void mlx5e_ipsec_aso_copy(struct mlx5_wqe_aso_ctrl_seg *ctrl,
-- 
2.43.0



