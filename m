Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA677342509
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301261; cv=none; b=sgDhWNuwBErKcXtub/7XDrS7N+k+4JLWu3kpx0pDYUaXvdiRMmqmweQRtqoEl+Y8xA7zQSYxdUzOhGN30IsjVHkRa5IQ74B5UiUtmTTpOIGOwrK97wXAqIanYviFc2tRJHjqqJ2w0v6E4EQLcr4WTunVGv3V739SfcjOc7K3zvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301261; c=relaxed/simple;
	bh=nJuoFNdtz9UpPUZWU4GmgJmXBMr3YKzyWljH3DGXy6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2i7BjRzj5o1cLbQ0cyp4HCtTLW+epdMIR1ROb416v5X3ng9EpkK7A76vp09MOH9ooea7nJwMDYqNeEvw23ZNKoZKypRANBJUfNKyeGgRdQx1+s1aDn7xLBXIOn2km7JJVX7uHei3fiL6te/547MbiFHMmfbragmUHbWCiMe/JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AeFJf0aN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AeFJf0aN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39A5C19423;
	Sat, 28 Feb 2026 17:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301261;
	bh=nJuoFNdtz9UpPUZWU4GmgJmXBMr3YKzyWljH3DGXy6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AeFJf0aNffMnerN48EOxMfwlWPI4uLHmPbf1ekzzTF1Son/Z8gOrm+JLUVOfHwM+8
	 YkkqBtd5OkaqSmQtU3Wz5iPGleWC9QJ7U003daAkjjcZFnRoYYVmRpUo7LFLuK2g/W
	 bIYIfDk/EhKl7XxypYghoKwmFCiBqWdPD+hhhY+3I5g8FOmRyHbX1FJJimftU/0C43
	 AApG+nnVJebl0iPOkZB3G4NFwsNVelqALUoRIYU54vBeBSl1dJ9ihnwsBYEXrn5INv
	 /C2+6MddOjiubBY7Q7IExYB7+XLowuCwHBHlwqRm6nTsDUtju66n6nrWDdvb7cn5l1
	 5OmQIhwWTnA3Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hangbin Liu <liuhangbin@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 445/752] team: use common function to compute the features
Date: Sat, 28 Feb 2026 12:42:36 -0500
Message-ID: <20260228174750.1542406-445-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 745cd46c2a47144dd656185b9be0a1e5e9b02d2d ]

Use the new helper netdev_compute_master_upper_features() to compute the
team device features. This helper performs both the feature computation
and the netdev_change_features() call.

Note that such change replace the lower layer traversing currently done
using team->port_list with netdev_for_each_lower_dev(). Such change is
safe as `port_list` contains exactly the same elements as
`team->dev->adj_list.lower` and the helper is always invoked under the
RTNL lock.

With this change, the explicit netdev_change_features() in team_add_slave()
can be safely removed, as team_port_add() already takes care of the
notification via netdev_compute_master_upper_features(), and same thing for
team_del_slave()

This also fixes missing computations for MPLS, XFRM, and TSO/GSO partial
features.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://patch.msgid.link/20251017034155.61990-4-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: bb4c698633c0 ("team: avoid NETDEV_CHANGEMTU event when unregistering slave")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team_core.c | 83 +++---------------------------------
 1 file changed, 6 insertions(+), 77 deletions(-)

diff --git a/drivers/net/team/team_core.c b/drivers/net/team/team_core.c
index 2fd3469d10464..d5da2f0774637 100644
--- a/drivers/net/team/team_core.c
+++ b/drivers/net/team/team_core.c
@@ -982,63 +982,6 @@ static void team_port_disable(struct team *team,
 	team_lower_state_changed(port);
 }
 
