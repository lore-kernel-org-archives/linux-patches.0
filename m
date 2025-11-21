Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0118352FAB;
	Fri, 21 Nov 2025 13:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732714; cv=none; b=tb98zfILEVh1e87a+34EQZpTP3i71mbVJtfRwQ+MBBBKakVHhAZ9R4X92eF5kH04+SQQ9gcgZbbJxyKlRlZ/r2o8HgpduAVcEq+lfaTJ2gaSG7V8xdmRlXNy509LbFtKOSBHuBxpAwmHGTEQV3Rr0S8mAHcheNLXQK6gcl0IE8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732714; c=relaxed/simple;
	bh=PKF19zBjoF1S1+6gVjkPW6NvGxG5OVADg+dTmM3NE1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K44udkLq8rKVZsh26PMuLa8+/iIz10q3BmTumiXUTtOInQ2XxFoi1kitg9jKw25Qcrc27KHSlK3LL++JPRUOxIXZi6aWiAaknfH6OkQVSdyU7CjWNyKxZxBqhs9rYfqrew5m+C3jP8/D2ifWEFxmMtuuD9gKjEpvhWYBy47VHbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aan9te2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aan9te2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10344C4CEF1;
	Fri, 21 Nov 2025 13:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732713;
	bh=PKF19zBjoF1S1+6gVjkPW6NvGxG5OVADg+dTmM3NE1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aan9te2KPiYNJvbSFV1EPE4OwaDsjh36GimnfDbXUJVl/Z/8uZ98KOKNPGnmDQF05
	 0xICilqWLFjFeKfZWhYFP0TQnxMrU+YSqwuyB5+s05UYqkMa0hcp8JFKds40/Rr67u
	 kPikH+8xcx3eMg7PmAw7vHtBdyUkA34/RjdyAi9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 218/529] netfilter: nf_reject: dont reply to icmp error messages
Date: Fri, 21 Nov 2025 14:08:37 +0100
Message-ID: <20251121130238.771397994@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
index 2d663fe50f876..2064b40130412 100644
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
index f3579bccf0a51..a19ca1907de36 100644
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



