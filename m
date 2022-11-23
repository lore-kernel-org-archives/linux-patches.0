Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E4C1C26
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF29C433C1;
	Wed, 23 Nov 2022 09:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194396;
	bh=tjRqxWg8DJw3EIdIM+/0wijhcXXq8Sri1sHybxKolW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yOePnSytoG+gY/Xx9iJwB+mfIZF2OMIfJ7NEA432nOn0CGeRAPmOFMCk/tDrUBpzP
	 w+pRGbhSeOCc091EXTYFqv9rRmS1N4guTlbMCHpY7ADyzo2LSjVtxKZM9SKkjRvocn
	 ehxlURy4ZuVIJIcjLzRS5shoMxQfD/p5ZqiUpfSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yongjun <weiyongjun1@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 065/114] net: bgmac: Drop free_netdev() from bgmac_enet_remove()
Date: Wed, 23 Nov 2022 09:50:52 +0100
Message-Id: <20221123084554.488688463@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 6f928ab8ee9bfbcb0e631c47ea8a16c3d5116ff1 ]

netdev is allocated in bgmac_alloc() with devm_alloc_etherdev() and will
be auto released in ->remove and ->probe failure path. Using free_netdev()
in bgmac_enet_remove() leads to double free.

Fixes: 34a5102c3235 ("net: bgmac: allocate struct bgmac just once & don't copy it")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Link: https://lore.kernel.org/r/20221109150136.2991171-1-weiyongjun@huaweicloud.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bgmac.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 4c94d9218bba..50c5afc46eb0 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -1566,7 +1566,6 @@ void bgmac_enet_remove(struct bgmac *bgmac)
 	phy_disconnect(bgmac->net_dev->phydev);
 	netif_napi_del(&bgmac->napi);
 	bgmac_dma_free(bgmac);
-	free_netdev(bgmac->net_dev);
 }
 EXPORT_SYMBOL_GPL(bgmac_enet_remove);
 
-- 
2.35.1



