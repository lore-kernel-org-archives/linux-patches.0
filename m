Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CE1148855;
	Thu, 13 Jun 2024 12:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280216; cv=none; b=R1XcAcGcVZoAZSNQIEedb3yxQkCffMG1xAmoqfjVc7MVE6x2qFuUGD3rikqqtZgOiZMq4YJNAyNc9/UkQq+FtC/PToLWYI1rU46JmksnrlsPzmEtHXzyEqRf3QNMGYvF+kdmsKczaQ50vGbhYJE2XNwzsB/aFpcK67Vjqxwi3GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280216; c=relaxed/simple;
	bh=aqYHuUVx0cZJ6QKkv5usuQNNifuWL+k/8k+FzFQmQJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hr5u82f5fVqyKJ0vovezYVv4O70HEseixW0PaJkjN6vsVgSgc4DidZ9+nHDM84NAiFJ5yHu9S1wd5MR1OMGVdgPfZN1UFOpOJ51QSjCF9YFp3QmLgcxnZjEHBBq3D/6rlBOyOOH+8O+RtDHWsq5kg3XJahOPsFU//upxPLdbXHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dzifSjLF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dzifSjLF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9555BC2BBFC;
	Thu, 13 Jun 2024 12:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280216;
	bh=aqYHuUVx0cZJ6QKkv5usuQNNifuWL+k/8k+FzFQmQJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dzifSjLF6Ub0WzDewHEi+4UEVnKHGKLN4GYdPrkJy7rsMmtoh+ymIcXrsz7onnTq9
	 MV0v1y654Z79DDQU2U1vcxZsYgiUXHnS54CoSHqUst4wCGXZJOfhJBuf6c9mbmMzSb
	 qCgyclpXk5hzXbcPPaKUrYZditls2s5W6uCJhCUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Edich <andre.edich@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 154/202] smsc95xx: remove redundant function arguments
Date: Thu, 13 Jun 2024 13:34:12 +0200
Message-ID: <20240613113233.694593766@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Edich <andre.edich@microchip.com>

[ Upstream commit 368be1ca28f66deba16627e2a02e78adedd023a6 ]

This patch removes arguments netdev and phy_id from the functions
smsc95xx_mdio_read_nopm and smsc95xx_mdio_write_nopm.  Both removed
arguments are recovered from a new argument `struct usbnet *dev`.

Signed-off-by: Andre Edich <andre.edich@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 52a2f0608366 ("net: usb: smsc95xx: fix changing LED_SEL bit value updated from EEPROM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/smsc95xx.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 1aa99727d40c7..6fe6edc59623d 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -261,16 +261,18 @@ static void __smsc95xx_mdio_write(struct net_device *netdev, int phy_id,
 	mutex_unlock(&dev->phy_mutex);
 }
 
-static int smsc95xx_mdio_read_nopm(struct net_device *netdev, int phy_id,
-				   int idx)
+static int smsc95xx_mdio_read_nopm(struct usbnet *dev, int idx)
 {
-	return __smsc95xx_mdio_read(netdev, phy_id, idx, 1);
+	struct mii_if_info *mii = &dev->mii;
+
+	return __smsc95xx_mdio_read(dev->net, mii->phy_id, idx, 1);
 }
 
-static void smsc95xx_mdio_write_nopm(struct net_device *netdev, int phy_id,
-				     int idx, int regval)
+static void smsc95xx_mdio_write_nopm(struct usbnet *dev, int idx, int regval)
 {
-	__smsc95xx_mdio_write(netdev, phy_id, idx, regval, 1);
+	struct mii_if_info *mii = &dev->mii;
+
+	__smsc95xx_mdio_write(dev->net, mii->phy_id, idx, regval, 1);
 }
 
 static int smsc95xx_mdio_read(struct net_device *netdev, int phy_id, int idx)
@@ -1347,39 +1349,37 @@ static u32 smsc_crc(const u8 *buffer, size_t len, int filter)
 
 static int smsc95xx_enable_phy_wakeup_interrupts(struct usbnet *dev, u16 mask)
 {
-	struct mii_if_info *mii = &dev->mii;
 	int ret;
 
 	netdev_dbg(dev->net, "enabling PHY wakeup interrupts\n");
 
 	/* read to clear */
-	ret = smsc95xx_mdio_read_nopm(dev->net, mii->phy_id, PHY_INT_SRC);
+	ret = smsc95xx_mdio_read_nopm(dev, PHY_INT_SRC);
 	if (ret < 0)
 		return ret;
 
 	/* enable interrupt source */
-	ret = smsc95xx_mdio_read_nopm(dev->net, mii->phy_id, PHY_INT_MASK);
+	ret = smsc95xx_mdio_read_nopm(dev, PHY_INT_MASK);
 	if (ret < 0)
 		return ret;
 
 	ret |= mask;
 
-	smsc95xx_mdio_write_nopm(dev->net, mii->phy_id, PHY_INT_MASK, ret);
+	smsc95xx_mdio_write_nopm(dev, PHY_INT_MASK, ret);
 
 	return 0;
 }
 
 static int smsc95xx_link_ok_nopm(struct usbnet *dev)
 {
-	struct mii_if_info *mii = &dev->mii;
 	int ret;
 
 	/* first, a dummy read, needed to latch some MII phys */
-	ret = smsc95xx_mdio_read_nopm(dev->net, mii->phy_id, MII_BMSR);
+	ret = smsc95xx_mdio_read_nopm(dev, MII_BMSR);
 	if (ret < 0)
 		return ret;
 
-	ret = smsc95xx_mdio_read_nopm(dev->net, mii->phy_id, MII_BMSR);
+	ret = smsc95xx_mdio_read_nopm(dev, MII_BMSR);
 	if (ret < 0)
 		return ret;
 
@@ -1428,7 +1428,6 @@ static int smsc95xx_enter_suspend0(struct usbnet *dev)
 static int smsc95xx_enter_suspend1(struct usbnet *dev)
 {
 	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
-	struct mii_if_info *mii = &dev->mii;
 	u32 val;
 	int ret;
 
@@ -1436,17 +1435,17 @@ static int smsc95xx_enter_suspend1(struct usbnet *dev)
 	 * compatibility with non-standard link partners
 	 */
 	if (pdata->features & FEATURE_PHY_NLP_CROSSOVER)
-		smsc95xx_mdio_write_nopm(dev->net, mii->phy_id,	PHY_EDPD_CONFIG,
-			PHY_EDPD_CONFIG_DEFAULT);
+		smsc95xx_mdio_write_nopm(dev, PHY_EDPD_CONFIG,
+					 PHY_EDPD_CONFIG_DEFAULT);
 
 	/* enable energy detect power-down mode */
-	ret = smsc95xx_mdio_read_nopm(dev->net, mii->phy_id, PHY_MODE_CTRL_STS);
+	ret = smsc95xx_mdio_read_nopm(dev, PHY_MODE_CTRL_STS);
 	if (ret < 0)
 		return ret;
 
 	ret |= MODE_CTRL_STS_EDPWRDOWN_;
 
-	smsc95xx_mdio_write_nopm(dev->net, mii->phy_id, PHY_MODE_CTRL_STS, ret);
+	smsc95xx_mdio_write_nopm(dev, PHY_MODE_CTRL_STS, ret);
 
 	/* enter SUSPEND1 mode */
 	ret = smsc95xx_read_reg_nopm(dev, PM_CTRL, &val);
-- 
2.43.0



