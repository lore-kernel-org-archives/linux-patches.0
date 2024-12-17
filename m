Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F849149DFA;
	Tue, 17 Dec 2024 17:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455482; cv=none; b=kKmAhv8Fv9R/r1OxXUpKqa0DIWrknd20PRdBUyJslCzYuFe3dfl7UTjTGCPFvZ1gdkhWxrfcXObtS/2zVuJ9KQqx46LeQy4U/HsBn3wZIeJwxaRamkjQO+S6ye9MXht8iMxxxZij8bwrjaBTtvYzTB3LmWSqDI/MQDvMd+5F5Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455482; c=relaxed/simple;
	bh=QYrpriJKzJqFq1VS6k4DSBz3U9dI3B3M8y1c0+XMg6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOicD9FhsBOi+SN96IqnQhhYSubSJE7qVehz/2dwPdynN5XuA0qFxF30stTAZfEPatnWs7absnOweVHR2u3oI+AINKlmiCMaNyyu5/iW01xF9ETzuUbQKG8iFz9jno1YYPQeaipFyzy6dERNQICCDRy9wEHdjd1Ap1IYreeYHwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R5lTWxw5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R5lTWxw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5ADC4CED3;
	Tue, 17 Dec 2024 17:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455482;
	bh=QYrpriJKzJqFq1VS6k4DSBz3U9dI3B3M8y1c0+XMg6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5lTWxw5hNWFKAM+aKi3U6Bk4X9vo3XcIfL3nYNjz7DVJzplp5orx0iKlgtxqxGS3
	 u3aKVzE/YHJsBwbFy/eYqE8NBo9IjFuiV5s99KSBYiZiM582Wpj3IbKLpgqZHglhel
	 H81jLfkbJPjRDY7dhvVym8Q2HBGi/65wKr6wL+2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Alexander Lobakin <alobakin@pm.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 25/43] net: bonding, dummy, ifb, team: advertise NETIF_F_GSO_SOFTWARE
Date: Tue, 17 Dec 2024 18:07:16 +0100
Message-ID: <20241217170521.467835851@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.459491270@linuxfoundation.org>
References: <20241217170520.459491270@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Lobakin <alobakin@pm.me>

[ Upstream commit ecb8fed408b6454606bbb3cd0edb083bf0ad162a ]

Virtual netdevs should use NETIF_F_GSO_SOFTWARE to forward GSO skbs
as-is and let the final drivers deal with them when supported.
Also remove NETIF_F_GSO_UDP_L4 from bonding and team drivers as it's
now included in the "software" list.

Suggested-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 77b11c8bf3a2 ("bonding: Fix feature propagation of NETIF_F_GSO_ENCAP_ALL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 11 +++++------
 drivers/net/dummy.c             |  2 +-
 drivers/net/ifb.c               |  3 +--
 drivers/net/team/team.c         |  9 ++++-----
 4 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 506b6d1cc27d..88d031b0ec14 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1342,14 +1342,14 @@ static netdev_features_t bond_fix_features(struct net_device *dev,
 }
 
 #define BOND_VLAN_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
-				 NETIF_F_FRAGLIST | NETIF_F_ALL_TSO | \
+				 NETIF_F_FRAGLIST | NETIF_F_GSO_SOFTWARE | \
 				 NETIF_F_HIGHDMA | NETIF_F_LRO)
 
 #define BOND_ENC_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
-				 NETIF_F_RXCSUM | NETIF_F_ALL_TSO)
+				 NETIF_F_RXCSUM | NETIF_F_GSO_SOFTWARE)
 
 #define BOND_MPLS_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
-				 NETIF_F_ALL_TSO)
+				 NETIF_F_GSO_SOFTWARE)
 
 
 static void bond_compute_features(struct bonding *bond)
@@ -1405,8 +1405,7 @@ static void bond_compute_features(struct bonding *bond)
 	bond_dev->vlan_features = vlan_features;
 	bond_dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL |
 				    NETIF_F_HW_VLAN_CTAG_TX |
