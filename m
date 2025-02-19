Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB291EA7EA;
	Wed, 19 Feb 2025 08:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955288; cv=none; b=VVsDReYKCOEuNs1vCLJnPbJi3q7Owscg/lF15JhCUm653Yn1+dO53dNNEneOfaJ9g8vShUpKXwRjM/GGYVHtLfIOzBGGaWeH264tVq+1jHUqwWrABKIBikCqa2cC3t/Dc4DJGxLK7nVs5Sa9851XodGiZGMgSAMcoXK1PAOe52I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955288; c=relaxed/simple;
	bh=i31ocSO4eHwhh4Y1l8cE4ScF14pgh67fVY4T+r8j78I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKYm++114F8HEjiz3qiK++VYU957fuOXvTGe9Od0pkTAlJ/hLKOy3SkaPMeSNrok/0MxbFPCJPgfGhxyuSkVN4YzWLvNn/3IEba91FSQ9gdruk0xnJV5H4/fsRcSnSkuySrqLdryeC8hlINOxCP+aimaMoHrBUvnig30my0L/dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x3GXEF+c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x3GXEF+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1769C4CEE6;
	Wed, 19 Feb 2025 08:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955288;
	bh=i31ocSO4eHwhh4Y1l8cE4ScF14pgh67fVY4T+r8j78I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x3GXEF+cKsmrW2Y0ZDtzKDgsOSZ2JGEed42BoC4ndbYZe9TcCz6f7FxTahFNGeHOU
	 puN1MgqtFNbWsDYxWRnL9YMs6u13KM2mDxNYIY+Pq4pOpKT9N0bUtENnc6GJQxjTxG
	 Z9mm4ALhN6aLXghiCe4tXzW/52P+MR3zI+PzRcRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 190/230] ipv4: icmp: convert to dev_net_rcu()
Date: Wed, 19 Feb 2025 09:28:27 +0100
Message-ID: <20250219082609.133615716@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4b8474a0951e605d2a27a2c483da4eb4b8c63760 ]

__icmp_send() must ensure rcu_read_lock() is held, as spotted
by Jakub.

Other ICMP uses of dev_net() seem safe, change them to dev_net_rcu()
to get LOCKDEP support.

