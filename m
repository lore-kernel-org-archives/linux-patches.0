Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEB427280A;
	Mon, 13 Apr 2026 16:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097260; cv=none; b=Tq/XURZUl88h099jkbUV6YIt2KUKu4fEqmbl5cDmb1y8c9ILB2pVCoaLTuqwCOEt4QPYXm+cMxShlj4x9IPklMBVvRLXJFg4wksXNqNKSUlmPT7HVXRa1980eiePOYsapGUrXNxtBCbQj8CcWvgQbG/hQ2l2gdeeS7ymC6FdNyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097260; c=relaxed/simple;
	bh=ekEU23To01k6knlFaq8y7Ux+P62YCu+0ArnZvK5So+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hdo/oPkQgNWmHjkclOBjM65DxtbVYPzm8i8jBqO3/4jkQPRh03PlwFR3LJKGoLHeXDiQvsBRmbbLqlzU6L4ECax5rOekzEgzjlyYsCMnUSnBqHzbNPCqNPGOTbTieVRMfhGD5n+wfReh5H4vAtXHYMVrJE6VllTln3Du0N2B3V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iI0tmzaX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iI0tmzaX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8417CC2BCAF;
	Mon, 13 Apr 2026 16:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097259;
	bh=ekEU23To01k6knlFaq8y7Ux+P62YCu+0ArnZvK5So+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iI0tmzaXUsqbifqa+sVvstqWqP7mZ5P29H5i+KYDOUjNncjhyfPZ9xTsGN8v+ybF8
	 1FmsUWkBRo6pOChaq5PBWuBOgv6m5rwxdhgAmhKvaKFsZ9YhC5V65bE9wKKwmbMZDa
	 4+ICfc0PaAXcJ66Y4IM3cN1JIX1J2pHaDqmNJH48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/570] net: dpaa2-switch: serialize changes to priv->mac with a mutex
Date: Mon, 13 Apr 2026 17:53:19 +0200
Message-ID: <20260413155832.990215154@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 3c7f44fa9c4c8a9154935ca49e4cf45c14240335 ]

