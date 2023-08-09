Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07A9168B7
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432F9C433C7;
	Wed,  9 Aug 2023 10:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578730;
	bh=pgjFsfYEuytySKKJNCu/JFmZeJEODP2OP4MBeb4/C58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B/lWFzl0u946UgnpGaOHjr0UIwFFbLGtuD26rjVMDi4kjVNCUMt/8HR2vVm8X268Z
	 g4zZUX6rr79IKNEOFoYFiAV8R5lCySkjGRr59a3wdj+W6ld6sceInFRZ9RDvZ3VUra
	 6FMw3qWyOzVGkt6l4m6NOWk+h5Jwa2oYj1BzEFHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 37/92] net: ll_temac: Switch to use dev_err_probe() helper
Date: Wed,  9 Aug 2023 12:41:13 +0200
Message-ID: <20230809103634.904124590@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 75ae8c284c00dc3584b7c173f6fcf96ee15bd02c ]

dev_err() can be replace with dev_err_probe() which will check if error
code is -EPROBE_DEFER.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: ef45e8400f5b ("net: ll_temac: fix error checking of irq_of_parse_and_map()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 2ab29efa6b6e4..303de9293fc71 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1556,16 +1556,12 @@ static int temac_probe(struct platform_device *pdev)
 	}
 
 	/* Error handle returned DMA RX and TX interrupts */
-	if (lp->rx_irq < 0) {
-		if (lp->rx_irq != -EPROBE_DEFER)
-			dev_err(&pdev->dev, "could not get DMA RX irq\n");
-		return lp->rx_irq;
-	}
-	if (lp->tx_irq < 0) {
-		if (lp->tx_irq != -EPROBE_DEFER)
-			dev_err(&pdev->dev, "could not get DMA TX irq\n");
-		return lp->tx_irq;
-	}
+	if (lp->rx_irq < 0)
+		return dev_err_probe(&pdev->dev, lp->rx_irq,
+				     "could not get DMA RX irq\n");
+	if (lp->tx_irq < 0)
+		return dev_err_probe(&pdev->dev, lp->tx_irq,
+				     "could not get DMA TX irq\n");
 
 	if (temac_np) {
 		/* Retrieve the MAC address */
-- 
2.40.1



