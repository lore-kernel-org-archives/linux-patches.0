Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D532EE619;
	Tue, 17 Jun 2025 16:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176885; cv=none; b=SLD3wpykl7dFcpE5NWbYcqUvjmz7kyuh+bMsSJJchZGJZ3DktkRRZwfQhjJM5KiyoYMYxgoAeOo81+0GrSp4CXkaBWYE5kHaBKHe6LafW/USOuppg0seyxXOGJRPwk25Cax7gaW+WO3xQHMFhzS4VwqHwyAo0Brm1g0N/2Ja9ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176885; c=relaxed/simple;
	bh=gT5ArMBW2AofmJljPn8tUygScn9++TWLEclFd5wsyxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjVe9e3iCkJFiS+pDh4W0rv+Jnc3mwkhjP0DZa6dw3g0cVncHaWrcMPGow+8l5Ed8OL0dkJ3sPrCBlBEAvZr0SMfpcdrpgVjHujvAVg/furvaOWbuJ66BrUQyM+ZFcvJC2cmP9ezBWkiur9BC65OnzSurl/GwxXOZB1tR+U4O+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHk5jJ+G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHk5jJ+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9DF8C4CEE3;
	Tue, 17 Jun 2025 16:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176885;
	bh=gT5ArMBW2AofmJljPn8tUygScn9++TWLEclFd5wsyxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHk5jJ+GLb0DTcQWv17Upbh7eAk9/h56xi6QuhONQ4rwOaQ7+2opC9zhCdWMfYgw1
	 fbkdGdjv4Bu1UTQv2QnStCIysS2/ALwafAWNaC/Eu5FIT3u+Mxp5LOR24WflKsJzim
	 +cxLkYG7N7LyNYxJp5dqs6s4rmfdqo97gPdCT3GU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huajian Yang <huajianyang@asrmicro.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 235/780] netfilter: bridge: Move specific fragmented packet to slow_path instead of dropping it
Date: Tue, 17 Jun 2025 17:19:03 +0200
Message-ID: <20250617152501.028091753@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huajian Yang <huajianyang@asrmicro.com>

[ Upstream commit aa04c6f45b9224b949aa35d4fa5f8d0ba07b23d4 ]

The config NF_CONNTRACK_BRIDGE will change the bridge forwarding for
fragmented packets.

The original bridge does not know that it is a fragmented packet and
forwards it directly, after NF_CONNTRACK_BRIDGE is enabled, function
nf_br_ip_fragment and br_ip6_fragment will check the headroom.

In original br_forward, insufficient headroom of skb may indeed exist,
but there's still a way to save the skb in the device driver after
dev_queue_xmit.So droping the skb will change the original bridge
forwarding in some cases.

Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
Signed-off-by: Huajian Yang <huajianyang@asrmicro.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 12 ++++++------
 net/ipv6/netfilter.c                       | 12 ++++++------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 816bb0fde718e..6482de4d87509 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -60,19 +60,19 @@ static int nf_br_ip_fragment(struct net *net, struct sock *sk,
 		struct ip_fraglist_iter iter;
 		struct sk_buff *frag;
 
-		if (first_len - hlen > mtu ||
-		    skb_headroom(skb) < ll_rs)
+		if (first_len - hlen > mtu)
 			goto blackhole;
 
-		if (skb_cloned(skb))
+		if (skb_cloned(skb) ||
+		    skb_headroom(skb) < ll_rs)
 			goto slow_path;
 
 		skb_walk_frags(skb, frag) {
-			if (frag->len > mtu ||
-			    skb_headroom(frag) < hlen + ll_rs)
+			if (frag->len > mtu)
 				goto blackhole;
 
-			if (skb_shared(frag))
+			if (skb_shared(frag) ||
+			    skb_headroom(frag) < hlen + ll_rs)
 				goto slow_path;
 		}
 
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 581ce055bf520..4541836ee3da2 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -164,20 +164,20 @@ int br_ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		struct ip6_fraglist_iter iter;
 		struct sk_buff *frag2;
 
-		if (first_len - hlen > mtu ||
-		    skb_headroom(skb) < (hroom + sizeof(struct frag_hdr)))
+		if (first_len - hlen > mtu)
 			goto blackhole;
 
-		if (skb_cloned(skb))
+		if (skb_cloned(skb) ||
+		    skb_headroom(skb) < (hroom + sizeof(struct frag_hdr)))
 			goto slow_path;
 
 		skb_walk_frags(skb, frag2) {
-			if (frag2->len > mtu ||
-			    skb_headroom(frag2) < (hlen + hroom + sizeof(struct frag_hdr)))
+			if (frag2->len > mtu)
 				goto blackhole;
 
 			/* Partially cloned skb? */
-			if (skb_shared(frag2))
+			if (skb_shared(frag2) ||
+			    skb_headroom(frag2) < (hlen + hroom + sizeof(struct frag_hdr)))
 				goto slow_path;
 		}
 
-- 
2.39.5



