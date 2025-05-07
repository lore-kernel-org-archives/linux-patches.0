Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5204C1FF5EC;
	Wed,  7 May 2025 18:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644055; cv=none; b=RyWyfGXAR4z6njM56eLy04puqqVYeucuiGP8YqPNYezkxDVlMNhKEbkV7FiMk+fZewtkHqB6OD+IJClKZ0pcQH/NYcBQ0O40OsDajJJuQPfmeMW4xZB3xusjJ048+1Y2WAWvlds/ISoex9rfqNpK8H0SuOFAu3Y6Z1ZTT8zrKt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644055; c=relaxed/simple;
	bh=5+JBaMI1UwP7pVtfpCxjfaWg9kJWeqXiB4Sn/tfVLL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FN3U9w/8RiKZgT9avV1AU1osxzS5HMIkky0B4E/kgZg+2Cx/y18EDY5M/7UOxZgBwTpCS7hFW4hOClAzGXjvfUbZLSOdPEOsYqht2nBpriQH9Uk7H7yrmgwuQ1WQpu3Q/ARZCQPMg44oos74uN9iOiMakniBDA5/2vEPapqKR6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0t8pM4dD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0t8pM4dD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7170C4CEE2;
	Wed,  7 May 2025 18:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644055;
	bh=5+JBaMI1UwP7pVtfpCxjfaWg9kJWeqXiB4Sn/tfVLL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0t8pM4dDhz8oZkf2L5yxjiAIYOcB48SalmK8JckgpNyxyz0jEJnLjHDC7Oh0ooHO3
	 +IIsjEQLNsz4/Pqz6sG3aSGpi0aXhd11yWghIdrWreKCR6KkAPZL9v8jMvyMid0M4U
	 XZRgrCGDu6FvMFN/suZH1ApV5uvskwk6bPapR7zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sridhar Samudrala <sridhar.samudrala@intel.com>,
	Madhu Chittim <madhu.chittim@intel.com>,
	Zachary Goldstein <zachmgoldstein@google.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 104/183] idpf: fix offloads support for encapsulated packets
Date: Wed,  7 May 2025 20:39:09 +0200
Message-ID: <20250507183829.045906287@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Madhu Chittim <madhu.chittim@intel.com>

[ Upstream commit 713dd6c2deca88cba0596b1e2576f7b7a8e5c59e ]

Split offloads into csum, tso and other offloads so that tunneled
packets do not by default have all the offloads enabled.

Stateless offloads for encapsulated packets are not yet supported in
firmware/software but in the driver we were setting the features same as
non encapsulated features.

Fixed naming to clarify CSUM bits are being checked for Tx.

Inherit netdev features to VLAN interfaces as well.

Fixes: 0fe45467a104 ("idpf: add create vport and netdev configuration")
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
Tested-by: Zachary Goldstein <zachmgoldstein@google.com>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20250425222636.3188441-4-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf.h     | 18 +++----
 drivers/net/ethernet/intel/idpf/idpf_lib.c | 57 ++++++++--------------
 2 files changed, 27 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf.h b/drivers/net/ethernet/intel/idpf/idpf.h
index 66544faab710a..aef0e9775a330 100644
--- a/drivers/net/ethernet/intel/idpf/idpf.h
+++ b/drivers/net/ethernet/intel/idpf/idpf.h
@@ -629,13 +629,13 @@ bool idpf_is_capability_ena(struct idpf_adapter *adapter, bool all,
 	VIRTCHNL2_CAP_RX_HSPLIT_AT_L4V4	|\
 	VIRTCHNL2_CAP_RX_HSPLIT_AT_L4V6)
 
