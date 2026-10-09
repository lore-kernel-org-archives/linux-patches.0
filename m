Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F61331ED5;
	Fri,  9 Oct 2026 14:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555605; cv=none; b=kjrOJoDWYk6cWe5x4m97cVgrV3w2xnv4ntahJYpkgbxMyydhdxs8DCj13dig/cCGG+x7C2lOg4XaF3Wh5BT8kn/J8oZBj0uKV+/jVwDuPjICw9/1Qd3OfTDMoRislWCJ5rCVKc9GnhBc8y9wfP3mTqhyTLv3EJs7hBAZXrBvodk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555605; c=relaxed/simple;
	bh=z0JXH+7i5nQX92KcxKzJuXoUmOrWXN3/FNkqYcUPA/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uitqOEr4xXTEFkz0K2jodJEB9/m3e5IbhOVUWi+aQFZ3tsisKeMfG2eqW5Ew+3zyovGnik721tLXzoQm4Gc4Q0MAqenHxmGC/1P0b0etboVz+Cmcxyqhgz25V8yYWoDVbBB0Af1+Kz1jsusbwJO7X5D9fGs053WrC9oLjBQpeoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f6qinW2U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f6qinW2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A931F00893;
	Fri,  9 Oct 2026 14:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555600;
	bh=lPxuZOPSqu1BiXKexNPXEsrCGQa5U5KUo7eIg/jQ9yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f6qinW2UMrtkAdLyW9GBK+e86a2XHjPPr1PUNfi/P1w1azL6ynddbA9PIoOd3NKsr
	 teC8XS7UhnU3mjg6xxXhiwP2IkhAyd5huto/5qf8PqdoXfDp6jKL868rv1j4s5vwGj
	 R69fATeWpgZryhUTwQz6DNGcSXNWBdH8VA5mKT20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 035/428] net: extend IPv6 exthdr detection of tunneled packets
Date: Fri,  9 Oct 2026 16:06:12 +0200
Message-ID: <20261009140946.859088101@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willem de Bruijn <willemb@google.com>

commit 5f0764cb1c81a9712bce605d38efe6d844a70b29 upstream.

Commit c4336a07eb6b ("net: correctly handle tunneled traffic on IPV6_CSUM
GSO fallback") split skb_gso_has_extension_hdr() into mutually exclusive
branches on skb->encapsulation. This did not yet address all paths:

1. With skb->encapsulation set, the outer header is not checked. IPv6
   tunnels such as ip6_gre and ip6_tunnel add an outer Destination
   Options header by default (encap_limit). Their GSO packets skip
   software GSO, then skb_csum_hwoffload_help() sees the outer extension
   header and calls skb_checksum_help() on the GSO skb, which warns and
   drops it.

2. Tunnels over IPv6 without an outer transport header, such as
   ip6_tunnel, leave skb->transport_header at the inner transport
   header. skb_network_header_len() then spans the outer IPv6, tunnel
   and inner IP headers, a false positive.

3. UDP tunnels without an inner network header, such as SCTP-in-UDP or
   PSP, have no inner IPv6 header to check. Decide on the outer header
   alone.

4. Directly dereferencing inner_ip_hdr(skb)->version without
   skb_header_pointer() is unsafe.

Instead, check ipv6_ext_hdr(nexthdr) on the outer IPv6 header and, if
set, on the inner IPv6 header. Read the headers with skb_header_pointer().
Keep the skb_network_header_len() check when !skb->encapsulation to also
catch encapsulated packets without skb->encapsulation (e.g., virtio).

Use the same helper in skb_csum_hwoffload_help(). Its open coded test
has the false positive of (2) and ignores the inner header.

Background: checksum offload of tunneled packets invariants:

Non-GSO skb:
- If the inner packet is CHECKSUM_PARTIAL, Local Checksum Offload computes
  the outer checksum in software and the device offloads only the inner L4
  checksum.
- If the inner packet is CHECKSUM_NONE (e.g., SCTP-in-UDP, ESP-in-UDP,
  Remote Checksum Offload), the device offloads the outer UDP or GRE
  checksum instead.

GSO skb:
- A device with NETIF_F_GSO_UDP_TUNNEL_CSUM or NETIF_F_GSO_GRE_CSUM
  computes both inner and outer checksums per segment.
  The outer checksum is seeded with only the pseudo-header checksum.

A NETIF_F_IPV6_CSUM device must parse through the outer headers to
reach the inner ones.

Fixes: c4336a07eb6b ("net: correctly handle tunneled traffic on IPV6_CSUM GSO fallback")
Cc: stable@vger.kernel.org
Signed-off-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260926140506.2335137-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |   47 +++++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 16 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3812,20 +3812,36 @@ static netdev_features_t dflt_features_c
 	return vlan_features_check(skb, features);
 }
 
