Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032359;
	b=GXPzbyKzHtLt6urWxt0oj4Y5gglCq0ZfZ5mK5goP66CffF7nUsf2OwKVeFNFO7hZaJp8
	 SqkoNOrewkSJeSI0is2N1nCqxRFtACuCQkC1qUNPiMeFYWnyC+uqotBW9qw2lmXvnCL/h
	 j6b+rI1Pa9PqOn4IlNuzQ10XVFx3tMhufdqdPuWGQFXG/Dab7aeTyeQSQIt2ZRaaDOKmi
	 WRCYYqKOh9KSYsOhi8rTj5xFeDnpMEeH1KV15pf9qriR/mkusJU9nnQKYtvSho9vC9X/Z
	 aeS6EIfqJ8OPUC7sq7kjAbE4uDk3gUZUwUPTugtYHb2Navv2X9e/A4LJd5AOVXQeHSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032359;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sjyMHbMpv/RQUPN2fUIvCKcM+shRT8SUhzhzHWMsLC8=;
	b=GuJG5T89uOavopBCbTjMrdAR6ndF1ECypBybuIK+Cp4C34O4AEoY3hO6t2EZZM3jbDAS
	 SyR0Dh78s5buN3KaLJDFvAMhBoFX3h6y6/pdRI+32cwU92tKDPn5q65bOfk3f08wH5IMk
	 he4k+5wp86QPmdYsw3BV5k1s6KdqXxmNDbV6hlFCPG2Eo3013Jp1mJs+lvLqCwCp3C564
	 nuUx2FFRCUl5xUt+dTlU6b25CKiUskdvy4o0DLRskv8E8KYaaDyBzSHicb5MbjdCfx/q/
	 47YkZZrwpRDN3ygQDuh8PW+DZE8O2AGJCQwqd/X1VAAegsuiwqVd+QfWafNEQ9yB1Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AijH11k8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3C3606A330;
	Wed, 18 Nov 2026 20:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AijH11k8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD2D1F000C4;
	Wed, 18 Nov 2026 20:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032358;
	bh=sjyMHbMpv/RQUPN2fUIvCKcM+shRT8SUhzhzHWMsLC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AijH11k8d2SPrao6rCVtIqwCw9MWvdQEAU9hI7g++LbBW4NgNGAZlIrakOGnDZIyo
	 w+eVDm6BrO/VjPundcokXNfo4u7/QNq+1Aayk6X+8evee170QTfgQYncVAFG+zQJa6
	 etVwA602jgwNw7MnvZCY2JeaVNz6BtCdkF4XWAs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1385/1756] bpf: Use memmove() to store bytes in an skb
Date: Wed, 18 Nov 2026 15:58:32 +0100
Message-ID: <20261118150104.312332941@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 1dc436c4e0f8e..f8a1c78d46fd4 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1736,7 +1736,8 @@ BPF_CALL_5(bpf_skb_store_bytes, struct sk_buff *, skb, u32, offset,
 	if (flags & BPF_F_RECOMPUTE_CSUM)
 		__skb_postpull_rcsum(skb, ptr, len, offset);
 
-	memcpy(ptr, from, len);
+	/* through a dynptr the source may be an overlapping slice of the skb */
+	memmove(ptr, from, len);
 
 	if (flags & BPF_F_RECOMPUTE_CSUM)
 		__skb_postpush_rcsum(skb, ptr, len, offset);
-- 
2.53.0



