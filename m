Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09D1155A30;
	Wed,  5 Feb 2025 15:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768373; cv=none; b=lZnwTmVP17b8+p/mqITwLUP+E8JlwHCvooW+ZBGYucwHjpW+AdqcV0fgKNcs0E/AgfMcn3UoiIpbNMNOevaxIy3/jmV75ysuatfgEOqNYSIXTj9kVe3OEAKB81PBv3BQeScq1IO54Vb0CKZ0B5zlKdG9eKD9IWos+LLDnglSrv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768373; c=relaxed/simple;
	bh=LHsdY40JHM3IvCZ/F/xhUtDYrebCUn8ySu1NSGpth1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8tdqCLVc+yl6YQC7iEgR15E/WYYF66bC+mU9D0h6KufLpA5llSOqzyRYtpM9ECBclp+YBZMAMX+yZSPyeg9Gco2ya2tYN+CoZebFnEyREzBU8HS5bUUkby1MClbzf4kUEiS3PH+oHg9AmdLVXq75nFsl0u5R9IRqfL/TPak3UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3BJQcHf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3BJQcHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C963C4CED1;
	Wed,  5 Feb 2025 15:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768373;
	bh=LHsdY40JHM3IvCZ/F/xhUtDYrebCUn8ySu1NSGpth1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3BJQcHfOgNCodAoPgp9vUgmxDXlWpwAHP/W6c9F+kH6rMvXpTEDY8P3ncHXVeMmR
	 r3eUH/roVQvQnnmEvvrBNW4O8ONZQH+81FU5dK1RXLhcAWyWsXVjOzreq6IHWRppgU
	 t2V9e3nd+xJX66fPE9kRyZGvbRqAqlBsmiE2gebA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 537/623] bonding: Correctly support GSO ESP offload
Date: Wed,  5 Feb 2025 14:44:39 +0100
Message-ID: <20250205134516.767976220@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit 9e6c4e6b605c1fa3e24f74ee0b641e95f090188a ]

The referenced fix is incomplete. It correctly computes
bond_dev->gso_partial_features across slaves, but unfortunately
netdev_fix_features discards gso_partial_features from the feature set
if NETIF_F_GSO_PARTIAL isn't set in bond_dev->features.

This is visible with ethtool -k bond0 | grep esp:
tx-esp-segmentation: off [requested on]
esp-hw-offload: on
esp-tx-csum-hw-offload: on

This patch reworks the bonding GSO offload support by:
- making aggregating gso_partial_features across slaves similar to the
  other feature sets (this part is a no-op).
- advertising the default partial gso features on empty bond devs, same
  as with other feature sets (also a no-op).
- adding NETIF_F_GSO_PARTIAL to hw_enc_features filtered across slaves.
- adding NETIF_F_GSO_PARTIAL to features in bond_setup()

With all of these, 'ethtool -k bond0 | grep esp' now reports:
tx-esp-segmentation: on
esp-hw-offload: on
esp-tx-csum-hw-offload: on

Fixes: 4861333b4217 ("bonding: add ESP offload features when slaves support")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Acked-by: Jay Vosburgh <jv@jvosburgh.net>
Link: https://patch.msgid.link/20250127104147.759658-1-cratiu@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 7b78c2bada814..e45bba240cbcd 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1538,17 +1538,20 @@ static netdev_features_t bond_fix_features(struct net_device *dev,
 				 NETIF_F_HIGHDMA | NETIF_F_LRO)
 
 #define BOND_ENC_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
-				 NETIF_F_RXCSUM | NETIF_F_GSO_SOFTWARE)
+				 NETIF_F_RXCSUM | NETIF_F_GSO_SOFTWARE | \
+				 NETIF_F_GSO_PARTIAL)
 
 #define BOND_MPLS_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
 				 NETIF_F_GSO_SOFTWARE)
 
+#define BOND_GSO_PARTIAL_FEATURES (NETIF_F_GSO_ESP)
+
 
 static void bond_compute_features(struct bonding *bond)
 {
+	netdev_features_t gso_partial_features = BOND_GSO_PARTIAL_FEATURES;
 	unsigned int dst_release_flag = IFF_XMIT_DST_RELEASE |
 					IFF_XMIT_DST_RELEASE_PERM;
-	netdev_features_t gso_partial_features = NETIF_F_GSO_ESP;
 	netdev_features_t vlan_features = BOND_VLAN_FEATURES;
 	netdev_features_t enc_features  = BOND_ENC_FEATURES;
 #ifdef CONFIG_XFRM_OFFLOAD
@@ -1582,8 +1585,9 @@ static void bond_compute_features(struct bonding *bond)
 							  BOND_XFRM_FEATURES);
 #endif /* CONFIG_XFRM_OFFLOAD */
 
-		if (slave->dev->hw_enc_features & NETIF_F_GSO_PARTIAL)
-			gso_partial_features &= slave->dev->gso_partial_features;
+		gso_partial_features = netdev_increment_features(gso_partial_features,
+								 slave->dev->gso_partial_features,
+								 BOND_GSO_PARTIAL_FEATURES);
 
 		mpls_features = netdev_increment_features(mpls_features,
 							  slave->dev->mpls_features,
@@ -1598,12 +1602,8 @@ static void bond_compute_features(struct bonding *bond)
 	}
 	bond_dev->hard_header_len = max_hard_header_len;
 
-	if (gso_partial_features & NETIF_F_GSO_ESP)
-		bond_dev->gso_partial_features |= NETIF_F_GSO_ESP;
-	else
-		bond_dev->gso_partial_features &= ~NETIF_F_GSO_ESP;
-
 done:
+	bond_dev->gso_partial_features = gso_partial_features;
 	bond_dev->vlan_features = vlan_features;
 	bond_dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL |
 				    NETIF_F_HW_VLAN_CTAG_TX |
@@ -6046,6 +6046,7 @@ void bond_setup(struct net_device *bond_dev)
 	bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
 	bond_dev->features |= bond_dev->hw_features;
 	bond_dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
+	bond_dev->features |= NETIF_F_GSO_PARTIAL;
 #ifdef CONFIG_XFRM_OFFLOAD
 	bond_dev->hw_features |= BOND_XFRM_FEATURES;
 	/* Only enable XFRM features if this is an active-backup config */
-- 
2.39.5



