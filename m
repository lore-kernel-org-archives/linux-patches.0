Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032585;
	b=zwEXPp+zHk+9V/tEIbWvWd9QXAVFekTEvIPJzLHd4dPHLk+3gTxe4Lnd6SSdgOsCe8jT
	 N2IGWKABtYRPQgr4lxuIAqCuRQ/ZSy6F2M4gl+int9/iR/LuDBRejXHXCNjHPn3pMP8j6
	 tzhdbfms3LomhQK68Ek0TvywO3VtZ+joTREVd8fUK/kaQ/mLg8G7JrbXbPKUs9CFclK1g
	 s6VnBXmto7z+sCi3CZBnN1wa/lvmWsje60yxidEo/F/EBPfvtzLxnCk6/RzWkFLkLdP4d
	 ALgG295p+5pZdx9QqoIhVrv5bCwvM7I9YJZ8YerhwzjeS6wxiURgD0Dlz0ZdnTFTCsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032585;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZCgO6xVjCFUYkedL2FqdTLtbkA4KADbKzQQm1ZlvEpM=;
	b=gdQezEYj1FzLj0wSOovldPtGRPLecjEqeNFyc3FPd/2EAh+xzaxiPHSrJhGd2pkPEvmE
	 FrHMGqjoION6dhRVqAtE6AsK8aub9DiMQSNFb7UnJZNYMjqfQxfhxrJsV7FH903WAYeyq
	 G3m0EodlEZkVXVyYKV2ozVIdTdd6pSu0hTqFffFMD4yisBfuRbUPy9jIX1Y+8lvYmu7mQ
	 MbwNDbLH3HucAQGAknD9w5Tq4e6xdvGwBCH2C4ogQGGO1GCEj/H9QmBw0neMtFxnnBs+I
	 FXnsb2jE4lokl1n5XBCL5ugk78imxtrl92iKOom/aKk2aM/Pmy5b6SO0L47JuyLxPLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NB71GoOj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02572606A31C;
	Wed, 18 Nov 2026 20:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NB71GoOj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118301F000C4;
	Wed, 18 Nov 2026 20:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032584;
	bh=ZCgO6xVjCFUYkedL2FqdTLtbkA4KADbKzQQm1ZlvEpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NB71GoOj8WjUCVgzFB5T35Y/yUIna40RkhY4/72ufDrZst2Fl4kRvmTr5Z4kRnplw
	 PIlVB9fYpb7HDwjy09A5xet7gMqIKTpNkvSFQMISR8VifKpKVo4MNtli+6IKm/rZuj
	 1AVHuPPaL4glpiUp49NY1OhbSCP8eD+8vpwuFug8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Igor Velkov <iav@iav.lv>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1461/1756] net: phy: marvell: keep WOL_EIE across interrupt reconfiguration
Date: Wed, 18 Nov 2026 15:59:48 +0100
Message-ID: <20261118150107.221737845@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit f434191f93884c9de58c38f18ac7fc7f1fdf9e42 ]

marvell_config_intr() rewrites the whole interrupt enable register, so
the config_intr call from phy_init_hw() on resume silently cleared
WOL_EIE on the 88E1318S and 88E1510: m88e1318_get_wol() still reported
WAKE_MAGIC, but a matched magic packet was no longer routed to INTn and
the board did not wake.

Bit 7 of that register is WOL_EIE only on these two PHYs; on others,
such as the 88E1111, it enables a FIFO error interrupt. So give the
88E1318S and 88E1510 their own config_intr and handle_interrupt, and
leave the shared callbacks unchanged.

m88e1318_set_wol() now records whether WoL is enabled, and both it and
the new config_intr derive WOL_EIE from that state under the MDIO bus
lock. WOL_EIE stays set across config_intr while WoL is enabled, except
when the PHY has an interrupt line and interrupts are being disabled,
as in phy_free_interrupt(): INTn is then the PHY IRQ, and nothing would
read IEVENT after free_irq() to release it. The bit is set again once
interrupts are re-enabled. phy_probe() still clears a WOL_EIE left by a
previous boot, since WoL starts out disabled. The new handler also
claims WoL events, so they do not go unacknowledged when the PHY IRQ is
in use.

