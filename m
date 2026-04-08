Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2162D346FB0;
	Wed,  8 Apr 2026 18:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673795; cv=none; b=IyhBsxVmyxsv9y0SoJikmCV9TaOaoXr1gTI/0Dpag0AvVKZXxu8J6WlyYMQIkpYQpVqKKu1iMsxzLUrHEnxL8NGuCZm7cpjEXo5NYuTC5KLFoV+eMFcvFjSmpbgl0q0vg9EvhnSPoqoT3GpEVCAWLPaA8QCulkWXG/eFAgByt28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673795; c=relaxed/simple;
	bh=jKfV0+29pY/80e5xQ0SARaWH9wnQmsaqeLUK8ibiOlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NprmekPJ0DYgHu9qO/EmxGny5omtZ9c+C//Vt4c9u7wqc3ZTlQK91WgO234USa9E4WbuYWtd2O6H1+ELIaT/VEo+skpQyniJ3TPTtrdHQ6VfR/fLav0sxpXzGmp+iZ4oaOk/D7orqwnBK/SuYrhX/1pJ6gaHNgwE5M4UEMW7IFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O164vmmx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O164vmmx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8F1C19421;
	Wed,  8 Apr 2026 18:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673795;
	bh=jKfV0+29pY/80e5xQ0SARaWH9wnQmsaqeLUK8ibiOlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O164vmmx3Tawxb/BXHVMBnPb32A6ru1GMLAlu/HX6MOWtyciywwSDHoFFSe5GNkAd
	 PXjolDUO4OUu8R5VUoZTjZWnCshsmJYlzv6ZmIhGmwOZ42vOb97+SK8JUu0FMJj6lQ
	 VXQd2QczHyjPJ5B8OJxoOBkEv4dxggOzZyOg+Kak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saeed Mahameed <saeedm@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 092/242] net/mlx5: Avoid "No data available" when FW version queries fail
Date: Wed,  8 Apr 2026 20:02:12 +0200
Message-ID: <20260408175930.528267034@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Saeed Mahameed <saeedm@nvidia.com>

[ Upstream commit 10dc35f6a443d488f219d1a1e3fb8f8dac422070 ]

Avoid printing the misleading "kernel answers: No data available" devlink
output when querying firmware or pending firmware version fails
(e.g. MLX5 fw state errors / flash failures).

FW can fail on loading the pending flash image and get its version due
to various reasons, examples:

mlxfw: Firmware flash failed: key not applicable, err (7)
mlx5_fw_image_pending: can't read pending fw version while fw state is 1

and the resulting:
$ devlink dev info
kernel answers: No data available

Instead, just report 0 or 0xfff.. versions in case of failure to indicate
a problem, and let other information be shown.

after the fix:
$ devlink dev info
pci/0000:00:06.0:
  driver mlx5_core
  serial_number xxx...
  board.serial_number MT2225300179
  versions:
      fixed:
        fw.psid MT_0000000436
      running:
        fw.version 22.41.0188
        fw 22.41.0188
      stored:
        fw.version 255.255.65535
        fw 255.255.65535

Fixes: 9c86b07e3069 ("net/mlx5: Added fw version query command")
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260330194015.53585-3-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  | 53 ++++++++++++-------
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  4 +-
 3 files changed, 37 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index e9d49afc31db5..0a818bddd0e2f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -53,9 +53,7 @@ mlx5_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 	if (err)
 		return err;
 
-	err = mlx5_fw_version_query(dev, &running_fw, &stored_fw);
-	if (err)
-		return err;
+	mlx5_fw_version_query(dev, &running_fw, &stored_fw);
 
 	snprintf(version_str, sizeof(version_str), "%d.%d.%04d",
 		 mlx5_fw_ver_major(running_fw), mlx5_fw_ver_minor(running_fw),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index 76ad46bf477d6..5b0c98642b997 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -803,48 +803,63 @@ mlx5_fw_image_pending(struct mlx5_core_dev *dev,
 	return 0;
 }
 
-int mlx5_fw_version_query(struct mlx5_core_dev *dev,
-			  u32 *running_ver, u32 *pending_ver)
+void mlx5_fw_version_query(struct mlx5_core_dev *dev,
+			   u32 *running_ver, u32 *pending_ver)
 {
 	u32 reg_mcqi_version[MLX5_ST_SZ_DW(mcqi_version)] = {};
 	bool pending_version_exists;
 	int component_index;
 	int err;
 
+	*running_ver = 0;
+	*pending_ver = 0;
+
 	if (!MLX5_CAP_GEN(dev, mcam_reg) || !MLX5_CAP_MCAM_REG(dev, mcqi) ||
 	    !MLX5_CAP_MCAM_REG(dev, mcqs)) {
 		mlx5_core_warn(dev, "fw query isn't supported by the FW\n");
-		return -EOPNOTSUPP;
+		return;
 	}
 
 	component_index = mlx5_get_boot_img_component_index(dev);
-	if (component_index < 0)
-		return component_index;
+	if (component_index < 0) {
+		mlx5_core_warn(dev, "fw query failed to find boot img component index, err %d\n",
+			       component_index);
+		return;
+	}
 
+	*running_ver = U32_MAX; /* indicate failure */
 	err = mlx5_reg_mcqi_version_query(dev, component_index,
 					  MCQI_FW_RUNNING_VERSION,
 					  reg_mcqi_version);
-	if (err)
-		return err;
-
-	*running_ver = MLX5_GET(mcqi_version, reg_mcqi_version, version);
-
+	if (!err)
+		*running_ver = MLX5_GET(mcqi_version, reg_mcqi_version,
+					version);
+	else
+		mlx5_core_warn(dev, "failed to query running version, err %d\n",
+			       err);
+
+	*pending_ver = U32_MAX; /* indicate failure */
 	err = mlx5_fw_image_pending(dev, component_index, &pending_version_exists);
-	if (err)
-		return err;
+	if (err) {
+		mlx5_core_warn(dev, "failed to query pending image, err %d\n",
+			       err);
+		return;
+	}
 
 	if (!pending_version_exists) {
 		*pending_ver = 0;
-		return 0;
+		return;
 	}
 
 	err = mlx5_reg_mcqi_version_query(dev, component_index,
 					  MCQI_FW_STORED_VERSION,
 					  reg_mcqi_version);
-	if (err)
-		return err;
-
-	*pending_ver = MLX5_GET(mcqi_version, reg_mcqi_version, version);
-
-	return 0;
+	if (!err)
+		*pending_ver = MLX5_GET(mcqi_version, reg_mcqi_version,
+					version);
+	else
+		mlx5_core_warn(dev, "failed to query pending version, err %d\n",
+			       err);
+
+	return;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 6b82a494bd323..1ca75f1815ef6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -373,8 +373,8 @@ int mlx5_port_max_linkspeed(struct mlx5_core_dev *mdev, u32 *speed);
 
 int mlx5_firmware_flash(struct mlx5_core_dev *dev, const struct firmware *fw,
 			struct netlink_ext_ack *extack);
-int mlx5_fw_version_query(struct mlx5_core_dev *dev,
-			  u32 *running_ver, u32 *stored_ver);
+void mlx5_fw_version_query(struct mlx5_core_dev *dev, u32 *running_ver,
+			   u32 *stored_ver);
 
 #ifdef CONFIG_MLX5_CORE_EN
 int mlx5e_init(void);
-- 
2.53.0



