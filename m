Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4043033EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92BFC433D2;
	Mon, 16 Jan 2023 16:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884817;
	bh=lZVgaUAg9pbyCOMu78NzV16NsGp3ONE17m2NulhRf6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c+XWyVDqwi7FWsxLCeFvzw3uXtcv6oScRWXZl90YAxIdr4qM9clb1XgsjW7vbCnsV
	 +QjsHNyqum04OhqSVz0rrc+0yEuuiOpzyA18ZDFqtG1t7i27+Rfhz6Y7Fj4Ih93RUw
	 REAtuLC57BAxSBQVRTtQpSVR9BUouH1v2HMMYGcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ariel Levkovich <lariel@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 151/183] net/mlx5e: TC, Keep mod hdr actions after mod hdr alloc
Date: Mon, 16 Jan 2023 16:51:14 +0100
Message-Id: <20230116154809.713043243@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ariel Levkovich <lariel@nvidia.com>

[ Upstream commit 5e72f3f1c558019082cfeedeed73748f35d780c6 ]

When offloading TC NIC rule which has mod_hdr action, the
mod_hdr actions list is freed upon mod_hdr allocation.

In the new format of handling multi table actions and CT in
particular, the mod_hdr actions list is still relevant when
setting the pre and post rules and therefore, freeing the list
may cause adding rules which don't set the FTE_ID.

Therefore, the mod_hdr actions list needs to be kept for the
pre/post flows as well and should be left for these handler to
be freed.

Fixes: 8300f225268b ("net/mlx5e: Create new flow attr for multi table actions")
Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index bd9936af4582..4c313b7424bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1283,7 +1283,6 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
 		err = mlx5e_attach_mod_hdr(priv, flow, parse_attr);
-		mlx5e_mod_hdr_dealloc(&parse_attr->mod_hdr_acts);
 		if (err)
 			return err;
 	}
@@ -1341,8 +1340,10 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 	}
 	mutex_unlock(&tc->t_lock);
 
-	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
+	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
+		mlx5e_mod_hdr_dealloc(&attr->parse_attr->mod_hdr_acts);
 		mlx5e_detach_mod_hdr(priv, flow);
+	}
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT)
 		mlx5_fc_destroy(priv->mdev, attr->counter);
-- 
2.35.1



