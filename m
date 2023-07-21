Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA76E20F88
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44060C433C8;
	Fri, 21 Jul 2023 19:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966598;
	bh=S5efc+spB6BW/idYFiowZdu/4EImoy2qmfvtKY7P2nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S2vwLdXoerAvC7UcaYASH5T5EKhzsIgUThAZ+WlMerJCq1/f0ehnYqlm4TtJDwADX
	 Aphrwfpdcvh51KrkE0VfjsOwrhZs+x6Rf3FYNnyrnhtPDNdX5863f1/DtdHOn3qhyZ
	 2kaOnDv5vOMF37mZ7jNe3PGELxgEP4HCd4Uf+4i8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Simon Horman <simon.horman@corigine.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 400/532] net/mlx5e: fix memory leak in mlx5e_ptp_open
Date: Fri, 21 Jul 2023 18:05:04 +0200
Message-ID: <20230721160636.157165210@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit d543b649ffe58a0cb4b6948b3305069c5980a1fa ]

When kvzalloc_node or kvzalloc failed in mlx5e_ptp_open, the memory
pointed by "c" or "cparams" is not freed, which can lead to a memory
leak. Fix by freeing the array in the error path.

Fixes: 145e5637d941 ("net/mlx5e: Add TX PTP port object support")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index ee95cc3a03786..ce941e6091c57 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -676,8 +676,10 @@ int mlx5e_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
 
 	c = kvzalloc_node(sizeof(*c), GFP_KERNEL, dev_to_node(mlx5_core_dma_dev(mdev)));
 	cparams = kvzalloc(sizeof(*cparams), GFP_KERNEL);
-	if (!c || !cparams)
-		return -ENOMEM;
+	if (!c || !cparams) {
+		err = -ENOMEM;
+		goto err_free;
+	}
 
 	c->priv     = priv;
 	c->mdev     = priv->mdev;
-- 
2.39.2



