Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BB54C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663A5C433C1;
	Mon, 14 Nov 2022 12:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430138;
	bh=tkch0EhrJno+mY3kL6Z+zZ628NBupKGqdyhdNDUcAmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gan/VpyXAVu+joObcvJ/UgA/Nc2IkFYANe1DNzj63PK9Dn8p5H1ED3F4UwPN3IlEf
	 xB0WCHVWLT1fTwF3RC1TvyUu2RiyyzxkuweRFbdmMrv4Q82b2QH4V5FomTxPaEz93i
	 RWHqXDVJijnxWo6nO3vkHdNUhW3doKdIKC3xbMXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 38/95] net: nixge: disable napi when enable interrupts failed in nixge_open()
Date: Mon, 14 Nov 2022 13:45:32 +0100
Message-Id: <20221114124444.151643292@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
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

[ Upstream commit b06334919c7a068d54ba5b219c05e919d89943f7 ]

When failed to enable interrupts in nixge_open() for opening device,
napi isn't disabled. When open nixge device next time, it will reports
a invalid opcode issue. Fix it. Only be compiled, not be tested.

Fixes: 492caffa8a1a ("net: ethernet: nixge: Add support for National Instruments XGE netdev")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20221107101443.120205-1-shaozhengchao@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ni/nixge.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index a6861df9904f..9c48fd85c418 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -899,6 +899,7 @@ static int nixge_open(struct net_device *ndev)
 err_rx_irq:
 	free_irq(priv->tx_irq, ndev);
 err_tx_irq:
+	napi_disable(&priv->napi);
 	phy_stop(phy);
 	phy_disconnect(phy);
 	tasklet_kill(&priv->dma_err_tasklet);
-- 
2.35.1



