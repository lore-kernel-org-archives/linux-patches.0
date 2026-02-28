Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D5C359A60
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302395; cv=none; b=GuHHDS1MWg9jDEFopQepxYBQbJ36FZsyc3TpPTWq/9kwlqd3uPdVEnjL//EZwYWgYX7ucJ9V27+NDsRpVHJSrUcPMr38GKGfN6J1tTn+9yqHCI94ROMZGHyFHr9REW7wxNCBe9XbGGw+cPGF/2sokKfir/KMxdPdNwNKlje2+wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302395; c=relaxed/simple;
	bh=gX4bI8l09+YbjsUSMiPfjk/5a6UX8Ci+u5J1PXNECGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYT87/tKpvDgyi7bv5EzKpcX3OLNyplM5oeRFVjk4qVqkUIlexChyHgzMY6b+jvbyN4TSPQPhvgYbaRz0KCGy6F3LYliel+AWe2c2Ce8ZcQCaCrEsWjfI86HN0YIqYVMSd7FtZceHdUIGy0TBOM2mXvEkRAFG8OitGlYeJhVN1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uWnGe3hs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uWnGe3hs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09966C19423;
	Sat, 28 Feb 2026 18:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302395;
	bh=gX4bI8l09+YbjsUSMiPfjk/5a6UX8Ci+u5J1PXNECGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uWnGe3hsSBk5uyrRuXa9dcF2hUR7icslvea7A5ycAK9i6LTIo6HcgrqQjoheUfiiM
	 bqtmt9u5VtJptofbWjEcEoLJYWM03J9PZtNUNMtKpCNO18hj4CUU8E0HmKbiXwx+CY
	 kyR8Np4r8Kzm358bQ4LjoijR1zYsBRuEZdzawDoOaiUOEoExWLAexqDcpPW60Pt3dr
	 wFY2Z8eiHEfotvgh7J2aLrU6f+8FHDvfzxqZXUyuaB721WjaRZmm51CRrhELwNu4I5
	 dpRU2abX9W/9oGDGp9J3OvLiY5rFQxQohUjvwUljbrBy7OvzL6PdGM96+zcYC19QTQ
	 b9f9JnZYYOv7g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 125/232] net: Switch to skb_dstref_steal/skb_dstref_restore for ip_route_input callers
Date: Sat, 28 Feb 2026 13:09:38 -0500
Message-ID: <20260228181127.1592657-125-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index b17549c4e5de8..9e1a574384aa6 100644
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

