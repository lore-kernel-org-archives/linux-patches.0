Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680501DE8BE;
	Tue, 26 Aug 2025 14:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218312; cv=none; b=p0zrcjQPFuZhXZdkxZ0zCdjPHeDWWwfEN04wnOg63icJRvBRjYRX6i0n3JW6TWfslqSXpIearmPyMm2Wg/Um3pc40qSEqzZocN75BO82SlgwWUpqhxokOW+802MvDN7ePRi8B60zuD0nx3dA58iAN9mPBfvlGyzC86NX7H658Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218312; c=relaxed/simple;
	bh=htr/dYvcdk5iHDUAiAtJXXsV1cYpio0lJNLBxfW4CBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+/seE6FcR2XG9RxfkBqwmztize98VZdPNxIRj4hBVRZGWZEvKZgcMaA0hPBOdtMz108UuN9fSQzNqr8o6ofJbwQPNTGMYlh5Q1XFVHRlcln55+E1xnp0/CGzSAHf0MItyFen9gVqb+TVT1u4whHVp8AA1/Szl1I4PpeIUIzsjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FWxR3wCq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FWxR3wCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0FEBC4CEF1;
	Tue, 26 Aug 2025 14:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218312;
	bh=htr/dYvcdk5iHDUAiAtJXXsV1cYpio0lJNLBxfW4CBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FWxR3wCqlyGffJFSxUWHv6JD9URiXOoDxM/zKq57+eL8xLvrsDd0k5lMyZWHleVw0
	 xqA0hz26iPI9Jjzpxhprm8F4Aibytp98oLJXVRq6m7osWm4ldiH89FSFipyZR3M9sw
	 n+KhMYsNJuVvds5e2rSi+Dym8IqeBtOIk/Nb1up4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 443/523] dpaa2-mac: export MAC counters even when in TYPE_FIXED
Date: Tue, 26 Aug 2025 13:10:53 +0200
Message-ID: <20250826110935.378998885@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit d87e606373f641c58d5e8e4c48b3216fd9d1c78a ]

If the network interface object is connected to a MAC of TYPE_FIXED, the
link status management is handled exclusively by the firmware. This does
not mean that the driver cannot access the MAC counters and export them
in ethtool.

