Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573AD1991AA;
	Wed, 20 Nov 2024 12:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107503; cv=none; b=cnERTY0vpHlB6XCuOTfwEZEWGUPf4lNK+Jawu+oHKkMnXsQmr55CwUlP/iKV96Y3NVlizhRIzvP6tB6H/FzKzajVfjfSW6YJ65CBVcwhf38jXTO1D+IulXsI2+l7bbtCId++JEzNxPpZqlBEvL4pEpWP5pqb7aT0Yj7B9po5IhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107503; c=relaxed/simple;
	bh=zHhWVgWIkiXvPyopaky4oqTa6nVkbpC19CLds8pKhb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BZqCaHERjcgkI+MN1jFIy383+kqsy7ar1959Q5/ddVXK190T0i4uzPWI495nG2BCMsGbfoqxd0gbu+zgEzoQP+fHiqQMVNqlFQtLiqEUEcvHfPNSsznJp1sLkWwZebemdTTGwPqxE7fL0gxvQQYtayLaddLMuTG6oPWMK1yoaUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kq/taq3r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kq/taq3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A3AC4CECD;
	Wed, 20 Nov 2024 12:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107503;
	bh=zHhWVgWIkiXvPyopaky4oqTa6nVkbpC19CLds8pKhb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kq/taq3rluSRwaJFP9UMfXre8oHGTz+c5KT7c7FNdA2c8Xq0fd9RQvFVt7NMfdaNR
	 0rrWvQC9GsoaPSCOGTUtZPXNQ5ve/QLRWo+kJgPGgroRjdG76EhgAETXw6FAiWWC3k
	 HEwVlsooqvNNwwd1OlJqIWAxz2cSsv5eNSc0sE+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitalii Mordan <mordan@ispras.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 028/107] stmmac: dwmac-intel-plat: fix call balance of tx_clk handling routines
Date: Wed, 20 Nov 2024 13:56:03 +0100
Message-ID: <20241120125630.312872202@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index d68f0c4e78350..9739bc9867c51 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
@@ -108,7 +108,12 @@ static int intel_eth_plat_probe(struct platform_device *pdev)
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
@@ -119,7 +124,7 @@ static int intel_eth_plat_probe(struct platform_device *pdev)
 				if (ret) {
 					dev_err(&pdev->dev,
 						"Failed to set tx_clk\n");
-					return ret;
+					goto err_tx_clk_disable;
 				}
 			}
 		}
@@ -133,7 +138,7 @@ static int intel_eth_plat_probe(struct platform_device *pdev)
 			if (ret) {
 				dev_err(&pdev->dev,
 					"Failed to set clk_ptp_ref\n");
-				return ret;
+				goto err_tx_clk_disable;
 			}
 		}
 	}
@@ -149,12 +154,15 @@ static int intel_eth_plat_probe(struct platform_device *pdev)
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
@@ -162,7 +170,8 @@ static void intel_eth_plat_remove(struct platform_device *pdev)
 	struct intel_dwmac *dwmac = get_stmmac_bsp_priv(&pdev->dev);
 
 	stmmac_pltfr_remove(pdev);
-	clk_disable_unprepare(dwmac->tx_clk);
+	if (dwmac->data->tx_clk_en)
+		clk_disable_unprepare(dwmac->tx_clk);
 }
 
 static struct platform_driver intel_eth_plat_driver = {
-- 
2.43.0



