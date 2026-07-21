Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779DB39733E;
	Tue, 21 Jul 2026 22:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674544; cv=none; b=FsaEoRsKC7ob+hCyeAfc+ZrLzhrsby3xoPWtxb83PAib7fr7heOUvZwV+5ZLGPmChSx/tGpLIFM3W7qPnbkPpJN7uy3DTEI4ZQHSs91+Bbd+VLju6WCUyGQvaS/j3ywRthNo52CVZ/2jZ1ZPBWHRRIG7Vxu3MstredfBWc4c7WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674544; c=relaxed/simple;
	bh=/z6Ic6GmKEIB4FDIHJpiCPqoZo7yvUD4AEdi21ngcUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2M6Ie3mc2Ih8zlASAv436AEsr1aviU3jzW+pQXQb8tDjySVAL9rWMc0eltW/KFCI0SGrD0veOlLdjHRjRXEsO/JB/unGSP19wOSiedQKZ1Pk5EszeXmkHzjIrDKboLR0ruVV1NgmHFtI+vDsF9xF0UovP0JNVWDEfxYPRm73n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cZf3Othx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZf3Othx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF44A1F000E9;
	Tue, 21 Jul 2026 22:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674543;
	bh=rbbemDJiCGz6qvNygWOsnGsamdNC0mUi0Zkgk/I0biY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cZf3OthxcSmrLV2bv1PXYEd69ZLPSaE72V840owSHCgQwLCb4mAVS6it5z7hCfkNY
	 4hxIS9PLsTf5pmmA+CCi7LhW+YXeAi/K32XDKujJ1mXETeqXEWC8SKvJ3fP5qQzKxu
	 WnjpiLNzQ3TAB4npnS/wSC1hX6wzmpfFDCsOe6nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.10 580/699] batman-adv: clean untagged VLAN on netdev registration failure
Date: Tue, 21 Jul 2026 17:25:39 +0200
Message-ID: <20260721152408.798767377@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ switch to old "mesh_iface" name "soft_iface", Context, keep early
  batadv_softif_destroy_netlink() cleanup in case sysfs support is active,
  only run destructor VLAN code on non-softif_destroy context ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/main.c           |   17 +++++++++++++++++
 net/batman-adv/soft-interface.c |    7 +++++--
 net/batman-adv/soft-interface.h |    2 ++
 net/batman-adv/types.h          |    7 +++++++
 4 files changed, 31 insertions(+), 2 deletions(-)

--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -265,6 +265,7 @@ err_orig:
 void batadv_mesh_free(struct net_device *soft_iface)
 {
 	struct batadv_priv *bat_priv = netdev_priv(soft_iface);
+	struct batadv_softif_vlan *vlan;
 
 	atomic_set(&bat_priv->mesh_state, BATADV_MESH_DEACTIVATING);
 
@@ -280,6 +281,22 @@ void batadv_mesh_free(struct net_device
 
 	batadv_mcast_free(bat_priv);
 
+	/* destroy the "untagged" VLAN in case of an register_netdevice() error.
+	 *
+	 * It will be handled normally by batadv_softif_destroy_netlink() and
+	 * batadv_softif_destroy_sysfs() before they call batadv_sysfs_del_meshif().
+	 *
+	 * But when a veto was received during the registration, the VLAN has to
+	 * be cleaned up in the destructor.
+	 */
+	if (!bat_priv->softif_destroy) {
+		vlan = batadv_softif_vlan_get(bat_priv, BATADV_NO_FLAGS);
+		if (vlan) {
+			batadv_softif_destroy_vlan(bat_priv, vlan);
+			batadv_softif_vlan_put(vlan);
+		}
+	}
+
 	/* Free the TT and the originator tables only after having terminated
 	 * all the other depending components which may use these structures for
 	 * their purposes.
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -629,8 +629,8 @@ int batadv_softif_create_vlan(struct bat
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
@@ -834,6 +834,7 @@ static int batadv_softif_init_late(struc
 	bat_priv->tt.last_changeset_len = 0;
 	bat_priv->isolation_mark = 0;
 	bat_priv->isolation_mark_mask = 0;
+	bat_priv->softif_destroy = false;
 
 	/* randomize initial seqno to avoid collision */
 	get_random_bytes(&random_seqno, sizeof(random_seqno));
@@ -1121,6 +1122,7 @@ void batadv_softif_destroy_sysfs(struct
 		batadv_softif_vlan_put(vlan);
 	}
 
+	bat_priv->softif_destroy = true;
 	batadv_sysfs_del_meshif(soft_iface);
 	unregister_netdevice(soft_iface);
 }
@@ -1151,6 +1153,7 @@ static void batadv_softif_destroy_netlin
 		batadv_softif_vlan_put(vlan);
 	}
 
+	bat_priv->softif_destroy = true;
 	batadv_sysfs_del_meshif(soft_iface);
 	unregister_netdevice_queue(soft_iface, head);
 }
--- a/net/batman-adv/soft-interface.h
+++ b/net/batman-adv/soft-interface.h
@@ -25,6 +25,8 @@ void batadv_softif_destroy_sysfs(struct
 bool batadv_softif_is_valid(const struct net_device *net_dev);
 extern struct rtnl_link_ops batadv_link_ops;
 int batadv_softif_create_vlan(struct batadv_priv *bat_priv, unsigned short vid);
+void batadv_softif_destroy_vlan(struct batadv_priv *bat_priv,
+				struct batadv_softif_vlan *vlan);
 void batadv_softif_vlan_release(struct kref *ref);
 struct batadv_softif_vlan *batadv_softif_vlan_get(struct batadv_priv *bat_priv,
 						  unsigned short vid);
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -1791,6 +1791,13 @@ struct batadv_priv {
 	/** @bat_v: B.A.T.M.A.N. V per soft-interface private data */
 	struct batadv_priv_bat_v bat_v;
 #endif
+
+	/**
+	 * @softif_destroy: whether the mesh_free() is called via the
+	 *  batadv_softif_destroy_sysfs() or batadv_softif_destroy_netlink()
+	 *  codepath and doesn't have to clean up the untagged VLAN (sysfs)
+	 */
+	bool softif_destroy:1;
 };
 
 /**


