Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F063238D014
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302160; cv=none; b=I+cdDqBeqSuCFxQeR0J08+QlmaU/wRaWXjLgE2oimvaqvUl1tVM7CYY2OCtesFq1PJ/potRrvFftlEalLlLNesJ7apwPqbLIGFliJ4SMNr10gnvuykY2N+SkwSTxADDXSvsn1sbzhu3Jiq3tq6wPR01mJIzP1UQenJyG8I2miZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302160; c=relaxed/simple;
	bh=SHHcD6mCH41TIvd9JVpEpHmIV58Z0XzCT7Ga0jtSiM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGuI0CJUmsE8r26Wa8Nlpt3zRRqB5nNpam0kpdQtoztaX9GG0cI+EcJokumM2xucYZYPg9mRexZE2FvPl/oR3zWrpYDJ5gpY4B2U0zP59e/KjU8u2U08jBsHoD5nRgoHJ2nGjhdMDlBSPAH+7uDbUXFSeXzacf9yEdfJzpIzfcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MzBAKjO5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MzBAKjO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F629C19423;
	Sat, 28 Feb 2026 18:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302159;
	bh=SHHcD6mCH41TIvd9JVpEpHmIV58Z0XzCT7Ga0jtSiM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MzBAKjO5FV2u9YV7t9thaFSMAVUcE13umEV1UhbocFmEt27V2WiQEem/v193GkJzo
	 IWBXOT6sdmiT+JZgVYzmPeu3619uaD+vESQQaTFNF8yhyrZfD2xhLk/iHmRlW62Wgt
	 SQakDTidSbPRKgdQv3YHtmXJSMddJtkBscD8rspgppKDoIMaYk20fK5R/7FzqBjrE6
	 IyRfxY2iHn9APq2GnrYDIBIn9WMqa5SeXtt5RADc4eSyuzFqRa5fGI6gq6hri3tLry
	 icRt1a1VVhyr0ibL75/mmMI7CZGIeTt+iKQpwa8sJ9dKSOh+/5FjYDGNl2B0GBBQit
	 3S0pW2UcdGVqw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 155/283] net: Switch to skb_dstref_steal/skb_dstref_restore for ip_route_input callers
Date: Sat, 28 Feb 2026 13:04:57 -0500
Message-ID: <20260228180709.1583486-155-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index f3cdfc09d7f06..efa589a1e7a38 100644
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
index b4c59708fc095..d898e1523a453 100644
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

