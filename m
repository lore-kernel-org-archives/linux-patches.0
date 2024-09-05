Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9111A154BFF;
	Thu,  5 Sep 2024 09:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529794; cv=none; b=TBTEpTLIzuz4DL9KnLJtFMuLlO6FYtiYYD8neVhwFX5HYgKDusBL7HzmkP63E8+AE6l5oewZ15siO/A1KxbFVV+fjjVQDseidmW3VAljN8zm7FNhJ/x+Ms9DBEHw6/5AJ38W0sj7g21NudV+MNyegnscrPB5lgWTWFTt6jWtv3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529794; c=relaxed/simple;
	bh=MfaoUPMCva0m4LfjGdU+DXj77VRcMnh4CbAsTmHR19s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=spRwL2hHnjqJSsXKGWrD15UOJ9DXKxlOHP7Jv/ZBw19wijlvWNjqW9Pb7r/z/wyeDCkpUULl7f+D1Z+gIy0eje7fP0u3jIzrureDIpqxTSBVtXiOIYPRYiys9oqpHCJcaqKRM6pLGufknC5XiEJY7dE5oYuna6VjTdCAXLEyga8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2lkTZm2J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2lkTZm2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE364C4CECB;
	Thu,  5 Sep 2024 09:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529794;
	bh=MfaoUPMCva0m4LfjGdU+DXj77VRcMnh4CbAsTmHR19s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2lkTZm2JqYKfNk+Yi1xRdpBCUDqJaXtrZXHE40lhREM3u03bdSufk0YRcLMluDxi9
	 APUF+ZpdakUBtejv8JQ5mqlYaBcLccvIkKHH0rzCmmXwrmRPmVThyK7+/CMgIwVTau
	 I91NGyAS+WrtIu1TXs85YVBdY1p4JOO7yCGUTXFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 144/184] net/mlx5e: SHAMPO, Fix incorrect page release
Date: Thu,  5 Sep 2024 11:40:57 +0200
Message-ID: <20240905093737.960107228@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit 70bd03b89f20b9bbe51a7f73c4950565a17a45f7 ]

Under the following conditions:
1) No skb created yet
2) header_size == 0 (no SHAMPO header)
3) header_index + 1 % MLX5E_SHAMPO_WQ_HEADER_PER_PAGE == 0 (this is the
   last page fragment of a SHAMPO header page)

a new skb is formed with a page that is NOT a SHAMPO header page (it
is a regular data page). Further down in the same function
(mlx5e_handle_rx_cqe_mpwrq_shampo()), a SHAMPO header page from
header_index is released. This is wrong and it leads to SHAMPO header
pages being released more than once.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20240603212219.1037656-3-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index cdc84a27a04e..0138f77eaeed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2369,7 +2369,8 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 	if (flush)
 		mlx5e_shampo_flush_skb(rq, cqe, match);
 free_hd_entry:
-	mlx5e_free_rx_shampo_hd_entry(rq, header_index);
+	if (likely(head_size))
+		mlx5e_free_rx_shampo_hd_entry(rq, header_index);
 mpwrq_cqe_out:
 	if (likely(wi->consumed_strides < rq->mpwqe.num_strides))
 		return;
-- 
2.43.0



