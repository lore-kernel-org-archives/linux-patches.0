Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75A11E4AB;
	Mon, 15 Apr 2024 14:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191430; cv=none; b=FX62MvUMdzncsjBHHpFX8G/jbZWj7dTF1eBIj6PdR/5d7RmjwsPvIssVJbhsjOxRQPsJgu2PlFdPeOul4/gqxV6+yRWlZmX/7IqgPhHFFB2GqnusV0md+zFcg42hGii2t2VgB6KBXMhK7L7AyHgClURlytWZruy33qKm/YPsSL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191430; c=relaxed/simple;
	bh=5M5GyywrFy0G3YDUcF4JcjjUgKOgneqLb8djC9oVqxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1QaJLIsX2/weL3iYY22FC2mKo/Tnj+lMAUPfoSJO6UFDmVg3R0GDyZSDu6HFgFdeiImfp3xZYMeZsUwJ4KrdfWqO+5a6moQoIwfONJuqtRERKqJKHSUE6xQNZ1/maevDacNi18Sx2Dccn4qecZSLx5f06GdK17zNjO/0YpSB0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fD+FzLsE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fD+FzLsE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138A8C113CC;
	Mon, 15 Apr 2024 14:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191429;
	bh=5M5GyywrFy0G3YDUcF4JcjjUgKOgneqLb8djC9oVqxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fD+FzLsEoda7FbiUNXmEAdwiZXuvYp41gUeLY/34V/bAr2Iqgbn0HeK0UR/uGruuT
	 jIesypBpXKZxWI92F2KwWnb0hyguFxe/rAiMl/W4vFxuKWzC2D7zJc6QAqGx//jOpt
	 CqsG3JcwOKSnV3BqyOyxvBNiG/e8ZlBmJBta8ivI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 090/172] net/mlx5e: Do not produce metadata freelist entries in Tx port ts WQE xmit
Date: Mon, 15 Apr 2024 16:19:49 +0200
Message-ID: <20240415142003.130724722@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

[ Upstream commit 86b0ca5b118d3a0bae5e5645a13e66f8a4f6c525 ]

Free Tx port timestamping metadata entries in the NAPI poll context and
consume metadata enties in the WQE xmit path. Do not free a Tx port
timestamping metadata entry in the WQE xmit path even in the error path to
avoid a race between two metadata entry producers.

Fixes: 3178308ad4ca ("net/mlx5e: Make tx_port_ts logic resilient to out-of-order CQEs")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20240409190820.227554-10-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h | 8 +++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c  | 7 +++----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
index 86f1854698b4e..883c044852f1d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
@@ -95,9 +95,15 @@ static inline void mlx5e_ptp_metadata_fifo_push(struct mlx5e_ptp_metadata_fifo *
 }
 
 static inline u8
+mlx5e_ptp_metadata_fifo_peek(struct mlx5e_ptp_metadata_fifo *fifo)
+{
+	return fifo->data[fifo->mask & fifo->cc];
+}
+
+static inline void
 mlx5e_ptp_metadata_fifo_pop(struct mlx5e_ptp_metadata_fifo *fifo)
 {
-	return fifo->data[fifo->mask & fifo->cc++];
+	fifo->cc++;
 }
 
 static inline void
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 2fa076b23fbea..e21a3b4128ce8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -398,6 +398,8 @@ mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		     (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))) {
 		u8 metadata_index = be32_to_cpu(eseg->flow_table_metadata);
 
+		mlx5e_ptp_metadata_fifo_pop(&sq->ptpsq->metadata_freelist);
+
 		mlx5e_skb_cb_hwtstamp_init(skb);
 		mlx5e_ptp_metadata_map_put(&sq->ptpsq->metadata_map, skb,
 					   metadata_index);
@@ -496,9 +498,6 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 
 err_drop:
 	stats->dropped++;
-	if (unlikely(sq->ptpsq && (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)))
-		mlx5e_ptp_metadata_fifo_push(&sq->ptpsq->metadata_freelist,
-					     be32_to_cpu(eseg->flow_table_metadata));
 	dev_kfree_skb_any(skb);
 	mlx5e_tx_flush(sq);
 }
@@ -657,7 +656,7 @@ static void mlx5e_cqe_ts_id_eseg(struct mlx5e_ptpsq *ptpsq, struct sk_buff *skb,
 {
 	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
 		eseg->flow_table_metadata =
-			cpu_to_be32(mlx5e_ptp_metadata_fifo_pop(&ptpsq->metadata_freelist));
+			cpu_to_be32(mlx5e_ptp_metadata_fifo_peek(&ptpsq->metadata_freelist));
 }
 
 static void mlx5e_txwqe_build_eseg(struct mlx5e_priv *priv, struct mlx5e_txqsq *sq,
-- 
2.43.0



