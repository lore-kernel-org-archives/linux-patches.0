Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D31355800;
	Wed,  3 Dec 2025 16:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780256; cv=none; b=uii8HEqs4XbOd5Sif5R4PqpUHykBDix91k64MGhHx3CYMU1EmW1+VP58kkPeProz3xdZxXfqK+gN24H8pVAG8cWdcLxwqIl/DQmZXpINQgTtt2oycc0ypy/bQ/7KMx4a+VllS6F10z0ScuitRr1syZy7LhHXb6qYY6pdYxNexaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780256; c=relaxed/simple;
	bh=AZQZxZ3fyIcu1VrOV9BiE3TIqvVmia/fY03gAj5Fovo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MXiVsAoy80QRGxawPRqtmZiAScdZXOBMnEg7F8KY+RR6mqU+y2Tl3fJatRJKtl3eTN8ICx0vpBpgw7yOSy5hPc4YJ2iKES1q2h3NEJOdZORc5Qf0EmN2RMBj/tJdGUUymRb4PPeOVKn4rz6D2pQrA5c80xcsPT/hkFafo+VEOz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uRl20XS3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uRl20XS3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42AD3C4CEF5;
	Wed,  3 Dec 2025 16:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780256;
	bh=AZQZxZ3fyIcu1VrOV9BiE3TIqvVmia/fY03gAj5Fovo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uRl20XS3RATceklPE4wNkeCK5voCmNyZdgGrIhLA/U04Ud3o3m97cAWZ75xq42uhL
	 SGBv9rDisGowS5x2Rtvan2krA+oZGn8259/VKumozVW8xoQP4KfiFchfXZB8dhDNrl
	 hUDvy0YSBMxxb6bj5IufwUC26tuSel7DGZk9N6HU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 503/568] net: dsa: sja1105: simplify static configuration reload
Date: Wed,  3 Dec 2025 16:28:25 +0100
Message-ID: <20251203152459.135974362@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit a18891b55703a45b700618ef40edd5e9aaecc345 ]

The static configuration reload saves the port speed in the static
configuration tables by first converting it from the internal
respresentation to the SPEED_xxx ethtool representation, and then
converts it back to restore the setting. This is because
sja1105_adjust_port_config() takes the speed as SPEED_xxx.

However, this is unnecessarily complex. If we split
sja1105_adjust_port_config() up, we can simply save and restore the
mac[port].speed member in the static configuration tables.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/E1svfMa-005ZIX-If@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: da62abaaa268 ("net: dsa: sja1105: fix SGMII linking at 10M or 100M but not passing traffic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 65 ++++++++++++++------------
 1 file changed, 34 insertions(+), 31 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index d51d982c4bc01..8350696bdda5b 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1262,29 +1262,11 @@ static int sja1105_parse_dt(struct sja1105_private *priv)
 	return rc;
 }
 
