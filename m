Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE40341043;
	Fri, 21 Nov 2025 13:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731084; cv=none; b=Ogh9eEkikxGUG//mr70Q6oSrDA/UX/qJ74vCjX7c0fffU50ezyp+2+P1d3TTHu5F220KijMSoOnFrxuMy49Tus40kGeO9H6/7N1yHs4r3vTa3GjDPJkdZp4SSSXtaWN4wVpgZssnE4+gY1o2DBFRYLfl/CuYtIufMRLoWxZ1+MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731084; c=relaxed/simple;
	bh=cvIy+jb8jy3k4gGqpa80vZ5T2Fud1ATkTCgKDYnGnB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnvRhhRU+5fsE2oSMu7QlQGsj7hZh4zBEclKtrmmuVZbdp29zr3/pTlnzF881c8XOvVZqELFxUbFZZ8TENeBVt/0T3MwGlYsLRNlNzmEiwqBCoaIzJCuDNuuWWKC1SPzxqY/YopHcCdbfgtXOsxBDl+6iq9n2v0NoTYLQt0xEkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ELU5glpX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ELU5glpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7ACFC4CEF1;
	Fri, 21 Nov 2025 13:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731084;
	bh=cvIy+jb8jy3k4gGqpa80vZ5T2Fud1ATkTCgKDYnGnB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELU5glpXmh4lNIbo6RCpVeJBxUVGtVQS9wZa0NHw/PYHSYOhMjeTHhae8I1GRoAkg
	 fm+D7aL4hV77Bx0U8F9lUADTvbpiyIQCFH6knwIVNEFPNBPMfHpkWe8As82b34bpYh
	 qG97tOt3qLtE30LeRBbs4uHuDtmkUdpbAtnr5xUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Divya Koppera <Divya.Koppera@microchip.com>
Subject: [PATCH 6.17 052/247] net: phy: micrel: lan8814 fix reset of the QSGMII interface
Date: Fri, 21 Nov 2025 14:09:59 +0100
Message-ID: <20251121130156.473211462@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 96a9178a29a6b84bb632ebeb4e84cf61191c73d5 ]

The lan8814 is a quad-phy and it is using QSGMII towards the MAC.
The problem is that everytime when one of the ports is configured then
the PCS is reseted for all the PHYs. Meaning that the other ports can
loose traffic until the link is establish again.
To fix this, do the reset one time for the entire PHY package.

Fixes: ece19502834d ("net: phy: micrel: 1588 support for LAN8814 phy")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Divya Koppera <Divya.Koppera@microchip.com >
Link: https://patch.msgid.link/20251106090637.2030625-1-horatiu.vultur@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 107e5c4c7da3b..39d2cd7cf4382 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -4327,12 +4327,6 @@ static int lan8814_config_init(struct phy_device *phydev)
 {
 	struct kszphy_priv *lan8814 = phydev->priv;
 
-	/* Reset the PHY */
-	lanphy_modify_page_reg(phydev, LAN8814_PAGE_COMMON_REGS,
-			       LAN8814_QSGMII_SOFT_RESET,
-			       LAN8814_QSGMII_SOFT_RESET_BIT,
-			       LAN8814_QSGMII_SOFT_RESET_BIT);
-
 	/* Disable ANEG with QSGMII PCS Host side */
 	lanphy_modify_page_reg(phydev, LAN8814_PAGE_COMMON_REGS,
 			       LAN8814_QSGMII_PCS1G_ANEG_CONFIG,
@@ -4418,6 +4412,12 @@ static int lan8814_probe(struct phy_device *phydev)
 			      addr, sizeof(struct lan8814_shared_priv));
 
 	if (phy_package_init_once(phydev)) {
+		/* Reset the PHY */
+		lanphy_modify_page_reg(phydev, LAN8814_PAGE_COMMON_REGS,
+				       LAN8814_QSGMII_SOFT_RESET,
+				       LAN8814_QSGMII_SOFT_RESET_BIT,
+				       LAN8814_QSGMII_SOFT_RESET_BIT);
+
 		err = lan8814_release_coma_mode(phydev);
 		if (err)
 			return err;
-- 
2.51.0



