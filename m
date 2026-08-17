Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A6E43CEE9;
	Mon, 17 Aug 2026 13:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974739; cv=none; b=oFLuw9t18BZdgceDOT7+j170lA24T5HAKKrG3FOO7Nhn0GlyEdoQhaF/H094e3+3m2RqvTY4yDyzPqPnlBKiXe1X4QXQIDKwZXwWtpuiNH0OvrpBSSC26gjYbNu0G2X0ZH3lbNqrV+HF75wn/86kms4wp7kOUdUXnBC5kV+/vco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974739; c=relaxed/simple;
	bh=aZNCxVnXYo6oVvjdPOggKU4JgwXFLi6mKOMa0LP5hxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B8Vhf9SLUAtOo1HHF5sqk/5qTnS+IouFPTGVELHm31i+oXfNopIjFhRnJzXOWmHerdJObIKY2pihQClqMoTlnskvE5+k1oFOjoP6IxZtZehYk3PBaj2+LlAAQB/51pBSvCeVyWrLXCphuaiL6fNiBhp7QEBOT+XZV5ZK+c0AFnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+Um3PVD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+Um3PVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3196B1F00A3A;
	Mon, 17 Aug 2026 13:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974729;
	bh=AsBM2ycUC6Iz2RkElIqnkTLVD29sA7DyqleHIiF7hNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0+Um3PVDi0ILuyMMXLkL0XFjF9hHvPPvM80XeDNy5IUv3BuRRN6AG73z1yg3J28s1
	 5f1o3gW2A9J4Fguecz040FexdAQhu8F75wazINMxvF6z4sMsQW7680TSg/FUR+ACiR
	 9z9beUM2pdB3Ot6OVamuFCezR+kjAahIJRfVC5DI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 027/250] ovpn: disable IPv4 redirects on MP interfaces
Date: Mon, 17 Aug 2026 15:29:48 +0200
Message-ID: <20260817132537.566516198@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Quartulli <antonio@openvpn.net>

[ Upstream commit 0301aa324941698bec3dd455df1c5abc7afb10db ]

ovpn_mp_alloc() tried to disable SEND_REDIRECTS on a multipeer
interface, but it runs from ovpn_net_init() (->ndo_init), which
register_netdevice() invokes before the NETDEV_REGISTER notifier
chain. The IPv4 in_device is only created when that notifier reaches
inetdev_event() -> inetdev_init(), so __in_dev_get_rtnl() always
returned NULL at ndo_init time and the whole redirect-disabling block
(both the per-device and the per-netns IPV4_DEVCONF_ALL write) was
dead. MP interfaces therefore kept emitting ICMP redirects.

Disabling redirects only once is not enough either: the IPv4
in_device is destroyed and recreated when the interface is moved to a
different network namespace (NETDEV_UNREGISTER/NETDEV_REGISTER), and
the newly created in_device inherits the destination namespace
defaults, silently re-enabling SEND_REDIRECTS.

Disable redirects from ovpn_net_open() (->ndo_open) instead: it runs
every time the interface is brought up, including after the in_device
has been recreated, so the setting is always re-applied. This mirrors
what wireguard does in wg_open(). RTNL is held on the ndo_open() path,
so __in_dev_get_rtnl() is safe.

Fixes: 05003b408c20 ("ovpn: implement multi-peer support")
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/main.c | 50 ++++++++++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ovpn/main.c b/drivers/net/ovpn/main.c
index 47859e1e3ef12..a3c15fc301d0d 100644
--- a/drivers/net/ovpn/main.c
+++ b/drivers/net/ovpn/main.c
@@ -35,25 +35,11 @@ static void ovpn_priv_free(struct net_device *net)
 
 static int ovpn_mp_alloc(struct ovpn_priv *ovpn)
 {
-	struct in_device *dev_v4;
 	int i;
 
 	if (ovpn->mode != OVPN_MODE_MP)
 		return 0;
 
-	dev_v4 = __in_dev_get_rtnl(ovpn->dev);
-	if (dev_v4) {
-		/* disable redirects as Linux gets confused by ovpn
-		 * handling same-LAN routing.
-		 * This happens because a multipeer interface is used as
-		 * relay point between hosts in the same subnet, while
-		 * in a classic LAN this would not be needed because the
-		 * two hosts would be able to talk directly.
-		 */
-		IN_DEV_CONF_SET(dev_v4, SEND_REDIRECTS, false);
-		IPV4_DEVCONF_ALL(dev_net(ovpn->dev), SEND_REDIRECTS) = false;
-	}
-
 	/* the peer container is fairly large, therefore we allocate it only in
 	 * MP mode
 	 */
@@ -97,9 +83,38 @@ static void ovpn_net_uninit(struct net_device *dev)
 	gro_cells_destroy(&ovpn->gro_cells);
 }
 
+static int ovpn_net_open(struct net_device *dev)
+{
+	struct ovpn_priv *ovpn = netdev_priv(dev);
+	struct in_device *dev_v4;
+
+	/* the IPv4 in_device (and thus its config) is recreated whenever the
+	 * interface is moved to a new netns, so redirects must be disabled on
+	 * every bring-up rather than once at creation time, otherwise the
+	 * setting is silently lost after such a move
+	 */
+	if (ovpn->mode == OVPN_MODE_MP) {
+		dev_v4 = __in_dev_get_rtnl(dev);
+		if (dev_v4) {
+			/* disable redirects as Linux gets confused by ovpn
+			 * handling same-LAN routing.
+			 * This happens because a multipeer interface is used as
+			 * relay point between hosts in the same subnet, while
+			 * in a classic LAN this would not be needed because the
+			 * two hosts would be able to talk directly.
+			 */
+			IN_DEV_CONF_SET(dev_v4, SEND_REDIRECTS, false);
+			IPV4_DEVCONF_ALL(dev_net(dev), SEND_REDIRECTS) = false;
+		}
+	}
+
+	return 0;
+}
+
 static const struct net_device_ops ovpn_netdev_ops = {
 	.ndo_init		= ovpn_net_init,
 	.ndo_uninit		= ovpn_net_uninit,
+	.ndo_open		= ovpn_net_open,
 	.ndo_start_xmit		= ovpn_net_xmit,
 };
 
@@ -183,6 +198,7 @@ static int ovpn_newlink(struct net_device *dev,
 	struct ovpn_priv *ovpn = netdev_priv(dev);
 	struct nlattr **data = params->data;
 	enum ovpn_mode mode = OVPN_MODE_P2P;
+	int ret;
 
 	if (data && data[IFLA_OVPN_MODE]) {
 		mode = nla_get_u8(data[IFLA_OVPN_MODE]);
@@ -207,7 +223,11 @@ static int ovpn_newlink(struct net_device *dev,
 	else
 		netif_carrier_off(dev);
 
-	return register_netdevice(dev);
+	ret = register_netdevice(dev);
+	if (ret < 0)
+		return ret;
+
+	return 0;
 }
 
 static size_t ovpn_get_size(const struct net_device *dev)
-- 
2.53.0



