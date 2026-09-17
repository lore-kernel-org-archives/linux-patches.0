Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66603DD86A;
	Thu, 17 Sep 2026 18:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671014; cv=none; b=RmEGsnuzJ2FZCqlugykojbW7MtgTiSsc4V+WPsqEGNuN08S1GT0Xq30GO9+P/63MhFCkiNCUgs1FA+o1/IY574Ho5MziIn73ZLOGwXmn8+SS9apOz+Actc0p5F2nUL+mpud8XpaxTe2pN8PYK96JnZOBuucEMjKOszLhzlmhnzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671014; c=relaxed/simple;
	bh=xrdHLUL6lE/JEVHqT76zgKgZMvmQe11OmMfz5pR7ugU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K8x5CrssewaSBbqdRG/DYZVB/9Ii7AttDwbpCE46V55jP8i0qS2cJhsTzhAVZNsUuiF/EAbCCGs8wMaGV0J93mDhxYyVUGaOb3p5BmPDsU7F9AIcHwxrgMywPjPMppBvrEdXqmXUmrtVqFqeBVLZ+1QNq8z90VIKWvTSSwsmua8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=keR8JeEx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="keR8JeEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C931F000FF;
	Thu, 17 Sep 2026 18:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671013;
	bh=J4XLJqVigRUEQB2xpAOBi62D079wtpYwRAJ69zx39hU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=keR8JeEx2FRAxwkkRry9TagmRPRlRYYWr9KmXjWKLeHgDE5R4FvG54cuiPDiqycYC
	 aGFf8DyZhRj4DR4joRWZZ0308gwyzE9JHKXFQ+RuLgMhNhlHuu4rLG+KUhKe/Tp6bm
	 wKfpB5uYN2kFPpuEpiA48UUJAXFSG1tHkxT5pSL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taehee Yoo <ap420073@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 0804/1102] crypto: x86/aria - add missing vzeroupper in AVX2 code
Date: Thu, 17 Sep 2026 16:12:27 +0100
Message-ID: <20260917151600.667309171@linuxfoundation.org>
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

commit ac53977611428db3bc0b4ac0225e19c3e08ae50b upstream.

Since the AVX2 optimized ARIA code uses YMM registers, execute
vzeroupper before returning from it.  This is needed to avoid degrading
the performance of any later SSE code that may happen to be executed.

Fixes: 37d8d3ae7a58 ("crypto: x86/aria - implement aria-avx2")
Cc: stable@vger.kernel.org
Cc: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/crypto/aria-aesni-avx2-asm_64.S |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/crypto/aria-aesni-avx2-asm_64.S
+++ b/arch/x86/crypto/aria-aesni-avx2-asm_64.S
@@ -988,6 +988,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_enc
 		     %ymm8, %ymm9, %ymm10, %ymm11, %ymm12, %ymm13, %ymm14,
 		     %ymm15, %rax);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_aesni_avx2_encrypt_32way)
@@ -1013,6 +1014,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_dec
 		     %ymm8, %ymm9, %ymm10, %ymm11, %ymm12, %ymm13, %ymm14,
 		     %ymm15, %rax);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_aesni_avx2_decrypt_32way)
@@ -1215,6 +1217,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_ctr
 		     %ymm8, %ymm9, %ymm10, %ymm11, %ymm12, %ymm13, %ymm14,
 		     %ymm15, %r10);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_aesni_avx2_ctr_crypt_32way)
@@ -1366,6 +1369,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_gfn
 		     %ymm8, %ymm9, %ymm10, %ymm11, %ymm12, %ymm13, %ymm14,
 		     %ymm15, %rax);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_aesni_avx2_gfni_encrypt_32way)
@@ -1391,6 +1395,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_gfn
 		     %ymm8, %ymm9, %ymm10, %ymm11, %ymm12, %ymm13, %ymm14,
 		     %ymm15, %rax);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_aesni_avx2_gfni_decrypt_32way)
@@ -1435,6 +1440,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_gfn
 		     %ymm8, %ymm9, %ymm10, %ymm11, %ymm12, %ymm13, %ymm14,
 		     %ymm15, %r10);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_aesni_avx2_gfni_ctr_crypt_32way)


