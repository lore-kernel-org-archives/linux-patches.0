Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1EB1AA797;
	Mon, 14 Oct 2024 14:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917010; cv=none; b=M2cX44JqQv035LqGeMuXFlWt1+ZQoGVT497BMFuhkV9bzBQskd/F9FqAILmNy+pC5+togN4Uy5UZqJOxzNiSBIsGlLt+0qLKjOTdfvZzyL1fpn31bk8r+R7UKy2YQF3tQz694VFap141q7PcigAXn6xMemrNyBs73mMjiNEqVLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917010; c=relaxed/simple;
	bh=PyerRhANBWvrN5WXJgdSyckyfNEnpgmGmyvkmk0mwnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XBG+b0FIlbpn7RziLjdZzlRkos1+H+b3UC5bleCvzycDOAWH4B1wc8pWKbRl+G1wIQ6UY3LcA9vpWyVFoZuMtTcOB0jEGpSPRgwt5WO+N+126HeA3PZECWtuXnSyMVUk4/w+hc1XGpC9eN8jInfnKqd+xmq6+zY5tkp91TOzaj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kw6y27x/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kw6y27x/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7F4C4CEC3;
	Mon, 14 Oct 2024 14:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917010;
	bh=PyerRhANBWvrN5WXJgdSyckyfNEnpgmGmyvkmk0mwnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kw6y27x/UxgLLS5dhqCQJ8b8Icq5ZumOuqT4Zw/qzkkRA9mJXZi07P6e4OWZii2GJ
	 DDHF+Qnjcum53kc4KIyaWD8RLHaT71C1BBfrw5jz+xVdGPKliILwLlpwxeCz3TQY5s
	 pVgDKCTd/fik3HIznFxKXeHV1z4gEaIyvJ6nEpGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Furong Xu <0x1207@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/213] Revert "net: stmmac: set PP_FLAG_DMA_SYNC_DEV only if XDP is enabled"
Date: Mon, 14 Oct 2024 16:20:32 +0200
Message-ID: <20241014141047.889483672@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 5546da79e6cc5bb3324bf25688ed05498fd3f86d ]

This reverts commit b514c47ebf41a6536551ed28a05758036e6eca7c.

The commit describes that we don't have to sync the page when
recycling, and it tries to optimize that case. But we do need
to sync after allocation. Recycling side should be changed to
pass the right sync size instead.

Fixes: b514c47ebf41 ("net: stmmac: set PP_FLAG_DMA_SYNC_DEV only if XDP is enabled")
Reported-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/20241004070846.2502e9ea@kernel.org
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Furong Xu <0x1207@gmail.com>
Link: https://patch.msgid.link/20241004142115.910876-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 89a80e3e8bb88..d6167a7b19f21 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2018,7 +2018,7 @@ static int __alloc_dma_rx_desc_resources(struct stmmac_priv *priv,
 	rx_q->queue_index = queue;
 	rx_q->priv_data = priv;
 
-	pp_params.flags = PP_FLAG_DMA_MAP | (xdp_prog ? PP_FLAG_DMA_SYNC_DEV : 0);
+	pp_params.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
 	pp_params.pool_size = dma_conf->dma_rx_size;
 	num_pages = DIV_ROUND_UP(dma_conf->dma_buf_sz, PAGE_SIZE);
 	pp_params.order = ilog2(num_pages);
-- 
2.43.0



