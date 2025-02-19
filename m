Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948DB1CAA8A;
	Wed, 19 Feb 2025 08:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954402; cv=none; b=f5D3gTK8WIYK4Pc57sUw/IC8auGRTzKup46CUYJ2ngt1kWiHc2HipzguEd8+mhJvf5JKGgtqpKskc6/o1jqlhEi+KPnfD88QpwuTps+lozE2EzRg0GSD9/NS8kWaMssE+Fvf0oybSUo9parKvOnuYjyTjKg9Bcjv5JYtv9wxY48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954402; c=relaxed/simple;
	bh=xZiCoRnXHEcePg+q1SQKk5UdpAa9L2HGFu5DPowvJp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PewwLrhol9lU2uV168Ko5co9YeUN+DoUKuGQ0zvr0Pr1Xh9+3YetWF2XpJiy6IrNcmu+Cp2u3wpS1ReVo/goysGb6J83sRTwjQH4gyfgZFLKfkfbn847b9dK3fp2GkzQ6U69brX9mpiEAknxs4svV0eo5iYYIJCwEEQRC19f0Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=spCq6YLp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="spCq6YLp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6CAC4CED1;
	Wed, 19 Feb 2025 08:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954402;
	bh=xZiCoRnXHEcePg+q1SQKk5UdpAa9L2HGFu5DPowvJp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=spCq6YLp2tKQq1jEuT0B7OAwJuJ8iThoPgXQlp/n8VTP0g8JPQY+Ygw4zQuvly/Jc
	 GLtlAKtKi4yC5uyFc309CuyaL6JfehvZPn/vkIvDsMo6qz8VYWZnF6BRLbLQOrpWNv
	 2GrVQxyuxHbkebyL0X6vaqCs7GDpD/OeAl3cHbHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@uliege.be>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 193/274] net: ipv6: ioam6_iptunnel: mitigate 2-realloc issue
Date: Wed, 19 Feb 2025 09:27:27 +0100
Message-ID: <20250219082617.136103645@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 9d8422e350f8d..28e5a89dc2557 100644
--- a/net/ipv6/ioam6_iptunnel.c
+++ b/net/ipv6/ioam6_iptunnel.c
@@ -253,14 +253,15 @@ static int ioam6_do_fill(struct net *net, struct sk_buff *skb)
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
 
@@ -291,7 +292,8 @@ static int ioam6_do_encap(struct net *net, struct sk_buff *skb,
 			  struct ioam6_lwt_encap *tuninfo,
 			  bool has_tunsrc,
 			  struct in6_addr *tunsrc,
-			  struct in6_addr *tundst)
+			  struct in6_addr *tundst,
+			  struct dst_entry *cache_dst)
 {
 	struct dst_entry *dst = skb_dst(skb);
 	struct ipv6hdr *hdr, *inner_hdr;
@@ -300,7 +302,7 @@ static int ioam6_do_encap(struct net *net, struct sk_buff *skb,
 	hdrlen = (tuninfo->eh.hdrlen + 1) << 3;
 	len = sizeof(*hdr) + hdrlen;
 
-	err = skb_cow_head(skb, len + skb->mac_len);
+	err = skb_cow_head(skb, len + dst_dev_overhead(cache_dst, skb));
 	if (unlikely(err))
 		return err;
 
@@ -334,7 +336,7 @@ static int ioam6_do_encap(struct net *net, struct sk_buff *skb,
 
 static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
-	struct dst_entry *dst = skb_dst(skb);
+	struct dst_entry *dst = skb_dst(skb), *cache_dst;
 	struct in6_addr orig_daddr;
 	struct ioam6_lwt *ilwt;
 	int err = -EINVAL;
@@ -352,6 +354,10 @@ static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 
 	orig_daddr = ipv6_hdr(skb)->daddr;
 
+	local_bh_disable();
+	cache_dst = dst_cache_get(&ilwt->cache);
+	local_bh_enable();
+
 	switch (ilwt->mode) {
 	case IOAM6_IPTUNNEL_MODE_INLINE:
 do_inline:
@@ -359,7 +365,7 @@ static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 		if (ipv6_hdr(skb)->nexthdr == NEXTHDR_HOP)
 			goto out;
 
-		err = ioam6_do_inline(net, skb, &ilwt->tuninfo);
+		err = ioam6_do_inline(net, skb, &ilwt->tuninfo, cache_dst);
 		if (unlikely(err))
 			goto drop;
 
@@ -369,7 +375,7 @@ static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 		/* Encapsulation (ip6ip6) */
 		err = ioam6_do_encap(net, skb, &ilwt->tuninfo,
 				     ilwt->has_tunsrc, &ilwt->tunsrc,
-				     &ilwt->tundst);
+				     &ilwt->tundst, cache_dst);
 		if (unlikely(err))
 			goto drop;
 
@@ -387,41 +393,36 @@ static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
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



