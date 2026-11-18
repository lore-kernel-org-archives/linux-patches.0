Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042019;
	b=UI1su4KIpLQ+xF/HvQjWsiQQvRZzpD4Ue6OFsCtZPME7NneWEVdN0S4LvBbJIqdMYVpP
	 vniMK0kax5bmHAc/KQ5U9ZxQlA1+8zz/TEOCZMnA4QjUOP2W8E6mxHFC4jTKlel+1YxAW
	 0X1IIoUTZ9rQ1s+lRn2oZc0kA1cXuhRWXS6p9PTzZUc+eqgQLjUMKdPMkkuydBeUNS3lL
	 LgowAVdC8ecQaMqp1WhAUb7lBecweTWIPyj7FgD7tepPLTQ2tfTpZC+euR9jQNQS/dys7
	 rfExksMtktzoBClQn+3qgxaQrhTJC03k/4cqEUhAmJ75dwn9QsL1Vp4CtwVI94zVOiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042019;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JlJncRiFfJ1rfLoig3i1iIyRTDZqIL4shZwUukNqQ0w=;
	b=JevvOgrBD8XsNToYrVTUTUsOON4IwCWxaAFq53N60qaJk2PaXZXIbXLMaMrPSjstqnTR
	 Rxsjm29Bqk+zGnut7AalvNDQc/xylZ1wmHwy3VJkTWpJx2TIYDxc1Hzl9JMv4tpkHNeEM
	 kNaP3aLvl1QZcqMdXnIZ2SK9A+Z2mImDDSyW6PCckYUdAYeoSkgUqSgi2bhc1Rqe69SpO
	 eiFtdYzFHGf/9kglv3qUss4V7CtsBqsRC2v/NQja8i4Ztew2h7j9Cn8Qm2dfa7MrhLrF3
	 lnp1lGFTYnRrC90v9f/PvMOzXpSMRRbqwreCLvgDlTbMleeQebagBlCt1+ct6k8c5Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dQsk77pO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E35606A31C;
	Wed, 18 Nov 2026 22:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dQsk77pO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85FF1F000C4;
	Wed, 18 Nov 2026 22:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042019;
	bh=JlJncRiFfJ1rfLoig3i1iIyRTDZqIL4shZwUukNqQ0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dQsk77pOGayX6L+qG6D2HcBgUVyQUxGUcX6PmrUkaruxyau5PpEDqzlZsdFxzBf4K
	 Hfuh0t/XzZ0aa8+cgv79miHfYqDniEIBSpXyCTIqdyIwg4aK55i03KBpK4Q50qkIVX
	 D10XUO9IEE61nkH9Wk45NfqjGrOyoRS/G25QNBj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3019/3318] bpf: Use memmove() to store bytes in an skb
Date: Wed, 18 Nov 2026 16:00:41 +0100
Message-ID: <20261118150450.781624460@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cf123f6410ac3..c86e31c46582b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1724,7 +1724,8 @@ BPF_CALL_5(bpf_skb_store_bytes, struct sk_buff *, skb, u32, offset,
 	if (flags & BPF_F_RECOMPUTE_CSUM)
 		__skb_postpull_rcsum(skb, ptr, len, offset);
 
-	memcpy(ptr, from, len);
+	/* through a dynptr the source may be an overlapping slice of the skb */
+	memmove(ptr, from, len);
 
 	if (flags & BPF_F_RECOMPUTE_CSUM)
 		__skb_postpush_rcsum(skb, ptr, len, offset);
-- 
2.53.0



