Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E871DE3A4;
	Wed, 28 Jan 2026 22:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769639640; cv=none; b=gPDaX7+l54kk7+z1j9KBLMZEduCROPMpr7JLSfg5/X/ZSkLhmf3iYv+k97tZj0GBVFWbJyWSfFmGaydufRribxeACrcbb06nuroMYJQ9QhWc2tInvvaOtIFNw4EgLF8D+iO6JJQr4tDJ0U4JhDeNgdDqWEQlmZGVi/qAXcuaFsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769639640; c=relaxed/simple;
	bh=+xRV2HkEsfrdZMBafEPY++3IUBK8ed73YGyM9OSrTOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFtPPDMfxlqHyBHY9L6mr7CozTnQSv2cuhLra6Tak1XE5vst+UjUEfi/9DR3MLnq+7IOblooIewd1J+gVvhEdapFhUOWc9GrykPZOPqvkX3ekmElb62fhS56dVROLfMXSRnWUpbf0vf3I5XVVn773ACZ2WV9HHgiYhNtkGTxKrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GFT+SJQe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GFT+SJQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F05C4CEF1;
	Wed, 28 Jan 2026 22:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769639639;
	bh=+xRV2HkEsfrdZMBafEPY++3IUBK8ed73YGyM9OSrTOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GFT+SJQeWAxJBzAONEHlTGwIFAve74HlsN9l13gpE9tz/7iC7F/ISJiNzx7vK7W19
	 wXWwm/bmuO+oyDtQwVHGCyNojeyjoX6cFiIswjJYGs+4Df7AkFK1US4WpAFHUvAud9
	 ZWqXjwBVCfS8kigZf8AD/msz+Z71O63FtZkLB3AUaqZqnMgyjLEzD3MAfy+3eD++/W
	 7Sk65RpglYcX62AISqL5InJ1zY08+imf60SdPuNqzIf9xzzYx4KDQNKRSszL0KJRbV
	 Q9LI2t7OBvA8PRE/EL8rv7aFRKpm1JMmWIBPAltw29d0f/Nqka2rujCfRpEyc+tLIQ
	 UZUJ3794T/22g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nathan Chancellor <nathan@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alexghiti@rivosinc.com,
	cyrilbur@tenstorrent.com,
	jszhang@kernel.org,
	aurelien@aurel32.net,
	tglx@kernel.org,
	cleger@rivosinc.com,
	linux-riscv@lists.infradead.org,
	llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.18] riscv: Use 64-bit variable for output in __get_user_asm
Date: Wed, 28 Jan 2026 17:33:12 -0500
Message-ID: <20260128223332.2806589-14-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260128223332.2806589-1-sashal@kernel.org>
References: <20260128223332.2806589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.7
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit bdce162f2e57a969803e5e9375999a3e0546905f ]

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
Link: https://patch.msgid.link/20260116-riscv-wa-llvm-asm-goto-outputs-assertion-failure-v3-1-55b5775f989b@kernel.org
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Looking at the full analysis based on what we have:

## Analysis Summary

### 1. COMMIT MESSAGE ANALYSIS

The commit message clearly states:
- **After commit f6bff7827a48** - Clearly identifies the regressing
  commit
- **Builds of clang built with assertions enabled start crashing** -
  This is a **build failure**, not just a warning
