Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2E63B71A0;
	Tue, 21 Jul 2026 21:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670448; cv=none; b=EKYNsJUoalOPNefJX4LjMv0gNIx+yqLsF8GXL+oJoZzk18FHXSQNb45AAdPZdbfeqM8tHBA+s2s0UNLe5i9lb4zIXGozXvGRQKU0QGmaeBJTTutOQjSuERxDRel6TKQ0iG7wfeqjKWS0Td0azJ+ur3o+rG8q/uBcdWXqY8KurLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670448; c=relaxed/simple;
	bh=C1eUQaAwVv3pWuqKuCziCb09yZbUa01lgrfD/Fk4N3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMwVghq07RfrJ12lu1a1yju5dfceZvaGbgUAVTKnFqP28MUFXoq7tiAliXjZ4IgPJzq5xxzidT8VDAgPab1LIpYbgx0of1ATWUstnk5G/ockJ3L4wAFtiCXi+L6h+Xpt8jZq3+Yt8kxZhAsSIwsScFRQP9GUR79XT3Qk6ckmHQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i37YbHtx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i37YbHtx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A296F1F000E9;
	Tue, 21 Jul 2026 21:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670447;
	bh=L/a7QKJxPFxHZ513lGu/3p2lRvW88KD3zTTRhMd3XqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i37YbHtxjcYViq71WvMl1dNffZIfuLKoPl5kxyu8H2S0hT8AIWVLfm4u1yQyXU4za
	 71ZP+kE5bvVpVKTkaAk3THoJm8mbTXqxtJggkXgLk9iYH4NbpTpPSQJbMgKKxTsiln
	 K3GC12xUaEQZ/KbWMHR7+sQICk8tRBT55Bj2Vvg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0892/1067] batman-adv: clean untagged VLAN on netdev registration failure
Date: Tue, 21 Jul 2026 17:24:53 +0200
Message-ID: <20260721152444.486210561@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 8669a550c752d86baebc5fdc83b8ff35c4372c0e upstream.

When an mesh interface is registered, it creates an untagged struct
batadv_meshif_vlan on top of it via the NETDEV_REGISTER notifier. But in
this process, another receiver of this notification can veto the
registration. The netdev registration will be aborted because of this veto.

The register_netdevice() call will try to clean up the net_device using
unregister_netdevice_queue() - which only uses the .priv_destructor to
free private resources. In this situation, .dellink will not be called.

The cleanup of the untagged batadv_meshif_vlan must thefore be done in the
destructor to avoid a leak of this object.

Cc: stable@vger.kernel.org
Fixes: 5d2c05b21337 ("batman-adv: add per VLAN interface attribute framework")
[ switch to old "mesh_iface" name "soft_iface" ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/main.c           |  8 ++++++++
 net/batman-adv/soft-interface.c | 13 ++-----------
 net/batman-adv/soft-interface.h |  2 ++
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/net/batman-adv/main.c b/net/batman-adv/main.c
index 28f616b8891a12..417de98c39a7be 100644
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -258,6 +258,7 @@ int batadv_mesh_init(struct net_device *soft_iface)
 void batadv_mesh_free(struct net_device *soft_iface)
 {
 	struct batadv_priv *bat_priv = netdev_priv(soft_iface);
+	struct batadv_softif_vlan *vlan;
 
 	atomic_set(&bat_priv->mesh_state, BATADV_MESH_DEACTIVATING);
 
@@ -273,6 +274,13 @@ void batadv_mesh_free(struct net_device *soft_iface)
 
 	batadv_mcast_free(bat_priv);
 
+	/* destroy the "untagged" VLAN */
+	vlan = batadv_softif_vlan_get(bat_priv, BATADV_NO_FLAGS);
+	if (vlan) {
+		batadv_softif_destroy_vlan(bat_priv, vlan);
+		batadv_softif_vlan_put(vlan);
+	}
+
 	/* Free the TT and the originator tables only after having terminated
 	 * all the other depending components which may use these structures for
 	 * their purposes.
diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index a8239902b4428c..57962ed4285b3f 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -605,8 +605,8 @@ int batadv_softif_create_vlan(struct batadv_priv *bat_priv, unsigned short vid)
  * @bat_priv: the bat priv with all the soft interface information
  * @vlan: the object to remove
  */
-static void batadv_softif_destroy_vlan(struct batadv_priv *bat_priv,
-				       struct batadv_softif_vlan *vlan)
+void batadv_softif_destroy_vlan(struct batadv_priv *bat_priv,
+				struct batadv_softif_vlan *vlan)
 {
 	/* explicitly remove the associated TT local entry because it is marked
 	 * with the NOPURGE flag
@@ -1088,22 +1088,13 @@ static int batadv_softif_newlink(struct net *src_net, struct net_device *dev,
 static void batadv_softif_destroy_netlink(struct net_device *soft_iface,
 					  struct list_head *head)
 {
-	struct batadv_priv *bat_priv = netdev_priv(soft_iface);
 	struct batadv_hard_iface *hard_iface;
-	struct batadv_softif_vlan *vlan;
 
 	list_for_each_entry(hard_iface, &batadv_hardif_list, list) {
 		if (hard_iface->soft_iface == soft_iface)
 			batadv_hardif_disable_interface(hard_iface);
 	}
 
-	/* destroy the "untagged" VLAN */
-	vlan = batadv_softif_vlan_get(bat_priv, BATADV_NO_FLAGS);
-	if (vlan) {
-		batadv_softif_destroy_vlan(bat_priv, vlan);
-		batadv_softif_vlan_put(vlan);
-	}
-
 	unregister_netdevice_queue(soft_iface, head);
 }
 
diff --git a/net/batman-adv/soft-interface.h b/net/batman-adv/soft-interface.h
index 9f2003f1a4972e..13709a5d23e3bf 100644
--- a/net/batman-adv/soft-interface.h
+++ b/net/batman-adv/soft-interface.h
@@ -22,6 +22,8 @@ void batadv_interface_rx(struct net_device *soft_iface,
 bool batadv_softif_is_valid(const struct net_device *net_dev);
 extern struct rtnl_link_ops batadv_link_ops;
 int batadv_softif_create_vlan(struct batadv_priv *bat_priv, unsigned short vid);
+void batadv_softif_destroy_vlan(struct batadv_priv *bat_priv,
+				struct batadv_softif_vlan *vlan);
 void batadv_softif_vlan_release(struct kref *ref);
 struct batadv_softif_vlan *batadv_softif_vlan_get(struct batadv_priv *bat_priv,
 						  unsigned short vid);
-- 
2.53.0



