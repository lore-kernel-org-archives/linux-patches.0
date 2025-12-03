Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960D33126C7;
	Wed,  3 Dec 2025 16:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777786; cv=none; b=BGnbh0Zk+cz18NhpKdkly+/9ed2KGc24ClNHt7gjksuBTtdz25NC81eA59KlsfIF5L/K5FebmxkqpUU9xwHkk6Bt2xM8yY5gEUFQvD3cBavI3DiBBgkYn1TERkj0szI8rMFDTtgPX+Jmtn7s0+JrN9t8wqJBMXjTVRwiH9J1QYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777786; c=relaxed/simple;
	bh=11qrLR5ZzU8xFJOQol8NctcNsUhyYEUbo++8CNo4Vb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zz+iv2g/tAAmgqEZtAF0rRkxoNOwo0oohA4eW3cRmH8tFUij+4oRiTvSAbWWWW7M+qeOGbBGOCFgqO+67jZB6KZGLoZSCqhniao4+hwQWp0nA3gxLIuuUyUMqMUOi5noHQaEWJH/qeWAtm8Iy6QM/x4MAuqH/34Kj1LHpkYJKx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qHSP8Hzc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qHSP8Hzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212A1C4CEF5;
	Wed,  3 Dec 2025 16:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777786;
	bh=11qrLR5ZzU8xFJOQol8NctcNsUhyYEUbo++8CNo4Vb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qHSP8Hzc5nmuP9ZAwvChH7NCv6xeeV2/0ZH3VcjoWSKumOVPnFS67wtnmt+7EbF0D
	 WZGw8vfbF0u43AtEs/KTyAu6oyv9TFoJaI/7LWWUYEsFibutNY6t69xcPO0lMNLCnU
	 80u3pnRLic232kNGDWMv/i7CD0/J3S30P9DsSsCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 147/392] netfilter: nf_reject: dont reply to icmp error messages
Date: Wed,  3 Dec 2025 16:24:57 +0100
Message-ID: <20251203152419.493742446@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit db99b2f2b3e2cd8227ac9990ca4a8a31a1e95e56 ]

tcp reject code won't reply to a tcp reset.

But the icmp reject 'netdev' family versions will reply to icmp
dst-unreach errors, unlike icmp_send() and icmp6_send() which are used
by the inet family implementation (and internally by the REJECT target).

Check for the icmp(6) type and do not respond if its an unreachable error.

Without this, something like 'ip protocol icmp reject', when used
in a netdev chain attached to 'lo', cause a packet loop.

Same for two hosts that both use such a rule: each error packet
will be replied to.

Such situation persist until the (bogus) rule is amended to ratelimit or
checks the icmp type before the reject statement.

As the inet versions don't do this make the netdev ones follow along.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 25 ++++++++++++++++++++++++
 net/ipv6/netfilter/nf_reject_ipv6.c | 30 +++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index c1f5ca847c8a8..4d16d49b430e9 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -71,6 +71,27 @@ struct sk_buff *nf_reject_skb_v4_tcp_reset(struct net *net,
 }
 EXPORT_SYMBOL_GPL(nf_reject_skb_v4_tcp_reset);
 
+static bool nf_skb_is_icmp_unreach(const struct sk_buff *skb)
+{
+	const struct iphdr *iph = ip_hdr(skb);
+	u8 *tp, _type;
+	int thoff;
+
+	if (iph->protocol != IPPROTO_ICMP)
+		return false;
+
+	thoff = skb_network_offset(skb) + sizeof(*iph);
+
+	tp = skb_header_pointer(skb,
+				thoff + offsetof(struct icmphdr, type),
+				sizeof(_type), &_type);
+
+	if (!tp)
+		return false;
+
+	return *tp == ICMP_DEST_UNREACH;
+}
+
 struct sk_buff *nf_reject_skb_v4_unreach(struct net *net,
 					 struct sk_buff *oldskb,
 					 const struct net_device *dev,
@@ -90,6 +111,10 @@ struct sk_buff *nf_reject_skb_v4_unreach(struct net *net,
 	if (ip_hdr(oldskb)->frag_off & htons(IP_OFFSET))
 		return NULL;
 
+	/* don't reply to ICMP_DEST_UNREACH with ICMP_DEST_UNREACH. */
+	if (nf_skb_is_icmp_unreach(oldskb))
+		return NULL;
+
 	/* RFC says return as much as we can without exceeding 576 bytes. */
 	len = min_t(unsigned int, 536, oldskb->len);
 
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index ca39b83c2a5d1..e209e8ca0c1cf 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -91,6 +91,32 @@ struct sk_buff *nf_reject_skb_v6_tcp_reset(struct net *net,
 }
 EXPORT_SYMBOL_GPL(nf_reject_skb_v6_tcp_reset);
 
+static bool nf_skb_is_icmp6_unreach(const struct sk_buff *skb)
+{
+	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
+	u8 proto = ip6h->nexthdr;
+	u8 _type, *tp;
+	int thoff;
+	__be16 fo;
+
+	thoff = ipv6_skip_exthdr(skb, ((u8 *)(ip6h + 1) - skb->data), &proto, &fo);
+
+	if (thoff < 0 || thoff >= skb->len || fo != 0)
+		return false;
+
+	if (proto != IPPROTO_ICMPV6)
+		return false;
+
+	tp = skb_header_pointer(skb,
+				thoff + offsetof(struct icmp6hdr, icmp6_type),
+				sizeof(_type), &_type);
+
+	if (!tp)
+		return false;
+
+	return *tp == ICMPV6_DEST_UNREACH;
+}
+
 struct sk_buff *nf_reject_skb_v6_unreach(struct net *net,
 					 struct sk_buff *oldskb,
 					 const struct net_device *dev,
@@ -104,6 +130,10 @@ struct sk_buff *nf_reject_skb_v6_unreach(struct net *net,
 	if (!nf_reject_ip6hdr_validate(oldskb))
 		return NULL;
 
+	/* Don't reply to ICMPV6_DEST_UNREACH with ICMPV6_DEST_UNREACH */
+	if (nf_skb_is_icmp6_unreach(oldskb))
+		return NULL;
+
 	/* Include "As much of invoking packet as possible without the ICMPv6
 	 * packet exceeding the minimum IPv6 MTU" in the ICMP payload.
 	 */
-- 
2.51.0



