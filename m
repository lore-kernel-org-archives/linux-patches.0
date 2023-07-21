Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CCB1F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3E9C433BA;
	Fri, 21 Jul 2023 16:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955784;
	bh=P9OFDi1eSkI0pxDF+EOvWbJNrrcsV/bckRXPdNy7SQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ug75zBWtutGymkoyBa1k0kEcQ1JZ5JVwYvThG0R41mdsXUZz+vMxkGRZ83WqbZLL9
	 jZlw+MlwMpIpkkpVUuqW6fQ1teWIpJ4C754z+ecIK0Dbve+UwnNhaFzjR84xUxCjh5
	 4SussOWhSZWOfiCIxw3kx2jSrMITllZZ0h5S+RcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 029/292] net/mlx5e: RX, Fix flush and close release flow of regular rq for legacy rq
Date: Fri, 21 Jul 2023 18:02:18 +0200
Message-ID: <20230721160530.052134476@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit 2e2d1965794d22fbe86df45bf4f933216743577d ]

Regular (non-XSK) RQs get flushed on XSK setup and re-activated on XSK
close. If the same regular RQ is closed (a config change for example)
soon after the XSK close, a double release occurs because the missing
wqes get released a second time.

Fixes: 3f93f82988bc ("net/mlx5e: RX, Defer page release in legacy rq for better recycling")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 69634829558e2..111f6a4a64b64 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -390,10 +390,18 @@ static void mlx5e_dealloc_rx_wqe(struct mlx5e_rq *rq, u16 ix)
 {
 	struct mlx5e_wqe_frag_info *wi = get_frag(rq, ix);
 
-	if (rq->xsk_pool)
+	if (rq->xsk_pool) {
 		mlx5e_xsk_free_rx_wqe(wi);
-	else
+	} else {
 		mlx5e_free_rx_wqe(rq, wi);
+
+		/* Avoid a second release of the wqe pages: dealloc is called
+		 * for the same missing wqes on regular RQ flush and on regular
+		 * RQ close. This happens when XSK RQs come into play.
+		 */
+		for (int i = 0; i < rq->wqe.info.num_frags; i++, wi++)
+			wi->flags |= BIT(MLX5E_WQE_FRAG_SKIP_RELEASE);
+	}
 }
 
 static void mlx5e_xsk_free_rx_wqes(struct mlx5e_rq *rq, u16 ix, int wqe_bulk)
-- 
2.39.2



