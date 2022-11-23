Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6728A1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C670EC43148;
	Wed, 23 Nov 2022 09:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195030;
	bh=aAiuY6rW0c7HXcUdWczTasJjEkYlIBdNYolj6H01FiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jw1wSstlOEeFgvtF074vf5AGTlwlETs7AKcSBSwq+vvTfiD3wMU5V6SzyIFTHBb7x
	 vTNFQ0HlunzB27jQOWY46L8a8aiYQNJTb2+UmcPpsbp8gl+Fua/mryw+7S27aLnTCk
	 RWXsP6kr1eK7boBkfor70MDkNQvhct4yUXLQYkWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yongjun <weiyongjun1@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/156] net: bgmac: Drop free_netdev() from bgmac_enet_remove()
Date: Wed, 23 Nov 2022 09:50:54 +0100
Message-Id: <20221123084601.496858584@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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
index 979af8e878e3..193722334d93 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -1564,7 +1564,6 @@ void bgmac_enet_remove(struct bgmac *bgmac)
 	phy_disconnect(bgmac->net_dev->phydev);
 	netif_napi_del(&bgmac->napi);
 	bgmac_dma_free(bgmac);
-	free_netdev(bgmac->net_dev);
 }
 EXPORT_SYMBOL_GPL(bgmac_enet_remove);
 
-- 
2.35.1



