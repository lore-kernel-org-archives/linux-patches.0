Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3FD8149C7B;
	Mon,  6 Jan 2025 15:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177442; cv=none; b=ASE1c3hWHmWBfR/ji4CdnYH8bqoSE8SL/4bJrnN/qMAhqMQfv3rk6xUD+Scd6cUblV9ydwnKrzYYNN4qhUIfxiLCyKZTIuO5IJIcz5LPnhoTdHNcvrCNQBxaTXSK1I88Le/iphsonsb7PhYOCCsAED8KDSLB0Ou/V6MfnFI7NWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177442; c=relaxed/simple;
	bh=YuXpynjOIJv3hSylJ/EtmRtbltllW16xEjAJWcuNQrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5B5Ohj3D1isE3etGsS1k0q9l1DYfqa4nX6AV9G7gieCcaYfgCjLQLoOTTuy9EPUzuAa0yTiI7P9RrDlCCTGqSM5Ew1JhZsL8dYzzH8GI7tRZhQVpsOEzrNAytg14V0zChHH7ck+rM4v/MB4aRT0/RMxnzkfohPXisI0HFyUiWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p8bQZfms; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p8bQZfms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C84C4CED2;
	Mon,  6 Jan 2025 15:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177441;
	bh=YuXpynjOIJv3hSylJ/EtmRtbltllW16xEjAJWcuNQrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p8bQZfmswX3eW33mNWdh4MSi8lZbmdiFC9+sFX2uq2ySgvTD/sUs4pmYBzFJQghkM
	 BkohcGjo1TfutLOIgo9lDJ06w0xYlQfShzn5JLnitiQUBcExGEtsX9G/bFr+cGvmVJ
	 joprGsYLAYwn0ScWpE8LekiTw2Q5UNmTKPztt6X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitalii Mordan <mordan@ispras.ru>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 166/222] eth: bcmsysport: fix call balance of priv->clk handling routines
Date: Mon,  6 Jan 2025 16:16:10 +0100
Message-ID: <20250106151157.048415436@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitalii Mordan <mordan@ispras.ru>

[ Upstream commit b255ef45fcc2141c1bf98456796abb956d843a27 ]

Check the return value of clk_prepare_enable to ensure that priv->clk has
been successfully enabled.

If priv->clk was not enabled during bcm_sysport_probe, bcm_sysport_resume,
or bcm_sysport_open, it must not be disabled in any subsequent execution
paths.

Fixes: 31bc72d97656 ("net: systemport: fetch and use clock resources")
Signed-off-by: Vitalii Mordan <mordan@ispras.ru>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20241227123007.2333397-1-mordan@ispras.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 49e890a7e04a..23cc2d85994e 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -1967,7 +1967,11 @@ static int bcm_sysport_open(struct net_device *dev)
 	unsigned int i;
 	int ret;
 
-	clk_prepare_enable(priv->clk);
+	ret = clk_prepare_enable(priv->clk);
+	if (ret) {
+		netdev_err(dev, "could not enable priv clock\n");
+		return ret;
+	}
 
 	/* Reset UniMAC */
 	umac_reset(priv);
@@ -2625,7 +2629,11 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 		goto err_deregister_notifier;
 	}
 
-	clk_prepare_enable(priv->clk);
+	ret = clk_prepare_enable(priv->clk);
+	if (ret) {
+		dev_err(&pdev->dev, "could not enable priv clock\n");
+		goto err_deregister_netdev;
+	}
 
 	priv->rev = topctrl_readl(priv, REV_CNTL) & REV_MASK;
 	dev_info(&pdev->dev,
@@ -2639,6 +2647,8 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_deregister_netdev:
+	unregister_netdev(dev);
 err_deregister_notifier:
 	unregister_netdevice_notifier(&priv->netdev_notifier);
 err_deregister_fixed_link:
@@ -2810,7 +2820,12 @@ static int __maybe_unused bcm_sysport_resume(struct device *d)
 	if (!netif_running(dev))
 		return 0;
 
-	clk_prepare_enable(priv->clk);
+	ret = clk_prepare_enable(priv->clk);
+	if (ret) {
+		netdev_err(dev, "could not enable priv clock\n");
+		return ret;
+	}
+
 	if (priv->wolopts)
 		clk_disable_unprepare(priv->wol_clk);
 
-- 
2.39.5



