Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F3E3BF2F1;
	Thu, 15 Jan 2026 16:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496273; cv=none; b=E2+qUXDKC18Y5P0HXJGAKZYGqtouY4vBmkg1r3ucf5oiCx6wzpXAIb7N2fMwD7nciVJTpiUqdZjgt8XDxBfxv1ZptBkCCCDJxzBB55lp0LDNEogmrmMGBzZajYd4NcaaOJTXC6HvI3humx1VSuLtNNDH9lap74No24o6GWJVfSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496273; c=relaxed/simple;
	bh=R74qWKRFVwKfeZdajaB1r/EP9huSRolLtd4D39AOHeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVIs9VVGO4rufnKlLeiXW46rlqFacqP523UyPAVdNflkeE5c7Ka7R2CG9pKB8oFKW2vvNwQ3iie0YsXvepClT+eUTKvhrLJ/5MwFTGMGyQZ2+562npupsJex673bnaY1UnbOAaa9IMzVmB/P6/vhwt5iChfJuKfXMb1JQGls11g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kUwVNqdV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kUwVNqdV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A62C116D0;
	Thu, 15 Jan 2026 16:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496273;
	bh=R74qWKRFVwKfeZdajaB1r/EP9huSRolLtd4D39AOHeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUwVNqdVpZc2wg0heR3L7vdwNdJwJEvZujVMvu98BpKnkbXufCLumO9W7vo6PDnC4
	 bAlUXhK2JCCj5nmkZ68aYQTICB8AfO+ZTp/Vxsri8amhI355udr5BBheRqB+IyLHaH
	 Ml2MOQRjHoRK3BJ3nN7WjEQYVLWDaBuEnc5urnBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Brunck <holger.brunck@hitachienergy.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 137/181] Revert "dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude configurable"
Date: Thu, 15 Jan 2026 17:47:54 +0100
Message-ID: <20260115164207.265073029@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 7801edc9badd972cb62cf11c0427e70b6dca239d ]

This reverts commit 926eae604403acfa27ba5b072af458e87e634a50, which
never could have produced the intended effect:
https://lore.kernel.org/netdev/AM0PR06MB10396BBF8B568D77556FC46F8F7DEA@AM0PR06MB10396.eurprd06.prod.outlook.com/

The reason why it is broken beyond repair in this form is that the
mv88e6xxx driver outsources its "tx-p2p-microvolt" property to the OF
node of an external Ethernet PHY. This:
(a) does not work if there is no external PHY (chip-to-chip connection,
    or SFP module)
(b) pollutes the OF property namespace / bindings of said external PHY
    ("tx-p2p-microvolt" could have meaning for the Ethernet PHY's SerDes
    interface as well)

We can revisit the idea of making SerDes amplitude configurable once we
have proper bindings for the mv88e6xxx SerDes. Until then, remove the
code that leaves us with unnecessary baggage.

Fixes: 926eae604403 ("dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude configurable")
Cc: Holger Brunck <holger.brunck@hitachienergy.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260104093952.486606-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c   | 23 ---------------
 drivers/net/dsa/mv88e6xxx/chip.h   |  4 ---
 drivers/net/dsa/mv88e6xxx/serdes.c | 46 ------------------------------
 drivers/net/dsa/mv88e6xxx/serdes.h |  5 ----
 4 files changed, 78 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index b4d48997bf467..09002c853b78e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3364,13 +3364,10 @@ static int mv88e6xxx_setup_upstream_port(struct mv88e6xxx_chip *chip, int port)
 
 static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 {
-	struct device_node *phy_handle = NULL;
 	struct fwnode_handle *ports_fwnode;
 	struct fwnode_handle *port_fwnode;
 	struct dsa_switch *ds = chip->ds;
 	struct mv88e6xxx_port *p;
-	struct dsa_port *dp;
-	int tx_amp;
 	int err;
 	u16 reg;
 	u32 val;
@@ -3582,23 +3579,6 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 			return err;
 	}
 
