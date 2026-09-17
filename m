Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDB04EFFAA;
	Thu, 17 Sep 2026 15:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660149; cv=none; b=fKkyqV1disJh2gfbMGkU4jHxUZZYqYqA0tgoqwkzinvqYROMgzD1RAuH/qFrN9p735HiLd7sq7d3qL03Vff4/iNakDduXh/iA18pSKYtinrQ4i9W7zK04Bul7XAwlrvD4PcbO+pYQCeO4mp4/CXbLKs53GQIBucLszLimZQZHfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660149; c=relaxed/simple;
	bh=/D2qBi+0aiEpx2PjEFmiTWCQfys752gMQd3lVFidhYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B6XK9BTwMagS1vV7DYQRWw4kGUB3+mUgPUS9Hi8z4HGku9qtUPLpJ/DjSUwgIO7WKeYBBk5s7fx5ctwhiyadWnQJv5wKRM54HQ63HyuT8jJ+gkeBjmyie97tiTJ0aqswI+PmtgsZ6rjZxyRO4g2YqWFVTeHU+sRv4xyHUYs4o8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ik9Rlig1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ik9Rlig1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8484C1F00893;
	Thu, 17 Sep 2026 15:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660145;
	bh=Sc8C3nvhGDOAec7G4jPPhcsWACQoqS98XdxnN+xjQp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ik9Rlig1vKDrTKJHlMVQ1VrftnzrUixxNaKJGQegoCDHNH0fo8uLXAFhSbHncTjQ0
	 Y24wqs897ub0UcMeqBXuuXaBzb/E3uO8IPgfOhj4xnZI/WBmULQgsVssepJAFULV2g
	 5YZ5alrjPmRZZ8eYO391rZisMDrWxl9n3lJW3Uwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taehee Yoo <ap420073@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.2 456/733] crypto: x86/aria - add missing vzeroupper in AVX2 code
Date: Thu, 17 Sep 2026 16:12:44 +0100
Message-ID: <20260917151403.285104108@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -982,6 +982,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_enc
 		     %ymm8, %ymm9, %ymm10, %ymm11, %ymm12, %ymm13, %ymm14,
 		     %ymm15, %rax);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_aesni_avx2_encrypt_32way)
@@ -1007,6 +1008,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_dec
 		     %ymm8, %ymm9, %ymm10, %ymm11, %ymm12, %ymm13, %ymm14,
 		     %ymm15, %rax);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_aesni_avx2_decrypt_32way)
@@ -1209,6 +1211,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_ctr
 		     %ymm8, %ymm9, %ymm10, %ymm11, %ymm12, %ymm13, %ymm14,
 		     %ymm15, %r10);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_aesni_avx2_ctr_crypt_32way)
@@ -1359,6 +1362,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_gfn
 		     %ymm8, %ymm9, %ymm10, %ymm11, %ymm12, %ymm13, %ymm14,
 		     %ymm15, %rax);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_aesni_avx2_gfni_encrypt_32way)
@@ -1384,6 +1388,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_gfn
 		     %ymm8, %ymm9, %ymm10, %ymm11, %ymm12, %ymm13, %ymm14,
 		     %ymm15, %rax);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_aesni_avx2_gfni_decrypt_32way)
@@ -1428,6 +1433,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_gfn
 		     %ymm8, %ymm9, %ymm10, %ymm11, %ymm12, %ymm13, %ymm14,
 		     %ymm15, %r10);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_aesni_avx2_gfni_ctr_crypt_32way)


