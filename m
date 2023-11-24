Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B592833CFD;
	Fri, 24 Nov 2023 19:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v5zndv7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23300C433C7;
	Fri, 24 Nov 2023 19:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852688;
	bh=tZaEec9ZAiV6fVHLGeTC6LOwmYrMUSKqc6IUZkooFCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v5zndv7zWGrAXyo5fyPt11ZeZwu4X/vlYTBTIMLapibFbsqY2Ah16KkOnDE0GQT9o
	 hC/atfcu8spdQDQl6vURKgiw2jvMx5XrpPWYm4Wu9NIkxv18ZtsA7rAgDhVMh2G2dj
	 QTGlZPFoWh6u6iLiYsPB2d+GXf4Ju5c+QLPxwBHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parav Pandit <parav@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/193] net/mlx5_core: Clean driver version and name
Date: Fri, 24 Nov 2023 17:53:30 +0000
Message-ID: <20231124171950.556396826@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171947.127438872@linuxfoundation.org>
References: <20231124171947.127438872@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 17a7612b99e66d2539341ab4f888f970c2c7f76d ]

Remove exposed driver version as it was done in other drivers,
so module version will work correctly by displaying the kernel
version for which it is compiled.

And move mlx5_core module name to general include, so auxiliary drivers
will be able to use it as a basis for a name in their device ID tables.

Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Stable-dep-of: 1b2bd0c0264f ("net/mlx5e: Check return value of snprintf writing to fw_version buffer for representors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c      |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  4 +---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c       |  1 -
 .../net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c         | 10 ++++++----
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h    |  3 ---
 include/linux/mlx5/driver.h                            |  2 ++
 7 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 0e699330ae77c..060561f633114 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -52,7 +52,7 @@ mlx5_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 	u32 running_fw, stored_fw;
 	int err;
 
-	err = devlink_info_driver_name_put(req, DRIVER_NAME);
+	err = devlink_info_driver_name_put(req, KBUILD_MODNAME);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 6a1b1363ac16a..d3817dd07e3dc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -40,9 +40,7 @@ void mlx5e_ethtool_get_drvinfo(struct mlx5e_priv *priv,
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
 
-	strlcpy(drvinfo->driver, DRIVER_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, DRIVER_VERSION,
-		sizeof(drvinfo->version));
+	strlcpy(drvinfo->driver, KBUILD_MODNAME, sizeof(drvinfo->driver));
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "%d.%d.%04d (%.16s)",
 		 fw_rev_maj(mdev), fw_rev_min(mdev), fw_rev_sub(mdev),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index b991f03c7e991..5a13d47d2c09d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -64,7 +64,6 @@ static void mlx5e_rep_get_drvinfo(struct net_device *dev,
 
 	strlcpy(drvinfo->driver, mlx5e_rep_driver_name,
 		sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, UTS_RELEASE, sizeof(drvinfo->version));
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "%d.%d.%04d (%.16s)",
 		 fw_rev_maj(mdev), fw_rev_min(mdev),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
index 2cf7f0fc170b8..d7bda76507673 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
@@ -39,7 +39,7 @@ static void mlx5i_get_drvinfo(struct net_device *dev,
 	struct mlx5e_priv *priv = mlx5i_epriv(dev);
 
 	mlx5e_ethtool_get_drvinfo(priv, drvinfo);
-	strlcpy(drvinfo->driver, DRIVER_NAME "[ib_ipoib]",
+	strlcpy(drvinfo->driver, KBUILD_MODNAME "[ib_ipoib]",
 		sizeof(drvinfo->driver));
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 22907f6364f54..35e11cb883c97 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -77,7 +77,6 @@
 MODULE_AUTHOR("Eli Cohen <eli@mellanox.com>");
 MODULE_DESCRIPTION("Mellanox 5th generation network adapters (ConnectX series) core driver");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION(DRIVER_VERSION);
 
 unsigned int mlx5_core_debug_mask;
 module_param_named(debug_mask, mlx5_core_debug_mask, uint, 0644);
@@ -228,7 +227,7 @@ static void mlx5_set_driver_version(struct mlx5_core_dev *dev)
 	strncat(string, ",", remaining_size);
 
 	remaining_size = max_t(int, 0, driver_ver_sz - strlen(string));
-	strncat(string, DRIVER_NAME, remaining_size);
+	strncat(string, KBUILD_MODNAME, remaining_size);
 
 	remaining_size = max_t(int, 0, driver_ver_sz - strlen(string));
 	strncat(string, ",", remaining_size);
@@ -313,7 +312,7 @@ static int request_bar(struct pci_dev *pdev)
 		return -ENODEV;
 	}
 
-	err = pci_request_regions(pdev, DRIVER_NAME);
+	err = pci_request_regions(pdev, KBUILD_MODNAME);
 	if (err)
 		dev_err(&pdev->dev, "Couldn't get PCI resources, aborting\n");
 
@@ -1620,7 +1619,7 @@ void mlx5_recover_device(struct mlx5_core_dev *dev)
 }
 
 static struct pci_driver mlx5_core_driver = {
-	.name           = DRIVER_NAME,
+	.name           = KBUILD_MODNAME,
 	.id_table       = mlx5_core_pci_table,
 	.probe          = init_one,
 	.remove         = remove_one,
@@ -1646,6 +1645,9 @@ static int __init mlx5_init(void)
 {
 	int err;
 
+	WARN_ONCE(strcmp(MLX5_ADEV_NAME, KBUILD_MODNAME),
+		  "mlx5_core name not in sync with kernel module name");
+
 	get_random_bytes(&sw_owner_id, sizeof(sw_owner_id));
 
 	mlx5_core_verify_params();
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 8cec85ab419d0..b285f1515e4e8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -42,9 +42,6 @@
 #include <linux/mlx5/fs.h>
 #include <linux/mlx5/driver.h>
 
-#define DRIVER_NAME "mlx5_core"
-#define DRIVER_VERSION "5.0-0"
-
 extern uint mlx5_core_debug_mask;
 
 #define mlx5_core_dbg(__dev, format, ...)				\
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 4f95b98215d81..2cd89af4dbf62 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -56,6 +56,8 @@
 #include <linux/ptp_clock_kernel.h>
 #include <net/devlink.h>
 
+#define MLX5_ADEV_NAME "mlx5_core"
+
 enum {
 	MLX5_BOARD_ID_LEN = 64,
 };
-- 
2.42.0



