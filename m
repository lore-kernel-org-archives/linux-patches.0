Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BF3392831;
	Thu, 30 Jul 2026 15:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424103; cv=none; b=GBcqxzPuEJiIBpHoCFslJ4qKpczynW8GND+RbWV4dG8l19FTIMFBqPSdIBJ4yNTsGjmaoCMrc+kyUdk940KKsgsUoSY+9smvnaxPpRNpvGuEC4w8Yfje2gDpTRZkpp/cHQN9iQiEobQb1N+9pX2iR7nCGFCYkREJoxTiKOB6woA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424103; c=relaxed/simple;
	bh=jUPnrEQqqIf4/VYlpqSBJvFoZI1J7CBENXuNMkYEdDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDGCZXAo9A3lbH9mQAoXzt/LIPdwjv4Po+6u+U3LF/Quj6ypKuNuB5Hv2TKVdfL8H7Iv8SoF5TFFA682Bf4d2ysCl5LWE+P02b0EhoI5e/mZGxh2P/CUh3iGAO8d7vWEC6u+l4Oqj0z8CwnA1UOIIfeiNotiiHgkhrSrA3UFkRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLUubOIE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLUubOIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E681F000E9;
	Thu, 30 Jul 2026 15:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424102;
	bh=nLFMvCkvTHq82UwSgKjDE8HCwf+esXmJ2zEUfblemdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xLUubOIE7X77WVT7/PO9BaOCLcLhn0iZG+8/qTIjj1oEBdSq0y2ib5zBjzEOhSRCB
	 F9qq69Ya1xxM+4MgfJ0Y5UNcISgPU1VMEymW/DEZNmHrmRzsirmSgr+t0tN3USlC7w
	 eFu2882/XJR6ou4bK06SgdXmT4CXCKc4w5Byotzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Michael Walle <mwalle@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 277/675] net: dpaa: fix mode setting
Date: Thu, 30 Jul 2026 16:10:07 +0200
Message-ID: <20260730141451.013574318@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 51402dff72c5ff..52f13b61bc6993 100644
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



