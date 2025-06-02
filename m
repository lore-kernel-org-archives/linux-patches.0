Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D02221F0A;
	Mon,  2 Jun 2025 14:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873673; cv=none; b=oZLc8Kp+riBLIORGz5A6DwOOUaW9Efuk/ADORTkEtGOvVdDnFkbZznmV0S0ZLJVXpfmct/QGDZDY1Z/B+IEkg0/VLZOH9AJl7KAdVwKMcNZs90lxcjEkWFmH1jX1hnyc01ghpLGpeF7yw00v1km1UJJ5mpaNj1FU8XRuzc7GIVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873673; c=relaxed/simple;
	bh=9JIapGg3+EbwYq+C7pKdh7bPiE7UokvC7Cz3rzv7msw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWhy+ONAvEziqbI5sue7BwbmPK7CSfQ8eoQUfLHBjxcqs9c9WVjx96Pc9XWKZFQD0Gp+E6R/iOMXhwRsSCKoqwz+9ryXL8DhgZ1QBMud6p8NgPqHaJ/CxOc30ITd/bBPkZ3rK7KC6QINBLdtPGh2z8+qbhuSJb1LuJu4+AU7WO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EqzRkDc7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EqzRkDc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5DCC4CEEB;
	Mon,  2 Jun 2025 14:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873673;
	bh=9JIapGg3+EbwYq+C7pKdh7bPiE7UokvC7Cz3rzv7msw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EqzRkDc7liYuUeeQoEigjjWOqX0CfrSLWkJEB46+DWbpbhmjEVhCwLxwM13cTC72P
	 WoAThacQksWJYP1fxBRqV278T1xAr12d+KamiGayitpqcGb5jVf2XP7VcyHXM9STO5
	 WWVvxDbA2/6AEAVTxLrcoRVdCw7Ea7TdvBFowmx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 216/444] eth: mlx4: dont try to complete XDP frames in netpoll
Date: Mon,  2 Jun 2025 15:44:40 +0200
Message-ID: <20250602134349.679158362@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 8fdeafd66edaf420ea0063a1f13442fe3470fe70 ]

mlx4 doesn't support ndo_xdp_xmit / XDP_REDIRECT and wasn't
using page pool until now, so it could run XDP completions
in netpoll (NAPI budget == 0) just fine. Page pool has calling
context requirements, make sure we don't try to call it from
what is potentially HW IRQ context.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20250213010635.1354034-3-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 65cb63f6c4658..61a0fd8424a2c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -450,6 +450,8 @@ int mlx4_en_process_tx_cq(struct net_device *dev,
 
 	if (unlikely(!priv->port_up))
 		return 0;
+	if (unlikely(!napi_budget) && cq->type == TX_XDP)
+		return 0;
 
 	netdev_txq_bql_complete_prefetchw(ring->tx_queue);
 
-- 
2.39.5



