Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5683EF66B;
	Tue, 17 Mar 2026 16:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765792; cv=none; b=GhahdBaXxnqZPniw1jgYnEzDpq50QVK558ZsoH92DgHzOoyNHlr0uGdNtmynRlPsaHCylCrcsmoMAxDgmbSc+9iidJ1arH0Qs1PYb1iVDuyem1QZZIqyqZ/0Dlsuvn64xY1aVF+LLLosSmRWN1pRFok+sjjuP62RL8O8TgZ+Xh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765792; c=relaxed/simple;
	bh=gu5SI+W58y8GLpQdbsNa/JD3KnOJRCjP2bq7eQpW8tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQyPLkHm4CrxaGfW1q+T49XX3bkcQTG0aFIt4BTu0vYJhpsRWDRxy3F3S07f8WgTOJLe8zfVkj7kpEnCeSEegV55qxskWG8MR3h/XdY5XeaC4QF4mCdkSCbRqecop0YWLXL7rZS9zsn3vbjcRUeWQG9SZwHy1oe2woPC1CeVWUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s35CZcyN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s35CZcyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1EAC4CEF7;
	Tue, 17 Mar 2026 16:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765791;
	bh=gu5SI+W58y8GLpQdbsNa/JD3KnOJRCjP2bq7eQpW8tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s35CZcyNyQJHVeHLeI/z51hMGW1J80q7Oyu1pzr6Lz45mOfvgFdkJ4m+F3Qh0FZkA
	 f56Xb9h4jyV31c8oAAZo0ENNgHYp8g2haTQYHOWsb5IibLGK2fV+nRJqQTREErNKPm
	 TxXueDGBE3S6m0NwOGFyKy3QiSf3GqJLRD0x3LLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clark Wang <xiaoning.wang@nxp.com>,
	Wei Fang <wei.fang@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 065/378] net: enetc: do not skip setting LaBCR[MDIO_PHYAD_PRTAD] for addr 0
Date: Tue, 17 Mar 2026 17:30:22 +0100
Message-ID: <20260317163009.382806717@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit dbe17e7783cb5d6451ff1217d0464865857e97e1 ]

Given that some platforms may use PHY address 0 (I suppose the PHY may
not treat address 0 as a broadcast address or default response address).
It is possible for some boards to connect multiple PHYs to the same
ENETC MAC, for example:

  - a PHY with a non-zero address connects to ENETC MAC through SGMII
    interface (selected via DTS_A)
  - a PHY with address 0 connects to ENETC MAC through RGMII interface
    (selected via DTS_B)

For the case where the ENETC port MDIO is used to manage the PHY, when
switching from DTS_A to DTS_B via soft reboot, LaBCR[MDIO_PHYAD_PRTAD]
must be updated to 0 because the NETCMIX block is not reset during soft
reboot. However, the current driver explicitly skips configuring address
0, causing LaBCR[MDIO_PHYAD_PRTAD] to retain its old value.

Therefore, remove the special-case skip of PHY address 0 so that valid
configurations using address 0 are properly supported.

Fixes: 6633df05f3ad ("net: enetc: set the external PHY address in IERB for port MDIO usage")
Fixes: 50bfd9c06f0f ("net: enetc: set external PHY address in IERB for i.MX94 ENETC")
Reviewed-by: Clark Wang <xiaoning.wang@nxp.com>
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20260305031211.904812-3-wei.fang@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/netc_blk_ctrl.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/netc_blk_ctrl.c b/drivers/net/ethernet/freescale/enetc/netc_blk_ctrl.c
index f0e103615e884..92a0f824dae7a 100644
--- a/drivers/net/ethernet/freescale/enetc/netc_blk_ctrl.c
+++ b/drivers/net/ethernet/freescale/enetc/netc_blk_ctrl.c
@@ -438,12 +438,6 @@ static int imx95_enetc_mdio_phyaddr_config(struct platform_device *pdev)
 				return -EINVAL;
 			}
 
-			/* The default value of LaBCR[MDIO_PHYAD_PRTAD ] is
-			 * 0, so no need to set the register.
-			 */
-			if (!addr)
-				continue;
-
 			switch (bus_devfn) {
 			case IMX95_ENETC0_BUS_DEVFN:
 				netc_reg_write(priv->ierb, IERB_LBCR(0),
@@ -590,12 +584,6 @@ static int imx94_enetc_mdio_phyaddr_config(struct netc_blk_ctrl *priv,
 		return addr;
 	}
 
-	/* The default value of LaBCR[MDIO_PHYAD_PRTAD] is 0,
-	 * so no need to set the register.
-	 */
-	if (!addr)
-		return 0;
-
 	if (phy_mask & BIT(addr)) {
 		dev_err(dev,
 			"Find same PHY address in EMDIO and ENETC node\n");
-- 
2.51.0



