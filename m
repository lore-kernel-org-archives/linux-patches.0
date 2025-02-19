Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911F51E378C;
	Wed, 19 Feb 2025 08:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955260; cv=none; b=qaKJ5hd0btGNNUQ6XDXipAeOnWYqBcgdAcjEYtcE8e+wj1ocXQK7vIikW7DB4Yvxrwry6PdlxsJ+3r02SDgUGJYyJorUz2gcxXiXZ3t/2FDwTBwWNEfIIbE2TR78cbOgqVqD416Lr0WqFUziy91/gb8YdLaqYbiyypQdxT/Ko5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955260; c=relaxed/simple;
	bh=R63+F9GsSdCnh/jF1XCI0MMtNmllJwjWgGXmkeXfKBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iti+2amWwz2xtL/Dw11cwirAvuhZQjRI++eP5F3HEW0uxjvHJ7qc+YwmUx+HSGaeobhW8+rIOYzRT6x1N3/BU3X6CvtZH8vArf2deOs2+JjWzt3+gH7fSAc2Geo9mmxU7Ea0oqq/LPD6IDAcwMYcUbUV8iIVwuclYHLSiFabfJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l9Oy1NxY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l9Oy1NxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10EDCC4CEE6;
	Wed, 19 Feb 2025 08:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955260;
	bh=R63+F9GsSdCnh/jF1XCI0MMtNmllJwjWgGXmkeXfKBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l9Oy1NxYm3UmHhQNTSfDOei52qOxFVIXodpcW+XvkVexJ+2UmEZ/H34+K6PgKicff
	 1435W9BdJjOlJjYYR03pJLuuB4Z1r9P5OJ0jLg3CsD3ftGnHVaqTktQsEz05uhjaoG
	 yRviNpDqoI7MiV/1bjvJnN8jyLAu/vFHT9wfl0d4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@uliege.be>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 164/230] net: ipv6: ioam6_iptunnel: mitigate 2-realloc issue
Date: Wed, 19 Feb 2025 09:28:01 +0100
Message-ID: <20250219082608.114537407@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Justin Iurman <justin.iurman@uliege.be>

[ Upstream commit dce525185bc92864e5a318040285ee070563fe34 ]

This patch mitigates the two-reallocations issue with ioam6_iptunnel by
providing the dst_entry (in the cache) to the first call to
skb_cow_head(). As a result, the very first iteration may still trigger
two reallocations (i.e., empty cache), while next iterations would only
trigger a single reallocation.

Performance tests before/after applying this patch, which clearly shows
the improvement:
- inline mode:
  - before: https://ibb.co/LhQ8V63
  - after: https://ibb.co/x5YT2bS
- encap mode:
  - before: https://ibb.co/3Cjm5m0
  - after: https://ibb.co/TwpsxTC
- encap mode with tunsrc:
  - before: https://ibb.co/Gpy9QPg
  - after: https://ibb.co/PW1bZFT

This patch also fixes an incorrect behavior: after the insertion, the
second call to skb_cow_head() makes sure that the dev has enough
headroom in the skb for layer 2 and stuff. In that case, the "old"
dst_entry was used, which is now fixed. After discussing with Paolo, it
appears that both patches can be merged into a single one -this one-
(for the sake of readability) and target net-next.

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 92191dd10730 ("net: ipv6: fix dst ref loops in rpl, seg6 and ioam6 lwtunnels")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ioam6_iptunnel.c | 73 ++++++++++++++++++++-------------------
 1 file changed, 37 insertions(+), 36 deletions(-)