-static bool skb_gso_has_extension_hdr(const struct sk_buff *skb)
+static bool __skb_has_ipv6_ext_hdr(const struct sk_buff *skb, int nhoff)
 {
-	if (!skb->encapsulation)
-		return ((skb_shinfo(skb)->gso_type & SKB_GSO_TCPV6 ||
-			 (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4 &&
-			  vlan_get_protocol(skb) == htons(ETH_P_IPV6))) &&
-			skb_transport_header_was_set(skb) &&
-			skb_network_header_len(skb) != sizeof(struct ipv6hdr));
-	else
-		return (!skb_inner_network_header_was_set(skb) ||
-			((skb_shinfo(skb)->gso_type & SKB_GSO_TCPV6 ||
-			  (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4 &&
-			   inner_ip_hdr(skb)->version == 6)) &&
-			 skb_inner_network_header_len(skb) != sizeof(struct ipv6hdr)));
+	const struct ipv6hdr *ip6h;
+	struct ipv6hdr _ip6h;
+
+	ip6h = skb_header_pointer(skb, nhoff, sizeof(_ip6h), &_ip6h);
+	return ip6h && ip6h->version == 6 && ipv6_ext_hdr(ip6h->nexthdr);
+}
+
+static bool skb_has_ipv6_extension_hdr(const struct sk_buff *skb)
+{
+	if (vlan_get_protocol(skb) == htons(ETH_P_IPV6)) {
+		if (__skb_has_ipv6_ext_hdr(skb, skb_network_offset(skb)))
+			return true;
+
+		/* Catch tunnels without skb->encapsulation (e.g., virtio). */
+		if (!skb->encapsulation &&
+		    skb_transport_header_was_set(skb) &&
+		    skb_network_header_len(skb) != sizeof(struct ipv6hdr))
+			return true;
+	}
+
+	/* Tunnels without an inner network header, such as SCTP-in-UDP or
+	 * PSP, have no inner IP header and thus no inner extension header.
+	 */
+	if (skb->encapsulation && skb_inner_network_header_was_set(skb) &&
+	    __skb_has_ipv6_ext_hdr(skb, skb_inner_network_offset(skb)))
+		return true;
+
+	return false;
 }
 
 static netdev_features_t gso_features_check(const struct sk_buff *skb,
@@ -3880,7 +3896,7 @@ static netdev_features_t gso_features_ch
 	 * so neither does TSO that depends on it.
 	 */
 	if (features & NETIF_F_IPV6_CSUM &&
-	    skb_gso_has_extension_hdr(skb))
+	    skb_has_ipv6_extension_hdr(skb))
 		features &= ~(NETIF_F_IPV6_CSUM | NETIF_F_TSO6 | NETIF_F_GSO_UDP_L4);
 
 	return features;
@@ -3982,8 +3998,7 @@ int skb_csum_hwoffload_help(struct sk_bu
 		return 0;
 
 	if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
-		if (vlan_get_protocol(skb) == htons(ETH_P_IPV6) &&
-		    skb_network_header_len(skb) != sizeof(struct ipv6hdr))
+		if (skb_has_ipv6_extension_hdr(skb))
 			goto sw_checksum;
 
 		switch (skb->csum_offset) {


