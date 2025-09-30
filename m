Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1854C2FB0BE;
	Tue, 30 Sep 2025 15:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246113; cv=none; b=fcbSGnNh9q0c8EzlszxE9Z538I+apCWYlL+s69TTOldxK+kGZHd6BlEc6Wn8gzzmFXruJKgf1PGlxllqE34ADScShirKfX+Gv+NSI/h0JHCLV7muv0w1Hb1La/lkjorvRGD5mxmqMyapb/A5yz0mHqr0+xFJrgqWDhG+mt78FPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246113; c=relaxed/simple;
	bh=q3/KW2adbcUOzsFaoUWlQqa06Vd4giKQib/aLYHHLh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HsZuTJHtnsyEj+TMmhJoYdXdeMIXJaVuFA7wEi8VmvG3MgPidoK0lbESVu77JTXJ2MC8CVVE6OonOmSSZ41K5KhK6VhgMPQnIw4QeatrbzxGq7egTVsNKywk0qCaFNvzeJk0JvWsIrasKddDyHnorU/BGSX9MXXgQconX6kUS1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nuWugo4X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nuWugo4X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139D5C116B1;
	Tue, 30 Sep 2025 15:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246112;
	bh=q3/KW2adbcUOzsFaoUWlQqa06Vd4giKQib/aLYHHLh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nuWugo4X9b0E9IXzV8lFqTwn8BxOYB1+2DjVsUERYzgOP4wyDcx7YMFu9DlVtZGPo
	 b7bHk0JsDLfsOJcWUu5qLVsbKbW1XBXHwl7fGXUHRc9+ajaXVg7Rh3lMrdPL393v/H
	 G3iilIEcv4M6U9lFI16Yj1hugk55wxkZjFQ0nwgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 55/89] net: dsa: lantiq_gswip: move gswip_add_single_port_br() call to port_setup()
Date: Tue, 30 Sep 2025 16:48:09 +0200
Message-ID: <20250930143824.201924766@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit c0054b25e2f1045f47b4954cf13a539e5e6047df ]

A port added to a "single port bridge" operates as standalone, and this
is mutually exclusive to being part of a Linux bridge. In fact,
gswip_port_bridge_join() calls gswip_add_single_port_br() with
add=false, i.e. removes the port from the "single port bridge" to enable
autonomous forwarding.

The blamed commit seems to have incorrectly thought that ds->ops->port_enable()
is called one time per port, during the setup phase of the switch.

However, it is actually called during the ndo_open() implementation of
DSA user ports, which is to say that this sequence of events:

1. ip link set swp0 down
2. ip link add br0 type bridge
3. ip link set swp0 master br0
4. ip link set swp0 up

would cause swp0 to join back the "single port bridge" which step 3 had
just removed it from.

The correct DSA hook for one-time actions per port at switch init time
is ds->ops->port_setup(). This is what seems to match the coder's
intention; also see the comment at the beginning of the file:

 * At the initialization the driver allocates one bridge table entry for
   ~~~~~~~~~~~~~~~~~~~~~
 * each switch port which is used when the port is used without an
 * explicit bridge.

Fixes: 8206e0ce96b3 ("net: dsa: lantiq: Add VLAN unaware bridge offloading")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250918072142.894692-2-vladimir.oltean@nxp.com
Tested-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/lantiq_gswip.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index fcd4505f49252..497964a5174bf 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -685,18 +685,27 @@ static int gswip_add_single_port_br(struct gswip_priv *priv, int port, bool add)
 	return 0;
 }
 
-static int gswip_port_enable(struct dsa_switch *ds, int port,
-			     struct phy_device *phydev)
+static int gswip_port_setup(struct dsa_switch *ds, int port)
 {
 	struct gswip_priv *priv = ds->priv;
 	int err;
 
 	if (!dsa_is_cpu_port(ds, port)) {
-		u32 mdio_phy = 0;
-
 		err = gswip_add_single_port_br(priv, port, true);
 		if (err)
 			return err;
+	}
+
+	return 0;
+}
+
+static int gswip_port_enable(struct dsa_switch *ds, int port,
+			     struct phy_device *phydev)
+{
+	struct gswip_priv *priv = ds->priv;
+
+	if (!dsa_is_cpu_port(ds, port)) {
+		u32 mdio_phy = 0;
 
 		if (phydev)
 			mdio_phy = phydev->mdio.addr & GSWIP_MDIO_PHY_ADDR_MASK;
@@ -1829,6 +1838,7 @@ static const struct phylink_mac_ops gswip_phylink_mac_ops = {
 static const struct dsa_switch_ops gswip_xrx200_switch_ops = {
 	.get_tag_protocol	= gswip_get_tag_protocol,
 	.setup			= gswip_setup,
+	.port_setup		= gswip_port_setup,
 	.port_enable		= gswip_port_enable,
 	.port_disable		= gswip_port_disable,
 	.port_bridge_join	= gswip_port_bridge_join,
-- 
2.51.0



