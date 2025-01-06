Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE1F146D6B;
	Mon,  6 Jan 2025 15:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177754; cv=none; b=pWaTIQavakfEHMPDmLI52eQJdE0Gtu5je+p1bazvBUirFlRKKGBM1NX98iFWXewOWAnGz7d9P7u5s5og1N3gddXUig7Am58SHyFvABzrclMBGhjTmKZzmoNm//PAVdqCoCR61eOh9uXzoEgl9ViJO+6NcrIesWRHcYxdUN2GrVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177754; c=relaxed/simple;
	bh=Yiusp/zFRRw9Q5O3NsfEsXK+6BmgD5ACRjfRFC1J/fE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JlVpnvEbS82MZReRcsIdWUAi5j0DmYvwAaASaqYWB38uYTgHoAvO+e6tBD1v3FGS/GFCVAmdFmuVDgdsu4ow5iag2tl4HjQJVlTX9kkDm7fGIRDP767NDCBud0jvWj+72dRGaxw0t2GByox9KILWVDSNxpx+gsruRJhb+isSzE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eotq6uHV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eotq6uHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89307C4CED2;
	Mon,  6 Jan 2025 15:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177753;
	bh=Yiusp/zFRRw9Q5O3NsfEsXK+6BmgD5ACRjfRFC1J/fE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eotq6uHVeZBzUzWWrwpoY8f3NIMYQxW6mdygvgpAH5mICUcWnt+Ysk89QH0Gmod91
	 uJ+TvVElXVswJtc1LA737EYbUuSLgcAbxsVvZuYBExBWNzp0FYTQ7J8Wx3cxhnKwMA
	 VNJNHsPitBTy3Nbqy2oZJ5F65J9e/zfI91j3ZWQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/156] net: stmmac: restructure the error path of stmmac_probe_config_dt()
Date: Mon,  6 Jan 2025 16:15:30 +0100
Message-ID: <20250106151143.396411007@linuxfoundation.org>
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

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit 2b6ffcd7873b7e8a62c3e15a6f305bfc747c466b ]

Current implementation of stmmac_probe_config_dt() does not release the
OF node reference obtained by of_parse_phandle() in some error paths.
The problem is that some error paths call stmmac_remove_config_dt() to
clean up but others use and unwind ladder.  These two types of error
handling have not kept in sync and have been a recurring source of bugs.
Re-write the error handling in stmmac_probe_config_dt() to use an unwind
ladder. Consequently, stmmac_remove_config_dt() is not needed anymore,
thus remove it.

This bug was found by an experimental verification tool that I am
developing.

Fixes: 4838a5405028 ("net: stmmac: Fix wrapper drivers not detecting PHY")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Link: https://patch.msgid.link/20241219024119.2017012-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/stmicro/stmmac/stmmac_platform.c | 43 ++++++++-----------
 1 file changed, 17 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index ad868e8d195d..aaf008bdbbcd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -405,22 +405,6 @@ static int stmmac_of_get_mac_mode(struct device_node *np)
 	return -ENODEV;
 }
 
-/**
- * stmmac_remove_config_dt - undo the effects of stmmac_probe_config_dt()
- * @pdev: platform_device structure
- * @plat: driver data platform structure
- *
- * Release resources claimed by stmmac_probe_config_dt().
- */
-static void stmmac_remove_config_dt(struct platform_device *pdev,
-				    struct plat_stmmacenet_data *plat)
-{
-	clk_disable_unprepare(plat->stmmac_clk);
-	clk_disable_unprepare(plat->pclk);
-	of_node_put(plat->phy_node);
-	of_node_put(plat->mdio_node);
-}
-
 /**
  * stmmac_probe_config_dt - parse device-tree driver parameters
  * @pdev: platform_device structure
@@ -490,8 +474,10 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 		dev_warn(&pdev->dev, "snps,phy-addr property is deprecated\n");
 
 	rc = stmmac_mdio_setup(plat, np, &pdev->dev);
-	if (rc)
-		return ERR_PTR(rc);
+	if (rc) {
+		ret = ERR_PTR(rc);
+		goto error_put_phy;
+	}
 
 	of_property_read_u32(np, "tx-fifo-depth", &plat->tx_fifo_size);
 
@@ -580,8 +566,8 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 	dma_cfg = devm_kzalloc(&pdev->dev, sizeof(*dma_cfg),
 			       GFP_KERNEL);
 	if (!dma_cfg) {
-		stmmac_remove_config_dt(pdev, plat);
-		return ERR_PTR(-ENOMEM);
+		ret = ERR_PTR(-ENOMEM);
+		goto error_put_mdio;
 	}
 	plat->dma_cfg = dma_cfg;
 
@@ -609,8 +595,8 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 
 	rc = stmmac_mtl_setup(pdev, plat);
 	if (rc) {
-		stmmac_remove_config_dt(pdev, plat);
-		return ERR_PTR(rc);
+		ret = ERR_PTR(rc);
+		goto error_put_mdio;
 	}
 
 	/* clock setup */
@@ -662,6 +648,10 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 	clk_disable_unprepare(plat->pclk);
 error_pclk_get:
 	clk_disable_unprepare(plat->stmmac_clk);
+error_put_mdio:
+	of_node_put(plat->mdio_node);
+error_put_phy:
+	of_node_put(plat->phy_node);
 
 	return ret;
 }
@@ -670,16 +660,17 @@ static void devm_stmmac_remove_config_dt(void *data)
 {
 	struct plat_stmmacenet_data *plat = data;
 
-	/* Platform data argument is unused */
-	stmmac_remove_config_dt(NULL, plat);
+	clk_disable_unprepare(plat->stmmac_clk);
+	clk_disable_unprepare(plat->pclk);
+	of_node_put(plat->mdio_node);
+	of_node_put(plat->phy_node);
 }
 
 /**
  * devm_stmmac_probe_config_dt
  * @pdev: platform_device structure
  * @mac: MAC address to use
- * Description: Devres variant of stmmac_probe_config_dt(). Does not require
- * the user to call stmmac_remove_config_dt() at driver detach.
+ * Description: Devres variant of stmmac_probe_config_dt().
  */
 struct plat_stmmacenet_data *
 devm_stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
-- 
2.39.5



