Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B416472553;
	Tue, 21 Jul 2026 20:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664198; cv=none; b=J7uWQV+kFKswD9/ksPWCyFcEKnHW6eYaIM92W6gqkzSMujngVLPj4TeXK4/kqf9LqipcsBs+1wH7K94N3gfiTz2beurFm2ViwxoKkWuefSeeEAwvf1eJGQFw0URCJ2JPvogGc6+Djrs6X4OvMoRf9Ki3Wz1HhNr/pWumuesWPXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664198; c=relaxed/simple;
	bh=ff9zqizpBHp9FfRv12bji5ol2IVU7HFigpqDvwCL9aI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NFkM53NbpVjWGkws3foglvYTnrvfcUNM8Lz+qQj3ceoovTn83HzQVR4ie/OKvh0wzzkGwwhIt7+xb825HwA5YYfWZryhXrvD2Qe1EURXrwjhtHP4UX/M9eiqTYEEwb6/M+LGDH/5XbHpGMiBlf+FmEp2aTkPdAbLaV4pT+VyJIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YcwxEUQd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YcwxEUQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D119D1F000E9;
	Tue, 21 Jul 2026 20:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664194;
	bh=F+98DMHViV2WJZa4taQ1bYhlQCrvICUONq7+vgL0M2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YcwxEUQdftGapCRwGmrRRPjgAED16/pdd7ueiPT/XraDrSTU3mbGjRhLCfmHU+XJ8
	 G/0GczDKVeL1UUmhQyfQ/2iIHdRHydebf4y/r3hWojJ1v/yFq46CxtUfAhfYNfrLiY
	 8wb2WzM+t6DcyJDcgWfQ0ipr1yHInHPppse2ZUhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1065/1276] batman-adv: clean untagged VLAN on netdev registration failure
Date: Tue, 21 Jul 2026 17:25:08 +0200
Message-ID: <20260721152509.819438937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
 net/batman-adv/main.c           |    8 ++++++++
 net/batman-adv/soft-interface.c |   13 ++-----------
 net/batman-adv/soft-interface.h |    2 ++
 3 files changed, 12 insertions(+), 11 deletions(-)

--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -259,6 +259,7 @@ err_orig:
 void batadv_mesh_free(struct net_device *soft_iface)
 {
 	struct batadv_priv *bat_priv = netdev_priv(soft_iface);
+	struct batadv_softif_vlan *vlan;
 
 	atomic_set(&bat_priv->mesh_state, BATADV_MESH_DEACTIVATING);
 
@@ -274,6 +275,13 @@ void batadv_mesh_free(struct net_device
 
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
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -606,8 +606,8 @@ int batadv_softif_create_vlan(struct bat
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
@@ -1103,22 +1103,13 @@ static int batadv_softif_newlink(struct
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
 
--- a/net/batman-adv/soft-interface.h
+++ b/net/batman-adv/soft-interface.h
@@ -22,6 +22,8 @@ void batadv_interface_rx(struct net_devi
 bool batadv_softif_is_valid(const struct net_device *net_dev);
 extern struct rtnl_link_ops batadv_link_ops;
 int batadv_softif_create_vlan(struct batadv_priv *bat_priv, unsigned short vid);
+void batadv_softif_destroy_vlan(struct batadv_priv *bat_priv,
+				struct batadv_softif_vlan *vlan);
 void batadv_softif_vlan_release(struct kref *ref);
 struct batadv_softif_vlan *batadv_softif_vlan_get(struct batadv_priv *bat_priv,
 						  unsigned short vid);


