Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62858211493;
	Thu, 12 Dec 2024 17:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024309; cv=none; b=iDzJifahBD6o0zl5aDm8RrXePYAj8C/SOwx6oEgzC7r8l0+fAZXSiADwVrZzTBJfPr8uAxkS37kyB/o0+9MPnMlG115s4xgEvRly2zH80J+siwTqGzIsj3snhTR83apz4w3xjcR/XYFFsKy96nzWISSxPeZObMpcfF3c1iW8QdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024309; c=relaxed/simple;
	bh=CNtlVLqpiD5PlzGxjxNI+LpYLJIRzq40MfQugVlAptM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QmzNKq5544y6OUf+ND7qfDr3kyC9gomdU44hpW4SQ7tcPk/jQswyFq0YMMvczjxX74dIIA1Z8LM45rOQJnzXNSOsE1frFSdW5A7aDnreorGTZrVeBebR/LNDVpNcpupnvee+SeLqZmRg2+8iOrzLB6oAN4/xCrSueX3PhKTX7cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U234Qpmp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U234Qpmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4377C4CECE;
	Thu, 12 Dec 2024 17:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024309;
	bh=CNtlVLqpiD5PlzGxjxNI+LpYLJIRzq40MfQugVlAptM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U234QpmpQhvX6jEqnDN4xw4eZeWJ9Ndkh0hYdxDMOIwf3hNteGNNZBB5r3PDa3VZI
	 otbj5F/xh0tcyerNENXbPjaWj0mtk1PtUI98x1VLTwM76eRRaDuXNIdxymR0xCAPYR
	 Gpk4Ub947vt+Xa/dI4hemY9pUZdtYX+T3A77bP4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitalii Mordan <mordan@ispras.ru>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 223/459] marvell: pxa168_eth: fix call balance of pep->clk handling routines
Date: Thu, 12 Dec 2024 15:59:21 +0100
Message-ID: <20241212144302.380073095@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitalii Mordan <mordan@ispras.ru>

[ Upstream commit b032ae57d4fe2b2445e3bc190db6fcaa8c102f68 ]

If the clock pep->clk was not enabled in pxa168_eth_probe,
it should not be disabled in any path.

Conversely, if it was enabled in pxa168_eth_probe, it must be disabled
in all error paths to ensure proper cleanup.

Use the devm_clk_get_enabled helper function to ensure proper call balance
for pep->clk.

Found by Linux Verification Center (linuxtesting.org) with Klever.

Fixes: a49f37eed22b ("net: add Fast Ethernet driver for PXA168.")
Signed-off-by: Vitalii Mordan <mordan@ispras.ru>
Link: https://patch.msgid.link/20241121200658.2203871-1-mordan@ispras.ru
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/pxa168_eth.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index 3712e1786091f..cf867b8f43808 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1397,18 +1397,15 @@ static int pxa168_eth_probe(struct platform_device *pdev)
 
 	printk(KERN_NOTICE "PXA168 10/100 Ethernet Driver\n");
 
-	clk = devm_clk_get(&pdev->dev, NULL);
+	clk = devm_clk_get_enabled(&pdev->dev, NULL);
 	if (IS_ERR(clk)) {
-		dev_err(&pdev->dev, "Fast Ethernet failed to get clock\n");
+		dev_err(&pdev->dev, "Fast Ethernet failed to get and enable clock\n");
 		return -ENODEV;
 	}
-	clk_prepare_enable(clk);
 
 	dev = alloc_etherdev(sizeof(struct pxa168_eth_private));
-	if (!dev) {
-		err = -ENOMEM;
-		goto err_clk;
-	}
+	if (!dev)
+		return -ENOMEM;
 
 	platform_set_drvdata(pdev, dev);
 	pep = netdev_priv(dev);
@@ -1523,8 +1520,6 @@ static int pxa168_eth_probe(struct platform_device *pdev)
 	mdiobus_free(pep->smi_bus);
 err_netdev:
 	free_netdev(dev);
-err_clk:
-	clk_disable_unprepare(clk);
 	return err;
 }
 
@@ -1541,7 +1536,6 @@ static int pxa168_eth_remove(struct platform_device *pdev)
 	if (dev->phydev)
 		phy_disconnect(dev->phydev);
 
-	clk_disable_unprepare(pep->clk);
 	mdiobus_unregister(pep->smi_bus);
 	mdiobus_free(pep->smi_bus);
 	cancel_work_sync(&pep->tx_timeout_task);
-- 
2.43.0



