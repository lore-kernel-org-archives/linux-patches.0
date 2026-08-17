Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B164418E4;
	Mon, 17 Aug 2026 15:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979802; cv=none; b=M65jw8AVwwYg/PckGBrWt7bIe93Bf6VtAvTt/YN8W463i6GkCUyyXHslSfK8luxPFA/9FOoVdHCjnTg8qVwHH8bHT4W/01eqPfr67jxcH3SJmiOBlD5CEOPgchXyt6E6e0bER6TN0Ntu+VT/Ll598uE6KUsRjMkHNsYFEBaGYpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979802; c=relaxed/simple;
	bh=ds/LXE96Cp4FKQXPbqaTtGN6G5Cn1ym+gGNNLhXLR9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hT3W9h+JSS91r9pgaLaIv826E+4UFo96WtyzFajrPWfBUUeiSw2uCJuDPXww+4Mg9q24Ki8ij5eZgYND1qiqXoWUa4jknFU4j94+n2fy0fJ3S8GBGwXJa96rvBH3owibA+SJufvo9pm7Pfn6eHWaIXUD1VKdEYC0JaaMVgSx6N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kuLfrCpD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kuLfrCpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C87A1F000E9;
	Mon, 17 Aug 2026 15:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979798;
	bh=GpeJHm6XV/8kuv5zmJoC6A0E+aYtc5wxWbds7+ChbSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kuLfrCpD9XI2v0WRpl0HAvkLbCvB11MY+AC0ZE+x9EOVVAWlk9Gv3qOO2CsAwJ7lj
	 06A2iO0IQybORkgdjrPKL2AF121GFvm34J3bkkOTNpBqyAWvtRjBUzHEbmXygempeu
	 cl3rIpvBVxV3hOuLNyhpUM95EYRFZ44E59RQYP04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 350/609] net: do not send ICMP/NDISC Redirects when peer allocation fails
Date: Mon, 17 Aug 2026 15:30:46 +0200
Message-ID: <20260817132555.984558076@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
index 60516c6ae62e0..f9d2d4268c616 100644
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
index ad821d362656f..93e55ab7e0f6d 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -623,7 +623,7 @@ int ip6_forward(struct sk_buff *skb)
 		/* Limit redirects both by destination (here)
 		   and by source (inside ndisc_send_redirect)
 		 */
-		if (inet_peer_xrlim_allow(peer, 1*HZ))
+		if (peer && inet_peer_xrlim_allow(peer, 1*HZ))
 			ndisc_send_redirect(skb, target);
 		rcu_read_unlock();
 	} else {
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index a53d2a6a99f85..585a9135cf267 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1727,6 +1727,8 @@ void ndisc_send_redirect(struct sk_buff *skb, const struct in6_addr *target)
 
 	rcu_read_lock();
 	peer = inet_getpeer_v6(net->ipv6.peers, &ipv6_hdr(skb)->saddr);
+	if (!peer)
+		goto release;
 	ret = inet_peer_xrlim_allow(peer, 1*HZ);
 	rcu_read_unlock();
 
-- 
2.53.0



