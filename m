Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2547CE54A
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BF6C4339C;
	Thu,  1 Jun 2023 13:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685625791;
	bh=csGBHSLMTywrf+G5mxuLNvCLcQ3JOfYfd77tWemtpQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LvpVh2HEfaIAsZq82CMJBRGxjCA1XOZWnw9/KFOGNE9u/ehKFQWClOvaAf1s5qhhJ
	 VEub/R23lLO7MfiFT7pliryvJyudpiEllSom8jcqpwjooJkzzFJutf1GHUzTxNrqdC
	 RXnYS0lwjslSW7+FOz4KtoWxi5Zqds0hN7Znidn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 17/22] net/mlx5: Devcom, serialize devcom registration
Date: Thu,  1 Jun 2023 14:21:15 +0100
Message-Id: <20230601131934.545100992@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131933.727832920@linuxfoundation.org>
References: <20230601131933.727832920@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 1f893f57a3bf9fe1f4bcb25b55aea7f7f9712fe7 ]

>From one hand, mlx5 driver is allowing to probe PFs in parallel.
>From the other hand, devcom, which is a share resource between PFs, is
registered without any lock. This might resulted in memory problems.

Hence, use the global mlx5_dev_list_lock in order to serialize devcom
registration.

Fixes: fadd59fc50d0 ("net/mlx5: Introduce inter-device communication mechanism")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/lib/devcom.c  | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
index 617eea1b1701b..438be215bbd45 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
@@ -3,6 +3,7 @@
 
 #include <linux/mlx5/vport.h>
 #include "lib/devcom.h"
+#include "mlx5_core.h"
 
 static LIST_HEAD(devcom_list);
 
@@ -77,6 +78,7 @@ struct mlx5_devcom *mlx5_devcom_register_device(struct mlx5_core_dev *dev)
 	if (MLX5_CAP_GEN(dev, num_lag_ports) != MLX5_DEVCOM_PORTS_SUPPORTED)
 		return NULL;
 
+	mlx5_dev_list_lock();
 	sguid0 = mlx5_query_nic_system_image_guid(dev);
 	list_for_each_entry(iter, &devcom_list, list) {
 		struct mlx5_core_dev *tmp_dev = NULL;
@@ -102,8 +104,10 @@ struct mlx5_devcom *mlx5_devcom_register_device(struct mlx5_core_dev *dev)
 
 	if (!priv) {
 		priv = mlx5_devcom_list_alloc();
-		if (!priv)
-			return ERR_PTR(-ENOMEM);
+		if (!priv) {
+			devcom = ERR_PTR(-ENOMEM);
+			goto out;
+		}
 
 		idx = 0;
 		new_priv = true;
@@ -114,12 +118,14 @@ struct mlx5_devcom *mlx5_devcom_register_device(struct mlx5_core_dev *dev)
 	if (!devcom) {
 		if (new_priv)
 			kfree(priv);
-		return ERR_PTR(-ENOMEM);
+		devcom = ERR_PTR(-ENOMEM);
+		goto out;
 	}
 
 	if (new_priv)
 		list_add(&priv->list, &devcom_list);
-
+out:
+	mlx5_dev_list_unlock();
 	return devcom;
 }
 
@@ -132,6 +138,7 @@ void mlx5_devcom_unregister_device(struct mlx5_devcom *devcom)
 	if (IS_ERR_OR_NULL(devcom))
 		return;
 
+	mlx5_dev_list_lock();
 	priv = devcom->priv;
 	priv->devs[devcom->idx] = NULL;
 
@@ -142,10 +149,12 @@ void mlx5_devcom_unregister_device(struct mlx5_devcom *devcom)
 			break;
 
 	if (i != MLX5_DEVCOM_PORTS_SUPPORTED)
-		return;
+		goto out;
 
 	list_del(&priv->list);
 	kfree(priv);
+out:
+	mlx5_dev_list_unlock();
 }
 
 void mlx5_devcom_register_component(struct mlx5_devcom *devcom,
-- 
2.39.2



