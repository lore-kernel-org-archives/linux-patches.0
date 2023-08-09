Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0235915AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:44:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F5BC433C8;
	Wed,  9 Aug 2023 10:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691577889;
	bh=x+6X6Jdft4FF0tkqsNGZ2MCyo210Eu4hV9zaZQGUfhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YtahFrcbI3jrmrXXjXqFMRex/yoGPBDkxwpVSIA0qQlvuulV3xDKnXLGhxD05GObj
	 QW2bUKePxVsS09RFqX6KQoSZBmLvZN+w2+kaPLbw1+PZlGV7SEkS2HaIFFgQdwl1qC
	 H/D5zQ/3yGPAXfuLV1XhCz8XzlUv7cXQv7XFUz3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Simon Horman <simon.horman@corigine.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 030/165] net/mlx5: fix potential memory leak in mlx5e_init_rep_rx
Date: Wed,  9 Aug 2023 12:39:21 +0200
Message-ID: <20230809103643.796937137@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
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

[ Upstream commit c6cf0b6097bf1bf1b2a89b521e9ecd26b581a93a ]

The memory pointed to by the priv->rx_res pointer is not freed in the error
path of mlx5e_init_rep_rx, which can lead to a memory leak. Fix by freeing
the memory in the error path, thereby making the error path identical to
mlx5e_cleanup_rep_rx().

Fixes: af8bbf730068 ("net/mlx5e: Convert mlx5e_flow_steering member of mlx5e_priv to pointer")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 3e7041bd5705e..95d8714765f70 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -964,7 +964,7 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 	err = mlx5e_open_drop_rq(priv, &priv->drop_rq);
 	if (err) {
 		mlx5_core_err(mdev, "open drop rq failed, %d\n", err);
-		return err;
+		goto err_rx_res_free;
 	}
 
 	err = mlx5e_rx_res_init(priv->rx_res, priv->mdev, 0,
@@ -998,6 +998,7 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 	mlx5e_rx_res_destroy(priv->rx_res);
 err_close_drop_rq:
 	mlx5e_close_drop_rq(&priv->drop_rq);
+err_rx_res_free:
 	mlx5e_rx_res_free(priv->rx_res);
 	priv->rx_res = NULL;
 err_free_fs:
-- 
2.40.1



