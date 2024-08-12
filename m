Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADE2183CC9;
	Mon, 12 Aug 2024 16:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478852; cv=none; b=O/f3cQegVolAAHC70dAmsfFMNYg/q6Q4ODJTNdHwrJ9p01CNZLgfPs47bAXX1tpWWtB97W044gZIsDt3YGZbRwzQ9CK+qaA5k+1Zmqlv+NPCXCP7aNpBILx0eQ3XNsb/fqpWvBHEHHEuq/gB57K4NZlTECjlfdlmj+DyCCBkYac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478852; c=relaxed/simple;
	bh=MgssrBQfenm1mncd1z2DtYbmUGERhVYdS0DaCQDzsss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVz8ZBekUQFQAgw9avXquJUAMFD4ws1TyqeyCu6pnhvdal8Fe/h//uAmgELCB5i4g0bqtzh2IX1X2LD88BXwPedx6yuxym461CqJB5AdIpRYlb1/X/5JjfRje5JFNcYYDDlGawCjSzxPBODXk5/gkftcJCr8teai/cJ3VIjXEHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Btmjh5U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Btmjh5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7819C32782;
	Mon, 12 Aug 2024 16:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478852;
	bh=MgssrBQfenm1mncd1z2DtYbmUGERhVYdS0DaCQDzsss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Btmjh5Uu0Ky4hA0RjBurZ/yvxNEo3hiZLZ938iodP1wvx8Rd5X5JcgJgECuE8U/z
	 7yvITWWSZ2irXLIdvKuLQNSoIhYNEarYobCSEieKHFzG3alTT+5kQ3bprlUdbvgC9p
	 OQdG6j7dD3evrefWXxjlhsj0azgOgjGt59TPTqdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/150] net/mlx5e: SHAMPO, Fix invalid WQ linked list unlink
Date: Mon, 12 Aug 2024 18:01:46 +0200
Message-ID: <20240812160126.133344494@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 56d1bd22c7c66..97d1cfec4ec03 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2146,6 +2146,9 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 	if (likely(wi->consumed_strides < rq->mpwqe.num_strides))
 		return;
 
+	if (unlikely(!cstrides))
+		return;
+
 	wq  = &rq->mpwqe.wq;
 	wqe = mlx5_wq_ll_get_wqe(wq, wqe_id);
 	mlx5e_free_rx_mpwqe(rq, wi, true);
-- 
2.43.0



