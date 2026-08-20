Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70A146F483;
	Thu, 20 Aug 2026 17:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247769; cv=none; b=UY2gabGE2Ibm5HAVoqWXDkpWffszpIaxpl09mV+Hy2FuNA/erwucPqPpW3rFUsFdaTboHqxquSwVdSkmea5bItX5lYT1qUT+kJCxfyFRsORnON6QANwwMA8q6D43Fk3hOTNwwmm2+NAO11WD67dUwc5AjA5JI7AVmEXJKi2jZI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247769; c=relaxed/simple;
	bh=dvOWlktlKKpXcm1vgXkSvaWDQYnucMDCZrKrvN4jQDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlpDkXW0K5n/WpSkpcZ8t2MO0087LYUCUfbrDBsFmQhdbY6Lb2gskrTsPAKBm31xrUYXjdOK0CdlD2t5GLc3i2NPLrMu6Bv/dw2n31Wxlqjhf8DjVWBM/KoHhNAR9KoREcK9JIrwbf6i/Y58uktsy+g+UzcE5YvdQi7WNaVETf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VmkfVgaG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VmkfVgaG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B101F000E9;
	Thu, 20 Aug 2026 17:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247767;
	bh=EaqXLxlq9BI9nZ+h1BqCz4rpQSERxh7PxfGVyAi0Ih0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VmkfVgaG/q/wMT1AtblnlkdQCV8oiosbYYWNGPBaMDFLQmZ6q+VTSitHrYqxAo93R
	 soxfUogV0n8oFI25aUNYBOT8UcpPpYccKWNYiK9AWMGvJVyh3bktvJwOp3vmyQcM3S
	 GzcfhTYx7v54KhDHdx71CBX7JrmnEm16P4Q6Ijl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 123/166] vxlan: use pskb_network_may_pull() for transmit path header pulls
Date: Thu, 20 Aug 2026 16:56:22 +0200
Message-ID: <20260820145214.864804488@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b9553558b48db54ac9273e6b98d7263ef5c1a329 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan/vxlan_core.c |    6 +++---
 drivers/net/vxlan/vxlan_mdb.c  |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1857,7 +1857,7 @@ static int arp_reduce(struct net_device
 	if (dev->flags & IFF_NOARP)
 		goto out;
 
-	if (!pskb_may_pull(skb, arp_hdr_len(dev))) {
+	if (!pskb_network_may_pull(skb, arp_hdr_len(dev))) {
 		dev_dstats_tx_dropped(dev);
 		vxlan_vnifilter_count(vxlan, vni, NULL,
 				      VXLAN_VNI_STATS_TX_DROPS, 0);
@@ -2831,8 +2831,8 @@ static netdev_tx_t vxlan_xmit(struct sk_
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
@@ -1326,7 +1326,7 @@ struct vxlan_mdb_entry *vxlan_mdb_entry_
 
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
-		if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+		if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
 			return NULL;
 		group.dst.sa.sa_family = AF_INET;
 		group.dst.sin.sin_addr.s_addr = ip_hdr(skb)->daddr;
@@ -1335,7 +1335,7 @@ struct vxlan_mdb_entry *vxlan_mdb_entry_
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case htons(ETH_P_IPV6):
-		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
+		if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
 			return NULL;
 		group.dst.sa.sa_family = AF_INET6;
 		group.dst.sin6.sin6_addr = ipv6_hdr(skb)->daddr;


