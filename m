Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215731;
	b=ab8UAf4S4k8YVi5SVT7Ej0wvI/1HwJcOmaZvM3zhy9DzGhoDfnlqaAGfBOZLLXIYEHdC
	 Vv9cHAmymXNN/xdSONDJGV19KESJgYWf27esta4p5EWyLk6TfmvYuDi737l+JGHfVMbr8
	 vnAPmFZB+w3ULYTheof8K7jCQl2ex7WZCTYKD1ONgjj2V6ffr/rO7Kf2OfzSGOuLvaQog
	 CT3v0BnJHEBf3ao3EsE4wvPExFbGaJSp45K9xwJaeAEmR9uw6vvQJCMU3/WyNpT1lZBkj
	 VlYFjuoR7ho7o4oVNYdnWWUSagFRzZHesufGpFScbT/KJOoWcEk1rZfW5mWCaOMDzew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215731;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zNVdrhoFGxBWNAaGFHPAF8BSTRPahvy0LtOLB0Hc9kg=;
	b=mUau+sX6IJ12Cv2Uwl9V9dlhuD+N7hyb7vTWEdw508PBFCHANmnM1WOaLK7YOs5LjEUF
	 ACAsnHMlFdaelHj7ye62nSq4ajvVHmF35DxYYEZXji5M8Qjev4WpqPASvOUWczS2X8hS6
	 GFI4jJLvXXhbNuHteE8Fr3m7i9a8Jmp6WAb+J+Yv0lCQzs3JsFtDN0yNhBnOA7Luap8UX
	 9hPrkHUinTVekK9g6TPCHLoEG3ccBPBNi9uaC059f7GqSCS0K0qMGGmyBCLr9V9vKcLTP
	 tZBGvBaJf+WvvYtoIbBmWHtt3yPjj2EfyYrk5D58MVJZWL/Og8dZeaZkIo2iwGzYV8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GliJ8RRN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D44606A31A;
	Wed, 28 Oct 2026 19:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GliJ8RRN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66451F01825;
	Wed, 28 Oct 2026 19:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215731;
	bh=zNVdrhoFGxBWNAaGFHPAF8BSTRPahvy0LtOLB0Hc9kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GliJ8RRNvworuDAqrok5NgkjMWaQKMpSBK9Xy982pGMDcF+jBDZyLDlF53OvNXgE0
	 xBnGrd8/7LnwzLqTPjfbzyT9+Dhnibq/MLjQcFFJAWpmWL2ohH6o2TR/JWP2f4HrCV
	 2h0DcjxrsVYFEOkWI6q/IHIG3L1uYyWAMCP5jK/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1311/1887] ipvs: revalidate ihl to prevent out-of-bounds access
Date: Wed, 28 Oct 2026 17:56:47 +0100
Message-ID: <20261028170529.264726226@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9aeb44f03f17c..9ac0ffb54bebd 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1583,7 +1583,7 @@ static inline char ip_vs_fwd_tag(struct ip_vs_conn *cp)
 	return fwd;
 }
 
-void ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
+bool ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
 		    struct ip_vs_conn *cp, int dir, unsigned int toff,
 		    bool has_ports, struct ip_vs_iphdr *ciph);
 
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 41f09e29d221b..dec212507ba99 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -745,7 +745,7 @@ static int ip_vs_route_me_harder(struct netns_ipvs *ipvs, int af,
  * Packet has been made sufficiently writable in caller
  * - inout: 1=in->out, 0=out->in
  */
-void ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
+bool ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
 		    struct ip_vs_conn *cp, int inout, unsigned int toff,
 		    bool has_ports, struct ip_vs_iphdr *ciph)
 {
@@ -753,6 +753,11 @@ void ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
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
@@ -786,6 +791,7 @@ void ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
 	else
 		IP_VS_DBG_PKT(11, AF_INET, pp, skb, ciph->off,
 			      "Forwarding altered incoming ICMP");
+	return true;
 }
 
 #ifdef CONFIG_IP_VS_IPV6
@@ -877,7 +883,8 @@ static int handle_response_icmp(int af, struct sk_buff *skb,
 		ip_vs_nat_icmp_v6(skb, pp, cp, 1, toff, has_ports, ciph);
 	else
 #endif
-		ip_vs_nat_icmp(skb, pp, cp, 1, toff, has_ports, ciph);
+		if (!ip_vs_nat_icmp(skb, pp, cp, 1, toff, has_ports, ciph))
+			goto out;
 
 	if (ip_vs_route_me_harder(cp->ipvs, af, skb, hooknum))
 		goto out;
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index b424ebd7235fe..cbef6ca5088a6 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -1615,7 +1615,8 @@ ip_vs_icmp_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	if (skb_cow(skb, rt->dst.dev->hard_header_len))
 		goto tx_error;
 
-	ip_vs_nat_icmp(skb, pp, cp, 0, toff, has_ports, ciph);
+	if (!ip_vs_nat_icmp(skb, pp, cp, 0, toff, has_ports, ciph))
+		goto tx_error;
 
 	/* Another hack: avoid icmp_send in ip_fragment */
 	skb->ignore_df = 1;
-- 
2.53.0



