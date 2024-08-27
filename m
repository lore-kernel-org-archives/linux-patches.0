Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8241C4ED4;
	Tue, 27 Aug 2024 15:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771335; cv=none; b=P9OUMeS2xolZzgIxzT4JnlJANP+3jWHjND/2zO8FF+ezuU9bFEhjQPNZSycs9jj31uwifnqbvrSW1raoEeNYYO8UzVz/JaCtQeldkOuVGQLXu+/By3vJfn+U8puhqeLW1/IB/ZWJHbybRQ8SoeRP+Sxcw6vnri8xpeEySCEwqBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771335; c=relaxed/simple;
	bh=TkbOrLnD6YkB6gOMQL/A1nIvOV40Yr8tpTj+z0ZGF+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CcX+y7YID4mkO/PKB458SFgLMrUnFlhvkagSuUYjJXPNh9CzizCtnNyYd9HjVpWMphexU6cVaFLK8DSPtgeBxg0O1/BXeA2sMzGtnY7zK+MlGNesckIns6yQMLAOU/C8lIZ6O2Bh6NVUnLNkKDykm2AJh56ckqJu1oyyRrAyi2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PgiVCM+/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PgiVCM+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE84C4AF13;
	Tue, 27 Aug 2024 15:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771335;
	bh=TkbOrLnD6YkB6gOMQL/A1nIvOV40Yr8tpTj+z0ZGF+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PgiVCM+/U54zj8kfAJsiki5X2Q5a24WzNvkVPQBZYGU0XB+N1G1K6zigZsTnlrSR8
	 tqkelNDOlWDHBCpLj69rbWNFrS4M9Y5LHaN+1qJGOsiNaWdhe3ZRouEh1Mpm7IO8Zr
	 OLEvTvbYQ65l5L+KVt0vxlW8qR1HdHJVGe9qy6MA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 157/273] net/mlx5e: XPS, Fix oversight of Multi-PF Netdev changes
Date: Tue, 27 Aug 2024 16:38:01 +0200
Message-ID: <20240827143839.378650433@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit a07e953dafe5ebd88942dc861dfb06eaf055fb07 ]

The offending commit overlooked the Multi-PF Netdev changes.

Revert mlx5e_set_default_xps_cpumasks to incorporate Multi-PF Netdev
changes.

Fixes: bcee093751f8 ("net/mlx5e: Modifying channels number and updating TX queues")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20240815071611.2211873-4-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index eedbcba226894..409f525f1703c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3005,15 +3005,18 @@ int mlx5e_update_tx_netdev_queues(struct mlx5e_priv *priv)
 static void mlx5e_set_default_xps_cpumasks(struct mlx5e_priv *priv,
 					   struct mlx5e_params *params)
 {
-	struct mlx5_core_dev *mdev = priv->mdev;
-	int num_comp_vectors, ix, irq;
-
-	num_comp_vectors = mlx5_comp_vectors_max(mdev);
+	int ix;
 
 	for (ix = 0; ix < params->num_channels; ix++) {
+		int num_comp_vectors, irq, vec_ix;
+		struct mlx5_core_dev *mdev;
+
+		mdev = mlx5_sd_ch_ix_get_dev(priv->mdev, ix);
+		num_comp_vectors = mlx5_comp_vectors_max(mdev);
 		cpumask_clear(priv->scratchpad.cpumask);
+		vec_ix = mlx5_sd_ch_ix_get_vec_ix(mdev, ix);
 
-		for (irq = ix; irq < num_comp_vectors; irq += params->num_channels) {
+		for (irq = vec_ix; irq < num_comp_vectors; irq += params->num_channels) {
 			int cpu = mlx5_comp_vector_get_cpu(mdev, irq);
 
 			cpumask_set_cpu(cpu, priv->scratchpad.cpumask);
-- 
2.43.0



