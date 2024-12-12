Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7662153EC;
	Thu, 12 Dec 2024 17:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025320; cv=none; b=Y6vsVOH7fC5HEemXhFyFxl95obzK/J+mO/VfklktY+63mhfgOoldWkzhP+evezMPZRtceCZjjXe1zk8Gu1eFaqLC3JO6jNpsMMLJgsUmDLqpoUIYWXJBlMmGQAoOGbp9FqW+c7OSVolYKrCqQTkVvDWBEwGRuy5o2i4yohutZBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025320; c=relaxed/simple;
	bh=J6g8u11b2uUvF4ecaxkv3SLBz4cVsFY06tnc7S/qZps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DvVmLa9d2RBNiCQDa3LtnIJC99waGsrnPOxctf8j2BxlJWCwxTuKtAbFMLqVEFJrhEv2YDQ9FSy93y1WgNZC4+f30G62r13rm4e9drjMkaOS8liMkC/V8I2bDKbr54aS/56c/hgSgLqU8vflas0xJqKGBAdIb9UeIyhKAm8ZXEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f5No5fMm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f5No5fMm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4745C4CECE;
	Thu, 12 Dec 2024 17:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025320;
	bh=J6g8u11b2uUvF4ecaxkv3SLBz4cVsFY06tnc7S/qZps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f5No5fMmD/PiGjsbCIpfOnpXwwLTG6u+EdEUNGRy3n/Lr0GxjRd31N5lAUe+M0xZu
	 3hqh3aF39TjJu7w6a6MjW0y4o+0c8Vnw3xdeuNqYo+YoD57AL/15wuPhyTHxmJPjMj
	 kG8U/KTxeIvDOqy8xHJiqkEk1nfHZZRmorqzfFKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitalii Mordan <mordan@ispras.ru>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 130/321] marvell: pxa168_eth: fix call balance of pep->clk handling routines
Date: Thu, 12 Dec 2024 16:00:48 +0100
Message-ID: <20241212144235.111879442@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/ethernet/marvell/pxa168_eth.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index 235bbb2940a88..0df507686b569 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1407,18 +1407,15 @@ static int pxa168_eth_probe(struct platform_device *pdev)
 
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
@@ -1531,8 +1528,6 @@ static int pxa168_eth_probe(struct platform_device *pdev)
 	mdiobus_free(pep->smi_bus);
 err_netdev:
 	free_netdev(dev);
-err_clk:
-	clk_disable_unprepare(clk);
 	return err;
 }
 
-- 
2.43.0



