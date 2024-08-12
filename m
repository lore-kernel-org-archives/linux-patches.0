Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4AD186E51;
	Mon, 12 Aug 2024 16:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479277; cv=none; b=m2yzyR+rtGPxrtji7pVCGblxR2213bsv/nrCwWeap9/aNcYl479r/MEsuAE5CphQvGR6KKZ918XoqUMi+4AL+J9eTzR3//kxWrtVD/SI37VayazpUTgFGINMqFXj8azqrvzYN+Vt12bV/fl6g5PwdR4vUKvvg8WSC6j8peF3hGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479277; c=relaxed/simple;
	bh=aJHSt64nABZEiS3ueIywdbfjjP63k+KbHsw2z+VhqtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=euzGeSNawVWVcLudp3AmUT/OtmJMslKLqit3zIXo7Q4BjWul8Vtxy+cNNILtotwJZG/9FxrlcoFKSsAX9ltSBqKGM86FDkBR/VSGb1eO0H495ahu/lwEtkT0YAXyVkL9H0t2/TQaD3FE/aF0DpYRxL8Pg0QALC0hfM3m1swq8aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9SQoIhk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9SQoIhk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AEBC32782;
	Mon, 12 Aug 2024 16:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479276;
	bh=aJHSt64nABZEiS3ueIywdbfjjP63k+KbHsw2z+VhqtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W9SQoIhkzpJv4DEpN/TwEv3LpKSj78tjX886bEmOUwTjowv0fs4RWoItamofqV/2l
	 hgPOCmzmPd+Ras+fR2jMKJuG5uJqILsYV89lUUqhnTAYNyYW4UMDnlKUzYH56ryRhE
	 rryzaNF7rdkQ+7kWOjAyYi3KBNkvmXsqWrN9fLQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/189] net/mlx5e: SHAMPO, Fix invalid WQ linked list unlink
Date: Mon, 12 Aug 2024 18:01:33 +0200
Message-ID: <20240812160133.575538274@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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
index 8d9743a5e42c7..79ec6fcc9e259 100644
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



