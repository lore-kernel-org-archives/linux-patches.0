Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B5E2D3EEE;
	Wed, 25 Feb 2026 06:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002729; cv=none; b=lUXJR0O1cBf+0P8d5qYdeCIBAdElnMdZb0gLpxnhciE7LdzS2hSPD+E9XS3N+UhHAeFAixgRi1QCahn3zKamtdiM0BUzywDRpeOo7t03G43bybgErKCFk/KsveK1HCIrsVl/QlOGDschHa3JbnPr2OGvxuWI819RYphuyzj0q1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002729; c=relaxed/simple;
	bh=nZc5c8Hema/7izjx5Lz1TAuRYRC8R8YUQRx7nnZD+Os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tktZXq/f0nC+JAVXu5hOppP8inV8zhWkDrIIcdRjEYJRG4Ho5voGaaof9D+knCBYVUKHqoRPBPAm5hgp/asxihyGsbparbI0+5Xn5h+/5VshU4UnKANyMRsV+gEmWAxF4cCQE1KGehHYffCROm5e06QBHGI4x7hsqto9kfw7eV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBHkpUxf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBHkpUxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828E2C116D0;
	Wed, 25 Feb 2026 06:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002729;
	bh=nZc5c8Hema/7izjx5Lz1TAuRYRC8R8YUQRx7nnZD+Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QBHkpUxfigaGLUW3HjgDxNRPdpbWmlgdxqz9V8H98qO3lVeWrh2B29cgqL5DS7D5u
	 swg4ZcEvtrXS4VMTUn7BGAUjMMB/EDIqLcS39X2IH+MSsnpt7Hj8ReXE3zxO71SXQz
	 p9rppr0t+sKvuvWoerqtnD4OGI4NsQS/SsSYNu+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 542/641] ipvs: do not keep dest_dst if dev is going down
Date: Tue, 24 Feb 2026 17:24:28 -0800
Message-ID: <20260225012401.664381042@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 618fbe1240b54..ecbcdc43263d6 100644
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



