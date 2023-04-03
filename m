Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87085683
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F49FC433EF;
	Mon,  3 Apr 2023 14:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531538;
	bh=vmRHxWXauqltCTp09RX7xctKAfxXOkatQKiugOKMfCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ogy1qzr2LggMeYok0b7rwM8Oja/etzUJXJ8QufW51QLeReooPN5hs3T/m//wMf51w
	 1/WKpQeMHWNcH2nsXN3uftefkKth/ZwtRlrx8B9C5fEi9eU/IeZX+g4i1d0wmCsYXI
	 dRSLuNi+qidrYW6to0bIeXFPH3qi3Or1Xh9JEPts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 017/104] net/mlx5: Read the TC mapping of all priorities on ETS query
Date: Mon,  3 Apr 2023 16:08:09 +0200
Message-Id: <20230403140404.877692387@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
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

[ Upstream commit 44d553188c38ac74b799dfdcebafef2f7bb70942 ]

When ETS configurations are queried by the user to get the mapping
assignment between packet priority and traffic class, only priorities up
to maximum TCs are queried from QTCT register in FW to retrieve their
assigned TC, leaving the rest of the priorities mapped to the default
TC #0 which might be misleading.

Fix by querying the TC mapping of all priorities on each ETS query,
regardless of the maximum number of TCs configured in FW.

Fixes: 820c2c5e773d ("net/mlx5e: Read ETS settings directly from firmware")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index 01f2918063af0..f1952e14c8042 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -109,12 +109,14 @@ static int mlx5e_dcbnl_ieee_getets(struct net_device *netdev,
 	if (!MLX5_CAP_GEN(priv->mdev, ets))
 		return -EOPNOTSUPP;
 
-	ets->ets_cap = mlx5_max_tc(priv->mdev) + 1;
-	for (i = 0; i < ets->ets_cap; i++) {
+	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
 		err = mlx5_query_port_prio_tc(mdev, i, &ets->prio_tc[i]);
 		if (err)
 			return err;
+	}
 
+	ets->ets_cap = mlx5_max_tc(priv->mdev) + 1;
+	for (i = 0; i < ets->ets_cap; i++) {
 		err = mlx5_query_port_tc_group(mdev, i, &tc_group[i]);
 		if (err)
 			return err;
-- 
2.39.2



