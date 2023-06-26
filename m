Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F8F134C7
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:19:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C437C433C8;
	Mon, 26 Jun 2023 18:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803586;
	bh=sVyZqpF7fzC+gxBXwy4sp60KSygFA90ZoXB5NBOGBKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EldzHg1PeFVLqejBGifWvnnrntfmKzzT60rEx/Ah8ME61TCPHszxyvO2sqgXJ5GmG
	 CGpzeQhMznRG3B1FBlCaGRnGn5Jt0CiezSsnRRQd/a8kKziYYYBBfA5W/rS/NYqHCQ
	 BG0ya1zX7ezXVqxn5p68CAxzpODQiD/2n/OSLOgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Alex Vesker <valex@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 111/199] net/mlx5: DR, Fix wrong action data allocation in decap action
Date: Mon, 26 Jun 2023 20:10:17 +0200
Message-ID: <20230626180810.518715518@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit ef4c5afc783dc3d47640270a9b94713229c697e8 ]

When TUNNEL_L3_TO_L2 decap action was created, a pointer to a local
variable was passed as its HW action data, resulting in attempt to
free invalid address:

  BUG: KASAN: invalid-free in mlx5dr_action_destroy+0x318/0x410 [mlx5_core]

Fixes: 4781df92f4da ("net/mlx5: DR, Move STEv0 modify header logic")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_action.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index ee104cf04392f..438c3bfae762a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -1403,9 +1403,13 @@ dr_action_create_reformat_action(struct mlx5dr_domain *dmn,
 	}
 	case DR_ACTION_TYP_TNL_L3_TO_L2:
 	{
-		u8 hw_actions[ACTION_CACHE_LINE_SIZE] = {};
+		u8 *hw_actions;
 		int ret;
 
+		hw_actions = kzalloc(ACTION_CACHE_LINE_SIZE, GFP_KERNEL);
+		if (!hw_actions)
+			return -ENOMEM;
+
 		ret = mlx5dr_ste_set_action_decap_l3_list(dmn->ste_ctx,
 							  data, data_sz,
 							  hw_actions,
@@ -1413,6 +1417,7 @@ dr_action_create_reformat_action(struct mlx5dr_domain *dmn,
 							  &action->rewrite->num_of_actions);
 		if (ret) {
 			mlx5dr_dbg(dmn, "Failed creating decap l3 action list\n");
+			kfree(hw_actions);
 			return ret;
 		}
 
@@ -1420,6 +1425,7 @@ dr_action_create_reformat_action(struct mlx5dr_domain *dmn,
 								DR_CHUNK_SIZE_8);
 		if (!action->rewrite->chunk) {
 			mlx5dr_dbg(dmn, "Failed allocating modify header chunk\n");
+			kfree(hw_actions);
 			return -ENOMEM;
 		}
 
@@ -1433,6 +1439,7 @@ dr_action_create_reformat_action(struct mlx5dr_domain *dmn,
 		if (ret) {
 			mlx5dr_dbg(dmn, "Writing decap l3 actions to ICM failed\n");
 			mlx5dr_icm_free_chunk(action->rewrite->chunk);
+			kfree(hw_actions);
 			return ret;
 		}
 		return 0;
-- 
2.39.2



