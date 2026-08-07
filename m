Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF111372EED;
	Fri,  7 Aug 2026 14:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113907; cv=none; b=JA+2mrKBtiZjyVRPXLsvsyckLXpU+aRf7UjUXoOIK9tY914W0nR6TROOx+ErL4ebHjSeuzAGoZjzms03/NkslFAXkwF6EP4rzDJo5OsOO4hPURmx1EyPf0HY3OD10jXlBdd6E8QehYEZTRfuqRmNJL7ggdDNDIVnCG3b4ZUH3j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113907; c=relaxed/simple;
	bh=rU/L84ROtpBibOtvzvOrH8tLTiKBzqxqr0hTzfL//KE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rI77qNFkseY7PxpUoX+jUEnsgOsGal33XQZ9o6Ipu5b0tzCeiFglkMNzYsWmwF6pqSBHikX7bYH5+syPuH4iJHFpweZLq7iQLBvrpiJ9kq673TiWIdz5/aJRSiKqQQ+XcuZKXxuhC6463TOluS4qWp9W64Mb9wCZQOWtEvdGxpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DpP+RDbM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DpP+RDbM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4EB1F00A3D;
	Fri,  7 Aug 2026 14:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113900;
	bh=LqJb95+wq5fpl8zppp0HxOnJU9WQXslJL8wlbkhLToc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DpP+RDbMw/1c8Ol3X9bm581eHHuutXsS3UbMH27r6Dyj/aoe3swhp5uVU0eOs7Egv
	 BJ+7Y1XvGV1GDEMN5FN4RsCxup2MHKv3AhCYuWzTBBu+RDO6lUbtIkWs+0zpkXc7SX
	 8e0Q8wVJVKnivUvxhDy3DfSt9xO24K5FQTTx28oQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 072/337] net: do not send ICMP/NDISC Redirects when peer allocation fails
Date: Fri,  7 Aug 2026 16:34:35 +0200
Message-ID: <20260807143420.072010531@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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
index 4dce0de6ab898..2b8c29a29c4ae 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -890,8 +890,6 @@ void ip_rt_send_redirect(struct sk_buff *skb)
 	peer = inet_getpeer_v4(net->ipv4.peers, ip_hdr(skb)->saddr, vif);
 	if (!peer) {
 		rcu_read_unlock();
-		icmp_send(skb, ICMP_REDIRECT, ICMP_REDIR_HOST,
-			  rt_nexthop(rt, ip_hdr(skb)->daddr));
 		return;
 	}
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 50b41be5d38d0..5d17982cb9946 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -627,7 +627,7 @@ int ip6_forward(struct sk_buff *skb)
 		/* Limit redirects both by destination (here)
 		   and by source (inside ndisc_send_redirect)
 		 */
-		if (inet_peer_xrlim_allow(peer, 1*HZ))
+		if (peer && inet_peer_xrlim_allow(peer, 1*HZ))
 			ndisc_send_redirect(skb, target);
 		rcu_read_unlock();
 	} else {
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 73e2e457e30be..1a759519a90f9 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1739,6 +1739,8 @@ void ndisc_send_redirect(struct sk_buff *skb, const struct in6_addr *target)
 
 	rcu_read_lock();
 	peer = inet_getpeer_v6(net->ipv6.peers, &ipv6_hdr(skb)->saddr);
+	if (!peer)
+		goto release;
 	ret = inet_peer_xrlim_allow(peer, 1*HZ);
 	rcu_read_unlock();
 
-- 
2.53.0



