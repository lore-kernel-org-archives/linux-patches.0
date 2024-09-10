Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141D117BEAD;
	Tue, 10 Sep 2024 10:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963650; cv=none; b=juh3ij1PhQJIs35X1zouHk0ZXuJYkYtFfmE7VEi1ooWP5WclAOXuJIxk1T9fnUIcw7A5BK7V01cDhb49oQwB7Psu99pHbbte/BWAeHOcMRmia5dJ6bUsN17zkNCEHFX9Xo1KBo6G9Mr7wENuVJZRoXf7uFdfKGCSHv3zjv36qlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963650; c=relaxed/simple;
	bh=7KRxNbv0UySSxTuiZYyQiJjzwQPTtSLeq7VeNYfio5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJSCThzWG886cYhjCgQDow4hatLNV1vVFWhJ32uVy6nTl/PnJ2We4u/C6gtONQVzqMgAlkvws4xa1m625lcvYinIIgo7tH1tLBsxty72+28NcVgmMdDTq9BChDT4o/YFB1wQLD59BW2c8NJTZWsirgqnhBlJ1L37KBjoJGkHQIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yT8ZIwEP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yT8ZIwEP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167E3C4CEC3;
	Tue, 10 Sep 2024 10:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963649;
	bh=7KRxNbv0UySSxTuiZYyQiJjzwQPTtSLeq7VeNYfio5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yT8ZIwEPti4A/LNgWoCVdvEog2YqHLSNGpy/kE4Xvodn/y3X5TQ5Vq4XdfKTKN/Qs
	 tAze5uelqcyoXcEhzp3la6jmczeS4h2sYS/uWP43rvM0mbUcw69WM2S0MR6insmPxP
	 D6+PmY+G+o6i5NE+H+rM0a7+1rMIIsV5C+v4ZPls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/214] gro: remove rcu_read_lock/rcu_read_unlock from gro_receive handlers
Date: Tue, 10 Sep 2024 11:32:32 +0200
Message-ID: <20240910092604.065496532@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0e4ea3c0fe82..eb5b7c66db93 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -530,18 +530,15 @@ static struct sk_buff *geneve_gro_receive(struct sock *sk,
 
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
index 8710d5d7d3c1..40bbe08c1aa4 100644
--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -483,10 +483,9 @@ static struct sk_buff *vlan_gro_receive(struct list_head *head,
 
 	type = vhdr->h_vlan_encapsulated_proto;
 
-	rcu_read_lock();
 	ptype = gro_find_receive_by_type(type);
 	if (!ptype)
-		goto out_unlock;
+		goto out;
 
 	flush = 0;
 
@@ -508,8 +507,6 @@ static struct sk_buff *vlan_gro_receive(struct list_head *head,
 					    ipv6_gro_receive, inet_gro_receive,
 					    head, skb);
 
-out_unlock:
-	rcu_read_unlock();
 out:
 	skb_gro_flush_final(skb, pp, flush);
 
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 9ad4a15232af..72841efebcb1 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -425,11 +425,10 @@ struct sk_buff *eth_gro_receive(struct list_head *head, struct sk_buff *skb)
 
 	type = eh->h_proto;
 
-	rcu_read_lock();
 	ptype = gro_find_receive_by_type(type);
 	if (ptype == NULL) {
 		flush = 1;
-		goto out_unlock;
+		goto out;
 	}
 
 	skb_gro_pull(skb, sizeof(*eh));
@@ -439,8 +438,6 @@ struct sk_buff *eth_gro_receive(struct list_head *head, struct sk_buff *skb)
 					    ipv6_gro_receive, inet_gro_receive,
 					    head, skb);
 
-out_unlock:
-	rcu_read_unlock();
 out:
 	skb_gro_flush_final(skb, pp, flush);
 
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 20cdd0efb95b..c9156e7605db 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1477,19 +1477,18 @@ struct sk_buff *inet_gro_receive(struct list_head *head, struct sk_buff *skb)
 
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
@@ -1566,9 +1565,6 @@ struct sk_buff *inet_gro_receive(struct list_head *head, struct sk_buff *skb)
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
index 1121a9d5fed9..c12b4b2fc638 100644
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -162,10 +162,9 @@ static struct sk_buff *gre_gro_receive(struct list_head *head,
 
 	type = greh->protocol;
 
-	rcu_read_lock();
 	ptype = gro_find_receive_by_type(type);
 	if (!ptype)
-		goto out_unlock;
+		goto out;
 
 	grehlen = GRE_HEADER_SECTION;
 
@@ -179,13 +178,13 @@ static struct sk_buff *gre_gro_receive(struct list_head *head,
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
@@ -229,8 +228,6 @@ static struct sk_buff *gre_gro_receive(struct list_head *head,
 	pp = call_gro_receive(ptype->callbacks.gro_receive, head, skb);
 	flush = 0;
 
-out_unlock:
-	rcu_read_unlock();
 out:
 	skb_gro_flush_final(skb, pp, flush);
 
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index c61268849948..0406097e7c29 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -618,13 +618,11 @@ struct sk_buff *udp4_gro_receive(struct list_head *head, struct sk_buff *skb)
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
index 172565d12570..46587894c8c9 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -210,7 +210,6 @@ INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
 
 	flush += ntohs(iph->payload_len) != skb_gro_len(skb);
 
-	rcu_read_lock();
 	proto = iph->nexthdr;
 	ops = rcu_dereference(inet6_offloads[proto]);
 	if (!ops || !ops->callbacks.gro_receive) {
@@ -223,7 +222,7 @@ INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
 
 		ops = rcu_dereference(inet6_offloads[proto]);
 		if (!ops || !ops->callbacks.gro_receive)
-			goto out_unlock;
+			goto out;
 
 		iph = ipv6_hdr(skb);
 	}
@@ -281,9 +280,6 @@ INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
 	pp = indirect_call_gro_receive_l4(tcp6_gro_receive, udp6_gro_receive,
 					 ops->callbacks.gro_receive, head, skb);
 
-out_unlock:
-	rcu_read_unlock();
-
 out:
 	skb_gro_flush_final(skb, pp, flush);
 
diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index 28f63c01a595..f93195fcc059 100644
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



