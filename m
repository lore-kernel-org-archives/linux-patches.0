Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D69F3438B7;
	Thu, 30 Jul 2026 15:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425867; cv=none; b=V9VfyQBHC9nMTtKyCqbxLx4wJkhQM6DeyrVVt2PlCW0Am9s8zAjGSDLzFqIW6pMCvMxgm1EZYC09jRQNNa3VNoQamA1tis88VY861OCb8QVLYCXaVaK86vUv+mpMPzIPgea2sb3f4R6WvvUWxji00rJ39QRcdl7+9PAlCJLsyqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425867; c=relaxed/simple;
	bh=qrK0JDt0uzv/Iuo3pmETRhaEs+q82C2d8MFkSUS8qzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKag2cfUTEAxS15XWO7/UfZkcEv/EtPVCcJx96bpQNr1Abrqd99SseIBfF8Lo2u/LQS4JHcRqfhRRhMpwx+Ercdz367agBngvq+jOL1BNariX4ZNsMgLltBxhCzCOvwQawpbIBgF3M+MgkeqpO7SsrySICeWEtZBaz+DI//MaG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R7UdaoWj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R7UdaoWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89CB1F000E9;
	Thu, 30 Jul 2026 15:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425866;
	bh=vv8gmLepsbKu0SYx1cYSqf1vpTqwuaeO8ixKYTCutak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R7UdaoWjPD9SReq099X6vYNxz2sFSq0vvC/iD8AjhjKTVtvQwLDVQ2vT6AFckjmdn
	 eXAkTkGiTLzegkiPaCjBHWD/xcPfUm3JSsH+w5NyxXYXe8L4/xqjZzBY3TVxv8L2Mm
	 yz3Y1LcRhaMl/3ZV2GVnCmlQBJeaClMYo7GWsw0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Michael Walle <mwalle@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 218/602] net: dpaa: fix mode setting
Date: Thu, 30 Jul 2026 16:10:10 +0200
Message-ID: <20260730141440.535624210@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit da2c6bcc5e30b1496ac587785dcacf6e849eb6ef ]

Before converting to the phylink interface, the init function would have
set a non-reserved I/F mode in the maccfg2 register. After converting to
phylink, 0 is written as mode, which is a reserved value (although it's
the hardware default). Without a valid mode, a SGMII link is never
established between the MAC and the PHY and thus .link_up() is never
called which could set the correct mode according to the actual speed.

Fix it by setting the maximum speed of the phy_interface_t in use in
.mac_config() - just like the driver did before the phylink conversion.

Fixes: 5d93cfcf7360 ("net: dpaa: Convert to phylink")
Suggested-by: Sean Anderson <sean.anderson@linux.dev>
Signed-off-by: Michael Walle <mwalle@kernel.org>
Reviewed-by: Sean Anderson <sean.anderson@linux.dev>
Reviewed-by: Sean Anderson <sean.anderson@linux.dev>
Link: https://patch.msgid.link/20260717132401.2653252-1-mwalle@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/freescale/fman/fman_dtsec.c    | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 3088da7adf0f84..074ca626a51508 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -900,22 +900,28 @@ static void dtsec_mac_config(struct phylink_config *config, unsigned int mode,
 {
 	struct mac_device *mac_dev = fman_config_to_mac(config);
 	struct dtsec_regs __iomem *regs = mac_dev->fman_mac->regs;
-	u32 tmp;
+	u32 ecntrl, maccfg2;
+
+	maccfg2 = ioread32be(&regs->maccfg2);
+	maccfg2 &= ~(MACCFG2_NIBBLE_MODE | MACCFG2_BYTE_MODE);
 
 	switch (state->interface) {
 	case PHY_INTERFACE_MODE_RMII:
-		tmp = DTSEC_ECNTRL_RMM;
+		ecntrl = DTSEC_ECNTRL_RMM;
+		maccfg2 |= MACCFG2_NIBBLE_MODE;
 		break;
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
 	case PHY_INTERFACE_MODE_RGMII_TXID:
-		tmp = DTSEC_ECNTRL_GMIIM | DTSEC_ECNTRL_RPM;
+		ecntrl = DTSEC_ECNTRL_GMIIM | DTSEC_ECNTRL_RPM;
+		maccfg2 |= MACCFG2_BYTE_MODE;
 		break;
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_1000BASEX:
 	case PHY_INTERFACE_MODE_2500BASEX:
-		tmp = DTSEC_ECNTRL_TBIM | DTSEC_ECNTRL_SGMIIM;
+		ecntrl = DTSEC_ECNTRL_TBIM | DTSEC_ECNTRL_SGMIIM;
+		maccfg2 |= MACCFG2_BYTE_MODE;
 		break;
 	default:
 		dev_warn(mac_dev->dev, "cannot configure dTSEC for %s\n",
@@ -923,7 +929,8 @@ static void dtsec_mac_config(struct phylink_config *config, unsigned int mode,
 		return;
 	}
 
-	iowrite32be(tmp, &regs->ecntrl);
+	iowrite32be(ecntrl, &regs->ecntrl);
+	iowrite32be(maccfg2, &regs->maccfg2);
 }
 
 static void dtsec_link_up(struct phylink_config *config, struct phy_device *phy,
-- 
2.53.0