-	if (chip->info->ops->serdes_set_tx_amplitude) {
-		dp = dsa_to_port(ds, port);
-		if (dp)
-			phy_handle = of_parse_phandle(dp->dn, "phy-handle", 0);
-
-		if (phy_handle && !of_property_read_u32(phy_handle,
-							"tx-p2p-microvolt",
-							&tx_amp))
-			err = chip->info->ops->serdes_set_tx_amplitude(chip,
-								port, tx_amp);
-		if (phy_handle) {
-			of_node_put(phy_handle);
-			if (err)
-				return err;
-		}
-	}
-
 	/* Port based VLAN map: give each port the same default address
 	 * database, and allow bidirectional communication between the
 	 * CPU and DSA port(s), and the other ports.
@@ -4768,7 +4748,6 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.serdes_irq_mapping = mv88e6352_serdes_irq_mapping,
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
-	.serdes_set_tx_amplitude = mv88e6352_serdes_set_tx_amplitude,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_get_caps = mv88e6352_phylink_get_caps,
 	.pcs_ops = &mv88e6352_pcs_ops,
@@ -5044,7 +5023,6 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.serdes_irq_mapping = mv88e6352_serdes_irq_mapping,
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
-	.serdes_set_tx_amplitude = mv88e6352_serdes_set_tx_amplitude,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
@@ -5481,7 +5459,6 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.serdes_get_stats = mv88e6352_serdes_get_stats,
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
-	.serdes_set_tx_amplitude = mv88e6352_serdes_set_tx_amplitude,
 	.phylink_get_caps = mv88e6352_phylink_get_caps,
 	.pcs_ops = &mv88e6352_pcs_ops,
 };
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 2f211e55cb47b..e073446ee7d02 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -642,10 +642,6 @@ struct mv88e6xxx_ops {
 	void (*serdes_get_regs)(struct mv88e6xxx_chip *chip, int port,
 				void *_p);
 
-	/* SERDES SGMII/Fiber Output Amplitude */
-	int (*serdes_set_tx_amplitude)(struct mv88e6xxx_chip *chip, int port,
-				       int val);
-
 	/* Address Translation Unit operations */
 	int (*atu_get_hash)(struct mv88e6xxx_chip *chip, u8 *hash);
 	int (*atu_set_hash)(struct mv88e6xxx_chip *chip, u8 hash);
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index b3330211edbca..a936ee80ce006 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -25,14 +25,6 @@ static int mv88e6352_serdes_read(struct mv88e6xxx_chip *chip, int reg,
 				       reg, val);
 }
 
-static int mv88e6352_serdes_write(struct mv88e6xxx_chip *chip, int reg,
-				  u16 val)
-{
-	return mv88e6xxx_phy_page_write(chip, MV88E6352_ADDR_SERDES,
-					MV88E6352_SERDES_PAGE_FIBER,
-					reg, val);
-}
-
 static int mv88e6390_serdes_read(struct mv88e6xxx_chip *chip,
 				 int lane, int device, int reg, u16 *val)
 {
@@ -506,41 +498,3 @@ void mv88e6390_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p)
 			p[i] = reg;
 	}
 }
-
-static const int mv88e6352_serdes_p2p_to_reg[] = {
-	/* Index of value in microvolts corresponds to the register value */
-	14000, 112000, 210000, 308000, 406000, 504000, 602000, 700000,
-};
-
-int mv88e6352_serdes_set_tx_amplitude(struct mv88e6xxx_chip *chip, int port,
-				      int val)
-{
-	bool found = false;
-	u16 ctrl, reg;
-	int err;
-	int i;
-
-	err = mv88e6352_g2_scratch_port_has_serdes(chip, port);
-	if (err <= 0)
-		return err;
-
-	for (i = 0; i < ARRAY_SIZE(mv88e6352_serdes_p2p_to_reg); ++i) {
-		if (mv88e6352_serdes_p2p_to_reg[i] == val) {
-			reg = i;
-			found = true;
-			break;
-		}
-	}
-
-	if (!found)
-		return -EINVAL;
-
-	err = mv88e6352_serdes_read(chip, MV88E6352_SERDES_SPEC_CTRL2, &ctrl);
-	if (err)
-		return err;
-
-	ctrl &= ~MV88E6352_SERDES_OUT_AMP_MASK;
-	ctrl |= reg;
-
-	return mv88e6352_serdes_write(chip, MV88E6352_SERDES_SPEC_CTRL2, ctrl);
-}
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index ad887d8601bcb..17a3e85fabaa3 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -29,8 +29,6 @@ struct phylink_link_state;
 #define MV88E6352_SERDES_INT_FIBRE_ENERGY	BIT(4)
 #define MV88E6352_SERDES_INT_STATUS	0x13
 
-#define MV88E6352_SERDES_SPEC_CTRL2	0x1a
-#define MV88E6352_SERDES_OUT_AMP_MASK		0x0007
 
 #define MV88E6341_PORT5_LANE		0x15
 
@@ -140,9 +138,6 @@ void mv88e6352_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p);
 int mv88e6390_serdes_get_regs_len(struct mv88e6xxx_chip *chip, int port);
 void mv88e6390_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p);
 
-int mv88e6352_serdes_set_tx_amplitude(struct mv88e6xxx_chip *chip, int port,
-				      int val);
-
 /* Return the (first) SERDES lane address a port is using, -errno otherwise. */
 static inline int mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip,
 					    int port)
-- 
2.51.0



