Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704973;
	b=l9VcMy9l323jsuK1F3TMis6j3JtHZFbxO2gAp3T19jCTxkpup4f5mJPI+kyaRA+qeoxs
	 H9+1wEP+jQ7ULe9RKqy2+MzgfQOPNkDvTfMvLzfZ8NC9IAocQAl1Ko0NCSdjIOuwD6wQD
	 yfcZV78/ek3gUPdeJwo535GLdiE/Hk/q2JBSYAc7gmFOlOh38NPVB5Jvjhhgh4OsTWivC
	 NEe403NsKVYUI1jTO6BIgDztl/Ajz/YcfQZLJ4s7BtEga1GrSgpEncyEQ2gYCBbVP3xRw
	 zWqOOhTx5VGt3UDZCNq+ry9RmJVYKq+2PhDLuB7fduV5iUFeutChGrSzb/inBL+mqnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704973;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8tIqKUzt4Kv3o+jf8OeeBrA7XCocX1xELHTMs6nUu6w=;
	b=O7zOsbzRJN5lw6cuQd8DWx9Lo05qH9yGVfott8OJ6b1hizDX4jF/SaGxp9Mm7U/Mw0PH
	 L9XwpRjPBNHJpA1G7PiO7vmk1ITnJNJHbCwWKXJPgh2UAlspAs69OXBN8vvhvnA1e52N5
	 UdAiJ64oKyOXuw5giSEhJlztmG6CodYyyBxWO0n1llj3VsoO4k0MytFVPw1pJ6Sk9KAFb
	 wLhwGVODhsd2VL6D7txozdq9TZ+BD2tyGORnY5f2cc+cxW5UWAcX81v7vt/Lk2IKkwyHs
	 sZMusiHoAS9sLDATrOm4w9uTS4K22xplPE4wQ6bJqnq/+lXt4F04JVjiXWcIJEjWidA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NoldMnkD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA603606A31E;
	Thu, 26 Nov 2026 14:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NoldMnkD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8901F000CA;
	Thu, 26 Nov 2026 14:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704973;
	bh=8tIqKUzt4Kv3o+jf8OeeBrA7XCocX1xELHTMs6nUu6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NoldMnkDpRHyO5DiFCPoPlAQlIbZqr8BME97Ne8fyKnPQ1Kx9oUVmiEc9JzGyEamD
	 cN7Fem/rZKTEFRVdudcFggOPDjlqEvG89t9jwvoIAtzR47NYADd5mJhD+9++XjwF9b
	 69pvpFXmIAVnPkZrye0RIMmGrb2LuwctTd5OKzYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/319] bpf: Dont look for the SRH again in the End.BPF helpers
Date: Thu, 26 Nov 2026 15:36:48 +0100
Message-ID: <20261126144007.642562118@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 45bcc58d576705d2c001332766e10313f1c55bad ]

A packet can have two SRHs. Thus input_action_end_bpf() uses
IP6_FH_F_SKIP_RH to skip routing headers with segments_left 0. The helpers
bpf_lwt_seg6_store_bytes() and bpf_lwt_seg6_adjust_srh() can reallocate the
head of the skb. Thus they look for the SRH again, but without this flag.

  +------------------------+ <- the helpers: srh_state->srh
  | SRH 1, segments_left 0 |
  +------------------------+ <- input_action_end_bpf(): srh_state->srh
  | SRH 2                  |    and srh_state->hdrlen
  +------------------------+

Then the helpers check offset against the wrong limits. If a helper changes
TLVs, seg6_bpf_has_valid_srh() writes the length of SRH 2 to SRH 1.

Neither helper changes the offset of the SRH from skb->data. Calculate the
new address from this offset. To add IP6_FH_F_SKIP_RH is not sufficient,
because advance_nextseg() can set segments_left of SRH 2 to 0. The helper
bpf_lwt_seg6_action() can change the headers and still looks for the SRH.

Fixes: fbbc5bc2ab8c ("seg6: ignore routing header with segments left equal to 0")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-20-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 07e60e4d9886a..0ff701919ee67 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6185,11 +6185,12 @@ BPF_CALL_4(bpf_lwt_seg6_store_bytes, struct sk_buff *, skb, u32, offset,
 		this_cpu_ptr(&seg6_bpf_srh_states);
 	struct ipv6_sr_hdr *srh = srh_state->srh;
 	void *srh_tlvs, *srh_end, *ptr;
-	int srhoff = 0;
+	int srhoff;
 
 	if (srh == NULL)
 		return -EINVAL;
 
+	srhoff = (unsigned char *)srh - skb->data;
 	srh_tlvs = (void *)((char *)srh + ((srh->first_segment + 1) << 4));
 	srh_end = (void *)((char *)srh + sizeof(*srh) + srh_state->hdrlen);
 
@@ -6202,8 +6203,7 @@ BPF_CALL_4(bpf_lwt_seg6_store_bytes, struct sk_buff *, skb, u32, offset,
 
 	if (unlikely(bpf_try_make_writable(skb, offset + len)))
 		return -EFAULT;
-	if (ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, NULL) < 0)
-		return -EINVAL;
+	/* The head may have moved. */
 	srh_state->srh = (struct ipv6_sr_hdr *)(skb->data + srhoff);
 
 	memcpy(skb->data + offset, from, len);
@@ -6321,12 +6321,13 @@ BPF_CALL_3(bpf_lwt_seg6_adjust_srh, struct sk_buff *, skb, u32, offset,
 	struct ipv6_sr_hdr *srh = srh_state->srh;
 	void *srh_end, *srh_tlvs, *ptr;
 	struct ipv6hdr *hdr;
-	int srhoff = 0;
+	int srhoff;
 	int ret;
 
 	if (unlikely(srh == NULL))
 		return -EINVAL;
 
+	srhoff = (unsigned char *)srh - skb->data;
 	srh_tlvs = (void *)((unsigned char *)srh + sizeof(*srh) +
 			((srh->first_segment + 1) << 4));
 	srh_end = (void *)((unsigned char *)srh + sizeof(*srh) +
@@ -6358,8 +6359,7 @@ BPF_CALL_3(bpf_lwt_seg6_adjust_srh, struct sk_buff *, skb, u32, offset,
 	hdr = (struct ipv6hdr *)skb->data;
 	hdr->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
 
-	if (ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, NULL) < 0)
-		return -EINVAL;
+	/* The bytes in front of offset have moved together with skb->data. */
 	srh_state->srh = (struct ipv6_sr_hdr *)(skb->data + srhoff);
 	srh_state->hdrlen += len;
 	srh_state->valid = false;
-- 
2.53.0



