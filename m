Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8902AF15;
	Tue, 10 Sep 2024 10:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965140; cv=none; b=nWZL9UJ1T6ByeCEkRS1eohAEwhtiF9cAuXhKkXMFNwmJoh+1zsQejfykh1nT3oDriSnT3RGLZOK8k0pfAApsnya67/gZeDf28D/a+x5zvtHMhp3HWv8NA5mY/vuujvg2Ze1kMU/5YZ/IXo/2X+k5bBurMzo5RtYBZv54zXrQaGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965140; c=relaxed/simple;
	bh=wKgyaSBCg5NI0rxzqjJ4M81znozMQ/KO5JKvSL5tILQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFwh80KdhWBBEa1g+GTEF2g/uqsQFRJwMdlyHFIQFrcFL7wuDY2Irba5TCgx9YZ/Zda+uqZKANnxmtIuWLQGZWF6nmDWPrXgKHkW6KYkSS1WUN5cqBKb6wFm3VV1gvYzx/3S1iuE8VO9c9j0tuIEqX1HNVFJUIwHX+Sw0DBhUOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ohm82d9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ohm82d9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D09C4CEC3;
	Tue, 10 Sep 2024 10:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965140;
	bh=wKgyaSBCg5NI0rxzqjJ4M81znozMQ/KO5JKvSL5tILQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ohm82d9DEwL2Pf1R4ti3qi9nnnwZ6O9kbnB0wuky6Uxc/0Jrvn5eMSE2C1/rOi5q
	 Qs1zboZXh9mmYrdqKrhXxxEypnkD4ONsDLdGyA1/IZF/iao8Eqvhvgk4uV66U7mwXE
	 ThKabTK/4Jp3V8bnBf3J9YobWAC8T16a13ALnuns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 123/186] gro: remove rcu_read_lock/rcu_read_unlock from gro_receive handlers
Date: Tue, 10 Sep 2024 11:33:38 +0200
Message-ID: <20240910092559.643591772@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit fc1ca3348a74a1afaa7ffebc2b2f2cc149e11278 ]

All gro_receive() handlers are called from dev_gro_receive()
while rcu_read_lock() has been called.