For this to happen, we open the attached dpmac device and keep a pointer
to it in priv->mac. Because of this, all the checks in the driver of the
following form 'if (priv->mac)' have to be updated to actually check
the dpmac attribute and not rely on the presence of a non-NULL value.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: ee9f3a81ab08 ("dpaa2-eth: Fix device reference count leak in MAC endpoint handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c     |   37 +++++++++----------
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h     |   13 ++++++
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c |   16 ++++----
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c     |   26 -------------
 4 files changed, 39 insertions(+), 53 deletions(-)

--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1765,7 +1765,7 @@ static int dpaa2_eth_link_state_update(s
 	/* When we manage the MAC/PHY using phylink there is no need
 	 * to manually update the netif_carrier.
 	 */
-	if (priv->mac)
+	if (dpaa2_eth_is_type_phy(priv))
 		goto out;
 
 	/* Chech link state; speed / duplex changes are not treated yet */
@@ -1804,7 +1804,7 @@ static int dpaa2_eth_open(struct net_dev
 			   priv->dpbp_dev->obj_desc.id, priv->bpid);
 	}
 
-	if (!priv->mac) {
+	if (!dpaa2_eth_is_type_phy(priv)) {
 		/* We'll only start the txqs when the link is actually ready;
 		 * make sure we don't race against the link up notification,
 		 * which may come immediately after dpni_enable();
@@ -1826,7 +1826,7 @@ static int dpaa2_eth_open(struct net_dev
 		goto enable_err;
 	}
 
-	if (priv->mac)
+	if (dpaa2_eth_is_type_phy(priv))
 		phylink_start(priv->mac->phylink);
 
 	return 0;
@@ -1900,11 +1900,11 @@ static int dpaa2_eth_stop(struct net_dev
 	int dpni_enabled = 0;
 	int retries = 10;
 
-	if (!priv->mac) {
+	if (dpaa2_eth_is_type_phy(priv)) {
+		phylink_stop(priv->mac->phylink);
+	} else {
 		netif_tx_stop_all_queues(net_dev);
 		netif_carrier_off(net_dev);
-	} else {
-		phylink_stop(priv->mac->phylink);
 	}
 
 	/* On dpni_disable(), the MC firmware will:
@@ -2192,7 +2192,7 @@ static int dpaa2_eth_ioctl(struct net_de
 	if (cmd == SIOCSHWTSTAMP)
 		return dpaa2_eth_ts_ioctl(dev, rq, cmd);
 
-	if (priv->mac)
+	if (dpaa2_eth_is_type_phy(priv))
 		return phylink_mii_ioctl(priv->mac->phylink, rq, cmd);
 
 	return -EOPNOTSUPP;
@@ -4137,9 +4137,6 @@ static int dpaa2_eth_connect_mac(struct
 	if (IS_ERR_OR_NULL(dpmac_dev) || dpmac_dev->dev.type != &fsl_mc_bus_dpmac_type)
 		return 0;
 
-	if (dpaa2_mac_is_type_fixed(dpmac_dev, priv->mc_io))
-		return 0;
-
 	mac = kzalloc(sizeof(struct dpaa2_mac), GFP_KERNEL);
 	if (!mac)
 		return -ENOMEM;
@@ -4151,18 +4148,21 @@ static int dpaa2_eth_connect_mac(struct
 	err = dpaa2_mac_open(mac);
 	if (err)
 		goto err_free_mac;
+	priv->mac = mac;
 
-	err = dpaa2_mac_connect(mac);
-	if (err) {
-		netdev_err(priv->net_dev, "Error connecting to the MAC endpoint\n");
-		goto err_close_mac;
+	if (dpaa2_eth_is_type_phy(priv)) {
+		err = dpaa2_mac_connect(mac);
+		if (err) {
+			netdev_err(priv->net_dev, "Error connecting to the MAC endpoint\n");
+			goto err_close_mac;
+		}
 	}
-	priv->mac = mac;
 
 	return 0;
 
 err_close_mac:
 	dpaa2_mac_close(mac);
+	priv->mac = NULL;
 err_free_mac:
 	kfree(mac);
 	return err;
@@ -4170,10 +4170,9 @@ err_free_mac:
 
 static void dpaa2_eth_disconnect_mac(struct dpaa2_eth_priv *priv)
 {
-	if (!priv->mac)
-		return;
+	if (dpaa2_eth_is_type_phy(priv))
+		dpaa2_mac_disconnect(priv->mac);
 
-	dpaa2_mac_disconnect(priv->mac);
 	dpaa2_mac_close(priv->mac);
 	kfree(priv->mac);
 	priv->mac = NULL;
@@ -4203,7 +4202,7 @@ static irqreturn_t dpni_irq0_handler_thr
 		dpaa2_eth_update_tx_fqids(priv);
 
 		rtnl_lock();
-		if (priv->mac)
+		if (dpaa2_eth_has_mac(priv))
 			dpaa2_eth_disconnect_mac(priv);
 		else
 			dpaa2_eth_connect_mac(priv);
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -705,6 +705,19 @@ static inline unsigned int dpaa2_eth_rx_
 	return priv->tx_data_offset - DPAA2_ETH_RX_HWA_SIZE;
 }
 
+static inline bool dpaa2_eth_is_type_phy(struct dpaa2_eth_priv *priv)
+{
+	if (priv->mac && priv->mac->attr.link_type == DPMAC_LINK_TYPE_PHY)
+		return true;
+
+	return false;
+}
+
+static inline bool dpaa2_eth_has_mac(struct dpaa2_eth_priv *priv)
+{
+	return priv->mac ? true : false;
+}
+
 int dpaa2_eth_set_hash(struct net_device *net_dev, u64 flags);
 int dpaa2_eth_set_cls(struct net_device *net_dev, u64 key);
 int dpaa2_eth_cls_key_size(u64 key);
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -85,7 +85,7 @@ static int dpaa2_eth_nway_reset(struct n
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 
-	if (priv->mac)
+	if (dpaa2_eth_is_type_phy(priv))
 		return phylink_ethtool_nway_reset(priv->mac->phylink);
 
 	return -EOPNOTSUPP;
@@ -97,7 +97,7 @@ dpaa2_eth_get_link_ksettings(struct net_
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 
-	if (priv->mac)
+	if (dpaa2_eth_is_type_phy(priv))
 		return phylink_ethtool_ksettings_get(priv->mac->phylink,
 						     link_settings);
 
@@ -115,7 +115,7 @@ dpaa2_eth_set_link_ksettings(struct net_
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 
-	if (!priv->mac)
+	if (!dpaa2_eth_is_type_phy(priv))
 		return -ENOTSUPP;
 
 	return phylink_ethtool_ksettings_set(priv->mac->phylink, link_settings);
@@ -127,7 +127,7 @@ static void dpaa2_eth_get_pauseparam(str
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 	u64 link_options = priv->link_state.options;
 
-	if (priv->mac) {
+	if (dpaa2_eth_is_type_phy(priv)) {
 		phylink_ethtool_get_pauseparam(priv->mac->phylink, pause);
 		return;
 	}
@@ -150,7 +150,7 @@ static int dpaa2_eth_set_pauseparam(stru
 		return -EOPNOTSUPP;
 	}
 
-	if (priv->mac)
+	if (dpaa2_eth_is_type_phy(priv))
 		return phylink_ethtool_set_pauseparam(priv->mac->phylink,
 						      pause);
 	if (pause->autoneg)
@@ -198,7 +198,7 @@ static void dpaa2_eth_get_strings(struct
 			strlcpy(p, dpaa2_ethtool_extras[i], ETH_GSTRING_LEN);
 			p += ETH_GSTRING_LEN;
 		}
-		if (priv->mac)
+		if (dpaa2_eth_has_mac(priv))
 			dpaa2_mac_get_strings(p);
 		break;
 	}
@@ -211,7 +211,7 @@ static int dpaa2_eth_get_sset_count(stru
 
 	switch (sset) {
 	case ETH_SS_STATS: /* ethtool_get_stats(), ethtool_get_drvinfo() */
-		if (priv->mac)
+		if (dpaa2_eth_has_mac(priv))
 			num_ss_stats += dpaa2_mac_get_sset_count();
 		return num_ss_stats;
 	default:
@@ -311,7 +311,7 @@ static void dpaa2_eth_get_ethtool_stats(
 	}
 	*(data + i++) = buf_cnt;
 
-	if (priv->mac)
+	if (dpaa2_eth_has_mac(priv))
 		dpaa2_mac_get_ethtool_stats(priv->mac, data + i);
 }
 
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -228,32 +228,6 @@ static const struct phylink_mac_ops dpaa
 	.mac_link_down = dpaa2_mac_link_down,
 };
 
-bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,
-			     struct fsl_mc_io *mc_io)
-{
-	struct dpmac_attr attr;
-	bool fixed = false;
-	u16 mc_handle = 0;
-	int err;
-
-	err = dpmac_open(mc_io, 0, dpmac_dev->obj_desc.id,
-			 &mc_handle);
-	if (err || !mc_handle)
-		return false;
-
-	err = dpmac_get_attributes(mc_io, 0, mc_handle, &attr);
-	if (err)
-		goto out;
-
-	if (attr.link_type == DPMAC_LINK_TYPE_FIXED)
-		fixed = true;
-
-out:
-	dpmac_close(mc_io, 0, mc_handle);
-
-	return fixed;
-}
-
 static int dpaa2_pcs_create(struct dpaa2_mac *mac,
 			    struct device_node *dpmac_node, int id)
 {


