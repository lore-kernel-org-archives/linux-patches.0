Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867C818B49E;
	Tue, 10 Sep 2024 10:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965143; cv=none; b=bZl/7rX5bxgU9dQhsLLDIc+G5hC+nAl3EmheC6glsHfubu/5+QJLd3o1fA0ZcumyS9jma78BOhRi8cvh9vdp/ViVKJ1y+PI+ohxUypTJ+YNy/WvOXyxu5Opj6X6OdH0RHhlRQ17y4oSX/PHjxOQP1We3vRsnagBFVreZCZ3nUkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965143; c=relaxed/simple;
	bh=sobHp9FYV4br4xHdgQ5LG4tLjblz1jMp65qMp/MwFPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IyHyVQyU3HUubzlZijbPTQ6uhjGzWWO9VHcW23Lk9o3/77l/1/jOjlwwvpbkOZu1iyMnerc0zEVsIEnl7R0QS6fSX5i53hCkuctJvPMcR0vTqYaMP6HnRJ3Z5YvTQ8UMwdy5BzyOQBxNadLTue2M1IcqCiCKE8Egd0vLhJ9zhwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C0/oL4yF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C0/oL4yF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2EEC4CEC3;
	Tue, 10 Sep 2024 10:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965143;
	bh=sobHp9FYV4br4xHdgQ5LG4tLjblz1jMp65qMp/MwFPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C0/oL4yFZa5JsiTp2sL7JcJ6L0Qb4HwrIizVv+/OMPdil2MrueBgpKA0reKH+aPkW
	 91j3GQzufbagm4eZvgsV4yLcK6Z5vfXU5DxOly8pxPljavbKqKkN3Q2DpogDKCCYCR
	 7KNoZTL4NFAWmJjZLxLTwbXcYVGXd5mQlBaMwijE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 124/186] gro: remove rcu_read_lock/rcu_read_unlock from gro_complete handlers
Date: Tue, 10 Sep 2024 11:33:39 +0200
Message-ID: <20240910092559.680714466@linuxfoundation.org>
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

[ Upstream commit 627b94f75b82d13d1530b59155a545fd99d807db ]

All gro_complete() handlers are called from napi_gro_complete()
while rcu_read_lock() has been called.

There is no point stacking more rcu_read_lock()

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 7e4196935069 ("fou: Fix null-ptr-deref in GRO.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/geneve.c   |  3 ---
 net/8021q/vlan_core.c  |  2 --
 net/ethernet/eth.c     |  2 --
 net/ipv4/af_inet.c     |  7 ++-----
 net/ipv4/fou.c         | 13 ++++---------
 net/ipv4/gre_offload.c |  3 ---
 net/ipv4/udp_offload.c |  2 --
 net/ipv6/ip6_offload.c |  8 ++------
 8 files changed, 8 insertions(+), 32 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 17989688f54b..08b479f04ed0 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -556,13 +556,10 @@ static int geneve_gro_complete(struct sock *sk, struct sk_buff *skb,
 	gh_len = geneve_hlen(gh);
 	type = gh->proto_type;
 
-	rcu_read_lock();
 	ptype = gro_find_complete_by_type(type);
 	if (ptype)
 		err = ptype->callbacks.gro_complete(skb, nhoff + gh_len);
 
-	rcu_read_unlock();
-
 	skb_set_inner_mac_header(skb, nhoff + gh_len);
 
 	return err;
diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
index ff0d3fc82c0f..c96ff4a1d4a0 100644
--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -516,12 +516,10 @@ static int vlan_gro_complete(struct sk_buff *skb, int nhoff)
 	struct packet_offload *ptype;
 	int err = -ENOENT;
 
-	rcu_read_lock();
 	ptype = gro_find_complete_by_type(type);
 	if (ptype)
 		err = ptype->callbacks.gro_complete(skb, nhoff + sizeof(*vhdr));
 
-	rcu_read_unlock();
 	return err;
 }
 
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 2b0eb24199d6..081390c32707 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -457,13 +457,11 @@ int eth_gro_complete(struct sk_buff *skb, int nhoff)
 	if (skb->encapsulation)
 		skb_set_inner_mac_header(skb, nhoff);
 
-	rcu_read_lock();
 	ptype = gro_find_complete_by_type(type);
 	if (ptype != NULL)
 		err = ptype->callbacks.gro_complete(skb, nhoff +
 						    sizeof(struct ethhdr));
 
-	rcu_read_unlock();
 	return err;
 }
 EXPORT_SYMBOL(eth_gro_complete);
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index cac63bb20c16..58dfca09093c 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1634,10 +1634,9 @@ int inet_gro_complete(struct sk_buff *skb, int nhoff)
 	csum_replace2(&iph->check, iph->tot_len, newlen);
 	iph->tot_len = newlen;
 
