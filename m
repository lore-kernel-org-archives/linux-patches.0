Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D896237BE75;
	Mon,  9 Feb 2026 14:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647987; cv=none; b=ieaZvnnEYaZfmJlkNIUR4dnG6jtou7PoeJSgf8PW96uLczqsn/jP3nrbSmQyefshFKmt5CcbyUTzK/bC8+sVNVJE2ZMoZvZVAdzMpoNUani1kE5DMREpICvv4/fMAyqUvJGQxDCZUfnCsXVpOVD0lGAlcSPWCuvgnOmh0B3VOHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647987; c=relaxed/simple;
	bh=9KLCyVYhvq2scr1mG6uyhUyRJ6ykmhIhV5EJkkhwRwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfLfMkar4sicagEIDAoW79V25PHcLSxd+4pyd6EFjf9kNUOQu9vv1jRx54ap4GANds5u34uGA4X07yCKWN4bf7im06ciBsiK/tOjZLKWoEDu2m9AvdI+AMjqPluuup2FaycbIcvJEMYRtSgq3Uwl6NdFWVwyHrdyko5ntJZ4DXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kHdqH3ih; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHdqH3ih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65542C116C6;
	Mon,  9 Feb 2026 14:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647987;
	bh=9KLCyVYhvq2scr1mG6uyhUyRJ6ykmhIhV5EJkkhwRwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kHdqH3ihVKsV2IFLUm5IQ1TMukvSTKFYSZo/e66ZfRiglBuuvGYfoMvaYoC+7b9gf
	 A1hDewyTrf0L9u1DxmQB6HDpW6HuugfqKbWGHGAQO4kMOgXX+cLM2/idwge7sDuvdm
	 UbddQz0HyPFeWJpsGp9LKZq8Dr3uZZBmuI69Ig9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 087/113] net: sfp: pre-parse the module support
Date: Mon,  9 Feb 2026 15:23:56 +0100
Message-ID: <20260209142313.311005892@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit ddae6127afbba46e32af3b31eb7bba939e1fad96 ]

