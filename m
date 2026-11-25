Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621093;
	b=mkH4QBBsdy6+x6JI8uJ2/U0gF0yjl/Iit/NUDBoVNua84QaYEIyyb4FZtKJe7sZwrBaD
	 WzVQcVA2k5iL0WH5mHWLuiwrkJZhoC+9MmmYLM4+97MDC/l75aEmFVRAdYVlfF5vvuy1/
	 TBwfqgJLlv17qu5RsBxaySSdDTGR3vC6QZ6EaKdU1bdwQs7v+JnDW0ouCsN9ZufsuG5Fz
	 y+cwek06fRCXOOHETYXG5uISKZqXYS2oHiOfZxGurw7a9h7tyuQPQEl55KfbHsc9ICpfE
	 pADOY/j/FZRgPtZOZNjpr8XhgmpfF+IQ4VUHhKXSdNlE57i7aVOuKf2MzP0yWmv2Cpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621093;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CEQJ13MZRJFu4XeVVjmnuw/ZVzPJK7/2gUE8S+nNdq4=;
	b=FIb5pCr6qVhrjQgWdEWq32ztkcdmnlEsjjNmBm5ixcD+defwLbHgpfgZVuHPburp4ffm
	 DdPXYC9YTIA9jHkQ1c9lIgMEeMZbJD8YY804CJbGYZPWsbKPVPzjH9FgJ1V/H8o0QVwUS
	 iYjDDLHRu7z3ZXq+c0wDFbz3jfb3pXuzJFUhFyl02YKfL+J37hrVNxlXmeMexRZcxXvxd
	 Syd52fucgcHILhAOe4jqNujPbvxjf3ZBtyvWxg1fZulOyAbLavFWaqApFFF9C1moRaShD
	 FrLfQBU2EJA2KnCpY5mZFkra1QexGbeiu/f0aZKe+DQ7AtlNvIjr4wMc64IB39uuAxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w8xFhc7l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DAE606A332;
	Wed, 25 Nov 2026 15:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w8xFhc7l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45F71F000C6;
	Wed, 25 Nov 2026 15:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621093;
	bh=CEQJ13MZRJFu4XeVVjmnuw/ZVzPJK7/2gUE8S+nNdq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w8xFhc7lJwIp0TAtndR9yYxqQFc1oWbxyBGsyX8UJBO1h4gj6hM78n1HuWFnEmOo3
	 BJIIZDx0Yt+kyVKs6O9owrALWzzZKWNMvBykEevUwUaifV04HB7VaJi/Kl9i3NsTbW
	 dWfwrbWlz0CXDquz2RgJyoymbfr2oGPBkZqBqzWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 120/990] bpf: Limit the SRH length in bpf_lwt_seg6_adjust_srh()
Date: Wed, 25 Nov 2026 15:24:47 +0100
Message-ID: <20261125143824.900069711@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

[ Upstream commit ac159f39b252971141c49b68a27de0b637debfad ]

bpf_lwt_seg6_adjust_srh() lets an End.BPF prog change the size of the TLVs
in the SRH. The helper keeps the SRH length in srh_state->hdrlen, in bytes
and without the first 8 bytes. Later seg6_bpf_has_valid_srh() writes it to
srh->hdrlen, an 8-bit field in units of 8 bytes. But srh_state->hdrlen has
no upper limit, and the cast to u8 can truncate it. After that,
seg6_validate_srh() gets the SRH length from srh->hdrlen, and thus it can
accept the SRH. Then srh->hdrlen is too small, and a parser reads TLVs as
the subsequent header.

Return -EFAULT when the new srh_state->hdrlen is larger than 2040, the
largest length that srh->hdrlen can hold. To replace a TLV in the largest
SRH, a prog can no longer add bytes first. It must remove bytes first.

Fixes: fe94cc290f53 ("bpf: Add IPv6 Segment Routing helpers")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-19-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 2df3e5cfc3fcd..a40e3641ec9b4 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6863,6 +6863,9 @@ BPF_CALL_3(bpf_lwt_seg6_adjust_srh, struct sk_buff *, skb, u32, offset,
 		return -EFAULT;
 	if (unlikely(len < 0 && (void *)((char *)ptr - len) > srh_end))
 		return -EFAULT;
+	/* The length field of the SRH has 8 bits, in units of 8 bytes. */
+	if (unlikely(len > (U8_MAX << 3) - srh_state->hdrlen))
+		return -EFAULT;
 
 	if (len > 0) {
 		ret = skb_cow_head(skb, len);
-- 
2.53.0



