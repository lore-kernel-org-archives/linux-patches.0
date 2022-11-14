Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AD44C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:55:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A609C433C1;
	Mon, 14 Nov 2022 12:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430521;
	bh=eAT6n0YEYuqn/ClFQ1aV7kB6KKKtNrs9cObhdkRu/AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LiLWrfclRC/ff76nfsfaVdaBaqZlPaJrjxDZbV2n6jfGyJmiPZ4j3gs3zVtgV2xCE
	 T96G3pnWytPqLN87qp00JQtrsnpaUqg+xqqnsIdnBfAKpse29/BFIiCBrTNvbUSQEz
	 PCm/QgAF90GNtZoTxE3CprUcaf79So7V8A/oEho4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/131] net: ethernet: mtk-star-emac: disable napi when connect and start PHY failed in mtk_star_enable()
Date: Mon, 14 Nov 2022 13:45:21 +0100
Message-Id: <20221114124450.929864548@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit b0c09c7f08c2467b2089bdf4adb2fbbc2464f4a8 ]

When failed to connect to and start PHY in mtk_star_enable() for opening
device, napi isn't disabled. When open mtk star device next time, it will
reports a invalid opcode issue. Fix it. Only be compiled, not be tested.

Fixes: 8c7bd5a454ff ("net: ethernet: mtk-star-emac: new driver")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20221107012159.211387-1-shaozhengchao@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index 1d5dd2015453..b3c4849f9f39 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -977,6 +977,8 @@ static int mtk_star_enable(struct net_device *ndev)
 	return 0;
 
 err_free_irq:
+	napi_disable(&priv->rx_napi);
+	napi_disable(&priv->tx_napi);
 	free_irq(ndev->irq, ndev);
 err_free_skbs:
 	mtk_star_free_rx_skbs(priv);
-- 
2.35.1



