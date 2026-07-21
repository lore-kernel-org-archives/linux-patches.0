Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED4D47143F;
	Tue, 21 Jul 2026 20:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664871; cv=none; b=CaH6qBV5gk9/BOH+7GOtF4uM2bx/8nStTDtRttuff4shQEoVqv06ZnM5ufsHlG6wkucWT3EsZzZxYWMpyo6cXLjRW4sdqlYUG+4YPapxzUsBpxE8+LSxss8OuE5EfEvcfagSRjJQ7PmGiw/67PkHyCeOewFUA2LnYgBbinp47ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664871; c=relaxed/simple;
	bh=tRHCLDS50JmEUK76EXsT2h2X4eRTTtVRpxcnOFpx6BU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qyrh5iv4mXvdBdMpoRULWfxyW18rhF6IlTnjp39BRn54461xkkzJTnggoYCVNl+AYmaf+J7MEWV9BzwOELiztJ4OrWIV4dzy2kzJPU2WHlBz3VRt93Bku4r/jTKFdappVKil10Wqvbo8nriPbcdrh5r+ZKxGlo9GMC5xE7aDgH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZpdK4mDw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZpdK4mDw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848741F000E9;
	Tue, 21 Jul 2026 20:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664870;
	bh=NeQzwOYCsoDT+q3WxVnjcarkjXLV7LMi4cUAgzU+QoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZpdK4mDwv1l7JzIxHCavj/E87C4cc2yvN+S5HSJkLd/1WdeAMhf5f7cj/PzzKOlMv
	 bBt/GBnhMSYwxWpI3a4JAvjOd1RkAbl1qQWqlN//q7V25WMD/vQ3tgMLj/PjDsfko9
	 zyPiEDgwPMKx3a3QK+vtict8imqTu3A0atUqkwwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Boris Pismenny <borisp@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0046/1266] bonding: add ESP offload features when slaves support
Date: Tue, 21 Jul 2026 17:08:03 +0200
Message-ID: <20260721152442.833423593@linuxfoundation.org>
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

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 4861333b42178fa3d8fd1bb4e2cfb2fedc968dba ]

Add NETIF_F_GSO_ESP bit to bond's gso_partial_features if all slaves
support it, such that ESP segmentation is handled by hardware if possible.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20241105192721.584822-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 950803f72547 ("bonding: fix type confusion in bond_setup_by_slave()")
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index d200909a75cfe9..ec21958babe7d8 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1484,6 +1484,7 @@ static void bond_compute_features(struct bonding *bond)
 {
 	unsigned int dst_release_flag = IFF_XMIT_DST_RELEASE |
 					IFF_XMIT_DST_RELEASE_PERM;
+	netdev_features_t gso_partial_features = NETIF_F_GSO_ESP;
 	netdev_features_t vlan_features = BOND_VLAN_FEATURES;
 	netdev_features_t enc_features  = BOND_ENC_FEATURES;
 #ifdef CONFIG_XFRM_OFFLOAD
@@ -1517,6 +1518,9 @@ static void bond_compute_features(struct bonding *bond)
 							  BOND_XFRM_FEATURES);
 #endif /* CONFIG_XFRM_OFFLOAD */
 
+		if (slave->dev->hw_enc_features & NETIF_F_GSO_PARTIAL)
+			gso_partial_features &= slave->dev->gso_partial_features;
+
 		mpls_features = netdev_increment_features(mpls_features,
 							  slave->dev->mpls_features,
 							  BOND_MPLS_FEATURES);
@@ -1530,6 +1534,11 @@ static void bond_compute_features(struct bonding *bond)
 	}
 	bond_dev->hard_header_len = max_hard_header_len;
 
+	if (gso_partial_features & NETIF_F_GSO_ESP)
+		bond_dev->gso_partial_features |= NETIF_F_GSO_ESP;
+	else
+		bond_dev->gso_partial_features &= ~NETIF_F_GSO_ESP;
+
 done:
 	bond_dev->vlan_features = vlan_features;
 	bond_dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL |
-- 
2.53.0



