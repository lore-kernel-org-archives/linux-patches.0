Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020819;
	b=BqKAqSFnYFIqEE6t9nQzYhh5ThFbTb7tyOrX8XU+dXTFrzYLmebTvLAF98FEARg6icOh
	 CFbTeHhafD1OeqPyDfqBKU1gblIdBBQPhAoqra5ArnINDUglyUktGM16tcPQnFo6wBf7D
	 u4lVX8ThVdc3eRB1QzwpiRpkN4bsKNKCOOKAfNdHxM+Bjlmw707piLkkLsRw//JNgPC8C
	 cFw/yR9EaNDOaZVtCk+U2zk4aKS2K2/Cr6JAIsYwBJsspRihC0xCXxPAmxUR4x/XbAQtP
	 xJ6OaDs0cfNH/t9Xi6H6Yox+ZLqPyQdmW7enIluxFzPdvGehHateJLNn8mG6E5AoIWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020819;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1ApeAE7Nsng+e3FAniAJ7saWurb5A/hSn61h60YqSTw=;
	b=ppaTbo+1/5gA4ugD99hb5MSDFePxGe8jpPHyEU4KG4KXOInUX2e1zO2hRgpEofM5wisM
	 GY50d0r5wEpHlR06AHwkYbfJ/KZ8U2r/aYEhlgVtxyr9AlfOKjz7z3S0XKH5XHVoCbVSQ
	 tpYd4KFgILbsLO1j7+qIduQL36Vv9PAad4zsfSZgmpSDqyacCYQGGQiuj29h6tPQEFQJ3
	 fp8LT3Q1JK3vkcqZJVJN1wIUbWPQXDgRGpQpq0/xJlBNUidNP7h80JUJzC3pyPx0EKbHP
	 k6tPrPJVER69ERUkyL5eJw/l3ThrmYb3jiSohv+K4Xi7ic9edEr314uw7SfLLnhlK/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fr4qJV23;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA96860A262E;
	Wed, 18 Nov 2026 16:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fr4qJV23
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7D31F000CD;
	Wed, 18 Nov 2026 16:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020819;
	bh=1ApeAE7Nsng+e3FAniAJ7saWurb5A/hSn61h60YqSTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fr4qJV23DUyGe6JOoD1XKUAWVUkboL+DrLKThYLNSLEBkBusWb/MlOWoeFFrUu4DS
	 LfcZavh4jfBH3P7+XVYQkNHaL3BGTDWnsHBfdagn4NYGj0AQ6yqJscYGkB4Qei+hBG
	 E8UtCqtkV/8OWSqSz92DcL4/CsYXp0DlIWsWZ+70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaiyan Mei <M202472210@hust.edu.cn>,
	Yinhao Hu <dddddd@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2086/2651] bpf: Fix verifier WARN on narrow read of bpf_tcp_sock u64 fields
Date: Wed, 18 Nov 2026 15:55:26 +0100
Message-ID: <20261118150401.108719304@linuxfoundation.org>
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

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit af873495cbcb066ab029f7f63b94410d4db47628 ]

A BPF program can read the middle of a u64 field in struct bpf_tcp_sock:

	tp = bpf_tcp_sock(listener);
	/* +0x54 is in the middle of the u64 bytes_received */
	unsigned hi = *(unsigned *)((char *)tp + 0x54);

bpf_tcp_sock_is_valid_access() allows this 4-byte read (the default case
only checks size == 4), but bpf_tcp_sock_convert_ctx_access() only knows
the field starts and has no idea how to handle such an offset. It emits
no instruction, cnt stays 0 and the fixup pass trips verifier_bug():

	verifier bug: error during ctx access conversion (0)

Just disallow the narrower access by matching the whole u64 range of the
two fields, so it is turned down at check time:

	invalid tcp_sock access off=84 size=4

Fixes: 655a51e536c0 ("bpf: Add struct bpf_tcp_sock and BPF_FUNC_tcp_sock")
Reported-by: Kaiyan Mei <M202472210@hust.edu.cn>
Reported-by: Yinhao Hu <dddddd@hust.edu.cn>
Reported-by: Dongliang Mu <dzm91@hust.edu.cn>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017143819.209510-1-jiayuan.chen@linux.dev
Closes: https://lore.kernel.org/bpf/7a8ff335.1024c.1a14395f3e5.Coremail.kaiyanm@hust.edu.cn/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index d3e5a2843d5e1..99e6aa572b2bc 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7607,8 +7607,8 @@ bool bpf_tcp_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 		return false;
 
 	switch (off) {
-	case offsetof(struct bpf_tcp_sock, bytes_received):
-	case offsetof(struct bpf_tcp_sock, bytes_acked):
+	case bpf_ctx_range(struct bpf_tcp_sock, bytes_received):
+	case bpf_ctx_range(struct bpf_tcp_sock, bytes_acked):
 		return size == sizeof(__u64);
 	default:
 		return size == sizeof(__u32);
-- 
2.53.0



