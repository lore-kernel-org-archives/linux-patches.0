Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B1E61FDF;
	Mon, 27 May 2024 19:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838702; cv=none; b=jYdFPMIubWfLgL2fIaJ4QaHWhoS1cngNhjFbY/HyOubsiisIzIFL9NGUVmDERAk54yhP6kuBDGZEQiS4nafwonnb/082E4eRE28+t4G39Zipf7LnJ9uFIXlSYv0lnTY0+FA72pi3i6K9cl2BFpUMNkE7oKFv7dypPm27H9IYSCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838702; c=relaxed/simple;
	bh=i8w9py/CXdXnNC8aOvAl9iT1I3Tr+rCG3nixcaHxVXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OclWp9o38GAYmsVZAAbCdR97S5Xk37dgBALO27n5fRtCgcQ1TXaF1DLLw7wbF5fLmf43ymo/jm7Qz7LLL6rbBNCKdvlhA+YQ2BalPyeGWLxaH6AmRuWdRFKQLIn7EEpUZ3yN58WiI9F0uANciZUjxEproJN8WFZP+fCg8pURWNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yrqW392m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yrqW392m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4109AC2BBFC;
	Mon, 27 May 2024 19:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838702;
	bh=i8w9py/CXdXnNC8aOvAl9iT1I3Tr+rCG3nixcaHxVXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yrqW392mPJNLvYKv/UBSkakHyphLgolbL0+vC5RSuRBZfmOGq81bdwDNJZ0IQPwJW
	 FJW4FoPOtwA85JppPm5veeOQLPQKxfojmPMSq02hl20dEbJrd3lYNheXxGz/gzQP+d
	 PTf/tjWxH38ssPwehkPzcRFYLlEq/FkYxD7CSp+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Sai Krishna <saikrishnag@marvell.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 485/493] net: wangxun: match VLAN CTAG and STAG features
Date: Mon, 27 May 2024 20:58:07 +0200
Message-ID: <20240527185646.003721379@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit ac71ab7816b675f1c9614015bd87bfccb456c394 ]

Hardware requires VLAN CTAG and STAG configuration always matches. And
whether VLAN CTAG or STAG changes, the configuration needs to be changed
as well.

Fixes: 6670f1ece2c8 ("net: txgbe: Add netdev features support")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Sai Krishna <saikrishnag@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c   | 46 +++++++++++++++++++
 drivers/net/ethernet/wangxun/libwx/wx_lib.h   |  2 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |  1 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  1 +
 4 files changed, 50 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index 6aa6073476f7d..b2d5c3f05eed5 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -2705,6 +2705,52 @@ int wx_set_features(struct net_device *netdev, netdev_features_t features)
 }
 EXPORT_SYMBOL(wx_set_features);
 
+#define NETIF_VLAN_STRIPPING_FEATURES	(NETIF_F_HW_VLAN_CTAG_RX | \
+					 NETIF_F_HW_VLAN_STAG_RX)
+
+#define NETIF_VLAN_INSERTION_FEATURES	(NETIF_F_HW_VLAN_CTAG_TX | \
+					 NETIF_F_HW_VLAN_STAG_TX)
+
+#define NETIF_VLAN_FILTERING_FEATURES	(NETIF_F_HW_VLAN_CTAG_FILTER | \
+					 NETIF_F_HW_VLAN_STAG_FILTER)
+
+netdev_features_t wx_fix_features(struct net_device *netdev,
+				  netdev_features_t features)
+{
+	netdev_features_t changed = netdev->features ^ features;
+	struct wx *wx = netdev_priv(netdev);
+
+	if (changed & NETIF_VLAN_STRIPPING_FEATURES) {
+		if ((features & NETIF_VLAN_STRIPPING_FEATURES) != NETIF_VLAN_STRIPPING_FEATURES &&
+		    (features & NETIF_VLAN_STRIPPING_FEATURES) != 0) {
+			features &= ~NETIF_VLAN_STRIPPING_FEATURES;
+			features |= netdev->features & NETIF_VLAN_STRIPPING_FEATURES;
+			wx_err(wx, "802.1Q and 802.1ad VLAN stripping must be either both on or both off.");
+		}
+	}
+
+	if (changed & NETIF_VLAN_INSERTION_FEATURES) {
+		if ((features & NETIF_VLAN_INSERTION_FEATURES) != NETIF_VLAN_INSERTION_FEATURES &&
+		    (features & NETIF_VLAN_INSERTION_FEATURES) != 0) {
+			features &= ~NETIF_VLAN_INSERTION_FEATURES;
+			features |= netdev->features & NETIF_VLAN_INSERTION_FEATURES;
+			wx_err(wx, "802.1Q and 802.1ad VLAN insertion must be either both on or both off.");
+		}
+	}
+
+	if (changed & NETIF_VLAN_FILTERING_FEATURES) {
+		if ((features & NETIF_VLAN_FILTERING_FEATURES) != NETIF_VLAN_FILTERING_FEATURES &&
+		    (features & NETIF_VLAN_FILTERING_FEATURES) != 0) {
+			features &= ~NETIF_VLAN_FILTERING_FEATURES;
+			features |= netdev->features & NETIF_VLAN_FILTERING_FEATURES;
+			wx_err(wx, "802.1Q and 802.1ad VLAN filtering must be either both on or both off.");
+		}
+	}
+
+	return features;
+}
+EXPORT_SYMBOL(wx_fix_features);
+
 void wx_set_ring(struct wx *wx, u32 new_tx_count,
 		 u32 new_rx_count, struct wx_ring *temp_ring)
 {
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.h b/drivers/net/ethernet/wangxun/libwx/wx_lib.h
index ec909e876720c..c41b29ea812ff 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.h
@@ -30,6 +30,8 @@ int wx_setup_resources(struct wx *wx);
 void wx_get_stats64(struct net_device *netdev,
 		    struct rtnl_link_stats64 *stats);
 int wx_set_features(struct net_device *netdev, netdev_features_t features);
+netdev_features_t wx_fix_features(struct net_device *netdev,
+				  netdev_features_t features);
 void wx_set_ring(struct wx *wx, u32 new_tx_count,
 		 u32 new_rx_count, struct wx_ring *temp_ring);
 
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index fdd6b4f70b7a5..e894e01d030d1 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -499,6 +499,7 @@ static const struct net_device_ops ngbe_netdev_ops = {
 	.ndo_start_xmit         = wx_xmit_frame,
 	.ndo_set_rx_mode        = wx_set_rx_mode,
 	.ndo_set_features       = wx_set_features,
+	.ndo_fix_features       = wx_fix_features,
 	.ndo_validate_addr      = eth_validate_addr,
 	.ndo_set_mac_address    = wx_set_mac,
 	.ndo_get_stats64        = wx_get_stats64,
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 3b151c410a5c2..c13c43e07a993 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -550,6 +550,7 @@ static const struct net_device_ops txgbe_netdev_ops = {
 	.ndo_start_xmit         = wx_xmit_frame,
 	.ndo_set_rx_mode        = wx_set_rx_mode,
 	.ndo_set_features       = wx_set_features,
+	.ndo_fix_features       = wx_fix_features,
 	.ndo_validate_addr      = eth_validate_addr,
 	.ndo_set_mac_address    = wx_set_mac,
 	.ndo_get_stats64        = wx_get_stats64,
-- 
2.43.0



