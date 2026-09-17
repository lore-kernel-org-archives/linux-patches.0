Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A185533CEA8;
	Thu, 17 Sep 2026 18:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671017; cv=none; b=WGVO+X//w2y9UIXcM65IroBjyiocqYJMY6oBtviTf52RySpLfMEUTPMOJ9ijckHgVBZYiJEtxuxAwfcH+jj4wFHWddM8ZeCogcqIlyXIEeVJN3hEt2rTtV4sBf8G4+XL+QSzGx+TN0k9KSvvpZ8MiPAYvKHAP1dhr/O+hWKxOdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671017; c=relaxed/simple;
	bh=UmhhAD+OF6I/YbUaXkSj1nJvk6r+Ut/GlYOzh4lTNsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1h+yoJ0s3ymFiBzZN0N8SqbZJBuRWimMyJ2cRv7OQlrvqYGkf7FUcvJdRGxdtjErobZIhXys565viBIM+OFyt/X5tA8pdZRbUORR3AKcY50mcHyTf4K9JAwX5njjkzhpiQPqZQudCeIJmoic7j4nimNk6yEDpR9/8AVRRqi+II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zW9fFPrT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zW9fFPrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033711F000FF;
	Thu, 17 Sep 2026 18:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671016;
	bh=k86LdqZJcm8soWfI4x/+UO2GI0Yqqi/fU8ZR7GYTEOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zW9fFPrTeJ9kkHD7hlCHPZZBF+yvyb8oFWGd/imhSEO/f7RJdtirwernXfqzuZUfN
	 W19uK4K3RKYMZvYaCy7p+M1JuTvaqWYivm2u4liglWeQ9+HBVrc06Npfpf9lldcAHp
	 PAx3ATD2F6V8w6jUumKhFM5w6iDXi4n57ohf4LtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taehee Yoo <ap420073@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 0805/1102] crypto: x86/aria - add missing vzeroupper in AVX-512 code
Date: Thu, 17 Sep 2026 16:12:28 +0100
Message-ID: <20260917151600.697008339@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 60892a384aa1e65d0e703e1c513417bdf0c80777 upstream.

Since the AVX-512 optimized ARIA code uses ZMM registers, execute
vzeroupper before returning from it.  This is needed to avoid degrading
the performance of any later SSE code that may happen to be executed.

Fixes: c970d42001f2 ("crypto: x86/aria - implement aria-avx512")
Cc: stable@vger.kernel.org
Cc: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/crypto/aria-gfni-avx512-asm_64.S |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/crypto/aria-gfni-avx512-asm_64.S
+++ b/arch/x86/crypto/aria-gfni-avx512-asm_64.S
@@ -800,6 +800,7 @@ SYM_TYPED_FUNC_START(aria_gfni_avx512_en
 		     %zmm9, %zmm8, %zmm11, %zmm10, %zmm12, %zmm13, %zmm14,
 		     %zmm15, %rax);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_gfni_avx512_encrypt_64way)
@@ -825,6 +826,7 @@ SYM_TYPED_FUNC_START(aria_gfni_avx512_de
 		     %zmm9, %zmm8, %zmm11, %zmm10, %zmm12, %zmm13, %zmm14,
 		     %zmm15, %rax);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_gfni_avx512_decrypt_64way)
@@ -966,6 +968,7 @@ SYM_TYPED_FUNC_START(aria_gfni_avx512_ct
 		     %zmm9, %zmm8, %zmm11, %zmm10, %zmm12, %zmm13, %zmm14,
 		     %zmm15, %r10);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_gfni_avx512_ctr_crypt_64way)


