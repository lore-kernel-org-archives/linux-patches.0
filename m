Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B86D221DA4;
	Thu, 12 Dec 2024 17:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025748; cv=none; b=Q4QQQG0H3d32u7PYewWhA3YI5Zi+NaVUJCb16PqARseq3z8GOUxN/mDCQNKGYkFasVDxDBoYoFZr5Q3Vql0PTrczG48ZNLjmr6yVIW3ZSRCPXsEJ5q4UZ+hyI1QwWINmNSyQ+NXhsS2Za+oZ53Q+M6+jujlnyqGcpJ/cVFnE/zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025748; c=relaxed/simple;
	bh=T398Q6XmdGD4VamuqF2YDiuAWZdrrjgqCEIw+w/yopw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFAd3CjuXFRHSTtyjVb8Z44kKs4Dorcqf5aprT+0W+vXgtmhTJjA5gxsC7AZfJ0ZhXgqvDq6A6BAG5ckgCMUtDsoJmBE3ezj+RH+Rd+8rpXETE0oSAKPh5rQZWHuZEDhrREbabIE2Qu/xX7xHtPEW6YuBnZGWy6h4/At7Anq7Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5PRDxNf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5PRDxNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02999C4CED1;
	Thu, 12 Dec 2024 17:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025748;
	bh=T398Q6XmdGD4VamuqF2YDiuAWZdrrjgqCEIw+w/yopw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5PRDxNfodGGW/Dsh8INjsFrPBOEqqpXcoqDtkf97FG2sT2QmXvCP/BcLJVC0iMtn
	 eTUlMdqNkLnW/NEnWW23UI31lWskrH2DIu6aegDjS9YafaQql/LPCkFYuLdj9dBYL1
	 LVqjEYPJwPEYkwEX8Q42FjizB7xHKP8qkqZ0D/Ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Eric Biggers <ebiggers@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 244/321] crypto: x86/aegis128 - access 32-bit arguments as 32-bit
Date: Thu, 12 Dec 2024 16:02:42 +0100
Message-ID: <20241212144239.612367366@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 3b2f2d22fb424e9bebda4dbf6676cbfc7f9f62cd ]

Fix the AEGIS assembly code to access 'unsigned int' arguments as 32-bit
values instead of 64-bit, since the upper bits of the corresponding
64-bit registers are not guaranteed to be zero.

Note: there haven't been any reports of this bug actually causing
incorrect behavior.  Neither gcc nor clang guarantee zero-extension to
64 bits, but zero-extension is likely to happen in practice because most
instructions that operate on 32-bit registers zero-extend to 64 bits.

Fixes: 1d373d4e8e15 ("crypto: x86 - Add optimized AEGIS implementations")
Cc: stable@vger.kernel.org
Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/crypto/aegis128-aesni-asm.S | 29 ++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/x86/crypto/aegis128-aesni-asm.S b/arch/x86/crypto/aegis128-aesni-asm.S
index b7026fdef4ff2..6c5048605a664 100644
--- a/arch/x86/crypto/aegis128-aesni-asm.S
+++ b/arch/x86/crypto/aegis128-aesni-asm.S
@@ -20,7 +20,7 @@
 #define T1	%xmm7
 
 #define STATEP	%rdi
-#define LEN	%rsi
+#define LEN	%esi
 #define SRC	%rdx
 #define DST	%rcx
 
@@ -75,32 +75,32 @@ SYM_FUNC_START_LOCAL(__load_partial)
 	xor %r9d, %r9d
 	pxor MSG, MSG
 
-	mov LEN, %r8
+	mov LEN, %r8d
 	and $0x1, %r8
 	jz .Lld_partial_1
 
-	mov LEN, %r8
+	mov LEN, %r8d
 	and $0x1E, %r8
 	add SRC, %r8
 	mov (%r8), %r9b
 
 .Lld_partial_1:
-	mov LEN, %r8
+	mov LEN, %r8d
 	and $0x2, %r8
 	jz .Lld_partial_2
 
-	mov LEN, %r8
+	mov LEN, %r8d
 	and $0x1C, %r8
 	add SRC, %r8
 	shl $0x10, %r9
 	mov (%r8), %r9w
 
 .Lld_partial_2:
-	mov LEN, %r8
+	mov LEN, %r8d
 	and $0x4, %r8
 	jz .Lld_partial_4
 
-	mov LEN, %r8
+	mov LEN, %r8d
 	and $0x18, %r8
 	add SRC, %r8
 	shl $32, %r9
@@ -110,11 +110,11 @@ SYM_FUNC_START_LOCAL(__load_partial)
 .Lld_partial_4:
 	movq %r9, MSG
 
-	mov LEN, %r8
+	mov LEN, %r8d
 	and $0x8, %r8
 	jz .Lld_partial_8
 
-	mov LEN, %r8
+	mov LEN, %r8d
 	and $0x10, %r8
 	add SRC, %r8
 	pslldq $8, MSG
@@ -138,7 +138,7 @@ SYM_FUNC_END(__load_partial)
  *   %r10
  */
 SYM_FUNC_START_LOCAL(__store_partial)
-	mov LEN, %r8
+	mov LEN, %r8d
 	mov DST, %r9
 
 	movq T0, %r10
@@ -676,7 +676,7 @@ ENTRY(crypto_aegis128_aesni_dec_tail)
 	call __store_partial
 
 	/* mask with byte count: */
-	movq LEN, T0
+	movd LEN, T0
 	punpcklbw T0, T0
 	punpcklbw T0, T0
 	punpcklbw T0, T0
@@ -701,7 +701,8 @@ ENDPROC(crypto_aegis128_aesni_dec_tail)
 
 /*
  * void crypto_aegis128_aesni_final(void *state, void *tag_xor,
- *                                  u64 assoclen, u64 cryptlen);
+ *                                  unsigned int assoclen,
+ *                                  unsigned int cryptlen);
  */
 ENTRY(crypto_aegis128_aesni_final)
 	FRAME_BEGIN
@@ -714,8 +715,8 @@ ENTRY(crypto_aegis128_aesni_final)
 	movdqu 0x40(STATEP), STATE4
 
 	/* prepare length block: */
-	movq %rdx, MSG
-	movq %rcx, T0
+	movd %edx, MSG
+	movd %ecx, T0
 	pslldq $8, T0
 	pxor T0, MSG
 	psllq $3, MSG /* multiply by 8 (to get bit count) */
-- 
2.43.0



