Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C5D2980A8;
	Mon, 23 Mar 2026 16:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282458; cv=none; b=pHth16DPCwgGYlmMgEV5qAi9rWGk8RuOGAJuZZbXs3ZS23hfS6xr+X9zYSHikWSQy/LRzfpGsCdozdqfl+bY3x7SqbYZpkAXQInrAZpjxdF1arQknxjHef5CQHvifRim/GvbM1DL0hEntIDbkDYvF+iiimOxVzP4pXm0MPJnyCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282458; c=relaxed/simple;
	bh=LVOeXSx6pakpFEXfRDyC1ljLW61TH4Gi1p1qmVKHb8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pChk1Um/bCJ6MEztgVg7QBPPY1Muw/y95GX8X6Bw49mtYN/I7UKFAVRZb8OymOy4YiHEqLGOlYFtXzslJpWfPdhsPh05PmG5AMWVck3GZcnBlrsmS95FoW3kaWnn5BQKRlXhsBYuFyrgzkjhl2+Cg3+tk9ElMEt7jkNp+9QP894=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=stgDSqkp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="stgDSqkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C880C4CEF7;
	Mon, 23 Mar 2026 16:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282458;
	bh=LVOeXSx6pakpFEXfRDyC1ljLW61TH4Gi1p1qmVKHb8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=stgDSqkpYBlLn1enPn6vrtAExNNds2sZu64tB5tssY0FzPdewfFYxhtrxbzw/p2ZA
	 23a3vvKDvZ+kwAACZUjcsgW/14qeoIl5CFpEhZRmwEOk3HbCMCp1M8D8uHQnr+3C35
	 EDjIEq083YIZsHK/ylkZTn3knb3vsdrlB7+a111Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Jurgens <danielj@nvidia.com>,
	William Tu <witu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 164/481] net/mlx5: Query to see if host PF is disabled
Date: Mon, 23 Mar 2026 14:42:26 +0100
Message-ID: <20260323134529.227649335@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Jurgens <danielj@nvidia.com>

[ Upstream commit 9e84de72aef9bcf0e751a0bff3ac91b0cf52366f ]

The host PF can be disabled, query firmware to check if the host PF of
this function exists.

Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Reviewed-by: William Tu <witu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1755112796-467444-2-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: aed763abf0e9 ("net/mlx5: Fix deadlock between devlink lock and esw->wq")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 23 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 2 files changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 9ba825df9be0e..3255af4313a29 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -969,6 +969,25 @@ const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *dev)
 	return ERR_PTR(err);
 }
 
+static int mlx5_esw_host_functions_enabled_query(struct mlx5_eswitch *esw)
+{
+	const u32 *query_host_out;
+
+	if (!mlx5_core_is_ecpf_esw_manager(esw->dev))
+		return 0;
+
+	query_host_out = mlx5_esw_query_functions(esw->dev);
+	if (IS_ERR(query_host_out))
+		return PTR_ERR(query_host_out);
+
+	esw->esw_funcs.host_funcs_disabled =
+		MLX5_GET(query_esw_functions_out, query_host_out,
+			 host_params_context.host_pf_not_exist);
+
+	kvfree(query_host_out);
+	return 0;
+}
+
 static void mlx5_eswitch_event_handler_register(struct mlx5_eswitch *esw)
 {
 	if (esw->mode == MLX5_ESWITCH_OFFLOADS && mlx5_eswitch_is_funcs_handler(esw->dev)) {
@@ -1596,6 +1615,10 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 		goto abort;
 	}
 
+	err = mlx5_esw_host_functions_enabled_query(esw);
+	if (err)
+		goto abort;
+
 	err = mlx5_esw_vports_init(esw);
 	if (err)
 		goto abort;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index a3daca44f74b1..ff20b43a551de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -279,6 +279,7 @@ struct mlx5_host_work {
 
 struct mlx5_esw_functions {
 	struct mlx5_nb		nb;
+	bool			host_funcs_disabled;
 	u16			num_vfs;
 };
 
-- 
2.51.0



