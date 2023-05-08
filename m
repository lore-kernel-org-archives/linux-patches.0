Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4915168C4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2976DC433D2;
	Mon,  8 May 2023 10:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540589;
	bh=tsHhjcFbu9WAW/ZJUbSYH19Wck+0RYJMh7cXfyZcc6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JIl7bAC0knkky0SIrGwUoS0rCSDgL5ydRrzpLwesKFLGrdox4RryDoqj54zhd54nT
	 kQ36RKs6y/sH9vcMXGfmF6TZjew6Woq/cNwkeq9FImuYPBtKdKA9K/hH9W0Oeak/1b
	 YfFcyK0z2EdwkHgwhSLMfQOmxJSnSs7t9vBClku0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mi <cmi@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Maor Dickman <maord@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 379/611] net/mlx5: E-switch, Dont destroy indirect table in split rule
Date: Mon,  8 May 2023 11:43:41 +0200
Message-Id: <20230508094434.652353865@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
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
index ac8cf1b93e46a..519526a4810ef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -733,7 +733,6 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 	kfree(dest);
 	return rule;
 err_chain_src_rewrite:
-	esw_put_dest_tables_loop(esw, attr, 0, i);
 	mlx5_esw_vporttbl_put(esw, &fwd_attr);
 err_get_fwd:
 	mlx5_chains_put_table(chains, attr->chain, attr->prio, 0);
@@ -776,7 +775,6 @@ __mlx5_eswitch_del_rule(struct mlx5_eswitch *esw,
 	if (fwd_rule)  {
 		mlx5_esw_vporttbl_put(esw, &fwd_attr);
 		mlx5_chains_put_table(chains, attr->chain, attr->prio, 0);
-		esw_put_dest_tables_loop(esw, attr, 0, esw_attr->split_count);
 	} else {
 		if (split)
 			mlx5_esw_vporttbl_put(esw, &fwd_attr);
-- 
2.39.2



