Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE060332EA7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301260; cv=none; b=qSX43CALvIi3pHThTxsQUZxff5TpP+gi3fIIOx/+K8Q5N0ohzE7j/ynDPJ4E7ap6eLWt9Y1js2gEqSIKioLqNCx1CfaOuz+0EdpBfug7oYH3WtvCGQmLXjkx3nrPBxXMlVnEyOI8hqXZ5P3YziXfJYP2ZtcrNj8gCj8VTqZFrzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301260; c=relaxed/simple;
	bh=kjPV0T0hJ5hNaWKfqB1Ib29vSWzSEK004blGecTl5dQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDkBgdQZrv8fgFqdEFCcn3BZIc420MJ44oFiCzjoBWy9BtRCnV5VCRvV3QpFFmLHqa7POp3xMKe7TbNLVkreULj4A+o6MCUD9qpwXJZJm1AKdfHDX7Yvli4KsMzJ1sJJd98BJ3wWhBbh+N19AMVYI+wKsEt/uhp7QRr5FDp1ngg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FPga6z17; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FPga6z17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1CFBC19424;
	Sat, 28 Feb 2026 17:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301260;
	bh=kjPV0T0hJ5hNaWKfqB1Ib29vSWzSEK004blGecTl5dQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FPga6z17F1b0nmuQIly84K1UWCBpI2gdrltGoXnHaPcl+irFjqkbJ/jmTVsYnmmfw
	 xghdmSeD6Dcyx0zQLiV/UpYp6Zsj3itflVU2XmynY1NVMhrBuYci0wDHmntQf1b6rh
	 ewNa7uD2GdgY9X/RlAdnnc4asTJ7IGBHFnC5H8Kg3uqizSDUqqOFyvQRxCQoG46EJ7
	 WzHoBP0FurTIkFe1ao6Ug2ELfM1YYFOr7hX57dgbP6KE0+PGBRxQ/2bz0qL+ylYSnm
	 2Wf2+oA2oGvlKOKRax4glptf5hCv4I9hj8w4zqKA+53SYcwY2rSJmrI0+9raEnjLBI
	 IzrPU3G5hpoeA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 444/752] net: add a common function to compute features for upper devices
Date: Sat, 28 Feb 2026 12:42:35 -0500
Message-ID: <20260228174750.1542406-444-sashal@kernel.org>
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

[ Upstream commit 28098defc79fe7d29e6bfe4eb6312991f6bdc3d3 ]

Some high level software drivers need to compute features from lower
devices. But each has their own implementations and may lost some
feature compute. Let's use one common function to compute features
for kinds of these devices.

The new helper uses the current bond implementation as the reference
one, as the latter already handles all the relevant aspects: netdev
features, TSO limits and dst retention.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://patch.msgid.link/20251017034155.61990-2-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: bb4c698633c0 ("team: avoid NETDEV_CHANGEMTU event when unregistering slave")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdev_features.h | 18 +++++++
 include/linux/netdevice.h       |  1 +
 net/core/dev.c                  | 88 +++++++++++++++++++++++++++++++++
 3 files changed, 107 insertions(+)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 7a01c518e5730..93e4da7046a10 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -255,6 +255,24 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 				 NETIF_F_GSO_UDP_TUNNEL |		\
 				 NETIF_F_GSO_UDP_TUNNEL_CSUM)
 
