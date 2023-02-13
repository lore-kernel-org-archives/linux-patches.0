Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99EA28F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21225C433EF;
	Mon, 13 Feb 2023 14:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300310;
	bh=wzZpU6F9WtJ94ygPICDTmIB0BOXU4zR+L00J7oAmH/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T+7RKeZ5u3xgL1DSa2vTQq4jWDm0Zyb7yaeY+sC39QGxefe1OwCHdeJ0BSt14WzDo
	 acd29DW4JWTrdFDBeuojd3xsmNqZ4EFoADOCAUsH4arXMjgG8+4pB3QWIoBFsmIiJd
	 39vCgDx1qQTKpUrvL58WBO4RfuK+TvXWO3/51rmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Mikityanskiy <maximmi@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 30/67] net/mlx5e: Move repeating clear_bit in mlx5e_rx_reporter_err_rq_cqe_recover
Date: Mon, 13 Feb 2023 15:49:11 +0100
Message-Id: <20230213144733.813988522@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maxim Mikityanskiy <maximmi@nvidia.com>

[ Upstream commit e64d71d055ca01fa5054d25b99fb29b98e543a31 ]

The same clear_bit is called in both error and success flows. Move the
call to do it only once and remove the out label.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 1e66220948df ("net/mlx5e: Update rx ring hw mtu upon each rx-fcs flag change")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index e329158fdc555..0f1dbad7c9f1a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -157,16 +157,13 @@ static int mlx5e_rx_reporter_err_rq_cqe_recover(void *ctx)
 	mlx5e_free_rx_descs(rq);
 
 	err = mlx5e_rq_to_ready(rq, MLX5_RQC_STATE_ERR);
+	clear_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state);
 	if (err)
-		goto out;
+		return err;
 
-	clear_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state);
 	mlx5e_activate_rq(rq);
 	rq->stats->recover++;
 	return 0;
-out:
-	clear_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state);
-	return err;
 }
 
 static int mlx5e_rx_reporter_timeout_recover(void *ctx)
-- 
2.39.0



