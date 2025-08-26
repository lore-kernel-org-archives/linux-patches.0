Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60035350D78;
	Tue, 26 Aug 2025 13:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216585; cv=none; b=VqV9LJ9Vl9EciZn7g0uWlyLF6QTHrksg6WyEYscmhIqK5USKeCkNTQpOmVdI1Xe8NhZsyDLoq/Gp5DxsCw0hqcb0aAVdEVPULBoZ3kgxOjxacOkvdQ9irhn+XYJefkvWUcWzZC9Giia22UnfWQ1GTBcEpnumZNf9i7DRRo0TOsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216585; c=relaxed/simple;
	bh=wSnbrnv26xUJHddkrNDbfaO/lMJaz/zszDXCRdBN7ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTNRlZesQ5MnjaXfabJS8M75iZadqQpAVIdRigfhRDnRzbX8xKA+Rx4jYEF7mT0K6/9riIPqH7p0G38CPZ6hiB2km+wTOoF6fKnrNVvuNA3YZhq9rryQJjdHbaWmpxt4PK8PtbDyf96vzMdutEOY9+E09c8F1g4g6A+3AqHWqpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y4VHZp28; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y4VHZp28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA968C4CEF1;
	Tue, 26 Aug 2025 13:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216585;
	bh=wSnbrnv26xUJHddkrNDbfaO/lMJaz/zszDXCRdBN7ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y4VHZp28AiBcECya71WzApSwjoIP7li7xR+RrMqHLYJapvHBX/pSFIKLi41cK03RI
	 wADR7VQYviKeHrSNcl/mdo3v2+pJ5ZU3+6rWXu98JXYrLU8os72pXFl50umPv68iX+
	 iufSGtXnctiDNBvOlXkGAfIWXS/urkrc1mjEfcyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.15 465/644] lib/crypto: mips/chacha: Fix clang build and remove unneeded byteswap
Date: Tue, 26 Aug 2025 13:09:16 +0200
Message-ID: <20250826110958.003403010@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 22375adaa0d9fbba9646c8e2b099c6e87c97bfae upstream.

The MIPS32r2 ChaCha code has never been buildable with the clang
assembler.  First, clang doesn't support the 'rotl' pseudo-instruction:

    error: unknown instruction, did you mean: rol, rotr?

Second, clang requires that both operands of the 'wsbh' instruction be
explicitly given:

    error: too few operands for instruction

To fix this, align the code with the real instruction set by (1) using
the real instruction 'rotr' instead of the nonstandard pseudo-
instruction 'rotl', and (2) explicitly giving both operands to 'wsbh'.

To make removing the use of 'rotl' a bit easier, also remove the
unnecessary special-casing for big endian CPUs at
.Lchacha_mips_xor_bytes.  The tail handling is actually
endian-independent since it processes one byte at a time.  On big endian
CPUs the old code byte-swapped SAVED_X, then iterated through it in
reverse order.  But the byteswap and reverse iteration canceled out.

Tested with chacha20poly1305-selftest in QEMU using "-M malta" with both
little endian and big endian mips32r2 kernels.

Fixes: 49aa7c00eddf ("crypto: mips/chacha - import 32r2 ChaCha code from Zinc")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505080409.EujEBwA0-lkp@intel.com/
Link: https://lore.kernel.org/r/20250619225535.679301-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/crypto/chacha-core.S |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

--- a/arch/mips/crypto/chacha-core.S
+++ b/arch/mips/crypto/chacha-core.S
@@ -55,17 +55,13 @@
 #if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
 #define MSB 0
 #define LSB 3
-#define ROTx rotl
-#define ROTR(n) rotr n, 24
 #define	CPU_TO_LE32(n) \
-	wsbh	n; \
+	wsbh	n, n; \
 	rotr	n, 16;
 #else
 #define MSB 3
 #define LSB 0
-#define ROTx rotr
 #define CPU_TO_LE32(n)
-#define ROTR(n)
 #endif
 
 #define FOR_EACH_WORD(x) \
@@ -192,10 +188,10 @@ CONCAT3(.Lchacha_mips_xor_aligned_, PLUS
 	xor	X(W), X(B); \
 	xor	X(Y), X(C); \
 	xor	X(Z), X(D); \
-	rotl	X(V), S;    \
-	rotl	X(W), S;    \
-	rotl	X(Y), S;    \
-	rotl	X(Z), S;
+	rotr	X(V), 32 - S; \
+	rotr	X(W), 32 - S; \
+	rotr	X(Y), 32 - S; \
+	rotr	X(Z), 32 - S;
 
 .text
 .set	reorder
@@ -372,21 +368,19 @@ chacha_crypt_arch:
 	/* First byte */
 	lbu	T1, 0(IN)
 	addiu	$at, BYTES, 1
-	CPU_TO_LE32(SAVED_X)
-	ROTR(SAVED_X)
 	xor	T1, SAVED_X
 	sb	T1, 0(OUT)
 	beqz	$at, .Lchacha_mips_xor_done
 	/* Second byte */
 	lbu	T1, 1(IN)
 	addiu	$at, BYTES, 2
-	ROTx	SAVED_X, 8
+	rotr	SAVED_X, 8
 	xor	T1, SAVED_X
 	sb	T1, 1(OUT)
 	beqz	$at, .Lchacha_mips_xor_done
 	/* Third byte */
 	lbu	T1, 2(IN)
-	ROTx	SAVED_X, 8
+	rotr	SAVED_X, 8
 	xor	T1, SAVED_X
 	sb	T1, 2(OUT)
 	b	.Lchacha_mips_xor_done


