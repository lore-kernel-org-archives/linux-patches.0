Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704977;
	b=Iiv0f47igrpRgoHaTa3SFhafU/e0ZrNUkH6mELDykj6DcbKRVgquLscoKKlT/4YBh04N
	 NB0Mt6cKb+F+EhcICxdDSJFzzE4fXJk7MfdMTSV7GLENalS3v6bx6/VFOA2lCmuxYzcnF
	 CYijcRkKUwIGNCEfkkVwrRDVyLZ0ZV0qJAQIQBe6CkUUT4bBSMEfSgWq3SoN/TpjhusGW
	 NTuOIzeaetNaMb8NNL4HVKE8ma2wVls0K75cW8Mtt3JTH94DQveKSdFk3T3AjO36jA7wO
	 9fCGojAsQEnA7LlU+I809AJc+X8fPbNlgEiq7icUZGVGNXB3CJyLZNSScq3Cfpyfhug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KQ72hMhqMbRWC6jp2Mm0EIIN5IFL+zPjyM+XTLoBtZM=;
	b=nfyGHyQ/dYcgnAQqkMB7VFJMWRUhYiEtmjGbcplpAG3y4dohr356/XggD7+jUhiJ/qYH
	 zks7+ad60xqHcFMdzseAxjaZop7TBmCtvfjeRm94Dc3uXVS6p/ZPNtfEGXJoEPgWVTraJ
	 SxRhcZOH5MVrbnkTslr4KD4xrzA35IQ2GF8XiJtcUDmG+rRjRfAtW2HeldS4X54PKgpGZ
	 TS8TXSGJ9MbRM/1ZyXmfLLdGRj5Qv+UGvx2+c0SwjJkReqWZmk2HBowyvI/+0zgSR5Ym0
	 cKUetQ3AmbbpygUaUsJNP07ba/M933T6oJhUcUUe0mrUk6kxJEVHZt4fZfBXPlqcezg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=etjUBHhZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AC0606A31C;
	Thu, 26 Nov 2026 14:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=etjUBHhZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89D51F000C4;
	Thu, 26 Nov 2026 14:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704976;
	bh=KQ72hMhqMbRWC6jp2Mm0EIIN5IFL+zPjyM+XTLoBtZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=etjUBHhZRF/jkYro2vjkCOBJr4roYA6T/vF/77d2TFwX0RReQgJkFmpXzHF9CIMSF
	 L8atAlnfN0Jn9qcKWKeXOtcz/QgkvT9wLkYvmoY/XDrARsKcjffez07sm6RtD07IsS
	 zJe0Fi++VG7w9Fltd/H4v/9CRCBREQPdsz1SWrL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 041/319] bpf: Move the MAC header in bpf_lwt_seg6_adjust_srh()
Date: Thu, 26 Nov 2026 15:36:49 +0100
Message-ID: <20261126144007.663774716@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit 0fcb3f11a93d740e7f9ae1aeb48fe4d25838be18 ]

bpf_skb_net_hdr_push() and bpf_skb_net_hdr_pop() change skb->data and
skb->mac_header by len. That is correct in a tc prog, where skb->data is
the MAC header. But bpf_lwt_seg6_adjust_srh() calls them in an End.BPF
prog, where skb->data is the network header. The MAC header does not move:

  before push  |       free       | MAC header   | IPv6 | SRH | payload
               ^ head             ^ mac_header   ^ data
  today        |       free       | MAC h| IPv6 | SRH   + len | payload
               ^ head     ^ mac_header   ^ data
  this patch   |   free   | MAC header   | IPv6 | SRH   + len | payload
               ^ head     ^ mac_header   ^ data

Users of skb_mac_header() get incorrect bytes until __dev_queue_xmit() sets
skb->mac_header again. skb_cow_head() reserves only len bytes. Thus the
16-bit offset skb->mac_header can wrap. A push also changes the "not set"
value. In both cases skb_mac_header() points after the skb.

Move the MAC header too. Pass len + skb->mac_len to skb_cow_head(). Keep
the "not set" value. The second Fixes tag is for this case. Since that
commit an End.BPF prog can get an skb with skb->mac_header not set.

Fixes: fe94cc290f53 ("bpf: Add IPv6 Segment Routing helpers")
Fixes: 20a081b7984c ("seg6: add VRF support for SRv6 End.DT6 behavior")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-21-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 0ff701919ee67..acd6b72964043 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6318,6 +6318,7 @@ BPF_CALL_3(bpf_lwt_seg6_adjust_srh, struct sk_buff *, skb, u32, offset,
 {
 	struct seg6_bpf_srh_state *srh_state =
 		this_cpu_ptr(&seg6_bpf_srh_states);
+	bool mac_set = skb_mac_header_was_set(skb);
 	struct ipv6_sr_hdr *srh = srh_state->srh;
 	void *srh_end, *srh_tlvs, *ptr;
 	struct ipv6hdr *hdr;
@@ -6342,20 +6343,38 @@ BPF_CALL_3(bpf_lwt_seg6_adjust_srh, struct sk_buff *, skb, u32, offset,
 	if (unlikely(len > (U8_MAX << 3) - srh_state->hdrlen))
 		return -EFAULT;
 
+	/*
+	 * skb->data is the network header here. The MAC header is in front of
+	 * it, so bpf_skb_net_hdr_push() and bpf_skb_net_hdr_pop() do not move
+	 * it with the other headers.
+	 */
 	if (len > 0) {
-		ret = skb_cow_head(skb, len);
+		ret = skb_cow_head(skb, len + skb->mac_len);
 		if (unlikely(ret < 0))
 			return ret;
 
+		/* The push can write over the MAC header, so move it first. */
+		if (mac_set)
+			memmove(skb->data - len - skb->mac_len,
+				skb_mac_header(skb), skb->mac_len);
 		ret = bpf_skb_net_hdr_push(skb, offset, len);
 	} else {
 		ret = bpf_skb_net_hdr_pop(skb, offset, -1 * len);
+		/* The pop has added -len to skb->mac_header. */
+		if (likely(!ret) && mac_set)
+			memmove(skb->data - skb->mac_len,
+				skb_mac_header(skb) + len, skb->mac_len);
 	}
 
 	bpf_compute_data_pointers(skb);
 	if (unlikely(ret < 0))
 		return ret;
 
+	if (mac_set)
+		skb_set_mac_header(skb, -skb->mac_len);
+	else
+		skb_unset_mac_header(skb);
+
 	hdr = (struct ipv6hdr *)skb->data;
 	hdr->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
 
-- 
2.53.0



