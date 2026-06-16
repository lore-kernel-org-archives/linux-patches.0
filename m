Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659FA34D90C;
	Tue, 16 Jun 2026 15:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623393; cv=none; b=XFXqp7t/mVO18owqd5LUt/XWXMOhoKw9lxhulwascamlVzW1Q9g0dWaoEI6CQiLra8Fuxaovd5gFz3EtmcO25F5Zs0IYys99gm0WY60PjuXwjofszDgxGg3e255RG+Zz6EZRQyJhQgukmTBHcPfHb1N+IeAJ/iWOvn/qhi4QTBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623393; c=relaxed/simple;
	bh=SfRJqp6S9mFZlLbkshzXM7H2wt2OAQTptudOvP9KnfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KB3/3mrni7R9AROj7XWQnCrRRrMPjw3A+gbK7M2pU/EqOsJHLUTAePmHHrsrTkxaNvOP93ReprcZIKFSLWXfg+Rpxvm565qSt7MvesU7hVorav+eQmWYUATVYynC0A053/VzS2FZ3E7ueyCqwa+UYG6yoB5ESHFJEIFkmQnSqmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G/GnQisI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/GnQisI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ADE51F000E9;
	Tue, 16 Jun 2026 15:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623392;
	bh=VkWYeqpLE7G8Qu2CEvw2tHBqdt60UBSzxZXFgtD7iAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G/GnQisI/72CbMhDeR2AF9xMb42NtRsdPNGrmHfnOti0yw+z1656dwpRRTHr84Vzc
	 4kM5MwVGv7s/h+mOQaQVMbeexNK1zW24awRtFVSQWTLm7SWDnXNgqyn6awXQpchZCw
	 MwUKjvqDvwJgCfWvd14LBB1TSOlFz7rstLlVjPvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 138/378] ip6_vti: fix incorrect tunnel matching in vti6_tnl_lookup()
Date: Tue, 16 Jun 2026 20:26:09 +0530
Message-ID: <20260616145117.549369528@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a5c0359f5cbc51a2e2b114d6041e0f3c73f903e9 ]

In vti6_tnl_lookup(), when an exact match for a tunnel fails,
the code falls back to searching for wildcard tunnels:

- Tunnels matching the packet's local address, with any remote address
  wildcard remote).

- Tunnels matching the packet's remote address, with any local address
  (wildcard local).

However, vti6 stores all these different types of tunnels in the same
hash table (ip6n->tnls_r_l) prone to hash collisions.

The bug is that the fallback search loops in vti6_tnl_lookup() were
missing checks to ensure that the candidate tunnel actually has
a wildcard address.

Fixes: fbe68ee87522 ("vti6: Add a lookup method for tunnels with wildcard endpoints.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Link: https://patch.msgid.link/20260608164613.933023-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_vti.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index d2b74a6f2cf62d..d871cab6938d36 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -106,6 +106,7 @@ vti6_tnl_lookup(struct net *net, const struct in6_addr *remote,
 	hash = HASH(&any, local);
 	for_each_vti6_tunnel_rcu(ip6n->tnls_r_l[hash]) {
 		if (ipv6_addr_equal(local, &t->parms.laddr) &&
+		    ipv6_addr_any(&t->parms.raddr) &&
 		    (t->dev->flags & IFF_UP))
 			return t;
 	}
@@ -113,6 +114,7 @@ vti6_tnl_lookup(struct net *net, const struct in6_addr *remote,
 	hash = HASH(remote, &any);
 	for_each_vti6_tunnel_rcu(ip6n->tnls_r_l[hash]) {
 		if (ipv6_addr_equal(remote, &t->parms.raddr) &&
+		    ipv6_addr_any(&t->parms.laddr) &&
 		    (t->dev->flags & IFF_UP))
 			return t;
 	}
-- 
2.53.0



