Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB58E19AA61;
	Thu,  6 Jun 2024 14:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683308; cv=none; b=YkQG98U0aZOq06SOmcSM44HlPS6FpZzMzcqukocR6G3ma0QQhlKsnOgoOA9epO7E5XP8vCIBR6H2uUNxjJ8gU9l8x7PBxGJavtItimgqtBVaa0TxmDj2mfDITM1b8kgKkc5vkMLK1vxU0DEWQBOHHwLMB/mEdSwNvY3DvikghOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683308; c=relaxed/simple;
	bh=8Yf+9dbgnmGSx0Eo5xseFkSJh+dqf7bfIVogkWloHIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=em7AS0PRMYZo6HcLK1/NcU8qpf9cWeurKq792KSU7c3GPq9cdzyyDqGqgJA3Z64bq700kKk6yaOa9tOMN6xIzTAu6tofPGslObXqejip3l70l1lSdfO5dXzfpGdQkMyZtTTlgJ6JuE14wd4oAocQX1Sal4GgTrX/8XkEqePS7Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STnlclku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STnlclku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C21CC2BD10;
	Thu,  6 Jun 2024 14:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683308;
	bh=8Yf+9dbgnmGSx0Eo5xseFkSJh+dqf7bfIVogkWloHIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STnlclkuLmDgPFtq9TGgKdQgXw6ArljZKg3OPJAPXymqLqphX0/grSegp9GStbfSv
	 MnxfjN3JNhRAvSVZUWD4lx9DtJKThCHUnzN+K09bGHRMJQTP2C3BBJANbAvECMpRP/
	 GCN671D8giVtTmwgeGLC4+6qBkjeFcRwhtcOMQok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 249/744] net/mlx5: Enable 4 ports multiport E-switch
Date: Thu,  6 Jun 2024 15:58:41 +0200
Message-ID: <20240606131740.389929632@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit e738e355045237ee8802cb2b31a8ed6f4b7ac534 ]

enable_mpesw() assumed only 2 ports are available, fix this by removing
that assumption and looping through the existing lag ports to enable multi-port
E-switch for cards with more than 2 ports.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 0f06228d4a2d ("net/mlx5: Reload only IB representors upon lag disable/enable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/lag/mpesw.c    | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index 4bf15391525c5..0857eebf4f07b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -65,12 +65,12 @@ static int mlx5_mpesw_metadata_set(struct mlx5_lag *ldev)
 	return err;
 }
 
-#define MLX5_LAG_MPESW_OFFLOADS_SUPPORTED_PORTS 2
+#define MLX5_LAG_MPESW_OFFLOADS_SUPPORTED_PORTS 4
 static int enable_mpesw(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
-	struct mlx5_core_dev *dev1 = ldev->pf[MLX5_LAG_P2].dev;
 	int err;
+	int i;
 
 	if (ldev->mode != MLX5_LAG_MODE_NONE)
 		return -EINVAL;
@@ -98,11 +98,11 @@ static int enable_mpesw(struct mlx5_lag *ldev)
 
 	dev0->priv.flags &= ~MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
 	mlx5_rescan_drivers_locked(dev0);
-	err = mlx5_eswitch_reload_reps(dev0->priv.eswitch);
-	if (!err)
-		err = mlx5_eswitch_reload_reps(dev1->priv.eswitch);
-	if (err)
-		goto err_rescan_drivers;
+	for (i = 0; i < ldev->ports; i++) {
+		err = mlx5_eswitch_reload_reps(ldev->pf[i].dev->priv.eswitch);
+		if (err)
+			goto err_rescan_drivers;
+	}
 
 	return 0;
 
@@ -112,8 +112,8 @@ static int enable_mpesw(struct mlx5_lag *ldev)
 	mlx5_deactivate_lag(ldev);
 err_add_devices:
 	mlx5_lag_add_devices(ldev);
-	mlx5_eswitch_reload_reps(dev0->priv.eswitch);
-	mlx5_eswitch_reload_reps(dev1->priv.eswitch);
+	for (i = 0; i < ldev->ports; i++)
+		mlx5_eswitch_reload_reps(ldev->pf[i].dev->priv.eswitch);
 	mlx5_mpesw_metadata_cleanup(ldev);
 	return err;
 }
-- 
2.43.0



