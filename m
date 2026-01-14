Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DB7A95E;
	Wed, 14 Jan 2026 00:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768349402; cv=none; b=BT3ED7AJfY3zpzV4+KQkyK3sDLbBYNgYDwqI682NMtDoUaAaI+YDyF4nHxtT1qx3PVs//i+KeORt4HVvRAKEkktrEr56NTjzFgR7ij3jLgJBUt7zqeCpozwE/+gIEqH7fW34D854Bw1SV2VcLDGM+XUXQqmIEyEVsBVvlexZvv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768349402; c=relaxed/simple;
	bh=FqAUsQaVDifqu95hEwBwnKuQrXIGCxdQT3cHv99z/q4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=LRRFXmGGwB0UXPY7AP8nsApuFbgPoE6d+P/yE9IAXSsUgDPPpQ3V0cmW1PBbI8/JicMoWNZFf2pEwTHE1Ae6GhvpNof5Fx8CpvTVg6hy4poHuNbj9KGfRoS31rUWeRq414ecRV8SplTYs3H0SMIGYMJVLltlw4GmSVlhvD2ZPEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VR6isYXe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VR6isYXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB275C116C6;
	Wed, 14 Jan 2026 00:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768349402;
	bh=FqAUsQaVDifqu95hEwBwnKuQrXIGCxdQT3cHv99z/q4=;
	h=From:Date:Subject:To:Cc:From;
	b=VR6isYXew7zPNstUqBkqi48WXDU2g4OaJAfnkuScUOQywMP/Zj81UUQ0cdC2K+tVG
	 WrB4PymuL7vpkeep8qmLCBwyfuOqnmxhvUpxdwsObxG3aid9pEH2gqZkDd/RNI+Yyt
	 Q7b+vGjUfo/POLAs4lN8RDY5Fwuz2m5061HydE/5j6gbeX5DFRC3Hclt0tQoC1m6vz
	 cfmrdC7Y2NueQzrn4wBY7DVTpiopJ+3IhG+t6MPQq6Tl+T1j6VNcGrWAokWO36RK7i
	 gH2imcA2NMFkzCbeXYy4Zm52Z4IFq718H/Nk5UbzRUhs61HWBYS8ULPW7SzEdkVz+p
	 gp34Zp8ATlLdw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 13 Jan 2026 17:09:50 -0700
Subject: [PATCH RFC v2] riscv: Use 64-bit variable for output in
 __get_user_asm
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260113-riscv-wa-llvm-asm-goto-outputs-assertion-failure-v2-1-e04aba2e1f9f@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/52OQQ6CMBBFr0Jm7RhbIoIrExMP4NawaOsAE4GSt
 lQN4e42HMHlfz95/y/gyTF5OGcLOIrs2Y4pyF0GplNjS8jPlEEe5PFQCoGOvYn4Vtj3cUDlB2x
 tsGjnMM3BJ5CEIUmwUdzPjrBQ1ChZ5HlpDCTt5Kjhzzb5gPvtCnWCHftg3Xe7EcVW/b8YBQo8a
 V2aymhdSX15kRup31vXQr2u6w82YyCS9gAAAA==
X-Change-ID: 20250811-riscv-wa-llvm-asm-goto-outputs-assertion-failure-6aefa26338cc
To: Paul Walmsley <pjw@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>, 
 Palmer Dabbelt <palmer@dabbelt.com>
Cc: Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Craig Topper <craig.topper@sifive.com>, linux-riscv@lists.infradead.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2746; i=nathan@kernel.org;
 h=from:subject:message-id; bh=FqAUsQaVDifqu95hEwBwnKuQrXIGCxdQT3cHv99z/q4=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDJlp9653BZ5yqA1o5C467XT4vlg9W8qN6JO3z84wae+R3
 LHQ4JJXRykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZgIy1OGPxwqC25oOM+ff+L6
 6a6HE1/5bDWxytofbbqw49B1r+X7U58y/Hd8PJPfoIr1t3zpum+Mm6YEOTrynp/lt6Cnded6DSE
 THT4A
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
Changes in v2:
- Rebase on 6.19-rc5
- Send to updated addresses
- Link to v1: https://lore.kernel.org/r/20250811-riscv-wa-llvm-asm-goto-outputs-assertion-failure-v1-1-7bb8c9cbb92b@kernel.org
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
index 36bba6720c26..2ccf93f746f0 100644
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
base-commit: 0f61b1860cc3f52aef9036d7235ed1f017632193
change-id: 20250811-riscv-wa-llvm-asm-goto-outputs-assertion-failure-6aefa26338cc

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

