Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6A43C76AD;
	Wed, 30 Sep 2026 19:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795547; cv=none; b=m8sbbAU45AHYwSg9pdMoThGIjLiV2i/Tuf9+R4bDM1+hWsDMcZtu1uGwGgGHEbCXMduiZSmw7O8HfIGRmKiGyDyuF7YlC+72okFYU92myW4noiGtjZ1RuiuW4Di5ZU+NrRtA6PTLcnvCzdtcPp4goH3A+rFnta1b02CGGbthFpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795547; c=relaxed/simple;
	bh=K++fiwKxYontlbX5a1cY9K1QUmnb3ZK6wsk2siKjYPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7zhMueoOmpbuqKxzvHwj0Q9jYEsSZlAGedMzJREO2OYUaaWugPa/SHq7/uOgF3MdJxnKFq1XjZcvBjN8dk3leVJgbjle2j536lkN+7/wd+Ck8qDkBOxD2lucOlIlmCF3jbpZuG8h4rFSeQ37eoU6XHhXWdURMK6GvtjU6Ctois=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ywFDi37l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ywFDi37l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A735C1F000FF;
	Wed, 30 Sep 2026 19:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795546;
	bh=ZtYmdumBHocyxDb8Ah7uCsOFuIKV6l981zC3eLmXaxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ywFDi37lvmaCXqKmDRnrzmEBWYVnftmtiFyJ0h0c2JWeca/vU4ZyaGVlPDCpj0F6X
	 /JaOumWGzynKMYI/DmtY7CnpwQP3MpshXZdXaV4msdhSlWPpNofL4Vg+KJR+AG3NV+
	 LcbJZ1Z/QTvIiQ5kbExJKftPfP3UJ3qsCPCtSvpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taehee Yoo <ap420073@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 0598/1193] crypto: x86/aria - add missing vzeroupper in AVX2 code
Date: Wed, 30 Sep 2026 17:21:22 +0200
Message-ID: <20260930152447.527782364@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


