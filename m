Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388C33EFD07;
	Tue, 17 Mar 2026 16:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765787; cv=none; b=A3U7TvyfKSlhvH8exSQidWRYnFieMuVy3hHdM5LeRmYLNDsID4KDb8Y2e2SJrozyKn+WKVrL4uEokwMsnTUfgZT6RHvqRlUO9IRAEFtWQUlzJhjx0D5PIXjpml32MJ4G7cUEyiiASYWkt6lGSjcKi9d1pKxBiAkBqOvcW6vkJ60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765787; c=relaxed/simple;
	bh=DPR2FE26DH6gmZMkzxoF5tavJKAVR7kKAIX/P+A3y/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNciTtBn2vTFy8EpED4erQv6CNJwZ/9O68KWUJrJQKot2Gv2GHmPH2uDLr4zORgFFfoevZaGedIZ+nAI3UFvrMn1y32y2MhK+H2V26gBZBuUMiiUJAGBj54geX1FhXhTJff3BiyhwJcmntgCihH8GVNHZsComLGy5oeHBfWcC2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RMfAx2pF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RMfAx2pF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A603C4CEF7;
	Tue, 17 Mar 2026 16:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765787;
	bh=DPR2FE26DH6gmZMkzxoF5tavJKAVR7kKAIX/P+A3y/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RMfAx2pFdvhHzuAUA/3H4etpRZXnZ6KGU3iMnWX8n/11wKAQ3X9j9AyqikxABLAhW
	 rixHLhRBTFiPAvNnio4Hc+k5G8DApgje/x4QomgvKatSRmRq20O5OXpeHLSYDc+Nq9
	 JeEMK3iGYYmXMHjSFDOJ6cB2XbeDD1O2ZgwjKR5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Clark Wang <xiaoning.wang@nxp.com>,
	Wei Fang <wei.fang@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 064/378] net: enetc: fix incorrect fallback PHY address handling
Date: Tue, 17 Mar 2026 17:30:21 +0100
Message-ID: <20260317163009.346507139@linuxfoundation.org>
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

[ Upstream commit 246953f33e8cf95621d6c00332e2780ce1594082 ]

The current netc_get_phy_addr() implementation falls back to PHY address
0 when the "mdio" node or the PHY child node is missing. On i.MX95, this
causes failures when a real PHY is actually assigned address 0 and is
managed through the EMDIO interface. Because the bit 0 of phy_mask will
be set, leading imx95_enetc_mdio_phyaddr_config() to return an error, and
the netc_blk_ctrl driver probe subsequently fails. Fix this by returning
-ENODEV when neither an "mdio" node nor any PHY node is present, it means
that ENETC port MDIO is not used to manage the PHY, so there is no need
to configure LaBCR[MDIO_PHYAD_PRTAD].

Reported-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Closes: https://lore.kernel.org/all/7825188.GXAFRqVoOG@steina-w
Fixes: 6633df05f3ad ("net: enetc: set the external PHY address in IERB for port MDIO usage")
Reviewed-by: Clark Wang <xiaoning.wang@nxp.com>
Tested-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20260305031211.904812-2-wei.fang@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/netc_blk_ctrl.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/netc_blk_ctrl.c b/drivers/net/ethernet/freescale/enetc/netc_blk_ctrl.c
index 7fd39f8952901..f0e103615e884 100644
--- a/drivers/net/ethernet/freescale/enetc/netc_blk_ctrl.c
+++ b/drivers/net/ethernet/freescale/enetc/netc_blk_ctrl.c
@@ -333,11 +333,13 @@ static int netc_get_phy_addr(struct device_node *np)
 
 	mdio_node = of_get_child_by_name(np, "mdio");
 	if (!mdio_node)
-		return 0;
+		return -ENODEV;
 
 	phy_node = of_get_next_child(mdio_node, NULL);
-	if (!phy_node)
+	if (!phy_node) {
+		err = -ENODEV;
 		goto of_put_mdio_node;
+	}
 
 	err = of_property_read_u32(phy_node, "reg", &addr);
 	if (err)
@@ -423,6 +425,9 @@ static int imx95_enetc_mdio_phyaddr_config(struct platform_device *pdev)
 
 			addr = netc_get_phy_addr(gchild);
 			if (addr < 0) {
+				if (addr == -ENODEV)
+					continue;
+
 				dev_err(dev, "Failed to get PHY address\n");
 				return addr;
 			}
@@ -578,6 +583,9 @@ static int imx94_enetc_mdio_phyaddr_config(struct netc_blk_ctrl *priv,
 
 	addr = netc_get_phy_addr(np);
 	if (addr < 0) {
+		if (addr == -ENODEV)
+			return 0;
+
 		dev_err(dev, "Failed to get PHY address\n");
 		return addr;
 	}
-- 
2.51.0



