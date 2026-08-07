Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F46C3803D9;
	Fri,  7 Aug 2026 15:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114883; cv=none; b=dGQ8G570lpEek0ZRZEyHMpLBSfZ+QlXlm30q/cU2CIJPOY09JzAsz7vinSusk4Vdk4unWlHR2V3SpgfqiP6vnD04/cZSxCH8BijpDCc9lfb96n/pXLKcPgb2KnWD3aRVIlXR0wtk+hA7MxHBzMX6y2bU/D+A1ddfKjFf6cE/OVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114883; c=relaxed/simple;
	bh=ETkqfjfgNiNOX7/eiAeSjhQ87cekCufMUz6n/R++x2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=grXKlYLz4R2vx1mr0OI4VmY7NXliC3y60rAutBqCWWL6LaRdt4w/4N6gQg3Cda2A+rvcbvqs0v0FMz9FIn58bu94CLwVSilMCCehBgDvPOQjolOS+p21VgWjN1dT3qkTL6n/TvU4w4v/QJ+l8yYUPcAyTJg7PZ988tuFffSs7O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fT/r6wxv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fT/r6wxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE1F1F00A3A;
	Fri,  7 Aug 2026 15:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114882;
	bh=lIXvm/t7QYXQKPdzts4I1OztqgLuWkeXIW0V5y5QwiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fT/r6wxvYyjT3OFpcfQ5qjbzVax5kIZNPbqtaRTQ34WRo/vYkErZSztdSJWpibhIV
	 xMVGog9K1lpPOxCytIPOmmroieJ+6kX37Ttwf4Nx/xbl0jNlDAphl/Cp5cw6ryMSYL
	 rn9hR8106KO4SS/siSB8HkvfyA7Hp5RIrXRX7vaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 080/396] net: do not send ICMP/NDISC Redirects when peer allocation fails
Date: Fri,  7 Aug 2026 16:34:00 +0200
Message-ID: <20260807143425.995701446@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
index 11d990703d31a..778467bea476a 100644
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
index 8f37c9cc868b0..9ef6581168f0f 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -630,7 +630,7 @@ int ip6_forward(struct sk_buff *skb)
 		/* Limit redirects both by destination (here)
 		   and by source (inside ndisc_send_redirect)
 		 */
-		if (inet_peer_xrlim_allow(peer, 1*HZ))
+		if (peer && inet_peer_xrlim_allow(peer, 1*HZ))
 			ndisc_send_redirect(skb, target);
 		rcu_read_unlock();
 	} else {
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 9df1fba967c6e..7262356de10d9 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1706,6 +1706,8 @@ void ndisc_send_redirect(struct sk_buff *skb, const struct in6_addr *target)
 	}
 
 	peer = inet_getpeer_v6(net->ipv6.peers, &ipv6_hdr(skb)->saddr);
+	if (!peer)
+		goto release;
 	ret = inet_peer_xrlim_allow(peer, 1*HZ);
 
 	if (!ret)
-- 
2.53.0



