Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79997171A6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2472C433C8;
	Wed,  9 Aug 2023 10:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578733;
	bh=Z3+Q/vk1KgLEjUc4pE5aH48R8aUD8Ac3uBsbyIqSV0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yCiAz38DW7bk+cXMsZ88cTuFjJb/yCByKLDWQ5ZqlqRL5XjcxpABSEBLq4Ua/iZPB
	 O3sVSgaouSKCc1kYxm7CsDkOw+cmm1OCKtQpu6hmN8mKmzMQt3zJYwwxx018BCRSbg
	 gEtuyx8lEShGwm5lzjX1v9LSjfCZkfL+qReEbkKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Esben Haabendal <esben@geanix.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Harini Katakam <harini.katakam@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 38/92] net: ll_temac: fix error checking of irq_of_parse_and_map()
Date: Wed,  9 Aug 2023 12:41:14 +0200
Message-ID: <20230809103634.935585044@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103633.485906560@linuxfoundation.org>
References: <20230809103633.485906560@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit ef45e8400f5bb66b03cc949f76c80e2a118447de ]

Most kernel functions return negative error codes but some irq functions
return zero on error.  In this code irq_of_parse_and_map(), returns zero
and platform_get_irq() returns negative error codes.  We need to handle
both cases appropriately.

Fixes: 8425c41d1ef7 ("net: ll_temac: Extend support to non-device-tree platforms")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Esben Haabendal <esben@geanix.com>
Reviewed-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Harini Katakam <harini.katakam@amd.com>
Link: https://lore.kernel.org/r/3d0aef75-06e0-45a5-a2a6-2cc4738d4143@moroto.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 303de9293fc71..b4db50c9e7038 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1556,12 +1556,16 @@ static int temac_probe(struct platform_device *pdev)
 	}
 
 	/* Error handle returned DMA RX and TX interrupts */
-	if (lp->rx_irq < 0)
-		return dev_err_probe(&pdev->dev, lp->rx_irq,
+	if (lp->rx_irq <= 0) {
+		rc = lp->rx_irq ?: -EINVAL;
+		return dev_err_probe(&pdev->dev, rc,
 				     "could not get DMA RX irq\n");
-	if (lp->tx_irq < 0)
-		return dev_err_probe(&pdev->dev, lp->tx_irq,
+	}
+	if (lp->tx_irq <= 0) {
+		rc = lp->tx_irq ?: -EINVAL;
+		return dev_err_probe(&pdev->dev, rc,
 				     "could not get DMA TX irq\n");
+	}
 
 	if (temac_np) {
 		/* Retrieve the MAC address */
-- 
2.40.1



