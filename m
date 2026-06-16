Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7486A43D4E9;
	Tue, 16 Jun 2026 17:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629388; cv=none; b=inCKrGzBXA666VEeGtdpiy/HWd7q1qdbOtlb9NK7ScDfS02+QpVa+wBSttmFz7gT2xooSlfoP03hey562GMzRSP0w/VZpYP6y5PSBGHmBeDlfNIceBMK9MhpZ3mCzjS8CuTIPCZg4UGuSJhxA8L4tGZTDbd4Ji21QKAMZNvBCd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629388; c=relaxed/simple;
	bh=Cb7J/Fs2rJWCzdcEnPPusXSFixlnKk1ldeKz1HWotE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BV61sOebHoVCPK/yjbcrZXGJ8C0RSXaLV2KAttB6GP1B1FcQZWgxdMd8g3B3iBhs94VTrf/gsKuh5cQ008EuGo7F3nhg13rgNPTqo2OPgiCqKu8ivKtnWM0t9Rm0s7dF+wNQti8id1eb5s/eO/CN20jQDMemzR1rl4Z0i9r7n3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qAVGY5LX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qAVGY5LX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766EB1F000E9;
	Tue, 16 Jun 2026 17:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629387;
	bh=8braIcAlR9IAb9IECQkwBvT0767JLQuIONbfW0aVA6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qAVGY5LXwyCISCbKzbY6EKGJ5h6+ZIu9tWzQiyUfzcnzxQCcKUwy8QAFF5w8McmxW
	 z0qx89qCj5+y0Pz6DdaexWarni9ZCjVzxTh2xCuixdEP5nlLpLdxNUD7l+HDOlcapT
	 aWP6oATrTFA+/3k7eMmp2tmgkCTIk26cqr90e05k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 275/452] ip6_vti: fix incorrect tunnel matching in vti6_tnl_lookup()
Date: Tue, 16 Jun 2026 20:28:22 +0530
Message-ID: <20260616145132.096719958@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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
index 5e71dbd9401694..67cf616c1499a4 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -105,6 +105,7 @@ vti6_tnl_lookup(struct net *net, const struct in6_addr *remote,
 	hash = HASH(&any, local);
 	for_each_vti6_tunnel_rcu(ip6n->tnls_r_l[hash]) {
 		if (ipv6_addr_equal(local, &t->parms.laddr) &&
+		    ipv6_addr_any(&t->parms.raddr) &&
 		    (t->dev->flags & IFF_UP))
 			return t;
 	}
@@ -112,6 +113,7 @@ vti6_tnl_lookup(struct net *net, const struct in6_addr *remote,
 	hash = HASH(remote, &any);
 	for_each_vti6_tunnel_rcu(ip6n->tnls_r_l[hash]) {
 		if (ipv6_addr_equal(remote, &t->parms.raddr) &&
+		    ipv6_addr_any(&t->parms.laddr) &&
 		    (t->dev->flags & IFF_UP))
 			return t;
 	}
-- 
2.53.0