+/* virtual device features */
+#define MASTER_UPPER_DEV_VLAN_FEATURES	 (NETIF_F_HW_CSUM | NETIF_F_SG | \
+					  NETIF_F_FRAGLIST | NETIF_F_GSO_SOFTWARE | \
+					  NETIF_F_GSO_ENCAP_ALL | \
+					  NETIF_F_HIGHDMA | NETIF_F_LRO)
+
+#define MASTER_UPPER_DEV_ENC_FEATURES	 (NETIF_F_HW_CSUM | NETIF_F_SG | \
+					  NETIF_F_RXCSUM | NETIF_F_GSO_SOFTWARE | \
+					  NETIF_F_GSO_PARTIAL)
+
+#define MASTER_UPPER_DEV_MPLS_FEATURES	 (NETIF_F_HW_CSUM | NETIF_F_SG | \
+					  NETIF_F_GSO_SOFTWARE)
+
+#define MASTER_UPPER_DEV_XFRM_FEATURES	 (NETIF_F_HW_ESP | NETIF_F_HW_ESP_TX_CSUM | \
+					  NETIF_F_GSO_ESP)
+
+#define MASTER_UPPER_DEV_GSO_PARTIAL_FEATURES (NETIF_F_GSO_ESP)
+
 static inline netdev_features_t netdev_base_features(netdev_features_t features)
 {
 	features &= ~NETIF_F_ONE_FOR_ALL;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index c6c04cd0a6816..3d9f21274dc32 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5306,6 +5306,7 @@ static inline netdev_features_t netdev_add_tso_features(netdev_features_t featur
 int __netdev_update_features(struct net_device *dev);
 void netdev_update_features(struct net_device *dev);
 void netdev_change_features(struct net_device *dev);
+void netdev_compute_master_upper_features(struct net_device *dev, bool update_header);
 
 void netif_stacked_transfer_operstate(const struct net_device *rootdev,
 					struct net_device *dev);
diff --git a/net/core/dev.c b/net/core/dev.c
index 2dc1cf7f8d892..6c15f9b040ba8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -12657,6 +12657,94 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 }
 EXPORT_SYMBOL(netdev_increment_features);
 
+/**
+ *	netdev_compute_master_upper_features - compute feature from lowers
+ *	@dev: the upper device
+ *	@update_header: whether to update upper device's header_len/headroom/tailroom
+ *
+ *	Recompute the upper device's feature based on all lower devices.
+ */
+void netdev_compute_master_upper_features(struct net_device *dev, bool update_header)
+{
+	unsigned int dst_release_flag = IFF_XMIT_DST_RELEASE | IFF_XMIT_DST_RELEASE_PERM;
+	netdev_features_t gso_partial_features = MASTER_UPPER_DEV_GSO_PARTIAL_FEATURES;
+	netdev_features_t xfrm_features = MASTER_UPPER_DEV_XFRM_FEATURES;
+	netdev_features_t mpls_features = MASTER_UPPER_DEV_MPLS_FEATURES;
+	netdev_features_t vlan_features = MASTER_UPPER_DEV_VLAN_FEATURES;
+	netdev_features_t enc_features = MASTER_UPPER_DEV_ENC_FEATURES;
+	unsigned short max_header_len = ETH_HLEN;
+	unsigned int tso_max_size = TSO_MAX_SIZE;
+	unsigned short max_headroom = 0;
+	unsigned short max_tailroom = 0;
+	u16 tso_max_segs = TSO_MAX_SEGS;
+	struct net_device *lower_dev;
+	struct list_head *iter;
+
+	mpls_features = netdev_base_features(mpls_features);
+	vlan_features = netdev_base_features(vlan_features);
+	enc_features = netdev_base_features(enc_features);
+
+	netdev_for_each_lower_dev(dev, lower_dev, iter) {
+		gso_partial_features = netdev_increment_features(gso_partial_features,
+								 lower_dev->gso_partial_features,
+								 MASTER_UPPER_DEV_GSO_PARTIAL_FEATURES);
+
+		vlan_features = netdev_increment_features(vlan_features,
+							  lower_dev->vlan_features,
+							  MASTER_UPPER_DEV_VLAN_FEATURES);
+
+		enc_features = netdev_increment_features(enc_features,
+							 lower_dev->hw_enc_features,
+							 MASTER_UPPER_DEV_ENC_FEATURES);
+
+		if (IS_ENABLED(CONFIG_XFRM_OFFLOAD))
+			xfrm_features = netdev_increment_features(xfrm_features,
+								  lower_dev->hw_enc_features,
+								  MASTER_UPPER_DEV_XFRM_FEATURES);
+
+		mpls_features = netdev_increment_features(mpls_features,
+							  lower_dev->mpls_features,
+							  MASTER_UPPER_DEV_MPLS_FEATURES);
+
+		dst_release_flag &= lower_dev->priv_flags;
+
+		if (update_header) {
+			max_header_len = max(max_header_len, lower_dev->hard_header_len);
+			max_headroom = max(max_headroom, lower_dev->needed_headroom);
+			max_tailroom = max(max_tailroom, lower_dev->needed_tailroom);
+		}
+
+		tso_max_size = min(tso_max_size, lower_dev->tso_max_size);
+		tso_max_segs = min(tso_max_segs, lower_dev->tso_max_segs);
+	}
+
+	dev->gso_partial_features = gso_partial_features;
+	dev->vlan_features = vlan_features;
+	dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL |
+			       NETIF_F_HW_VLAN_CTAG_TX |
+			       NETIF_F_HW_VLAN_STAG_TX;
+	if (IS_ENABLED(CONFIG_XFRM_OFFLOAD))
+		dev->hw_enc_features |= xfrm_features;
+	dev->mpls_features = mpls_features;
+
+	dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
+	if ((dev->priv_flags & IFF_XMIT_DST_RELEASE_PERM) &&
+	    dst_release_flag == (IFF_XMIT_DST_RELEASE | IFF_XMIT_DST_RELEASE_PERM))
+		dev->priv_flags |= IFF_XMIT_DST_RELEASE;
+
+	if (update_header) {
+		dev->hard_header_len = max_header_len;
+		dev->needed_headroom = max_headroom;
+		dev->needed_tailroom = max_tailroom;
+	}
+
+	netif_set_tso_max_segs(dev, tso_max_segs);
+	netif_set_tso_max_size(dev, tso_max_size);
+
+	netdev_change_features(dev);
+}
+EXPORT_SYMBOL(netdev_compute_master_upper_features);
+
 static struct hlist_head * __net_init netdev_create_hash(void)
 {
 	int i;
-- 
2.51.0

