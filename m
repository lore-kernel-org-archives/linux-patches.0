Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363AEA93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F27C433EF;
	Tue, 10 Jan 2023 18:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374567;
	bh=WbSEZbiygLJ8vY925beSj9sKHvYADsjiC9HOcj6wBRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+fSSBc0SGrMg1pwPikVd3kosW1G68vCUBnlttr1waaqEViQ4SS0V7GdT97U1vWRs
	 YSqz/74sJy1RU7cXNjNHDcule/6bsmJLYKicnyuIe941iKCQm+a416l8LdzsHEjN/5
	 qEBWz3PrB0xqMsqik7eVIl2klcNzQYz7/6GceAec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mi <cmi@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/159] net/mlx5e: CT: Fix ct debugfs folder name
Date: Tue, 10 Jan 2023 19:03:26 +0100
Message-Id: <20230110180020.161810785@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chris Mi <cmi@nvidia.com>

[ Upstream commit 849190e3e4ccf452fbe2240eace30a9ca83fb8d2 ]

Need to use sprintf to build a string instead of sscanf. Otherwise
dirname is null and both "ct_nic" and "ct_fdb" won't be created.
But its redundant anyway as driver could be in switchdev mode but
still add nic rules. So use "ct" as folder name.

Fixes: 77422a8f6f61 ("net/mlx5e: CT: Add ct driver counters")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 864ce0c393e6..f01f7dfdbcf8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -2080,14 +2080,9 @@ mlx5_tc_ct_init_check_support(struct mlx5e_priv *priv,
 static void
 mlx5_ct_tc_create_dbgfs(struct mlx5_tc_ct_priv *ct_priv)
 {
-	bool is_fdb = ct_priv->ns_type == MLX5_FLOW_NAMESPACE_FDB;
 	struct mlx5_tc_ct_debugfs *ct_dbgfs = &ct_priv->debugfs;
-	char dirname[16] = {};
 
-	if (sscanf(dirname, "ct_%s", is_fdb ? "fdb" : "nic") < 0)
-		return;
-
-	ct_dbgfs->root = debugfs_create_dir(dirname, mlx5_debugfs_get_dev_root(ct_priv->dev));
+	ct_dbgfs->root = debugfs_create_dir("ct", mlx5_debugfs_get_dev_root(ct_priv->dev));
 	debugfs_create_atomic_t("offloaded", 0400, ct_dbgfs->root,
 				&ct_dbgfs->stats.offloaded);
 	debugfs_create_atomic_t("rx_dropped", 0400, ct_dbgfs->root,
-- 
2.35.1



