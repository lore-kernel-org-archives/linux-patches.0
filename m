Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624160;
	b=J7W3U7p8y15gdPbhnXmUUiBBYq6BhFwUEOA5uNOxkdzjacSAhtr3jYWYIK/4WumBQK2q
	 QvthEdPTA75GQOBKUS6yyBOH/T2UFdvd/s1XFra6aoMCuTFfk/uwwXfkZpl5Vf3/pcNEh
	 YUhld4nEBpRh6xODGVyq746vqjlr55BQbdWLUv0VQLrOkXarTpWndpicsTctg5JmFOYox
	 ofaCbsAZCGJ1uDLmk66ujGlL85uBHq63OyN4F9wTdDY8r/UflsdfdsHnTNvZgjYn7kDwF
	 n9Kp+/WDTDvPvXBlo1QgwBXzELGzr9Y8GnJVLGNJ4d0RjR2nNyhZnrYf2faNQNQFz6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LbsUpdb9pWQh7PfzRKAqXJRi8c1asDo6SCfQDDTODHg=;
	b=xqv3UQbTZ0YfHJ9c+OjB77IhvFqgQz+zn1myaWnAnjktM1C19oU+5w+22BRQiLgFzCzC
	 rpAzg9dVLKSWdlV7ayvuKLnrW0vYlPuKTMyGFUxLsacrs1/C+vGKUWHetccK3qZspQ4w3
	 OiJqeIhqLE1fn5uQYYghY3538SDjO/IZct3yPwPxwOBNjIg8zldJNB1ZH8jSWIYDfppXi
	 v+P1IiagLGErY+Ls2uJaE+qsmSsZfLitLJpC1WZh/MZA2zsKIl1gVfyv43IBv5ljGGWPx
	 pa7xkYw2dxz+3aRGXYKRezEzkSdRUh3zXpyFDRibshb2DY/fVGYpTAGHn+a4Jnk2FbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n2DLYED9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FD8606A31E;
	Wed, 25 Nov 2026 16:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n2DLYED9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE60F1F000D3;
	Wed, 25 Nov 2026 16:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624159;
	bh=LbsUpdb9pWQh7PfzRKAqXJRi8c1asDo6SCfQDDTODHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n2DLYED9/KU4+BPFXauhltUmD+QyVP5y2tKHDn1g98PH6e+zP+W3YKIJgigsWJJf9
	 E8O1Y/UByyHZtwqFMG1SiBJW4MnLDD0jVdFXdpwDnoP00aEc5zXmpd3JHelSI7SqKh
	 cEgPi6NJ88mAlLRBy7cm3jNkrKW1XjS7UGMWZcCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 104/816] bpf: Dont look for the SRH again in the End.BPF helpers
Date: Wed, 25 Nov 2026 15:27:32 +0100
Message-ID: <20261125143851.622493454@linuxfoundation.org>
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
index e4930cd595350..59db81c2438ba 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6621,12 +6621,13 @@ BPF_CALL_4(bpf_lwt_seg6_store_bytes, struct sk_buff *, skb, u32, offset,
 		this_cpu_ptr(&seg6_bpf_srh_states);
 	struct ipv6_sr_hdr *srh = srh_state->srh;
 	void *srh_tlvs, *srh_end, *ptr;
-	int srhoff = 0;
+	int srhoff;
 
 	lockdep_assert_held(&srh_state->bh_lock);
 	if (srh == NULL)
 		return -EINVAL;
 
+	srhoff = (unsigned char *)srh - skb->data;
 	srh_tlvs = (void *)((char *)srh + ((srh->first_segment + 1) << 4));
 	srh_end = (void *)((char *)srh + sizeof(*srh) + srh_state->hdrlen);
 
@@ -6639,8 +6640,7 @@ BPF_CALL_4(bpf_lwt_seg6_store_bytes, struct sk_buff *, skb, u32, offset,
 
 	if (unlikely(bpf_try_make_writable(skb, offset + len)))
 		return -EFAULT;
-	if (ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, NULL) < 0)
-		return -EINVAL;
+	/* The head may have moved. */
 	srh_state->srh = (struct ipv6_sr_hdr *)(skb->data + srhoff);
 
 	memcpy(skb->data + offset, from, len);
@@ -6759,13 +6759,14 @@ BPF_CALL_3(bpf_lwt_seg6_adjust_srh, struct sk_buff *, skb, u32, offset,
 	struct ipv6_sr_hdr *srh = srh_state->srh;
 	void *srh_end, *srh_tlvs, *ptr;
 	struct ipv6hdr *hdr;
-	int srhoff = 0;
+	int srhoff;
 	int ret;
 
 	lockdep_assert_held(&srh_state->bh_lock);
 	if (unlikely(srh == NULL))
 		return -EINVAL;
 
+	srhoff = (unsigned char *)srh - skb->data;
 	srh_tlvs = (void *)((unsigned char *)srh + sizeof(*srh) +
 			((srh->first_segment + 1) << 4));
 	srh_end = (void *)((unsigned char *)srh + sizeof(*srh) +
@@ -6797,8 +6798,7 @@ BPF_CALL_3(bpf_lwt_seg6_adjust_srh, struct sk_buff *, skb, u32, offset,
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



