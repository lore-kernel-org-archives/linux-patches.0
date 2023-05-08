Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C362171A8
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:41:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73F9C433D2;
	Mon,  8 May 2023 11:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683546097;
	bh=pvVG1bQrgKQy6L2w9RgoF2dq3+O5g12/qddxf+TVB4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCeDZ50b/VZ5lDsDZVp0FDdSC22QM0lsLuaWngjyBoJ6+86zuRwvPhDwlTirUWwWC
	 oukXwacyQEGQ/Bg3laO+m8vhajZL/Whydybu5dNEILj1YdTzk6U26JOMr9MFPbRsbe
	 dDkKiL3nnFi+BPJzjYuHb8099fHl5/wXqgapkOlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mi <cmi@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Maor Dickman <maord@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 226/371] net/mlx5: E-switch, Dont destroy indirect table in split rule
Date: Mon,  8 May 2023 11:47:07 +0200
Message-Id: <20230508094821.036115063@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
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

[ Upstream commit 4c8189302567f75099a336b0efcff8291ec86ff4 ]

Source port rewrite (forward to ovs internal port or statck device) isn't
supported in the rule of split action. So there is no indirect table in
split rule. The cited commit destroyes indirect table in split rule. The
indirect table for other rules will be destroyed wrongly. It will cause
traffic loss.

Fix it by removing the destroy function in split rule. And also remove
the destroy function in error flow.

Fixes: 10742efc20a4 ("net/mlx5e: VF tunnel TX traffic offloading")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 002567792e91e..829f703233a9e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -656,7 +656,6 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 
 	return rule;
 err_chain_src_rewrite:
-	esw_put_dest_tables_loop(esw, attr, 0, i);
 	mlx5_esw_vporttbl_put(esw, &fwd_attr);
 err_get_fwd:
 	mlx5_chains_put_table(chains, attr->chain, attr->prio, 0);
@@ -698,7 +697,6 @@ __mlx5_eswitch_del_rule(struct mlx5_eswitch *esw,
 	if (fwd_rule)  {
 		mlx5_esw_vporttbl_put(esw, &fwd_attr);
 		mlx5_chains_put_table(chains, attr->chain, attr->prio, 0);
-		esw_put_dest_tables_loop(esw, attr, 0, esw_attr->split_count);
 	} else {
 		if (split)
 			mlx5_esw_vporttbl_put(esw, &fwd_attr);
-- 
2.39.2



