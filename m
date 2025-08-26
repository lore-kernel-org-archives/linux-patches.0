Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270A61DE8BE;
	Tue, 26 Aug 2025 14:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218310; cv=none; b=ajQSCq/5EQdM7BI7oL2YO6uCZJOX2axTq14xTTU5+vwV2Je1Pm6mEjTwdSELcLeIZ7Gh4j2G+gzR8/JKBQXZxb00/GcoZcWu75ATN41WAHhBSSU0pAcoZX6NJOK12Iv5ucWHzWp21EwFU4ZLI2m06KfxyIjLo9E/VSNQVhq1cU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218310; c=relaxed/simple;
	bh=wRogOnvZ/E/BFquimxjZKpscViFBn3KMY8vH8j2KpFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oF4ezHCZI77ZVRJhsxA/mtrzRVXCaLM/uw1qusY2H2LNZdok8NBipTS1545g48sa85ziMn+swVPBhgHwEGXqn88G73f2eaq/isS9gY4P1hef3gRlN4YpduEkAqzQBLro0A5upTrY2gEmvxZTFCJs4IRSOtawus/BmIsDJAjENEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DCSbqWig; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DCSbqWig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1E9C4CEF1;
	Tue, 26 Aug 2025 14:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218309;
	bh=wRogOnvZ/E/BFquimxjZKpscViFBn3KMY8vH8j2KpFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DCSbqWignK50uVoKNSju7ty0E4ZWi4pNaM30Ivkro6rrM/amm7voDYBcqDHJyisGc
	 60s4XnUc2Vh0rBfXxJsWty0pfO16P2hef8WLhm+mYmAcbmUyEZcGmX92EBZBw6St0c
	 6iAZH31xQbyr+8Q2TgOHjp0q/SpDKTBqMk1waZ+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 442/523] dpaa2-mac: split up initializing the MAC object from connecting to it
Date: Tue, 26 Aug 2025 13:10:52 +0200
Message-ID: <20250826110935.354255094@linuxfoundation.org>
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

[ Upstream commit 095dca16d92f32150314ef47ea150ed83c5aacd9 ]

