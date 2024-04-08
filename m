Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9F47EEF3;
	Mon,  8 Apr 2024 13:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583065; cv=none; b=Zx1dP00M0979X/wkltfr2tB55EV9pYjt7Q8E/qnpcdFj2oh2a1aTj42WA8Bf+dztDMCHl3O7gdoLQg9eevUzAUzpN9pnOLosYncnDW+PXUxDKmI+Sm5nGiFQMQX4/uhTr7G+O19CTgAkUM5vW++oeKtAP52u2c7OoFqmcvj9Nms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583065; c=relaxed/simple;
	bh=YBZwo+mherOnI0noFezc9JhSoSbXTMQVSoAnn1UW05M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qudf0LUq6odIWOemFKFvA3BOb3EOZ8DfBL8wVc5jE6BVD2zaZCY2KDzuHvXWXZv63rJQTIQ+bPrJYX6WhdsG+zC27Pr0bLXITJsiqGRWcFIC/VYMOd8wPzIRK48dUEc5v8E9xCpwzkER8yD0NIwJhEnClhSpdb1u63qCGdrmboA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yA7DV20P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yA7DV20P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6B6C433C7;
	Mon,  8 Apr 2024 13:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583065;
	bh=YBZwo+mherOnI0noFezc9JhSoSbXTMQVSoAnn1UW05M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yA7DV20P4ZdJtkWPCBnH/V0EjejnLYz58geOB/s/omC6vtETjKPu47qkuoy5THBF7
	 IxuM4su8wNLIzZEkJ3oZNEeUB3g168qrJdAygxV4WdAJ4I21vBuoVOUGcqqiLzbNII
	 1AlXYQnCdW/Tscmq30YOrlTbfQhZaz7JKzRZ6cak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Tenart <atenart@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.8 121/273] udp: do not accept non-tunnel GSO skbs landing in a tunnel
Date: Mon,  8 Apr 2024 14:56:36 +0200
Message-ID: <20240408125313.054843329@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoine Tenart <atenart@kernel.org>

commit 3d010c8031e39f5fa1e8b13ada77e0321091011f upstream.

When rx-udp-gro-forwarding is enabled UDP packets might be GROed when
being forwarded. If such packets might land in a tunnel this can cause
various issues and udp_gro_receive makes sure this isn't the case by
looking for a matching socket. This is performed in
udp4/6_gro_lookup_skb but only in the current netns. This is an issue
with tunneled packets when the endpoint is in another netns. In such
cases the packets will be GROed at the UDP level, which leads to various
issues later on. The same thing can happen with rx-gro-list.

We saw this with geneve packets being GROed at the UDP level. In such
case gso_size is set; later the packet goes through the geneve rx path,
the geneve header is pulled, the offset are adjusted and frag_list skbs
are not adjusted with regard to geneve. When those skbs hit
skb_fragment, it will misbehave. Different outcomes are possible
depending on what the GROed skbs look like; from corrupted packets to
kernel crashes.

One example is a BUG_ON[1] triggered in skb_segment while processing the
frag_list. Because gso_size is wrong (geneve header was pulled)
skb_segment thinks there is "geneve header size" of data in frag_list,
although it's in fact the next packet. The BUG_ON itself has nothing to
do with the issue. This is only one of the potential issues.

Looking up for a matching socket in udp_gro_receive is fragile: the
lookup could be extended to all netns (not speaking about performances)
but nothing prevents those packets from being modified in between and we
could still not find a matching socket. It's OK to keep the current
logic there as it should cover most cases but we also need to make sure
we handle tunnel packets being GROed too early.

This is done by extending the checks in udp_unexpected_gso: GSO packets
lacking the SKB_GSO_UDP_TUNNEL/_CSUM bits and landing in a tunnel must
be segmented.

[1] kernel BUG at net/core/skbuff.c:4408!
    RIP: 0010:skb_segment+0xd2a/0xf70
    __udp_gso_segment+0xaa/0x560

Fixes: 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
Fixes: 36707061d6ba ("udp: allow forwarding of plain (non-fraglisted) UDP GRO packets")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/udp.h    |   28 ++++++++++++++++++++++++++++
 net/ipv4/udp.c         |    7 +++++++
 net/ipv4/udp_offload.c |    6 ++++--
 net/ipv6/udp.c         |    2 +-
 4 files changed, 40 insertions(+), 3 deletions(-)

--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -140,6 +140,24 @@ static inline void udp_cmsg_recv(struct
 	}
 }
 
+DECLARE_STATIC_KEY_FALSE(udp_encap_needed_key);
+#if IS_ENABLED(CONFIG_IPV6)
+DECLARE_STATIC_KEY_FALSE(udpv6_encap_needed_key);
+#endif
+
+static inline bool udp_encap_needed(void)
+{
+	if (static_branch_unlikely(&udp_encap_needed_key))
+		return true;
+
+#if IS_ENABLED(CONFIG_IPV6)
+	if (static_branch_unlikely(&udpv6_encap_needed_key))
+		return true;
+#endif
+
+	return false;
+}
+
 static inline bool udp_unexpected_gso(struct sock *sk, struct sk_buff *skb)
 {
 	if (!skb_is_gso(skb))
@@ -153,6 +171,16 @@ static inline bool udp_unexpected_gso(st
 	    !udp_test_bit(ACCEPT_FRAGLIST, sk))
 		return true;
 
+	/* GSO packets lacking the SKB_GSO_UDP_TUNNEL/_CSUM bits might still
+	 * land in a tunnel as the socket check in udp_gro_receive cannot be
+	 * foolproof.
+	 */
+	if (udp_encap_needed() &&
+	    READ_ONCE(udp_sk(sk)->encap_rcv) &&
+	    !(skb_shinfo(skb)->gso_type &
+	      (SKB_GSO_UDP_TUNNEL | SKB_GSO_UDP_TUNNEL_CSUM)))
+		return true;
+
 	return false;
 }
 
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -584,6 +584,13 @@ static inline bool __udp_is_mcast_sock(s
 }
 
 DEFINE_STATIC_KEY_FALSE(udp_encap_needed_key);
+EXPORT_SYMBOL(udp_encap_needed_key);
+
+#if IS_ENABLED(CONFIG_IPV6)
+DEFINE_STATIC_KEY_FALSE(udpv6_encap_needed_key);
+EXPORT_SYMBOL(udpv6_encap_needed_key);
+#endif
+
 void udp_encap_enable(void)
 {
 	static_branch_inc(&udp_encap_needed_key);
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -552,8 +552,10 @@ struct sk_buff *udp_gro_receive(struct l
 	unsigned int off = skb_gro_offset(skb);
 	int flush = 1;
 
-	/* we can do L4 aggregation only if the packet can't land in a tunnel
-	 * otherwise we could corrupt the inner stream
+	/* We can do L4 aggregation only if the packet can't land in a tunnel
+	 * otherwise we could corrupt the inner stream. Detecting such packets
+	 * cannot be foolproof and the aggregation might still happen in some
+	 * cases. Such packets should be caught in udp_unexpected_gso later.
 	 */
 	NAPI_GRO_CB(skb)->is_flist = 0;
 	if (!sk || !udp_sk(sk)->gro_receive) {
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -450,7 +450,7 @@ csum_copy_err:
 	goto try_again;
 }
 
-DEFINE_STATIC_KEY_FALSE(udpv6_encap_needed_key);
+DECLARE_STATIC_KEY_FALSE(udpv6_encap_needed_key);
 void udpv6_encap_enable(void)
 {
 	static_branch_inc(&udpv6_encap_needed_key);


