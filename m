Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F3C3F9A0B;
	Mon, 17 Aug 2026 13:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973939; cv=none; b=Wff7efw/jPudtozPM8zd8M8nn4/duj1pbhq19o7FMuWpDBJyaxhmaKc3n3mK1ebmz9K+ClKm23zwkSTvT24qduIKKMEHI9nvdB/rBwEZ+3Ry4atFSUbQAJXGLnMZpLiUh5PDkPGf9LrN1nxNIV+2WlM0Ql6lhnyG/ObZUBzo1uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973939; c=relaxed/simple;
	bh=6KaTBJxuyuEpx84z/AlArqt1d1+KTDq/JC1wYcE2TYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f22h70ikuTHHUwDykgkfHLMr1fwrLqbY/bm7jidAbi1E2r2DKpRiHRoBnGP1TURwqAphFkiWDneeEaPbVUoQFWSps3D5EeHgb2F7k/UhpIeWK3Cx8iZLvI4zQ2tckIUfARunb0L13hm/tC4ZnEj+6rpibJc6LkRuFkCNOGGOOs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fAFD9s6S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fAFD9s6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9631F000E9;
	Mon, 17 Aug 2026 13:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973937;
	bh=Il3fppaXU+NDOPl2OMVgncSj0EAkAtcGdUlCuJ3Ktw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fAFD9s6SYFMpbF5sFuXnueFduqLka3m6uhuBjQvcXEAx+sxJOg4ZXAfA1dT7ARIp6
	 R4/WMSS0ShCiwyJv1/wHjYIm6ixsWOHxKPW1dWz29Sa5GETUt8JBP1C+osos0qV+Ig
	 lM7VC6Z9ctkbw+R7R+MN1zkSaL1qE49sw+qy44/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 032/271] ovpn: disable IPv4 redirects on MP interfaces
Date: Mon, 17 Aug 2026 15:29:17 +0200
Message-ID: <20260817132538.071415123@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9d9a0ff690d66..3a04757d5c31e 100644
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



