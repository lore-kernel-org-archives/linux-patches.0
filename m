Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6356B3CFF53;
	Thu, 17 Sep 2026 18:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671487; cv=none; b=qjXDNBSIKlrfy5CDhve7vo8qkQcybtfNsOD9NASospQEMbiL37mauc//1M9MRB4F+FJsAJt1XgbojtVrcuIEnzHe3lK+6D4XSQ6w+9EppWHDvl9CvZd5hVOpIyQsJLdT8/sZ1p6PcZi7qmZlkdQFJtkPFYt4Q8alPitaRUDuf8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671487; c=relaxed/simple;
	bh=H3FdN3irCmpP4Pe/bZTdAxx5KNgPBQC8lZoJzeDAPGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNHOM7RXTV5XxyYzOCWDsUNhK1WdPzZDIjxA1z5mEu5S7qusOgcq2JNVHDMqrthAEV6PKofmsz8oxZb5ZldgkmjZR1tQtNSCb9vijmfzwEYg0UMeucJd43QF0DAgF0JnEDjm93RyAdeaqAGPTH1QpcxKsd7NFE0RxLlRpj8nL88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gqs4ItRt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gqs4ItRt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE011F000FF;
	Thu, 17 Sep 2026 18:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671486;
	bh=pDdjGGW2LsLBLjF71kye4M6UDZSl/UtpNHeG10hm+08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gqs4ItRt+hvIuRBGd6PZaMzpMz7PqveAPm7G0f54Pl/3EYmUcAmz62GXJrfLJSDv7
	 5iszSzYvCXEatfov3y05IOKWGtxjNjYAU0V1/q+BvJmWvWzCbMBHvo26pKH4qQCfze
	 Iz+4Us8OqfY2TeAczkl6Ws5CSp7fraLVt1s6vPCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0965/1102] ipv6: add some unlikely()/likely() clauses in ip6_output.c
Date: Thu, 17 Sep 2026 16:15:08 +0100
Message-ID: <20260917151604.898375692@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2855e4925416c5900a9c6cece11f4a2e56bf6e63 ]

1) daddr is unlikely a multicast in ip6_finish_output2().

2) ip6_finish_output_gso_slowpath_drop() should not be called often.

3) ip6_fragment() should not be called often.

4) opt is unlikely to be set.

5) ip6_xmit() and ip6_forward() mostly sends not too big packets.

6) Most __ip6_make_skb() calls are for UDP packets,
   not ICMPV6 ones.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260130210303.3888261-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 870a9e42ecc6 ("tcp: clamp route advmss to TCP_MIN_MSS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_output.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -83,7 +83,7 @@ static int ip6_finish_output2(struct net
 
 	hdr = ipv6_hdr(skb);
 	daddr = &hdr->daddr;
-	if (ipv6_addr_is_multicast(daddr)) {
+	if (unlikely(ipv6_addr_is_multicast(daddr))) {
 		if (!(dev->flags & IFF_LOOPBACK) && sk_mc_loop(sk) &&
 		    ((mroute6_is_socket(net, skb) &&
 		     !(IP6CB(skb)->flags & IP6SKB_FORWARDED)) ||
@@ -187,8 +187,8 @@ ip6_finish_output_gso_slowpath_drop(stru
 static int ip6_finish_output_gso(struct net *net, struct sock *sk,
 				 struct sk_buff *skb, unsigned int mtu)
 {
-	if (!(IP6CB(skb)->flags & IP6SKB_FAKEJUMBO) &&
-	    !skb_gso_validate_network_len(skb, mtu))
+	if (unlikely(!(IP6CB(skb)->flags & IP6SKB_FAKEJUMBO) &&
+	    !skb_gso_validate_network_len(skb, mtu)))
 		return ip6_finish_output_gso_slowpath_drop(net, sk, skb, mtu);
 
 	return ip6_finish_output2(net, sk, skb);
@@ -210,8 +210,8 @@ static int __ip6_finish_output(struct ne
 	if (skb_is_gso(skb))
 		return ip6_finish_output_gso(net, sk, skb, mtu);
 
-	if (skb->len > mtu ||
-	    (IP6CB(skb)->frag_max_size && skb->len > IP6CB(skb)->frag_max_size))
+	if (unlikely(skb->len > mtu ||
+	    (IP6CB(skb)->frag_max_size && skb->len > IP6CB(skb)->frag_max_size)))
 		return ip6_fragment(net, sk, skb, ip6_finish_output2);
 
 	return ip6_finish_output2(net, sk, skb);
@@ -301,7 +301,7 @@ int ip6_xmit(const struct sock *sk, stru
 		}
 	}
 
-	if (opt) {
+	if (unlikely(opt)) {
 		seg_len += opt->opt_nflen + opt->opt_flen;
 
 		if (opt->opt_flen)
@@ -354,7 +354,7 @@ int ip6_xmit(const struct sock *sk, stru
 	skb->mark = mark;
 
 	mtu = dst_mtu(dst);
-	if ((skb->len <= mtu) || skb->ignore_df || skb_is_gso(skb)) {
+	if (likely((skb->len <= mtu) || skb->ignore_df || skb_is_gso(skb))) {
 		IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTREQUESTS);
 
 		/* if egress device is enslaved to an L3 master device pass the
@@ -653,7 +653,7 @@ int ip6_forward(struct sk_buff *skb)
 	if (mtu < IPV6_MIN_MTU)
 		mtu = IPV6_MIN_MTU;
 
-	if (ip6_pkt_too_big(skb, mtu)) {
+	if (unlikely(ip6_pkt_too_big(skb, mtu))) {
 		/* Again, force OUTPUT device used as source address */
 		skb->dev = dev;
 		icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
@@ -1365,7 +1365,7 @@ static int ip6_setup_cork(struct sock *s
 	/*
 	 * setup for corking
 	 */
-	if (opt) {
+	if (unlikely(opt)) {
 		if (WARN_ON(v6_cork->opt))
 			return -EINVAL;
 
@@ -1874,7 +1874,7 @@ static void ip6_cork_steal_dst(struct sk
 static void ip6_cork_release(struct inet_cork_full *cork,
 			     struct inet6_cork *v6_cork)
 {
-	if (v6_cork->opt) {
+	if (unlikely(v6_cork->opt)) {
 		struct ipv6_txoptions *opt = v6_cork->opt;
 
 		kfree(opt->dst0opt);
@@ -1930,7 +1930,7 @@ struct sk_buff *__ip6_make_skb(struct so
 	__skb_pull(skb, skb_network_header_len(skb));
 
 	final_dst = &fl6->daddr;
-	if (opt) {
+	if (unlikely(opt)) {
 		if (opt->opt_flen)
 			proto = ipv6_push_frag_opts(skb, opt, proto);
 		if (opt->opt_nflen)
@@ -1958,7 +1958,7 @@ struct sk_buff *__ip6_make_skb(struct so
 
 	ip6_cork_steal_dst(skb, cork);
 	IP6_INC_STATS(net, rt->rt6i_idev, IPSTATS_MIB_OUTREQUESTS);
-	if (proto == IPPROTO_ICMPV6) {
+	if (unlikely(proto == IPPROTO_ICMPV6)) {
 		struct inet6_dev *idev = ip6_dst_idev(skb_dst(skb));
 		u8 icmp6_type;
 


