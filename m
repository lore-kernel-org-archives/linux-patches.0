Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FDE24C08D;
	Tue, 29 Apr 2025 16:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945954; cv=none; b=SqfgMFPRT4edml7mOq+6Ux6arZi9ZVR/5OzGDwfPgA4h28Ad23X6zhGShzKzcc7um/X8vMoW1UP56ada//T7RKFNyRIWYhYUuA+DelqA2VgUilPr8k8crJrb4HwqZL2q/PMzyyDfxZjqJ2T9fM8m3+U0Q1etRmjtNXes9/cK+Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945954; c=relaxed/simple;
	bh=d005Owtr5lJfWKpXALtVLnlyYH6ML3eHfQI473gCfCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWalS1uUL2VLlCpE73uDuYFGRCxV/nQM12YVCDtk54L+mSfSOJzAlR65v61k1WTHxvNbVJsi6ibpxepubBo0MUMYZGeK1SvHQqAhTmAJDwlPeUVty13wjSJ/ez4SDpsnXQtPLJXK9seD0thUXvcA464LhrTyJO+IIxhxdNYyxmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0a+fe99u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0a+fe99u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22D6C4CEE3;
	Tue, 29 Apr 2025 16:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945954;
	bh=d005Owtr5lJfWKpXALtVLnlyYH6ML3eHfQI473gCfCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0a+fe99uhdNiZOJ/C3iaz4QCc9ASJ3Jx5gLO9SVfaDgdUieDUcSKA6H5nMxK3FY50
	 RVI8fd58DFCbLmpB6O0l/4v1czfOymfNAQSHIV1hpgDkGgLC2OD+ymQYVK52fKD/Gh
	 D0ZGJaAW20nIu09mOpGxE2Wr+M8l3OX/nrs9T01g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 6.14 105/311] net: stmmac: address non-LPI resume failures properly
Date: Tue, 29 Apr 2025 18:39:02 +0200
Message-ID: <20250429161125.336689742@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

commit ef43e5132895ad59b45e38855d32e966bb7434d9 upstream.

The Synopsys Designware GMAC core databook requires all clocks to be
active in order to complete software reset, which we perform during
resume.

However, IEEE 802.3 allows a PHY to stop its clocks when placed in
low-power mode, which happens when the system is suspended and WoL
is not enabled.

As an attempt to work around this, commit 36d18b5664ef ("net: stmmac:
start phylink instance before stmmac_hw_setup()") started phylink
early, but this has the side effect that the mac_link_up() method may
be called before or during the initialisation of GMAC hardware.

We also have the socfpga glue driver directly calling phy_resume()
also as an attempt to work around this.

In a previous commit, phylink_prepare_resume() has been introduced
to give MAC drivers a way to ensure that the PHY is resumed prior to
their initialisation of their MAC hardware. This commit adds the call,
and moves the phylink_resume() call back to where it should be before
the aforementioned commit.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/E1tvO6a-008Vjh-FG@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7907,12 +7907,12 @@ int stmmac_resume(struct device *dev)
 	}
 
 	rtnl_lock();
-	phylink_resume(priv->phylink);
-	if (device_may_wakeup(priv->device) && !priv->plat->pmt)
-		phylink_speed_up(priv->phylink);
-	rtnl_unlock();
 
-	rtnl_lock();
+	/* Prepare the PHY to resume, ensuring that its clocks which are
+	 * necessary for the MAC DMA reset to complete are running
+	 */
+	phylink_prepare_resume(priv->phylink);
+
 	mutex_lock(&priv->lock);
 
 	stmmac_reset_queues_param(priv);
@@ -7930,6 +7930,15 @@ int stmmac_resume(struct device *dev)
 	stmmac_enable_all_dma_irq(priv);
 
 	mutex_unlock(&priv->lock);
+
+	/* phylink_resume() must be called after the hardware has been
+	 * initialised because it may bring the link up immediately in a
+	 * workqueue thread, which will race with initialisation.
+	 */
+	phylink_resume(priv->phylink);
+	if (device_may_wakeup(priv->device) && !priv->plat->pmt)
+		phylink_speed_up(priv->phylink);
+
 	rtnl_unlock();
 
 	netif_device_attach(ndev);