-#define TEAM_VLAN_FEATURES (NETIF_F_HW_CSUM | NETIF_F_SG | \
-			    NETIF_F_FRAGLIST | NETIF_F_GSO_SOFTWARE | \
-			    NETIF_F_HIGHDMA | NETIF_F_LRO | \
-			    NETIF_F_GSO_ENCAP_ALL)
-
-#define TEAM_ENC_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
-				 NETIF_F_RXCSUM | NETIF_F_GSO_SOFTWARE)
-
-static void __team_compute_features(struct team *team)
-{
-	struct team_port *port;
-	netdev_features_t vlan_features = TEAM_VLAN_FEATURES;
-	netdev_features_t enc_features  = TEAM_ENC_FEATURES;
-	unsigned short max_hard_header_len = ETH_HLEN;
-	unsigned int dst_release_flag = IFF_XMIT_DST_RELEASE |
-					IFF_XMIT_DST_RELEASE_PERM;
-
-	rcu_read_lock();
-	if (list_empty(&team->port_list))
-		goto done;
-
-	vlan_features = netdev_base_features(vlan_features);
-	enc_features = netdev_base_features(enc_features);
-
-	list_for_each_entry_rcu(port, &team->port_list, list) {
-		vlan_features = netdev_increment_features(vlan_features,
-					port->dev->vlan_features,
-					TEAM_VLAN_FEATURES);
-		enc_features =
-			netdev_increment_features(enc_features,
-						  port->dev->hw_enc_features,
-						  TEAM_ENC_FEATURES);
-
-		dst_release_flag &= port->dev->priv_flags;
-		if (port->dev->hard_header_len > max_hard_header_len)
-			max_hard_header_len = port->dev->hard_header_len;
-	}
-done:
-	rcu_read_unlock();
-
-	team->dev->vlan_features = vlan_features;
-	team->dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL |
-				     NETIF_F_HW_VLAN_CTAG_TX |
-				     NETIF_F_HW_VLAN_STAG_TX;
-	team->dev->hard_header_len = max_hard_header_len;
-
-	team->dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
-	if (dst_release_flag == (IFF_XMIT_DST_RELEASE | IFF_XMIT_DST_RELEASE_PERM))
-		team->dev->priv_flags |= IFF_XMIT_DST_RELEASE;
-}
-
-static void team_compute_features(struct team *team)
-{
-	__team_compute_features(team);
-	netdev_change_features(team->dev);
-}
-
 static int team_port_enter(struct team *team, struct team_port *port)
 {
 	int err = 0;
@@ -1306,7 +1249,7 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 	port->index = -1;
 	list_add_tail_rcu(&port->list, &team->port_list);
 	team_port_enable(team, port);
-	__team_compute_features(team);
+	netdev_compute_master_upper_features(team->dev, true);
 	__team_port_change_port_added(port, !!netif_oper_up(port_dev));
 	__team_options_change_check(team);
 
@@ -1389,7 +1332,7 @@ static int team_port_del(struct team *team, struct net_device *port_dev)
 	dev_set_mtu(port_dev, port->orig.mtu);
 	kfree_rcu(port, rcu);
 	netdev_info(dev, "Port device %s removed\n", portname);
-	__team_compute_features(team);
+	netdev_compute_master_upper_features(team->dev, true);
 
 	return 0;
 }
@@ -1977,33 +1920,19 @@ static int team_add_slave(struct net_device *dev, struct net_device *port_dev,
 			  struct netlink_ext_ack *extack)
 {
 	struct team *team = netdev_priv(dev);
-	int err;
 
 	ASSERT_RTNL();
 
-	err = team_port_add(team, port_dev, extack);
-
-	if (!err)
-		netdev_change_features(dev);
-
-	return err;
+	return team_port_add(team, port_dev, extack);
 }
 
 static int team_del_slave(struct net_device *dev, struct net_device *port_dev)
 {
 	struct team *team = netdev_priv(dev);
-	int err;
 
 	ASSERT_RTNL();
 
-	err = team_port_del(team, port_dev);
-
-	if (err)
-		return err;
-
-	netdev_change_features(dev);
-
-	return err;
+	return team_port_del(team, port_dev);
 }
 
 static netdev_features_t team_fix_features(struct net_device *dev,
@@ -2197,7 +2126,7 @@ static void team_setup(struct net_device *dev)
 
 	dev->features |= NETIF_F_GRO;
 
-	dev->hw_features = TEAM_VLAN_FEATURES |
+	dev->hw_features = MASTER_UPPER_DEV_VLAN_FEATURES |
 			   NETIF_F_HW_VLAN_CTAG_RX |
 			   NETIF_F_HW_VLAN_CTAG_FILTER |
 			   NETIF_F_HW_VLAN_STAG_RX |
@@ -3001,7 +2930,7 @@ static int team_device_event(struct notifier_block *unused,
 	case NETDEV_FEAT_CHANGE:
 		if (!port->team->notifier_ctx) {
 			port->team->notifier_ctx = true;
-			team_compute_features(port->team);
+			netdev_compute_master_upper_features(port->team->dev, true);
 			port->team->notifier_ctx = false;
 		}
 		break;
-- 
2.51.0

