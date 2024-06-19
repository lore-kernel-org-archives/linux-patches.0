Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570F1144D3E;
	Wed, 19 Jun 2024 13:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803557; cv=none; b=kWyjVrs5OiTTBxg1cV+5Fu24YxsxjLJsaMmd2feXIJJCfEQOxbOPX8he/QGvdo1xkkKwtq6623Qkt47WEDYjmqm6VJ/N7rfsmcnj+ET8WwzAYnFW/0rUIwmNCLtRqEeyncNgns2Yph2gdnWbG/08EuXYsTo//0qZJbABDwoFbvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803557; c=relaxed/simple;
	bh=IReF9dQS0YFF5S1jsqGxopsCLfGwiBEbYlg9DkAto9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPUEy2Qu+hDgc6cGqEF34729hy3CFTxeNqiz3tp5UqqSsYyNxkQnr3bEKzHQ7lMEK1mMtuTiMf6jm+TqunJuSumjjbp4id6esNLSPiAjWIQC3Q6xZhkcCQy1JNImah0IeEhbaSySTch3qH/NV/lEQT22uxutB3+6kMSWfGUlecA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VEBdVLdW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VEBdVLdW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A916C2BBFC;
	Wed, 19 Jun 2024 13:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803556;
	bh=IReF9dQS0YFF5S1jsqGxopsCLfGwiBEbYlg9DkAto9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VEBdVLdWXT1d8TUMehycLT5vUXRzLOLN07219hNjabR5ul9PWG+Qy7fhh0QYvFNQU
	 DtxqniGppLW/pAA0o6LjuwAxShm5ksKM1ROECssQn3Nzp0/V7KdbxAyfBQ96d2aDDp
	 OY7vuQibGdG6eMjSRJoP/6P+hsXV0L7xdSUwy3xI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/217] net/mlx5: Split function_setup() to enable and open functions
Date: Wed, 19 Jun 2024 14:54:28 +0200
Message-ID: <20240619125557.620438027@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 2059cf51f318681a4cdd3eb1a01a2d62b6a9c442 ]

mlx5_cmd_init_hca() is taking ~0.2 seconds. In case of a user who
desire to disable some of the SF aux devices, and with large scale-1K
SFs for example, this user will waste more than 3 minutes on
mlx5_cmd_init_hca() which isn't needed at this stage.

Downstream patch will change SFs which are probe over the E-switch,
local SFs, to be probed without any aux dev. In order to support this,
split function_setup() to avoid executing mlx5_cmd_init_hca().

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: c8b3f38d2dae ("net/mlx5: Always stop health timer during driver removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 83 +++++++++++++------
 1 file changed, 58 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 6ab0642e9de78..fe0a78c29438b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1093,7 +1093,7 @@ static void mlx5_cleanup_once(struct mlx5_core_dev *dev)
 	mlx5_devcom_unregister_device(dev->priv.devcom);
 }
 
-static int mlx5_function_setup(struct mlx5_core_dev *dev, bool boot, u64 timeout)
+static int mlx5_function_enable(struct mlx5_core_dev *dev, bool boot, u64 timeout)
 {
 	int err;
 
@@ -1158,28 +1158,56 @@ static int mlx5_function_setup(struct mlx5_core_dev *dev, bool boot, u64 timeout
 		goto reclaim_boot_pages;
 	}
 
+	return 0;
+
+reclaim_boot_pages:
+	mlx5_reclaim_startup_pages(dev);
+err_disable_hca:
+	mlx5_core_disable_hca(dev, 0);
+stop_health_poll:
+	mlx5_stop_health_poll(dev, boot);
+err_cmd_cleanup:
+	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
+	mlx5_cmd_cleanup(dev);
+
+	return err;
+}
+
+static void mlx5_function_disable(struct mlx5_core_dev *dev, bool boot)
+{
+	mlx5_reclaim_startup_pages(dev);
+	mlx5_core_disable_hca(dev, 0);
+	mlx5_stop_health_poll(dev, boot);
+	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
+	mlx5_cmd_cleanup(dev);
+}
+
+static int mlx5_function_open(struct mlx5_core_dev *dev)
+{
+	int err;
+
 	err = set_hca_ctrl(dev);
 	if (err) {
 		mlx5_core_err(dev, "set_hca_ctrl failed\n");
-		goto reclaim_boot_pages;
+		return err;
 	}
 
 	err = set_hca_cap(dev);
 	if (err) {
 		mlx5_core_err(dev, "set_hca_cap failed\n");
-		goto reclaim_boot_pages;
+		return err;
 	}
 
 	err = mlx5_satisfy_startup_pages(dev, 0);
 	if (err) {
 		mlx5_core_err(dev, "failed to allocate init pages\n");
-		goto reclaim_boot_pages;
+		return err;
 	}
 
 	err = mlx5_cmd_init_hca(dev, sw_owner_id);
 	if (err) {
 		mlx5_core_err(dev, "init hca failed\n");
-		goto reclaim_boot_pages;
+		return err;
 	}
 
 	mlx5_set_driver_version(dev);
@@ -1187,26 +1215,13 @@ static int mlx5_function_setup(struct mlx5_core_dev *dev, bool boot, u64 timeout
 	err = mlx5_query_hca_caps(dev);
 	if (err) {
 		mlx5_core_err(dev, "query hca failed\n");
-		goto reclaim_boot_pages;
+		return err;
 	}
 	mlx5_start_health_fw_log_up(dev);
-
 	return 0;
-
-reclaim_boot_pages:
-	mlx5_reclaim_startup_pages(dev);
-err_disable_hca:
-	mlx5_core_disable_hca(dev, 0);
-stop_health_poll:
-	mlx5_stop_health_poll(dev, boot);
-err_cmd_cleanup:
-	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
-	mlx5_cmd_cleanup(dev);
-
-	return err;
 }
 
-static int mlx5_function_teardown(struct mlx5_core_dev *dev, bool boot)
+static int mlx5_function_close(struct mlx5_core_dev *dev)
 {
 	int err;
 
@@ -1215,15 +1230,33 @@ static int mlx5_function_teardown(struct mlx5_core_dev *dev, bool boot)
 		mlx5_core_err(dev, "tear_down_hca failed, skip cleanup\n");
 		return err;
 	}
-	mlx5_reclaim_startup_pages(dev);
-	mlx5_core_disable_hca(dev, 0);
-	mlx5_stop_health_poll(dev, boot);
-	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
-	mlx5_cmd_cleanup(dev);
 
 	return 0;
 }
 
+static int mlx5_function_setup(struct mlx5_core_dev *dev, bool boot, u64 timeout)
+{
+	int err;
+
+	err = mlx5_function_enable(dev, boot, timeout);
+	if (err)
+		return err;
+
+	err = mlx5_function_open(dev);
+	if (err)
+		mlx5_function_disable(dev, boot);
+	return err;
+}
+
+static int mlx5_function_teardown(struct mlx5_core_dev *dev, bool boot)
+{
+	int err = mlx5_function_close(dev);
+
+	if (!err)
+		mlx5_function_disable(dev, boot);
+	return err;
+}
+
 static int mlx5_load(struct mlx5_core_dev *dev)
 {
 	int err;
-- 
2.43.0



