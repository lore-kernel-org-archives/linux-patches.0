Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029461;
	b=IWZzKRUM+wkEr1dWW9EppqCkRmxuvfjIsAOBanv69KLV0mg7u0ENN0A+7jyXpD8MzS+l
	 l6nulXCimmqreYjXFnc+bgf5l/u2Qw33UwIavIfWRjw84rsLtNyQscZnF4BieuGZeqKOc
	 DUaoo6oc3mHdG5WG2afAnPCFnirHLa0YstvNYrZJ5xrpk0BD6P3OWnShiHdHQDhHaZJpO
	 95VH0NWhWaw06Fvsp8GVSdqJ7vja1LAbJ4WSIYjv+ehjvlWDkclTPxZjidmS8eLzb7aYy
	 zvZ/9n0qfIDwWcDO0VuB3CGa3wLBZW1LxuSw6j1dpd6nUC6xfdmOi45ENaDIpimN3XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029461;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vOH12lzWt9roK93uiJFzTvra2DLWJ0sXMdgbUZi0ur0=;
	b=bsDCReKABgnvDbVevjEwr3VQioFOVMdayRONzg+svV6u9qiywtAQy7UENUVpjrW1WgUR
	 bmaWzHquqHt2vJbvYxYVLiEkyHZoAF342baMOZx82XR+kGOaeg/TZWZ6MSmhg+W3u/F57
	 /AuxTpLCEhp433X24vyI/DRXDt3RmMAq9gzY4bWFfqas/dXp4njKUPeklJz+xWQQTjNUn
	 W8WLAp6j7v8rgyaKCjfh9D93uRUqC35/952WvOX5j3k1jqwtTUx01Ph7phg4IqufCa2UU
	 U03ZQ7Vy04BuWXdq8J0fKtOQZxicKQqelc+GMmoKrTeY63QqqQZZHBEBJoEBKkRoofQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dIz99n0m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30700606A32C;
	Wed, 18 Nov 2026 19:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dIz99n0m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA2E1F000C4;
	Wed, 18 Nov 2026 19:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029461;
	bh=vOH12lzWt9roK93uiJFzTvra2DLWJ0sXMdgbUZi0ur0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dIz99n0m5Vv992leLgfynjnBVyxp0xir1k8DYnN0DLs0+wOCPZVlVbE6YjSDkkQ8V
	 pYwhwxNMf1e9HAwOFROXhvxLXuF1AW/Y+whQsKw0DCgCh6jUmUiZnYaB5tJChCC62D
	 mVmLKHYtS0yqmMGj7W6DDPTsA8csLt+gTDsDpliA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0357/1756] crypto: lskcipher - preserve state across unaligned chunks
Date: Wed, 18 Nov 2026 15:41:24 +0100
Message-ID: <20261118150022.551888720@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit ba871255f796d1f599ba710f03e1803d1b374a75 ]

crypto_lskcipher_crypt_unaligned() splits a request into page-sized
chunks but never sets CRYPTO_LSKCIPHER_FLAG_CONT, so a stateful algorithm
restarts from its keyed state at every page boundary. It also marks every
chunk CRYPTO_LSKCIPHER_FLAG_FINAL, which is wrong but harmless: chunks are
trimmed to a multiple of the chunk size, so the trailing partial block that
FINAL guards against is caught after the loop instead.

ARC4 is the only lskcipher with internal state, and cbc, the other
in-tree user of the direct API, never passes more than one block, so
this went unnoticed. bpf_crypto_crypt() however hands
__bpf_dynptr_data() to crypto_lskcipher_encrypt() unchecked, leaving
both alignment and length to the BPF program. An 8192-byte ARC4 request
offset by one byte comes back with its second page identical to its
first: the keystream is reused.

Set FINAL only on the last chunk and CONT after the first, mirroring the
progression used by crypto_lskcipher_crypt_sg().

Fixes: 0ae4dcc1ebf6 ("crypto: skcipher - Add internal state support")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/lskcipher.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
index b4537be3b2a8c..652416e23eaf1 100644
--- a/crypto/lskcipher.c
+++ b/crypto/lskcipher.c
@@ -75,6 +75,7 @@ static int crypto_lskcipher_crypt_unaligned(
 	unsigned ivsize = crypto_lskcipher_ivsize(tfm);
 	unsigned bs = crypto_lskcipher_blocksize(tfm);
 	unsigned cs = crypto_lskcipher_chunksize(tfm);
+	u32 flags = 0;
 	int err;
 	u8 *tiv;
 	u8 *p;
@@ -98,13 +99,16 @@ static int crypto_lskcipher_crypt_unaligned(
 
 		if (chunk > cs)
 			chunk &= ~(cs - 1);
+		if (chunk == len)
+			flags |= CRYPTO_LSKCIPHER_FLAG_FINAL;
 
 		memcpy(p, src, chunk);
-		err = crypt(tfm, p, p, chunk, tiv, CRYPTO_LSKCIPHER_FLAG_FINAL);
+		err = crypt(tfm, p, p, chunk, tiv, flags);
 		if (err)
 			goto out;
 
 		memcpy(dst, p, chunk);
+		flags |= CRYPTO_LSKCIPHER_FLAG_CONT;
 		src += chunk;
 		dst += chunk;
 		len -= chunk;
-- 
2.53.0



