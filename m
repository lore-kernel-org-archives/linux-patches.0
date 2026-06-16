Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D38B2F12AE;
	Tue, 16 Jun 2026 18:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633316; cv=none; b=eVIJtPjPmXjNAJdXzLlY528fogZVz8Ix5NV11IYbHwI6nkNv/vIZxudkQK/6hHDR1oEf6aeho2U/jKPrmmHrWzdIiZKJSoeWeAjQO2LUkLXD5FOrJja1k3+5jkQCMsLnE9GifBeU9ezKYYCLNK+AiqJAl0BI8/6XGN80UwL91QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633316; c=relaxed/simple;
	bh=1rWvHvqxZc4yahQCUDwDuSwCdlggrD98L91ysTjnKrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oH51qdYnGeXbYqRS6R/vqnGG7IidFqfR97blZhGNbYT7gyYHuGaU+s6YVSq/OjZAjRDj/LP9PiR7zai6SdJfpfscqJ8Q/wKypJoOZHKTsIugV4y5NBK8CcqUtTciG5GACdF86rRw9wqON4Vgjugg9cbFgYSRNs+W9gXJ/388JSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sq29qgd+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sq29qgd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C8B61F000E9;
	Tue, 16 Jun 2026 18:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633315;
	bh=2KzzQJKxY3Uebqb3/CltoOozttAz1xa3avtR8foGEeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sq29qgd+83dL07yEOrt9dvgnKug58mEuql/+UpmND+nyi1yer9KWM0J4JkSLH248p
	 hkIKK0khoioBT84DpJzs5Onn3EkbM+gCyOdR10z4dSjB6jQ1ZgPTPUnwpvme8oAMgd
	 wvWVJmt3wzOtZ2m5aq+wMeR46OLf71j1liTs9CoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Stefano Brivio <sbrivio@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/411] tunnels: load network headers after skb_cow() in iptunnel_pmtud_build_icmp[v6]()
Date: Tue, 16 Jun 2026 20:24:20 +0530
Message-ID: <20260616145101.559940217@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3737188ba4e1e5..4d80bbcd15d5a4 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -194,7 +194,7 @@ EXPORT_SYMBOL_GPL(iptunnel_handle_offloads);
  */
 static int iptunnel_pmtud_build_icmp(struct sk_buff *skb, int mtu)
 {
-	const struct iphdr *iph = ip_hdr(skb);
+	const struct iphdr *iph;
 	struct icmphdr *icmph;
 	struct iphdr *niph;
 	struct ethhdr eh;
@@ -208,7 +208,6 @@ static int iptunnel_pmtud_build_icmp(struct sk_buff *skb, int mtu)
 
 	skb_copy_bits(skb, skb_mac_offset(skb), &eh, ETH_HLEN);
 	pskb_pull(skb, ETH_HLEN);
-	skb_reset_network_header(skb);
 
 	err = pskb_trim(skb, 576 - sizeof(*niph) - sizeof(*icmph));
 	if (err)
@@ -218,7 +217,7 @@ static int iptunnel_pmtud_build_icmp(struct sk_buff *skb, int mtu)
 	err = skb_cow(skb, sizeof(*niph) + sizeof(*icmph) + ETH_HLEN);
 	if (err)
 		return err;
-
+	iph = ip_hdr(skb);
 	icmph = skb_push(skb, sizeof(*icmph));
 	*icmph = (struct icmphdr) {
 		.type			= ICMP_DEST_UNREACH,
@@ -290,7 +289,7 @@ static int iptunnel_pmtud_check_icmp(struct sk_buff *skb, int mtu)
  */
 static int iptunnel_pmtud_build_icmpv6(struct sk_buff *skb, int mtu)
 {
-	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
+	const struct ipv6hdr *ip6h;
 	struct icmp6hdr *icmp6h;
 	struct ipv6hdr *nip6h;
 	struct ethhdr eh;
@@ -305,7 +304,6 @@ static int iptunnel_pmtud_build_icmpv6(struct sk_buff *skb, int mtu)
 
 	skb_copy_bits(skb, skb_mac_offset(skb), &eh, ETH_HLEN);
 	pskb_pull(skb, ETH_HLEN);
-	skb_reset_network_header(skb);
 
 	err = pskb_trim(skb, IPV6_MIN_MTU - sizeof(*nip6h) - sizeof(*icmp6h));
 	if (err)
@@ -316,6 +314,7 @@ static int iptunnel_pmtud_build_icmpv6(struct sk_buff *skb, int mtu)
 	if (err)
 		return err;
 
+	ip6h = ipv6_hdr(skb);
 	icmp6h = skb_push(skb, sizeof(*icmp6h));
 	*icmp6h = (struct icmp6hdr) {
 		.icmp6_type		= ICMPV6_PKT_TOOBIG,
-- 
2.53.0