The dpaa2-switch driver uses a DPMAC in the same way as the dpaa2-eth
driver, so we need to duplicate the locking solution established by the
previous change to the switch driver as well.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 74badb9c20b1 ("dpaa2-switch: Fix interrupt storm after receiving bad if_id in IRQ handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../freescale/dpaa2/dpaa2-switch-ethtool.c    | 32 +++++++++++++++----
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 31 ++++++++++++++++--
 .../ethernet/freescale/dpaa2/dpaa2-switch.h   |  2 ++
 3 files changed, 55 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
index 0b41a945e0fff..dc9f4ad8a061d 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
@@ -60,11 +60,18 @@ dpaa2_switch_get_link_ksettings(struct net_device *netdev,
 {
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
 	struct dpsw_link_state state = {0};
-	int err = 0;
+	int err;
+
+	mutex_lock(&port_priv->mac_lock);
 
-	if (dpaa2_switch_port_is_type_phy(port_priv))
-		return phylink_ethtool_ksettings_get(port_priv->mac->phylink,
-						     link_ksettings);
+	if (dpaa2_switch_port_is_type_phy(port_priv)) {
+		err = phylink_ethtool_ksettings_get(port_priv->mac->phylink,
+						    link_ksettings);
+		mutex_unlock(&port_priv->mac_lock);
+		return err;
+	}
+
+	mutex_unlock(&port_priv->mac_lock);
 
 	err = dpsw_if_get_link_state(port_priv->ethsw_data->mc_io, 0,
 				     port_priv->ethsw_data->dpsw_handle,
@@ -99,9 +106,16 @@ dpaa2_switch_set_link_ksettings(struct net_device *netdev,
 	bool if_running;
 	int err = 0, ret;
 
-	if (dpaa2_switch_port_is_type_phy(port_priv))
-		return phylink_ethtool_ksettings_set(port_priv->mac->phylink,
-						     link_ksettings);
+	mutex_lock(&port_priv->mac_lock);
+
+	if (dpaa2_switch_port_is_type_phy(port_priv)) {
+		err = phylink_ethtool_ksettings_set(port_priv->mac->phylink,
+						    link_ksettings);
+		mutex_unlock(&port_priv->mac_lock);
+		return err;
+	}
+
+	mutex_unlock(&port_priv->mac_lock);
 
 	/* Interface needs to be down to change link settings */
 	if_running = netif_running(netdev);
@@ -196,8 +210,12 @@ static void dpaa2_switch_ethtool_get_stats(struct net_device *netdev,
 				   dpaa2_switch_ethtool_counters[i].name, err);
 	}
 
+	mutex_lock(&port_priv->mac_lock);
+
 	if (dpaa2_switch_port_has_mac(port_priv))
 		dpaa2_mac_get_ethtool_stats(port_priv->mac, data + i);
+
+	mutex_unlock(&port_priv->mac_lock);
 }
 
 const struct ethtool_ops dpaa2_switch_port_ethtool_ops = {
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index a2812229511c3..92500e55ab931 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -602,8 +602,11 @@ static int dpaa2_switch_port_link_state_update(struct net_device *netdev)
 
 	/* When we manage the MAC/PHY using phylink there is no need
 	 * to manually update the netif_carrier.
+	 * We can avoid locking because we are called from the "link changed"
+	 * IRQ handler, which is the same as the "endpoint changed" IRQ handler
+	 * (the writer to port_priv->mac), so we cannot race with it.
 	 */
-	if (dpaa2_switch_port_is_type_phy(port_priv))
+	if (dpaa2_mac_is_type_phy(port_priv->mac))
 		return 0;
 
 	/* Interrupts are received even though no one issued an 'ifconfig up'
@@ -683,6 +686,8 @@ static int dpaa2_switch_port_open(struct net_device *netdev)
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
 	int err;
 
+	mutex_lock(&port_priv->mac_lock);
+
 	if (!dpaa2_switch_port_is_type_phy(port_priv)) {
 		/* Explicitly set carrier off, otherwise
 		 * netif_carrier_ok() will return true and cause 'ip link show'
@@ -696,6 +701,7 @@ static int dpaa2_switch_port_open(struct net_device *netdev)
 			     port_priv->ethsw_data->dpsw_handle,
 			     port_priv->idx);
 	if (err) {
+		mutex_unlock(&port_priv->mac_lock);
 		netdev_err(netdev, "dpsw_if_enable err %d\n", err);
 		return err;
 	}
@@ -705,6 +711,8 @@ static int dpaa2_switch_port_open(struct net_device *netdev)
 	if (dpaa2_switch_port_is_type_phy(port_priv))
 		phylink_start(port_priv->mac->phylink);
 
+	mutex_unlock(&port_priv->mac_lock);
+
 	return 0;
 }
 
@@ -714,6 +722,8 @@ static int dpaa2_switch_port_stop(struct net_device *netdev)
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
 	int err;
 
+	mutex_lock(&port_priv->mac_lock);
+
 	if (dpaa2_switch_port_is_type_phy(port_priv)) {
 		phylink_stop(port_priv->mac->phylink);
 	} else {
@@ -721,6 +731,8 @@ static int dpaa2_switch_port_stop(struct net_device *netdev)
 		netif_carrier_off(netdev);
 	}
 
+	mutex_unlock(&port_priv->mac_lock);
+
 	err = dpsw_if_disable(port_priv->ethsw_data->mc_io, 0,
 			      port_priv->ethsw_data->dpsw_handle,
 			      port_priv->idx);
@@ -1467,7 +1479,9 @@ static int dpaa2_switch_port_connect_mac(struct ethsw_port_priv *port_priv)
 		}
 	}
 
+	mutex_lock(&port_priv->mac_lock);
 	port_priv->mac = mac;
+	mutex_unlock(&port_priv->mac_lock);
 
 	return 0;
 
@@ -1482,9 +1496,12 @@ static int dpaa2_switch_port_connect_mac(struct ethsw_port_priv *port_priv)
 
 static void dpaa2_switch_port_disconnect_mac(struct ethsw_port_priv *port_priv)
 {
-	struct dpaa2_mac *mac = port_priv->mac;
+	struct dpaa2_mac *mac;
 
+	mutex_lock(&port_priv->mac_lock);
+	mac = port_priv->mac;
 	port_priv->mac = NULL;
+	mutex_unlock(&port_priv->mac_lock);
 
 	if (!mac)
 		return;
@@ -1503,6 +1520,7 @@ static irqreturn_t dpaa2_switch_irq0_handler_thread(int irq_num, void *arg)
 	struct ethsw_port_priv *port_priv;
 	u32 status = ~0;
 	int err, if_id;
+	bool had_mac;
 
 	err = dpsw_get_irq_status(ethsw->mc_io, 0, ethsw->dpsw_handle,
 				  DPSW_IRQ_INDEX_IF, &status);
@@ -1525,7 +1543,12 @@ static irqreturn_t dpaa2_switch_irq0_handler_thread(int irq_num, void *arg)
 
 	if (status & DPSW_IRQ_EVENT_ENDPOINT_CHANGED) {
 		rtnl_lock();
-		if (dpaa2_switch_port_has_mac(port_priv))
+		/* We can avoid locking because the "endpoint changed" IRQ
+		 * handler is the only one who changes priv->mac at runtime,
+		 * so we are not racing with anyone.
+		 */
+		had_mac = !!port_priv->mac;
+		if (had_mac)
 			dpaa2_switch_port_disconnect_mac(port_priv);
 		else
 			dpaa2_switch_port_connect_mac(port_priv);
@@ -3281,6 +3304,8 @@ static int dpaa2_switch_probe_port(struct ethsw_core *ethsw,
 	port_priv->netdev = port_netdev;
 	port_priv->ethsw_data = ethsw;
 
+	mutex_init(&port_priv->mac_lock);
+
 	port_priv->idx = port_idx;
 	port_priv->stp_state = BR_STATE_FORWARDING;
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
index 9898073abe012..42b3ca73f55d5 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
@@ -161,6 +161,8 @@ struct ethsw_port_priv {
 
 	struct dpaa2_switch_filter_block *filter_block;
 	struct dpaa2_mac	*mac;
+	/* Protects against changes to port_priv->mac */
+	struct mutex		mac_lock;
 };
 
 /* Switch data */
-- 
2.51.0



