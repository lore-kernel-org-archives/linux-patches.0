Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B6934250E;
	Fri,  7 Aug 2026 14:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113944; cv=none; b=F6Qz8R7OUcxJM2f2m+VMmZqsABHjuT/FCuUKLAQvlxax1+0/1Z3+CjDXSUgwPGqIAdSUCJ0Zt12sPwhYiabvOeVFLGZgl0IO2R24a5KwH4cEQg2p7NcNmcFcqZo4B2Blm/TaCrlkzJyof+sXQJ42sX3AJo6DYC2RKZiUSnPMdtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113944; c=relaxed/simple;
	bh=9B62b2Gc+fdY/Yi0aV6hO5XxaaA96ZV5d0zkn+UQ/0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCzKVLnsEq+Kn/eo+tZ9JA+GJpo6MVm+uqX4LOT+tGiVfzvO/OnsJ6SnIwrlkLXVCGRMhLrWCbNtMN1deVwLJ1d5uCqGVTHBGKl4GgwmtRde2/Kvr8r7sc6sgJ8qJCc4L/qSH93nMbUgFGWeafxHZKou+tq/Lt+uMyvviw+UA/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K9N5qHPt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K9N5qHPt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7331C1F000E9;
	Fri,  7 Aug 2026 14:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113943;
	bh=OZvgDEr60o9KCyLcjfnhv3gAZ0KuMrhCn7GBZpTOvjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K9N5qHPtyryMShwmeOFmtK5ZwglOfSUUyFg/xRFzFGbK8znN9vQj5RC7GDKFYvSEm
	 aUwcRvI35vay4iXr5XyLftn+GL10XToL1PNzBlfKp2IVDVVXwenamgo7hulz9PMrrw
	 AQGIRuMx3ZSNA7Tc83zeuZ/eB6bkl9tmmBaqYacY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Wunderlich <frank-w@public-files.de>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/337] net: ethernet: mtk_eth_soc: support named IRQs
Date: Fri,  7 Aug 2026 16:34:53 +0200
Message-ID: <20260807143420.466574387@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Wunderlich <frank-w@public-files.de>

[ Upstream commit ee85b483fefbbebe1e6e61c53169f864bbdd8f13 ]

Add named interrupts and keep index based fallback for existing
devicetrees.

Currently only rx and tx IRQs are defined to be used with mt7988, but
later extended with RSS/LRO support.

Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250619132125.78368-2-linux@fw-web.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e095f249e220 ("net: ethernet: mtk_eth_soc: pass eth to mtk_handle_irq_rx in poll_controller")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 46 ++++++++++++++++-----
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index ebf5432cb328d..4305779459efd 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3210,6 +3210,37 @@ static void mtk_tx_timeout(struct net_device *dev, unsigned int txqueue)
 	schedule_work(&eth->pending_work);
 }
 
+static int mtk_get_irqs(struct platform_device *pdev, struct mtk_eth *eth)
+{
+	int i;
+
+	/* future SoCs beginning with MT7988 should use named IRQs in dts */
+	eth->irq[1] = platform_get_irq_byname(pdev, "fe1");
+	eth->irq[2] = platform_get_irq_byname(pdev, "fe2");
+	if (eth->irq[1] >= 0 && eth->irq[2] >= 0)
+		return 0;
+
+	/* legacy way:
+	 * On MTK_SHARED_INT SoCs (MT7621 + MT7628) the first IRQ is taken
+	 * from devicetree and used for both RX and TX - it is shared.
+	 * On SoCs with non-shared IRQs the first entry is not used,
+	 * the second is for TX, and the third is for RX.
+	 */
+	for (i = 0; i < 3; i++) {
+		if (MTK_HAS_CAPS(eth->soc->caps, MTK_SHARED_INT) && i > 0)
+			eth->irq[i] = eth->irq[0];
+		else
+			eth->irq[i] = platform_get_irq(pdev, i);
+
+		if (eth->irq[i] < 0) {
+			dev_err(&pdev->dev, "no IRQ%d resource found\n", i);
+			return -ENXIO;
+		}
+	}
+
+	return 0;
+}
+
 static irqreturn_t mtk_handle_irq_rx(int irq, void *_eth)
 {
 	struct mtk_eth *eth = _eth;
@@ -4986,17 +5017,10 @@ static int mtk_probe(struct platform_device *pdev)
 		}
 	}
 
-	for (i = 0; i < 3; i++) {
-		if (MTK_HAS_CAPS(eth->soc->caps, MTK_SHARED_INT) && i > 0)
-			eth->irq[i] = eth->irq[0];
-		else
-			eth->irq[i] = platform_get_irq(pdev, i);
-		if (eth->irq[i] < 0) {
-			dev_err(&pdev->dev, "no IRQ%d resource found\n", i);
-			err = -ENXIO;
-			goto err_wed_exit;
-		}
-	}
+	err = mtk_get_irqs(pdev, eth);
+	if (err)
+		goto err_wed_exit;
+
 	for (i = 0; i < ARRAY_SIZE(eth->clks); i++) {
 		eth->clks[i] = devm_clk_get(eth->dev,
 					    mtk_clks_source_name[i]);
-- 
2.53.0



