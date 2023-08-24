Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6599514A81
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 17:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE812C433C8;
	Thu, 24 Aug 2023 17:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692897621;
	bh=zbsiTRERABHo9KsSdGdW5d61R1/CS1BqFTB9FWv/KoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xEWeKAIl3HPmD/Mg/da0hyzt69KerDgQGyqqLMNeXMt2NftCfPYUA0JAPfnaeYaP8
	 y1IOiepORtO/TR+iT7YS9NGRh/JPVfNyfqAJvG+QAr4/4barAg0+VlQ/phOTXlChN8
	 /VdkHmuu/N/UkKgP0177HJNCHGaa/IM+Oz3NOcXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akira Tsukamoto <akira.tsukamoto@gmail.com>,
	Palmer Dabbelt <palmerdabbelt@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/135] riscv: __asm_copy_to-from_user: Optimize unaligned memory access and pipeline stall
Date: Thu, 24 Aug 2023 19:09:37 +0200
Message-ID: <20230824170621.810124858@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>
References: <20230824170617.074557800@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akira Tsukamoto <akira.tsukamoto@gmail.com>

[ Upstream commit ca6eaaa210deec0e41cbfc380bf89cf079203569 ]

This patch will reduce cpu usage dramatically in kernel space especially
for application which use sys-call with large buffer size, such as
network applications. The main reason behind this is that every
unaligned memory access will raise exceptions and switch between s-mode
and m-mode causing large overhead.

First copy in bytes until reaches the first word aligned boundary in
destination memory address. This is the preparation before the bulk
aligned word copy.

The destination address is aligned now, but oftentimes the source
address is not in an aligned boundary. To reduce the unaligned memory
access, it reads the data from source in aligned boundaries, which will
cause the data to have an offset, and then combines the data in the next
iteration by fixing offset with shifting before writing to destination.
The majority of the improving copy speed comes from this shift copy.

In the lucky situation that the both source and destination address are
on the aligned boundary, perform load and store with register size to
copy the data. Without the unrolling, it will reduce the speed since the
next store instruction for the same register using from the load will
stall the pipeline.

At last, copying the remainder in one byte at a time.

Signed-off-by: Akira Tsukamoto <akira.tsukamoto@gmail.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Stable-dep-of: 4b05b993900d ("riscv: uaccess: Return the number of bytes effectively not copied")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/lib/uaccess.S | 181 +++++++++++++++++++++++++++++++--------
 1 file changed, 146 insertions(+), 35 deletions(-)

diff --git a/arch/riscv/lib/uaccess.S b/arch/riscv/lib/uaccess.S
index fceaeb18cc640..bceb0629e440e 100644
--- a/arch/riscv/lib/uaccess.S
+++ b/arch/riscv/lib/uaccess.S
@@ -19,50 +19,161 @@ ENTRY(__asm_copy_from_user)
 	li t6, SR_SUM
 	csrs CSR_STATUS, t6
 
-	add a3, a1, a2
-	/* Use word-oriented copy only if low-order bits match */
-	andi t0, a0, SZREG-1
-	andi t1, a1, SZREG-1
-	bne t0, t1, 2f
+	/* Save for return value */
+	mv	t5, a2
 
-	addi t0, a1, SZREG-1
-	andi t1, a3, ~(SZREG-1)
-	andi t0, t0, ~(SZREG-1)
 	/*
-	 * a3: terminal address of source region
-	 * t0: lowest XLEN-aligned address in source
-	 * t1: highest XLEN-aligned address in source
+	 * Register allocation for code below:
+	 * a0 - start of uncopied dst
+	 * a1 - start of uncopied src
+	 * a2 - size
+	 * t0 - end of uncopied dst
 	 */
-	bgeu t0, t1, 2f
-	bltu a1, t0, 4f
+	add	t0, a0, a2
+	bgtu	a0, t0, 5f
+
+	/*
+	 * Use byte copy only if too small.
+	 */
+	li	a3, 8*SZREG /* size must be larger than size in word_copy */
+	bltu	a2, a3, .Lbyte_copy_tail
+
+	/*
+	 * Copy first bytes until dst is align to word boundary.
+	 * a0 - start of dst
+	 * t1 - start of aligned dst
+	 */
+	addi	t1, a0, SZREG-1
+	andi	t1, t1, ~(SZREG-1)
+	/* dst is already aligned, skip */
+	beq	a0, t1, .Lskip_first_bytes
 1:
-	fixup REG_L, t2, (a1), 10f
-	fixup REG_S, t2, (a0), 10f
-	addi a1, a1, SZREG
-	addi a0, a0, SZREG
-	bltu a1, t1, 1b
+	/* a5 - one byte for copying data */
+	fixup lb      a5, 0(a1), 10f
+	addi	a1, a1, 1	/* src */
+	fixup sb      a5, 0(a0), 10f
+	addi	a0, a0, 1	/* dst */
+	bltu	a0, t1, 1b	/* t1 - start of aligned dst */
+
+.Lskip_first_bytes:
+	/*
+	 * Now dst is aligned.
+	 * Use shift-copy if src is misaligned.
+	 * Use word-copy if both src and dst are aligned because
+	 * can not use shift-copy which do not require shifting
+	 */
+	/* a1 - start of src */
+	andi	a3, a1, SZREG-1
+	bnez	a3, .Lshift_copy
+
+.Lword_copy:
+        /*
+	 * Both src and dst are aligned, unrolled word copy
+	 *
+	 * a0 - start of aligned dst
+	 * a1 - start of aligned src
+	 * a3 - a1 & mask:(SZREG-1)
+	 * t0 - end of aligned dst
+	 */
+	addi	t0, t0, -(8*SZREG-1) /* not to over run */
 2:
