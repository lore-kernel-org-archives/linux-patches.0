Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A4F31327A;
	Fri,  7 Aug 2026 15:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116810; cv=none; b=V0DCTTz9KDJfmjPWNE26Gc0Dewdzukl1i576SAitgbfFiAEDN6dIXZQqkrrSfKgDqy2rYnimtfa4ndaSPR8VavKeMoELCIrWNJ3Ca+lRk/nfwODjDMn14yd6tbjW/63M4+BJgSheCc44M3IgKGAOuzQwIR+dyiUYCqdZCLno8hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116810; c=relaxed/simple;
	bh=H/82X9CFBBIAFUQz9ervpuGJSEO32r18ep4qcKxg5sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1zamsGUHWOYXVhieeD8TgxG1TDv4b4Fo2FMGkLv/4gHjqGjfhRuwzjyRvtl1RSqzx8+mvpk2vP0+TXLS+Re/OlVk40DtvLws/Qwng3HhP77Cd1sGMgzPythc0AaP1GEDPml5MVyANxRtH1nrNEHwED91AMK7Xc+6G1GlpHgA/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bliYDv7k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bliYDv7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C581F00A3D;
	Fri,  7 Aug 2026 15:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116808;
	bh=tXIf3EnjRE4gOcLjBX4vj1vojn9m2XlDRbgAfhwwyb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bliYDv7kT+ZTWxBkPvNLRoBvEE07umYjVQjxtxGaO9ZfnGFa5bIhIlXSzW+Epvkws
	 QfjdmORMSE86Q7n0PaIqRu+mKX6eGy5sKXYzSs1U59f93oVhz+JMmF1xdMm1dmndBU
	 8DPLr+sKtuNdHMNLxakRggu0Nb9N2gabWYTCqrv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 097/438] net: do not send ICMP/NDISC Redirects when peer allocation fails
Date: Fri,  7 Aug 2026 16:34:53 +0200
Message-ID: <20260807143430.058261983@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3d62d45d84bda..7cc9a7336c30a 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -892,8 +892,6 @@ void ip_rt_send_redirect(struct sk_buff *skb)
 	peer = inet_getpeer_v4(net->ipv4.peers, ip_hdr(skb)->saddr, vif);
 	if (!peer) {
 		rcu_read_unlock();
-		icmp_send(skb, ICMP_REDIRECT, ICMP_REDIR_HOST,
-			  rt_nexthop(rt, ip_hdr(skb)->daddr));
 		return;
 	}
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index b5d9c57fe439f..634f581e17114 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -641,7 +641,7 @@ int ip6_forward(struct sk_buff *skb)
 		/* Limit redirects both by destination (here)
 		   and by source (inside ndisc_send_redirect)
 		 */
-		if (inet_peer_xrlim_allow(peer, 1*HZ))
+		if (peer && inet_peer_xrlim_allow(peer, 1*HZ))
 			ndisc_send_redirect(skb, target);
 		rcu_read_unlock();
 	} else {
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index f867ec8d3d905..fe36b3f512850 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1707,6 +1707,8 @@ void ndisc_send_redirect(struct sk_buff *skb, const struct in6_addr *target)
 	}
 
 	peer = inet_getpeer_v6(net->ipv6.peers, &ipv6_hdr(skb)->saddr);
+	if (!peer)
+		goto release;
 	ret = inet_peer_xrlim_allow(peer, 1*HZ);
 
 	if (!ret)
-- 
2.53.0



