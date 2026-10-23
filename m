Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774602;
	b=tHqQB0CH2JwZ0G/t/GW+jF3edbZAEO3nBtnVvUjBrUKK0iKpSoQxJNlDOyPqLZRF34yp
	 MI58Vre1KnWlF8mo36MP1uqBildNud2qjn2JUVy52PM/ur+1WUlhwB39YFOTS69bXEw0N
	 6h3bo5kxbXdeZY2hBkUvxb5npZgDKlNOmRsA6XQg25N+08jVARfOC1l8NgxiHNYe8y0iP
	 BkXlyTy/rFGr87lPcqdUK+UFOGTR+l+ztHmA0ive4sR0S2B13MpWkzIJOoGvfV5bGNedA
	 s12PkVdIGJCOnMNIip+folVHCiWUECaK+UCBpZX02Ism/zIdEE8JwXbuPbecOEiPDsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774602;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fz1IYXiS/iyu4RGpyXADii1kr8Hebta4Sw2l4EJGapI=;
	b=ZR/R7t//55ycujqr6ITFgmYTUNvC3Qh9zlDuyKiF9FMExeC5AVqgqdGlKwlRjnyuTLuL
	 RF0cyW4kfW52IMD5ScgAOnGDnBa23UcYmxjfFWyUYJQIwvF898bZ4P1TZ11t8LhZemvqL
	 xVi1d7cNaP4iTzW63xUdoN6JWsgcwSac2YuR/dhygf26sZvLWnASW8fwQLPjO0cT0V875
	 zUX1MF5yZ5CnvYtIQQP9Di1TxfccpZVMMF+iM496BGsnou+qLmxHSc7qGg+qZcvzztWGI
	 jax3GUWe7UgU6OukAmPg1OACQwLsR06Evhuu14EubSK4EkdkdRRm4+pRJKPCSbrIJww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sDPFsZBw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB71606A31E;
	Fri, 23 Oct 2026 16:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sDPFsZBw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADEA41F01825;
	Fri, 23 Oct 2026 16:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774602;
	bh=Fz1IYXiS/iyu4RGpyXADii1kr8Hebta4Sw2l4EJGapI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sDPFsZBwRS28qk5u2Rt/RJIBvOTntA7SGiiGkxTSPNqChWWc1FyZpCmVU0mtYCPdk
	 ILcBqKZIssQR1I2EowWJSTE1WwODJsxa7t6H4BepHLJHPLWjj0Fq/bEZywCGj+yxi3
	 LwIMFVr9v8W/BxtYLwUSnYv4V87aU1Qfmsg+lYzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Zobernig <lukas.zobernig@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 097/242] x86/insn-eval: Fix shadowed segment index in get_seg_reg_override_idx()
Date: Fri, 23 Oct 2026 18:38:59 +0200
Message-ID: <20261023163716.077239814@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Zobernig <lukas.zobernig@gmail.com>

[ Upstream commit 32c52ec87d6245ee2d12ed5dd509e40062939b50 ]

Commit 45e1dccc0653 ("x86/insn: Simplify for_each_insn_prefix()") made
for_each_insn_prefix() declare its own loop counter named idx.
get_seg_reg_override_idx() keeps its result in a local of the same name,
so the assignments in the loop body now write the loop counter:

 - the function always returns INAT_SEG_REG_DEFAULT, so FS and GS
   overrides are ignored;

 - a CS override sets the counter to INAT_SEG_REG_CS (2), the increment
   makes it 3, and prefixes.bytes[3] holds the last prefix, 0x2e again,
   so the loop never terminates.

The UMIP emulation reaches this from the #GP handler for user space: an
SGDT, SIDT or SMSW with a memory operand and a CS prefix leaves the task
spinning in the kernel, never returning to user space, with a SIGKILL
that is never delivered.  Any user can thus tie up CPUs until reboot.
With an FS or GS prefix, the emulated result is written to the wrong
address.

Rename the internal macro iterator variable.

[ Lukas' original patch renamed the use site, I changed it to rename the
  iterator in the macro instead, but left Lukas' commit message and
  authorship   - Linus ]

Fixes: 45e1dccc0653 ("x86/insn: Simplify for_each_insn_prefix()")
Signed-off-by: Lukas Zobernig <lukas.zobernig@gmail.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/insn.h       | 2 +-
 tools/arch/x86/include/asm/insn.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/insn.h b/arch/x86/include/asm/insn.h
index 846d21c1a7f88..8fb92da1a2c46 100644
--- a/arch/x86/include/asm/insn.h
+++ b/arch/x86/include/asm/insn.h
@@ -321,7 +321,7 @@ static inline int insn_offset_immediate(struct insn *insn)
  * are repeated, it cannot be used for looping over the prefixes.
  */
 #define for_each_insn_prefix(insn, prefix)	\
-	for (int idx = 0; idx < ARRAY_SIZE(insn->prefixes.bytes) && (prefix = insn->prefixes.bytes[idx]) != 0; idx++)
+	for (int __i = 0; __i < ARRAY_SIZE(insn->prefixes.bytes) && (prefix = insn->prefixes.bytes[__i]) != 0; __i++)
 
 #define POP_SS_OPCODE 0x1f
 #define MOV_SREG_OPCODE 0x8e
diff --git a/tools/arch/x86/include/asm/insn.h b/tools/arch/x86/include/asm/insn.h
index 8f10f29433703..1d2903508bbeb 100644
--- a/tools/arch/x86/include/asm/insn.h
+++ b/tools/arch/x86/include/asm/insn.h
@@ -321,7 +321,7 @@ static inline int insn_offset_immediate(struct insn *insn)
  * are repeated, it cannot be used for looping over the prefixes.
  */
 #define for_each_insn_prefix(insn, prefix)	\
-	for (int idx = 0; idx < ARRAY_SIZE(insn->prefixes.bytes) && (prefix = insn->prefixes.bytes[idx]) != 0; idx++)
+	for (int __i = 0; __i < ARRAY_SIZE(insn->prefixes.bytes) && (prefix = insn->prefixes.bytes[__i]) != 0; __i++)
 
 #define POP_SS_OPCODE 0x1f
 #define MOV_SREG_OPCODE 0x8e
-- 
2.53.0



