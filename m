Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70BD1A7262;
	Wed, 20 Nov 2024 12:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107582; cv=none; b=dQVALRYc+e1BHFMIQPRao804wmzWKnq6Z3xhwA0c1ZeUNaqBg18ZRE8qouQo6oVBnxk73UEfJ72N5c418cfGfNGA0OCE1zlVHx9IhJ2XleEgDOTS6GPH74+jidfmicXv81bmSZXWE9VVbTHmKWXZ+8GxW4M9vIa/+oKhkS9cEfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107582; c=relaxed/simple;
	bh=i6jPMdquwlpoQ1yiEG6F/GuxOrhYi3bpVfGIk7bWZeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQS/l9y6bLbdRdFQTMIczNVQRHwQ+W1p4JuSWPkUJBt+EtKET0aMyvaQGfM9x+lctQKluVvD83m3aznFuL0QXLYm0AMs82JEmDE7V6WlPtugaunIjdfg70VekyUoaLLRH8i7FE6PZnUslJjrCPdjgJNzdZ72j4/0PxA0F9o1R9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tuQt/pkX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tuQt/pkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB64FC4CECD;
	Wed, 20 Nov 2024 12:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107581;
	bh=i6jPMdquwlpoQ1yiEG6F/GuxOrhYi3bpVfGIk7bWZeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tuQt/pkXqUxQM8gUWCacy2Yi6X+W40t3KkKOtgnPFPmSiPH7d5t02qW0oeWvI38Bq
	 35Azr9/ELlWSHpyy51o7Z/hZ647idt5uPcp13FL0L0RLC8Cr9i/v4FY/xJ24ygmO6x
	 fvtAph/ysYkh2Ksdc9t2/ELGo8Y27d64sfgWjuSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitalii Mordan <mordan@ispras.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 23/82] stmmac: dwmac-intel-plat: fix call balance of tx_clk handling routines
Date: Wed, 20 Nov 2024 13:56:33 +0100
Message-ID: <20241120125630.131656879@linuxfoundation.org>
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

From: Vitalii Mordan <mordan@ispras.ru>

[ Upstream commit 5b366eae71937ae7412365340b431064625f9617 ]

If the clock dwmac->tx_clk was not enabled in intel_eth_plat_probe,
it should not be disabled in any path.

Conversely, if it was enabled in intel_eth_plat_probe, it must be disabled
in all error paths to ensure proper cleanup.

Found by Linux Verification Center (linuxtesting.org) with Klever.

Fixes: 9efc9b2b04c7 ("net: stmmac: Add dwmac-intel-plat for GBE driver")
Signed-off-by: Vitalii Mordan <mordan@ispras.ru>
Link: https://patch.msgid.link/20241108173334.2973603-1-mordan@ispras.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../stmicro/stmmac/dwmac-intel-plat.c         | 25 +++++++++++++------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
index 70edc5232379f..134f6506df99a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
@@ -111,7 +111,12 @@ static int intel_eth_plat_probe(struct platform_device *pdev)
 			if (IS_ERR(dwmac->tx_clk))
 				return PTR_ERR(dwmac->tx_clk);
 
-			clk_prepare_enable(dwmac->tx_clk);
+			ret = clk_prepare_enable(dwmac->tx_clk);
+			if (ret) {
+				dev_err(&pdev->dev,
+					"Failed to enable tx_clk\n");
+				return ret;
+			}
 
 			/* Check and configure TX clock rate */
 			rate = clk_get_rate(dwmac->tx_clk);
@@ -122,7 +127,7 @@ static int intel_eth_plat_probe(struct platform_device *pdev)
 				if (ret) {
 					dev_err(&pdev->dev,
 						"Failed to set tx_clk\n");
-					return ret;
+					goto err_tx_clk_disable;
 				}
 			}
 		}
@@ -136,7 +141,7 @@ static int intel_eth_plat_probe(struct platform_device *pdev)
 			if (ret) {
 				dev_err(&pdev->dev,
 					"Failed to set clk_ptp_ref\n");
-				return ret;
+				goto err_tx_clk_disable;
 			}
 		}
 	}
@@ -152,12 +157,15 @@ static int intel_eth_plat_probe(struct platform_device *pdev)
 	}
 
 	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
-	if (ret) {
-		clk_disable_unprepare(dwmac->tx_clk);
-		return ret;
-	}
+	if (ret)
+		goto err_tx_clk_disable;
 
 	return 0;
+
+err_tx_clk_disable:
+	if (dwmac->data->tx_clk_en)
+		clk_disable_unprepare(dwmac->tx_clk);
+	return ret;
 }
 
 static void intel_eth_plat_remove(struct platform_device *pdev)
@@ -165,7 +173,8 @@ static void intel_eth_plat_remove(struct platform_device *pdev)
 	struct intel_dwmac *dwmac = get_stmmac_bsp_priv(&pdev->dev);
 
 	stmmac_pltfr_remove(pdev);
-	clk_disable_unprepare(dwmac->tx_clk);
+	if (dwmac->data->tx_clk_en)
+		clk_disable_unprepare(dwmac->tx_clk);
 }
 
 static struct platform_driver intel_eth_plat_driver = {
-- 
2.43.0



