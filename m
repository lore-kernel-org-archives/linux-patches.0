Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B4079C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85EF5C433D7;
	Wed, 30 Nov 2022 18:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834144;
	bh=pLu0LTOaGgTRLtHLDNyNB3eH/64heXsfitmdw7/s9f8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iLi/TNnHrvA4Ttmfeg7USvmrhPMU9bxfNuw1BqBICMvWktl7fs0j2f7lOfZI6HYXU
	 XvYbQHyhdd3TkN2DEiEFjxn7bYZQOZSZAVQRkoThb7HwiMhGlo4Ty6WxOQSP4EafYQ
	 i5171A+pIBuYyZkuzy8Cnq0pNQNnxz0diJRUBBQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yan Cangang <nalanzeyu@gmail.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 138/289] net: ethernet: mtk_eth_soc: fix resource leak in error path
Date: Wed, 30 Nov 2022 19:22:03 +0100
Message-Id: <20221130180547.266618387@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yan Cangang <nalanzeyu@gmail.com>

[ Upstream commit 8110437e59616293228cd781c486d8495a61e36a ]

In mtk_probe(), when mtk_ppe_init() or mtk_eth_offload_init() failed,
mtk_mdio_cleanup() isn't called. Fix it.

Fixes: ba37b7caf1ed ("net: ethernet: mtk_eth_soc: add support for initializing the PPE")
Fixes: 502e84e2382d ("net: ethernet: mtk_eth_soc: add flow offloading support")
Signed-off-by: Yan Cangang <nalanzeyu@gmail.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 3db24ddd1261..aee57b22c496 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4114,12 +4114,12 @@ static int mtk_probe(struct platform_device *pdev)
 		eth->ppe = mtk_ppe_init(eth, eth->base + ppe_addr, 2);
 		if (!eth->ppe) {
 			err = -ENOMEM;
-			goto err_free_dev;
+			goto err_deinit_mdio;
 		}
 
 		err = mtk_eth_offload_init(eth);
 		if (err)
-			goto err_free_dev;
+			goto err_deinit_mdio;
 	}
 
 	for (i = 0; i < MTK_MAX_DEVS; i++) {
-- 
2.35.1



