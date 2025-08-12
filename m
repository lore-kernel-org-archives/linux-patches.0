Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D34169AE6;
	Tue, 12 Aug 2025 04:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754971841; cv=none; b=bQPc6cKRJk0cMUro/QTP9v9kFHiOf2N6Z4c8MyulgmUJh7V2vhoy2YEUREyMaGXuC2zLgV21EBJ6bzxb3ppA4yYBTxeS1tKYTzarXn/9TuH5s8Pejq17WcXgrVQWuO5COc1iGzPtA1L3WlSbsfWLvv2WSk0u4nqml1CJ8oh08SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754971841; c=relaxed/simple;
	bh=A1IDknI2wBVOF1lDrVTLS/8ROE/k11Q3XCJ/bLtA1Qk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=r/YeJLgigygSofgwXXdsDUscxaX7gy0WaLChLWQVEHJ8ynrxp9b4qyskuAPesB2HoBOj1/JjwHqpjKcJ9AtIEhEhRpx53RctmHekJbIgiQuYWkmGeu9A1z3I9GbHSD73Ch5uyHM+uIbH08sqFl9qF+0lR2564IA4+wDPjTgNuaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tMPKyrPX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tMPKyrPX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0E6C4CEF0;
	Tue, 12 Aug 2025 04:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754971840;
	bh=A1IDknI2wBVOF1lDrVTLS/8ROE/k11Q3XCJ/bLtA1Qk=;
	h=From:Date:Subject:To:Cc:From;
	b=tMPKyrPX7lo45EbxFVokOQCV7amf4PfNmPA+d8EqFKOZ7mq6bO73wUaWvP7MO3jPa
	 x2QLuPdJvru8sVfRRndqXv9SLq8UL/BRs+KfSVqpzOXH5u8ZACsmXSw4CIs3QogrwE
	 a4i9XTRhwvDiyZAZIOB6gaFJqBAdJS5uyKhEIQgJTKJArOIsihkmLm7Fn0eQqRbn4H
	 oFR4MN3FIPX10lbxO07nIAAVOFC0mw6ZqvCCBhgR5NFfx4cLZ1tPL/mgz0iEH7M1pg
	 pCt4uuXQO5jniQp2dYuexo25QpiZrRJsqnrz7ut4QO69TmnPiuyEJYUFa8luUha2cA
	 84MuwP1LVk6TQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 11 Aug 2025 21:10:01 -0700
Subject: [PATCH RFC] riscv: Use 64-bit variable for output in
 __get_user_asm
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250811-riscv-wa-llvm-asm-goto-outputs-assertion-failure-v1-1-7bb8c9cbb92b@kernel.org>
X-B4-Tracking: v=1; b=H4sIAJi+mmgC/x3NywrCMBCF4Vcps3agSbEUt4IP4FZcDHFSB9Km5
 KZQ+u4OLv+z+M4OmZNwhku3Q+ImWeKqYU4duDetM6O8tMH29txPxmCS7Bp+CENoC1JecI4lYqx
 lqyXroGBRBD1JqIlxJPZkx2GYnANlt8Revv/LB9xvV3gexw/QjY3WhwAAAA==
X-Change-ID: 20250811-riscv-wa-llvm-asm-goto-outputs-assertion-failure-6aefa26338cc
To: Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>, 
 Paul Walmsley <paul.walmsley@sifive.com>
Cc: Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Craig Topper <craig.topper@sifive.com>, 
 linux-riscv@lists.infradead.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2547; i=nathan@kernel.org;
 h=from:subject:message-id; bh=A1IDknI2wBVOF1lDrVTLS/8ROE/k11Q3XCJ/bLtA1Qk=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBmz9u3bu+uaZ6lnc862mOrn133Ys/dd/3fH+YnE1hdRc
 y/lJNzk6ChlYRDjYpAVU2Spfqx63NBwzlnGG6cmwcxhZQIZwsDFKQATMX7JyHDe9KGdeaNbuKXH
 l/DAxCAb4a+J21+Ul92Kl05/7JhnpMXIsLmZ0U0t6PDh/XeutvcsczGcuKHPsEa67Lyh28p7y+W
 zWAA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After commit f6bff7827a48 ("riscv: uaccess: use 'asm_goto_output' for
get_user()"), which was the first commit that started using asm goto
with outputs on RISC-V, builds of clang built with assertions enabled
start crashing in certain files that use get_user() with:

  clang: llvm/lib/CodeGen/SelectionDAG/SelectionDAGBuilder.cpp:12743: Register FollowCopyChain(MachineRegisterInfo &, Register): Assertion `MI->getOpcode() == TargetOpcode::COPY && "start of copy chain MUST be COPY"' failed.

Internally, LLVM generates an addiw instruction when the output of the
inline asm (which may be any scalar type) needs to be sign extended for
ABI reasons, such as a later function call, so that basic block does not
have to do it.

Use a temporary 64-bit variable as the output of the inline assembly in
__get_user_asm() and explicitly cast it to truncate it if necessary,
avoiding the addiw that triggers the assertion.

Link: https://github.com/ClangBuiltLinux/linux/issues/2092
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
I did this unconditionally but I did not do much investigation into how
the code generation changes, as I never have good luck with figuring out
what is real vs. noise. If this is a worry, I can just duplicate this
under a CONFIG_CC_IS_CLANG block. Alternatively, we could mark
CONFIG_CC_HAS_ASM_GOTO_OUTPUT as broken with clang when targeting
RISC-V.
---
 arch/riscv/include/asm/uaccess.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/uaccess.h b/arch/riscv/include/asm/uaccess.h
index b88a6218b7f2..ff162db20521 100644
--- a/arch/riscv/include/asm/uaccess.h
+++ b/arch/riscv/include/asm/uaccess.h
@@ -98,12 +98,16 @@ static inline unsigned long __untagged_addr_remote(struct mm_struct *mm, unsigne
 
 #ifdef CONFIG_CC_HAS_ASM_GOTO_OUTPUT
 #define __get_user_asm(insn, x, ptr, label)			\
+do {								\
+	u64 __tmp;						\
 	asm_goto_output(					\
 		"1:\n"						\
 		"	" insn " %0, %1\n"			\
 		_ASM_EXTABLE_UACCESS_ERR(1b, %l2, %0)		\
-		: "=&r" (x)					\
-		: "m" (*(ptr)) : : label)
+		: "=&r" (__tmp)					\
+		: "m" (*(ptr)) : : label);			\
+	(x) = (__typeof__(x))__tmp;				\
+} while (0)
 #else /* !CONFIG_CC_HAS_ASM_GOTO_OUTPUT */
 #define __get_user_asm(insn, x, ptr, label)			\
 do {								\

---
base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
change-id: 20250811-riscv-wa-llvm-asm-goto-outputs-assertion-failure-6aefa26338cc

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

