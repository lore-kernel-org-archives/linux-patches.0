Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D3B35C1AE;
	Tue, 21 Jul 2026 18:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658621; cv=none; b=DBxYYAti3NShp/h3rOTEM5UPfwMl1szduS1v4y8+0mZpCBDgyUvd2ZnOZ6J6X/Ic7h8T8aZYqEh48PYiFv2H3DQQFVUTRt6oPQxnOqWSszDOVhaQRi8TZcXKY7+JooHDiAUJmAF5rs+ZDxspt//h0CU3R6Uu07Ipo3sM0XOGZ3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658621; c=relaxed/simple;
	bh=/uBmg5Yw0E6pfmAz/vVtmzgsp1YJ+M2KaMwHmDpTVNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1jUFHwcSvLNZLFamIMoxXS2rWhR9LVPKpAbEeo5SAjP+ByqFbm247O4hUq56yovfycrO+g5salbAM+as7s0qDwrI3Q2pryfu1Xa02q+hCnbRxAbMXLCCgMacFZqDe7uJv/xJ3wSf+1x2yL09GYfzXOc2OtnkHCavttpra9toOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdiL+Kpt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdiL+Kpt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBE81F000E9;
	Tue, 21 Jul 2026 18:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658620;
	bh=NBKCatd0nDnhHAlIO7+tZaib8Dvye99bTn5kP9A9DAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EdiL+KptTh9mzRTbxGD2ytXoq9ttg2/IGvEZs7gebGaIKpleLak+C8U5CYGRS53L1
	 C/7sjU8quADq986CacwkxGluPdDSATBVgD0TB7kD0JspqIq0VmkXUN+czedUOC9yf1
	 9aEvoB+W1vUCI6DWRSdI1wJIRhYfQRNyWoBRcceY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 1205/1611] batman-adv: clean untagged VLAN on netdev registration failure
Date: Tue, 21 Jul 2026 17:22:01 +0200
Message-ID: <20260721152542.538457891@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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