There is no point stacking more rcu_read_lock()

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 7e4196935069 ("fou: Fix null-ptr-deref in GRO.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/geneve.c   |  5 +----
 net/8021q/vlan_core.c  |  5 +----
 net/ethernet/eth.c     |  5 +----
 net/ipv4/af_inet.c     | 12 ++++--------
 net/ipv4/fou.c         | 12 +++---------
 net/ipv4/gre_offload.c |  9 +++------
 net/ipv4/udp_offload.c |  2 --
 net/ipv6/ip6_offload.c |  6 +-----
 net/ipv6/udp_offload.c |  2 --
 9 files changed, 14 insertions(+), 44 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index af35361a3dce..17989688f54b 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -528,18 +528,15 @@ static struct sk_buff *geneve_gro_receive(struct sock *sk,
 
 	type = gh->proto_type;
 
-	rcu_read_lock();
 	ptype = gro_find_receive_by_type(type);
 	if (!ptype)
-		goto out_unlock;
+		goto out;
 
 	skb_gro_pull(skb, gh_len);
 	skb_gro_postpull_rcsum(skb, gh, gh_len);
 	pp = call_gro_receive(ptype->callbacks.gro_receive, head, skb);
 	flush = 0;
 
-out_unlock:
-	rcu_read_unlock();
 out:
 	skb_gro_flush_final(skb, pp, flush);
 
diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
index 43aea97c5762..ff0d3fc82c0f 100644
--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -482,10 +482,9 @@ static struct sk_buff *vlan_gro_receive(struct list_head *head,
 
 	type = vhdr->h_vlan_encapsulated_proto;
 
-	rcu_read_lock();
 	ptype = gro_find_receive_by_type(type);
 	if (!ptype)
-		goto out_unlock;
+		goto out;
 
 	flush = 0;
 
@@ -504,8 +503,6 @@ static struct sk_buff *vlan_gro_receive(struct list_head *head,
 	skb_gro_postpull_rcsum(skb, vhdr, sizeof(*vhdr));
 	pp = call_gro_receive(ptype->callbacks.gro_receive, head, skb);
 
-out_unlock:
-	rcu_read_unlock();
 out:
 	skb_gro_flush_final(skb, pp, flush);
 
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 61cb40368723..2b0eb24199d6 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -430,19 +430,16 @@ struct sk_buff *eth_gro_receive(struct list_head *head, struct sk_buff *skb)
 
 	type = eh->h_proto;
 
-	rcu_read_lock();
 	ptype = gro_find_receive_by_type(type);
 	if (ptype == NULL) {
 		flush = 1;
-		goto out_unlock;
+		goto out;
 	}
 
 	skb_gro_pull(skb, sizeof(*eh));
 	skb_gro_postpull_rcsum(skb, eh, sizeof(*eh));
 	pp = call_gro_receive(ptype->callbacks.gro_receive, head, skb);
 
-out_unlock:
-	rcu_read_unlock();
 out:
 	skb_gro_flush_final(skb, pp, flush);
 
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index ce42626663de..cac63bb20c16 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1471,19 +1471,18 @@ struct sk_buff *inet_gro_receive(struct list_head *head, struct sk_buff *skb)
 
 	proto = iph->protocol;
 
-	rcu_read_lock();
 	ops = rcu_dereference(inet_offloads[proto]);
 	if (!ops || !ops->callbacks.gro_receive)
-		goto out_unlock;
+		goto out;
 
 	if (*(u8 *)iph != 0x45)
-		goto out_unlock;
+		goto out;
 
 	if (ip_is_fragment(iph))
-		goto out_unlock;
+		goto out;
 
 	if (unlikely(ip_fast_csum((u8 *)iph, 5)))
-		goto out_unlock;
+		goto out;
 
 	id = ntohl(*(__be32 *)&iph->id);
 	flush = (u16)((ntohl(*(__be32 *)iph) ^ skb_gro_len(skb)) | (id & ~IP_DF));
@@ -1560,9 +1559,6 @@ struct sk_buff *inet_gro_receive(struct list_head *head, struct sk_buff *skb)
 	pp = indirect_call_gro_receive(tcp4_gro_receive, udp4_gro_receive,
 				       ops->callbacks.gro_receive, head, skb);
 
-out_unlock:
-	rcu_read_unlock();
-
 out:
 	skb_gro_flush_final(skb, pp, flush);
 
diff --git a/net/ipv4/fou.c b/net/ipv4/fou.c
index 8fcbc6258ec5..5aacc75e495c 100644
--- a/net/ipv4/fou.c
+++ b/net/ipv4/fou.c
@@ -246,17 +246,14 @@ static struct sk_buff *fou_gro_receive(struct sock *sk,
 	/* Flag this frame as already having an outer encap header */
 	NAPI_GRO_CB(skb)->is_fou = 1;
 
-	rcu_read_lock();
 	offloads = NAPI_GRO_CB(skb)->is_ipv6 ? inet6_offloads : inet_offloads;
 	ops = rcu_dereference(offloads[proto]);
 	if (!ops || !ops->callbacks.gro_receive)
-		goto out_unlock;
+		goto out;
 
 	pp = call_gro_receive(ops->callbacks.gro_receive, head, skb);
 
-out_unlock:
-	rcu_read_unlock();
-
+out:
 	return pp;
 }
 
@@ -438,17 +435,14 @@ static struct sk_buff *gue_gro_receive(struct sock *sk,
 	/* Flag this frame as already having an outer encap header */
 	NAPI_GRO_CB(skb)->is_fou = 1;
 
-	rcu_read_lock();
 	offloads = NAPI_GRO_CB(skb)->is_ipv6 ? inet6_offloads : inet_offloads;
 	ops = rcu_dereference(offloads[proto]);
 	if (WARN_ON_ONCE(!ops || !ops->callbacks.gro_receive))
-		goto out_unlock;
+		goto out;
 
 	pp = call_gro_receive(ops->callbacks.gro_receive, head, skb);
 	flush = 0;
 
-out_unlock:
-	rcu_read_unlock();
 out:
 	skb_gro_flush_final_remcsum(skb, pp, flush, &grc);
 
diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
index e0a246575887..e9dabf1affe9 100644
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -158,10 +158,9 @@ static struct sk_buff *gre_gro_receive(struct list_head *head,
 
 	type = greh->protocol;
 
-	rcu_read_lock();
 	ptype = gro_find_receive_by_type(type);
 	if (!ptype)
-		goto out_unlock;
+		goto out;
 
 	grehlen = GRE_HEADER_SECTION;
 
@@ -175,13 +174,13 @@ static struct sk_buff *gre_gro_receive(struct list_head *head,
 	if (skb_gro_header_hard(skb, hlen)) {
 		greh = skb_gro_header_slow(skb, hlen, off);
 		if (unlikely(!greh))
-			goto out_unlock;
+			goto out;
 	}
 
 	/* Don't bother verifying checksum if we're going to flush anyway. */
 	if ((greh->flags & GRE_CSUM) && !NAPI_GRO_CB(skb)->flush) {
 		if (skb_gro_checksum_simple_validate(skb))
-			goto out_unlock;
+			goto out;
 
 		skb_gro_checksum_try_convert(skb, IPPROTO_GRE,
 					     null_compute_pseudo);
@@ -225,8 +224,6 @@ static struct sk_buff *gre_gro_receive(struct list_head *head,
 	pp = call_gro_receive(ptype->callbacks.gro_receive, head, skb);
 	flush = 0;
 
-out_unlock:
-	rcu_read_unlock();
 out:
 	skb_gro_flush_final(skb, pp, flush);
 
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 57168d4fa195..418da7a8a075 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -606,13 +606,11 @@ struct sk_buff *udp4_gro_receive(struct list_head *head, struct sk_buff *skb)
 					     inet_gro_compute_pseudo);
 skip:
 	NAPI_GRO_CB(skb)->is_ipv6 = 0;
-	rcu_read_lock();
 
 	if (static_branch_unlikely(&udp_encap_needed_key))
 		sk = udp4_gro_lookup_skb(skb, uh->source, uh->dest);
 
 	pp = udp_gro_receive(head, skb, uh, sk);
-	rcu_read_unlock();
 	return pp;
 
 flush:
diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index 15c8eef1ef44..f67921e0dd56 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -209,7 +209,6 @@ INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
 
 	flush += ntohs(iph->payload_len) != skb_gro_len(skb);
 
-	rcu_read_lock();
 	proto = iph->nexthdr;
 	ops = rcu_dereference(inet6_offloads[proto]);
 	if (!ops || !ops->callbacks.gro_receive) {
@@ -222,7 +221,7 @@ INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
 
 		ops = rcu_dereference(inet6_offloads[proto]);
 		if (!ops || !ops->callbacks.gro_receive)
-			goto out_unlock;
+			goto out;
 
 		iph = ipv6_hdr(skb);
 	}
@@ -280,9 +279,6 @@ INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
 	pp = indirect_call_gro_receive_l4(tcp6_gro_receive, udp6_gro_receive,
 					 ops->callbacks.gro_receive, head, skb);
 
-out_unlock:
-	rcu_read_unlock();
-
 out:
 	skb_gro_flush_final(skb, pp, flush);
 
diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index 7752e1e921f8..1107782c083d 100644
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -144,13 +144,11 @@ struct sk_buff *udp6_gro_receive(struct list_head *head, struct sk_buff *skb)
 
 skip:
 	NAPI_GRO_CB(skb)->is_ipv6 = 1;
-	rcu_read_lock();
 
 	if (static_branch_unlikely(&udpv6_encap_needed_key))
 		sk = udp6_gro_lookup_skb(skb, uh->source, uh->dest);
 
 	pp = udp_gro_receive(head, skb, uh, sk);
-	rcu_read_unlock();
 	return pp;
 
 flush:
-- 
2.43.0



