Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB7A43D4F7;
	Tue, 16 Jun 2026 15:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625398; cv=none; b=GXju+AxTZtOMnOG8HLDunCeI52gqlC1/3IN7mDpwAtYrGz6F9Her1JC6qlwgQFzaUa1jSSTjyYWYx6fqrVlP0bfZDcJFjH1kYEUlF+KUt1zeAh0h+6Bfy2x21hyC27xFLhIBeJ8MdSIVEgawUX0EQDGvnrTX0cfoF5rtnwcjP98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625398; c=relaxed/simple;
	bh=oOyOCSXG+HeMjU4YIQyJW1y2SQx8UV8GYSiH7fCruXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fAwgoc17Eq/la1svNaFsT0B6Ci2EbJDOZWGU8YZLcrPItr5OxGN6+/omum+n4lnRIY1QgHW9y0SQXQEThdk6FlWM5e+JyGP8cxLUviDMaZGAcYARVQyS0iZNGniGpAAchnBH4RuCXzuKJ7QiY1utjdoabz0VgPQpZvyR01SpcaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UuD7TP66; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UuD7TP66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55481F000E9;
	Tue, 16 Jun 2026 15:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625397;
	bh=8OTTVRgOe6EzsNHJ66/UjCKjpHo/kQsdjjfrDOJ6B38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UuD7TP66nvp1//CsHw2eQCvgbjv8dmNzwvlx+WlHTh2EgFHSRx6nilbeBbooETDIK
	 bZ8erwXCFKoZKh3cDtF7+12xP1ew+gkqeVQHOMclB2Su2YeuzAQPxZJjMXadDRkOUM
	 iyrrfqVlAe2gF6VUQUXlDOn5o1z3hEzWSqbby8Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 134/325] net: txgbe: support CR modules for AML devices
Date: Tue, 16 Jun 2026 20:28:50 +0530
Message-ID: <20260616145104.409082077@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit 354d128aa7212c53ffc7127877953264a445f5af ]

Support to identify 25G/10G CR modules for AML devices. Autoneg is
enbaled by default in CR mode.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://patch.msgid.link/20251118080259.24676-2-jiawenwu@trustnetic.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 0487cfca4651 ("net: txgbe: initialize module info buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/wangxun/txgbe/txgbe_aml.c    | 59 +++++++++++++------
 .../ethernet/wangxun/txgbe/txgbe_ethtool.c    |  3 +-
 2 files changed, 44 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
index 80413504e4bc86..05f852e31e6e52 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
@@ -104,7 +104,8 @@ static int txgbe_set_phy_link_hostif(struct wx *wx, int speed, int autoneg, int
 					 WX_HI_COMMAND_TIMEOUT, false);
 }
 
-static void txgbe_get_link_capabilities(struct wx *wx, int *speed, int *duplex)
+static void txgbe_get_link_capabilities(struct wx *wx, int *speed,
+					int *autoneg, int *duplex)
 {
 	struct txgbe *txgbe = wx->priv;
 
@@ -115,6 +116,7 @@ static void txgbe_get_link_capabilities(struct wx *wx, int *speed, int *duplex)
 	else
 		*speed = SPEED_UNKNOWN;
 
+	*autoneg = phylink_test(txgbe->advertising, Autoneg);
 	*duplex = *speed == SPEED_UNKNOWN ? DUPLEX_HALF : DUPLEX_FULL;
 }
 
