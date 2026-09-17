Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57CE4F96CB;
	Thu, 17 Sep 2026 17:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666202; cv=none; b=YsOn0vty38m+dzgZ87GkzSgAUiD/zLS9pE3Ro57K+wn5JvnFalfBdum/J1DPCLakDutBYBns4iSRlhEievjmQeZYR3Gc7hWK88afS7iPz1IR2oLRUC5ltbji4jw30qAhqNZqFU+o5cbV1TGUG96OiDPT2Dl5bM61UsFdghW4pX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666202; c=relaxed/simple;
	bh=qzIoJPiV1wzIfUuqMK88/zDEXVT/olZxL9UhOW5dG9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXxHG4M2N4HHufZGBs/ED94EFdTtmZBPiv/jAAl2TWdHNw+yV9ts3H7CqWOwTtEELYfeRiQmQ/bezCkXb4l/8U/ElH9+2BPjrzNZ+5IEpaEwysCP3dBHBPMctHpQORsKhGnXt4PjifjDhlGS75ICo8gpazoiDBtT1mljOg8KbK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvcXme9r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvcXme9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283881F000FF;
	Thu, 17 Sep 2026 17:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666200;
	bh=rxEKXQDXly+cAt/6V+OCWeukoT/v+hnPPJiWAiTVwnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jvcXme9rnQvMAuo4GK+DwJl39q0hD0r+VzGIwSuF4jhUjmKyvwo2ReVoWUb98Estv
	 GzdXluHBhuhDUZixNMP0gpXPXrHsKfFKQGXbAcaNRNXcI4vdrxB8fVRQ/ADg8OskHJ
	 IpC/3PNpZw51Upog/4x1pzmktGqYnMmg4VPx+H0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taehee Yoo <ap420073@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 0958/1250] crypto: x86/aria - add missing vzeroupper in AVX2 code
Date: Thu, 17 Sep 2026 16:12:33 +0100
Message-ID: <20260917151617.985341544@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


