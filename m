Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC6F2E06EF;
	Mon, 12 Jan 2026 14:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229943; cv=none; b=uF/c+V7KZHmCKK4v4vSLRYLGL8Cw1+qq/lGit4yv/KDE8tFqfhQ2IBNxUMxeEqgTIHZoBYn/dR0yGlpKTymr17ANKnE+f75/DcQEJoVCUXpG3OEgHWByMgZWgTQ1zSUF5Iorz/HiTDSw9wY+qAxlD6HrZe66bJd0Fj0zL+7x60A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229943; c=relaxed/simple;
	bh=d/Hk7pYr4QRi+FKcMg9nhvQmJRSFfVO6mTcYAH99iTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZCFfIFFS3wPvPs82XJB+GeBFH1u0Mwk2HrJMtbq25Y0gfrRWZEznAbzUblTJHw6kU5Nx8KUHmR29GuR1gmgnME5vzLcLjITfwA3Q+H0rNUDThU5F/V9q5X0f2HxJTN89QASCUOGjPci9f2mUGJq86eAbn8jUEAzExPNilZcYTjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AJ9tKkVL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AJ9tKkVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E7FC16AAE;
	Mon, 12 Jan 2026 14:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768229942;
	bh=d/Hk7pYr4QRi+FKcMg9nhvQmJRSFfVO6mTcYAH99iTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJ9tKkVLiC3hcUnvnr2U/MBHaNOywYwFe6kRM5s/oZOUik6OQR9TUSM+2Ipezchjd
	 ouO6/7+vVDPrk5jD3PIg2laoLsSaHPjJulfrThd2FOxDc1ANaiLFaXw09CEOvLVgf3
	 scgwvcnA8gLVWM0hbUWyKc5Rr6l+5QmT8csmgwmnd+BBPYGUltpwZOrDsJ+YOzG5qd
	 9H15ZR8PpC1FO6JmftE4hnQqpG0KyMg7QibKljVthUUcEERiV+J9jDCViT1DrqxWH/
	 MWu2Au1Qasnm4ohsIVP35NmqmpJmoSO1nodosGaB3FMc9T6Dyis3PHnv7NL/3GPS++
	 0ccFjHgERd1qQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lukas Gerlach <lukas.gerlach@cispa.de>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alexghiti@rivosinc.com,
	cleger@rivosinc.com,
	namcao@linutronix.de,
	linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18-6.12] riscv: Sanitize syscall table indexing under speculation
Date: Mon, 12 Jan 2026 09:58:13 -0500
Message-ID: <20260112145840.724774-12-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112145840.724774-1-sashal@kernel.org>
References: <20260112145840.724774-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lukas Gerlach <lukas.gerlach@cispa.de>

[ Upstream commit 25fd7ee7bf58ac3ec7be3c9f82ceff153451946c ]

The syscall number is a user-controlled value used to index into the
syscall table. Use array_index_nospec() to clamp this value after the
bounds check to prevent speculative out-of-bounds access and subsequent
data leakage via cache side channels.

Signed-off-by: Lukas Gerlach <lukas.gerlach@cispa.de>
Link: https://patch.msgid.link/20251218191332.35849-3-lukas.gerlach@cispa.de
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Commit Analysis: riscv: Sanitize syscall table indexing under
speculation

### 1. COMMIT MESSAGE ANALYSIS

The commit message clearly describes a **security vulnerability fix**:
- User-controlled syscall numbers are used to index into the syscall
  table
- The fix prevents speculative out-of-bounds access
- Addresses data leakage via cache side channels (Spectre v1-style
  attack)

Key indicators: "speculative out-of-bounds access", "data leakage",
"cache side channels" - these are unmistakable security vulnerability
descriptions.

### 2. CODE CHANGE ANALYSIS

The change is minimal and surgical:

```c
- if (syscall >= 0 && syscall < NR_syscalls)
+               if (syscall >= 0 && syscall < NR_syscalls) {
+                       syscall = array_index_nospec(syscall,
NR_syscalls);
                        syscall_handler(regs, syscall);
+               }
```

