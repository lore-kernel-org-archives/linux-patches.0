Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8281B24A078;
	Tue, 21 Jul 2026 20:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664876; cv=none; b=NgbtDki6II1gyh+QdKx8F5uT42KtJZWAo0ugklk06kMGe8uphjdgcMzAKrN1qIXbaiAFo0168ZlimwcaUj6MGquOZLQH9mmnuoKIIQY46xWhMHRgoztIpJaA1nlzUEG+Y+Ap4XXMjY5iIyrrNOuBwlKlV1VJxI3yDGMgovREUOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664876; c=relaxed/simple;
	bh=MDZGE0P0eGQUJFQ2mNgRrUDOebmjrPCcfafXgZOWgT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FK3f/DuAnmsl63v/tzrl8bgwb4yeYAcEf81Ohpa55T65EN/Nm7EflkZwYUT5pqghLlS4qRMllCkOtldyaV6aXMlI3nxNXU98qWxM0rUGG17mSLd59kdMQgyaP92cguqZeaMQMzjUI+AwSuBYiMXifAmUUwAQ1RM8t0XPqOw1Z/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7w9WAEA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7w9WAEA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7A71F000E9;
	Tue, 21 Jul 2026 20:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664875;
	bh=6AuC1Jae4HIVzw15uEYibzxGC9zf0Q0qG8U6XJBAW6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W7w9WAEAGmzYXj67lajXU+Kdz3yYIz624WcI52Ckm4VO0/qy2xCEBHHQ2QhlEvnhq
	 p20lfliqoA8SYprVKuV5vVkMwEpaXG6JUI4i94OY6+1Aj2Ki7rB/qX+M3dQyTc8EhJ
	 II9Olzu9g8uqA8ZDyK1HuIlI90Te5Uhb8qhB6Nh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0048/1266] net: add a common function to compute features for upper devices
Date: Tue, 21 Jul 2026 17:08:05 +0200
Message-ID: <20260721152442.877611884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Stable-dep-of: 950803f72547 ("bonding: fix type confusion in bond_setup_by_slave()")
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdev_features.h | 18 +++++++
 include/linux/netdevice.h       |  1 +
 net/core/dev.c                  | 88 +++++++++++++++++++++++++++++++++
 3 files changed, 107 insertions(+)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 1b5ad57e7cbf5a..988e62cafd316a 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -261,6 +261,24 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
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
index 202e557496fb41..a81dab6c2f5f24 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5005,6 +5005,7 @@ static inline netdev_features_t netdev_add_tso_features(netdev_features_t featur
 int __netdev_update_features(struct net_device *dev);
 void netdev_update_features(struct net_device *dev);
 void netdev_change_features(struct net_device *dev);
+void netdev_compute_master_upper_features(struct net_device *dev, bool update_header);
 
 void netif_stacked_transfer_operstate(const struct net_device *rootdev,
 					struct net_device *dev);
diff --git a/net/core/dev.c b/net/core/dev.c
index 405b448bd91fef..0cc03e6c6fb144 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -11450,6 +11450,94 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
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
2.53.0



