Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A5F1DE889;
	Wed, 19 Feb 2025 08:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954405; cv=none; b=feYSZnQ6L8OfPs64tD2KXTXkZcowHSuloVKr9yzt4svL1kjVwooameUwpS6mJm6YluYWMWxXUmBBTAFpGcEVxyNtKKPj4wmJLBbchMKQ8w96NqaG3oyWfAUTljO2/65yVuoVNLS914yD1O9C7pysWlX0Fl9pHbiPEBxQ6zKs3aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954405; c=relaxed/simple;
	bh=KkldybmVKm1Su/P3iQaIPM43J7Kol9ebIc+YsYIbzHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BOKrxi5tBBy0gDA8Qr3OgA7HvKCfH2/WFrv1G03ZAEhWb7LVbrKkYr4r8NCuvfksKTMPm6NnF3B0X6Iues01XtOL0nZ5r/5/+mJ+LQTiq3gqkJBQgAJUAjv+VcCQgZj7iecDcHc7Bs10v83mPMhatL7i4ShCl5GNdrwKBTkUyHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uefxzv+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uefxzv+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2500BC4CED1;
	Wed, 19 Feb 2025 08:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954405;
	bh=KkldybmVKm1Su/P3iQaIPM43J7Kol9ebIc+YsYIbzHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uefxzv+95oNCTFYOP1dplXE56eb9tA/cC5NZOWSWSFfN0UXj+JyBdugoxkER5Dt4U
	 x2nQiPVSLr+mB8/YsR9D3XKZBHPQmrwL3zdjKWejEoTEzF2T7Ohw3T+b00rtwlMrjw
	 WHRVkJJHxF1T56fFcAZwKVpEuJD9af0ua3xJfY7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@uliege.be>,
	David Lebrun <dlebrun@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 194/274] net: ipv6: seg6_iptunnel: mitigate 2-realloc issue
Date: Wed, 19 Feb 2025 09:27:28 +0100
Message-ID: <20250219082617.178784537@linuxfoundation.org>
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

[ Upstream commit 40475b63761abb6f8fdef960d03228a08662c9c4 ]

This patch mitigates the two-reallocations issue with seg6_iptunnel by
providing the dst_entry (in the cache) to the first call to
skb_cow_head(). As a result, the very first iteration would still
trigger two reallocations (i.e., empty cache), while next iterations
would only trigger a single reallocation.

Performance tests before/after applying this patch, which clearly shows
the improvement:
- before: https://ibb.co/3Cg4sNH
- after: https://ibb.co/8rQ350r

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
Cc: David Lebrun <dlebrun@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 92191dd10730 ("net: ipv6: fix dst ref loops in rpl, seg6 and ioam6 lwtunnels")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6_iptunnel.c | 85 ++++++++++++++++++++++++----------------
 1 file changed, 52 insertions(+), 33 deletions(-)

diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index 098632adc9b5a..4bf937bfc2633 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -124,8 +124,8 @@ static __be32 seg6_make_flowlabel(struct net *net, struct sk_buff *skb,
 	return flowlabel;
 }
 
-/* encapsulate an IPv6 packet within an outer IPv6 header with a given SRH */
-int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
+static int __seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh,
+			       int proto, struct dst_entry *cache_dst)
 {
 	struct dst_entry *dst = skb_dst(skb);
 	struct net *net = dev_net(dst->dev);
@@ -137,7 +137,7 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
 	hdrlen = (osrh->hdrlen + 1) << 3;
 	tot_len = hdrlen + sizeof(*hdr);
 
-	err = skb_cow_head(skb, tot_len + skb->mac_len);
+	err = skb_cow_head(skb, tot_len + dst_dev_overhead(cache_dst, skb));
 	if (unlikely(err))
 		return err;
 
@@ -197,11 +197,18 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
 
 	return 0;
 }
+
+/* encapsulate an IPv6 packet within an outer IPv6 header with a given SRH */
+int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
+{
+	return __seg6_do_srh_encap(skb, osrh, proto, NULL);
+}
 EXPORT_SYMBOL_GPL(seg6_do_srh_encap);
 
 /* encapsulate an IPv6 packet within an outer IPv6 header with reduced SRH */
 static int seg6_do_srh_encap_red(struct sk_buff *skb,
-				 struct ipv6_sr_hdr *osrh, int proto)
+				 struct ipv6_sr_hdr *osrh, int proto,
+				 struct dst_entry *cache_dst)
 {
 	__u8 first_seg = osrh->first_segment;
 	struct dst_entry *dst = skb_dst(skb);
@@ -230,7 +237,7 @@ static int seg6_do_srh_encap_red(struct sk_buff *skb,
 
 	tot_len = red_hdrlen + sizeof(struct ipv6hdr);
 
-	err = skb_cow_head(skb, tot_len + skb->mac_len);
+	err = skb_cow_head(skb, tot_len + dst_dev_overhead(cache_dst, skb));
 	if (unlikely(err))
 		return err;
 
@@ -317,8 +324,8 @@ static int seg6_do_srh_encap_red(struct sk_buff *skb,
 	return 0;
 }
 
-/* insert an SRH within an IPv6 packet, just after the IPv6 header */
-int seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr *osrh)
+static int __seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr *osrh,
+				struct dst_entry *cache_dst)
 {
 	struct ipv6hdr *hdr, *oldhdr;
 	struct ipv6_sr_hdr *isrh;
@@ -326,7 +333,7 @@ int seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr *osrh)
 
 	hdrlen = (osrh->hdrlen + 1) << 3;
 
