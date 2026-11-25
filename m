Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623018;
	b=wnPpx3fd9onbuCDYWEDZykx0sv7Ua2N1ZxBS1ASLZchdG5B5nmYRNPArpGhsKCOU1u5G
	 LW86ZWEOf/RUBIk7gThNww2jFerx6ZTgJluECq05YZIwXhxu0Qvr+wU361RGDUHwyKTB8
	 uYjV7VKj9wE6s+G9o/+2honAVrIBp2quoCzSBkEdw2ceOGxfCA0zqFbttT9btPplYY6A2
	 tFZnDW/xgxwGXN3KQ/eQDuQbg+E5mlTczDTUQA7gEocLu876dfiybiO6ZiEBx6gzegXIH
	 o9n5brWkCjY/eg3UZ5M7HMXIeTyVSMdbIbVSus0X1yjvH8sXEyioDbj97OT3B/qeUCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4SYUXuhmuLv6LTFRK8DiyU2Cpj67vaj/xXQMPiqVX6E=;
	b=JW4yOw4RkLIgn3nCSR3fzzGzXY1V/CSQDGe9eUCmE3IVksNmLmkNPr/WfUscTMrArLis
	 Qlu3SxJdMuRTi34M+kjMZZvaCy6XjfSi8alHC53OZD+a101ZszAwaBmVO+3awdEkK4PQd
	 A4qrTS0+kvqDveGd86FZQAUgzxwc91ZYlElSoR7yAzzcx+Kuupjdrs8SSrPg6vrk6bdRt
	 kxDp7dDX5Nktxw+Y3LTuWUjqOE2r1hVNa6vWP7nH5YUnErbZQhBHCHvnhs1cKNFEDRh9G
	 U2ZlHnCqXlST+1cOJyFXZ/2VXerpOQZThPHWkuCt4Mw5oy5VWAFBiRI85S1MLop8ylg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zuXnIY86;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA71606A31E;
	Wed, 25 Nov 2026 16:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zuXnIY86
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EAB41F000C6;
	Wed, 25 Nov 2026 16:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623018;
	bh=4SYUXuhmuLv6LTFRK8DiyU2Cpj67vaj/xXQMPiqVX6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zuXnIY86EpKNVEAM3nVI0olYXJoCfXF+igJyQ6WfgDJH3dNL15bgUz9FoX0aRJkK4
	 tSQc08Pz52D1GwVD+ag7xkAVNpsoUOfHXGLh3CFYE0QIFAdC6K/tLAyqR+N2DM1b+y
	 GTJceZZV4PyVDvsPUyEVJPBIlTvOQr4A7HTAuw8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 722/990] net: gro: do not undo remote checksum offload on merged packets
Date: Wed, 25 Nov 2026 15:34:49 +0100
Message-ID: <20261125143838.989574468@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

commit c817ec1b06875b98460fbd19591be541bc3fa924 upstream.

skb_gro_flush_final_remcsum() calls skb_gro_remcsum_cleanup() to undo
the checksum adjustment done by skb_gro_remcsum_process() when the
packet was not consumed by GRO.

When the inner handler merged the packet (NAPI_GRO_CB(skb)->same_flow
is set), grc->offset can no longer be trusted:

- skb_gro_receive() either gives the frags or the head of the skb
  to the held packet, or uses __skb_pull(skb, offset) before adding
  the skb to the frag_list of the held packet.

- skb_gro_receive_list() uses skb_pull(skb, skb_gro_offset(skb)).

grc->offset is relative to the original skb->data, so the 2-byte
read-modify-write done by skb_gro_remcsum_cleanup() can land in
the payload of a packet which now belongs to the GRO packet.
pskb_may_pull() can also be called on this frag_list member.

With fraglist GRO, this can also be a use-after-free:
pskb_may_pull(skb, skb_gro_offset(skb)) in skb_gro_receive_list()
or udp_gro_receive_segment() releases the first page fragment if it
only contains headers. NAPI_GRO_CB(skb)->frag0 and frag0_len are not
updated, so skb_gro_remcsum_cleanup() takes the fast path and writes
through frag0 into a page the skb no longer holds a reference on.
The non merged case, where frag0 is used after this pull, is handled
in the following patch.

For skbs merged by skb_gro_receive(), the cleanup can be skipped:
the skb is freed, or its headers are rebuilt from the head skb in
skb_segment().

Fraglist members keep their own inner headers, as skb_segment_list()
only copies the link-layer and tunnel headers from the head skb.
Their checksum can not be right in all cases: a packet forwarded with
its tunnel header needs the original value, while a VXLAN packet
decapsulated locally needs the adjusted one, as vxlan_remcsum() only
adjusts the head skb. Make skb_gro_receive_list() refuse packets with
skb->remcsum_offload set, so that fraglist members never carry an
adjusted checksum.

This affects VXLAN (VXLAN_F_REMCSUM_NOPARTIAL) and GUE
(FOU_F_REMCSUM_NOPARTIAL).

This was found while fixing a report from Taesoo Kim and Cen Zhang,
who used LLM assisted code analysis and provided reproducers.

Fixes: 26c4f7da3e41 ("net: Fix remcsum in GRO path to not change packet")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261104151042.1157782-2-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/gro.h |    8 +++++++-
 net/core/gro.c    |    7 +++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/include/net/gro.h
+++ b/include/net/gro.h
@@ -351,7 +351,13 @@ static inline void skb_gro_remcsum_clean
 	void *ptr;
 	size_t plen = grc->offset + sizeof(u16);
 
-	if (!grc->delta)
+	/* Once merged, grc->offset can not be trusted: the frags or head
+	 * of this skb now belong to the GRO packet, or skb->data was pulled
+	 * past the headers before adding it to a frag_list.
+	 * skb_gro_receive_list() does not merge packets with an adjusted
+	 * checksum, other merged packets do not use their headers anymore.
+	 */
+	if (!grc->delta || NAPI_GRO_CB(skb)->same_flow)
 		return;
 
 	ptr = skb_gro_header(skb, plen, grc->offset);
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -243,6 +243,13 @@ int skb_gro_receive_list(struct sk_buff
 		     NAPI_GRO_CB(skb)->flush))
 		return -E2BIG;
 
+	/* Fraglist members keep their own headers. Their checksum can not
+	 * be right both for a forwarded packet and for a decapsulated one,
+	 * if remote checksum offload adjusted it.
+	 */
+	if (unlikely(skb->remcsum_offload))
+		return -EINVAL;
+
 	if (!pskb_may_pull(skb, skb_gro_offset(skb))) {
 		NAPI_GRO_CB(skb)->flush = 1;
 		return -ENOMEM;