Helios4 (Armada 388, 88E1512), 7.2.9. With this patch WOL_EIE stays set
over 3 link down/up cycles, "wol d" clears it, and a magic packet on a
running board is a handled interrupt. Without it, WOL_EIE is lost on the
first down/up, survives "wol d", and the magic packet is an unhandled
interrupt.

Fixes: 3871c3876f80 ("mv643xx_eth with 88E1318S: support Wake on LAN")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Tested-by: Igor Velkov <iav@iav.lv>
Link: https://patch.msgid.link/20261014194818.11640-2-rosenp@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/marvell.c | 97 ++++++++++++++++++++++++++++++---------
 1 file changed, 75 insertions(+), 22 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 2b64a11fe9b36..b061a6898e486 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -55,6 +55,8 @@
 #define MII_M1011_IMASK			0x12
 #define MII_M1011_IMASK_INIT		0x6400
 #define MII_M1011_IMASK_CLEAR		0x0000
+/* WOL Event Interrupt Enable, 88E1318S and 88E1510 only */
+#define MII_M1011_IMASK_WOL		BIT(7)
 
 #define MII_M1011_PHY_SCR			0x10
 #define MII_M1011_PHY_SCR_DOWNSHIFT_EN		BIT(11)
@@ -139,11 +141,6 @@
 #define MII_88E1318S_PHY_MSCR1_REG	16
 #define MII_88E1318S_PHY_MSCR1_PAD_ODD	BIT(6)
 
-/* Copper Specific Interrupt Enable Register */
-#define MII_88E1318S_PHY_CSIER				0x12
-/* WOL Event Interrupt Enable */
-#define MII_88E1318S_PHY_CSIER_WOL_EIE			BIT(7)
-
 #define MII_88E1318S_PHY_LED_FUNC		0x10
 #define MII_88E1318S_PHY_LED_FUNC_OFF		(0x8)
 #define MII_88E1318S_PHY_LED_FUNC_ON		(0x9)
@@ -353,6 +350,7 @@ struct marvell_priv {
 	u32 step;
 	s8 pair;
 	u8 vct_phase;
+	bool wol_enabled;
 };
 
 static int marvell_read_page(struct phy_device *phydev)
@@ -406,7 +404,8 @@ static int marvell_config_intr(struct phy_device *phydev)
 	return err;
 }
 
-static irqreturn_t marvell_handle_interrupt(struct phy_device *phydev)
+static irqreturn_t __marvell_handle_interrupt(struct phy_device *phydev,
+					      u16 mask)
 {
 	int irq_status;
 
@@ -416,7 +415,7 @@ static irqreturn_t marvell_handle_interrupt(struct phy_device *phydev)
 		return IRQ_NONE;
 	}
 
-	if (!(irq_status & MII_M1011_IMASK_INIT))
+	if (!(irq_status & mask))
 		return IRQ_NONE;
 
 	phy_trigger_machine(phydev);
