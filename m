Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E7E32A3FF;
	Thu, 28 May 2026 20:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000052; cv=none; b=jIu4Et+ZwwAmTcr/cE8Km/jegngOkahyPiHj9ub5QfWUrGUJkW8lS8T+A37Bkqn9omTy/vPeUbkFVaQAGsSESdRnAJOpnGMZvh326e3ZQqsN16BfRKWRHn6cNaP/Vioqra9CVJWSz4BpFXMhi+Ngfx9yylTwunzccp6BM+qOBIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000052; c=relaxed/simple;
	bh=6oC/0yoCxSFpl0jG8K94hzwuW1u2xJf+7QCe9kWEkx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=liP48h+rQThPyxmn01PK5yazIXaqsG/Kvucv2NHwkuV9sLgaUclDn+NKceKmxVrrOVeY+UQgaCFgu9pgv6RILnM9q+BtlDdUKlw/TLtujFJJw0l/lcP+PLB2mFW3O70qcyAsBtg8EpSKLmSB/jivXctGwUYmLZH4fSWU87ZkPIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kDfrRKZf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kDfrRKZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9291F00ADE;
	Thu, 28 May 2026 20:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000051;
	bh=vueji10p+Up9QLbNCYafMpKKO3EVdwfk9OF8yzuw13A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kDfrRKZfp9nAD1SwqIQx2WhBR1XzsNytOUq6MOFyOHJQcOhoQVDJ9PHJDAl0C/V1s
	 L22GYMtsHgMwxY5GYytQMzfniYpSN4gipmUrjnlKfXkwvkJB1RXMBU/PinRbCfV2Xh
	 4b22zmWSVyuYLhDKeRTXy83KRoMkauThQtCGDHqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 286/377] ovpn: fix race between deleting interface and adding new peer
Date: Thu, 28 May 2026 21:48:44 +0200
Message-ID: <20260528194646.633525718@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

[ Upstream commit 982422b11e6f95f766a8cd2c2b1cbdb77e234a61 ]

While deleting an existing ovpn interface, there is a very
narrow window where adding a new peer via netlink may cause
the netdevice to hang and prevent its unregistration.

It may happen during ovpn_dellink(), when all existing peers are
freed and the device is queued for deregistration, but a
CMD_PEER_NEW message comes in adding a new peer that takes again
a reference to the netdev.

At this point there is no way to release the device because we are
under the assumption that all peers were already released.

Fix the race condition by releasing all peers in ndo_uninit(),
when the netdevice has already been removed from the netdev
list.

Also ovpn_peer_add() has now an extra check that forces the
function to bail out if the device reg_state is not REGISTERED.
This way any incoming CMD_PEER_NEW racing with the interface
deletion routine will simply stop before adding the peer.

Note that the above check happens while holding the netdev_lock
to prevent racing netdev state changes.

ovpn_dellink() is now empty and can be removed.

Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Closes: https://lore.kernel.org/netdev/aaVgJ16edTfQkYbx@v4bel/
Suggested-by: Sabrina Dubroca <sd@queasysnail.net>
Fixes: 80747caef33d ("ovpn: introduce the ovpn_peer object")
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/main.c | 12 ++----------
 drivers/net/ovpn/peer.c | 21 ++++++++++++++++++---
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ovpn/main.c b/drivers/net/ovpn/main.c
index 1bb1afe766a41..3f76b1b0e5f60 100644
--- a/drivers/net/ovpn/main.c
+++ b/drivers/net/ovpn/main.c
@@ -92,6 +92,8 @@ static void ovpn_net_uninit(struct net_device *dev)
 {
 	struct ovpn_priv *ovpn = netdev_priv(dev);
 
+	disable_delayed_work_sync(&ovpn->keepalive_work);
+	ovpn_peers_free(ovpn, NULL, OVPN_DEL_PEER_REASON_TEARDOWN);
 	gro_cells_destroy(&ovpn->gro_cells);
 }
 
@@ -208,15 +210,6 @@ static int ovpn_newlink(struct net_device *dev,
 	return register_netdevice(dev);
 }
 
-static void ovpn_dellink(struct net_device *dev, struct list_head *head)
-{
-	struct ovpn_priv *ovpn = netdev_priv(dev);
-
-	cancel_delayed_work_sync(&ovpn->keepalive_work);
-	ovpn_peers_free(ovpn, NULL, OVPN_DEL_PEER_REASON_TEARDOWN);
-	unregister_netdevice_queue(dev, head);
-}
-
 static int ovpn_fill_info(struct sk_buff *skb, const struct net_device *dev)
 {
 	struct ovpn_priv *ovpn = netdev_priv(dev);
@@ -235,7 +228,6 @@ static struct rtnl_link_ops ovpn_link_ops = {
 	.policy = ovpn_policy,
 	.maxtype = IFLA_OVPN_MAX,
 	.newlink = ovpn_newlink,
-	.dellink = ovpn_dellink,
 	.fill_info = ovpn_fill_info,
 };
 
diff --git a/drivers/net/ovpn/peer.c b/drivers/net/ovpn/peer.c
index a3d856724b84a..87a83321f1dd5 100644
--- a/drivers/net/ovpn/peer.c
+++ b/drivers/net/ovpn/peer.c
@@ -1029,14 +1029,29 @@ static int ovpn_peer_add_p2p(struct ovpn_priv *ovpn, struct ovpn_peer *peer)
  */
 int ovpn_peer_add(struct ovpn_priv *ovpn, struct ovpn_peer *peer)
 {
+	int ret = -ENODEV;
+
+	/* Prevent adding new peers while destroying the ovpn interface.
+	 * Failing to do so would end up holding the device reference
+	 * endlessly hostage of the new peer object with no chance of
+	 * release..
+	 */
+	netdev_lock(ovpn->dev);
+	if (ovpn->dev->reg_state != NETREG_REGISTERED)
+		goto out;
+
 	switch (ovpn->mode) {
 	case OVPN_MODE_MP:
-		return ovpn_peer_add_mp(ovpn, peer);
+		ret = ovpn_peer_add_mp(ovpn, peer);
+		break;
 	case OVPN_MODE_P2P:
-		return ovpn_peer_add_p2p(ovpn, peer);
+		ret = ovpn_peer_add_p2p(ovpn, peer);
+		break;
 	}
+out:
+	netdev_unlock(ovpn->dev);
 
-	return -EOPNOTSUPP;
+	return ret;
 }
 
 /**
-- 
2.53.0



