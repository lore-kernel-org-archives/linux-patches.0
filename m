Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2E51ADFE3;
	Mon,  6 Jan 2025 15:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177799; cv=none; b=ql5cta+H0pzmCSCUaOM+Db1qNll5Yi2F7/kI3tMQlIKz+YLGqTKXwrBuz82tE+tBYqvHIyxUZnoxjgDEZVov1VY9bouCuRH7sHL9LUZXBb+/q9VqZwrtkrm/lXpVMIOx0lzjkfjM+NX0oyKWf5FrjuDXZ9TGlniVOkvO2ng5W68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177799; c=relaxed/simple;
	bh=M/YkEiBbp7+RFIqVCGLEq5HOsp1G9JY80LhWH62UoL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H++ALMKLU1n9E5yuH/hJ9yONpyowlV8J1gbumk40M/L+BDXkOUT/Uy/RsNlH877UxcDvubxILway+TgHleFlBGxiTRWMT3v0XXr2v5Zs4aNrvIc4ck9YaIqYFZube+Ba78DCQD/xAH2L83C9bzFpxLYCUa2FcFDrrFSR44qU13U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aus9Pvm8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aus9Pvm8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3D3C4CED2;
	Mon,  6 Jan 2025 15:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177798;
	bh=M/YkEiBbp7+RFIqVCGLEq5HOsp1G9JY80LhWH62UoL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aus9Pvm8T/7L+mJhJd/JVAVuSnQCri2tVOvZ0ED+X21oBGKL6Mdns8VrcEWybulTO
	 BxQ6vcg2ZcOKCqMV9hPUKTJ0gMxBzxYPqo3pk+8zVlGGWBbPL04wGZgmJSRYosDoR9
	 uw+Tl4DrlDTH1zONf0ALHo9q2nr2pk/3Qulkf/ZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitalii Mordan <mordan@ispras.ru>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/156] eth: bcmsysport: fix call balance of priv->clk handling routines
Date: Mon,  6 Jan 2025 16:15:47 +0100
Message-ID: <20250106151144.035858767@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0a68b526e4a8..2b784ced0645 100644
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
@@ -2808,7 +2818,12 @@ static int __maybe_unused bcm_sysport_resume(struct device *d)
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



