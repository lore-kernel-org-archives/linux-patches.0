Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900B53EDE79;
	Tue, 21 Jul 2026 17:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654294; cv=none; b=UOm9NgKLbObhRWtvNnFXORolkW67fDX2iJXaMXLXfVQT49tzSid2D2zr5ai/Q3TiWB1euOt7PAU7C+4QDMKlY5y9F23N+O88w/mpwJ+m1znga1dG3eLzcXOd8PRTegx5aUJZJLf/6z7qA6FWExkjzkZs8zrHSKMmXcLS15AHEWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654294; c=relaxed/simple;
	bh=m7N35N3apB81opy4hVWODQI/b8RbZwrOWVKvGDqSyu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NsokjczlpRlp0ofec/GQ8uRM2QRAWpWjOlC1jyiANU9wa9+CgwzjR7hvxgtNNJxNhB9AgH5mIDwOoTFm18YInM5OFLEUP395VLZCohGtlTyT107JAZ4NAENcNi48zATyv0DycJUKCG8Z4ILUGOtdgqXYdBlTcELWX08NuOOcQrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ARenxp8e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ARenxp8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A111F000E9;
	Tue, 21 Jul 2026 17:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654293;
	bh=ifhB2290RdlQmphOJXmP2HBNLY9migKccTLS7RYaC60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ARenxp8ehTbuyRFm6CM/l6MxKgUrwooBuvpmn35QPt6uYH5D7nWiJVoNepLEvK25L
	 bnBgirLUYsLfB4cGuLpm21wd0ngIU5pLTmCt+MqHsq3jj9UPWQOt34G/n1LXdGYCIz
	 lNxx+yU8JW2maWZp81jxT/3rv/myfq/43SkmYTMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.1 1649/2077] batman-adv: clean untagged VLAN on netdev registration failure
Date: Tue, 21 Jul 2026 17:22:02 +0200
Message-ID: <20260721152631.642686921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/main.c           |    8 ++++++++
 net/batman-adv/mesh-interface.c |   13 ++-----------
 net/batman-adv/mesh-interface.h |    2 ++
 3 files changed, 12 insertions(+), 11 deletions(-)

--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -245,6 +245,7 @@ err_orig:
 void batadv_mesh_free(struct net_device *mesh_iface)
 {
 	struct batadv_priv *bat_priv = netdev_priv(mesh_iface);
+	struct batadv_meshif_vlan *vlan;
 
 	atomic_set(&bat_priv->mesh_state, BATADV_MESH_DEACTIVATING);
 
@@ -259,6 +260,13 @@ void batadv_mesh_free(struct net_device
 
 	batadv_mcast_free(bat_priv);
 
+	/* destroy the "untagged" VLAN */
+	vlan = batadv_meshif_vlan_get(bat_priv, BATADV_NO_FLAGS);
+	if (vlan) {
+		batadv_meshif_destroy_vlan(bat_priv, vlan);
+		batadv_meshif_vlan_put(vlan);
+	}
+
 	/* Free the TT and the originator tables only after having terminated
 	 * all the other depending components which may use these structures for
 	 * their purposes.
--- a/net/batman-adv/mesh-interface.c
+++ b/net/batman-adv/mesh-interface.c
@@ -593,8 +593,8 @@ int batadv_meshif_create_vlan(struct bat
  * @bat_priv: the bat priv with all the mesh interface information
  * @vlan: the object to remove
  */
-static void batadv_meshif_destroy_vlan(struct batadv_priv *bat_priv,
-				       struct batadv_meshif_vlan *vlan)
+void batadv_meshif_destroy_vlan(struct batadv_priv *bat_priv,
+				struct batadv_meshif_vlan *vlan)
 {
 	/* explicitly remove the associated TT local entry because it is marked
 	 * with the NOPURGE flag
@@ -1089,22 +1089,13 @@ static int batadv_meshif_newlink(struct
 static void batadv_meshif_destroy_netlink(struct net_device *mesh_iface,
 					  struct list_head *head)
 {
-	struct batadv_priv *bat_priv = netdev_priv(mesh_iface);
 	struct batadv_hard_iface *hard_iface;
-	struct batadv_meshif_vlan *vlan;
 
 	while (!list_empty(&mesh_iface->adj_list.lower)) {
 		hard_iface = netdev_adjacent_get_private(mesh_iface->adj_list.lower.next);
 		batadv_hardif_disable_interface(hard_iface);
 	}
 
-	/* destroy the "untagged" VLAN */
-	vlan = batadv_meshif_vlan_get(bat_priv, BATADV_NO_FLAGS);
-	if (vlan) {
-		batadv_meshif_destroy_vlan(bat_priv, vlan);
-		batadv_meshif_vlan_put(vlan);
-	}
-
 	unregister_netdevice_queue(mesh_iface, head);
 }
 
--- a/net/batman-adv/mesh-interface.h
+++ b/net/batman-adv/mesh-interface.h
@@ -21,6 +21,8 @@ void batadv_interface_rx(struct net_devi
 bool batadv_meshif_is_valid(const struct net_device *net_dev);
 extern struct rtnl_link_ops batadv_link_ops;
 int batadv_meshif_create_vlan(struct batadv_priv *bat_priv, unsigned short vid);
+void batadv_meshif_destroy_vlan(struct batadv_priv *bat_priv,
+				struct batadv_meshif_vlan *vlan);
 void batadv_meshif_vlan_release(struct kref *ref);
 struct batadv_meshif_vlan *batadv_meshif_vlan_get(struct batadv_priv *bat_priv,
 						  unsigned short vid);


