Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517EA2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:40:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB3BC433D2;
	Wed, 12 Apr 2023 08:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288805;
	bh=nQfbM/rRFgmLgFBHUU3/NKaKt1RlMnHwYjtRROWyHkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/Bq3TMnVWh/HFRvi6cjo6iIYmPR7k06KenCijkpfIWMIQ2RxVAtc+2MBFVwOe0DO
	 4/F99zL9akrxW6wZP1Tk3Nq7Wfcx645vQU1Ig3GDOSXM+ZIF3yFHkJ9PXq8/A7yVc7
	 51VGrT7a2pSFL9xTm+U+VJtVrUdsxKs7Uny2RBYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
	Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/164] net: stmmac: check if MAC needs to attach to a PHY
Date: Wed, 12 Apr 2023 10:32:26 +0200
Message-Id: <20230412082837.938490202@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
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

[ Upstream commit fe2cfbc9680356a3d9f8adde8a38e715831e32f5 ]

After the introduction of the fixed-link support, the MAC driver
no longer attempt to scan for a PHY to attach to. This causes the
non fixed-link setups to stop working.

Using the phylink_expects_phy() to check and determine if the MAC
should expect and attach a PHY.

Fixes: ab21cf920928 ("net: stmmac: make mdio register skips PHY scanning for fixed-link")
Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Signed-off-by: Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 93321437f0933..3a5abfb1a890f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1133,6 +1133,7 @@ static int stmmac_init_phy(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	struct fwnode_handle *fwnode;
+	bool phy_needed;
 	int ret;
 
 	fwnode = of_fwnode_handle(priv->plat->phylink_node);
@@ -1142,10 +1143,11 @@ static int stmmac_init_phy(struct net_device *dev)
 	if (fwnode)
 		ret = phylink_fwnode_phy_connect(priv->phylink, fwnode, 0);
 
+	phy_needed = phylink_expects_phy(priv->phylink);
 	/* Some DT bindings do not set-up the PHY handle. Let's try to
 	 * manually parse it
 	 */
-	if (!fwnode || ret) {
+	if (!fwnode || phy_needed || ret) {
 		int addr = priv->plat->phy_addr;
 		struct phy_device *phydev;
 
-- 
2.39.2



