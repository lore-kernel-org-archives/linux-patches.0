Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CAB823DD;
	Mon, 23 Mar 2026 14:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275401; cv=none; b=iXh6LZ3oRNZfhHi4BmXTv3tfeFFgkviwkq4BZdfeV5IEYRlGRh5piwoWCBFhvG5uC/o7CHNK7jkwEFx3aC5IxHQ6rrjm0RS6dN90/Adv7SWoXLAlho68Kk9yNIHMU9OYNVvutK72dUiKZOFrfBioszbYFNS5w95eLFrogTxwQuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275401; c=relaxed/simple;
	bh=+SeJSods1RsMBVxgN2dP07SPfLu8lQqQpo/XW80hbxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqlyGVEEPZrhJzzQIJg7QQle22mB3zGvrWsvUnAF+Z9Zpt8aHAVhIitXAYCtJX+cEEl4Gg3tvyevQNqkkH9uOLwg4SllEaA/HmMsgmMVjycN1SwAcL9wOef5A5CszG87f8SsWWNF5dPx7PhDgPamC6S9ajolTuQmgB7YPaXDDp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cs7bq/uH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cs7bq/uH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28FBC4CEF7;
	Mon, 23 Mar 2026 14:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275401;
	bh=+SeJSods1RsMBVxgN2dP07SPfLu8lQqQpo/XW80hbxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cs7bq/uHv08pjufTLG+E2miBgxSwehVoNmc/oedGFI4LBWT7MoocUb4MKU7q2BIVR
	 OY+PMirl7ql7I76EUPRZAIgeQTyJWmrLM93QUiPMWeY5iKRZWJpEX//FUYJVpOub28
	 86PP51GGv3HKyuwhcxCFCYqWBjxY0PLNYADyZhO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Weiming Shi <bestswngs@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 085/460] net: prevent NULL deref in ip[6]tunnel_xmit()
Date: Mon, 23 Mar 2026 14:41:21 +0100
Message-ID: <20260323134528.766166475@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index dfdb4dba5be8f..17913fca5445a 100644
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
index 53d02602c17a3..507f2f9ec400c 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -57,10 +57,12 @@ void iptunnel_xmit(struct sock *sk, struct rtable *rt, struct sk_buff *skb,
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