**Technical mechanism:**
- The bounds check (`syscall >= 0 && syscall < NR_syscalls`) is
  performed at runtime
- However, speculative execution can bypass this check - the CPU may
  speculatively execute `syscall_handler()` with an out-of-bounds index
  before the branch is resolved
- This speculative access leaves traces in the cache that can be
  measured via timing attacks
- `array_index_nospec()` creates a data dependency that architecturally
  clamps the index, preventing speculative OOB access

This is the standard Spectre v1 (bounds check bypass) mitigation pattern
used extensively throughout the kernel since 2018.

### 3. CLASSIFICATION

**Type:** Security fix (speculative execution side-channel
vulnerability)

This is NOT:
- A new feature
- A code cleanup
- An optimization
- A refactoring

This IS a security hardening fix addressing a well-known class of
vulnerabilities.

### 4. SCOPE AND RISK ASSESSMENT

**Size:** 2 lines of actual code change
**Files:** 1 file (arch/riscv/kernel/traps.c)
**Complexity:** Extremely low - standard pattern

**Risk analysis:**
- `array_index_nospec()` is a mature, battle-tested macro available
  since kernel 4.16+
- The logic flow is identical - only adds speculation barrier
- No functional behavior change
- Zero regression risk - this is purely defensive

### 5. USER IMPACT

**Affected users:** All RISC-V kernel users

**Severity:** High - this is a security vulnerability:
- Allows potential kernel memory disclosure via timing side-channels
- Spectre-class vulnerabilities have resulted in numerous CVEs
- The syscall path is one of the most critical attack surfaces (user →
  kernel transition)

**Real-world impact:** While exploitation requires sophistication,
Spectre attacks are well-documented and actively exploited. This
vulnerability class affects every major cloud provider and is taken very
seriously.

### 6. STABILITY INDICATORS

- Authored by researcher from CISPA (Helmholtz Center for Information
  Security)
- Signed-off by Paul Walmsley (RISC-V maintainer)
- Follows established kernel security patterns
- Other architectures (x86, ARM64) already have equivalent protections

### 7. DEPENDENCY CHECK

**`array_index_nospec()`:** This macro has been in the kernel since
early 2018 (v4.16) for Spectre mitigations. It will be present in all
maintained stable trees.

**Code context:** The `do_trap_ecall_u()` function in
`arch/riscv/kernel/traps.c` is a fundamental part of the RISC-V syscall
handling and exists in all stable trees supporting RISC-V.

No other commits are required as dependencies.

### STABLE KERNEL RULES ASSESSMENT

| Criteria | Assessment |
|----------|------------|
| Obviously correct | ✅ Uses standard kernel pattern |
| Fixes real bug | ✅ Security vulnerability |
| Important issue | ✅ Information disclosure via side-channel |
| Small and contained | ✅ 2 lines, 1 file |
| No new features | ✅ Pure security hardening |
| Can apply cleanly | ✅ Self-contained change |

### CONCLUSION

This is an exemplary stable backport candidate:

1. **Security fix** for a Spectre v1-class vulnerability in the RISC-V
   syscall path
2. **Minimal change** - 2 lines using well-established kernel security
   primitives
3. **Zero regression risk** - no functional change, only speculation
   barrier
4. **High value** - protects all RISC-V users from potential kernel
   memory disclosure
5. **Brings RISC-V in line** with other architectures that already have
   this protection

The fix is small, surgical, addresses a real security vulnerability,
uses a mature mitigation pattern, and has essentially no risk of causing
regressions. This meets all stable kernel criteria.

**YES**

 arch/riscv/kernel/traps.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 80230de167def..47afea4ff1a8d 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -339,8 +339,10 @@ void do_trap_ecall_u(struct pt_regs *regs)
 
 		add_random_kstack_offset();
 
-		if (syscall >= 0 && syscall < NR_syscalls)
+		if (syscall >= 0 && syscall < NR_syscalls) {
+			syscall = array_index_nospec(syscall, NR_syscalls);
 			syscall_handler(regs, syscall);
+		}
 
 		/*
 		 * Ultimately, this value will get limited by KSTACK_OFFSET_MAX(),
-- 
2.51.0

