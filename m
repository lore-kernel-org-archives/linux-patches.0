Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55ED847AF6F;
	Fri,  7 Aug 2026 15:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117536; cv=none; b=ApyLmz3mGqB2mllKtRvccnQ92ctLcuStJKWzEbTEEl1Xa3ExxZJwTwcU8LSM6/YVVwUYB9CMgZXeEOF7o8Ak54IlbuXyODhd8CqFW0Q6z62/G1PT+Y0H2LPxjGR2x10XGthUSuJJq4l/ODO9cUtz9+vZGAW/G7WI4UkpSdzsfE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117536; c=relaxed/simple;
	bh=zmF4jv+I+LptGXpaami6FABm2SPTuUxqrnUvEriG5OE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IpXC4UKiHTS7wzCi2SAPQRj5cL7plU5rSa/z+ZeolULnwpCx5eBJ6f5FtfUHK4XIMpQbKuNxGERDWOsWFejodDSE8lEENIyBEP8VYPSRQrH6R/TwzfSpeLHjVMRYPHVuzGim+Bg1Tn1Xj/dZSkzJWBaPHQxaFD5Tgj6oOtD6+vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D9Yk5Mk5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D9Yk5Mk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A831A1F000E9;
	Fri,  7 Aug 2026 15:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117535;
	bh=3qnufwsN1XBzZ/5HcltHbQ3BbD9U2HIg6Qb7rMKnN4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D9Yk5Mk5WJpLDI4SMxxJO3epuxNc2zPw8GgwzpKnH2ZJ4oBWCFCcciCEqMOvNb7+j
	 IWxawuXzxbNVowTaqgRuye5hY/YzOf0zLBQxue4Vc+ls0iIB4URkFbZoCYA9RGslXK
	 j3rU9Z53N2BGvCv3uQ8iyzT9/BUuIUgY+Fm0JUss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 309/438] vxlan: use pskb_network_may_pull() for transmit path header pulls
Date: Fri,  7 Aug 2026 16:38:25 +0200
Message-ID: <20260807143434.558935649@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit b9553558b48db54ac9273e6b98d7263ef5c1a329 upstream.

In vxlan_xmit(), arp_reduce(), and vxlan_mdb_entry_skb_get(), pskb_may_pull() was
being called to verify the availability of network layer headers (ARP, IPv6/ND,
IP/IPv6 MDB keys).

However, during transmit skb->data points to the MAC header, so skb_network_offset(skb)
is ETH_HLEN (14 bytes). Using pskb_may_pull(skb, len) only checks len bytes from skb->data
rather than skb_network_offset(skb) + len, which can leave part of the network header
in non-linear frags.

Replace these remaining pskb_may_pull() calls with pskb_network_may_pull() to properly
account for the MAC header offset.

Fixes: e4f67addf158 ("add DOVE extensions for VXLAN")
Fixes: f564f45c4518 ("vxlan: add ipv6 proxy support")
Fixes: 0f83e69f44bf ("vxlan: Add MDB data path support")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: stable@vger.kernel.org
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260723144249.759100-6-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan/vxlan_core.c |    6 +++---
 drivers/net/vxlan/vxlan_mdb.c  |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1851,7 +1851,7 @@ static int arp_reduce(struct net_device
 	if (dev->flags & IFF_NOARP)
 		goto out;
 
-	if (!pskb_may_pull(skb, arp_hdr_len(dev))) {
+	if (!pskb_network_may_pull(skb, arp_hdr_len(dev))) {
 		dev_dstats_tx_dropped(dev);
 		vxlan_vnifilter_count(vxlan, vni, NULL,
 				      VXLAN_VNI_STATS_TX_DROPS, 0);
@@ -2764,8 +2764,8 @@ static netdev_tx_t vxlan_xmit(struct sk_
 			return arp_reduce(dev, skb, vni);
 #if IS_ENABLED(CONFIG_IPV6)
 		else if (ntohs(eth->h_proto) == ETH_P_IPV6 &&
-			 pskb_may_pull(skb, sizeof(struct ipv6hdr) +
-					    sizeof(struct nd_msg)) &&
+			 pskb_network_may_pull(skb, sizeof(struct ipv6hdr) +
+						    sizeof(struct nd_msg)) &&
 			 ipv6_hdr(skb)->nexthdr == IPPROTO_ICMPV6) {
 			struct nd_msg *m = (struct nd_msg *)(ipv6_hdr(skb) + 1);
 
--- a/drivers/net/vxlan/vxlan_mdb.c
+++ b/drivers/net/vxlan/vxlan_mdb.c
@@ -1631,7 +1631,7 @@ struct vxlan_mdb_entry *vxlan_mdb_entry_
 
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
-		if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+		if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
 			return NULL;
 		group.dst.sa.sa_family = AF_INET;
 		group.dst.sin.sin_addr.s_addr = ip_hdr(skb)->daddr;
@@ -1640,7 +1640,7 @@ struct vxlan_mdb_entry *vxlan_mdb_entry_
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case htons(ETH_P_IPV6):
-		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
+		if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
 			return NULL;
 		group.dst.sa.sa_family = AF_INET6;
 		group.dst.sin6.sin6_addr = ipv6_hdr(skb)->daddr;


