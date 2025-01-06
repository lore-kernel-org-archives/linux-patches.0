Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D471DED64;
	Mon,  6 Jan 2025 15:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178416; cv=none; b=LzcrgtFs1agR40sbyAL+i9921hIfihIoJTpYejN5XPjb1ZidklyMiXKk80xaxE1Te4eU4BsjmbnQkd4hEo16fwJ8oV++FLUyFhQ43gUi0WFPL8robQgwe0/PIWBTaHhvgVt7uVUeQQSlxUHw+Pp0Sgf+engiqqcA/9Qelp487IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178416; c=relaxed/simple;
	bh=KN5FeK4RZDyOnaLk6q285263m+MGC/DAU/NevG5aHEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDk4a4MzGMhlOH/1ZBBC1/VcN/VqcHMhx9i44McYAD9aQrbaCJW+y+8aSRBySCi0BKFqMuLDruf+jGcCVDv6LA/+l7oJBS5yQ3Pvo/wTzJWeXbzeg3FxN+WZxoJJ3OyOAXhSp7Ve6Z4Tpmyc6akfgBe3YwKKzomsIqk0tawOxN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UFOWYOEa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFOWYOEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FD5C4CED2;
	Mon,  6 Jan 2025 15:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178415;
	bh=KN5FeK4RZDyOnaLk6q285263m+MGC/DAU/NevG5aHEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UFOWYOEastygZME4J9LsxEtphuTdnaaM6e5OEmr/hqIwFVaUaJh1DWtVzDZOnVFvR
	 i2sGDVY7ZouH6dZI5SndVGWjSxwmnoOUE9Vg+sXdYp5Yx980lGTVQaUV+ArzrZ8mOK
	 gDb3v9PSSxNYk8gRpdDHYBhOFRKXg/BuH+vpA5zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitalii Mordan <mordan@ispras.ru>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/138] eth: bcmsysport: fix call balance of priv->clk handling routines
Date: Mon,  6 Jan 2025 16:17:14 +0100
Message-ID: <20250106151137.392826000@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ae1cf2ead9a9..1c6b7808a100 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -1951,7 +1951,11 @@ static int bcm_sysport_open(struct net_device *dev)
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
@@ -2622,7 +2626,11 @@ static int bcm_sysport_probe(struct platform_device *pdev)
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
@@ -2636,6 +2644,8 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_deregister_netdev:
+	unregister_netdev(dev);
 err_deregister_notifier:
 	unregister_dsa_notifier(&priv->dsa_notifier);
 err_deregister_fixed_link:
@@ -2807,7 +2817,12 @@ static int __maybe_unused bcm_sysport_resume(struct device *d)
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



