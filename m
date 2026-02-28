Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C5C333434
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301822; cv=none; b=mTrJoozRA5ZMPEAqVJBp+T+73p5kaZlY+HHU5J4nCoJi0DhKdbh5aVqbu8eR3RPS3u74wLbe8lMvMjcW3DmJ0VcrjDeXw55Q4G8gFZoHLDyeNovcxynldbB1xmMAZ4NCkfj0et2q21X1f/KVbyjsgeHSuTjCNbjXIZ5Fj+0rjTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301822; c=relaxed/simple;
	bh=YDJNLYmWag3j6u1shiQ7Asl8IBw2ASYLWDkFY6XjXwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qXtwdNim7el7TdUbeJF4m9PW2WQUQTdgBEiEt1rzS3GMctHZTbR8HbcFr00AmmqRDSrDPkTWCNtfI/McZuw7UhNVRzYBI923vu7rNamGCPecbJ/qQKlFrlCFg4BVI6xy/3SiuacDG0BnBH0s6OrM23U7OjFQyOGI0nHnreQ/BoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tykqhv6L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tykqhv6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C622FC19423;
	Sat, 28 Feb 2026 18:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301822;
	bh=YDJNLYmWag3j6u1shiQ7Asl8IBw2ASYLWDkFY6XjXwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tykqhv6LZMIPJm1fe1wnqtzqKVZP2sYsu93EWIHUHHEsLtzS2BB8tSH0oDHl8PuOo
	 OVMbkpcTXKmYVQHX86eHqwHsC0zieC8DByjockIJampywteLaikzNgDISWsL9iNUTE
	 zMk2+fisS8MFqK7CUt0BpSSW3U3qZhNato4YZ+W1jH00wiemEX7AO1yo6XlhkOhv9l
	 UoGPD8nVdgCM/AdZmTDSLM7/5yqfcsH1NWTDxzOa7ESqwvXGqrDzvLf/4/276oHEJD
	 cQhMNJuRMPukPzXeaWctk9bjmck1jIsLotn9wsliCT6Rpbjl6NyjRwHrfMjNaX1ppV
	 WtPoMPR1DprSA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 237/385] net: Switch to skb_dstref_steal/skb_dstref_restore for ip_route_input callers
Date: Sat, 28 Feb 2026 12:57:39 -0500
Message-ID: <20260228180011.1568201-237-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Stanislav Fomichev <sdf@fomichev.me>

[ Upstream commit e97e6a1830ddb5885ba312e56b6fa3aa39b5f47e ]

Going forward skb_dst_set will assert that skb dst_entry
is empty during skb_dst_set. skb_dstref_steal is added to reset
existing entry without doing refcnt. skb_dstref_restore should
be used to restore the previous entry. Convert icmp_route_lookup
and ip_options_rcv_srr to these helpers. Add extra call to
skb_dstref_reset to icmp_route_lookup to clear the ip_route_input
entry.

Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20250818154032.3173645-5-sdf@fomichev.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 81b84de32bb2 ("xfrm: fix ip_rt_bug race in icmp_route_lookup reverse path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c       | 7 ++++---
 net/ipv4/ip_options.c | 5 ++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index c0373d1172d73..2bda14908273c 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -546,14 +546,15 @@ static struct rtable *icmp_route_lookup(struct net *net, struct flowi4 *fl4,
 			goto relookup_failed;
 		}
 		/* Ugh! */
-		orefdst = skb_in->_skb_refdst; /* save old refdst */
-		skb_dst_set(skb_in, NULL);
+		orefdst = skb_dstref_steal(skb_in);
 		err = ip_route_input(skb_in, fl4_dec.daddr, fl4_dec.saddr,
 				     dscp, rt2->dst.dev);
 
 		dst_release(&rt2->dst);
 		rt2 = skb_rtable(skb_in);
-		skb_in->_skb_refdst = orefdst; /* restore old refdst */
+		/* steal dst entry from skb_in, don't drop refcnt */
+		skb_dstref_steal(skb_in);
+		skb_dstref_restore(skb_in, orefdst);
 	}
 
 	if (err)
diff --git a/net/ipv4/ip_options.c b/net/ipv4/ip_options.c
index 81e86e5defee6..3d154bc7e1f2e 100644
--- a/net/ipv4/ip_options.c
+++ b/net/ipv4/ip_options.c
@@ -615,14 +615,13 @@ int ip_options_rcv_srr(struct sk_buff *skb, struct net_device *dev)
 		}
 		memcpy(&nexthop, &optptr[srrptr-1], 4);
 
-		orefdst = skb->_skb_refdst;
-		skb_dst_set(skb, NULL);
+		orefdst = skb_dstref_steal(skb);
 		err = ip_route_input(skb, nexthop, iph->saddr, ip4h_dscp(iph),
 				     dev);
 		rt2 = skb_rtable(skb);
 		if (err || (rt2->rt_type != RTN_UNICAST && rt2->rt_type != RTN_LOCAL)) {
 			skb_dst_drop(skb);
-			skb->_skb_refdst = orefdst;
+			skb_dstref_restore(skb, orefdst);
 			return -EINVAL;
 		}
 		refdst_drop(orefdst);
-- 
2.51.0

