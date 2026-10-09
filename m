Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C254E36CA;
	Fri,  9 Oct 2026 14:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555603; cv=none; b=gfo1J6E0jMEQpXo5+FaUwfM+VU34Bocwu7Xpllij+MNH9SrLjkMtIE9lBuZroTXhE+PXGDHm7TFSa6P4va8FXrdT8NsRseRvZqyWwrquwLDJX0JOgL9A5MIRKMqZagOqEx4Qrd/qEqW5/mpmYfS4XnpAL5iWO9Q2DS5zDOLecn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555603; c=relaxed/simple;
	bh=LIPAMNA4MFYUztNE4ZfkXuYKADAS5/F2NjDiy0Yj84s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzLxEC6wsMgFe3yXcB/iboejLfAPAubnxuLgPA8fxpfIuZEUCu1HyFKRaZ2bFnKWvtbzMAXfiiqspzf06ywQIBv2YuKNqmuwiqnv0S//K/Ve3wBFAEIN0+1VjuqZG7tBnOCSvQPjIYB0VAEj6TXTVayPGPrVGV6E78KPsDxnXHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YoRMfZRP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YoRMfZRP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C2B1F00898;
	Fri,  9 Oct 2026 14:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555594;
	bh=HshEQfc9xJtG6KBapUSzlhs6dlt2h1i2DHNLvK9wTjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YoRMfZRP1KmSnNocL7hDmNC4FkzrWZaoJe5NgUup1JisppE6G/4dVlTkJu+j7hz4C
	 a97ZX8gov3GddyAFSL+9Zsac1YAhshM3wPWTnP8lAm7otZ6sR4e3+DingA9o266uzk
	 +0xqO+Ao5PARHYrHdAtjRwi2K2/aVEzxeR7Jy2vA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>,
	Zihan Xi <zihanx@nebusec.ai>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.2 034/428] net: gso: limit recursive IP-in-IP segmentation
Date: Fri,  9 Oct 2026 16:06:11 +0200
Message-ID: <20261009140946.835251620@linuxfoundation.org>
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

From: Zihan Xi <zihanx@nebusec.ai>

commit 006c8b834aed8b02bd8fb9fb05e9e7ead37d1763 upstream.

IP-in-IP GSO can re-enter inet_gso_segment() or ipv6_gso_segment()
for each nested IP header. encap_level tracks header bytes, not callback
depth, so a deep chain can exhaust the kernel stack. Making
inet_gso_segment() stackable introduced unbounded IPv4 nesting; IPIP
GSO/TSO later made the path reachable. The IPv6 stackable path was
introduced separately and uses the same guard.

Count IPv4 and IPv6 GSO handler entries in skb_gso_cb, initialized once
per top-level GSO operation and preserved across GRE/UDP context changes.
Use the existing IP_TUNNEL_RECURSION_LIMIT for both handlers. The first
five entries pass, and the sixth returns -EINVAL before dispatching
another GSO callback.

Fixes: 3347c9602955 ("ipv4: gso: make inet_gso_segment() stackable")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Closes: https://lore.kernel.org/all/cover.1790157745.git.zihanx@nebusec.ai/
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260924051521.32568-2-zihanx@nebusec.ai
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/gso.h      |    8 ++++++++
 net/core/gso.c         |    1 +
 net/ipv4/af_inet.c     |    3 +++
 net/ipv6/ip6_offload.c |    4 ++++
 4 files changed, 16 insertions(+)

--- a/include/net/gso.h
+++ b/include/net/gso.h
@@ -19,10 +19,18 @@ struct skb_gso_cb {
 	int	encap_level;
 	__wsum	csum;
 	__u16	csum_start;
+	/* Number of IPv4/IPv6 GSO handler entries for this packet. */
+	u8	recursion_counter;
 };
 #define SKB_GSO_CB_OFFSET	32
 #define SKB_GSO_CB(skb) ((struct skb_gso_cb *)((skb)->cb + SKB_GSO_CB_OFFSET))
 
+static inline bool gso_recursion_inc_test(struct sk_buff *skb,
+					  unsigned int limit)
+{
+	return ++SKB_GSO_CB(skb)->recursion_counter > limit;
+}
+
 static inline int skb_tnl_header_len(const struct sk_buff *inner_skb)
 {
 	return (skb_mac_header(inner_skb) - inner_skb->head) -
--- a/net/core/gso.c
+++ b/net/core/gso.c
@@ -117,6 +117,7 @@ struct sk_buff *__skb_gso_segment(struct
 
 	SKB_GSO_CB(skb)->mac_offset = skb_headroom(skb);
 	SKB_GSO_CB(skb)->encap_level = 0;
+	SKB_GSO_CB(skb)->recursion_counter = 0;
 
 	skb_reset_mac_header(skb);
 	skb_reset_mac_len(skb);
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1375,6 +1375,9 @@ struct sk_buff *inet_gso_segment(struct
 	int id;
 
 	skb_reset_network_header(skb);
+	if (unlikely(gso_recursion_inc_test(skb,
+					   IP_TUNNEL_RECURSION_LIMIT)))
+		goto out;
 	nhoff = skb_network_header(skb) - skb_mac_header(skb);
 	if (unlikely(!pskb_may_pull(skb, sizeof(*iph))))
 		goto out;
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -17,6 +17,7 @@
 #include <net/udp.h>
 #include <net/gro.h>
 #include <net/gso.h>
+#include <net/ip_tunnels.h>
 
 #include "ip6_offload.h"
 #include "tcpv6_offload.c"
@@ -104,6 +105,9 @@ static struct sk_buff *ipv6_gso_segment(
 	bool gso_partial;
 
 	skb_reset_network_header(skb);
+	if (unlikely(gso_recursion_inc_test(skb,
+					   IP_TUNNEL_RECURSION_LIMIT)))
+		goto out;
 	nhoff = skb_network_header(skb) - skb_mac_header(skb);
 	if (unlikely(!pskb_may_pull(skb, sizeof(*ipv6h))))
 		goto out;