-				    NETIF_F_HW_VLAN_STAG_TX |
-				    NETIF_F_GSO_UDP_L4;
+				    NETIF_F_HW_VLAN_STAG_TX;
 #ifdef CONFIG_XFRM_OFFLOAD
 	bond_dev->hw_enc_features |= xfrm_features;
 #endif /* CONFIG_XFRM_OFFLOAD */
@@ -4922,7 +4921,7 @@ void bond_setup(struct net_device *bond_dev)
 				NETIF_F_HW_VLAN_STAG_RX |
 				NETIF_F_HW_VLAN_STAG_FILTER;
 
-	bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_UDP_L4;
+	bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
 #ifdef CONFIG_XFRM_OFFLOAD
 	bond_dev->hw_features |= BOND_XFRM_FEATURES;
 #endif /* CONFIG_XFRM_OFFLOAD */
diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
index bab3a9bb5e6f..f82ad7419508 100644
--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -124,7 +124,7 @@ static void dummy_setup(struct net_device *dev)
 	dev->flags &= ~IFF_MULTICAST;
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE | IFF_NO_QUEUE;
 	dev->features	|= NETIF_F_SG | NETIF_F_FRAGLIST;
-	dev->features	|= NETIF_F_ALL_TSO;
+	dev->features	|= NETIF_F_GSO_SOFTWARE;
 	dev->features	|= NETIF_F_HW_CSUM | NETIF_F_HIGHDMA | NETIF_F_LLTX;
 	dev->features	|= NETIF_F_GSO_ENCAP_ALL;
 	dev->hw_features |= dev->features;
diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index db3a9b93d4db..f9eb95b44022 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -189,8 +189,7 @@ static const struct net_device_ops ifb_netdev_ops = {
 };
 
 #define IFB_FEATURES (NETIF_F_HW_CSUM | NETIF_F_SG  | NETIF_F_FRAGLIST	| \
-		      NETIF_F_TSO_ECN | NETIF_F_TSO | NETIF_F_TSO6	| \
-		      NETIF_F_GSO_ENCAP_ALL 				| \
+		      NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL	| \
 		      NETIF_F_HIGHDMA | NETIF_F_HW_VLAN_CTAG_TX		| \
 		      NETIF_F_HW_VLAN_STAG_TX)
 
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 49d7030ddc1b..e455e526b774 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -977,11 +977,11 @@ static void team_port_disable(struct team *team,
 }
 
 #define TEAM_VLAN_FEATURES (NETIF_F_HW_CSUM | NETIF_F_SG | \
-			    NETIF_F_FRAGLIST | NETIF_F_ALL_TSO | \
+			    NETIF_F_FRAGLIST | NETIF_F_GSO_SOFTWARE | \
 			    NETIF_F_HIGHDMA | NETIF_F_LRO)
 
 #define TEAM_ENC_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
-				 NETIF_F_RXCSUM | NETIF_F_ALL_TSO)
+				 NETIF_F_RXCSUM | NETIF_F_GSO_SOFTWARE)
 
 static void __team_compute_features(struct team *team)
 {
@@ -1013,8 +1013,7 @@ static void __team_compute_features(struct team *team)
 	team->dev->vlan_features = vlan_features;
 	team->dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL |
 				     NETIF_F_HW_VLAN_CTAG_TX |
-				     NETIF_F_HW_VLAN_STAG_TX |
-				     NETIF_F_GSO_UDP_L4;
+				     NETIF_F_HW_VLAN_STAG_TX;
 	team->dev->hard_header_len = max_hard_header_len;
 
 	team->dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
@@ -2209,7 +2208,7 @@ static void team_setup(struct net_device *dev)
 			   NETIF_F_HW_VLAN_STAG_RX |
 			   NETIF_F_HW_VLAN_STAG_FILTER;
 
-	dev->hw_features |= NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_UDP_L4;
+	dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
 	dev->features |= dev->hw_features;
 	dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
 }
-- 
2.39.5



