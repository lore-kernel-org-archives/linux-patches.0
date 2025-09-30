Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A88307AD2;
	Tue, 30 Sep 2025 15:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245315; cv=none; b=a5/WGCuq5p/auU69r2Fs6MlshZzwOHSzNxHQKGjxDYEpKlVUNnP0KVhUQ22dlr77ULj/0XKKzl/pWVywTibN9rhrSrlpvE9SPg576OJoKLrVkOpxdcf/xcRJMaJrc3B9JmILpb+iThfll0rEJEQrSWc7zYElIKVOBFV/GYsNIXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245315; c=relaxed/simple;
	bh=dKtb9YfC1+5H5VOdlizcardYxO77Ohdq/S1yHrPXESc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5wkb/bgcfSqC5nutmVrAUkNEyoyNirpt1dTrT023jBy199DYBGNu2Mc4N9pMVm1CVGQxaCNp41WGWphwc/6vcT9LlPP/ycagZki8pHnbG7SpgQSN4F5xt6TqVk6IYIEf32WZkjNf/wQQwyY/TEvR3onmIRgVy0HKbOa/0LHkHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vn6djIUg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vn6djIUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A5AC113D0;
	Tue, 30 Sep 2025 15:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245315;
	bh=dKtb9YfC1+5H5VOdlizcardYxO77Ohdq/S1yHrPXESc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vn6djIUgY9WaWOC6R5CGINArlBjq5P6FjfKcJzhDolTIabeU7girsZ6CMusTzRPXr
	 hQ7zs1V21oUimSn2cXNvlxAjM/J/ejr+LGY7pRGA35jWZiuIp4zfmnNgLxNpgLgytH
	 QbjCZ7SMtYJLi9cYRD+LKeYD9PgYEPm5XzlVTJ4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/151] net: dsa: lantiq_gswip: move gswip_add_single_port_br() call to port_setup()
Date: Tue, 30 Sep 2025 16:47:43 +0200
Message-ID: <20250930143832.897933137@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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
index f1ed7fff23e27..97d88c25fc992 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -655,18 +655,27 @@ static int gswip_add_single_port_br(struct gswip_priv *priv, int port, bool add)
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
@@ -1794,6 +1803,7 @@ static int gswip_get_sset_count(struct dsa_switch *ds, int port, int sset)
 static const struct dsa_switch_ops gswip_xrx200_switch_ops = {
 	.get_tag_protocol	= gswip_get_tag_protocol,
 	.setup			= gswip_setup,
+	.port_setup		= gswip_port_setup,
 	.port_enable		= gswip_port_enable,
 	.port_disable		= gswip_port_disable,
 	.port_bridge_join	= gswip_port_bridge_join,
-- 
2.51.0