-#define IDPF_CAP_RX_CSUM_L4V4 (\
-	VIRTCHNL2_CAP_RX_CSUM_L4_IPV4_TCP	|\
-	VIRTCHNL2_CAP_RX_CSUM_L4_IPV4_UDP)
+#define IDPF_CAP_TX_CSUM_L4V4 (\
+	VIRTCHNL2_CAP_TX_CSUM_L4_IPV4_TCP	|\
+	VIRTCHNL2_CAP_TX_CSUM_L4_IPV4_UDP)
 
-#define IDPF_CAP_RX_CSUM_L4V6 (\
-	VIRTCHNL2_CAP_RX_CSUM_L4_IPV6_TCP	|\
-	VIRTCHNL2_CAP_RX_CSUM_L4_IPV6_UDP)
+#define IDPF_CAP_TX_CSUM_L4V6 (\
+	VIRTCHNL2_CAP_TX_CSUM_L4_IPV6_TCP	|\
+	VIRTCHNL2_CAP_TX_CSUM_L4_IPV6_UDP)
 
 #define IDPF_CAP_RX_CSUM (\
 	VIRTCHNL2_CAP_RX_CSUM_L3_IPV4		|\
@@ -644,11 +644,9 @@ bool idpf_is_capability_ena(struct idpf_adapter *adapter, bool all,
 	VIRTCHNL2_CAP_RX_CSUM_L4_IPV6_TCP	|\
 	VIRTCHNL2_CAP_RX_CSUM_L4_IPV6_UDP)
 
-#define IDPF_CAP_SCTP_CSUM (\
+#define IDPF_CAP_TX_SCTP_CSUM (\
 	VIRTCHNL2_CAP_TX_CSUM_L4_IPV4_SCTP	|\
-	VIRTCHNL2_CAP_TX_CSUM_L4_IPV6_SCTP	|\
-	VIRTCHNL2_CAP_RX_CSUM_L4_IPV4_SCTP	|\
-	VIRTCHNL2_CAP_RX_CSUM_L4_IPV6_SCTP)
+	VIRTCHNL2_CAP_TX_CSUM_L4_IPV6_SCTP)
 
 #define IDPF_CAP_TUNNEL_TX_CSUM (\
 	VIRTCHNL2_CAP_TX_CSUM_L3_SINGLE_TUNNEL	|\
diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index a055a47449f12..78951d62f6171 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -703,8 +703,10 @@ static int idpf_cfg_netdev(struct idpf_vport *vport)
 {
 	struct idpf_adapter *adapter = vport->adapter;
 	struct idpf_vport_config *vport_config;
+	netdev_features_t other_offloads = 0;
+	netdev_features_t csum_offloads = 0;
+	netdev_features_t tso_offloads = 0;
 	netdev_features_t dflt_features;
-	netdev_features_t offloads = 0;
 	struct idpf_netdev_priv *np;
 	struct net_device *netdev;
 	u16 idx = vport->idx;
@@ -766,53 +768,32 @@ static int idpf_cfg_netdev(struct idpf_vport *vport)
 
 	if (idpf_is_cap_ena_all(adapter, IDPF_RSS_CAPS, IDPF_CAP_RSS))
 		dflt_features |= NETIF_F_RXHASH;
-	if (idpf_is_cap_ena_all(adapter, IDPF_CSUM_CAPS, IDPF_CAP_RX_CSUM_L4V4))
-		dflt_features |= NETIF_F_IP_CSUM;
-	if (idpf_is_cap_ena_all(adapter, IDPF_CSUM_CAPS, IDPF_CAP_RX_CSUM_L4V6))
-		dflt_features |= NETIF_F_IPV6_CSUM;
+	if (idpf_is_cap_ena_all(adapter, IDPF_CSUM_CAPS, IDPF_CAP_TX_CSUM_L4V4))
+		csum_offloads |= NETIF_F_IP_CSUM;
+	if (idpf_is_cap_ena_all(adapter, IDPF_CSUM_CAPS, IDPF_CAP_TX_CSUM_L4V6))
+		csum_offloads |= NETIF_F_IPV6_CSUM;
 	if (idpf_is_cap_ena(adapter, IDPF_CSUM_CAPS, IDPF_CAP_RX_CSUM))
-		dflt_features |= NETIF_F_RXCSUM;
-	if (idpf_is_cap_ena_all(adapter, IDPF_CSUM_CAPS, IDPF_CAP_SCTP_CSUM))
-		dflt_features |= NETIF_F_SCTP_CRC;
+		csum_offloads |= NETIF_F_RXCSUM;
+	if (idpf_is_cap_ena_all(adapter, IDPF_CSUM_CAPS, IDPF_CAP_TX_SCTP_CSUM))
+		csum_offloads |= NETIF_F_SCTP_CRC;
 
 	if (idpf_is_cap_ena(adapter, IDPF_SEG_CAPS, VIRTCHNL2_CAP_SEG_IPV4_TCP))
-		dflt_features |= NETIF_F_TSO;
+		tso_offloads |= NETIF_F_TSO;
 	if (idpf_is_cap_ena(adapter, IDPF_SEG_CAPS, VIRTCHNL2_CAP_SEG_IPV6_TCP))
-		dflt_features |= NETIF_F_TSO6;
+		tso_offloads |= NETIF_F_TSO6;
 	if (idpf_is_cap_ena_all(adapter, IDPF_SEG_CAPS,
 				VIRTCHNL2_CAP_SEG_IPV4_UDP |
 				VIRTCHNL2_CAP_SEG_IPV6_UDP))
-		dflt_features |= NETIF_F_GSO_UDP_L4;
+		tso_offloads |= NETIF_F_GSO_UDP_L4;
 	if (idpf_is_cap_ena_all(adapter, IDPF_RSC_CAPS, IDPF_CAP_RSC))
-		offloads |= NETIF_F_GRO_HW;
-	/* advertise to stack only if offloads for encapsulated packets is
-	 * supported
-	 */
-	if (idpf_is_cap_ena(vport->adapter, IDPF_SEG_CAPS,
-			    VIRTCHNL2_CAP_SEG_TX_SINGLE_TUNNEL)) {
-		offloads |= NETIF_F_GSO_UDP_TUNNEL	|
-			    NETIF_F_GSO_GRE		|
-			    NETIF_F_GSO_GRE_CSUM	|
-			    NETIF_F_GSO_PARTIAL		|
-			    NETIF_F_GSO_UDP_TUNNEL_CSUM	|
-			    NETIF_F_GSO_IPXIP4		|
-			    NETIF_F_GSO_IPXIP6		|
-			    0;
-
-		if (!idpf_is_cap_ena_all(vport->adapter, IDPF_CSUM_CAPS,
-					 IDPF_CAP_TUNNEL_TX_CSUM))
-			netdev->gso_partial_features |=
-				NETIF_F_GSO_UDP_TUNNEL_CSUM;
-
-		netdev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
-		offloads |= NETIF_F_TSO_MANGLEID;
-	}
+		other_offloads |= NETIF_F_GRO_HW;
 	if (idpf_is_cap_ena(adapter, IDPF_OTHER_CAPS, VIRTCHNL2_CAP_LOOPBACK))
-		offloads |= NETIF_F_LOOPBACK;
+		other_offloads |= NETIF_F_LOOPBACK;
 
-	netdev->features |= dflt_features;
-	netdev->hw_features |= dflt_features | offloads;
-	netdev->hw_enc_features |= dflt_features | offloads;
+	netdev->features |= dflt_features | csum_offloads | tso_offloads;
+	netdev->hw_features |=  netdev->features | other_offloads;
+	netdev->vlan_features |= netdev->features | other_offloads;
+	netdev->hw_enc_features |= dflt_features | other_offloads;
 	idpf_set_ethtool_ops(netdev);
 	SET_NETDEV_DEV(netdev, &adapter->pdev->dev);
 
-- 
2.39.5



