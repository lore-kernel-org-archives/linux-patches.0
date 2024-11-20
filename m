Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB621AA1E6;
	Wed, 20 Nov 2024 12:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107579; cv=none; b=fBd7urFtCm+Ybv497c8dSMsIXYdYr/g1ry77tO7Cp6LfRHJVhffpqiQkzmiNzJ/BWz3+WnjgbbY0hG/wW37M9B6SHwPx0BPO7MeNS3FGNzbZg1C/rjElmO3TP46VOzygQvgd69uFJ8cft5rsGCmZpad7mSDlu499CCuMPG+SVrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107579; c=relaxed/simple;
	bh=aR5gt2do2CU3NtpGWi9mKiyQTd8Q5Dkfd9cWCmP10Ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6KKnYtZWNjA+rG7E7T7VVxJOrdxBKT/JQp0zPtQ30nFGe9e46ciLGorh3g8nhGugJYF5J7JlenIIjg43OhCe0wmduZQVD6Zihcfpe8Xw7UlYvFZGEErfU2tqzHmMrTS6RPjAVaSsdAGZUK/5cZf8eMdVUA8qOCUf6ggN7IWRQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vIbjvwoh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vIbjvwoh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E94DC4CECD;
	Wed, 20 Nov 2024 12:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107579;
	bh=aR5gt2do2CU3NtpGWi9mKiyQTd8Q5Dkfd9cWCmP10Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vIbjvwohjV5IldC1orBkd7x3dNk8AfZR2ceaw+Pq4lL47QgGCVDd5s/B0Tf5x8qfg
	 Q64iL+jx/lHy2lEnYht72ke8WIVO4mkCpDDvmtzIMeZf4flGq/+McvRemnzd6arb33
	 5LVT6jeI7QDN2px+nyjFPtvStsOVSGuh0ZM7hAPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 20/82] net: stmmac: dwmac-intel-plat: use devm_stmmac_probe_config_dt()
Date: Wed, 20 Nov 2024 13:56:30 +0100
Message-ID: <20241120125630.066799305@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit abea8fd5e801a679312479b2bf00d7b4285eca78 ]

Simplify the driver's probe() function by using the devres
variant of stmmac_probe_config_dt().

The calling of stmmac_pltfr_remove() now needs to be switched to
stmmac_pltfr_remove_no_dt().

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 5b366eae7193 ("stmmac: dwmac-intel-plat: fix call balance of tx_clk handling routines")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../stmicro/stmmac/dwmac-intel-plat.c         | 27 +++++++------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
index d352a14f9d483..d1aec2ca2b429 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
@@ -85,17 +85,15 @@ static int intel_eth_plat_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
+	plat_dat = devm_stmmac_probe_config_dt(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat)) {
 		dev_err(&pdev->dev, "dt configuration failed\n");
 		return PTR_ERR(plat_dat);
 	}
 
 	dwmac = devm_kzalloc(&pdev->dev, sizeof(*dwmac), GFP_KERNEL);
-	if (!dwmac) {
-		ret = -ENOMEM;
-		goto err_remove_config_dt;
-	}
+	if (!dwmac)
+		return -ENOMEM;
 
 	dwmac->dev = &pdev->dev;
 	dwmac->tx_clk = NULL;
@@ -110,10 +108,8 @@ static int intel_eth_plat_probe(struct platform_device *pdev)
 		/* Enable TX clock */
 		if (dwmac->data->tx_clk_en) {
 			dwmac->tx_clk = devm_clk_get(&pdev->dev, "tx_clk");
-			if (IS_ERR(dwmac->tx_clk)) {
-				ret = PTR_ERR(dwmac->tx_clk);
-				goto err_remove_config_dt;
-			}
+			if (IS_ERR(dwmac->tx_clk))
+				return PTR_ERR(dwmac->tx_clk);
 
 			clk_prepare_enable(dwmac->tx_clk);
 
@@ -126,7 +122,7 @@ static int intel_eth_plat_probe(struct platform_device *pdev)
 				if (ret) {
 					dev_err(&pdev->dev,
 						"Failed to set tx_clk\n");
-					goto err_remove_config_dt;
+					return ret;
 				}
 			}
 		}
@@ -140,7 +136,7 @@ static int intel_eth_plat_probe(struct platform_device *pdev)
 			if (ret) {
 				dev_err(&pdev->dev,
 					"Failed to set clk_ptp_ref\n");
-				goto err_remove_config_dt;
+				return ret;
 			}
 		}
 	}
@@ -158,22 +154,17 @@ static int intel_eth_plat_probe(struct platform_device *pdev)
 	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (ret) {
 		clk_disable_unprepare(dwmac->tx_clk);
-		goto err_remove_config_dt;
+		return ret;
 	}
 
 	return 0;
-
-err_remove_config_dt:
-	stmmac_remove_config_dt(pdev, plat_dat);
-
-	return ret;
 }
 
 static void intel_eth_plat_remove(struct platform_device *pdev)
 {
 	struct intel_dwmac *dwmac = get_stmmac_bsp_priv(&pdev->dev);
 
-	stmmac_pltfr_remove(pdev);
+	stmmac_pltfr_remove_no_dt(pdev);
 	clk_disable_unprepare(dwmac->tx_clk);
 }
 
-- 
2.43.0