-	err = skb_cow_head(skb, hdrlen + skb->mac_len);
+	err = skb_cow_head(skb, hdrlen + dst_dev_overhead(cache_dst, skb));
 	if (unlikely(err))
 		return err;
 
@@ -369,9 +376,8 @@ int seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr *osrh)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(seg6_do_srh_inline);
 
-static int seg6_do_srh(struct sk_buff *skb)
+static int seg6_do_srh(struct sk_buff *skb, struct dst_entry *cache_dst)
 {
 	struct dst_entry *dst = skb_dst(skb);
 	struct seg6_iptunnel_encap *tinfo;
@@ -384,7 +390,7 @@ static int seg6_do_srh(struct sk_buff *skb)
 		if (skb->protocol != htons(ETH_P_IPV6))
 			return -EINVAL;
 
-		err = seg6_do_srh_inline(skb, tinfo->srh);
+		err = __seg6_do_srh_inline(skb, tinfo->srh, cache_dst);
 		if (err)
 			return err;
 		break;
@@ -402,9 +408,11 @@ static int seg6_do_srh(struct sk_buff *skb)
 			return -EINVAL;
 
 		if (tinfo->mode == SEG6_IPTUN_MODE_ENCAP)
-			err = seg6_do_srh_encap(skb, tinfo->srh, proto);
+			err = __seg6_do_srh_encap(skb, tinfo->srh,
+						  proto, cache_dst);
 		else
-			err = seg6_do_srh_encap_red(skb, tinfo->srh, proto);
+			err = seg6_do_srh_encap_red(skb, tinfo->srh,
+						    proto, cache_dst);
 
 		if (err)
 			return err;
@@ -425,11 +433,13 @@ static int seg6_do_srh(struct sk_buff *skb)
 		skb_push(skb, skb->mac_len);
 
 		if (tinfo->mode == SEG6_IPTUN_MODE_L2ENCAP)
-			err = seg6_do_srh_encap(skb, tinfo->srh,
-						IPPROTO_ETHERNET);
+			err = __seg6_do_srh_encap(skb, tinfo->srh,
+						  IPPROTO_ETHERNET,
+						  cache_dst);
 		else
 			err = seg6_do_srh_encap_red(skb, tinfo->srh,
-						    IPPROTO_ETHERNET);
+						    IPPROTO_ETHERNET,
+						    cache_dst);
 
 		if (err)
 			return err;
@@ -444,6 +454,13 @@ static int seg6_do_srh(struct sk_buff *skb)
 	return 0;
 }
 
+/* insert an SRH within an IPv6 packet, just after the IPv6 header */
+int seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr *osrh)
+{
+	return __seg6_do_srh_inline(skb, osrh, NULL);
+}
+EXPORT_SYMBOL_GPL(seg6_do_srh_inline);
+
 static int seg6_input_finish(struct net *net, struct sock *sk,
 			     struct sk_buff *skb)
 {
@@ -458,31 +475,33 @@ static int seg6_input_core(struct net *net, struct sock *sk,
 	struct seg6_lwt *slwt;
 	int err;
 
-	err = seg6_do_srh(skb);
-	if (unlikely(err))
-		goto drop;
-
 	slwt = seg6_lwt_lwtunnel(orig_dst->lwtstate);
 
 	local_bh_disable();
 	dst = dst_cache_get(&slwt->cache);
+	local_bh_enable();
+
+	err = seg6_do_srh(skb, dst);
+	if (unlikely(err))
+		goto drop;
 
 	if (!dst) {
 		ip6_route_input(skb);
 		dst = skb_dst(skb);
 		if (!dst->error) {
+			local_bh_disable();
 			dst_cache_set_ip6(&slwt->cache, dst,
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
 
 	if (static_branch_unlikely(&nf_hooks_lwtunnel_enabled))
 		return NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_OUT,
@@ -528,16 +547,16 @@ static int seg6_output_core(struct net *net, struct sock *sk,
 	struct seg6_lwt *slwt;
 	int err;
 
-	err = seg6_do_srh(skb);
-	if (unlikely(err))
-		goto drop;
-
 	slwt = seg6_lwt_lwtunnel(orig_dst->lwtstate);
 
 	local_bh_disable();
 	dst = dst_cache_get(&slwt->cache);
 	local_bh_enable();
 
+	err = seg6_do_srh(skb, dst);
+	if (unlikely(err))
+		goto drop;
+
 	if (unlikely(!dst)) {
 		struct ipv6hdr *hdr = ipv6_hdr(skb);
 		struct flowi6 fl6;
@@ -559,15 +578,15 @@ static int seg6_output_core(struct net *net, struct sock *sk,
 		local_bh_disable();
 		dst_cache_set_ip6(&slwt->cache, dst, &fl6.saddr);
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
 	if (static_branch_unlikely(&nf_hooks_lwtunnel_enabled))
 		return NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_OUT, net, sk, skb,
 			       NULL, skb_dst(skb)->dev, dst_output);
-- 
2.39.5