-/* Convert link speed from SJA1105 to ethtool encoding */
-static int sja1105_port_speed_to_ethtool(struct sja1105_private *priv,
-					 u64 speed)
-{
-	if (speed == priv->info->port_speed[SJA1105_SPEED_10MBPS])
-		return SPEED_10;
-	if (speed == priv->info->port_speed[SJA1105_SPEED_100MBPS])
-		return SPEED_100;
-	if (speed == priv->info->port_speed[SJA1105_SPEED_1000MBPS])
-		return SPEED_1000;
-	if (speed == priv->info->port_speed[SJA1105_SPEED_2500MBPS])
-		return SPEED_2500;
-	return SPEED_UNKNOWN;
-}
-
-/* Set link speed in the MAC configuration for a specific port. */
-static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
-				      int speed_mbps)
+static int sja1105_set_port_speed(struct sja1105_private *priv, int port,
+				  int speed_mbps)
 {
 	struct sja1105_mac_config_entry *mac;
-	struct device *dev = priv->ds->dev;
 	u64 speed;
-	int rc;
 
 	/* On P/Q/R/S, one can read from the device via the MAC reconfiguration
 	 * tables. On E/T, MAC reconfig tables are not readable, only writable.
@@ -1318,7 +1300,7 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 		speed = priv->info->port_speed[SJA1105_SPEED_2500MBPS];
 		break;
 	default:
-		dev_err(dev, "Invalid speed %iMbps\n", speed_mbps);
+		dev_err(priv->ds->dev, "Invalid speed %iMbps\n", speed_mbps);
 		return -EINVAL;
 	}
 
@@ -1330,11 +1312,31 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 	 * we need to configure the PCS only (if even that).
 	 */
 	if (priv->phy_mode[port] == PHY_INTERFACE_MODE_SGMII)
-		mac[port].speed = priv->info->port_speed[SJA1105_SPEED_1000MBPS];
+		speed = priv->info->port_speed[SJA1105_SPEED_1000MBPS];
 	else if (priv->phy_mode[port] == PHY_INTERFACE_MODE_2500BASEX)
-		mac[port].speed = priv->info->port_speed[SJA1105_SPEED_2500MBPS];
-	else
-		mac[port].speed = speed;
+		speed = priv->info->port_speed[SJA1105_SPEED_2500MBPS];
+
+	mac[port].speed = speed;
+
+	return 0;
+}
+
+/* Write the MAC Configuration Table entry and, if necessary, the CGU settings,
+ * after a link speedchange for this port.
+ */
+static int sja1105_set_port_config(struct sja1105_private *priv, int port)
+{
+	struct sja1105_mac_config_entry *mac;
+	struct device *dev = priv->ds->dev;
+	int rc;
+
+	/* On P/Q/R/S, one can read from the device via the MAC reconfiguration
+	 * tables. On E/T, MAC reconfig tables are not readable, only writable.
+	 * We have to *know* what the MAC looks like.  For the sake of keeping
+	 * the code common, we'll use the static configuration tables as a
+	 * reasonable approximation for both E/T and P/Q/R/S.
+	 */
+	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
 
 	/* Write to the dynamic reconfiguration tables */
 	rc = sja1105_dynamic_config_write(priv, BLK_IDX_MAC_CONFIG, port,
@@ -1384,7 +1386,8 @@ static void sja1105_mac_link_up(struct dsa_switch *ds, int port,
 {
 	struct sja1105_private *priv = ds->priv;
 
-	sja1105_adjust_port_config(priv, port, speed);
+	if (!sja1105_set_port_speed(priv, port, speed))
+		sja1105_set_port_config(priv, port);
 
 	sja1105_inhibit_tx(priv, BIT(port), false);
 }
@@ -2291,8 +2294,8 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 {
 	struct ptp_system_timestamp ptp_sts_before;
 	struct ptp_system_timestamp ptp_sts_after;
-	int speed_mbps[SJA1105_MAX_NUM_PORTS];
 	u16 bmcr[SJA1105_MAX_NUM_PORTS] = {0};
+	u64 mac_speed[SJA1105_MAX_NUM_PORTS];
 	struct sja1105_mac_config_entry *mac;
 	struct dsa_switch *ds = priv->ds;
 	s64 t1, t2, t3, t4;
@@ -2305,14 +2308,13 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 
 	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
 
-	/* Back up the dynamic link speed changed by sja1105_adjust_port_config
+	/* Back up the dynamic link speed changed by sja1105_set_port_speed()
 	 * in order to temporarily restore it to SJA1105_SPEED_AUTO - which the
 	 * switch wants to see in the static config in order to allow us to
 	 * change it through the dynamic interface later.
 	 */
 	for (i = 0; i < ds->num_ports; i++) {
-		speed_mbps[i] = sja1105_port_speed_to_ethtool(priv,
-							      mac[i].speed);
+		mac_speed[i] = mac[i].speed;
 		mac[i].speed = priv->info->port_speed[SJA1105_SPEED_AUTO];
 
 		if (priv->xpcs[i])
@@ -2375,7 +2377,8 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 		struct dw_xpcs *xpcs = priv->xpcs[i];
 		unsigned int mode;
 
-		rc = sja1105_adjust_port_config(priv, i, speed_mbps[i]);
+		mac[i].speed = mac_speed[i];
+		rc = sja1105_set_port_config(priv, i);
 		if (rc < 0)
 			goto out;
 
-- 
2.51.0



