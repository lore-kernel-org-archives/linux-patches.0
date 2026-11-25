Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619622;
	b=ZFrz9AADE8/Ou+2lfpqMaQeCUjhlgYQK2WWkox4OEDS2v05VkHrS4CjIzbc9x220YHXX
	 olsGHEjZeOiTO/YgHAdXNT2E1SYCzG7tOAMue7AIJqumb3/xhI2Oq1C1gO7o4tHyJe29C
	 /VzuphSiYdbZlBcMKhFlRPc4ARczt1fXGwbs7xo8spoqOtMBuv7jzmIPZM6uYttA277Tu
	 1AgndjYEwNN6QuiAOc6fLfdawb/9TUZqWP4OftBxCzVLaDru7kUnJigNKGOw7ULfNj8lP
	 zIv5iNJXLOZknLNk3odkBSz+NTNAmsxgPS/mbCi58xajCkSUUOoxbL4t9TRScFCtHXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619622;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IbkeyI3Yl3946l/y1Ueh0vHP+9Pi68+N+nJh5tK70mc=;
	b=YoZQVJqhOjmqs/35dm7wahKKdLIzhXZ52gBuD4WDWfSMSDxmF/kVyv4QIal49ysiXbOn
	 6c+HiSAmz42qUqB9q6UvmaFVMnPk1H5NUpa0ELvL0yUu2LPXe4gPeK9OgWgUa4qIKFiF6
	 czUnxXc+hUiyducGJNhtyL5lb5Ft5Kh+nYkg7qebS+EHc6JM5L/4G1yvABKvVaaiBGZZZ
	 0QXUWFOw/LQzLac29SAumj3AV5VQekTYCXLyIZzQAhBiWKOVwZxc0owb7t5TyCBmPFWPK
	 IDoR75G5PtsM8WhmaB0gyw9cGEPLZSyIOIufQEdJAxtGyQKWaXj3QL9jTBIrvT5qswA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k4ruGvJD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517C3606A323;
	Wed, 25 Nov 2026 15:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k4ruGvJD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E6F1F000C4;
	Wed, 25 Nov 2026 15:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619622;
	bh=IbkeyI3Yl3946l/y1Ueh0vHP+9Pi68+N+nJh5tK70mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k4ruGvJDcVdLLAcetL1zzAjrmHb3wAkTDZLini5h/3FfajexieaHMWJf1H5V4ycPa
	 Bjnf8AZoGeziavGOUrZsaz2oVnBghOaw2HsKLpcYvNy4cAftq9w9VBNEghCMT4sUgD
	 NB3V3oyXHqPZ/N9VZ6vGgxNEGXRaDtCyLnrhs4Ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 0657/1005] net: gro: do not undo remote checksum offload on merged packets
Date: Wed, 25 Nov 2026 15:33:15 +0100
Message-ID: <20261125143837.138360575@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -238,6 +238,13 @@ int skb_gro_receive_list(struct sk_buff
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


