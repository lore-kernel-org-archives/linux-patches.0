Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2673839FE3;
	Fri, 24 Nov 2023 18:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSxoT9gL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C8CC433C7;
	Fri, 24 Nov 2023 18:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849538;
	bh=MiL/NaEoZYRnn8bb93qemDZ4NcWm2Gi9jcGmrDkGuqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSxoT9gLUjK332yiF2PnOu9CcoAr89PyE+FVNqFUiEdJCB7OnaNVf00zhPLcksbD5
	 QPIZAat2IH4QnaI10f87m3dXu+JPzroBo/8eaIAJaIQ8T4RdWAWrDpdj4Y7ijgN217
	 gXBh3VvJPbw1XD5cdafXqe0Y8Lpzcrt8+tEkDihQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 222/530] net/mlx5e: Avoid referencing skb after free-ing in drop path of mlx5e_sq_xmit_wqe
Date: Fri, 24 Nov 2023 17:46:28 +0000
Message-ID: <20231124172034.813613378@linuxfoundation.org>
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

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

[ Upstream commit 64f14d16eef1f939000f2617b50c7c996b5117d4 ]

When SQ is a port timestamping SQ for PTP, do not access tx flags of skb
after free-ing the skb. Free the skb only after all references that depend
on it have been handled in the dropped WQE path.

Fixes: 3178308ad4ca ("net/mlx5e: Make tx_port_ts logic resilient to out-of-order CQEs")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Link: https://lore.kernel.org/r/20231114215846.5902-10-saeed@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index d41435c22ce56..19f2c25b05a0b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -494,10 +494,10 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 
 err_drop:
 	stats->dropped++;
-	dev_kfree_skb_any(skb);
 	if (unlikely(sq->ptpsq && (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)))
 		mlx5e_ptp_metadata_fifo_push(&sq->ptpsq->metadata_freelist,
 					     be32_to_cpu(eseg->flow_table_metadata));
+	dev_kfree_skb_any(skb);
 	mlx5e_tx_flush(sq);
 }
 
-- 
2.42.0