Pre-parse the module support on insert rather than when the upstream
requests the data. This will allow more flexible and extensible
parsing.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/E1uydVZ-000000061WE-2pXD@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: adcbadfd8e05 ("net: sfp: Fix quirk for Ubiquiti U-Fiber Instant SFP module")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp-bus.c | 80 +++++++++++++++++++++++++++------------
 include/linux/sfp.h       | 22 +++++++++++
 2 files changed, 77 insertions(+), 25 deletions(-)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index f13c00b5b449c..35030c527fbed 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -22,7 +22,6 @@ struct sfp_bus {
 	const struct sfp_socket_ops *socket_ops;
 	struct device *sfp_dev;
 	struct sfp *sfp;
-	const struct sfp_quirk *sfp_quirk;
 
 	const struct sfp_upstream_ops *upstream_ops;
 	void *upstream;
@@ -30,6 +29,8 @@ struct sfp_bus {
 
 	bool registered;
 	bool started;
+
+	struct sfp_module_caps caps;
 };
 
 /**
@@ -48,6 +49,13 @@ struct sfp_bus {
  */
 int sfp_parse_port(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 		   unsigned long *support)
+{
+	return bus->caps.port;
+}
+EXPORT_SYMBOL_GPL(sfp_parse_port);
+
+static void sfp_module_parse_port(struct sfp_bus *bus,
+				  const struct sfp_eeprom_id *id)
 {
 	int port;
 
@@ -91,21 +99,18 @@ int sfp_parse_port(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 		break;
 	}
 
-	if (support) {
-		switch (port) {
-		case PORT_FIBRE:
-			phylink_set(support, FIBRE);
-			break;
+	switch (port) {
+	case PORT_FIBRE:
+		phylink_set(bus->caps.link_modes, FIBRE);
+		break;
 
-		case PORT_TP:
-			phylink_set(support, TP);
-			break;
-		}
+	case PORT_TP:
+		phylink_set(bus->caps.link_modes, TP);
+		break;
 	}
 
-	return port;
+	bus->caps.port = port;
 }
-EXPORT_SYMBOL_GPL(sfp_parse_port);
 
 /**
  * sfp_may_have_phy() - indicate whether the module may have a PHY
@@ -117,8 +122,17 @@ EXPORT_SYMBOL_GPL(sfp_parse_port);
  */
 bool sfp_may_have_phy(struct sfp_bus *bus, const struct sfp_eeprom_id *id)
 {
-	if (id->base.e1000_base_t)
-		return true;
+	return bus->caps.may_have_phy;
+}
+EXPORT_SYMBOL_GPL(sfp_may_have_phy);
+
+static void sfp_module_parse_may_have_phy(struct sfp_bus *bus,
+					  const struct sfp_eeprom_id *id)
+{
+	if (id->base.e1000_base_t) {
+		bus->caps.may_have_phy = true;
+		return;
+	}
 
 	if (id->base.phys_id != SFF8024_ID_DWDM_SFP) {
 		switch (id->base.extended_cc) {
@@ -126,13 +140,13 @@ bool sfp_may_have_phy(struct sfp_bus *bus, const struct sfp_eeprom_id *id)
 		case SFF8024_ECC_10GBASE_T_SR:
 		case SFF8024_ECC_5GBASE_T:
 		case SFF8024_ECC_2_5GBASE_T:
-			return true;
+			bus->caps.may_have_phy = true;
+			return;
 		}
 	}
 
-	return false;
+	bus->caps.may_have_phy = false;
 }
-EXPORT_SYMBOL_GPL(sfp_may_have_phy);
 
 /**
  * sfp_parse_support() - Parse the eeprom id for supported link modes
@@ -148,8 +162,17 @@ EXPORT_SYMBOL_GPL(sfp_may_have_phy);
 void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 		       unsigned long *support, unsigned long *interfaces)
 {
+	linkmode_or(support, support, bus->caps.link_modes);
+	phy_interface_copy(interfaces, bus->caps.interfaces);
+}
+EXPORT_SYMBOL_GPL(sfp_parse_support);
+
+static void sfp_module_parse_support(struct sfp_bus *bus,
+				     const struct sfp_eeprom_id *id)
+{
+	unsigned long *interfaces = bus->caps.interfaces;
+	unsigned long *modes = bus->caps.link_modes;
 	unsigned int br_min, br_nom, br_max;
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(modes) = { 0, };
 
 	/* Decode the bitrate information to MBd */
 	br_min = br_nom = br_max = 0;
@@ -338,13 +361,22 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 	phylink_set(modes, Autoneg);
 	phylink_set(modes, Pause);
 	phylink_set(modes, Asym_Pause);
+}
+
+static void sfp_init_module(struct sfp_bus *bus,
+			    const struct sfp_eeprom_id *id,
+			    const struct sfp_quirk *quirk)
+{
+	memset(&bus->caps, 0, sizeof(bus->caps));
 
-	if (bus->sfp_quirk && bus->sfp_quirk->modes)
-		bus->sfp_quirk->modes(id, modes, interfaces);
+	sfp_module_parse_support(bus, id);
+	sfp_module_parse_port(bus, id);
+	sfp_module_parse_may_have_phy(bus, id);
 
-	linkmode_or(support, support, modes);
+	if (quirk && quirk->modes)
+		quirk->modes(id, bus->caps.link_modes,
+			     bus->caps.interfaces);
 }
-EXPORT_SYMBOL_GPL(sfp_parse_support);
 
 /**
  * sfp_select_interface() - Select appropriate phy_interface_t mode
@@ -794,7 +826,7 @@ int sfp_module_insert(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 	const struct sfp_upstream_ops *ops = sfp_get_upstream_ops(bus);
 	int ret = 0;
 
-	bus->sfp_quirk = quirk;
+	sfp_init_module(bus, id, quirk);
 
 	if (ops && ops->module_insert)
 		ret = ops->module_insert(bus->upstream, id);
@@ -809,8 +841,6 @@ void sfp_module_remove(struct sfp_bus *bus)
 
 	if (ops && ops->module_remove)
 		ops->module_remove(bus->upstream);
-
-	bus->sfp_quirk = NULL;
 }
 EXPORT_SYMBOL_GPL(sfp_module_remove);
 
diff --git a/include/linux/sfp.h b/include/linux/sfp.h
index 60c65cea74f62..5fb59cf49882c 100644
--- a/include/linux/sfp.h
+++ b/include/linux/sfp.h
@@ -521,6 +521,28 @@ struct ethtool_eeprom;
 struct ethtool_modinfo;
 struct sfp_bus;
 
+/**
+ * struct sfp_module_caps - sfp module capabilities
+ * @interfaces: bitmap of interfaces that the module may support
+ * @link_modes: bitmap of ethtool link modes that the module may support
+ */
+struct sfp_module_caps {
+	DECLARE_PHY_INTERFACE_MASK(interfaces);
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(link_modes);
+	/**
+	 * @may_have_phy: indicate whether the module may have an ethernet PHY
+	 * There is no way to be sure that a module has a PHY as the EEPROM
+	 * doesn't contain this information. When set, this does not mean that
+	 * the module definitely has a PHY.
+	 */
+	bool may_have_phy;
+	/**
+	 * @port: one of ethtool %PORT_* definitions, parsed from the module
+	 * EEPROM, or %PORT_OTHER if the port type is not known.
+	 */
+	u8 port;
+};
+
 /**
  * struct sfp_upstream_ops - upstream operations structure
  * @attach: called when the sfp socket driver is bound to the upstream
-- 
2.51.0



