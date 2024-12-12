Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3863E2054EF;
	Thu, 12 Dec 2024 16:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022579; cv=none; b=MkuOwXKiWfP4gpkZOvI97uNlsF5oH31IJxsb0ALJCYydtSY8GkbsaFeyf5IUoY/2wBSJe7TI+uTrQqzRf3Z9BenLfonPNjnhOmzXXMoHdeJhvOMAW/rnkxBxldyLuqZHUrT1CRpEBELmFab5i5C0LifdCryAU/Ol/T8cn8Sn2lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022579; c=relaxed/simple;
	bh=dbCQrxVbfP0Hi7AmV2DSmdzMCTd9R6DPFMcFni3QBAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BqkZY4IV0/Tunk/odv8spKPg77S3UbGZJZHzc8KAA5X738QUHXtU08wGHzFu4MqxRoBG3XmYBzsSGVrk3UmvciEBOmNjoSxuGqtp7gpctdQrvOlE58q7DEqOkYcHQCTsIyxjxLLauHXn74VGaaXLtWsfXQmFn/+/4nH/9wm8F4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWXtnjE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWXtnjE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E11AC4CED3;
	Thu, 12 Dec 2024 16:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022579;
	bh=dbCQrxVbfP0Hi7AmV2DSmdzMCTd9R6DPFMcFni3QBAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HWXtnjE5+s6L8rGKtCHmzOC/z/3qSNbWHgSZa4XiZEcqvNkm5Ix1n4jRZjLDwnGle
	 lS1kFLqeK8hpoGeNCSMerXjzEDDsnaYYlzfefEK7R/e+BGXF1ENetVcG6qfYsrJbq1
	 Zf9Sgakp0f8x4KuY1VXNt7GpnIVWsxl2gC5D86oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitalii Mordan <mordan@ispras.ru>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 279/565] marvell: pxa168_eth: fix call balance of pep->clk handling routines
Date: Thu, 12 Dec 2024 15:57:54 +0100
Message-ID: <20241212144322.483788608@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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
index 11ef1d8dea15c..a202320c26985 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1396,18 +1396,15 @@ static int pxa168_eth_probe(struct platform_device *pdev)
 
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
@@ -1518,8 +1515,6 @@ static int pxa168_eth_probe(struct platform_device *pdev)
 	mdiobus_free(pep->smi_bus);
 err_netdev:
 	free_netdev(dev);
-err_clk:
-	clk_disable_unprepare(clk);
 	return err;
 }
 
@@ -1537,7 +1532,6 @@ static int pxa168_eth_remove(struct platform_device *pdev)
 	if (dev->phydev)
 		phy_disconnect(dev->phydev);
 
-	clk_disable_unprepare(pep->clk);
 	mdiobus_unregister(pep->smi_bus);
 	mdiobus_free(pep->smi_bus);
 	unregister_netdev(dev);
-- 
2.43.0



