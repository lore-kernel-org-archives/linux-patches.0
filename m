Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046714;
	b=e0oZcBw9vfI2c6jtDMiTdg7bGDwhGnumjIQ2GlmaTDbdYOJTrUkqrYALnuQYeTkJRtdZ
	 8r7Z8DJBfQ+FGgLt1/HjglDZ1xUlnW9AHgCmANCSe7XrZqjGlWLPOpC9B+LeQ8cjvcTI4
	 daRLyhbtv8YSmCHZ1DiBGXSO6RBslKRcQA6SoaJjd4w2eHtWPfPaqMQ/IWSmnH8O7EkuM
	 O0uhn1fys5MkpE6px0q/C4EC2VVmjmW55tDn6f0S6/C1L3paG6flKRg1+UeCPB7PFpY+U
	 tcDde+HoSbcVhoac2KajCUxywx5hHu/Qoe8KnYRbj/swcPKM3pzasG6NX9HygViigDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046714;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=boxA4Xp56DBTlM2mu+CyEzhGofbLaddj8kymQNUs1ek=;
	b=sflLBuVR+J2T2/5AIVvj7Hd4RQLOOJBdLmDg1dPhr07azTnBBJTKag8xahuPshZ7U+bi
	 u+vuRDIXlpivua9UNDi0uLFoa3pa3Wl7o5cbxIzu/Uk9UiVhYAkwQmr9V8w19FaXyi2M8
	 cWr6yjs4bwy6MkJgo+vocX8JpRQCcrJYJQa3ISeBPBouzMdUqA0e/N1Le0WDj2jEXvKK/
	 IugNe+JdwPq0lZwpQbxdVLBjxWYcYtrR8hPJglj+1MvRop9cCzNKpM1uYadvk/gUECQKz
	 mwgpGAvLAhBqAu+cgG4LKf9gKyJvf56MmSIVpU/DlNCbuRNhYIXWzmAhS35RC4N/g7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CDnMBRfV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A5C606A31C;
	Thu, 19 Nov 2026 00:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CDnMBRfV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869B11F000C5;
	Thu, 19 Nov 2026 00:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046714;
	bh=boxA4Xp56DBTlM2mu+CyEzhGofbLaddj8kymQNUs1ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CDnMBRfVddUQn+HmnDekUiPBpT+dV4t6bqiW9LtXZ1Q86mjlWTATv2Brn1i3GraRK
	 vVAAqftnZURbssFGWrKcx3CVzkBbPVwaLH5G/yI0QVKNjBPcsc+QyMimMWc3uqlKp3
	 Lwql6/1LftpkhyPhga130Gk417rJuqIIymRndJLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1339/2857] crypto: algif_skcipher - rewind rounded output bytes
Date: Wed, 18 Nov 2026 15:39:33 +0100
Message-ID: <20261118150249.637534574@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit 2f90facc7b94934653eb7ebfadcc25d503b89196 ]

af_alg_get_rsgl() advances the receive iterator by the unrounded RX
scatterlist length.  For a continuing skcipher request,
_skcipher_recvmsg() then rounds its local length down to a whole chunksize
without restoring the iterator.

A later chunk starts after bytes which the provider never wrote, while the
syscall returns only the processed length.  When copy_splice_read()
supplies non-zeroed pages and publishes that return as a dense prefix, the
gap exposes stale bytes from a previous page lifetime.

With unprivileged xts(aes), a 31-byte MSG_MORE request followed by one
final byte advances a 47-byte destination while returning 32 bytes.  A
hardened v7.2-rc5 image retained all 15 seeded stale bytes in 4,829 of
4,829 records.  With init_on_alloc enabled, all 72,345 gap bytes observed
were zero.

Rewind the iterator by the tail excluded during rounding, before rejecting
a zero processed length.  The crypto request uses only the rounded length;
af_alg_free_resources() releases the entire RX list before another receive
iteration.

The fixed target-like kernel returned byte-identical dense 48-byte output
in 4,771 of 4,771 rounds.  The unmodified kernel returned the vulnerable
32-byte short record in 2,409 of 2,409 rounds.

Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ sashal: Adjusted context to account for the missing CRYPTO_SKCIPHER_REQ_NOTFINAL assignment. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/algif_skcipher.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 0fe62be7470f2..c037c3969e9d6 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -83,12 +83,15 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	 * full block size buffers.
 	 */
 	if (ctx->more || len < ctx->used) {
-		if (len < bs) {
+		size_t excess = len % bs;
+
+		len -= excess;
+		iov_iter_revert(&msg->msg_iter, excess);
+
+		if (!len) {
 			err = -EINVAL;
 			goto free;
 		}
-
-		len -= len % bs;
 	}
 
 	/*
-- 
2.53.0



