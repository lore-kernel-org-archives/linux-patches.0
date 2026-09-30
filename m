Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3813C76AD;
	Wed, 30 Sep 2026 19:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795550; cv=none; b=RiB4+S4fC2Us2f81CpKncZffRwImzb1RPcmjoN7hJZbKUTifigiQIDXZf2Fx8i/z+gByE7rxwlHCsXvGtfMoLYsTdpsdov+kxYQY1Ae4n8YpYMJ7DtoqYdpgnnuwDrn5j56fdM+F+4fadB4kVS3Iw19nw7BQeQXu2i30L6oWW5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795550; c=relaxed/simple;
	bh=y9YMJDbBV+gjdMigJeRhIbOtAONMg4igE4K6Y5g7r9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8Jv4kb4BJsPNGiwmkVbnYc7BZRtT3kXhBnLOUkSaHGaJ95xPecxjYq+cuvBsAbPootzQTgepcrwQVsp1HZOtxkqZLkAO953as7n9/hLtwfMs7A7p1skTXmU6P15AxFGPUwsk6zmIjn+ewLgQAODDpwFxfbsD85kG3pKc5YVp1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f9hxgpdf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9hxgpdf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8319B1F000FF;
	Wed, 30 Sep 2026 19:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795549;
	bh=keZ2t0CnwqhsZdTD9QtEQobLKRgG233SvhocWBu4bXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f9hxgpdfvy3eHtOqjDIY1CUCCq64O2pFvPTjSnMC4bNrTdNAW6zZL6dN4uZQFgKk9
	 O076j6CvDHf6Rn6jXXf7CfNHQgKkuIo0r2+fKvXRgn1N6p6HdW3WBLtH2vSZspue39
	 MP+TLUmRg8BEthgbXjAdfxFplZ4JwwPianwhYrDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taehee Yoo <ap420073@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 0599/1193] crypto: x86/aria - add missing vzeroupper in AVX-512 code
Date: Wed, 30 Sep 2026 17:21:23 +0200
Message-ID: <20260930152447.549441775@linuxfoundation.org>
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


