Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4571D2F0C74;
	Fri,  7 Aug 2026 15:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115913; cv=none; b=FakhUlPDjjHkxuMTlpm1V1ioJ57I//KZTvs0hmzA9bBLwXa3kLg8R7MqzzuXbbDO542Qe34cjkQRH0w7cu1/5NBMjf4EwXjIqfkoMjbRKyvHbDFcP5UJ7wQ0w8DFepD1vxrTrkyKLeK/9bGQJ9cUrJljk+GwCSVXWSSB5aKzn6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115913; c=relaxed/simple;
	bh=OkHNP2TtIOe1J8p0zBTqVqCuQHxwF9TgL4QmulF9/9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCnEJMEbjyKkzzTgz+AizzUOsFYJMgHUBQQIaTWqX7eiB7XqGYcNHGqcwgLy9cdiMC7x7fqd9Q9bjcVTJqZnY1Ay4T7q2glSaKv50wW90Eshfq53l/en8kjRdpxmWdJ2VjeLnSvg4PNVGfbSyWp87wx2asaFR3wj6aaNgPotw2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vg2K1Zdc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vg2K1Zdc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17BF1F00A3A;
	Fri,  7 Aug 2026 15:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115912;
	bh=bOzJbe5xMpCdOs0bZuuyNskxCg4hCvIaXMyzJqbHAGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vg2K1ZdctAKOabdChoRKadK5IfKOjfpW7vp7pTgQ9IwrKW3miuj6xKkT1t+eB/e7L
	 mLkUbJUjZVW/loscUWldguJDV0fMrNJT/YnQ6lTaTVY8Jz5zmL4wpaPAo6DfUEHSrM
	 ykDnKnztY9uVnJymhPTzSopo7f9KDQMgAs3Xh0WQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/261] net: do not send ICMP/NDISC Redirects when peer allocation fails
Date: Fri,  7 Aug 2026 16:36:43 +0200
Message-ID: <20260807143416.378690215@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit dbc3791e3b2472e1ccc08947e0f83b443470ff4f ]

When inet_getpeer_v4() or inet_getpeer_v6() fails to allocate a peer entry
under memory pressure or tree size caps, redirect handlers previously fell
back to sending un-rate-limited ICMP/NDISC Redirect messages.

In IPv4, ip_rt_send_redirect() called icmp_send() directly when peer == NULL.
In IPv6, ip6_forward() and ndisc_send_redirect() passed a NULL peer into
inet_peer_xrlim_allow(), which returned true when peer == NULL.

Because ICMP/NDISC Redirects are not part of the default global rate limit
mask (sysctl_icmp_ratemask), sending redirects when peer == NULL creates
an un-rate-limited ICMP packet storm.

Fix this by failing closed in ip_rt_send_redirect(), ip6_forward(), and
ndisc_send_redirect() when peer is NULL.

Fixes: 92d868292634 ("inetpeer: Move ICMP rate limiting state into inet_peer entries.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260724072901.1633601-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c      | 2 --
 net/ipv6/ip6_output.c | 2 +-
 net/ipv6/ndisc.c      | 2 ++
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index f134c59f839e2..834ec1f34e506 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -902,8 +902,6 @@ void ip_rt_send_redirect(struct sk_buff *skb)
 	peer = inet_getpeer_v4(net->ipv4.peers, ip_hdr(skb)->saddr, vif);
 	if (!peer) {
 		rcu_read_unlock();
-		icmp_send(skb, ICMP_REDIRECT, ICMP_REDIR_HOST,
-			  rt_nexthop(rt, ip_hdr(skb)->daddr));
 		return;
 	}
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 2e2cd0e0d48a5..5ee625d81942a 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -625,7 +625,7 @@ int ip6_forward(struct sk_buff *skb)
 		/* Limit redirects both by destination (here)
 		   and by source (inside ndisc_send_redirect)
 		 */
-		if (inet_peer_xrlim_allow(peer, 1*HZ))
+		if (peer && inet_peer_xrlim_allow(peer, 1*HZ))
 			ndisc_send_redirect(skb, target);
 		rcu_read_unlock();
 	} else {
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 342e7066f765f..8adb31804f01b 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1731,6 +1731,8 @@ void ndisc_send_redirect(struct sk_buff *skb, const struct in6_addr *target)
 
 	rcu_read_lock();
 	peer = inet_getpeer_v6(net->ipv6.peers, &ipv6_hdr(skb)->saddr);
+	if (!peer)
+		goto release;
 	ret = inet_peer_xrlim_allow(peer, 1*HZ);
 	rcu_read_unlock();
 
-- 
2.53.0



