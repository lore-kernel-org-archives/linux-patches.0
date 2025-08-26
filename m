Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085611494D9;
	Tue, 26 Aug 2025 14:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217081; cv=none; b=U1fpUvPvHla6q1lkcELAFtKREGjpcUf/ya6TrVHcssur98nEx7ixfhG1+vG4Wl14IKroWEb2TcLnRYV9nUOvvAErLC5Gjf4f7y+2UqS3O3ejVSSzN8IW0Qf8/SfEsfgt+TIt/Y5se3TzyXeP21Vaxu7WH6OdZ7xSxq4akhFjhtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217081; c=relaxed/simple;
	bh=oLKK4bYDVgAF903BYTj0drVRPZz4VgAnhEYxeJY0A1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgzPpBrMu9gQ2IWO49Zle8lNLNdbvWsHxST223+UIssvs9eParn6Igw3EhMmBCx5+JwiCSl2DPU8+/JxPQ73ywstmKkgAiktYgN44TmMYQ9Kf/4jclAe1v6ZIh91yTFh9mSv4PPTd8V6aut8yXLZH0WVP7HceI/gXy3M860oADQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yv7T4p7a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yv7T4p7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92890C4CEF1;
	Tue, 26 Aug 2025 14:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217080;
	bh=oLKK4bYDVgAF903BYTj0drVRPZz4VgAnhEYxeJY0A1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yv7T4p7a9KKKuT0JWWKy7f48LswP61YZrH6cwVvT4EZfsoQW0opQ68ur7XQfCLXXQ
	 CwBXth6P+GUCuWqhDZl1ESjifYrObaYbhRUAKJ7XZs4oQBajk4bna6jebFnZLABUTc
	 ZJX2n43KmyG6UaR4n8NXiN/85PzbqnEDMfWB6JvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 643/644] netfilter: nf_reject: dont leak dst refcount for loopback packets
Date: Tue, 26 Aug 2025 13:12:14 +0200
Message-ID: <20250826111002.497495608@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 91a79b792204313153e1bdbbe5acbfc28903b3a5 ]

recent patches to add a WARN() when replacing skb dst entry found an
old bug:

WARNING: include/linux/skbuff.h:1165 skb_dst_check_unset include/linux/skbuff.h:1164 [inline]
WARNING: include/linux/skbuff.h:1165 skb_dst_set include/linux/skbuff.h:1210 [inline]
WARNING: include/linux/skbuff.h:1165 nf_reject_fill_skb_dst+0x2a4/0x330 net/ipv4/netfilter/nf_reject_ipv4.c:234
[..]
Call Trace:
 nf_send_unreach+0x17b/0x6e0 net/ipv4/netfilter/nf_reject_ipv4.c:325
 nft_reject_inet_eval+0x4bc/0x690 net/netfilter/nft_reject_inet.c:27
 expr_call_ops_eval net/netfilter/nf_tables_core.c:237 [inline]
 ..

This is because blamed commit forgot about loopback packets.
Such packets already have a dst_entry attached, even at PRE_ROUTING stage.

Instead of checking hook just check if the skb already has a route
attached to it.

Fixes: f53b9b0bdc59 ("netfilter: introduce support for reject at prerouting stage")
Signed-off-by: Florian Westphal <fw@strlen.de>
Link: https://patch.msgid.link/20250820123707.10671-1-fw@strlen.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 6 ++----
 net/ipv6/netfilter/nf_reject_ipv6.c | 5 ++---
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 350aaca12618..c1f5ca847c8a 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -247,8 +247,7 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	if (!oth)
 		return;
 
-	if ((hook == NF_INET_PRE_ROUTING || hook == NF_INET_INGRESS) &&
-	    nf_reject_fill_skb_dst(oldskb) < 0)
+	if (!skb_dst(oldskb) && nf_reject_fill_skb_dst(oldskb) < 0)
 		return;
 
 	if (skb_rtable(oldskb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
@@ -317,8 +316,7 @@ void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
 	if (iph->frag_off & htons(IP_OFFSET))
 		return;
 
-	if ((hook == NF_INET_PRE_ROUTING || hook == NF_INET_INGRESS) &&
-	    nf_reject_fill_skb_dst(skb_in) < 0)
+	if (!skb_dst(skb_in) && nf_reject_fill_skb_dst(skb_in) < 0)
 		return;
 
 	if (skb_csum_unnecessary(skb_in) || !nf_reject_verify_csum(proto)) {
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 8208490e05a3..ca39b83c2a5d 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -295,7 +295,7 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	fl6.fl6_sport = otcph->dest;
 	fl6.fl6_dport = otcph->source;
 
-	if (hook == NF_INET_PRE_ROUTING || hook == NF_INET_INGRESS) {
+	if (!skb_dst(oldskb)) {
 		nf_ip6_route(net, &dst, flowi6_to_flowi(&fl6), false);
 		if (!dst)
 			return;
@@ -394,8 +394,7 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
 	if (hooknum == NF_INET_LOCAL_OUT && skb_in->dev == NULL)
 		skb_in->dev = net->loopback_dev;
 
-	if ((hooknum == NF_INET_PRE_ROUTING || hooknum == NF_INET_INGRESS) &&
-	    nf_reject6_fill_skb_dst(skb_in) < 0)
+	if (!skb_dst(skb_in) && nf_reject6_fill_skb_dst(skb_in) < 0)
 		return;
 
 	icmpv6_send(skb_in, ICMPV6_DEST_UNREACH, code, 0);
-- 
2.50.1



