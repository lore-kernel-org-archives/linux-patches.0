Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73E93D47A5;
	Wed,  8 Apr 2026 18:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671672; cv=none; b=WhWmz3p/CJfBaTOdAioOGOVdDYPhcFDxQI/ktMycxyBB9QJUD+EenTyAd/l+yEiCWz0a2zLjVVNtpFNxcfM+GMmYPhTMJKTH847jv/s1LTD2vAKUqiDHSd9kf9NeZbOHjbdKo7gjv5r4Ws10h2zf6eVlPoyWDyNsw2SkSq8cawc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671672; c=relaxed/simple;
	bh=fZ1boC/dAbN71xFXPw4xFqFgeMJm0uT4pFgIfjluE70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbpOmSKlG8y09NI3AWdBXvLxIqaFSYcS/U2rkmJ8bC5pTqCDyIFJEUaM4JkW0aObY0GjTMuwRVBhw4TpxVKjDZUdR2KtMGaeaGple2l00xhKg4va79/qpakhYcQ9KcOG9bheNTPy66/2GIiStTwzb8btnQ6XRFjkr3mUlvmL4/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ol9F70em; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ol9F70em"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F089C19421;
	Wed,  8 Apr 2026 18:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671672;
	bh=fZ1boC/dAbN71xFXPw4xFqFgeMJm0uT4pFgIfjluE70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ol9F70emPjKOT/kuNf7QMl/92v9qugdu7AewmvUnVoVxGc1j1mSeuKAksdgnvM3Ks
	 p9ehv3ErFQXXIxccg4BhXdTb1RyM7FiCpbHJONPUjyh6KI//o6mUE8XBJ06fJPQ0kp
	 qXdqrNf80VojHKuID14x91uL1UPIxJowJgGPYNqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Eric Dumazet <edumazet@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/312] xfrm: Fix the usage of skb->sk
Date: Wed,  8 Apr 2026 19:59:01 +0200
Message-ID: <20260408175934.631235028@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 1620c88887b16940e00dbe57dd38c74eda9bad9e ]

xfrm assumed to always have a full socket at skb->sk.
This is not always true, so fix it by converting to a
full socket before it is used.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Stable-dep-of: 0c0eef8ccd24 ("esp: fix skb leak with espintcp and async crypto")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4.c                | 2 +-
 net/ipv6/esp6.c                | 2 +-
 net/ipv6/xfrm6_output.c        | 4 ++--
 net/xfrm/xfrm_interface_core.c | 2 +-
 net/xfrm/xfrm_output.c         | 7 ++++---
 net/xfrm/xfrm_policy.c         | 2 +-
 6 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index a40f78a6474c6..70ad42826c3db 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -236,7 +236,7 @@ static void esp_output_done(struct crypto_async_request *base, int err)
 		    x->encap && x->encap->encap_type == TCP_ENCAP_ESPINTCP)
 			esp_output_tail_tcp(x, skb);
 		else
-			xfrm_output_resume(skb->sk, skb, err);
+			xfrm_output_resume(skb_to_full_sk(skb), skb, err);
 	}
 }
 
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 48963fc9057bc..a7cc96fc7c247 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -272,7 +272,7 @@ static void esp_output_done(struct crypto_async_request *base, int err)
 		    x->encap && x->encap->encap_type == TCP_ENCAP_ESPINTCP)
 			esp_output_tail_tcp(x, skb);
 		else
-			xfrm_output_resume(skb->sk, skb, err);
+			xfrm_output_resume(skb_to_full_sk(skb), skb, err);
 	}
 }
 
diff --git a/net/ipv6/xfrm6_output.c b/net/ipv6/xfrm6_output.c
index ad07904642cad..ff183bd76c998 100644
--- a/net/ipv6/xfrm6_output.c
+++ b/net/ipv6/xfrm6_output.c
@@ -82,14 +82,14 @@ static int __xfrm6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 
 	toobig = skb->len > mtu && !skb_is_gso(skb);
 
-	if (toobig && xfrm6_local_dontfrag(skb->sk)) {
+	if (toobig && xfrm6_local_dontfrag(sk)) {
 		xfrm6_local_rxpmtu(skb, mtu);
 		kfree_skb(skb);
 		return -EMSGSIZE;
 	} else if (toobig && xfrm6_noneed_fragment(skb)) {
 		skb->ignore_df = 1;
 		goto skip_frag;
-	} else if (!skb->ignore_df && toobig && skb->sk) {
+	} else if (!skb->ignore_df && toobig && sk) {
 		xfrm_local_error(skb, mtu);
 		kfree_skb(skb);
 		return -EMSGSIZE;
diff --git a/net/xfrm/xfrm_interface_core.c b/net/xfrm/xfrm_interface_core.c
index 45466fa4ace43..87983f963f4f6 100644
--- a/net/xfrm/xfrm_interface_core.c
+++ b/net/xfrm/xfrm_interface_core.c
@@ -498,7 +498,7 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 	skb_dst_set(skb, dst);
 	skb->dev = tdev;
 
-	err = dst_output(xi->net, skb->sk, skb);
+	err = dst_output(xi->net, skb_to_full_sk(skb), skb);
 	if (net_xmit_eval(err) == 0) {
 		dev_sw_netstats_tx_add(dev, 1, length);
 	} else {
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index c59c548d8fc10..290059d9e08e0 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -782,7 +782,7 @@ static int xfrm4_tunnel_check_size(struct sk_buff *skb)
 	     !skb_gso_validate_network_len(skb, ip_skb_dst_mtu(skb->sk, skb)))) {
 		skb->protocol = htons(ETH_P_IP);
 
-		if (skb->sk)
+		if (skb->sk && sk_fullsock(skb->sk))
 			xfrm_local_error(skb, mtu);
 		else
 			icmp_send(skb, ICMP_DEST_UNREACH,
@@ -818,6 +818,7 @@ static int xfrm6_tunnel_check_size(struct sk_buff *skb)
 {
 	int mtu, ret = 0;
 	struct dst_entry *dst = skb_dst(skb);
+	struct sock *sk = skb_to_full_sk(skb);
 
 	if (skb->ignore_df)
 		goto out;
@@ -832,9 +833,9 @@ static int xfrm6_tunnel_check_size(struct sk_buff *skb)
 		skb->dev = dst->dev;
 		skb->protocol = htons(ETH_P_IPV6);
 
-		if (xfrm6_local_dontfrag(skb->sk))
+		if (xfrm6_local_dontfrag(sk))
 			ipv6_stub->xfrm6_local_rxpmtu(skb, mtu);
-		else if (skb->sk)
+		else if (sk)
 			xfrm_local_error(skb, mtu);
 		else
 			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index e015ff225b27a..cd534803a0e42 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2858,7 +2858,7 @@ static void xfrm_policy_queue_process(struct timer_list *t)
 		skb_dst_drop(skb);
 		skb_dst_set(skb, dst);
 
-		dst_output(net, skb->sk, skb);
+		dst_output(net, skb_to_full_sk(skb), skb);
 	}
 
 out:
-- 
2.51.0



