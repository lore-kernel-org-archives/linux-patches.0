Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721CB134AC;
	Mon, 12 Aug 2024 16:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480006; cv=none; b=B++KlYKy4O4icUWv6GhFBqyGxSrUPNYIbn4AlL94WwZLzKFL52SflqEODKtmSJgwXpiX/QvLUmcguwIiN+fECNCnAQOQfCFxYEEQetEKRh8DbKd4qFsJ5J0J79ZMTbUULLm0pyM+XbgculyZBnfrPUVnQa8zBEZW1xGThPWa4rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480006; c=relaxed/simple;
	bh=61j13H6xHqIOVzekAN3pSmdKsKu5T9OMpBmeMzo48qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sV9o5gTPFsQ4orrSZLxRg69oFI46PFyg3m1Zddig+vXTpKqezUFE9PFJvMqZ8ULhnSreuJsddCQUByoEKl8uWQkftkTd3mBdh7KRKO3FVjVJpN+WGijwsKXhScLsp3e61Of1Q4mCtUrMyLJJzMMot+d/wpLMj2RpTov6+clCBbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tKZ8vFHl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tKZ8vFHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE98C32782;
	Mon, 12 Aug 2024 16:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480006;
	bh=61j13H6xHqIOVzekAN3pSmdKsKu5T9OMpBmeMzo48qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tKZ8vFHlQyqb9kf1Foh5fZD3/Z8xSxZD4sDlIkHt8D+XhylfnnT+y4k7n+SVgOV1H
	 J8vd1Qw5jANeHa7WqSjP9cTeT3M6HMpjhoN2/oR5aM3HSnfKSI8DR3wmimTSt6mQUY
	 tp+xKBeYHvCunUi1QXJICbRe+t81ZIoIzMdOIRPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 067/263] net/mlx5e: SHAMPO, Fix invalid WQ linked list unlink
Date: Mon, 12 Aug 2024 18:01:08 +0200
Message-ID: <20240812160149.108678414@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

[ Upstream commit fba8334721e266f92079632598e46e5f89082f30 ]

When all the strides in a WQE have been consumed, the WQE is unlinked
from the WQ linked list (mlx5_wq_ll_pop()). For SHAMPO, it is possible
to receive CQEs with 0 consumed strides for the same WQE even after the
WQE is fully consumed and unlinked. This triggers an additional unlink
for the same wqe which corrupts the linked list.

Fix this scenario by accepting 0 sized consumed strides without
unlinking the WQE again.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20240603212219.1037656-4-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index b5333da20e8a7..cdc84a27a04ed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2374,6 +2374,9 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 	if (likely(wi->consumed_strides < rq->mpwqe.num_strides))
 		return;
 
+	if (unlikely(!cstrides))
+		return;
+
 	wq  = &rq->mpwqe.wq;
 	wqe = mlx5_wq_ll_get_wqe(wq, wqe_id);
 	mlx5_wq_ll_pop(wq, cqe->wqe_id, &wqe->next.next_wqe_index);
-- 
2.43.0



