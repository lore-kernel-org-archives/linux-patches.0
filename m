Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5447360745;
	Thu, 20 Aug 2026 15:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238666; cv=none; b=qeehPGUrCaBn+oaAJPpRKfn4tAEE2L1OEPTZUtiMtLS50gOU8NdbWD/u30bfv6OVijMHHgPNylvTvSY6F3Ks/UVgLnh011aa0yOHJkAMMVafFcsiXZGOUqsACJ/zN/RS14L6NDeANunRmZF1DupU5g437UuO1IBRmEe0jCedT4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238666; c=relaxed/simple;
	bh=h+MoXEUWqS7mGzug5wIWIZFvQNgdopWBOcmfJe5nTk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=geo5zSXIGSUUQPeyX+BklyX9G0QSudzMi0+lmLM6N63YuTeVF8d7jqxsrq1rG+Ou9bIeW/Jq85BlnWY4RIkO2ryw2mjQ1B1umEEKp+8OoyEutxjRmlsTlHuwo7RGhjSdj0k5Ju4V1jr+8AkhGVbXY073DKI+vWS6I21nU0n4SRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GhLYHuwg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GhLYHuwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0FF1F000E9;
	Thu, 20 Aug 2026 15:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238665;
	bh=91MJ3bgIn4KBvHKrlCYeNX33vqbK0QcLUag74nBIjMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GhLYHuwgZHUbHy4Nj2xJp2TpZPZgt/aZXDAnLUgG+hfrSvm954HO9cTKmNRtcFkOC
	 vD6d0UxaTm6xUOLdIvhMyYHysmp2jcejtA5w1eHvJpafi75cWU74pR4+8Cr4E1Hbgw
	 fX98O7wlYIl2uHDngpgtr75r9rKklJf5TdqSXSew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 188/228] ipvs: revalidate ihl to prevent out-of-bounds access
Date: Thu, 20 Aug 2026 16:55:30 +0200
Message-ID: <20260820145250.421226856@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit d93660df4dd1d116f608ada4a29a80a5d6f0a6ed ]

While the outer IP header is already pulled into the skb head,
we must be careful and revalidate the embedded headers after
reading them from the skb frags to prevent out-of-bounds
access.

One such place reported by Sashiko is ip_vs_nat_icmp() where
local process can change the ihl field and after
skb_ensure_writable() we can see larger value which is a
problem for the ip_send_check(cih) calls.

Add check to drop the packet if the ihl field is changed.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://sashiko.dev/#/patchset/20260730183506.87473-1-ja%40ssi.bg
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip_vs.h             |  2 +-
 net/netfilter/ipvs/ip_vs_core.c | 11 +++++++++--
 net/netfilter/ipvs/ip_vs_xmit.c |  3 ++-
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 7f7fa4484492f..b3ac38e6cdd7a 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -2046,7 +2046,7 @@ static inline bool ip_vs_conn_use_hash2(struct ip_vs_conn *cp)
 	       !(cp->flags & IP_VS_CONN_F_TEMPLATE);
 }
 
-void ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
+bool ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
 		    struct ip_vs_conn *cp, int dir, unsigned int toff,
 		    bool has_ports, struct ip_vs_iphdr *ciph);
 
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index a46e7acdd8e12..eb806813292ad 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -923,7 +923,7 @@ static int ip_vs_route_me_harder(struct netns_ipvs *ipvs, int af,
  * Packet has been made sufficiently writable in caller
  * - inout: 1=in->out, 0=out->in
  */
-void ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
+bool ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
 		    struct ip_vs_conn *cp, int inout, unsigned int toff,
 		    bool has_ports, struct ip_vs_iphdr *ciph)
 {
@@ -931,6 +931,11 @@ void ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
 	struct icmphdr *icmph	 = (struct icmphdr *)(skb->data + toff);
 	struct iphdr *cih	 = (struct iphdr *)(icmph + 1);
 
+	/* Before now we may used ihl from skb frag, revalidate it after
+	 * copying it into skb head to prevent out-of-bounds access
+	 */
+	if (cih->ihl * 4 != ciph->len - ciph->off)
+		return false;
 	if (inout) {
 		iph->saddr = cp->vaddr.ip;
 		ip_send_check(iph);
@@ -964,6 +969,7 @@ void ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
 	else
 		IP_VS_DBG_PKT(11, AF_INET, pp, skb, ciph->off,
 			      "Forwarding altered incoming ICMP");
+	return true;
 }
 
 #ifdef CONFIG_IP_VS_IPV6
@@ -1055,7 +1061,8 @@ static int handle_response_icmp(int af, struct sk_buff *skb,
 		ip_vs_nat_icmp_v6(skb, pp, cp, 1, toff, has_ports, ciph);
 	else
 #endif
-		ip_vs_nat_icmp(skb, pp, cp, 1, toff, has_ports, ciph);
+		if (!ip_vs_nat_icmp(skb, pp, cp, 1, toff, has_ports, ciph))
+			goto out;
 
 	if (ip_vs_route_me_harder(cp->ipvs, af, skb, hooknum))
 		goto out;
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index fc74031863940..04450a48f01a5 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -1580,7 +1580,8 @@ ip_vs_icmp_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	if (skb_cow(skb, rt->dst.dev->hard_header_len))
 		goto tx_error;
 
-	ip_vs_nat_icmp(skb, pp, cp, 0, toff, has_ports, ciph);
+	if (!ip_vs_nat_icmp(skb, pp, cp, 0, toff, has_ports, ciph))
+		goto tx_error;
 
 	/* Another hack: avoid icmp_send in ip_fragment */
 	skb->ignore_df = 1;
-- 
2.53.0



