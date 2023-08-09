Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E6F15AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFD0C433C8;
	Wed,  9 Aug 2023 10:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691577990;
	bh=TDXgYBB5XxbNkhrQ/4gRaEFxKoAWAv7UCn8odu/LZxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cN7svZayRb/uSeBNeQ46UsKu7CfSW88CVcz8CiUjm8NZpNm2BwwpTkQR2uw6pDDqM
	 k9dPaVHt7rOsKEUEonFcVGasxtTgW2ye+XRAlDOvokTNObLMpjo71OTuxRvS/F1D13
	 M2tep1SqOK86CUXvigCTv6HaKvMK8aew8zkg+WEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kal Cutter Conley <kal.conley@dectris.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 037/165] net/mlx5e: xsk: Fix crash on regular rq reactivation
Date: Wed,  9 Aug 2023 12:39:28 +0200
Message-ID: <20230809103644.027542174@linuxfoundation.org>
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

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit 39646d9bcd1a65d2396328026626859a1dab59d7 ]

When the regular rq is reactivated after the XSK socket is closed
it could be reading stale cqes which eventually corrupts the rq.
This leads to no more traffic being received on the regular rq and a
crash on the next close or deactivation of the rq.

Kal Cuttler Conely reported this issue as a crash on the release
path when the xdpsock sample program is stopped (killed) and restarted
in sequence while traffic is running.

This patch flushes all cqes when during the rq flush. The cqe flushing
is done in the reset state of the rq. mlx5e_rq_to_ready code is moved
into the flush function to allow for this.

Fixes: 082a9edf12fe ("net/mlx5e: xsk: Flush RQ on XSK activation to save memory")
Reported-by: Kal Cutter Conley <kal.conley@dectris.com>
Closes: https://lore.kernel.org/xdp-newbies/CAHApi-nUAs4TeFWUDV915CZJo07XVg2Vp63-no7UDfj6wur9nQ@mail.gmail.com
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 29 ++++++++++++++-----
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index a5bdf78955d76..f084513fbead4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1036,7 +1036,23 @@ static int mlx5e_modify_rq_state(struct mlx5e_rq *rq, int curr_state, int next_s
 	return err;
 }
 
-static int mlx5e_rq_to_ready(struct mlx5e_rq *rq, int curr_state)
+static void mlx5e_flush_rq_cq(struct mlx5e_rq *rq)
+{
+	struct mlx5_cqwq *cqwq = &rq->cq.wq;
+	struct mlx5_cqe64 *cqe;
+
+	if (test_bit(MLX5E_RQ_STATE_MINI_CQE_ENHANCED, &rq->state)) {
+		while ((cqe = mlx5_cqwq_get_cqe_enahnced_comp(cqwq)))
+			mlx5_cqwq_pop(cqwq);
+	} else {
+		while ((cqe = mlx5_cqwq_get_cqe(cqwq)))
+			mlx5_cqwq_pop(cqwq);
+	}
+
+	mlx5_cqwq_update_db_record(cqwq);
+}
+
+int mlx5e_flush_rq(struct mlx5e_rq *rq, int curr_state)
 {
 	struct net_device *dev = rq->netdev;
 	int err;
@@ -1046,6 +1062,10 @@ static int mlx5e_rq_to_ready(struct mlx5e_rq *rq, int curr_state)
 		netdev_err(dev, "Failed to move rq 0x%x to reset\n", rq->rqn);
 		return err;
 	}
+
+	mlx5e_free_rx_descs(rq);
+	mlx5e_flush_rq_cq(rq);
+
 	err = mlx5e_modify_rq_state(rq, MLX5_RQC_STATE_RST, MLX5_RQC_STATE_RDY);
 	if (err) {
 		netdev_err(dev, "Failed to move rq 0x%x to ready\n", rq->rqn);
@@ -1055,13 +1075,6 @@ static int mlx5e_rq_to_ready(struct mlx5e_rq *rq, int curr_state)
 	return 0;
 }
 
-int mlx5e_flush_rq(struct mlx5e_rq *rq, int curr_state)
-{
-	mlx5e_free_rx_descs(rq);
-
-	return mlx5e_rq_to_ready(rq, curr_state);
-}
-
 static int mlx5e_modify_rq_vsd(struct mlx5e_rq *rq, bool vsd)
 {
 	struct mlx5_core_dev *mdev = rq->mdev;
-- 
2.40.1



