Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAEF4071DA;
	Sun,  7 Jun 2026 10:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827500; cv=none; b=IP8ZGAVjqhi2Rj9aNWOqOAmsSe3+zCRYdSxOm+mRxRSI0Kr3po3hzE7S8xmKA+W+GP4yL8hsdwR/7uusqBhXYXlRoiUBkEhFMDLSM2LrG53NF+5C3TjhmvcAtDnUTtVnj3CNq2DGDppbl4pX674BKb8NeOPaOhZGMszEukGX0lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827500; c=relaxed/simple;
	bh=xPHmhH7Zskssth0zc14V5yiO0G8m6E45XatDw9gjgjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGgKL/+a2Gi0LPVjgn7vNGg2wyGYr2KAH9mVZiOkBCuuMyPE77MxIuduzmhDtCKwy5jf6jdIfta0eC9/+Y5PNIUStPi6tCS7tZIxlt4SowUbQI0vMmpZNGl+7O8Y1co94cewlwk7t741W/kpsZ9UGDhwAmr3gorCq1qKu3ZZp+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hKbORNFQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hKbORNFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E2B1F00893;
	Sun,  7 Jun 2026 10:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827499;
	bh=XKs7wBHOqz9WyjosjyKBpft+SNfdWak/LkZnpxxldww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hKbORNFQX/ypVdIAMvYcUyTMmR29Tkwedz2tV06ikkeNgUeLi5Tu49jVDRZNErCm4
	 DhuogzTNl8vZqEOGpFWsle9Z58XGklDptSSPs4PlPugbgwuVF+ZQyte1Sy/uA6AIn7
	 vNf71vW/t93LcevHToswqY8zZ6q2u4NJdrkYf7n8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Stefano Brivio <sbrivio@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 060/307] tunnels: load network headers after skb_cow() in iptunnel_pmtud_build_icmp[v6]()
Date: Sun,  7 Jun 2026 11:57:37 +0200
Message-ID: <20260607095729.946026838@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b4bc94353050b1fa7b702bd4c6600710dd926cff ]

Sashiko found that iptunnel_pmtud_build_icmp() and
iptunnel_pmtud_build_icmpv6() were caching ip_hdr() and ipv6_hdr()
before an skb_cow() call which can reallocate skb->head.

Fix this possible UAF by initializing the local variables
after the skb_cow() call.

Remove skb_reset_network_header() calls which were not needed.

Fixes: 4cb47a8644cc ("tunnels: PMTU discovery support for directly bridged IP packets")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Link: https://patch.msgid.link/20260525201335.2361845-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_tunnel_core.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 507f2f9ec400ce..cf496644d3df6c 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -210,7 +210,7 @@ EXPORT_SYMBOL_GPL(iptunnel_handle_offloads);
  */
 static int iptunnel_pmtud_build_icmp(struct sk_buff *skb, int mtu)
 {
-	const struct iphdr *iph = ip_hdr(skb);
+	const struct iphdr *iph;
 	struct icmphdr *icmph;
 	struct iphdr *niph;
 	struct ethhdr eh;
@@ -224,7 +224,6 @@ static int iptunnel_pmtud_build_icmp(struct sk_buff *skb, int mtu)
 
 	skb_copy_bits(skb, skb_mac_offset(skb), &eh, ETH_HLEN);
 	pskb_pull(skb, ETH_HLEN);
-	skb_reset_network_header(skb);
 
 	err = pskb_trim(skb, 576 - sizeof(*niph) - sizeof(*icmph));
 	if (err)
@@ -234,7 +233,7 @@ static int iptunnel_pmtud_build_icmp(struct sk_buff *skb, int mtu)
 	err = skb_cow(skb, sizeof(*niph) + sizeof(*icmph) + ETH_HLEN);
 	if (err)
 		return err;
-
+	iph = ip_hdr(skb);
 	icmph = skb_push(skb, sizeof(*icmph));
 	*icmph = (struct icmphdr) {
 		.type			= ICMP_DEST_UNREACH,
@@ -306,7 +305,7 @@ static int iptunnel_pmtud_check_icmp(struct sk_buff *skb, int mtu)
  */
 static int iptunnel_pmtud_build_icmpv6(struct sk_buff *skb, int mtu)
 {
-	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
+	const struct ipv6hdr *ip6h;
 	struct icmp6hdr *icmp6h;
 	struct ipv6hdr *nip6h;
 	struct ethhdr eh;
@@ -321,7 +320,6 @@ static int iptunnel_pmtud_build_icmpv6(struct sk_buff *skb, int mtu)
 
 	skb_copy_bits(skb, skb_mac_offset(skb), &eh, ETH_HLEN);
 	pskb_pull(skb, ETH_HLEN);
-	skb_reset_network_header(skb);
 
 	err = pskb_trim(skb, IPV6_MIN_MTU - sizeof(*nip6h) - sizeof(*icmp6h));
 	if (err)
@@ -332,6 +330,7 @@ static int iptunnel_pmtud_build_icmpv6(struct sk_buff *skb, int mtu)
 	if (err)
 		return err;
 
+	ip6h = ipv6_hdr(skb);
 	icmp6h = skb_push(skb, sizeof(*icmp6h));
 	*icmp6h = (struct icmp6hdr) {
 		.icmp6_type		= ICMPV6_PKT_TOOBIG,
-- 
2.53.0



