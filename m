Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EAD79F2;
	Tue,  5 Dec 2023 03:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15WpDxLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F36C433C7;
	Tue,  5 Dec 2023 03:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747724;
	bh=hdXgerfsnr0Mzpy3nCt5wR5+DgVNPYDrhmMrAnqYAuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=15WpDxLB403yyVJRcAThI8e6u2eDcAqMv85tRgOKX9nk7gV9PSYxVQIKE++t/azn7
	 0vZ6mdKp6IJl13qJU8WekZXs3GY21k37MyiXnjtcQFp9+d0saFPucWss2rXLZ6qIBP
	 JUwu6akY2AZWunvf8xcTgDllVqLgTxIFWUR+IWLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Edworthy <phil.edworthy@renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 45/67] ravb: Support separate Line0 (Desc), Line1 (Err) and Line2 (Mgmt) irqs
Date: Tue,  5 Dec 2023 12:17:30 +0900
Message-ID: <20231205031522.422083009@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031519.853779502@linuxfoundation.org>
References: <20231205031519.853779502@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Edworthy <phil.edworthy@renesas.com>

[ Upstream commit b0265dcba3d6c1689e6ce315bed09192fb587403 ]

R-Car has a combined interrupt line, ch22 = Line0_DiA | Line1_A | Line2_A.
RZ/V2M has separate interrupt lines for each of these, so add a feature
that allows the driver to get these interrupts and call the common handler.

Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: eac16a733427 ("net: ravb: Stop DMA in case of failures on ravb_open()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb.h      |  3 ++
 drivers/net/ethernet/renesas/ravb_main.c | 56 +++++++++++++++++++++---
 2 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index a3cd09c7003bf..29df692ebaaa2 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1001,6 +1001,7 @@ struct ravb_hw_info {
 	unsigned tx_counters:1;		/* E-MAC has TX counters */
 	unsigned multi_irqs:1;		/* AVB-DMAC and E-MAC has multiple irqs */
 	unsigned irq_en_dis:1;		/* Has separate irq enable and disable regs */
+	unsigned err_mgmt_irqs:1;	/* Line1 (Err) and Line2 (Mgmt) irqs are separate */
 	unsigned gptp:1;		/* AVB-DMAC has gPTP support */
 	unsigned ccc_gac:1;		/* AVB-DMAC has gPTP support active in config mode */
 };
@@ -1046,6 +1047,8 @@ struct ravb_private {
 	int msg_enable;
 	int speed;
 	int emac_irq;
+	int erra_irq;
+	int mgmta_irq;
 	int rx_irqs[NUM_RX_QUEUE];
 	int tx_irqs[NUM_TX_QUEUE];
 
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 57215c834188c..5cdc7bc63e267 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1436,12 +1436,23 @@ static int ravb_open(struct net_device *ndev)
 				      ndev, dev, "ch19:tx_nc");
 		if (error)
 			goto out_free_irq_nc_rx;
+
+		if (info->err_mgmt_irqs) {
+			error = ravb_hook_irq(priv->erra_irq, ravb_multi_interrupt,
+					      ndev, dev, "err_a");
+			if (error)
+				goto out_free_irq_nc_tx;
+			error = ravb_hook_irq(priv->mgmta_irq, ravb_multi_interrupt,
+					      ndev, dev, "mgmt_a");
+			if (error)
+				goto out_free_irq_erra;
+		}
 	}
 
 	/* Device init */
 	error = ravb_dmac_init(ndev);
 	if (error)
-		goto out_free_irq_nc_tx;
+		goto out_free_irq_mgmta;
 	ravb_emac_init(ndev);
 
 	/* Initialise PTP Clock driver */
@@ -1461,9 +1472,15 @@ static int ravb_open(struct net_device *ndev)
 	/* Stop PTP Clock driver */
 	if (info->gptp)
 		ravb_ptp_stop(ndev);
-out_free_irq_nc_tx:
+out_free_irq_mgmta:
 	if (!info->multi_irqs)
 		goto out_free_irq;
+	if (info->err_mgmt_irqs)
+		free_irq(priv->mgmta_irq, ndev);
+out_free_irq_erra:
+	if (info->err_mgmt_irqs)
+		free_irq(priv->erra_irq, ndev);
+out_free_irq_nc_tx:
 	free_irq(priv->tx_irqs[RAVB_NC], ndev);
 out_free_irq_nc_rx:
 	free_irq(priv->rx_irqs[RAVB_NC], ndev);
@@ -1791,6 +1808,10 @@ static int ravb_close(struct net_device *ndev)
 		free_irq(priv->tx_irqs[RAVB_BE], ndev);
 		free_irq(priv->rx_irqs[RAVB_BE], ndev);
 		free_irq(priv->emac_irq, ndev);
+		if (info->err_mgmt_irqs) {
+			free_irq(priv->erra_irq, ndev);
+			free_irq(priv->mgmta_irq, ndev);
+		}
 	}
 	free_irq(ndev->irq, ndev);
 
@@ -2198,10 +2219,14 @@ static int ravb_probe(struct platform_device *pdev)
 	if (error < 0)
 		goto out_rpm_disable;
 
-	if (info->multi_irqs)
-		irq = platform_get_irq_byname(pdev, "ch22");
-	else
+	if (info->multi_irqs) {
+		if (info->err_mgmt_irqs)
+			irq = platform_get_irq_byname(pdev, "dia");
+		else
+			irq = platform_get_irq_byname(pdev, "ch22");
+	} else {
 		irq = platform_get_irq(pdev, 0);
+	}
 	if (irq < 0) {
 		error = irq;
 		goto out_release;
@@ -2240,7 +2265,10 @@ static int ravb_probe(struct platform_device *pdev)
 		of_property_read_bool(np, "renesas,ether-link-active-low");
 
 	if (info->multi_irqs) {
-		irq = platform_get_irq_byname(pdev, "ch24");
+		if (info->err_mgmt_irqs)
+			irq = platform_get_irq_byname(pdev, "line3");
+		else
+			irq = platform_get_irq_byname(pdev, "ch24");
 		if (irq < 0) {
 			error = irq;
 			goto out_release;
@@ -2262,6 +2290,22 @@ static int ravb_probe(struct platform_device *pdev)
 			}
 			priv->tx_irqs[i] = irq;
 		}
+
+		if (info->err_mgmt_irqs) {
+			irq = platform_get_irq_byname(pdev, "err_a");
+			if (irq < 0) {
+				error = irq;
+				goto out_release;
+			}
+			priv->erra_irq = irq;
+
+			irq = platform_get_irq_byname(pdev, "mgmt_a");
+			if (irq < 0) {
+				error = irq;
+				goto out_release;
+			}
+			priv->mgmta_irq = irq;
+		}
 	}
 
 	priv->clk = devm_clk_get(&pdev->dev, NULL);
-- 
2.42.0



