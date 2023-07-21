Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46681F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CD6C433C8;
	Fri, 21 Jul 2023 16:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955795;
	bh=exfTTuL1r35pbPi24rTY/nPJMkAbb3MJ6CoKZJRhvdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2IwxqgNOGNXj0xYOacjFeDuw1KRC8z27+OADZKZFUm9MYp+G3j186lWk5u+5AX9a/
	 tmk/Cpt2L3jbvV3Yl82rzqceBlG06lOEu1ExUNoLrWlGY1Q1NEUwLaDfJEz2lpjs8j
	 RkG2/1ZXBdUhogsFjnOoP2HSOkauwaWMH/7q7AmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 033/292] net/mlx5: Query hca_cap_2 only when supported
Date: Fri, 21 Jul 2023 18:02:22 +0200
Message-ID: <20230721160530.225902730@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maher Sanalla <msanalla@nvidia.com>

[ Upstream commit 6496357aa5f710eec96f91345b9da1b37c3231f6 ]

On vport enable, where fw's hca caps are queried, the driver queries
hca_caps_2 without checking if fw truly supports them, causing a false
failure of vfs vport load and blocking SRIOV enablement on old devices
such as CX4 where hca_caps_2 support is missing.

Thus, add a check for the said caps support before accessing them.

Fixes: e5b9642a33be ("net/mlx5: E-Switch, Implement devlink port function cmds to control migratable")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 901c53751b0aa..f81c6d8d5e0f4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -800,6 +800,9 @@ static int mlx5_esw_vport_caps_get(struct mlx5_eswitch *esw, struct mlx5_vport *
 	hca_caps = MLX5_ADDR_OF(query_hca_cap_out, query_ctx, capability);
 	vport->info.roce_enabled = MLX5_GET(cmd_hca_cap, hca_caps, roce);
 
+	if (!MLX5_CAP_GEN_MAX(esw->dev, hca_cap_2))
+		goto out_free;
+
 	memset(query_ctx, 0, query_out_sz);
 	err = mlx5_vport_get_other_func_cap(esw->dev, vport->vport, query_ctx,
 					    MLX5_CAP_GENERAL_2);
-- 
2.39.2



