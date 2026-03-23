Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A033C07A;
	Mon, 23 Mar 2026 14:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275448; cv=none; b=EUgnLCDVuCQdBIam/poG6+LdftLhx0NaFH/B2FTo0GeM/tgCWqXeE/k5FPoVaGw6/02S4EDzmIg9P5KHHn9gXbrRCodaLxsEi1iCxcaJC616uOh4w5aKXsm+YRUJfUDYZBDZvFASBDA5CpacSGYLDs/iLutJF0+AhMyoA8E7y9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275448; c=relaxed/simple;
	bh=M7oWq+qaCr216arfSZ1R51eP6WF5FMoP4iXxoVuWICo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+2LAbaNEtBejt+trCs4X+4d94/MucDl1JgSzV+u3BgWSXD4X5yZdcoH67hA3JF2VFc9gPqMVpGGGxJbne5fw5cc95APWv2DNCV7XBP4F1cEjyoiZd6Mf+I1HHS0B2JVPH/1THmabg3AhWRvw0sbUmSO3TUOtKRHFvxN8c2In2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I5lcCmms; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I5lcCmms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30737C4CEF7;
	Mon, 23 Mar 2026 14:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275448;
	bh=M7oWq+qaCr216arfSZ1R51eP6WF5FMoP4iXxoVuWICo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I5lcCmmsQsT/alhr7MFWg8aiQWQEnJYgvvbWiOE8T30Aqtk7+hOle8TPHkbA/o2yH
	 o0iL61IlVIp/XEunTAaEcKU5Y6q0e8W0BTuagPtE5m11ydcn1t641omQAUx10N1lIR
	 73d6Qrogo1Yy1xwAlThyXrXqeeHbIOReiKHVZqBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Boris Pismenny <borisp@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/460] bonding: add ESP offload features when slaves support
Date: Mon, 23 Mar 2026 14:40:47 +0100
Message-ID: <20260323134527.963967163@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index c71b52e2966fc..aac385607ac42 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1558,6 +1558,7 @@ static void bond_compute_features(struct bonding *bond)
 {
 	unsigned int dst_release_flag = IFF_XMIT_DST_RELEASE |
 					IFF_XMIT_DST_RELEASE_PERM;
+	netdev_features_t gso_partial_features = NETIF_F_GSO_ESP;
 	netdev_features_t vlan_features = BOND_VLAN_FEATURES;
 	netdev_features_t enc_features  = BOND_ENC_FEATURES;
 #ifdef CONFIG_XFRM_OFFLOAD
@@ -1591,6 +1592,9 @@ static void bond_compute_features(struct bonding *bond)
 							  BOND_XFRM_FEATURES);
 #endif /* CONFIG_XFRM_OFFLOAD */
 
+		if (slave->dev->hw_enc_features & NETIF_F_GSO_PARTIAL)
+			gso_partial_features &= slave->dev->gso_partial_features;
+
 		mpls_features = netdev_increment_features(mpls_features,
 							  slave->dev->mpls_features,
 							  BOND_MPLS_FEATURES);
@@ -1604,6 +1608,11 @@ static void bond_compute_features(struct bonding *bond)
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
2.51.0



