Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7579B27733;
	Tue, 16 Jul 2024 15:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144842; cv=none; b=mCJ3P8mAuu2PijhaIRaXAVvzsfEm96CwHzxGzrdpaJu2zD6PnRpiUfYnduIMiKRkN9oNMX0bthmYxxvgrurf4C8OEQAzGpG8Kr0Hnwcapqu958RRsCSH6NUe2SqSNXzACP2zyikffqZUyzq/aIFNSLgJl1/lMPInrfrdrsdlegw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144842; c=relaxed/simple;
	bh=AQkwc+++80B0aqPUKWsA2CqbwesDdl+BLnrK9kJoqNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJ5/bQUYCuuKa/7perwgqnVvB6jIw6hkCIkz73j+5nQTJidU7HaiPf0kz+sPuGSw91zDHK/cJzENDk7pRnk/E4zyqA4OibF6CH+YH9jQgP8sUXUEdgEwuAS/GSWBt5RRMJvTvMPPwglX1I6jzA6vNGJawVyysnJ8BJv8DRek7Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qpMe30VY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qpMe30VY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C42C4AF0B;
	Tue, 16 Jul 2024 15:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144842;
	bh=AQkwc+++80B0aqPUKWsA2CqbwesDdl+BLnrK9kJoqNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qpMe30VYaYUTxhG/6roXom6y9K2QMLF/rFab5pZMKdw7lXk71bUwnv4JXGx5EaYP3
	 VYUZhQuQmHEaH+wg5O6ldphtAoRIY6sPl9EMT6MhrmpBROE/D9HSCcMfw+arqNg7WE
	 2ZKaiD1HJRGH/RprBa18u/AyGJOCDcYeAVrAIk2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 014/143] net: dsa: lan9303: provide own phylink MAC operations
Date: Tue, 16 Jul 2024 17:30:10 +0200
Message-ID: <20240716152756.537317503@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit 855b4ac06e46eaaf0f28484863e55d23fee89a0c ]

Convert lan9303 to provide its own phylink MAC operations, thus
avoiding the shim layer in DSA's port.c. We need to provide stubs for
the mac_link_down() and mac_config() methods which are mandatory.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/E1rwfuE-007537-1u@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 0005b2dc43f9 ("dsa: lan9303: Fix mapping between DSA port number and PHY address")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/lan9303-core.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index fcb20eac332a6..666b4d766c005 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1293,14 +1293,29 @@ static void lan9303_phylink_get_caps(struct dsa_switch *ds, int port,
 	}
 }
 
-static void lan9303_phylink_mac_link_up(struct dsa_switch *ds, int port,
+static void lan9303_phylink_mac_config(struct phylink_config *config,
+				       unsigned int mode,
+				       const struct phylink_link_state *state)
+{
+}
+
+static void lan9303_phylink_mac_link_down(struct phylink_config *config,
+					  unsigned int mode,
+					  phy_interface_t interface)
+{
+}
+
+static void lan9303_phylink_mac_link_up(struct phylink_config *config,
+					struct phy_device *phydev,
 					unsigned int mode,
 					phy_interface_t interface,
-					struct phy_device *phydev, int speed,
-					int duplex, bool tx_pause,
+					int speed, int duplex, bool tx_pause,
 					bool rx_pause)
 {
-	struct lan9303 *chip = ds->priv;
+	struct dsa_port *dp = dsa_phylink_to_port(config);
+	struct lan9303 *chip = dp->ds->priv;
+	struct dsa_switch *ds = dp->ds;
+	int port = dp->index;
 	u32 ctl;
 	u32 reg;
 
@@ -1330,6 +1345,12 @@ static void lan9303_phylink_mac_link_up(struct dsa_switch *ds, int port,
 	regmap_write(chip->regmap, flow_ctl_reg[port], reg);
 }
 
+static const struct phylink_mac_ops lan9303_phylink_mac_ops = {
+	.mac_config	= lan9303_phylink_mac_config,
+	.mac_link_down	= lan9303_phylink_mac_link_down,
+	.mac_link_up	= lan9303_phylink_mac_link_up,
+};
+
 static const struct dsa_switch_ops lan9303_switch_ops = {
 	.get_tag_protocol	= lan9303_get_tag_protocol,
 	.setup			= lan9303_setup,
@@ -1337,7 +1358,6 @@ static const struct dsa_switch_ops lan9303_switch_ops = {
 	.phy_read		= lan9303_phy_read,
 	.phy_write		= lan9303_phy_write,
 	.phylink_get_caps	= lan9303_phylink_get_caps,
-	.phylink_mac_link_up	= lan9303_phylink_mac_link_up,
 	.get_ethtool_stats	= lan9303_get_ethtool_stats,
 	.get_sset_count		= lan9303_get_sset_count,
 	.port_enable		= lan9303_port_enable,
@@ -1365,6 +1385,7 @@ static int lan9303_register_switch(struct lan9303 *chip)
 	chip->ds->num_ports = LAN9303_NUM_PORTS;
 	chip->ds->priv = chip;
 	chip->ds->ops = &lan9303_switch_ops;
+	chip->ds->phylink_mac_ops = &lan9303_phylink_mac_ops;
 	base = chip->phy_addr_base;
 	chip->ds->phys_mii_mask = GENMASK(LAN9303_NUM_PORTS - 1 + base, base);
 
-- 
2.43.0



