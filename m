Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0516381D6;
	Fri, 24 Nov 2023 18:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rTit2Ai0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E47C433C7;
	Fri, 24 Nov 2023 18:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849511;
	bh=kMdDDEBtQ3HFud6uWUAchIUhpBasU470zzrlB/6WrkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rTit2Ai0cbuyONMGMMaGQ0g15mxa0buWFtTGYrWTHUBvPxxkPwOBJY9kG05rdsIbz
	 SLqd4U9Z29mPm1c0gR5tk8yYhIWLNwLKWlyNfOd2qFcM3A7vmxTP3YXRwp06UKmRfH
	 VamOogXYvlYpDK9qM2+w+oqvk5K8atgcPTPP1wJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baruch Siach <baruch@tkos.co.il>,
	Serge Semin <fancer.lancer@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 210/530] net: stmmac: avoid rx queue overrun
Date: Fri, 24 Nov 2023 17:46:16 +0000
Message-ID: <20231124172034.454653794@linuxfoundation.org>
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

From: Baruch Siach <baruch@tkos.co.il>

[ Upstream commit b6cb4541853c7ee512111b0e7ddf3cb66c99c137 ]

dma_rx_size can be set as low as 64. Rx budget might be higher than
that. Make sure to not overrun allocated rx buffers when budget is
larger.

Leave one descriptor unused to avoid wrap around of 'dirty_rx' vs
'cur_rx'.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Fixes: 47dd7a540b8a ("net: add support for STMicroelectronics Ethernet controllers.")
Link: https://lore.kernel.org/r/d95413e44c97d4692e72cec13a75f894abeb6998.1699897370.git.baruch@tkos.co.il
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 53358015fbe5c..1fa4da96c8f50 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5267,6 +5267,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 
 	dma_dir = page_pool_get_dma_dir(rx_q->page_pool);
 	buf_sz = DIV_ROUND_UP(priv->dma_conf.dma_buf_sz, PAGE_SIZE) * PAGE_SIZE;
+	limit = min(priv->dma_conf.dma_rx_size - 1, (unsigned int)limit);
 
 	if (netif_msg_rx_status(priv)) {
 		void *rx_head;
-- 
2.42.0



