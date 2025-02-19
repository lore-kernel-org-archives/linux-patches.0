Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0B71C175A;
	Wed, 19 Feb 2025 08:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954408; cv=none; b=TYY9RrcMG/sEMMWc89RNfqw1TomN0UhE4CiPPHTPouTUlLol3pLv3WEjID8GGNQcR5gMggFZ/BTWVuglR6cI2h5YpjxfWprvhHu/1ODcCEzVRuu49kInqxxiHa/nvI4d1yS1ZZYVSU/D3dTgeVrzS84HrZRFd1z5iAjTlR8NOEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954408; c=relaxed/simple;
	bh=tn+UrPDw0iuxO5JsCSN8w2Dpplk9db+t6QO5nUUr+6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HI7fXsfRrZDV96nJxYfiPat4Tr5fF39Gej6rm88yWOfFNIL5TND8Hv/XodULen6FWo7K1GhEapyZ+HbfYlTvvEkY5ek67HHzXBvR+dIgO9YlW15A4/sFhH6V8kMRY8pEZykBHCcwclvGMbQpDXNYy/fLGengxxeqZttf2xovB0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDUUFotU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDUUFotU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3E4C4CED1;
	Wed, 19 Feb 2025 08:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954408;
	bh=tn+UrPDw0iuxO5JsCSN8w2Dpplk9db+t6QO5nUUr+6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDUUFotUPHLE43Ki7foeWz1IT19Tfdn49viOXZdwiwpHEGDfjUExT1GEkCZCY2iGb
	 A09GXGcGaWUaJ7yK8BMQJcvCd4B7GaOZqRY2JY+J8zbwAMlZ4RTKplG68GTmUfdMhz
	 3B8q705Z0I8jgCCny1LSZQuEmO8anbk+xS97spYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@uliege.be>,
	Alexander Aring <aahringo@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 195/274] net: ipv6: rpl_iptunnel: mitigate 2-realloc issue
Date: Wed, 19 Feb 2025 09:27:29 +0100
Message-ID: <20250219082617.216726760@linuxfoundation.org>
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

[ Upstream commit 985ec6f5e6235242191370628acb73d7a9f0c0ea ]

This patch mitigates the two-reallocations issue with rpl_iptunnel by
providing the dst_entry (in the cache) to the first call to
skb_cow_head(). As a result, the very first iteration would still
trigger two reallocations (i.e., empty cache), while next iterations
would only trigger a single reallocation.

