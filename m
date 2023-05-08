Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BB6168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DCF3C433EF;
	Mon,  8 May 2023 11:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544608;
	bh=rV8o0NwuPaC8QPs0IXNsdZZemB1XzchG6OoZm81iUXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjcdS7jANVLt86otYld33PWNmNSGZflMV3AOXM8g+1gEjDugtOcQB28CPiEnf89ov
	 YKDKXiuRbQJ9Tnh01kLALXjxDuSLq8lxrxoyFSpEF5M+r6iSqcj4Ug5xB1DTkAIC2l
	 nJEjdAeQ2/IqA7taChwzftwV7BQI9LlLDoO78vR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roi Dayan <roid@nvidia.com>,
	Maor Dickman <maord@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 465/694] net/mlx5e: Fix error flow in representor failing to add vport rx rule
Date: Mon,  8 May 2023 11:45:00 +0200
Message-Id: <20230508094448.808445971@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roi Dayan <roid@nvidia.com>

[ Upstream commit 0a6b069cc60d68d33b4f6e7dd7f1adc3ec749766 ]

On representor init rx error flow the flow steering pointer is being
released so mlx5e_attach_netdev() doesn't have a valid fs pointer
in its error flow. Make sure the pointer is nullified when released
and add a check in mlx5e_fs_cleanup() to verify fs is not null
as representor cleanup callback would be called anyway.

Fixes: af8bbf730068 ("net/mlx5e: Convert mlx5e_flow_steering member of mlx5e_priv to pointer")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c   | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c  | 2 ++
 3 files changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 05796f8b1d7cf..f1dac0244958c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -1490,6 +1490,8 @@ struct mlx5e_flow_steering *mlx5e_fs_init(const struct mlx5e_profile *profile,
 
 void mlx5e_fs_cleanup(struct mlx5e_flow_steering *fs)
 {
+	if (!fs)
+		return;
 	debugfs_remove_recursive(fs->dfs_root);
 	mlx5e_fs_ethtool_free(fs);
 	mlx5e_fs_tc_free(fs);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 7ca7e9b57607f..579c2d217fdc6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5270,6 +5270,7 @@ static void mlx5e_nic_cleanup(struct mlx5e_priv *priv)
 	mlx5e_health_destroy_reporters(priv);
 	mlx5e_ktls_cleanup(priv);
 	mlx5e_fs_cleanup(priv->fs);
+	priv->fs = NULL;
 }
 
 static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 8ff654b4e9e14..6e18d91c3d766 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -828,6 +828,7 @@ static int mlx5e_init_ul_rep(struct mlx5_core_dev *mdev,
 static void mlx5e_cleanup_rep(struct mlx5e_priv *priv)
 {
 	mlx5e_fs_cleanup(priv->fs);
+	priv->fs = NULL;
 }
 
 static int mlx5e_create_rep_ttc_table(struct mlx5e_priv *priv)
@@ -994,6 +995,7 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 	priv->rx_res = NULL;
 err_free_fs:
 	mlx5e_fs_cleanup(priv->fs);
+	priv->fs = NULL;
 	return err;
 }
 
-- 
2.39.2