@@ -135,11 +137,11 @@ static void txgbe_get_phy_link(struct wx *wx, int *speed)
 
 int txgbe_set_phy_link(struct wx *wx)
 {
-	int speed, duplex, err;
+	int speed, autoneg, duplex, err;
 
-	txgbe_get_link_capabilities(wx, &speed, &duplex);
+	txgbe_get_link_capabilities(wx, &speed, &autoneg, &duplex);
 
-	err = txgbe_set_phy_link_hostif(wx, speed, 0, duplex);
+	err = txgbe_set_phy_link_hostif(wx, speed, autoneg, duplex);
 	if (err) {
 		wx_err(wx, "Failed to setup link\n");
 		return err;
@@ -154,19 +156,43 @@ static int txgbe_sfp_to_linkmodes(struct wx *wx, struct txgbe_sfp_id *id)
 	DECLARE_PHY_INTERFACE_MASK(interfaces);
 	struct txgbe *txgbe = wx->priv;
 
-	if (id->com_25g_code & (TXGBE_SFF_25GBASESR_CAPABLE |
-				TXGBE_SFF_25GBASEER_CAPABLE |
-				TXGBE_SFF_25GBASELR_CAPABLE)) {
-		phylink_set(modes, 25000baseSR_Full);
+	if (id->cable_tech & TXGBE_SFF_DA_PASSIVE_CABLE) {
+		txgbe->link_port = PORT_DA;
+		phylink_set(modes, Autoneg);
+		if (id->com_25g_code == TXGBE_SFF_25GBASECR_91FEC ||
+		    id->com_25g_code == TXGBE_SFF_25GBASECR_74FEC ||
+		    id->com_25g_code == TXGBE_SFF_25GBASECR_NOFEC) {
+			phylink_set(modes, 25000baseCR_Full);
+			phylink_set(modes, 10000baseCR_Full);
+			__set_bit(PHY_INTERFACE_MODE_25GBASER, interfaces);
+			__set_bit(PHY_INTERFACE_MODE_10GBASER, interfaces);
+		} else {
+			phylink_set(modes, 10000baseCR_Full);
+			__set_bit(PHY_INTERFACE_MODE_10GBASER, interfaces);
+		}
+	} else if (id->cable_tech & TXGBE_SFF_DA_ACTIVE_CABLE) {
+		txgbe->link_port = PORT_DA;
+		phylink_set(modes, Autoneg);
+		phylink_set(modes, 25000baseCR_Full);
 		__set_bit(PHY_INTERFACE_MODE_25GBASER, interfaces);
-	}
-	if (id->com_10g_code & TXGBE_SFF_10GBASESR_CAPABLE) {
-		phylink_set(modes, 10000baseSR_Full);
-		__set_bit(PHY_INTERFACE_MODE_10GBASER, interfaces);
-	}
-	if (id->com_10g_code & TXGBE_SFF_10GBASELR_CAPABLE) {
-		phylink_set(modes, 10000baseLR_Full);
-		__set_bit(PHY_INTERFACE_MODE_10GBASER, interfaces);
+	} else {
+		if (id->com_25g_code == TXGBE_SFF_25GBASESR_CAPABLE ||
+		    id->com_25g_code == TXGBE_SFF_25GBASEER_CAPABLE ||
+		    id->com_25g_code == TXGBE_SFF_25GBASELR_CAPABLE) {
+			txgbe->link_port = PORT_FIBRE;
+			phylink_set(modes, 25000baseSR_Full);
+			__set_bit(PHY_INTERFACE_MODE_25GBASER, interfaces);
+		}
+		if (id->com_10g_code & TXGBE_SFF_10GBASESR_CAPABLE) {
+			txgbe->link_port = PORT_FIBRE;
+			phylink_set(modes, 10000baseSR_Full);
+			__set_bit(PHY_INTERFACE_MODE_10GBASER, interfaces);
+		}
+		if (id->com_10g_code & TXGBE_SFF_10GBASELR_CAPABLE) {
+			txgbe->link_port = PORT_FIBRE;
+			phylink_set(modes, 10000baseLR_Full);
+			__set_bit(PHY_INTERFACE_MODE_10GBASER, interfaces);
+		}
 	}
 
 	if (phy_interface_empty(interfaces)) {
@@ -177,7 +203,6 @@ static int txgbe_sfp_to_linkmodes(struct wx *wx, struct txgbe_sfp_id *id)
 	phylink_set(modes, Pause);
 	phylink_set(modes, Asym_Pause);
 	phylink_set(modes, FIBRE);
-	txgbe->link_port = PORT_FIBRE;
 
 	if (!linkmode_equal(txgbe->sfp_support, modes)) {
 		linkmode_copy(txgbe->sfp_support, modes);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c
index e285b088c7b267..e8dd277a35c7a4 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c
@@ -30,7 +30,8 @@ int txgbe_get_link_ksettings(struct net_device *netdev,
 		return 0;
 
 	cmd->base.port = txgbe->link_port;
-	cmd->base.autoneg = AUTONEG_DISABLE;
+	cmd->base.autoneg = phylink_test(txgbe->advertising, Autoneg) ?
+			    AUTONEG_ENABLE : AUTONEG_DISABLE;
 	linkmode_copy(cmd->link_modes.supported, txgbe->sfp_support);
 	linkmode_copy(cmd->link_modes.advertising, txgbe->advertising);
 
-- 
2.53.0



