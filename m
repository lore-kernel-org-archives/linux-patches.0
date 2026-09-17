Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90A14F3EDA;
	Thu, 17 Sep 2026 17:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666205; cv=none; b=ZXcXKevdL/tehAmbDRB+ql+Z22/sV02FbbNjNDkymvOSa/8OoJ0Aja/IUzqAaoclOJkOxc+U7ryQ4+l+IULy3guoyjTKyuQPOlZ0GVh9x/YRG9DSnvmVPa66gvropjLVGJjLsEPice3UPEbuw4OJstZFIckubHlaaeLg1+gXf+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666205; c=relaxed/simple;
	bh=GdkBTSfXQw1g3LSDjOtshsQ61RsNNpRoPqNXpm+/hv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1eXqoHO29+WqTbWeIyD63XLf6fhycX3j6yJgJy5Y61MfvfE3l+YK/D23C8pamKnb0AFawsOY0e0+fZtlwZ+E9jzMoBCvoGSvmnp/vWgvA29T3s6EjbjJyHX7cY/x1JncWU6t5c2Q4ljYXdA/9i1wmI6upCGiWCdlxsXBGoQIcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fiAQjBYF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fiAQjBYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6101A1F000FF;
	Thu, 17 Sep 2026 17:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666203;
	bh=GGx7KOtuLTaBR+gJVbZpmqggBY29mU5jrVC5TW389aU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fiAQjBYFKFlKmBglvlB97x8rinlso2jU8JL47/Axn+pU0l2xcXaEhq0D1H4z19E8r
	 FiZ91M0qmtYOtXCvLdNcFbdO4aeJa5NCSN3NX+jGRIsHFzvfbk3/g18GqiTz9Y+6yM
	 BpSiDBbOuyIK26KuSFB38snRLpzlTAOrxd5Y9j08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taehee Yoo <ap420073@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 0959/1250] crypto: x86/aria - add missing vzeroupper in AVX-512 code
Date: Thu, 17 Sep 2026 16:12:34 +0100
Message-ID: <20260917151618.010584769@linuxfoundation.org>
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