Performance tests before/after applying this patch, which clearly shows
there is no impact (it even shows improvement):
- before: https://ibb.co/nQJhqwc
- after: https://ibb.co/4ZvW6wV

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
Cc: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 92191dd10730 ("net: ipv6: fix dst ref loops in rpl, seg6 and ioam6 lwtunnels")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/rpl_iptunnel.c | 46 ++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/net/ipv6/rpl_iptunnel.c b/net/ipv6/rpl_iptunnel.c
index db3c19a42e1ca..7ba22d2f2bfef 100644
--- a/net/ipv6/rpl_iptunnel.c
+++ b/net/ipv6/rpl_iptunnel.c
@@ -125,7 +125,8 @@ static void rpl_destroy_state(struct lwtunnel_state *lwt)
 }
 
 static int rpl_do_srh_inline(struct sk_buff *skb, const struct rpl_lwt *rlwt,
-			     const struct ipv6_rpl_sr_hdr *srh)
+			     const struct ipv6_rpl_sr_hdr *srh,
+			     struct dst_entry *cache_dst)
 {
 	struct ipv6_rpl_sr_hdr *isrh, *csrh;
 	const struct ipv6hdr *oldhdr;
@@ -153,7 +154,7 @@ static int rpl_do_srh_inline(struct sk_buff *skb, const struct rpl_lwt *rlwt,
 
 	hdrlen = ((csrh->hdrlen + 1) << 3);
 
-	err = skb_cow_head(skb, hdrlen + skb->mac_len);
+	err = skb_cow_head(skb, hdrlen + dst_dev_overhead(cache_dst, skb));
 	if (unlikely(err)) {
 		kfree(buf);
 		return err;
@@ -186,7 +187,8 @@ static int rpl_do_srh_inline(struct sk_buff *skb, const struct rpl_lwt *rlwt,
 	return 0;
 }
 
-static int rpl_do_srh(struct sk_buff *skb, const struct rpl_lwt *rlwt)
+static int rpl_do_srh(struct sk_buff *skb, const struct rpl_lwt *rlwt,
+		      struct dst_entry *cache_dst)
 {
 	struct dst_entry *dst = skb_dst(skb);
 	struct rpl_iptunnel_encap *tinfo;
@@ -196,7 +198,7 @@ static int rpl_do_srh(struct sk_buff *skb, const struct rpl_lwt *rlwt)
 
 	tinfo = rpl_encap_lwtunnel(dst->lwtstate);
 
-	return rpl_do_srh_inline(skb, rlwt, tinfo->srh);
+	return rpl_do_srh_inline(skb, rlwt, tinfo->srh, cache_dst);
 }
 
 static int rpl_output(struct net *net, struct sock *sk, struct sk_buff *skb)
@@ -208,14 +210,14 @@ static int rpl_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 
 	rlwt = rpl_lwt_lwtunnel(orig_dst->lwtstate);
 
-	err = rpl_do_srh(skb, rlwt);
-	if (unlikely(err))
-		goto drop;
-
 	local_bh_disable();
 	dst = dst_cache_get(&rlwt->cache);
 	local_bh_enable();
 
+	err = rpl_do_srh(skb, rlwt, dst);
+	if (unlikely(err))
+		goto drop;
+
 	if (unlikely(!dst)) {
 		struct ipv6hdr *hdr = ipv6_hdr(skb);
 		struct flowi6 fl6;
@@ -237,15 +239,15 @@ static int rpl_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 		local_bh_disable();
 		dst_cache_set_ip6(&rlwt->cache, dst, &fl6.saddr);
 		local_bh_enable();
+
+		err = skb_cow_head(skb, LL_RESERVED_SPACE(dst->dev));
+		if (unlikely(err))
+			goto drop;
 	}
 
 	skb_dst_drop(skb);
 	skb_dst_set(skb, dst);
 
-	err = skb_cow_head(skb, LL_RESERVED_SPACE(dst->dev));
-	if (unlikely(err))
-		goto drop;
-
 	return dst_output(net, sk, skb);
 
 drop:
@@ -262,29 +264,31 @@ static int rpl_input(struct sk_buff *skb)
 
 	rlwt = rpl_lwt_lwtunnel(orig_dst->lwtstate);
 
-	err = rpl_do_srh(skb, rlwt);
-	if (unlikely(err))
-		goto drop;
-
 	local_bh_disable();
 	dst = dst_cache_get(&rlwt->cache);
+	local_bh_enable();
+
+	err = rpl_do_srh(skb, rlwt, dst);
+	if (unlikely(err))
+		goto drop;
 
 	if (!dst) {
 		ip6_route_input(skb);
 		dst = skb_dst(skb);
 		if (!dst->error) {
+			local_bh_disable();
 			dst_cache_set_ip6(&rlwt->cache, dst,
 					  &ipv6_hdr(skb)->saddr);
+			local_bh_enable();
 		}
+
+		err = skb_cow_head(skb, LL_RESERVED_SPACE(dst->dev));
+		if (unlikely(err))
+			goto drop;
 	} else {
 		skb_dst_drop(skb);
 		skb_dst_set(skb, dst);
 	}
-	local_bh_enable();
-
-	err = skb_cow_head(skb, LL_RESERVED_SPACE(dst->dev));
-	if (unlikely(err))
-		goto drop;
 
 	return dst_input(skb);
 
-- 
2.39.5



