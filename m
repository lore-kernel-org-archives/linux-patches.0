Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0274B26CE32;
	Mon, 13 Apr 2026 16:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098200; cv=none; b=oUj6+EBe2aQPO4/Z8vNhNfkFQPR8O4dg7nbFL9KnXSLd3TVFEIe/UZ69V0xYoeqbUC4Ynw1JrXk+rfxBdW6KYFCEva3lM5EY7zQhsnr+lLagyKfIU46Dxb4LFN3kmEtl6KFWkg8kVdnSeivllBd6TGjAUyPzgDuNJibDevWeluQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098200; c=relaxed/simple;
	bh=BmZE4SpmsmK1lpRi7JijTMxssqkUs5/lMCpwISU+XfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rP13fbgbnuLLw3tRJN6RT6CzzKDLkhrDMM+hYoDvk6v02tyrXFsGvP3OQ0Sb4McD0UGt/flWFbtcrHq2Km7Roxbfi2TxlLAElbZroLhdws5jzgcgssyhMu6pUWMa+R9kND4TU8UMBircj+WPM2CH6Ujz3iDOXHTqh5Vjb0iCPmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sV6A8k/8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sV6A8k/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86BACC2BCAF;
	Mon, 13 Apr 2026 16:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098199;
	bh=BmZE4SpmsmK1lpRi7JijTMxssqkUs5/lMCpwISU+XfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sV6A8k/8NrIz/ldtxHzB3XKw9aMXZjdyr7t1WOvJd2rAHhier/xiPQBqqlT9sFNki
	 BXEBNi5VV+mWILXb3n4T7OYDBpVsm2tKAs4Vy5HmBuAykb7Orq0zSmi56kASOrf1mn
	 cHN6JxwCt28Yk+cthr0T6r6uVRbLQW0ym6t/P1NE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saeed Mahameed <saeedm@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 431/570] net/mlx5: Avoid "No data available" when FW version queries fail
Date: Mon, 13 Apr 2026 17:59:22 +0200
Message-ID: <20260413155846.616743213@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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
index 7d56a927081d0..e8a676b08e4b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -54,9 +54,7 @@ mlx5_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 	if (err)
 		return err;
 
-	err = mlx5_fw_version_query(dev, &running_fw, &stored_fw);
-	if (err)
-		return err;
+	mlx5_fw_version_query(dev, &running_fw, &stored_fw);
 
 	snprintf(version_str, sizeof(version_str), "%d.%d.%04d",
 		 mlx5_fw_ver_major(running_fw), mlx5_fw_ver_minor(running_fw),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index 016d26f809a59..31ef43f871308 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -776,48 +776,63 @@ mlx5_fw_image_pending(struct mlx5_core_dev *dev,
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
index 3f3ea8d268ce4..1c047c5e5fb02 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -206,8 +206,8 @@ void mlx5_dm_cleanup(struct mlx5_core_dev *dev);
 
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