Fixes: dde1bc0e6f86 ("[NETNS]: Add namespace for ICMP replying code.")
Closes: https://lore.kernel.org/netdev/20250203153633.46ce0337@kernel.org/
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250205155120.1676781-9-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 932bd775fc268..f45bc187a92a7 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -399,10 +399,10 @@ static void icmp_push_reply(struct sock *sk,
 
 static void icmp_reply(struct icmp_bxm *icmp_param, struct sk_buff *skb)
 {
-	struct ipcm_cookie ipc;
 	struct rtable *rt = skb_rtable(skb);
-	struct net *net = dev_net(rt->dst.dev);
+	struct net *net = dev_net_rcu(rt->dst.dev);
 	bool apply_ratelimit = false;
+	struct ipcm_cookie ipc;
 	struct flowi4 fl4;
 	struct sock *sk;
 	struct inet_sock *inet;
@@ -610,12 +610,14 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
 	struct sock *sk;
 
 	if (!rt)
-		goto out;
+		return;
+
+	rcu_read_lock();
 
 	if (rt->dst.dev)
-		net = dev_net(rt->dst.dev);
+		net = dev_net_rcu(rt->dst.dev);
 	else if (skb_in->dev)
-		net = dev_net(skb_in->dev);
+		net = dev_net_rcu(skb_in->dev);
 	else
 		goto out;
 
@@ -786,7 +788,8 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
 	icmp_xmit_unlock(sk);
 out_bh_enable:
 	local_bh_enable();
-out:;
+out:
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(__icmp_send);
 
@@ -835,7 +838,7 @@ static void icmp_socket_deliver(struct sk_buff *skb, u32 info)
 	 * avoid additional coding at protocol handlers.
 	 */
 	if (!pskb_may_pull(skb, iph->ihl * 4 + 8)) {
-		__ICMP_INC_STATS(dev_net(skb->dev), ICMP_MIB_INERRORS);
+		__ICMP_INC_STATS(dev_net_rcu(skb->dev), ICMP_MIB_INERRORS);
 		return;
 	}
 
@@ -869,7 +872,7 @@ static enum skb_drop_reason icmp_unreach(struct sk_buff *skb)
 	struct net *net;
 	u32 info = 0;
 
-	net = dev_net(skb_dst(skb)->dev);
+	net = dev_net_rcu(skb_dst(skb)->dev);
 
 	/*
 	 *	Incomplete header ?
@@ -980,7 +983,7 @@ static enum skb_drop_reason icmp_unreach(struct sk_buff *skb)
 static enum skb_drop_reason icmp_redirect(struct sk_buff *skb)
 {
 	if (skb->len < sizeof(struct iphdr)) {
-		__ICMP_INC_STATS(dev_net(skb->dev), ICMP_MIB_INERRORS);
+		__ICMP_INC_STATS(dev_net_rcu(skb->dev), ICMP_MIB_INERRORS);
 		return SKB_DROP_REASON_PKT_TOO_SMALL;
 	}
 
@@ -1012,7 +1015,7 @@ static enum skb_drop_reason icmp_echo(struct sk_buff *skb)
 	struct icmp_bxm icmp_param;
 	struct net *net;
 
-	net = dev_net(skb_dst(skb)->dev);
+	net = dev_net_rcu(skb_dst(skb)->dev);
 	/* should there be an ICMP stat for ignored echos? */
 	if (READ_ONCE(net->ipv4.sysctl_icmp_echo_ignore_all))
 		return SKB_NOT_DROPPED_YET;
@@ -1041,9 +1044,9 @@ static enum skb_drop_reason icmp_echo(struct sk_buff *skb)
 
 bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
 {
+	struct net *net = dev_net_rcu(skb->dev);
 	struct icmp_ext_hdr *ext_hdr, _ext_hdr;
 	struct icmp_ext_echo_iio *iio, _iio;
-	struct net *net = dev_net(skb->dev);
 	struct inet6_dev *in6_dev;
 	struct in_device *in_dev;
 	struct net_device *dev;
@@ -1182,7 +1185,7 @@ static enum skb_drop_reason icmp_timestamp(struct sk_buff *skb)
 	return SKB_NOT_DROPPED_YET;
 
 out_err:
-	__ICMP_INC_STATS(dev_net(skb_dst(skb)->dev), ICMP_MIB_INERRORS);
+	__ICMP_INC_STATS(dev_net_rcu(skb_dst(skb)->dev), ICMP_MIB_INERRORS);
 	return SKB_DROP_REASON_PKT_TOO_SMALL;
 }
 
@@ -1199,7 +1202,7 @@ int icmp_rcv(struct sk_buff *skb)
 {
 	enum skb_drop_reason reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	struct rtable *rt = skb_rtable(skb);
-	struct net *net = dev_net(rt->dst.dev);
+	struct net *net = dev_net_rcu(rt->dst.dev);
 	struct icmphdr *icmph;
 
 	if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb)) {
@@ -1372,9 +1375,9 @@ int icmp_err(struct sk_buff *skb, u32 info)
 	struct iphdr *iph = (struct iphdr *)skb->data;
 	int offset = iph->ihl<<2;
 	struct icmphdr *icmph = (struct icmphdr *)(skb->data + offset);
+	struct net *net = dev_net_rcu(skb->dev);
 	int type = icmp_hdr(skb)->type;
 	int code = icmp_hdr(skb)->code;
-	struct net *net = dev_net(skb->dev);
 
 	/*
 	 * Use ping_err to handle all icmp errors except those
-- 
2.39.5



