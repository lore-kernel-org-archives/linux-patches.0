Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4BE37755D;
	Tue, 17 Feb 2026 20:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360894; cv=none; b=HNruWFhTbWJMnpoZp9rCiUvTh+Wihn4TaqFbDlcDPTGVKnpuOHDMh/2N2o31aou1NctIlTBXa9RCWFDJbqsM2s3WUapQmkWvqo19nJK0Q4RLZkHZY+roNqKm6MvbPUMGVFjUnUgNDOuOGI+jVCul7hDx3sfnk9SDNEmOR23p2C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360894; c=relaxed/simple;
	bh=Vm8yBriRfyLbwLD7o+/3dHW/PD8B04MT4VLebiMC1Hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJZOJvMv+M+N0Rmq9+1qfBu3WdDvMQOxOtwqESZ02iGt6anqi/ikU1VNcM5ei4WhXKOsTe0t3kI58kYlBRKMQaQzraPEC1uVnyiNNbmalR4dyfOsSKullSygtXcsAHhoV1Cci0tjq6PM1M4upGrieZbZzGFIzkFa9ZxCwxBKywk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQ0wM4UB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQ0wM4UB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40BEC4CEF7;
	Tue, 17 Feb 2026 20:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771360894;
	bh=Vm8yBriRfyLbwLD7o+/3dHW/PD8B04MT4VLebiMC1Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQ0wM4UBdPvJCRZyyQhtS3iumezxbgEwSuDcsRJb9OppzJ3FZ9Xz+0Z9GSVvhoNID
	 VWQZ1ml7rcdH4I4lE28e1J1URt2u2eDqossexdboCQn2uk8lapKEVL7l0fIVH+5Vfi
	 Ym3o+sTW+fpzF0qyieeVTWj+2YpWbsC20wp/5Bi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <dongml2@chinatelecom.cn>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 39/39] net: tunnel: make skb_vlan_inet_prepare() return drop reasons
Date: Tue, 17 Feb 2026 21:31:01 +0100
Message-ID: <20260217200005.711817490@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200004.221651386@linuxfoundation.org>
References: <20260217200004.221651386@linuxfoundation.org>
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

From: Menglong Dong <menglong8.dong@gmail.com>

[ Upstream commit 9990ddf47d4168088e2246c3d418bf526e40830d ]

Make skb_vlan_inet_prepare return the skb drop reasons, which is just
what pskb_may_pull_reason() returns. Meanwhile, adjust all the call of
it.

Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bareudp.c    |  4 ++--
 drivers/net/geneve.c     |  4 ++--
 include/net/ip_tunnels.h | 13 ++++++++-----
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 54767154de265..cfbc0240126ef 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -319,7 +319,7 @@ static int bareudp_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be32 saddr;
 	int err;
 
-	if (!skb_vlan_inet_prepare(skb, skb->protocol != htons(ETH_P_TEB)))
+	if (skb_vlan_inet_prepare(skb, skb->protocol != htons(ETH_P_TEB)))
 		return -EINVAL;
 
 	if (!sock)
@@ -385,7 +385,7 @@ static int bareudp6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be16 sport;
 	int err;
 
-	if (!skb_vlan_inet_prepare(skb, skb->protocol != htons(ETH_P_TEB)))
+	if (skb_vlan_inet_prepare(skb, skb->protocol != htons(ETH_P_TEB)))
 		return -EINVAL;
 
 	if (!sock)
diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 27761334e1bff..33dae09f7fb22 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -927,7 +927,7 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be16 sport;
 	int err;
 
-	if (!skb_vlan_inet_prepare(skb, inner_proto_inherit))
+	if (skb_vlan_inet_prepare(skb, inner_proto_inherit))
 		return -EINVAL;
 
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
@@ -1026,7 +1026,7 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be16 sport;
 	int err;
 
-	if (!skb_vlan_inet_prepare(skb, inner_proto_inherit))
+	if (skb_vlan_inet_prepare(skb, inner_proto_inherit))
 		return -EINVAL;
 
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 3d36794cb1899..1051af74285c5 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -362,11 +362,12 @@ static inline bool pskb_inet_may_pull(struct sk_buff *skb)
 
 /* Variant of pskb_inet_may_pull().
  */
-static inline bool skb_vlan_inet_prepare(struct sk_buff *skb,
-					 bool inner_proto_inherit)
+static inline enum skb_drop_reason
+skb_vlan_inet_prepare(struct sk_buff *skb, bool inner_proto_inherit)
 {
 	int nhlen = 0, maclen = inner_proto_inherit ? 0 : ETH_HLEN;
 	__be16 type = skb->protocol;
+	enum skb_drop_reason reason;
 
 	/* Essentially this is skb_protocol(skb, true)
 	 * And we get MAC len.
@@ -387,11 +388,13 @@ static inline bool skb_vlan_inet_prepare(struct sk_buff *skb,
 	/* For ETH_P_IPV6/ETH_P_IP we make sure to pull
 	 * a base network header in skb->head.
 	 */
-	if (!pskb_may_pull(skb, maclen + nhlen))
-		return false;
+	reason = pskb_may_pull_reason(skb, maclen + nhlen);
+	if (reason)
+		return reason;
 
 	skb_set_network_header(skb, maclen);
-	return true;
+
+	return SKB_NOT_DROPPED_YET;
 }
 
 static inline int ip_encap_hlen(struct ip_tunnel_encap *e)
-- 
2.51.0