-	bltu a1, a3, 5f
+	fixup REG_L   a4,        0(a1), 10f
+	fixup REG_L   a5,    SZREG(a1), 10f
+	fixup REG_L   a6,  2*SZREG(a1), 10f
+	fixup REG_L   a7,  3*SZREG(a1), 10f
+	fixup REG_L   t1,  4*SZREG(a1), 10f
+	fixup REG_L   t2,  5*SZREG(a1), 10f
+	fixup REG_L   t3,  6*SZREG(a1), 10f
+	fixup REG_L   t4,  7*SZREG(a1), 10f
+	fixup REG_S   a4,        0(a0), 10f
+	fixup REG_S   a5,    SZREG(a0), 10f
+	fixup REG_S   a6,  2*SZREG(a0), 10f
+	fixup REG_S   a7,  3*SZREG(a0), 10f
+	fixup REG_S   t1,  4*SZREG(a0), 10f
+	fixup REG_S   t2,  5*SZREG(a0), 10f
+	fixup REG_S   t3,  6*SZREG(a0), 10f
+	fixup REG_S   t4,  7*SZREG(a0), 10f
+	addi	a0, a0, 8*SZREG
+	addi	a1, a1, 8*SZREG
+	bltu	a0, t0, 2b
+
+	addi	t0, t0, 8*SZREG-1 /* revert to original value */
+	j	.Lbyte_copy_tail
+
+.Lshift_copy:
+
+	/*
+	 * Word copy with shifting.
+	 * For misaligned copy we still perform aligned word copy, but
+	 * we need to use the value fetched from the previous iteration and
+	 * do some shifts.
+	 * This is safe because reading less than a word size.
+	 *
+	 * a0 - start of aligned dst
+	 * a1 - start of src
+	 * a3 - a1 & mask:(SZREG-1)
+	 * t0 - end of uncopied dst
+	 * t1 - end of aligned dst
+	 */
+	/* calculating aligned word boundary for dst */
+	andi	t1, t0, ~(SZREG-1)
+	/* Converting unaligned src to aligned arc */
+	andi	a1, a1, ~(SZREG-1)
+
+	/*
+	 * Calculate shifts
+	 * t3 - prev shift
+	 * t4 - current shift
+	 */
+	slli	t3, a3, LGREG
+	li	a5, SZREG*8
+	sub	t4, a5, t3
+
+	/* Load the first word to combine with seceond word */
+	fixup REG_L   a5, 0(a1), 10f
 
 3:
+	/* Main shifting copy
+	 *
+	 * a0 - start of aligned dst
+	 * a1 - start of aligned src
+	 * t1 - end of aligned dst
+	 */
+
+	/* At least one iteration will be executed */
+	srl	a4, a5, t3
+	fixup REG_L   a5, SZREG(a1), 10f
+	addi	a1, a1, SZREG
+	sll	a2, a5, t4
+	or	a2, a2, a4
+	fixup REG_S   a2, 0(a0), 10f
+	addi	a0, a0, SZREG
+	bltu	a0, t1, 3b
+
+	/* Revert src to original unaligned value  */
+	add	a1, a1, a3
+
+.Lbyte_copy_tail:
+	/*
+	 * Byte copy anything left.
+	 *
+	 * a0 - start of remaining dst
+	 * a1 - start of remaining src
+	 * t0 - end of remaining dst
+	 */
+	bgeu	a0, t0, 5f
+4:
+	fixup lb      a5, 0(a1), 10f
+	addi	a1, a1, 1	/* src */
+	fixup sb      a5, 0(a0), 10f
+	addi	a0, a0, 1	/* dst */
+	bltu	a0, t0, 4b	/* t0 - end of dst */
+
+5:
 	/* Disable access to user memory */
 	csrc CSR_STATUS, t6
-	li a0, 0
+	li	a0, 0
 	ret
-4: /* Edge case: unalignment */
-	fixup lbu, t2, (a1), 10f
-	fixup sb, t2, (a0), 10f
-	addi a1, a1, 1
-	addi a0, a0, 1
-	bltu a1, t0, 4b
-	j 1b
-5: /* Edge case: remainder */
-	fixup lbu, t2, (a1), 10f
-	fixup sb, t2, (a0), 10f
-	addi a1, a1, 1
-	addi a0, a0, 1
-	bltu a1, a3, 5b
-	j 3b
 ENDPROC(__asm_copy_to_user)
 ENDPROC(__asm_copy_from_user)
 EXPORT_SYMBOL(__asm_copy_to_user)
@@ -117,7 +228,7 @@ EXPORT_SYMBOL(__clear_user)
 10:
 	/* Disable access to user memory */
 	csrs CSR_STATUS, t6
-	mv a0, a2
+	mv a0, t5
 	ret
 11:
 	csrs CSR_STATUS, t6
-- 
2.40.1