@@ -424,6 +423,57 @@ static irqreturn_t marvell_handle_interrupt(struct phy_device *phydev)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t marvell_handle_interrupt(struct phy_device *phydev)
+{
+	return __marvell_handle_interrupt(phydev, MII_M1011_IMASK_INIT);
+}
+
+/* WOL_EIE also routes WoL events to INTn. Keep it set while WoL is enabled,
+ * unless INTn is the PHY interrupt and that interrupt is being disabled:
+ * nothing would read IEVENT after free_irq() to release the line.
+ */
+static u16 m88e1318_wol_imask(struct phy_device *phydev)
+{
+	struct marvell_priv *priv = phydev->priv;
+
+	if (priv->wol_enabled &&
+	    (phydev->interrupts == PHY_INTERRUPT_ENABLED ||
+	     !phy_interrupt_is_valid(phydev)))
+		return MII_M1011_IMASK_WOL;
+
+	return 0;
+}
+
+static int m88e1318_config_intr(struct phy_device *phydev)
+{
+	bool enable = phydev->interrupts == PHY_INTERRUPT_ENABLED;
+	u16 imask;
+	int err;
+
+	if (enable) {
+		err = marvell_ack_interrupt(phydev);
+		if (err)
+			return err;
+	}
+
+	/* Serialise against m88e1318_set_wol() updating wol_enabled */
+	phy_lock_mdio_bus(phydev);
+	imask = enable ? MII_M1011_IMASK_INIT : MII_M1011_IMASK_CLEAR;
+	imask |= m88e1318_wol_imask(phydev);
+	err = __phy_write(phydev, MII_M1011_IMASK, imask);
+	phy_unlock_mdio_bus(phydev);
+	if (err || enable)
+		return err;
+
+	return marvell_ack_interrupt(phydev);
+}
+
+static irqreturn_t m88e1318_handle_interrupt(struct phy_device *phydev)
+{
+	return __marvell_handle_interrupt(phydev, MII_M1011_IMASK_INIT |
+					  MII_M1011_IMASK_WOL);
+}
+
 static int marvell_set_polarity(struct phy_device *phydev, int polarity)
 {
 	u16 val;
@@ -1915,18 +1965,27 @@ static void m88e1318_get_wol(struct phy_device *phydev,
 static int m88e1318_set_wol(struct phy_device *phydev,
 			    struct ethtool_wolinfo *wol)
 {
+	struct marvell_priv *priv = phydev->priv;
 	int err = 0, oldpage;
 
 	oldpage = phy_save_page(phydev);
 	if (oldpage < 0)
 		goto error;
 
-	if (wol->wolopts & (WAKE_MAGIC | WAKE_PHY)) {
-		/* Explicitly switch to page 0x00, just to be sure */
-		err = marvell_write_page(phydev, MII_MARVELL_COPPER_PAGE);
-		if (err < 0)
-			goto error;
+	priv->wol_enabled = !!(wol->wolopts & (WAKE_MAGIC | WAKE_PHY));
 
+	/* Explicitly switch to page 0x00, just to be sure */
+	err = marvell_write_page(phydev, MII_MARVELL_COPPER_PAGE);
+	if (err < 0)
+		goto error;
+
+	/* Update the WOL interrupt enable */
+	err = __phy_modify(phydev, MII_M1011_IMASK, MII_M1011_IMASK_WOL,
+			   m88e1318_wol_imask(phydev));
+	if (err < 0)
+		goto error;
+
+	if (priv->wol_enabled) {
 		/* If WOL event happened once, the LED[2] interrupt pin
 		 * will not be cleared unless we reading the interrupt status
 		 * register. If interrupts are in use, the normal interrupt
@@ -1936,12 +1995,6 @@ static int m88e1318_set_wol(struct phy_device *phydev,
 		if (!phy_interrupt_is_valid(phydev))
 			__phy_read(phydev, MII_M1011_IEVENT);
 
-		/* Enable the WOL interrupt */
-		err = __phy_set_bits(phydev, MII_88E1318S_PHY_CSIER,
-				     MII_88E1318S_PHY_CSIER_WOL_EIE);
-		if (err < 0)
-			goto error;
-
 		err = marvell_write_page(phydev, MII_MARVELL_LED_PAGE);
 		if (err < 0)
 			goto error;
@@ -3812,8 +3865,8 @@ static struct phy_driver marvell_drivers[] = {
 		.config_init = m88e1318_config_init,
 		.config_aneg = m88e1318_config_aneg,
 		.read_status = marvell_read_status,
-		.config_intr = marvell_config_intr,
-		.handle_interrupt = marvell_handle_interrupt,
+		.config_intr = m88e1318_config_intr,
+		.handle_interrupt = m88e1318_handle_interrupt,
 		.get_wol = m88e1318_get_wol,
 		.set_wol = m88e1318_set_wol,
 		.resume = genphy_resume,
@@ -3920,8 +3973,8 @@ static struct phy_driver marvell_drivers[] = {
 		.config_init = m88e1510_config_init,
 		.config_aneg = m88e1510_config_aneg,
 		.read_status = marvell_read_status,
-		.config_intr = marvell_config_intr,
-		.handle_interrupt = marvell_handle_interrupt,
+		.config_intr = m88e1318_config_intr,
+		.handle_interrupt = m88e1318_handle_interrupt,
 		.get_wol = m88e1318_get_wol,
 		.set_wol = m88e1318_set_wol,
 		.resume = m88e1510_resume,
-- 
2.53.0



