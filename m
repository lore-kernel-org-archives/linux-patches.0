Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EFD21578A;
	Thu, 12 Dec 2024 15:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015831; cv=none; b=CHol5efgRQFwo5APhKNxSmxf/26Z/+N3BfzQWexvQqdfXZ2ZuKKq15hiEhBF6HM9yWJcpy3oi7o2J4GLoAPyhUAXgu8dsgMRBzLTdUVR2t2lu+B1I7AE6vIyuc2fSP6gOB1J64OAb/5YnLMzyRq7dY7+Rjl/0CveUHbxhsJ4HWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015831; c=relaxed/simple;
	bh=Jn1SiHk2Ai9IyTSeZjf1x+nfTM6O4Ek473obu94i2Ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICYNqO38sXNPV/z/wdUP9Oh4nz1GeOWJl9YefrETsbY8LM41mfaBYHBY82YvgDfHmEpa7RtjQczTsEIEsExzJN0CAUB/s4Pe5Oz0T6Jfnn/4kSFaYrqTGLAkCSgW0g158gIIPa0YJ2a9cRt25ZlrXuCW+vCYhIcjAC3wx4FuQqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gyDscPm5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gyDscPm5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0281CC4CECE;
	Thu, 12 Dec 2024 15:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015831;
	bh=Jn1SiHk2Ai9IyTSeZjf1x+nfTM6O4Ek473obu94i2Ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gyDscPm5KIrTLJAIQT8xH0TOnT5kZtYjI9LUqdko7h4tUAf6ShpK+E2NwkPziDvth
	 aPPLiM8EbO+mu6Jx83tsOZ0TrrEo7WvHkAd+m4oYbVtstamQaHcMLHxTm9riazv4Xu
	 RDnziZZmrGsXcdyqbSuqPGXLIuZxr8X1Aw7MUwjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tariq Toukan <tariqt@nvidia.com>,
	Lama Kayal <lkayal@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/466] net/mlx5e: SD, Use correct mdev to build channel param
Date: Thu, 12 Dec 2024 15:53:45 +0100
Message-ID: <20241212144309.032087912@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tariq Toukan <tariqt@nvidia.com>

[ Upstream commit 31f114c3d158dacbeda33f2afb0ca41f4ec6c9f9 ]

In a multi-PF netdev, each traffic channel creates its own resources
against a specific PF.
In the cited commit, where this support was added, the channel_param
logic was mistakenly kept unchanged, so it always used the primary PF
which is found at priv->mdev.
In this patch we fix this by moving the logic to be per-channel, and
passing the correct mdev instance.

This bug happened to be usually harmless, as the resulting cparam
structures would be the same for all channels, due to identical FW logic
and decisions.
However, in some use cases, like fwreset, this gets broken.

This could lead to different symptoms. Example:
Error cqe on cqn 0x428, ci 0x0, qn 0x10a9, opcode 0xe, syndrome 0x4,
vendor syndrome 0x32

Fixes: e4f9686bdee7 ("net/mlx5e: Let channels be SD-aware")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Link: https://patch.msgid.link/20241203204920.232744-6-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 32 ++++++++++---------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 13a3fa8dc0cb0..c14bef83d84d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2652,11 +2652,11 @@ void mlx5e_trigger_napi_sched(struct napi_struct *napi)
 
 static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 			      struct mlx5e_params *params,
-			      struct mlx5e_channel_param *cparam,
 			      struct xsk_buff_pool *xsk_pool,
 			      struct mlx5e_channel **cp)
 {
 	struct net_device *netdev = priv->netdev;
+	struct mlx5e_channel_param *cparam;
 	struct mlx5_core_dev *mdev;
 	struct mlx5e_xsk_param xsk;
 	struct mlx5e_channel *c;
@@ -2678,8 +2678,15 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 		return err;
 
 	c = kvzalloc_node(sizeof(*c), GFP_KERNEL, cpu_to_node(cpu));
-	if (!c)
-		return -ENOMEM;
+	cparam = kvzalloc(sizeof(*cparam), GFP_KERNEL);
+	if (!c || !cparam) {
+		err = -ENOMEM;
+		goto err_free;
+	}
+
+	err = mlx5e_build_channel_param(mdev, params, cparam);
+	if (err)
+		goto err_free;
 
 	c->priv     = priv;
 	c->mdev     = mdev;
@@ -2713,6 +2720,7 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 
 	*cp = c;
 
+	kvfree(cparam);
 	return 0;
 
 err_close_queues:
@@ -2721,6 +2729,8 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 err_napi_del:
 	netif_napi_del(&c->napi);
 
+err_free:
+	kvfree(cparam);
 	kvfree(c);
 
 	return err;
@@ -2779,20 +2789,14 @@ static void mlx5e_close_channel(struct mlx5e_channel *c)
 int mlx5e_open_channels(struct mlx5e_priv *priv,
 			struct mlx5e_channels *chs)
 {
-	struct mlx5e_channel_param *cparam;
 	int err = -ENOMEM;
 	int i;
 
 	chs->num = chs->params.num_channels;
 
 	chs->c = kcalloc(chs->num, sizeof(struct mlx5e_channel *), GFP_KERNEL);
-	cparam = kvzalloc(sizeof(struct mlx5e_channel_param), GFP_KERNEL);
-	if (!chs->c || !cparam)
-		goto err_free;
-
-	err = mlx5e_build_channel_param(priv->mdev, &chs->params, cparam);
-	if (err)
-		goto err_free;
+	if (!chs->c)
+		goto err_out;
 
 	for (i = 0; i < chs->num; i++) {
 		struct xsk_buff_pool *xsk_pool = NULL;
@@ -2800,7 +2804,7 @@ int mlx5e_open_channels(struct mlx5e_priv *priv,
 		if (chs->params.xdp_prog)
 			xsk_pool = mlx5e_xsk_get_pool(&chs->params, chs->params.xsk, i);
 
-		err = mlx5e_open_channel(priv, i, &chs->params, cparam, xsk_pool, &chs->c[i]);
+		err = mlx5e_open_channel(priv, i, &chs->params, xsk_pool, &chs->c[i]);
 		if (err)
 			goto err_close_channels;
 	}
@@ -2818,7 +2822,6 @@ int mlx5e_open_channels(struct mlx5e_priv *priv,
 	}
 
 	mlx5e_health_channels_update(priv);
-	kvfree(cparam);
 	return 0;
 
 err_close_ptp:
@@ -2829,9 +2832,8 @@ int mlx5e_open_channels(struct mlx5e_priv *priv,
 	for (i--; i >= 0; i--)
 		mlx5e_close_channel(chs->c[i]);
 
-err_free:
 	kfree(chs->c);
-	kvfree(cparam);
+err_out:
 	chs->num = 0;
 	return err;
 }
-- 
2.43.0



