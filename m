Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EAC24C08D;
	Tue, 29 Apr 2025 16:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945957; cv=none; b=set9DHU0wRzly73fDzQPKCWITeIhjui/nmYDSgYU3gNc+tVEfr1DOlIT/ObfEyWzf3HBCDxlSEa71VuuJUxL6XxbAmDsQ16eunPryrJljNdynUiYsG4acXsG+u76hkTfyW7jOeE20hGqy9oAR0BnP/ZMAJkk4IF5xDpHbConA4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945957; c=relaxed/simple;
	bh=ojQc09bG/VpPlGROwXOxLvTsQSRONLyAfFIS99M4P/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igcNhKi18TbtLO2SmnIXhn4gVr+QWeuYuTCEtaAp6ZzRemwH3WudXJXqVbJWQ1g3W8UM9cxKw6BO3zNW0gvtvjIeHVINTgfUxqHGCrz24tYBsQz5Zzj4uq+40dkKRzPYFmUpxn7g+FYc6DVSTP0AR5tg1DqcKLx1c8CZQpymN+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=albouxV2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="albouxV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8A2C4CEE3;
	Tue, 29 Apr 2025 16:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945957;
	bh=ojQc09bG/VpPlGROwXOxLvTsQSRONLyAfFIS99M4P/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=albouxV2Yge3ZtuJmjiRYFfhoNJKE45gc99WtqX7aEwDu4fGr5MnU2IU21vmyIl0X
	 puvYyF1GLfIZ+D3exa8GsqTR8nsfQElW9R4/DM17dLkPX7OPyAjIREROwfOxir80UC
	 9jhIFM7Q0PqzeyMLfJbvNiq2dEOl7iwc6U9mkRuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 6.14 106/311] net: stmmac: socfpga: remove phy_resume() call
Date: Tue, 29 Apr 2025 18:39:03 +0200
Message-ID: <20250429161125.381677836@linuxfoundation.org>
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

commit 366aeeba79088003307f0f12bb3575fb083cc72a upstream.

As the previous commit addressed DWGMAC resuming with a PHY in
suspended state, there is now no need for socfpga to work around
this. Remove this code.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/E1tvO6f-008Vjn-J1@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c |   18 ------------------
 1 file changed, 18 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -523,24 +523,6 @@ static int socfpga_dwmac_resume(struct d
 
 	dwmac_priv->ops->set_phy_mode(priv->plat->bsp_priv);
 
-	/* Before the enet controller is suspended, the phy is suspended.
-	 * This causes the phy clock to be gated. The enet controller is
-	 * resumed before the phy, so the clock is still gated "off" when
-	 * the enet controller is resumed. This code makes sure the phy
-	 * is "resumed" before reinitializing the enet controller since
-	 * the enet controller depends on an active phy clock to complete
-	 * a DMA reset. A DMA reset will "time out" if executed
-	 * with no phy clock input on the Synopsys enet controller.
-	 * Verified through Synopsys Case #8000711656.
-	 *
-	 * Note that the phy clock is also gated when the phy is isolated.
-	 * Phy "suspend" and "isolate" controls are located in phy basic
-	 * control register 0, and can be modified by the phy driver
-	 * framework.
-	 */
-	if (ndev->phydev)
-		phy_resume(ndev->phydev);
-
 	return stmmac_resume(dev);
 }
 #endif /* CONFIG_PM_SLEEP */


