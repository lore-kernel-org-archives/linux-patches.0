Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7540C264A76;
	Tue,  8 Apr 2025 11:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110933; cv=none; b=FOs/LvqTOyMZNghb92lA/UEQ4La9S20mgxPObOuMbVm/N8CL6KJAujL6V8GK2c1svxRGVNHqxEMOo/gx8Vqx2yZeCxDb5bf4i1zt2AQ/I7yg/ojBEA0e4YlGwRcYfn8wXOtjsGKSu1vmk3Npr5FAqxsb8bd123BtEtVZTf3cVfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110933; c=relaxed/simple;
	bh=9y+ukwB+Bbm6geLKXLhUZQcKufthAWEzLnp6u/hSkGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WI2Oq78uJt6GufC+bkumJMx7Rbv4g7/2cpFPF2FgwQjj2wNfX6xzn+C2HzpGuX8gAWglBrqiln8hKFse/DfgsLSYCLsuhVluolV0Z+v2Nn7nHxKZnS1ZHBLUBZnAV92InRUC+4Rd8wUSJ4cfw59tqDT9qZWmjNWj4e3uKxUgxkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h+JX/M4c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h+JX/M4c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C1AC4CEE5;
	Tue,  8 Apr 2025 11:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110932;
	bh=9y+ukwB+Bbm6geLKXLhUZQcKufthAWEzLnp6u/hSkGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h+JX/M4cMccLg+LzXHZQyhDbrWcV0L4kWDay9TG0jHXGOB+/Y0UDRH/9CXj+EmRfY
	 o1FuRlFK94s8Qm1xYsKhuApB/RalL1IBKUGwdZCzH2H8FsJCpyz9mtM4pgSeSPqSoh
	 ssbqalao5V8CkgClcR+CSgOhB11AfBOy+zD8VFxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 247/731] net/mlx5: Start health poll after enable hca
Date: Tue,  8 Apr 2025 12:42:24 +0200
Message-ID: <20250408104920.028963267@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit 1726ad035cb0c93cc5c3f2227ec71322ccd7c2f8 ]

The health poll mechanism performs periodic checks to detect firmware
errors. One of the checks verifies the function is still enabled on
firmware side, but the function is enabled only after enable_hca command
completed. Start health poll after enable_hca command to avoid a race
between function enabled and first health polling.

Fixes: 9b98d395b85d ("net/mlx5: Start health poll at earlier stage of driver load")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Link: https://patch.msgid.link/1742331077-102038-3-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index ec956c4bcebdb..7c3312d6aed9b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1205,24 +1205,24 @@ static int mlx5_function_enable(struct mlx5_core_dev *dev, bool boot, u64 timeou
 	dev->caps.embedded_cpu = mlx5_read_embedded_cpu(dev);
 	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_UP);
 
-	mlx5_start_health_poll(dev);
-
 	err = mlx5_core_enable_hca(dev, 0);
 	if (err) {
 		mlx5_core_err(dev, "enable hca failed\n");
-		goto stop_health_poll;
+		goto err_cmd_cleanup;
 	}
 
+	mlx5_start_health_poll(dev);
+
 	err = mlx5_core_set_issi(dev);
 	if (err) {
 		mlx5_core_err(dev, "failed to set issi\n");
-		goto err_disable_hca;
+		goto stop_health_poll;
 	}
 
 	err = mlx5_satisfy_startup_pages(dev, 1);
 	if (err) {
 		mlx5_core_err(dev, "failed to allocate boot pages\n");
-		goto err_disable_hca;
+		goto stop_health_poll;
 	}
 
 	err = mlx5_tout_query_dtor(dev);
@@ -1235,10 +1235,9 @@ static int mlx5_function_enable(struct mlx5_core_dev *dev, bool boot, u64 timeou
 
 reclaim_boot_pages:
 	mlx5_reclaim_startup_pages(dev);
-err_disable_hca:
-	mlx5_core_disable_hca(dev, 0);
 stop_health_poll:
 	mlx5_stop_health_poll(dev, boot);
+	mlx5_core_disable_hca(dev, 0);
 err_cmd_cleanup:
 	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
 	mlx5_cmd_disable(dev);
@@ -1249,8 +1248,8 @@ static int mlx5_function_enable(struct mlx5_core_dev *dev, bool boot, u64 timeou
 static void mlx5_function_disable(struct mlx5_core_dev *dev, bool boot)
 {
 	mlx5_reclaim_startup_pages(dev);
-	mlx5_core_disable_hca(dev, 0);
 	mlx5_stop_health_poll(dev, boot);
+	mlx5_core_disable_hca(dev, 0);
 	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
 	mlx5_cmd_disable(dev);
 }
-- 
2.39.5



