Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE4926FD9B;
	Tue, 17 Mar 2026 17:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767516; cv=none; b=SkYf5hkd+ERG5yaErqS98DVozXGAuNKVazXc1ugN+Km2zyKtz9wG0eVGOf0+AYt9EJju7fN8wOUPQx5799yx/btfjn9aOb4ILHV1X54B6pqoY5QJj1L+Fxb57lsRYmU2y5aoxSUwvzqqWxJOLw/QeRf+zHsGqjrk+OlEKztv2/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767516; c=relaxed/simple;
	bh=7biJQf+letdU5ffW1U7ceOu7gLQmt1+obeGazCOvYUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXjqPEGUlRgHKVS6peeI1JmaMpC/2s0MpHRWJNOwKUG9X4Q3X/WxIXr3ouz2LiBThZxWtvl6Flzn3SC31Iihcz2C62TA9TGSRs+rBlCn0mejexLgwuzYVf9eqit5LPw8gaOCr1Q8/a/ID1r17tLc//KpxWX2J5zAuVO1VPSXXbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LeDQvDzM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LeDQvDzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F080BC4CEF7;
	Tue, 17 Mar 2026 17:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767516;
	bh=7biJQf+letdU5ffW1U7ceOu7gLQmt1+obeGazCOvYUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LeDQvDzMEggOCPpqWIBSOVBehmUHNcgu3IsPJoD0bkMn3maUXnTn34jpEH7W+Vwyu
	 qsErABVemp2sYkgWpweVCFXV4MsHDaz6Jr8UnbgHWwQM5Bn8GWWStTmPVmoRNIggpE
	 04s72hVb/P4fbRuZ+bmE7tDv2Hf9YjveKsT5XG2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Weiming Shi <bestswngs@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 101/333] net: prevent NULL deref in ip[6]tunnel_xmit()
Date: Tue, 17 Mar 2026 17:32:10 +0100
Message-ID: <20260317163003.116355657@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c38b8f5f791ecce13ab77e2257f8fd2444ba80f6 ]

Blamed commit missed that both functions can be called with dev == NULL.

Also add unlikely() hints for these conditions that only fuzzers can hit.

Fixes: 6f1a9140ecda ("net: add xmit recursion limit to tunnel xmit functions")
Signed-off-by: Eric Dumazet <edumazet@google.com>
CC: Weiming Shi <bestswngs@gmail.com>
Link: https://patch.msgid.link/20260312043908.2790803-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip6_tunnel.h  | 10 ++++++----
 net/ipv4/ip_tunnel_core.c | 10 ++++++----
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/net/ip6_tunnel.h b/include/net/ip6_tunnel.h
index 1253cbb4b0a45..359b595f1df93 100644
--- a/include/net/ip6_tunnel.h
+++ b/include/net/ip6_tunnel.h
@@ -156,10 +156,12 @@ static inline void ip6tunnel_xmit(struct sock *sk, struct sk_buff *skb,
 {
 	int pkt_len, err;
 
-	if (dev_recursion_level() > IP_TUNNEL_RECURSION_LIMIT) {
-		net_crit_ratelimited("Dead loop on virtual device %s, fix it urgently!\n",
-				     dev->name);
-		DEV_STATS_INC(dev, tx_errors);
+	if (unlikely(dev_recursion_level() > IP_TUNNEL_RECURSION_LIMIT)) {
+		if (dev) {
+			net_crit_ratelimited("Dead loop on virtual device %s, fix it urgently!\n",
+					     dev->name);
+			DEV_STATS_INC(dev, tx_errors);
+		}
 		kfree_skb(skb);
 		return;
 	}
diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index b1b6bf949f65a..5683c328990f4 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -58,10 +58,12 @@ void iptunnel_xmit(struct sock *sk, struct rtable *rt, struct sk_buff *skb,
 	struct iphdr *iph;
 	int err;
 
-	if (dev_recursion_level() > IP_TUNNEL_RECURSION_LIMIT) {
-		net_crit_ratelimited("Dead loop on virtual device %s, fix it urgently!\n",
-				     dev->name);
-		DEV_STATS_INC(dev, tx_errors);
+	if (unlikely(dev_recursion_level() > IP_TUNNEL_RECURSION_LIMIT)) {
+		if (dev) {
+			net_crit_ratelimited("Dead loop on virtual device %s, fix it urgently!\n",
+					     dev->name);
+			DEV_STATS_INC(dev, tx_errors);
+		}
 		ip_rt_put(rt);
 		kfree_skb(skb);
 		return;
-- 
2.51.0



