Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6082F337B81;
	Wed,  8 Apr 2026 18:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674358; cv=none; b=p39u0ncdiIMaZJuye+Pv/b6PNBtMPq/o6Fe3v/XW4NxPCeFLE5h2+M1UWebtrHbSdUM47k+b2h0KlEm/KWta/jHjZ2ZK7Q+BKkXn/RtNmf1bCEI5Xh70w1K9/rset50lQTYi7HqkAWHuHHn36tSsGzO3JVO+TySIUr0QVe+Vnnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674358; c=relaxed/simple;
	bh=4e6bAS4iCPq1TpaRFTh25HePxJWGG+fyIMYkJAN+52k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eilGY03nUQhREWra+rFcS2pcHVo76wkkZk1TW42yDH9MOCP8z0eT+O6WcxfN/MXSPupLEHaH3SIGzJAKvDilG8LVE9XBw1+dqVz3Zxk07y9d78zsETFWcsrp+SsrZEYNqaw3t9eOTVQtoFicYunTyUoqq2jgdOttWNn7/pKFMpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xNgYkbeU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xNgYkbeU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD32C19421;
	Wed,  8 Apr 2026 18:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674358;
	bh=4e6bAS4iCPq1TpaRFTh25HePxJWGG+fyIMYkJAN+52k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xNgYkbeUPAVMvue7HPkRtYUFrrORZGU8HoA/0rutw2/H0uwa8d6HLGVdxvBbmRoa1
	 FTKP95t2Eu1rkjGk05tdKi2U9WFsAi6RLHRb06RfHGkmPovEPoCgyniX2+l6qohXU2
	 ZBxnHLpzkphYJcSmlzqybDPDS1Ag6ZCGPVvxuBRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 065/311] net: introduce mangleid_features
Date: Wed,  8 Apr 2026 20:01:05 +0200
Message-ID: <20260408175941.843956623@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 31c5a71d982b57df75858974634c2f0a338f2fc6 ]

Some/most devices implementing gso_partial need to disable the GSO partial
features when the IP ID can't be mangled; to that extend each of them
implements something alike the following[1]:

	if (skb->encapsulation && !(features & NETIF_F_TSO_MANGLEID))
		features &= ~NETIF_F_TSO;

in the ndo_features_check() op, which leads to a bit of duplicate code.

Later patch in the series will implement GSO partial support for virtual
devices, and the current status quo will require more duplicate code and
a new indirect call in the TX path for them.

Introduce the mangleid_features mask, allowing the core to disable NIC
features based on/requiring MANGLEID, without any further intervention
from the driver.

The same functionality could be alternatively implemented adding a single
boolean flag to the struct net_device, but would require an additional
checks in ndo_features_check().

Also note that [1] is incorrect if the NIC additionally implements
NETIF_F_GSO_UDP_L4, mangleid_features transparently handle even such a
case.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/5a7cdaeea40b0a29b88e525b6c942d73ed3b8ce7.1769011015.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: ddc748a391dd ("net: use skb_header_pointer() for TCPv4 GSO frag_off check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 3 +++
 net/core/dev.c            | 5 ++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 1216f050f0699..846afec74703b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1833,6 +1833,8 @@ enum netdev_reg_state {
  *
  *	@mpls_features:	Mask of features inheritable by MPLS
  *	@gso_partial_features: value(s) from NETIF_F_GSO\*
+ *	@mangleid_features:	Mask of features requiring MANGLEID, will be
+ *				disabled together with the latter.
  *
  *	@ifindex:	interface index
  *	@group:		The group the device belongs to
@@ -2222,6 +2224,7 @@ struct net_device {
 	netdev_features_t	vlan_features;
 	netdev_features_t	hw_enc_features;
 	netdev_features_t	mpls_features;
+	netdev_features_t	mangleid_features;
 
 	unsigned int		min_mtu;
 	unsigned int		max_mtu;
diff --git a/net/core/dev.c b/net/core/dev.c
index b5f0d5c4d5412..8439bac371b7d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3819,7 +3819,7 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 				    inner_ip_hdr(skb) : ip_hdr(skb);
 
 		if (!(iph->frag_off & htons(IP_DF)))
-			features &= ~NETIF_F_TSO_MANGLEID;
+			features &= ~dev->mangleid_features;
 	}
 
 	/* NETIF_F_IPV6_CSUM does not support IPv6 extension headers,
@@ -11411,6 +11411,9 @@ int register_netdevice(struct net_device *dev)
 	if (dev->hw_enc_features & NETIF_F_TSO)
 		dev->hw_enc_features |= NETIF_F_TSO_MANGLEID;
 
+	/* TSO_MANGLEID belongs in mangleid_features by definition */
+	dev->mangleid_features |= NETIF_F_TSO_MANGLEID;
+
 	/* Make NETIF_F_HIGHDMA inheritable to VLAN devices.
 	 */
 	dev->vlan_features |= NETIF_F_HIGHDMA;
-- 
2.53.0



