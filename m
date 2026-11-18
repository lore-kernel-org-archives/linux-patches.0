Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021679;
	b=YRL1kqS2lkY3g+zbPdIDxjidP3rgt/MMiSPKNJxx0HtbjoHAywjN2OlWe1ZYYUeLoYE1
	 GNKnok11C142MKgCE7QRzIqhTVNdvnEXLWsZWZcnPP5OUdEMf/4b/TzMKpxjuoUs3Ticj
	 AC33sXvBA6mGff3zYOpRSUlKzxL0u2r3mZsZwEoGA9Xjp2vFWv8rvgttxliQdGzQV6Gi3
	 7716mZA5bhAw0yLqqWkJqayzux9lTnKofSEy+J5eB9yyzfVfWRw0W+VLtdIzI/QpZG/xr
	 XZ9NAhq7VG5/xK5OgTLf8VrSEHNVb7UaDXNkjffcRD2i7P3IfywWSUc/GVI2tCxfzgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021679;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I0JB38feJCYHuZWBX12yyHrzOmGlouhCI1SpEaZWXPo=;
	b=qVUwI99E4t4JnsKP1zrUSWyqJH7gf5kBNVoonMPkpdprgJGk4kxQSzJLhu3QvEaICjDt
	 djlsj/skjhQfYFJB618vkYSOApm0R8owBYtl0yno1lDnpRowLAyEJdkFv7/NsYdRHFBaA
	 uiH/3Adzw/7UgSe5aDINMHAhGu+QGFuF7q1fGTnw2+7GD+NFYY7dd4+2PAKQDRlMY6yjV
	 NKwJDXx1UgysHi1ThQ9i+s3dJi6ynigGvHWH9ebeeLZcngsFKNWCMa/eUzuPFDHlLXuuf
	 jcJwE4CvPwFL7VuCch4+bsX7A3xujzBg9VLCaqQQUcvTwxPLjSalf0dt8o4m0MBUIqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OS7A+GA6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AFB606A325;
	Wed, 18 Nov 2026 17:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OS7A+GA6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138001F000C6;
	Wed, 18 Nov 2026 17:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021679;
	bh=I0JB38feJCYHuZWBX12yyHrzOmGlouhCI1SpEaZWXPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OS7A+GA6E45ACeF/IOSafLL2or0JCdR1mdWIb7OeQBpBvZJl8/0bCqqEics7vvXJT
	 MCs8xcZuxe8JnaT8rTzg00GwXATtaDYpKXhjVBeOaFtasmpc0Cc3a/evr0LvZrcqng
	 8kCgKtjr2RkQV2cG72Yzlw9VsruPAxPYwMZ3PsK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ayushman Rout <ayushmanrout27@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2392/2651] bpf: Use memmove() to load bytes from an skb and an xdp_buff
Date: Wed, 18 Nov 2026 16:00:32 +0100
Message-ID: <20261118150411.509655645@linuxfoundation.org>
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

From: Ayushman Rout <ayushmanrout27@gmail.com>

[ Upstream commit b93cf2c8a0552b544e90e25802e4bf989987d29d ]

bpf_dynptr_read() on an skb or xdp dynptr ends in bpf_skb_load_bytes()
or bpf_xdp_load_bytes(). The destination can be a slice of the same
packet, so it can overlap the source, which memcpy() does not allow.
On x86 with FSRM memcpy() copies forward, so a destination above the
source gets the first bytes repeated:

  p = bpf_dynptr_slice_rdwr(&ptr, 8, NULL, 64);
  bpf_dynptr_read(p, 64, &ptr, 0, 0);

leaves bytes 8-71 of the packet as bytes 0-7 repeated, not bytes 0-63.
Reproduced with BPF_PROG_TEST_RUN on both an xdp and a tc program.

Use memmove(), as the store side does since commit 1db084f42884
("bpf: Use memmove() to store bytes in an skb") and commit ab08863c58b1
("bpf: Use memmove() to store bytes in an xdp_buff"). A read that spans
xdp frags still goes through bpf_xdp_copy_buf() and is not changed
here.

bpf_skb_load_bytes_relative() has the same pattern and is reachable
from tc and sk_filter programs, so use memmove() there as well.
Reproduced with BPF_PROG_TEST_RUN on a tc program: loading into a
slice at offset 8 gave wrong bytes before the change and correct
bytes after.

Fixes: 2012c867c800 ("bpf: verifier: Accept dynptr mem as mem in helpers")
Signed-off-by: Ayushman Rout <ayushmanrout27@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261022112312.31563-1-ayushmanrout27@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 9e577495eef19..0ad1507759ded 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1789,7 +1789,7 @@ BPF_CALL_4(bpf_skb_load_bytes, const struct sk_buff *, skb, u32, offset,
 	if (unlikely(!ptr))
 		goto err_clear;
 	if (ptr != to)
-		memcpy(to, ptr, len);
+		memmove(to, ptr, len);
 
 	return 0;
 err_clear:
@@ -1871,7 +1871,7 @@ BPF_CALL_5(bpf_skb_load_bytes_relative, const struct sk_buff *, skb,
 	ptr = start + offset;
 
 	if (likely(ptr + len <= end)) {
-		memcpy(to, ptr, len);
+		memmove(to, ptr, len);
 		return 0;
 	}
 
@@ -4305,7 +4305,7 @@ BPF_CALL_4(bpf_xdp_load_bytes, struct xdp_buff *, xdp, u32, offset,
 	if (!ptr)
 		bpf_xdp_copy_buf(xdp, offset, buf, len, false);
 	else
-		memcpy(buf, ptr, len);
+		memmove(buf, ptr, len);
 
 	return 0;
 }
-- 
2.53.0