-	rcu_read_lock();
 	ops = rcu_dereference(inet_offloads[proto]);
 	if (WARN_ON(!ops || !ops->callbacks.gro_complete))
-		goto out_unlock;
+		goto out;
 
 	/* Only need to add sizeof(*iph) to get to the next hdr below
 	 * because any hdr with option will have been flushed in
@@ -1647,9 +1646,7 @@ int inet_gro_complete(struct sk_buff *skb, int nhoff)
 			      tcp4_gro_complete, udp4_gro_complete,
 			      skb, nhoff + sizeof(*iph));
 
-out_unlock:
-	rcu_read_unlock();
-
+out:
 	return err;
 }
 EXPORT_SYMBOL(inet_gro_complete);
diff --git a/net/ipv4/fou.c b/net/ipv4/fou.c
index 5aacc75e495c..605d9673d6ec 100644
--- a/net/ipv4/fou.c
+++ b/net/ipv4/fou.c
@@ -265,19 +265,16 @@ static int fou_gro_complete(struct sock *sk, struct sk_buff *skb,
 	const struct net_offload *ops;
 	int err = -ENOSYS;
 
-	rcu_read_lock();
 	offloads = NAPI_GRO_CB(skb)->is_ipv6 ? inet6_offloads : inet_offloads;
 	ops = rcu_dereference(offloads[proto]);
 	if (WARN_ON(!ops || !ops->callbacks.gro_complete))
-		goto out_unlock;
+		goto out;
 
 	err = ops->callbacks.gro_complete(skb, nhoff);
 
 	skb_set_inner_mac_header(skb, nhoff);
 
-out_unlock:
-	rcu_read_unlock();
-
+out:
 	return err;
 }
 
@@ -479,18 +476,16 @@ static int gue_gro_complete(struct sock *sk, struct sk_buff *skb, int nhoff)
 		return err;
 	}
 
-	rcu_read_lock();
 	offloads = NAPI_GRO_CB(skb)->is_ipv6 ? inet6_offloads : inet_offloads;
 	ops = rcu_dereference(offloads[proto]);
 	if (WARN_ON(!ops || !ops->callbacks.gro_complete))
-		goto out_unlock;
+		goto out;
 
 	err = ops->callbacks.gro_complete(skb, nhoff + guehlen);
 
 	skb_set_inner_mac_header(skb, nhoff + guehlen);
 
-out_unlock:
-	rcu_read_unlock();
+out:
 	return err;
 }
 
diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
index e9dabf1affe9..b4da692b9734 100644
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -248,13 +248,10 @@ static int gre_gro_complete(struct sk_buff *skb, int nhoff)
 	if (greh->flags & GRE_CSUM)
 		grehlen += GRE_HEADER_SECTION;
 
-	rcu_read_lock();
 	ptype = gro_find_complete_by_type(type);
 	if (ptype)
 		err = ptype->callbacks.gro_complete(skb, nhoff + grehlen);
 
-	rcu_read_unlock();
-
 	skb_set_inner_mac_header(skb, nhoff + grehlen);
 
 	return err;
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 418da7a8a075..6e36eb1ba276 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -645,7 +645,6 @@ int udp_gro_complete(struct sk_buff *skb, int nhoff,
 
 	uh->len = newlen;
 
-	rcu_read_lock();
 	sk = INDIRECT_CALL_INET(lookup, udp6_lib_lookup_skb,
 				udp4_lib_lookup_skb, skb, uh->source, uh->dest);
 	if (sk && udp_sk(sk)->gro_complete) {
@@ -661,7 +660,6 @@ int udp_gro_complete(struct sk_buff *skb, int nhoff,
 	} else {
 		err = udp_gro_complete_segment(skb);
 	}
-	rcu_read_unlock();
 
 	if (skb->remcsum_offload)
 		skb_shinfo(skb)->gso_type |= SKB_GSO_TUNNEL_REMCSUM;
diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index f67921e0dd56..673f02ea62aa 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -328,18 +328,14 @@ INDIRECT_CALLABLE_SCOPE int ipv6_gro_complete(struct sk_buff *skb, int nhoff)
 
 	iph->payload_len = htons(skb->len - nhoff - sizeof(*iph));
 
-	rcu_read_lock();
-
 	nhoff += sizeof(*iph) + ipv6_exthdrs_len(iph, &ops);
 	if (WARN_ON(!ops || !ops->callbacks.gro_complete))
-		goto out_unlock;
+		goto out;
 
 	err = INDIRECT_CALL_L4(ops->callbacks.gro_complete, tcp6_gro_complete,
 			       udp6_gro_complete, skb, nhoff);
 
-out_unlock:
-	rcu_read_unlock();
-
+out:
 	return err;
 }
 
-- 
2.43.0



