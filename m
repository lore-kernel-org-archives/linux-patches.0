Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D254E2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1C6C433D2;
	Wed, 12 Apr 2023 08:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289339;
	bh=ZsgoMZ6B59bRE20ESo9UuKPdvGsVuW5abBLtW59aHco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hsZBX1Dke/BiEuEyZvhDT2BuiOvMzFFHwLJUWEd7XxPBFTfSxb58Yu/1RmViSa8Gk
	 FXSm/uv/f+xemsvS1LdTtAjMmUPoxRkxSr+rpgx1uGyXu511R7csuSYylatyKSRCYF
	 jIXI2uAEf5eYWGMlwuAjKQ6VZ6GOhyYRnKB7K+IU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Shahab Vahedi <shahab@synopsys.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 054/173] net: stmmac: check fwnode for phy device before scanning for phy
Date: Wed, 12 Apr 2023 10:33:00 +0200
Message-Id: <20230412082840.298602477@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>

[ Upstream commit 8fbc10b995a506e173f1080dfa2764f232a65e02 ]

Some DT devices already have phy device configured in the DT/ACPI.
Current implementation scans for a phy unconditionally even though
there is a phy listed in the DT/ACPI and already attached.

We should check the fwnode if there is any phy device listed in
fwnode and decide whether to scan for a phy to attach to.

Fixes: fe2cfbc96803 ("net: stmmac: check if MAC needs to attach to a PHY")
Reported-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/lkml/20230403212434.296975-1-martin.blumenstingl@googlemail.com/
Tested-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Shahab Vahedi <shahab@synopsys.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Suggested-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Link: https://lore.kernel.org/r/20230406024541.3556305-1-michael.wei.hong.sit@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 4888536a31500..622b95bfb0b2b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1134,22 +1134,26 @@ static void stmmac_check_pcs_mode(struct stmmac_priv *priv)
 static int stmmac_init_phy(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
+	struct fwnode_handle *phy_fwnode;
 	struct fwnode_handle *fwnode;
-	bool phy_needed;
 	int ret;
 
+	if (!phylink_expects_phy(priv->phylink))
+		return 0;
+
 	fwnode = of_fwnode_handle(priv->plat->phylink_node);
 	if (!fwnode)
 		fwnode = dev_fwnode(priv->device);
 
 	if (fwnode)
-		ret = phylink_fwnode_phy_connect(priv->phylink, fwnode, 0);
+		phy_fwnode = fwnode_get_phy_node(fwnode);
+	else
+		phy_fwnode = NULL;
 
-	phy_needed = phylink_expects_phy(priv->phylink);
 	/* Some DT bindings do not set-up the PHY handle. Let's try to
 	 * manually parse it
 	 */
-	if (!fwnode || phy_needed || ret) {
+	if (!phy_fwnode || IS_ERR(phy_fwnode)) {
 		int addr = priv->plat->phy_addr;
 		struct phy_device *phydev;
 
@@ -1165,6 +1169,9 @@ static int stmmac_init_phy(struct net_device *dev)
 		}
 
 		ret = phylink_connect_phy(priv->phylink, phydev);
+	} else {
+		fwnode_handle_put(phy_fwnode);
+		ret = phylink_fwnode_phy_connect(priv->phylink, fwnode, 0);
 	}
 
 	if (!priv->plat->pmt) {
-- 
2.39.2



