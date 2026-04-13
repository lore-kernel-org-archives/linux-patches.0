Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D195D318EC1;
	Mon, 13 Apr 2026 16:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099279; cv=none; b=ZEuWW3BGgi/7Oxf/CYpe/WcA9+n5QBPBX63DRwH8373at9fISmD11mx5w9eB3Wm1+B04+Ly2ouXkJ1PSqRkbYvwPcFUymTgwMmkLNyr/WOBz0aX3wLN1XjH7OwlE7Fx1IeaNdPzW9rjWlFgyOl19Cj97mTmPL0Rr/m2F5kUVD30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099279; c=relaxed/simple;
	bh=yY1D32tuwV0JAUUZzHSRivkdzuvv+k1zewZ910VX0dM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IV4pS1TvxJ0M0/JIabDLYCrHXINTh5Nf3a4WP6FWBa90Y9z3ikUfUdcMH1CnkHsSo7OH+76oOkv0t6xZfC4S4I6OHlDZ3uKlSccdsTc0Dwwp1uz5KTDfitUeOgbmBX5yR1IcnqPQ416llWMJhtJyg7urUwZ5tgkeezBKLztzwIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mI/0KIgF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mI/0KIgF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4E8C2BCAF;
	Mon, 13 Apr 2026 16:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099279;
	bh=yY1D32tuwV0JAUUZzHSRivkdzuvv+k1zewZ910VX0dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mI/0KIgFX11ad1yLIWGnkcz+VYuwDA3ZNWXyMZCJjkwLZYiKbL3WqTzMbzaL0WA5m
	 6E5FhJXQeVE05mTEx9nC2POWv2CsAc/A83vSzmbjttfEzRx8Qf/2yep3D2MV7xpltc
	 uxotZPw1PN7tIEcRoCZu4gINtU48GCkYxtaTjAiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Eric Dumazet <edumazet@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 248/491] xfrm: Fix the usage of skb->sk
Date: Mon, 13 Apr 2026 17:58:13 +0200
Message-ID: <20260413155828.340273722@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index adfefcd88bbcc..295bc1799002a 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -278,7 +278,7 @@ static void esp_output_done(struct crypto_async_request *base, int err)
 		    x->encap && x->encap->encap_type == TCP_ENCAP_ESPINTCP)
 			esp_output_tail_tcp(x, skb);
 		else
-			xfrm_output_resume(skb->sk, skb, err);
+			xfrm_output_resume(skb_to_full_sk(skb), skb, err);
 	}
 }
 
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 39154531d4559..9df910dfc348a 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -313,7 +313,7 @@ static void esp_output_done(struct crypto_async_request *base, int err)
 		    x->encap && x->encap->encap_type == TCP_ENCAP_ESPINTCP)
 			esp_output_tail_tcp(x, skb);
 		else
-			xfrm_output_resume(skb->sk, skb, err);
+			xfrm_output_resume(skb_to_full_sk(skb), skb, err);
 	}
 }
 
diff --git a/net/ipv6/xfrm6_output.c b/net/ipv6/xfrm6_output.c
index ee349c2438782..a8fc778ce465c 100644
--- a/net/ipv6/xfrm6_output.c
+++ b/net/ipv6/xfrm6_output.c
@@ -89,14 +89,14 @@ static int __xfrm6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 
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
index 9eaf0174d9981..fc5967ccaddca 100644
--- a/net/xfrm/xfrm_interface_core.c
+++ b/net/xfrm/xfrm_interface_core.c
@@ -368,7 +368,7 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 	skb_dst_set(skb, dst);
 	skb->dev = tdev;
 
-	err = dst_output(xi->net, skb->sk, skb);
+	err = dst_output(xi->net, skb_to_full_sk(skb), skb);
 	if (net_xmit_eval(err) == 0) {
 		struct pcpu_sw_netstats *tstats = this_cpu_ptr(dev->tstats);
 
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 40f7a98abdd1c..7c588973cfa1b 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -645,7 +645,7 @@ static int xfrm4_tunnel_check_size(struct sk_buff *skb)
 	     !skb_gso_validate_network_len(skb, ip_skb_dst_mtu(skb->sk, skb)))) {
 		skb->protocol = htons(ETH_P_IP);
 
-		if (skb->sk)
+		if (skb->sk && sk_fullsock(skb->sk))
 			xfrm_local_error(skb, mtu);
 		else
 			icmp_send(skb, ICMP_DEST_UNREACH,
@@ -681,6 +681,7 @@ static int xfrm6_tunnel_check_size(struct sk_buff *skb)
 {
 	int mtu, ret = 0;
 	struct dst_entry *dst = skb_dst(skb);
+	struct sock *sk = skb_to_full_sk(skb);
 
 	if (skb->ignore_df)
 		goto out;
@@ -695,9 +696,9 @@ static int xfrm6_tunnel_check_size(struct sk_buff *skb)
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
index 64b971bb1d36a..c4ebfaa0b2ed0 100644
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



