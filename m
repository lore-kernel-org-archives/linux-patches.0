Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8819A306B39;
	Tue, 11 Nov 2025 01:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823873; cv=none; b=PMHFMzCwrqUyMlYEwEL+1AQ0sbQOGRffbFyM1nSHVE9QmyUj+FmaZQ3DJuc44DK0VpIbF3cK3x0DHKMv0obO3ziCIaJsqr0GR4esMzC+XUEAs+gWOn0Cv5/na0Uqit9ppqF9UOyJHclGq9wLab0qNinewOiafrxxw9F7vfpmqKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823873; c=relaxed/simple;
	bh=0puMK1jm214Pr9X9H9ZaB/thqip84pezsEQLdIVI0xE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrmygwUdW6kASz2GDXEvgB0DKf977c+2vWCE99J9kqBgyJx5P7dODaPxYN97iBLb4eLdG24IZNOXK+r8c9h0bkoB1xy47zdaLCq9Qi3RBq+d1vS5zTx9ErOaTQqdPkQOi91/7TxL2kQ8oMTDgxrIASN6DBOGlAV4esRAK8EymZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jz0FLj+x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jz0FLj+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06917C113D0;
	Tue, 11 Nov 2025 01:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823873;
	bh=0puMK1jm214Pr9X9H9ZaB/thqip84pezsEQLdIVI0xE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jz0FLj+xbNCDseYy1pFrGTDweGmmOfcHrpwORE8QG1IhyNA5KzOa21vpBgjzRYX2d
	 vhvFap89mMtQv9l8EFvVVXpE/3pyb2VwJc3XInQW9I29mhYxnMTqflogCab8iut46g
	 O8/+YrmwY0yaKIuK7k9NlpwNP2imGGyEPWeszik8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 341/565] netfilter: nf_reject: dont reply to icmp error messages
Date: Tue, 11 Nov 2025 09:43:17 +0900
Message-ID: <20251111004534.549817347@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 0d3cb2ba6fc84..a7a3439fe7800 100644
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
@@ -91,6 +112,10 @@ struct sk_buff *nf_reject_skb_v4_unreach(struct net *net,
 	if (ip_hdr(oldskb)->frag_off & htons(IP_OFFSET))
 		return NULL;
 
+	/* don't reply to ICMP_DEST_UNREACH with ICMP_DEST_UNREACH. */
+	if (nf_skb_is_icmp_unreach(oldskb))
+		return NULL;
+
 	/* RFC says return as much as we can without exceeding 576 bytes. */
 	len = min_t(unsigned int, 536, oldskb->len);
 
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index c3d64c4b69d7d..84afa0cbc9021 100644
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



