Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB84347BA7;
	Tue,  6 Jan 2026 17:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721427; cv=none; b=hKg3MLix1XdCkKf2SXOuHYisAkCVNYPCUvNE3LnKvN6rbqlTifKnB3S7dgaeInU0FyCq9KjtsWN6GPQpKy/mMWHkRAzBy3kJeik4vyocr2pobuR0fTSsAGgVefqKSXWRlym2HW5dILtpTGW2PBNah4qpcRepcbrxOLnlzSlrkBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721427; c=relaxed/simple;
	bh=8EG+7gfw2QfRXKPT1NjR0R2sL/ptkbIgE1RNT2LK0xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZuh3z+eC9CU1AyQqGwCBUBMqrdoJ0ApgzPPVqvYYSHyrHnV5v5SJb2Dlmtt5PM7xEChBHE76MdpfAK+SpiOsP9olAXEL7D7EFo3sfUTNNTKf7VAPjnVUKty1BGm3Nbeoy5eNBImVB1fi8oaHJHRLPptdVYXY3CnbsWcl5Xcab8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnFWUNRJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnFWUNRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8BDC19423;
	Tue,  6 Jan 2026 17:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721427;
	bh=8EG+7gfw2QfRXKPT1NjR0R2sL/ptkbIgE1RNT2LK0xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AnFWUNRJy1Lv16MiQad7CucSJUcapJnVPUyOrbICCYD3gKQCwGLUPt8mWezgHMRiM
	 VmNta6ph3JKBYkORujFuthCG7VWRXIqQl6O3TWJ9F7PDSpvwdmgqp6OvfMLOv93M8f
	 sdMmuHi4dXGHJ2kBBH9wTrrHluLiJOolM0ghJtU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@uliege.be>,
	Paolo Abeni <pabeni@redhat.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.12 526/567] net: ipv6: ioam6: use consistent dst names
Date: Tue,  6 Jan 2026 18:05:08 +0100
Message-ID: <20260106170510.849369273@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Iurman <justin.iurman@uliege.be>

[ Upstream commit d55acb9732d981c7a8e07dd63089a77d2938e382 ]

Be consistent and use the same terminology as other lwt users: orig_dst
is the dst_entry before the transformation, while dst is either the
dst_entry in the cache or the dst_entry after the transformation

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
Link: https://patch.msgid.link/20250415112554.23823-2-justin.iurman@uliege.be
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[Harshit: Backport to 6.12.y]
Stable-dep-of: 99a2ace61b21 ("net: use dst_dev_rcu() in sk_setup_caps()")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ioam6_iptunnel.c |   35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

--- a/net/ipv6/ioam6_iptunnel.c
+++ b/net/ipv6/ioam6_iptunnel.c
@@ -338,7 +338,8 @@ static int ioam6_do_encap(struct net *ne
 
 static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
-	struct dst_entry *dst = skb_dst(skb), *cache_dst = NULL;
+	struct dst_entry *orig_dst = skb_dst(skb);
+	struct dst_entry *dst = NULL;
 	struct ioam6_lwt *ilwt;
 	int err = -EINVAL;
 	u32 pkt_cnt;
@@ -346,7 +347,7 @@ static int ioam6_output(struct net *net,
 	if (skb->protocol != htons(ETH_P_IPV6))
 		goto drop;
 
-	ilwt = ioam6_lwt_state(dst->lwtstate);
+	ilwt = ioam6_lwt_state(orig_dst->lwtstate);
 
 	/* Check for insertion frequency (i.e., "k over n" insertions) */
 	pkt_cnt = atomic_fetch_inc(&ilwt->pkt_cnt);
@@ -354,7 +355,7 @@ static int ioam6_output(struct net *net,
 		goto out;
 
 	local_bh_disable();
-	cache_dst = dst_cache_get(&ilwt->cache);
+	dst = dst_cache_get(&ilwt->cache);
 	local_bh_enable();
 
 	switch (ilwt->mode) {
@@ -364,7 +365,7 @@ do_inline:
 		if (ipv6_hdr(skb)->nexthdr == NEXTHDR_HOP)
 			goto out;
 
-		err = ioam6_do_inline(net, skb, &ilwt->tuninfo, cache_dst);
+		err = ioam6_do_inline(net, skb, &ilwt->tuninfo, dst);
 		if (unlikely(err))
 			goto drop;
 
@@ -374,7 +375,7 @@ do_encap:
 		/* Encapsulation (ip6ip6) */
 		err = ioam6_do_encap(net, skb, &ilwt->tuninfo,
 				     ilwt->has_tunsrc, &ilwt->tunsrc,
-				     &ilwt->tundst, cache_dst);
+				     &ilwt->tundst, dst);
 		if (unlikely(err))
 			goto drop;
 
@@ -392,7 +393,7 @@ do_encap:
 		goto drop;
 	}
 
-	if (unlikely(!cache_dst)) {
+	if (unlikely(!dst)) {
 		struct ipv6hdr *hdr = ipv6_hdr(skb);
 		struct flowi6 fl6;
 
@@ -403,20 +404,20 @@ do_encap:
 		fl6.flowi6_mark = skb->mark;
 		fl6.flowi6_proto = hdr->nexthdr;
 
-		cache_dst = ip6_route_output(net, NULL, &fl6);
-		if (cache_dst->error) {
-			err = cache_dst->error;
+		dst = ip6_route_output(net, NULL, &fl6);
+		if (dst->error) {
+			err = dst->error;
 			goto drop;
 		}
 
 		/* cache only if we don't create a dst reference loop */
-		if (dst->lwtstate != cache_dst->lwtstate) {
+		if (orig_dst->lwtstate != dst->lwtstate) {
 			local_bh_disable();
-			dst_cache_set_ip6(&ilwt->cache, cache_dst, &fl6.saddr);
+			dst_cache_set_ip6(&ilwt->cache, dst, &fl6.saddr);
 			local_bh_enable();
 		}
 
-		err = skb_cow_head(skb, LL_RESERVED_SPACE(cache_dst->dev));
+		err = skb_cow_head(skb, LL_RESERVED_SPACE(dst->dev));
 		if (unlikely(err))
 			goto drop;
 	}
@@ -424,16 +425,16 @@ do_encap:
 	/* avoid lwtunnel_output() reentry loop when destination is the same
 	 * after transformation (e.g., with the inline mode)
 	 */
-	if (dst->lwtstate != cache_dst->lwtstate) {
+	if (orig_dst->lwtstate != dst->lwtstate) {
 		skb_dst_drop(skb);
-		skb_dst_set(skb, cache_dst);
+		skb_dst_set(skb, dst);
 		return dst_output(net, sk, skb);
 	}
 out:
-	dst_release(cache_dst);
-	return dst->lwtstate->orig_output(net, sk, skb);
+	dst_release(dst);
+	return orig_dst->lwtstate->orig_output(net, sk, skb);
 drop:
-	dst_release(cache_dst);
+	dst_release(dst);
 	kfree_skb(skb);
 	return err;
 }