- Provides a link to the ClangBuiltLinux issue tracker
  (https://github.com/ClangBuiltLinux/linux/issues/2092)
- The assertion failure message is in LLVM's code generation phase
- Author: Nathan Chancellor (ClangBuiltLinux maintainer, well-known
  kernel/LLVM expert)

### 2. CODE CHANGE ANALYSIS

The change is small and surgical:
- **Old code (asm_goto_output path):**
  ```c
  #define __get_user_asm(insn, x, ptr, label)  \
  asm_goto_output(                          \
  "1:\n"                                 \
  "  " insn " %0, %1\n"                  \
  _ASM_EXTABLE_UACCESS_ERR(1b, %l2, %0)  \
  : "=&r" (x)                            \
  : "m" (*(ptr)) : : label)
  ```

- **New code:**
  ```c
  #define __get_user_asm(insn, x, ptr, label)  \
  do {                                          \
  u64 __tmp;                                \
  asm_goto_output(                          \
  "1:\n"                                 \
  "  " insn " %0, %1\n"                  \
  _ASM_EXTABLE_UACCESS_ERR(1b, %l2, %0)  \
  : "=&r" (__tmp)                        \
  : "m" (*(ptr)) : : label);             \
  (x) = (__typeof__(x))__tmp;               \
  } while (0)
  ```

**Technical mechanism:**
- The fix uses a 64-bit temporary variable (`u64 __tmp`) as the output
  of the inline assembly
- Then explicitly casts it to the expected type of `x`
- This avoids LLVM generating an `addiw` instruction to sign-extend the
  output for ABI reasons
- The `addiw` was causing an assertion failure in LLVM's code generation
  because it wasn't recognized as a proper copy instruction

### 3. CLASSIFICATION

This is a **BUILD FIX** - one of the exception categories that is
explicitly allowed in stable:
- Prevents compilation with Clang/LLVM on RISC-V
- Without this fix, users cannot build kernel for RISC-V when using
  Clang with assertions enabled
- The underlying bug likely causes incorrect code generation even when
  assertions are disabled

### 4. SCOPE AND RISK ASSESSMENT

**Lines changed:** ~10 lines, all in a single macro definition
**Files touched:** 1 (arch/riscv/include/asm/uaccess.h)
**Subsystem:** RISC-V uaccess (user-space access)
**Risk:** Very low
- Uses a temporary variable to hold the assembly output then casts it
- This is a known safe pattern (used elsewhere in the kernel)
- Does not change any runtime behavior for GCC builds
- Only affects the `CONFIG_CC_HAS_ASM_GOTO_OUTPUT` code path
  (Clang/modern GCC)

### 5. USER IMPACT

- **Who is affected:** All RISC-V kernel developers and users building
  with Clang/LLVM
- **Severity:** Cannot build the kernel at all on RISC-V with Clang
  (when using assertion-enabled builds)
- RISC-V is an increasingly popular architecture
- Clang is a major compiler used by many distributions

### 6. STABILITY INDICATORS

- Written by Nathan Chancellor (ClangBuiltLinux project lead, kernel
  developer)
- Clear reference to upstream bug reports
- Follows a known workaround pattern

### 7. DEPENDENCY CHECK

**Critical:** This fix depends on commit **f6bff7827a48** ("riscv:
uaccess: use 'asm_goto_output' for get_user()"), which was introduced in
**v6.16-rc1**.

The fix is only relevant for stable trees that contain v6.16+. For older
stable trees (6.15.y and earlier), the problematic code doesn't exist,
so this fix is not needed and wouldn't apply.

### Risk vs. Benefit Analysis

**Benefits:**
- Fixes a **complete build failure** on RISC-V with Clang
- Build fixes are explicitly allowed in stable rules
- Critical for RISC-V users who use Clang

**Risks:**
- Minimal - adds a temporary variable and explicit cast
- Does not change runtime behavior for correct code
- Pattern is well-understood and used elsewhere

### Concerns

1. **Dependency:** Only applicable to stable trees containing 6.16+
   (which have commit f6bff7827a48)
2. **LLVM Bug:** This is a workaround for an LLVM bug (tracked at llvm-
   project#143795). The LLVM bug may eventually be fixed, but kernel
   builds need to work now.

### Conclusion

This commit is a **build fix** that solves a Clang compilation failure
on RISC-V. Build fixes are explicitly allowed in stable kernel rules.
The fix is:
- Small (10 lines)
- Surgical (single macro)
- Safe (temporary variable + cast pattern)
- Critical (prevents build failure)
- Well-documented (links to bug reports)
- Written by an expert (Nathan Chancellor)

The only consideration is that it should only be backported to stable
trees that contain the parent commit f6bff7827a48 (v6.16+), otherwise
the fix addresses code that doesn't exist.

**YES**

 arch/riscv/include/asm/uaccess.h | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/uaccess.h b/arch/riscv/include/asm/uaccess.h
index f5f4f7f85543f..1029c31026dcf 100644
--- a/arch/riscv/include/asm/uaccess.h
+++ b/arch/riscv/include/asm/uaccess.h
@@ -97,13 +97,23 @@ static inline unsigned long __untagged_addr_remote(struct mm_struct *mm, unsigne
  */
 
 #ifdef CONFIG_CC_HAS_ASM_GOTO_OUTPUT
+/*
+ * Use a temporary variable for the output of the asm goto to avoid a
+ * triggering an LLVM assertion due to sign extending the output when
+ * it is used in later function calls:
+ * https://github.com/llvm/llvm-project/issues/143795
+ */
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
-- 
2.51.0