Split up the initialization phase of the dpmac object from actually
configuring the phylink instance, connecting to it and configuring the
MAC. This is done so that even though the dpni object is connected to a
dpmac which has link management handled by the firmware we are still
able to export the MAC counters.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: ee9f3a81ab08 ("dpaa2-eth: Fix device reference count leak in MAC endpoint handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c |   14 ++++
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c |   69 ++++++++++++++---------
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h |    5 +
 3 files changed, 59 insertions(+), 29 deletions(-)

--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4148,15 +4148,24 @@ static int dpaa2_eth_connect_mac(struct
 	mac->mc_io = priv->mc_io;
 	mac->net_dev = priv->net_dev;
 
+	err = dpaa2_mac_open(mac);
+	if (err)
+		goto err_free_mac;
+
 	err = dpaa2_mac_connect(mac);
 	if (err) {
 		netdev_err(priv->net_dev, "Error connecting to the MAC endpoint\n");
-		kfree(mac);
-		return err;
+		goto err_close_mac;
 	}
 	priv->mac = mac;
 
 	return 0;
+
+err_close_mac:
+	dpaa2_mac_close(mac);
+err_free_mac:
+	kfree(mac);
+	return err;
 }
 
 static void dpaa2_eth_disconnect_mac(struct dpaa2_eth_priv *priv)
@@ -4165,6 +4174,7 @@ static void dpaa2_eth_disconnect_mac(str
 		return;
 
 	dpaa2_mac_disconnect(priv->mac);
+	dpaa2_mac_close(priv->mac);
 	kfree(priv->mac);
 	priv->mac = NULL;
 }
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -302,36 +302,20 @@ static void dpaa2_pcs_destroy(struct dpa
 
 int dpaa2_mac_connect(struct dpaa2_mac *mac)
 {
-	struct fsl_mc_device *dpmac_dev = mac->mc_dev;
 	struct net_device *net_dev = mac->net_dev;
 	struct device_node *dpmac_node;
 	struct phylink *phylink;
-	struct dpmac_attr attr;
 	int err;
 
-	err = dpmac_open(mac->mc_io, 0, dpmac_dev->obj_desc.id,
-			 &dpmac_dev->mc_handle);
-	if (err || !dpmac_dev->mc_handle) {
-		netdev_err(net_dev, "dpmac_open() = %d\n", err);
-		return -ENODEV;
-	}
-
-	err = dpmac_get_attributes(mac->mc_io, 0, dpmac_dev->mc_handle, &attr);
-	if (err) {
-		netdev_err(net_dev, "dpmac_get_attributes() = %d\n", err);
-		goto err_close_dpmac;
-	}
-
-	mac->if_link_type = attr.link_type;
+	mac->if_link_type = mac->attr.link_type;
 
-	dpmac_node = dpaa2_mac_get_node(attr.id);
+	dpmac_node = dpaa2_mac_get_node(mac->attr.id);
 	if (!dpmac_node) {
-		netdev_err(net_dev, "No dpmac@%d node found.\n", attr.id);
-		err = -ENODEV;
-		goto err_close_dpmac;
+		netdev_err(net_dev, "No dpmac@%d node found.\n", mac->attr.id);
+		return -ENODEV;
 	}
 
-	err = dpaa2_mac_get_if_mode(dpmac_node, attr);
+	err = dpaa2_mac_get_if_mode(dpmac_node, mac->attr);
 	if (err < 0) {
 		err = -EINVAL;
 		goto err_put_node;
@@ -351,9 +335,9 @@ int dpaa2_mac_connect(struct dpaa2_mac *
 		goto err_put_node;
 	}
 
-	if (attr.link_type == DPMAC_LINK_TYPE_PHY &&
-	    attr.eth_if != DPMAC_ETH_IF_RGMII) {
-		err = dpaa2_pcs_create(mac, dpmac_node, attr.id);
+	if (mac->attr.link_type == DPMAC_LINK_TYPE_PHY &&
+	    mac->attr.eth_if != DPMAC_ETH_IF_RGMII) {
+		err = dpaa2_pcs_create(mac, dpmac_node, mac->attr.id);
 		if (err)
 			goto err_put_node;
 	}
@@ -389,8 +373,7 @@ err_pcs_destroy:
 	dpaa2_pcs_destroy(mac);
 err_put_node:
 	of_node_put(dpmac_node);
-err_close_dpmac:
-	dpmac_close(mac->mc_io, 0, dpmac_dev->mc_handle);
+
 	return err;
 }
 
@@ -402,8 +385,40 @@ void dpaa2_mac_disconnect(struct dpaa2_m
 	phylink_disconnect_phy(mac->phylink);
 	phylink_destroy(mac->phylink);
 	dpaa2_pcs_destroy(mac);
+}
+
+int dpaa2_mac_open(struct dpaa2_mac *mac)
+{
+	struct fsl_mc_device *dpmac_dev = mac->mc_dev;
+	struct net_device *net_dev = mac->net_dev;
+	int err;
 
-	dpmac_close(mac->mc_io, 0, mac->mc_dev->mc_handle);
+	err = dpmac_open(mac->mc_io, 0, dpmac_dev->obj_desc.id,
+			 &dpmac_dev->mc_handle);
+	if (err || !dpmac_dev->mc_handle) {
+		netdev_err(net_dev, "dpmac_open() = %d\n", err);
+		return -ENODEV;
+	}
+
+	err = dpmac_get_attributes(mac->mc_io, 0, dpmac_dev->mc_handle,
+				   &mac->attr);
+	if (err) {
+		netdev_err(net_dev, "dpmac_get_attributes() = %d\n", err);
+		goto err_close_dpmac;
+	}
+
+	return 0;
+
+err_close_dpmac:
+	dpmac_close(mac->mc_io, 0, dpmac_dev->mc_handle);
+	return err;
+}
+
+void dpaa2_mac_close(struct dpaa2_mac *mac)
+{
+	struct fsl_mc_device *dpmac_dev = mac->mc_dev;
+
+	dpmac_close(mac->mc_io, 0, dpmac_dev->mc_handle);
 }
 
 static char dpaa2_mac_ethtool_stats[][ETH_GSTRING_LEN] = {
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
@@ -17,6 +17,7 @@ struct dpaa2_mac {
 	struct dpmac_link_state state;
 	struct net_device *net_dev;
 	struct fsl_mc_io *mc_io;
+	struct dpmac_attr attr;
 
 	struct phylink_config phylink_config;
 	struct phylink *phylink;
@@ -28,6 +29,10 @@ struct dpaa2_mac {
 bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,
 			     struct fsl_mc_io *mc_io);
 
+int dpaa2_mac_open(struct dpaa2_mac *mac);
+
+void dpaa2_mac_close(struct dpaa2_mac *mac);
+
 int dpaa2_mac_connect(struct dpaa2_mac *mac);
 
 void dpaa2_mac_disconnect(struct dpaa2_mac *mac);


