Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D9D7F476;
	Mon, 15 Apr 2024 14:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191279; cv=none; b=X+YZDKhGE4JeM5GiPnb38fvuIKuGGxL41+sWZZ8Jn6lbHv6phFdfZAq6xzZonb7sY8MejZYH/kblhepmt0c0NR4aK9JqU35VliBXBbkFr8bSJe/CWbe+sQosIskrZFkcZcF5Yaxdj4Spd8LbBRCXPhkAu03ks3pzJMp2E9zNEqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191279; c=relaxed/simple;
	bh=L4RbYFj2bMTsHPA+msIYx88UQYGBNc/1PqP1EmFi2Ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSoFmI/d+LlA9E84xQQHxzAAti6BqpxMo0a6JE8ie0XWd6HWS1S/adBLpxxN1dq87NOUp47vrwuEgCSbjYyPeWPtNTA9SWm5pguVYDorbs5zKdHIqWvgtempLvgnHPngWvMUWvM7OIHPerWe8MhfvrUEaJAMaGibB1D42yxvto4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ra/kn6rS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ra/kn6rS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27E8C113CC;
	Mon, 15 Apr 2024 14:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191279;
	bh=L4RbYFj2bMTsHPA+msIYx88UQYGBNc/1PqP1EmFi2Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ra/kn6rSw+rM5jM7IEr+JMTPldRaHLRKCvUnBPmaJ0WpPfmFGlgJVRx/dtDpT+BDT
	 unFAUnnIShHUbXLWX7b0mu73BzItGzDK6hAecLErY0xbfVImSrzUA/QV9Sx9yI537r
	 JPXNMZGGeU3+VEIvW4FYTflJIpq1tWWQlasLxhqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 089/172] net/mlx5e: HTB, Fix inconsistencies with QoS SQs number
Date: Mon, 15 Apr 2024 16:19:48 +0200
Message-ID: <20240415142003.101638721@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit 2f436f1869771d46e1a9f85738d5a1a7c5653a4e ]

When creating a new HTB class while the interface is down,
the variable that follows the number of QoS SQs (htb_max_qos_sqs)
may not be consistent with the number of HTB classes.

Previously, we compared these two values to ensure that
the node_qid is lower than the number of QoS SQs, and we
allocated stats for that SQ when they are equal.

Change the check to compare the node_qid with the current
number of leaf nodes and fix the checking conditions to
ensure allocation of stats_list and stats for each node.

Fixes: 214baf22870c ("net/mlx5e: Support HTB offload")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20240409190820.227554-9-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  | 33 ++++++++++---------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
index 34adf8c3f81a0..922bc5b7c10e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
@@ -83,24 +83,25 @@ int mlx5e_open_qos_sq(struct mlx5e_priv *priv, struct mlx5e_channels *chs,
 
 	txq_ix = mlx5e_qid_from_qos(chs, node_qid);
 
-	WARN_ON(node_qid > priv->htb_max_qos_sqs);
-	if (node_qid == priv->htb_max_qos_sqs) {
-		struct mlx5e_sq_stats *stats, **stats_list = NULL;
-
-		if (priv->htb_max_qos_sqs == 0) {
-			stats_list = kvcalloc(mlx5e_qos_max_leaf_nodes(priv->mdev),
-					      sizeof(*stats_list),
-					      GFP_KERNEL);
-			if (!stats_list)
-				return -ENOMEM;
-		}
+	WARN_ON(node_qid >= mlx5e_htb_cur_leaf_nodes(priv->htb));
+	if (!priv->htb_qos_sq_stats) {
+		struct mlx5e_sq_stats **stats_list;
+
+		stats_list = kvcalloc(mlx5e_qos_max_leaf_nodes(priv->mdev),
+				      sizeof(*stats_list), GFP_KERNEL);
+		if (!stats_list)
+			return -ENOMEM;
+
+		WRITE_ONCE(priv->htb_qos_sq_stats, stats_list);
+	}
+
+	if (!priv->htb_qos_sq_stats[node_qid]) {
+		struct mlx5e_sq_stats *stats;
+
 		stats = kzalloc(sizeof(*stats), GFP_KERNEL);
-		if (!stats) {
-			kvfree(stats_list);
+		if (!stats)
 			return -ENOMEM;
-		}
-		if (stats_list)
-			WRITE_ONCE(priv->htb_qos_sq_stats, stats_list);
+
 		WRITE_ONCE(priv->htb_qos_sq_stats[node_qid], stats);
 		/* Order htb_max_qos_sqs increment after writing the array pointer.
 		 * Pairs with smp_load_acquire in en_stats.c.
-- 
2.43.0