diff --git a/net/ipv6/ioam6_iptunnel.c b/net/ipv6/ioam6_iptunnel.c
index beb6b4cfc551c..e81b45b1f6555 100644
--- a/net/ipv6/ioam6_iptunnel.c
+++ b/net/ipv6/ioam6_iptunnel.c
@@ -255,14 +255,15 @@ static int ioam6_do_fill(struct net *net, struct sk_buff *skb)
 }
 
 static int ioam6_do_inline(struct net *net, struct sk_buff *skb,
-			   struct ioam6_lwt_encap *tuninfo)
+			   struct ioam6_lwt_encap *tuninfo,
+			   struct dst_entry *cache_dst)
 {
 	struct ipv6hdr *oldhdr, *hdr;
 	int hdrlen, err;
 
 	hdrlen = (tuninfo->eh.hdrlen + 1) << 3;
 
-	err = skb_cow_head(skb, hdrlen + skb->mac_len);
+	err = skb_cow_head(skb, hdrlen + dst_dev_overhead(cache_dst, skb));
 	if (unlikely(err))
 		return err;
 
@@ -293,7 +294,8 @@ static int ioam6_do_encap(struct net *net, struct sk_buff *skb,
 			  struct ioam6_lwt_encap *tuninfo,
 			  bool has_tunsrc,
 			  struct in6_addr *tunsrc,
-			  struct in6_addr *tundst)
+			  struct in6_addr *tundst,
+			  struct dst_entry *cache_dst)
 {
 	struct dst_entry *dst = skb_dst(skb);
 	struct ipv6hdr *hdr, *inner_hdr;
@@ -302,7 +304,7 @@ static int ioam6_do_encap(struct net *net, struct sk_buff *skb,
 	hdrlen = (tuninfo->eh.hdrlen + 1) << 3;
 	len = sizeof(*hdr) + hdrlen;
 
-	err = skb_cow_head(skb, len + skb->mac_len);
+	err = skb_cow_head(skb, len + dst_dev_overhead(cache_dst, skb));
 	if (unlikely(err))
 		return err;
 
@@ -336,7 +338,7 @@ static int ioam6_do_encap(struct net *net, struct sk_buff *skb,
 
 static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
-	struct dst_entry *dst = skb_dst(skb);
+	struct dst_entry *dst = skb_dst(skb), *cache_dst;
 	struct in6_addr orig_daddr;
 	struct ioam6_lwt *ilwt;
 	int err = -EINVAL;
@@ -354,6 +356,10 @@ static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 
 	orig_daddr = ipv6_hdr(skb)->daddr;
 
+	local_bh_disable();
+	cache_dst = dst_cache_get(&ilwt->cache);
+	local_bh_enable();
+
 	switch (ilwt->mode) {
 	case IOAM6_IPTUNNEL_MODE_INLINE:
 do_inline:
@@ -361,7 +367,7 @@ static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 		if (ipv6_hdr(skb)->nexthdr == NEXTHDR_HOP)
 			goto out;
 
-		err = ioam6_do_inline(net, skb, &ilwt->tuninfo);
+		err = ioam6_do_inline(net, skb, &ilwt->tuninfo, cache_dst);
 		if (unlikely(err))
 			goto drop;
 
@@ -371,7 +377,7 @@ static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 		/* Encapsulation (ip6ip6) */
 		err = ioam6_do_encap(net, skb, &ilwt->tuninfo,
 				     ilwt->has_tunsrc, &ilwt->tunsrc,
-				     &ilwt->tundst);
+				     &ilwt->tundst, cache_dst);
 		if (unlikely(err))
 			goto drop;
 
@@ -389,41 +395,36 @@ static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 		goto drop;
 	}
 
-	err = skb_cow_head(skb, LL_RESERVED_SPACE(dst->dev));
-	if (unlikely(err))
-		goto drop;
+	if (unlikely(!cache_dst)) {
+		struct ipv6hdr *hdr = ipv6_hdr(skb);
+		struct flowi6 fl6;
+
+		memset(&fl6, 0, sizeof(fl6));
+		fl6.daddr = hdr->daddr;
+		fl6.saddr = hdr->saddr;
+		fl6.flowlabel = ip6_flowinfo(hdr);
+		fl6.flowi6_mark = skb->mark;
+		fl6.flowi6_proto = hdr->nexthdr;
+
+		cache_dst = ip6_route_output(net, NULL, &fl6);
+		if (cache_dst->error) {
+			err = cache_dst->error;
+			dst_release(cache_dst);
+			goto drop;
+		}
 
-	if (!ipv6_addr_equal(&orig_daddr, &ipv6_hdr(skb)->daddr)) {
 		local_bh_disable();
-		dst = dst_cache_get(&ilwt->cache);
+		dst_cache_set_ip6(&ilwt->cache, cache_dst, &fl6.saddr);
 		local_bh_enable();
 
-		if (unlikely(!dst)) {
-			struct ipv6hdr *hdr = ipv6_hdr(skb);
-			struct flowi6 fl6;
-
-			memset(&fl6, 0, sizeof(fl6));
-			fl6.daddr = hdr->daddr;
-			fl6.saddr = hdr->saddr;
-			fl6.flowlabel = ip6_flowinfo(hdr);
-			fl6.flowi6_mark = skb->mark;
-			fl6.flowi6_proto = hdr->nexthdr;
-
-			dst = ip6_route_output(net, NULL, &fl6);
-			if (dst->error) {
-				err = dst->error;
-				dst_release(dst);
-				goto drop;
-			}
-
-			local_bh_disable();
-			dst_cache_set_ip6(&ilwt->cache, dst, &fl6.saddr);
-			local_bh_enable();
-		}
+		err = skb_cow_head(skb, LL_RESERVED_SPACE(cache_dst->dev));
+		if (unlikely(err))
+			goto drop;
+	}
 
+	if (!ipv6_addr_equal(&orig_daddr, &ipv6_hdr(skb)->daddr)) {
 		skb_dst_drop(skb);
-		skb_dst_set(skb, dst);
-
+		skb_dst_set(skb, cache_dst);
 		return dst_output(net, sk, skb);
 	}
 out:
-- 
2.39.5



