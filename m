Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020943;
	b=07AOeh2ASjK2oGFa3BNe+Scmg/lpb4Q6X4V9R+mpMDOYoChqDfAPHSZN2981sYYPQZjn
	 CJEaUn75DlzAVNC2F99P2C5yaXduyBdue/n+urRvdOZSAm5kQb9LbKV9C+dyx6xHzvHvx
	 YMTnaJwitGMX5QmE8gGaAn1VjOzp/1U61Jr3PjXxtciCSkX3ijxflfEvE89KFX+LuYhd8
	 r0sCQIGA18AfVbHwvkVkQIzsppeuyCXQc0kqS2XLwAnx2p5n9wE+y82tZR5fuUfDMCl6J
	 JqSrs9WgG7S7nIEZX9GjkbRUotiTZWm03ONmjyHj1pCFL4u3wxp3nc7pPw+y1NJIerQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020943;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=URWAEXIsEMI451Q8LlTAWmIBEedhHAzAWQcGkl7GImM=;
	b=TjJyIxbpaFFgUBp8ws0HDb5aAzG6ftjTVwFCQkdvJmZv3MkA5OICMyAdXZO7RvSKK9fz
	 ARF+lViwirBpPWAQ+w2kHt8H8CtF69qhvfVrQLCEn7UWKlZA41QyvbGVHry54h+IwKfmS
	 n+rVRmRns7YFZ76EDbwBW35+x5WCAE3mqbd9BObTuoogSSOEvWqs0D24jjYvNZ/cgq2iA
	 VdyIKmyq0yv28mSBcZf1Ox8MqCy7EvpLUCp6KZVoTrThNACuVj6sUgroSSY7DewLPdXhF
	 Gye4RndcuIhfi3uVtPQomPOCERJrJfiqM4Q59efEIqCv53LLhal6Q777bpiE9OjqJOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nw9feIgc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049CA606A325;
	Wed, 18 Nov 2026 16:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nw9feIgc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537FF1F000C4;
	Wed, 18 Nov 2026 16:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020942;
	bh=URWAEXIsEMI451Q8LlTAWmIBEedhHAzAWQcGkl7GImM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nw9feIgc2DvBbgMCYB3bjJLIzsIXjMpGMvZJVUjZn7adGRHl+dUdCsIKrFwcXKGBE
	 Y56UBiyhEHz05gLPUCtjMqE8sIEx16fnKfBQS2KK+bGUrvEULQqoigANrKFBrBIH4p
	 mJeXM9UVlsyUxkNAr5zEUfVbtZsVp/2H780EOw+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2130/2651] bpf: Use memmove() to store bytes in an skb
Date: Wed, 18 Nov 2026 15:56:10 +0100
Message-ID: <20261118150402.576267035@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 1db084f42884c5af881fedf3df4777fe2095b20b ]

Through bpf_dynptr_write() and bpf_dynptr_copy() the source of
bpf_skb_store_bytes() can be a slice of the same skb which overlaps the
destination. memcpy() then reads bytes which it has overwritten already. On
x86 with FSRM it repeats the first bytes of the source instead of copying
it. Local, ringbuf and skb metadata dynptrs are written with memmove() for
that reason.

Fixes: 2012c867c800 ("bpf: verifier: Accept dynptr mem as mem in helpers")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017230950.802052-15-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index aa229d1ebe28a..3ffff068b03a7 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1749,7 +1749,8 @@ BPF_CALL_5(bpf_skb_store_bytes, struct sk_buff *, skb, u32, offset,
 	if (flags & BPF_F_RECOMPUTE_CSUM)
 		__skb_postpull_rcsum(skb, ptr, len, offset);
 
-	memcpy(ptr, from, len);
+	/* through a dynptr the source may be an overlapping slice of the skb */
+	memmove(ptr, from, len);
 
 	if (flags & BPF_F_RECOMPUTE_CSUM)
 		__skb_postpush_rcsum(skb, ptr, len, offset);
-- 
2.53.0



