Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027313;
	b=w4vEkEBLwUvegpEDVkAw9pBwe1DM4pUG23pqm+vRX0PX9lBjer45Nmg8HEoeSA/APvAA
	 EWw8Drt3YaV1DJrs9lei3VgdBfk7koH5g4TgGPliaw2VRrDZtnE8qIVTJNjnXNbgwbji5
	 +oQh4CHD/w/wBzUsMqemKZ3TsIJ34ap3dUJYL6T653USrghkMW9LDZwGq8pvIHCZzZ/s6
	 mCkCSlzAVdvQnn1/WZ8rhITYXDRpL0njl+CEPjjLhZtSdZqyeTrzwNmZQVSgQF4Nj86PI
	 MCTXw3coxttr4D7zI3SxHVgMOfVnXD2zU2rwOnW0wPm611K+tEif+pxcyVgoR23Vyfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027313;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LbP4h4ViuAW3gxRxn5sQjzRWXr1BPAyRbssg30nd5Z4=;
	b=NgSMd/m/G7qz+BLHVZ8cbI4mgBsqHF1rmqnFVh2bWBVXKIRK6K63YipZvGcjBEN+LcQz
	 dBVcE+e6t4iCucnBVfDOM+yMwMmVF0gwFpsDW056fg+Ajvc87qeBWFTrE8jTnLnu9Cw08
	 rXQh3blqETmIWgenalaHFy5HzAKMBNR3Er1n5xSvxIR3DZKQ6tnCm+iQ/0/lVtsXlw6xM
	 e9Aadbf3h5TSG1onyvReXAUo5YQbACB7XJFGgTxAyZciyVXAI2wTilqSs9AKvSRGEBWY1
	 pPca63MoYs+VVpLbfb13A2Zp9vmEAn+h6Kvbsn4gxwulLMNnbH01o8C1ehit93FqgJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uvNz0vjM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF2B606A33B;
	Wed, 18 Nov 2026 18:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uvNz0vjM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F631F000C5;
	Wed, 18 Nov 2026 18:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027313;
	bh=LbP4h4ViuAW3gxRxn5sQjzRWXr1BPAyRbssg30nd5Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uvNz0vjMGYUw3RuyJzyeud6Hc2ojl/2UKKI8rqXkTvL4X/sFnVamtQXQLC7x+xP+D
	 JaqZvDcPCSxFw2/xwtxQaYC7bEu2yrpfWRPaFod6179Pwl19NFsAeewc6ewd8vESRS
	 2oZ63dtjQtTHvrI1uchXfsUsS+snxevQ3feV2j10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1746/2151] bpf: Use memmove() to store bytes in an skb
Date: Wed, 18 Nov 2026 15:58:01 +0100
Message-ID: <20261118150225.461229086@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index b6780339ae857..d79a51ba69824 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1751,7 +1751,8 @@ BPF_CALL_5(bpf_skb_store_bytes, struct sk_buff *, skb, u32, offset,
 	if (flags & BPF_F_RECOMPUTE_CSUM)
 		__skb_postpull_rcsum(skb, ptr, len, offset);
 
-	memcpy(ptr, from, len);
+	/* through a dynptr the source may be an overlapping slice of the skb */
+	memmove(ptr, from, len);
 
 	if (flags & BPF_F_RECOMPUTE_CSUM)
 		__skb_postpush_rcsum(skb, ptr, len, offset);
-- 
2.53.0



