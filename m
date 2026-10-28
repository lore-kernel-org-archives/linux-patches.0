Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209794;
	b=Rh6zmxzGItqzegcZ19aD3gAYMu+By2ocVuRcfybq0FcOmSI1U7HhwMQu9XgLvGuZjG5L
	 D5pXcW3FmpXxnckwF/XW6x8Pu9Wgvu7U3YE0VH750z+XCVU8CTQo8/5yRArkaUaydTbl7
	 hJsuC0sDtEgjgCogrVJqN1i0aaoSDB7XJrGybpzSmlzm7LZbq7bDb1nN0Sk/T+IhWf3SO
	 kbUovHePxoG3qI4Ix/l/TnUrf6FoJLzOK5uAvtBBaLTXNU5Uco28xfSc3eVdFTnCxy+YY
	 4xorQwoVHJuC1vbjAZolKNZkU8MJV6Gepjln8JZrdXNxHeNVX2ORyLAwdb0J1wASXeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KIH/rsYprcwNPb/Kfl3G8c0NMjM7yK+KjZ/qqtzciHc=;
	b=EOZX+EeI5l9PfV2HfdkTQqC42nWl+pVN1gSG9DYpzqLVMo2hPIn+NVIY/bGOu3L+9nBv
	 4w4z6BLe05nPQqRmGykIlj3OJusJAXnv5qCMD/ruDjMSceyk4fiPdCIk5CLJaDAdPamJm
	 OuAHYQr71RQHlMaZywMEYTPIt4ONhmqcafwKcELHkmhkH5VgO8lzO/d2374v1oGfzdVIW
	 ENXvyAp+ippQ4KaAlu77eAgfN3t9Q0XY6p5oyX9pf8UsId++qRky4KKNNremdB/7IJpP2
	 B2p+k72YollUiIwMytW9ygsEGpQ2edO8IJg3tMmCzGzcJSbjrEIVx8vBFPt+KTaT/yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rSY/GkvO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B1B606A31A;
	Wed, 28 Oct 2026 17:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rSY/GkvO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8601F01825;
	Wed, 28 Oct 2026 17:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209793;
	bh=KIH/rsYprcwNPb/Kfl3G8c0NMjM7yK+KjZ/qqtzciHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rSY/GkvOnzTwHziMBE44FEfR9RBcteOlFilulA1urcd6aR0aagm7jOq6rIFWO0FuM
	 FiXsmeQXXv2u6qIthvx//1HOhIHHxU63J41osYK7G5ILhOor+YUDfsLyf+hZVP6WoK
	 Ax4c+y0qm9gCp/zKFKDLuYBj6N3vlXOMkghTyb90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>,
	Zihan Xi <zihanx@nebusec.ai>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Ting-Han Hou <ue081723@gmail.com>
Subject: [PATCH 6.18 042/109] net: gso: limit recursive IP-in-IP segmentation
Date: Wed, 28 Oct 2026 18:00:26 +0100
Message-ID: <20261028165943.352531631@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ Ting-Han: ipv6_gso_segment() still calls ipv6_hopopt_jumbo_remove()
  right after skb_reset_network_header() in this version; keep the new
  recursion check directly after skb_reset_network_header() as upstream
  does, before the jumbo removal ]
Signed-off-by: Ting-Han Hou <ue081723@gmail.com>
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
@@ -1364,6 +1364,9 @@ struct sk_buff *inet_gso_segment(struct
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
 
@@ -120,6 +121,9 @@ static struct sk_buff *ipv6_gso_segment(
 	bool gso_partial;
 
 	skb_reset_network_header(skb);
+	if (unlikely(gso_recursion_inc_test(skb,
+					   IP_TUNNEL_RECURSION_LIMIT)))
+		goto out;
 	err = ipv6_hopopt_jumbo_remove(skb);
 	if (err)
 		return ERR_PTR(err);


