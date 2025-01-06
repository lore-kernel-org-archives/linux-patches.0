Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E6615A842;
	Mon,  6 Jan 2025 15:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178901; cv=none; b=KDTSbIMcRfKvbUF++cHoks6F8i4BIZukFm0ZAw2ogaq+UqQoNZxFgB9mZhj7fXy1YLS23NgYZNBaAjSyz/BQ077CkrdWNIf9ERyw8snzQ4OKxK+R2rjFNKxD3qafmAyFcivUcZsC5/sFfwog8KZamplJqt7CVTQqVnKoNg1fsXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178901; c=relaxed/simple;
	bh=ldleyQ8XGGruGAt3NNcllFoCkTNommv8mG+/Lhg+e2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrMkpL6EV8oSbb5N5Ex+KxgG1iI/jrtG1QUKrLg668OxW0dFIZ8o0Xwz3Mx5zbLRi7ROTuPq7aILfGbxzLBg6gNrO27rbdZT00vBLVbtZjLCVqNvjGF6DRv5orKhiQhPi5udFJ7OGpKrnl9udyRf6a/45bYDWGGd01lkFf82qm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SR+9GDBr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SR+9GDBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCBDC4CED2;
	Mon,  6 Jan 2025 15:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178901;
	bh=ldleyQ8XGGruGAt3NNcllFoCkTNommv8mG+/Lhg+e2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SR+9GDBrFKKZptGpQGYlgm/U43vgTq+089M+1Tl9+5iNJ2ZnRzLOEVJRiVsYcA+5n
	 5jtJuRvpBs8EjCo+YawLIJsB83+3oOOEvQOtLYJky2cDRnHhF0/0vzRxcOe5fGZSFF
	 FEiFXmv2aPXvWjPwo4wDRkeB4RVyAcr+k7mJEkHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/168] net: stmmac: restructure the error path of stmmac_probe_config_dt()
Date: Mon,  6 Jan 2025 16:17:18 +0100
Message-ID: <20250106151143.351197816@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 .../ethernet/stmicro/stmmac/stmmac_platform.c | 27 ++++++++++++-------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 7f816f0cf9a5..36b013b9d99e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -472,8 +472,10 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 		dev_warn(&pdev->dev, "snps,phy-addr property is deprecated\n");
 
 	rc = stmmac_mdio_setup(plat, np, &pdev->dev);
-	if (rc)
-		return ERR_PTR(rc);
+	if (rc) {
+		ret = ERR_PTR(rc);
+		goto error_put_phy;
+	}
 
 	of_property_read_u32(np, "tx-fifo-depth", &plat->tx_fifo_size);
 
@@ -559,8 +561,8 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 	dma_cfg = devm_kzalloc(&pdev->dev, sizeof(*dma_cfg),
 			       GFP_KERNEL);
 	if (!dma_cfg) {
-		stmmac_remove_config_dt(pdev, plat);
-		return ERR_PTR(-ENOMEM);
+		ret = ERR_PTR(-ENOMEM);
+		goto error_put_mdio;
 	}
 	plat->dma_cfg = dma_cfg;
 
@@ -588,8 +590,8 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 
 	rc = stmmac_mtl_setup(pdev, plat);
 	if (rc) {
-		stmmac_remove_config_dt(pdev, plat);
-		return ERR_PTR(rc);
+		ret = ERR_PTR(rc);
+		goto error_put_mdio;
 	}
 
 	/* clock setup */
@@ -641,6 +643,10 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 	clk_disable_unprepare(plat->pclk);
 error_pclk_get:
 	clk_disable_unprepare(plat->stmmac_clk);
+error_put_mdio:
+	of_node_put(plat->mdio_node);
+error_put_phy:
+	of_node_put(plat->phy_node);
 
 	return ret;
 }
@@ -649,16 +655,17 @@ static void devm_stmmac_remove_config_dt(void *data)
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



