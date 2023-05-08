Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D135168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CD3C433D2;
	Mon,  8 May 2023 10:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540578;
	bh=AovXRJWNm5x/pdvDWWKgcj4Rn/vzIhdfaGEhxwZY7Us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Sc/2oelF73nYPOEAd1Ax5zShCizjStIvSQv6IfU2OZkbiuVdHzABLU+809SgF+fA
	 g8qUJ3r4m4RRb2l5qqC29bUJg/2o87VIsep3e1NIYgn+gjG3zghJ5SfeaYp77X8Wcv
	 6JOhfLvqBwtVUETNXyw7TIR55WAhvuJ2QfWqrA7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aya Levin <ayal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 385/611] net/mlx5e: Nullify table pointer when failing to create
Date: Mon,  8 May 2023 11:43:47 +0200
Message-Id: <20230508094434.823488807@linuxfoundation.org>
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

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit 1b540decd03acd736693aabb6cb46c71fca38ae6 ]

On failing to create promisc flow steering table, the pointer is
returned with an error. Nullify it so unloading the driver won't try to
destroy a non existing table.

Failing to create promisc table may happen over BF devices when the ARM
side is going through a firmware tear down. The host side start a
reload flow. While the driver unloads, it tries to remove the promisc
table. Remove WARN in this state as it is a valid error flow.

Fixes: 1c46d7409f30 ("net/mlx5e: Optimize promiscuous mode")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index edbe22d93c992..eba601487eb79 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -776,6 +776,7 @@ static int mlx5e_create_promisc_table(struct mlx5e_flow_steering *fs)
 	ft->t = mlx5_create_auto_grouped_flow_table(fs->ns, &ft_attr);
 	if (IS_ERR(ft->t)) {
 		err = PTR_ERR(ft->t);
+		ft->t = NULL;
 		fs_err(fs, "fail to create promisc table err=%d\n", err);
 		return err;
 	}
@@ -803,7 +804,7 @@ static void mlx5e_del_promisc_rule(struct mlx5e_flow_steering *fs)
 
 static void mlx5e_destroy_promisc_table(struct mlx5e_flow_steering *fs)
 {
-	if (WARN(!fs->promisc.ft.t, "Trying to remove non-existing promiscuous table"))
+	if (!fs->promisc.ft.t)
 		return;
 	mlx5e_del_promisc_rule(fs);
 	mlx5_destroy_flow_table(fs->promisc.ft.t);
-- 
2.39.2



