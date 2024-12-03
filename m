Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13AA51F8935;
	Tue,  3 Dec 2024 16:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242211; cv=none; b=EBflcyTJq8Rw5VN2Lckj0P9DHP7ZItFYa4cJ5np4v3X6V5Ia5bypgnPqiyx/L7J8e34GtlwX0FpbKvX5JlpDkDcatgA1x7yDF5UZblk8K4maC8MJ/8AhlWjAT0D/rBYRZ0pkxDoGR6Grb5BgdLBxep0zjBIfCu5c4PltNS4ZL1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242211; c=relaxed/simple;
	bh=gUWkV9p4y8Mv7SSeSmze5sw1IZWpR4j9+QJTDzp1YVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUaUMgClLhJ+XN3JhvNPZKHKOpBqBCk69uIJBz9ZDMK94GHtAIhjMgSu31yXlGD5SSxbFuvvAelDWz0QUAo66O/thziRVhlDJWLoowKtWE1egBvR4KaPVo2sf8vmR1ypnAB+kXrN509Sykh0Z2YiyoEERnZebaxdWIUbPOILdEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=elBsGo7M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="elBsGo7M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7633AC4CECF;
	Tue,  3 Dec 2024 16:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242210;
	bh=gUWkV9p4y8Mv7SSeSmze5sw1IZWpR4j9+QJTDzp1YVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=elBsGo7MwkgvXoZBFBLQbPoFn1z78uGlyAXBLPXw1xHRIUUwYb7/UPQ0tTCI8dnvV
	 Pj2I1qqhKxI80pTxvTeNa5A+FkYuIUkN+ApCUOpWw7zmgmEV7jq/jBwhzhd7zTc344
	 Mfx0ZQP09qmY9ALxyxoiHoGlxkHA7d0M3uSqiC34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Eric Biggers <ebiggers@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 639/826] crypto: x86/aegis128 - access 32-bit arguments as 32-bit
Date: Tue,  3 Dec 2024 15:46:06 +0100
Message-ID: <20241203144808.676486745@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

commit 3b2f2d22fb424e9bebda4dbf6676cbfc7f9f62cd upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/crypto/aegis128-aesni-asm.S |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

--- a/arch/x86/crypto/aegis128-aesni-asm.S
+++ b/arch/x86/crypto/aegis128-aesni-asm.S
@@ -21,7 +21,7 @@
 #define T1	%xmm7
 
 #define STATEP	%rdi
-#define LEN	%rsi
+#define LEN	%esi
 #define SRC	%rdx
 #define DST	%rcx
 
@@ -76,32 +76,32 @@ SYM_FUNC_START_LOCAL(__load_partial)
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
@@ -111,11 +111,11 @@ SYM_FUNC_START_LOCAL(__load_partial)
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
@@ -139,7 +139,7 @@ SYM_FUNC_END(__load_partial)
  *   %r10
  */
 SYM_FUNC_START_LOCAL(__store_partial)
-	mov LEN, %r8
+	mov LEN, %r8d
 	mov DST, %r9
 
 	movq T0, %r10
@@ -677,7 +677,7 @@ SYM_TYPED_FUNC_START(crypto_aegis128_aes
 	call __store_partial
 
 	/* mask with byte count: */
-	movq LEN, T0
+	movd LEN, T0
 	punpcklbw T0, T0
 	punpcklbw T0, T0
 	punpcklbw T0, T0
@@ -702,7 +702,8 @@ SYM_FUNC_END(crypto_aegis128_aesni_dec_t
 
 /*
  * void crypto_aegis128_aesni_final(void *state, void *tag_xor,
- *                                  u64 assoclen, u64 cryptlen);
+ *                                  unsigned int assoclen,
+ *                                  unsigned int cryptlen);
  */
 SYM_FUNC_START(crypto_aegis128_aesni_final)
 	FRAME_BEGIN
@@ -715,8 +716,8 @@ SYM_FUNC_START(crypto_aegis128_aesni_fin
 	movdqu 0x40(STATEP), STATE4
 
 	/* prepare length block: */
-	movq %rdx, MSG
-	movq %rcx, T0
+	movd %edx, MSG
+	movd %ecx, T0
 	pslldq $8, T0
 	pxor T0, MSG
 	psllq $3, MSG /* multiply by 8 (to get bit count) */


