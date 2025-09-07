Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A9E1A704B;
	Sun,  7 Sep 2025 20:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277580; cv=none; b=YyZokorDBXZii8WxKzjrAawkdEJcQz/HljaLWrUXugyXmFZ3hYbx5WQGBbdlA8CmTZdwVNa42eQIWuGUDMcvAV6Br1VAlRSH3SZJ7jsKp+GCgEC6B4A1ywG4jnXNUFRwfd6vdNwKAHuYYNvzR7bZKynRthd49/6gfIb7+RgLlL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277580; c=relaxed/simple;
	bh=P7+/SWifkn0/r8+JOU0xtEpSpeJKleNU4/1SbzexJEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUCk0v7FRjgAk2UBOTdb1ymD9A0IeS9vI+L4kHk5zTua7nDgXaGeNEadg0OZg1EnGVxE4Jz7f2OLlpIJ4d1lVZrMq+RHc8973kQOt9m5IaZY+d7oMzy1WgXG6KjDboh3+FPap9w59E/N7LOaUfJMZeuhA1DN0gXkcSk+JFV7NN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXviU3zR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXviU3zR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00402C4CEF0;
	Sun,  7 Sep 2025 20:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277580;
	bh=P7+/SWifkn0/r8+JOU0xtEpSpeJKleNU4/1SbzexJEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CXviU3zRRY6r7Y94dkfDXV/IUUthfYieTkAaY5Hr7SbQfNaguBcVMDgXdfBn+cgPh
	 6gnzWF1MJgwU2oupENqhwyBcIwOjtHyYcgWOYMvP9gmyDv6NvhE649f+qclLr0ma+1
	 OOwZYrvf2V79p0L2+8qDgcj+ADpLkM4ebuSIrL1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 058/183] eth: mlx4: Fix IS_ERR() vs NULL check bug in mlx4_en_create_rx_ring
Date: Sun,  7 Sep 2025 21:58:05 +0200
Message-ID: <20250907195617.167722963@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit e580beaf43d563aaf457f1c7f934002355ebfe7b ]

Replace NULL check with IS_ERR() check after calling page_pool_create()
since this function returns error pointers (ERR_PTR).
Using NULL check could lead to invalid pointer dereference.

Fixes: 8533b14b3d65 ("eth: mlx4: create a page pool for Rx")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20250828121858.67639-1-linmq006@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index b33285d755b90..a626fd0d20735 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -267,8 +267,10 @@ int mlx4_en_create_rx_ring(struct mlx4_en_priv *priv,
 	pp.dma_dir = priv->dma_dir;
 
 	ring->pp = page_pool_create(&pp);
-	if (!ring->pp)
+	if (IS_ERR(ring->pp)) {
+		err = PTR_ERR(ring->pp);
 		goto err_ring;
+	}
 
 	if (xdp_rxq_info_reg(&ring->xdp_rxq, priv->dev, queue_index, 0) < 0)
 		goto err_pp;
-- 
2.50.1



