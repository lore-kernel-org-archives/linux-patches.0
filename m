Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DE2282F35;
	Mon, 23 Mar 2026 16:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282909; cv=none; b=fe/UjLYN51lMGCP6GZYcHxdL7QqmwTfRv9g6eD04TQDKfGX9q/M1FYzE5rq3Cy7Ekpp4b0f/iPhw9tNhW6s5JUAVTH6WgIEv9QiNYqCIdfoK1qvvtkbYfeAafZGM+rvheHRN6ic1yBN9cZYfq4vy1YQwHeDeL6Qnt+iLImhBaCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282909; c=relaxed/simple;
	bh=L0Jm6wduFaczRQjIYdistB0U8zFZWuFZearJlnzQhX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nwfc1mUN9Vtj1QApOulBtx9cx9dkH3NKq5kTbG+BUu2fnsa/08hSEf7OmYQHIu56sNmFQ7GtNM2rlTBO0iAEdbTYWjdbZ42H50Avir6H3vR7mlL0zV5QOdw+R18rmpOLl+sFO5dDPsZERQJv4o0wXJOduS+W5jvB6MSj9U6L9rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x2bPFrqk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x2bPFrqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290DEC4CEF7;
	Mon, 23 Mar 2026 16:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282909;
	bh=L0Jm6wduFaczRQjIYdistB0U8zFZWuFZearJlnzQhX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x2bPFrqkf8jC5q8ykn3/SfIUJ5xArDCq0JSbCDx2y7ggfL2SKcFeRNIN9dPi5zA/l
	 JfjFCRNbYZV/ejT/zjX7anMT0r/QCU3NgsUKjIvU/eLsFI4fuRKdolo5wfoSXUberq
	 QRUzH+OjGf+CwLw7bhOXX4BlEvC/1xUj94XoPeZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Keerthana K <keerthana.kalyanasundaram@broadcom.com>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 6.1 277/481] ipv6: use RCU in ip6_xmit()
Date: Mon, 23 Mar 2026 14:44:19 +0100
Message-ID: <20260323134531.871590100@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit 9085e56501d93af9f2d7bd16f7fcfacdde47b99c upstream.

Use RCU in ip6_xmit() in order to use dst_dev_rcu() to prevent
possible UAF.

Fixes: 4a6ce2b6f2ec ("net: introduce a new function dst_dev_put()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250828195823.3958522-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
---
 net/ipv6/ip6_output.c |   35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -258,35 +258,36 @@ bool ip6_autoflowlabel(struct net *net,
 int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
 	     __u32 mark, struct ipv6_txoptions *opt, int tclass, u32 priority)
 {
-	struct net *net = sock_net(sk);
 	const struct ipv6_pinfo *np = inet6_sk(sk);
 	struct in6_addr *first_hop = &fl6->daddr;
 	struct dst_entry *dst = skb_dst(skb);
-	struct net_device *dev = dst->dev;
 	struct inet6_dev *idev = ip6_dst_idev(dst);
 	struct hop_jumbo_hdr *hop_jumbo;
 	int hoplen = sizeof(*hop_jumbo);
+	struct net *net = sock_net(sk);
 	unsigned int head_room;
+	struct net_device *dev;
 	struct ipv6hdr *hdr;
 	u8  proto = fl6->flowi6_proto;
 	int seg_len = skb->len;
-	int hlimit = -1;
+	int ret, hlimit = -1;
 	u32 mtu;
 
+	rcu_read_lock();
+
+	dev = dst_dev_rcu(dst);
 	head_room = sizeof(struct ipv6hdr) + hoplen + LL_RESERVED_SPACE(dev);
 	if (opt)
 		head_room += opt->opt_nflen + opt->opt_flen;
 
 	if (unlikely(head_room > skb_headroom(skb))) {
-		/* Make sure idev stays alive */
-		rcu_read_lock();
+		/* idev stays alive while we hold rcu_read_lock(). */
 		skb = skb_expand_head(skb, head_room);
 		if (!skb) {
 			IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARDS);
-			rcu_read_unlock();
-			return -ENOBUFS;
+			ret = -ENOBUFS;
+			goto unlock;
 		}
-		rcu_read_unlock();
 	}
 
 	if (opt) {
@@ -348,17 +349,21 @@ int ip6_xmit(const struct sock *sk, stru
 		 * skb to its handler for processing
 		 */
 		skb = l3mdev_ip6_out((struct sock *)sk, skb);
-		if (unlikely(!skb))
-			return 0;
+		if (unlikely(!skb)) {
+			ret = 0;
+			goto unlock;
+		}
 
 		/* hooks should never assume socket lock is held.
 		 * we promote our socket to non const
 		 */
-		return NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_OUT,
-			       net, (struct sock *)sk, skb, NULL, dev,
-			       dst_output);
+		ret = NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_OUT,
+			      net, (struct sock *)sk, skb, NULL, dev,
+			      dst_output);
+		goto unlock;
 	}
 
+	ret = -EMSGSIZE;
 	skb->dev = dev;
 	/* ipv6_local_error() does not require socket lock,
 	 * we promote our socket to non const
@@ -367,7 +372,9 @@ int ip6_xmit(const struct sock *sk, stru
 
 	IP6_INC_STATS(net, idev, IPSTATS_MIB_FRAGFAILS);
 	kfree_skb(skb);
-	return -EMSGSIZE;
+unlock:
+	rcu_read_unlock();
+	return ret;
 }
 EXPORT_SYMBOL(ip6_xmit);
 


