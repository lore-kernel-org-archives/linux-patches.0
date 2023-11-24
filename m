Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BE439FE1;
	Fri, 24 Nov 2023 18:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bYar3Nmm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7977FC433C8;
	Fri, 24 Nov 2023 18:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849548;
	bh=unuVUaPYwqW6hUgXb/HJybJzNbe4dL7R4fL4HKq7U3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bYar3Nmm/XXQ7BCr+L/MnFox5SyFxvodyRw6zMue5iSq+6mQgbo769rsHzuXDl+lO
	 auUVEmNz0efOm2IhbcAM0aVfxJplKaqHS5B9sSSw5ePQCZWqxNkIQwf7XCLcxQUULK
	 EkNRym0YXbAp+pWpLHOMFXs8JwEVAt4aQQ5CoTA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 226/530] net/mlx5e: Reduce the size of icosq_str
Date: Fri, 24 Nov 2023 17:46:32 +0000
Message-ID: <20231124172034.932776558@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saeed Mahameed <saeedm@nvidia.com>

[ Upstream commit dce94142842e119b982c27c1b62bd20890c7fd21 ]

icosq_str size is unnecessarily too long, and it causes a build warning
-Wformat-truncation with W=1. Looking closely, It doesn't need to be 255B,
hence this patch reduces the size to 32B which should be more than enough
to host the string: "ICOSQ: 0x%x, ".

While here, add a missing space in the formatted string.

This fixes the following build warning:

$ KCFLAGS='-Wall -Werror'
$ make O=/tmp/kbuild/linux W=1 -s -j12 drivers/net/ethernet/mellanox/mlx5/core/

drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c: In function 'mlx5e_reporter_rx_timeout':
drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c:718:56:
error: ', CQ: 0x' directive output may be truncated writing 8 bytes into a region of size between 0 and 255 [-Werror=format-truncation=]
  718 |                  "RX timeout on channel: %d, %sRQ: 0x%x, CQ: 0x%x",
      |                                                        ^~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c:717:9: note: 'snprintf' output between 43 and 322 bytes into a destination of size 288
  717 |         snprintf(err_str, sizeof(err_str),
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  718 |                  "RX timeout on channel: %d, %sRQ: 0x%x, CQ: 0x%x",
      |                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  719 |                  rq->ix, icosq_str, rq->rqn, rq->cq.mcq.cqn);
      |                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fixes: 521f31af004a ("net/mlx5e: Allow RQ outside of channel context")
Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6d4ab2e97dcfbcd748ae71761a9d8e5e41cc732c
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Link: https://lore.kernel.org/r/20231114215846.5902-14-saeed@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index e8eea9ffd5eb6..03b119a434bc9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -702,11 +702,11 @@ static int mlx5e_rx_reporter_dump(struct devlink_health_reporter *reporter,
 
 void mlx5e_reporter_rx_timeout(struct mlx5e_rq *rq)
 {
-	char icosq_str[MLX5E_REPORTER_PER_Q_MAX_LEN] = {};
 	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
 	struct mlx5e_icosq *icosq = rq->icosq;
 	struct mlx5e_priv *priv = rq->priv;
 	struct mlx5e_err_ctx err_ctx = {};
+	char icosq_str[32] = {};
 
 	err_ctx.ctx = rq;
 	err_ctx.recover = mlx5e_rx_reporter_timeout_recover;
@@ -715,7 +715,7 @@ void mlx5e_reporter_rx_timeout(struct mlx5e_rq *rq)
 	if (icosq)
 		snprintf(icosq_str, sizeof(icosq_str), "ICOSQ: 0x%x, ", icosq->sqn);
 	snprintf(err_str, sizeof(err_str),
-		 "RX timeout on channel: %d, %sRQ: 0x%x, CQ: 0x%x",
+		 "RX timeout on channel: %d, %s RQ: 0x%x, CQ: 0x%x",
 		 rq->ix, icosq_str, rq->rqn, rq->cq.mcq.cqn);
 
 	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
-- 
2.42.0



