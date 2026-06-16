Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3153935292A;
	Tue, 16 Jun 2026 18:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634049; cv=none; b=vGOv7Exut+uaA1YF5OjnRES2i3gHAa392fHvkdWreS9Z2++GgiljrRfXNG1e18Sr5Vs+xyKZJAkN6xKoXbE0u7qdE+tystJOomaI3HMwGqwhXDcwQx91ffCRg8traaakLgeG7YAluPsbxflW4GJEFdFPP+qjJbQLtWaPV6v036k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634049; c=relaxed/simple;
	bh=7/XV1tIBY8w1MrUFj0BAZsXsXmDaHzlxPcv9+ljI7kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOqbw1F5FHGz/eFiX8SyCUD0xc4WxeNo2/Bv3oZxon5VCvYKj5tSqpLf+aPNvTcEJZkSwtoxkF2rifJxjZ3wA1pfNRqkIcQfg77ElLulV6YXeb/by+Uc7ONVaGJbq5tEZNro9Gc9kAGuunoFL/nxbBrnRmWL05bjTtxd8nEzhu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5+Mms66; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5+Mms66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32FD71F000E9;
	Tue, 16 Jun 2026 18:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634048;
	bh=kluWo6FEPJzpAtWxNyePsS5USJH9NFi3kYSPOR7qwAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P5+Mms66E3y6nWrF0wc9cBtdVWB70OskpNMuksvEnY92rAIhlq2TN1GKebu+2gBam
	 av4mDrGZox5vy4oEcYYvMhnaSVhwAQwPJw3iVP8KJ5VqCm5yVF+k3DGPbzxT/68k3m
	 S4D4m3wPv+CLPxVrd1pTpw+mB/udQY0sLV7H5FBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 190/411] ip6_vti: fix incorrect tunnel matching in vti6_tnl_lookup()
Date: Tue, 16 Jun 2026 20:27:08 +0530
Message-ID: <20260616145110.804165879@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4f5093b36b3e36..077aae4b1bb332 100644
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



