Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F47432ED2A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301942; cv=none; b=SOozCI5PbxKWnNE+dU/+ECyupkz2PEUF4/nbM/USAazyvPechxFbdHaakPq9iXZS2Ov1lunyqRILJNZ0Vvx+j3Z2zuRebxOKC1gmq9CmuHaJjAvFXWxiSdvNEqDQgOSt88rIZtLjk/rOaGUvNY3Z50Iye6Dt9kYIZFNEtz86mKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301942; c=relaxed/simple;
	bh=jscaZRorEQn4QV26UB6lCf2P8roqynxLWjwZvM5QmwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acMAvakk/N9cRNCyzAFslzNJuemeBZRlqnhlvbWBnzbc4MDB5hXgD1jqW/afFGefK038njpjLJyQcfh55Aq0VP3U30bhIIZeErAaAKcUGDPWQvYTaUNihQukXlwSWDCpZZuNNgKnZte4uvKUPO71qrMBm0zLxeibbnTqoA2MPmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fhXxH+U1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fhXxH+U1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72372C116D0;
	Sat, 28 Feb 2026 18:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301941;
	bh=jscaZRorEQn4QV26UB6lCf2P8roqynxLWjwZvM5QmwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fhXxH+U1nPLnB331K6YhnJfuqdONhQgLAR9xlS54uG8t3sgwOXwLqviZ02ujLy26m
	 g8WX6C5fZHoFXuVlGYQ+AHBT3SwRngEzCDl5XxXi3gMtBxr8jQysyAzDlJ1ddUB6u5
	 AzmFIimlET1dqdVyod3JEcrUSIElmcGnKd1sccNI1bng0l2uRnE+CVMZQsDmQfaUjV
	 n5U1+n7KM3nfTZjc3bSVhM9XWdcSfbnTkRcqT06I8tDNq2Ye9UxL05kTNcKEQiQAtF
	 /wramd34Z4Z9pbleeIrDgwxAQkOVUUJ/SsCiY2OE3XGSR7pw21LGF96+FU5kKBnk3J
	 uAA8o8i6mlMUQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Julian Anastasov <ja@ssi.bg>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 379/385] ipvs: do not keep dest_dst if dev is going down
Date: Sat, 28 Feb 2026 13:00:01 -0500
Message-ID: <20260228180011.1568201-379-sashal@kernel.org>
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

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit 8fde939b0206afc1d5846217a01a16b9bc8c7896 ]

There is race between the netdev notifier ip_vs_dst_event()
and the code that caches dst with dev that is going down.
As the FIB can be notified for the closed device after our
handler finishes, it is possible valid route to be returned
and cached resuling in a leaked dev reference until the dest
is not removed.

To prevent new dest_dst to be attached to dest just after the
handler dropped the old one, add a netif_running() check
to make sure the notifier handler is not currently running
for device that is closing.

Fixes: 7a4f0761fce3 ("IPVS: init and cleanup restructuring")
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_xmit.c | 46 ++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index fa2db17f6298b..8892f261451e9 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -295,6 +295,12 @@ static inline bool decrement_ttl(struct netns_ipvs *ipvs,
 	return true;
 }
 
+/* rt has device that is down */
+static bool rt_dev_is_down(const struct net_device *dev)
+{
+	return dev && !netif_running(dev);
+}
+
 /* Get route to destination or remote server */
 static int
 __ip_vs_get_out_rt(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
@@ -310,9 +316,11 @@ __ip_vs_get_out_rt(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
 
 	if (dest) {
 		dest_dst = __ip_vs_dst_check(dest);
-		if (likely(dest_dst))
+		if (likely(dest_dst)) {
 			rt = dst_rtable(dest_dst->dst_cache);
-		else {
+			if (ret_saddr)
+				*ret_saddr = dest_dst->dst_saddr.ip;
+		} else {
 			dest_dst = ip_vs_dest_dst_alloc();
 			spin_lock_bh(&dest->dst_lock);
 			if (!dest_dst) {
@@ -328,14 +336,22 @@ __ip_vs_get_out_rt(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
 				ip_vs_dest_dst_free(dest_dst);
 				goto err_unreach;
 			}
-			__ip_vs_dst_set(dest, dest_dst, &rt->dst, 0);
+			/* It is forbidden to attach dest->dest_dst if
+			 * device is going down.
+			 */
+			if (!rt_dev_is_down(dst_dev_rcu(&rt->dst)))
+				__ip_vs_dst_set(dest, dest_dst, &rt->dst, 0);
+			else
+				noref = 0;
 			spin_unlock_bh(&dest->dst_lock);
 			IP_VS_DBG(10, "new dst %pI4, src %pI4, refcnt=%d\n",
 				  &dest->addr.ip, &dest_dst->dst_saddr.ip,
 				  rcuref_read(&rt->dst.__rcuref));
+			if (ret_saddr)
+				*ret_saddr = dest_dst->dst_saddr.ip;
+			if (!noref)
+				ip_vs_dest_dst_free(dest_dst);
 		}
-		if (ret_saddr)
-			*ret_saddr = dest_dst->dst_saddr.ip;
 	} else {
 		noref = 0;
 
@@ -472,9 +488,11 @@ __ip_vs_get_out_rt_v6(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
 
 	if (dest) {
 		dest_dst = __ip_vs_dst_check(dest);
-		if (likely(dest_dst))
+		if (likely(dest_dst)) {
 			rt = dst_rt6_info(dest_dst->dst_cache);
-		else {
+			if (ret_saddr)
+				*ret_saddr = dest_dst->dst_saddr.in6;
+		} else {
 			u32 cookie;
 
 			dest_dst = ip_vs_dest_dst_alloc();
@@ -495,14 +513,22 @@ __ip_vs_get_out_rt_v6(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
 			}
 			rt = dst_rt6_info(dst);
 			cookie = rt6_get_cookie(rt);
-			__ip_vs_dst_set(dest, dest_dst, &rt->dst, cookie);
+			/* It is forbidden to attach dest->dest_dst if
+			 * device is going down.
+			 */
+			if (!rt_dev_is_down(dst_dev_rcu(&rt->dst)))
+				__ip_vs_dst_set(dest, dest_dst, &rt->dst, cookie);
+			else
+				noref = 0;
 			spin_unlock_bh(&dest->dst_lock);
 			IP_VS_DBG(10, "new dst %pI6, src %pI6, refcnt=%d\n",
 				  &dest->addr.in6, &dest_dst->dst_saddr.in6,
 				  rcuref_read(&rt->dst.__rcuref));
+			if (ret_saddr)
+				*ret_saddr = dest_dst->dst_saddr.in6;
+			if (!noref)
+				ip_vs_dest_dst_free(dest_dst);
 		}
-		if (ret_saddr)
-			*ret_saddr = dest_dst->dst_saddr.in6;
 	} else {
 		noref = 0;
 		dst = __ip_vs_route_output_v6(net, daddr, ret_saddr, do_xfrm,
-- 
2.51.0

