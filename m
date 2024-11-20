Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6601A7262;
	Wed, 20 Nov 2024 12:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107580; cv=none; b=lEb1+kBXfJE62/IaiBvRcisgWABO279osSl9D7E/oev1GdkuxvUbCFF0sKnmSvrWet128jfIT+QNPrY9StWQLuYm5K+5tJ5rJEtfOXQSa+42o5dLyh3zLaP8RZSW7i9GP321mC1NBa0ScdXw89Fw4U/gyPvhUGvgmZ6vqR1Wyb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107580; c=relaxed/simple;
	bh=iOscSGwZ90/RaKqsVpQv0tTMP/GP7LeSdmjYsMGEOh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvMLYM8DaVjukUul+rStp6YU5Wv1XWU8ieVpGicTUrA7wV89zEDW9U9kGY1afbf/M21pip3KmoTdT0JKtXm4P2M+1xhp4W2v1TwzHLMNvhnale4aaDbFgBy2KkWmm65AStEa9oQjxnO9TnAX/Lu3oIzpplrsuvpRrIPFHaDk9r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZqhRl9V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZqhRl9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65FAEC4CECD;
	Wed, 20 Nov 2024 12:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107580;
	bh=iOscSGwZ90/RaKqsVpQv0tTMP/GP7LeSdmjYsMGEOh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZqhRl9VaIXBJFfiz6q+5rXqlRUyvoC1XUjtElxcl2BpDcdsz3aGCD9d6+astSjXN
	 PqM+6M4KCahaKNezzQ3DRjswTr1DF8uwbn3GGQFJ8TAe5tLEOMWuMYkRArvaJD3Siv
	 wVew2dy6BX3xYQg/NpAphZ+K9Qn3fF0m5JbI2mo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 21/82] net: stmmac: dwmac-visconti: use devm_stmmac_probe_config_dt()
Date: Wed, 20 Nov 2024 13:56:31 +0100
Message-ID: <20241120125630.088964530@linuxfoundation.org>
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

[ Upstream commit d336a117b593e96559c309bb250f06b4fc22998f ]

Simplify the driver's probe() function by using the devres
variant of stmmac_probe_config_dt().

The calling of stmmac_pltfr_remove() now needs to be switched to
stmmac_pltfr_remove_no_dt().

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 5b366eae7193 ("stmmac: dwmac-intel-plat: fix call balance of tx_clk handling routines")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/stmicro/stmmac/dwmac-visconti.c  | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
index 22d113fb8e09c..45f5d66a11c26 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
@@ -220,15 +220,13 @@ static int visconti_eth_dwmac_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
+	plat_dat = devm_stmmac_probe_config_dt(pdev, stmmac_res.mac);
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
 	dwmac = devm_kzalloc(&pdev->dev, sizeof(*dwmac), GFP_KERNEL);
-	if (!dwmac) {
-		ret = -ENOMEM;
-		goto remove_config;
-	}
+	if (!dwmac)
+		return -ENOMEM;
 
 	spin_lock_init(&dwmac->lock);
 	dwmac->reg = stmmac_res.addr;
@@ -238,7 +236,7 @@ static int visconti_eth_dwmac_probe(struct platform_device *pdev)
 
 	ret = visconti_eth_clock_probe(pdev, plat_dat);
 	if (ret)
-		goto remove_config;
+		return ret;
 
 	visconti_eth_init_hw(pdev, plat_dat);
 
@@ -252,22 +250,15 @@ static int visconti_eth_dwmac_probe(struct platform_device *pdev)
 
 remove:
 	visconti_eth_clock_remove(pdev);
-remove_config:
-	stmmac_remove_config_dt(pdev, plat_dat);
 
 	return ret;
 }
 
 static void visconti_eth_dwmac_remove(struct platform_device *pdev)
 {
-	struct net_device *ndev = platform_get_drvdata(pdev);
-	struct stmmac_priv *priv = netdev_priv(ndev);
-
-	stmmac_pltfr_remove(pdev);
+	stmmac_pltfr_remove_no_dt(pdev);
 
 	visconti_eth_clock_remove(pdev);
-
-	stmmac_remove_config_dt(pdev, priv->plat);
 }
 
 static const struct of_device_id visconti_eth_dwmac_match[] = {
-- 
2.43.0



