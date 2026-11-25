Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625694;
	b=v9RrC/kbbp+3WJuKCczJAGaNLh++Mz/JBCYVPH4yGxprCMIOyO+i7Ng0FPyYCb+kMqc6
	 r70mvw+dEz4dr2ATFhrGY2SJ9gwGk6kOjT+9CR8EhzICT7sZTGKgOQ3ApEMNuFe4xJX1r
	 nLutdLbhfsL58rt7CvkAt2RpvAxUTD6P95dRyBJCIG2DMj+Y6PbA4ZFAMp3V5MGnXH9vH
	 sadNgoBiQRAxzGMcxv1+OTu8rLI4ZHC/qAXs0j4cCnXQQd2lfXf+pQjdFOO7KDRbTqzcd
	 T+RzDvxveyIIMdQeY+rOzn5Da0+ReJ3Mgte21MDLlHOJPM9jFqoQKsit2FOTcMv3+Gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pjFIqownmICy+YJVXbKjfsS/vSXzxY7BCJC2alTJLhs=;
	b=xUTuGD6bB//OI37+Q5bcBlKGmt2hpZBmSm4ORFFn0qqtaet8bJw3ENSe92dzHsi4SQFY
	 ZLdVh/cM5sq445Xwfg3GkZLo4r4ncIj4Qx/fwKj4Rg0sIxZsfVSssxRbjUTQ/nKMfz6/q
	 jpg/N9WPxK8IOWyXp+fUrxesimoD4lrbWfYChBKg0ZCbpi7LAiPXDPDIRrM3cRqdvSG0N
	 zenkR7olKs9EZQKUT+RMy4TdmdurxeOmrxRYJuk/HiG9n2YdzENbbLliMucrEZ+XB8ukw
	 0zAeB1XlCr0DxvtgXkKpdVqYYnFKYEVJZTXvVUsQ/4MlqPb6T6NEw/kqLEDLNSXxk4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b7D1LSJ6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5A7606A31E;
	Wed, 25 Nov 2026 16:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b7D1LSJ6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C531F000C4;
	Wed, 25 Nov 2026 16:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625694;
	bh=pjFIqownmICy+YJVXbKjfsS/vSXzxY7BCJC2alTJLhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b7D1LSJ6tUW2uawgl6XR1hDG++87Bit47KlF9ArfsafUfk7bkymcb3uv8kMuS195S
	 EgNff6FO8HE+GOcPbg8WbwH1Iy8DnEo5Clzz5FE4DhLT6eeX65njVAE2V+x8yck2VX
	 5C5HIZ4fkqXrT+buzhrnagjOzcBDAUK9KxyEHK7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 599/816] net: gro: do not undo remote checksum offload on merged packets
Date: Wed, 25 Nov 2026 15:35:47 +0100
Message-ID: <20261125143903.043684039@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -354,7 +354,13 @@ static inline void skb_gro_remcsum_clean
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
@@ -242,6 +242,13 @@ int skb_gro_receive_list(struct sk_buff
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


