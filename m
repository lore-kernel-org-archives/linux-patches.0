Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BD52DF3C9;
	Tue, 17 Jun 2025 15:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174779; cv=none; b=T25ncFhyasZgTosXFgzm3lr4zNQo8gsghJJWlPPRJKWQNKcVQFuZZVXd7fsqq0+xOyy4pRKpOnX2aXxs0IvgnsNOzgmy+YcsIeEYpl64WPZTWN4NbOxjdk5hi60789GnB8cRu/s4J5d/ulhiimSXQ+3AdIHM2d/5xMV71fgsjAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174779; c=relaxed/simple;
	bh=GUmgAZNfWdGQuVzt+kYVrLt+EiyPFmFBIr9fGLbZ5Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMBBhNEtO69KfyMouWuqtMvEBZwNU+OUm7jztYarACKZD1NJOJfnWYp/9wJVSz4AN2KsnYUm3eQg9I1ALG2s3Nxs3q75nnyDNcY0ywhfCJ5avQVWD8cPXFv02A2iqjeH0OIBwCtJ9dV/+KidwycXJT9o2F8W4gdy+adzC9TLR6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDBftx5x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDBftx5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61730C4CEE3;
	Tue, 17 Jun 2025 15:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174778;
	bh=GUmgAZNfWdGQuVzt+kYVrLt+EiyPFmFBIr9fGLbZ5Ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wDBftx5xiOM/SkDHY4qnbRjFhCxvRmg3+pPi7QFtNyZhSKMrq4vf6J/CUJSzYbAOY
	 We3/NKoxLO1Qu7Kk+XoprNUmb5UJKS8P5cJcBw05fkRNJC9joYy4E/CLEx0SYz3nGe
	 ZMTqyTajmUY/ko0upovJNY+ClCszdSfqJx5XlLEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huajian Yang <huajianyang@asrmicro.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 106/356] netfilter: bridge: Move specific fragmented packet to slow_path instead of dropping it
Date: Tue, 17 Jun 2025 17:23:41 +0200
Message-ID: <20250617152342.487592803@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4fbfbafdfa027..4b4a396d97225 100644
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
index 7c4af48d529e1..606aae4e78a9a 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -163,20 +163,20 @@ int br_ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
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



