Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546EB2C11DE;
	Mon, 17 Aug 2026 15:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979148; cv=none; b=KRnKsSoyKmVn7g7iAA3ESGgCdem+o5QjA0tgIybEJTs2SYZ9MG9SrB0NvPeRI2IM7MY+4k6oY057IcVcKZYg91yRy3CqtmDqYVmdqwfiDKnv77t32EiMDWW5duTsr+wblX+T5jPrZPdC7d10f/NUcQRYZBiJAbRImUNJ43w8Q7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979148; c=relaxed/simple;
	bh=ZXdkBmsIhjrGXSLzOx7wsCqbUf5CAWdVUcDx490Drrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AWZg4C/7b7/BgekNYx52jtTewXZ7OnH6IpUNVLdUQ3cKHIZ94YybKi2U00mk3McWYR9xRPkw24fD09Xdma2Kw6f8AWg3Z+kW6eIFUxIsNMWP/u/Ripbd0a6UQAQqMBMkf5i/NYUbcvPTJMF5GyxENT0Ib4nGi56581WRn0Sji3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EpueUSgo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EpueUSgo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0B61F000E9;
	Mon, 17 Aug 2026 15:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979147;
	bh=V49S+J0Jx8VBpnuEa5dRExk6PmfazGs7jiDgZ0eJv6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EpueUSgox2zTBY9X/fqakJT0bcjz5l+DdjzDX8hrFtl20h+G0Rl2/T0KkAcjtMXaf
	 ZrQxXN3Ww9vfHI+BJdtAjwLqvoGZQQpOUUY6aFAsjPkVAIr9hsDJNe+2GwQK7DPMqx
	 /ZCUs+hinzMdVE6dEnJ4Fg0CqdJJ1hGIuVMps3o4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 126/609] net: dpaa2-eth: assign priv->mac after dpaa2_mac_connect() call
Date: Mon, 17 Aug 2026 15:27:02 +0200
Message-ID: <20260817132548.070416447@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 02d61948e8daf3844d0af41ba5d563ef03cc7c4f ]

There are 2 requirements for correct code:

- Any time the driver accesses the priv->mac pointer at runtime, it
  either holds NULL to indicate a DPNI-DPNI connection (or unconnected
  DPNI), or a struct dpaa2_mac whose phylink instance was fully
  initialized (created and connected to the PHY). No changes are made to
  priv->mac while it is being used. Currently, rtnl_lock() watches over
  the call to dpaa2_eth_connect_mac(), so it serves the purpose of
  serializing this with all readers of priv->mac.

- dpaa2_mac_connect() should run unlocked, because inside it are 2
  phylink calls with incompatible locking requirements: phylink_create()
  requires that the rtnl_mutex isn't held, and phylink_fwnode_phy_connect()
  requires that the rtnl_mutex is held. The only way to solve those
  contradictory requirements is to let dpaa2_mac_connect() take
  rtnl_lock() when it needs to.

To solve both requirements, we need to identify the writer side of the
priv->mac pointer, which can be wrapped in a mutex private to the driver
in a future patch. The dpaa2_mac_connect() cannot be part of the writer
side critical section, because of an AB/BA deadlock with rtnl_lock().

So the strategy needs to be that where we prepare the DPMAC by calling
dpaa2_mac_connect(), and only make priv->mac point to it once it's fully
prepared. This ensures that the writer side critical section has the
absolute minimum surface it can.

The reverse strategy is adopted in the dpaa2_eth_disconnect_mac() code
path. This makes sure that priv->mac is NULL when we start tearing down
the DPMAC that we disconnected from, and concurrent code will simply not
see it.

No locking changes in this patch (concurrent code is still blocked by
the rtnl_mutex).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: b4b201cc93ff ("dpaa2-eth: put MAC endpoint device on disconnect")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 21 +++++++++++--------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 3c19be56af22e5..6727e17fb5145e 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4466,9 +4466,8 @@ static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
 	err = dpaa2_mac_open(mac);
 	if (err)
 		goto err_free_mac;
-	priv->mac = mac;
 
-	if (dpaa2_eth_is_type_phy(priv)) {
+	if (dpaa2_mac_is_type_phy(mac)) {
 		err = dpaa2_mac_connect(mac);
 		if (err && err != -EPROBE_DEFER)
 			netdev_err(priv->net_dev, "Error connecting to the MAC endpoint: %pe",
@@ -4477,11 +4476,12 @@ static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
 			goto err_close_mac;
 	}
 
+	priv->mac = mac;
+
 	return 0;
 
 err_close_mac:
 	dpaa2_mac_close(mac);
-	priv->mac = NULL;
 err_free_mac:
 	kfree(mac);
 out_put_device:
@@ -4491,15 +4491,18 @@ static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
 
 static void dpaa2_eth_disconnect_mac(struct dpaa2_eth_priv *priv)
 {
-	if (dpaa2_eth_is_type_phy(priv))
-		dpaa2_mac_disconnect(priv->mac);
+	struct dpaa2_mac *mac = priv->mac;
 
-	if (!dpaa2_eth_has_mac(priv))
+	priv->mac = NULL;
+
+	if (!mac)
 		return;
 
-	dpaa2_mac_close(priv->mac);
-	kfree(priv->mac);
-	priv->mac = NULL;
+	if (dpaa2_mac_is_type_phy(mac))
+		dpaa2_mac_disconnect(mac);
+
+	dpaa2_mac_close(mac);
+	kfree(mac);
 }
 
 static irqreturn_t dpni_irq0_handler_thread(int irq_num, void *arg)
-- 
2.53.0



