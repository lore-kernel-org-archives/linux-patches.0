Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B2F5038F7;
	Wed, 30 Sep 2026 16:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785356; cv=none; b=UcoTDR6l1UCKkgPQP7+hnnaXwv5dQhg6yMf2fzlj6AfheOUB33d38+GXCS4Ut6sfpvsoxUt4aTJJn6n2drSruvm1ccmsTb6sVKIkGaPQsLA9zI2R8Xy/QFTy4tY+4pNg4cBfrFPqU507cf3vvNQWv18zUrdafqO+bvo6LdDmZYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785356; c=relaxed/simple;
	bh=E0C4Mz25NtfnLlL8EQpjnmhwaz4J9AtsrpGJyaU2sH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pm1Uww5eF/LHOvVrT/qfmYjBX3xkfloOG7iellvA6dzWP1baSfASAFB81v8oRTFglWCaYWanvtXNjtB9FYOH5ysteioeTvdrVW3zqfOQ5qpMhEs7MAKFypITFRNs9KoD2wiCnjNDzRbrJNsVlP9LNfLOSU1a1CRDWtg/SAEiTI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HkB3bIVi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HkB3bIVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A84C1F000FF;
	Wed, 30 Sep 2026 16:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785347;
	bh=l4PtEH7EpF5iOfYMc1EwsSUx7YjQ+JfC9YSvYSBy0Jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HkB3bIVi0Zf6ovpOhFCSHRdBAy9xrUJXRTFDwuRBY7Uu4N5cIKFAcuAJVOlv8ipiL
	 rwuiF8YcE+F6ST5uU+kd/6xKC41n+OoPkfs+BElkRxHR2JaSkWr9tQCQS1EH1BDWR8
	 u9PwSGBdWtHv6YpiCEFC1B+MsKujal2nnjNbS9dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 476/982] vxlan: Pull inner IP header in vxlan_xmit_one().
Date: Wed, 30 Sep 2026 17:20:12 +0200
Message-ID: <20260930152427.006736633@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 31392048f55f98cb01ca709d32d06d926ab9760a ]

Ensure the inner IP header is part of the skb's linear data before
setting old_iph. Otherwise, on a non-linear skb, old_iph could point
outside of the packet data.

Unlike classical VXLAN, which always encapsulates Ethernet packets,
VXLAN-GPE can transport IP packets directly. In that case, we need to
look at skb->protocol to figure out if an Ethernet header is present.

Fixes: d342894c5d2f ("vxlan: virtual extensible lan")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Link: https://patch.msgid.link/2aa75f6fa62ac9dbe4f16ad5ba75dd04a51d4b99.1718804000.git.gnault@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: be83178bfc44 ("vxlan: initialize _md in vxlan_xmit_one()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 34cdc9b4221bc..6659a7df23a17 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2439,7 +2439,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 	struct ip_tunnel_key *pkey;
 	struct ip_tunnel_key key;
 	struct vxlan_dev *vxlan = netdev_priv(dev);
-	const struct iphdr *old_iph = ip_hdr(skb);
+	const struct iphdr *old_iph;
 	struct vxlan_metadata _md;
 	struct vxlan_metadata *md = &_md;
 	unsigned int pkt_len = skb->len;
@@ -2453,8 +2453,15 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 	bool use_cache;
 	bool udp_sum = false;
 	bool xnet = !net_eq(vxlan->net, dev_net(vxlan->dev));
+	bool no_eth_encap;
 	__be32 vni = 0;
 
+	no_eth_encap = flags & VXLAN_F_GPE && skb->protocol != htons(ETH_P_TEB);
+	if (!skb_vlan_inet_prepare(skb, no_eth_encap))
+		goto drop;
+
+	old_iph = ip_hdr(skb);
+
 	info = skb_tunnel_info(skb);
 	use_cache = ip_tunnel_dst_cache_usable(skb, info);
 
-- 
2.53.0



