Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964B7175A99;
	Mon, 17 Aug 2026 14:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976829; cv=none; b=SVYFXblfnckk3yPUhZYx7McR64LQSkGjRO9zXCccTnFtVkaIkMBFLmFCKjIMjecRwcmY3uV4zIwyNbHLNkhfPSfEc7D00I9YME/4770bXl5iBcLI7ZlERsb0p9VNzD0VAHWax4G9ygc8rXIxBShZMQtmN0iq41jSJT79MmBquRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976829; c=relaxed/simple;
	bh=vHwjiiBNzi88SZQZbTnRNMOgCFNiEHL2VpvsHIi9I7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aeKEQOGhkUlE8sqXHynDxLuBKIuYyf5Augtg0+yRNvHFCRmkDs74u4VFRSMkQy4jUQqcxBhuDft+/QHqzZTFr1mO9reX6v563Fo7GVH+thkKqtoTrSm3osCBBRa1ICl+vY1ATjT/6tuBY2yl6ISnY7T4g2CXJaYFfYDQVfOS79I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15fmewnV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15fmewnV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21931F000E9;
	Mon, 17 Aug 2026 14:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976828;
	bh=ZCugLSmDDEasZGasKK9VamMR1XVbC+h7+tUTFR8+Kas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=15fmewnVXvVTRIhlENKgFxejJuH5TrQwd7565TeybkXNCcQtuIHEp+c0ZfsLioQJf
	 FdozNgpLB3LE7LC6epNG0TIPnMS6XRQFvIZ3WcY3U68fPAu1VsZA4vob8XEOdw4+Wx
	 HpU2EUcsKwLgZZr5UmuSMc7yTilz2nOihu0Jodz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/456] net: dpaa2-eth: assign priv->mac after dpaa2_mac_connect() call
Date: Mon, 17 Aug 2026 15:28:11 +0200
Message-ID: <20260817132544.045840920@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
index 0439bf465fa5bd..c6f20ceadede31 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4248,9 +4248,8 @@ static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
 	err = dpaa2_mac_open(mac);
 	if (err)
 		goto err_free_mac;
-	priv->mac = mac;
 
-	if (dpaa2_eth_is_type_phy(priv)) {
+	if (dpaa2_mac_is_type_phy(mac)) {
 		err = dpaa2_mac_connect(mac);
 		if (err && err != -EPROBE_DEFER)
 			netdev_err(priv->net_dev, "Error connecting to the MAC endpoint: %pe",
@@ -4259,11 +4258,12 @@ static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
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
@@ -4273,15 +4273,18 @@ static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
 
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



