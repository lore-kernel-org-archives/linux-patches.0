Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAAE2DCF43;
	Mon, 12 Jan 2026 14:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229936; cv=none; b=hT8Htsd87tD9FLL0oVetIYr1XNr1FovtmTeyLNpZ5eNOR/fWtOL+eVga3mqKon65yA5TdpRk5C/emBKDXR3zZpxOExp0D902CoNO2DeRbRKi+WqOm9CckfOegVU43tf8D97Sw6m4FoH1L85MVApJx4V+JHHIjFsDskCXjBmMWcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229936; c=relaxed/simple;
	bh=QGi0ds/+im2mb7sW3M1Gg5OlQyOn8wmsoECSS6PGgIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HrtwVimY/h4OvcSyTWFqvLzNGg++JKyiqWL57Ob73PKVeHlhEFVhBLJaJJPsv0eaa32EemocrOkEjj7iL0UConNmGbtI4rzkv+P9c9JZgLzthdE0yHs9l/ANQtqtQFQYNFMB9SRozO1EwyKfODxwlt+N15WGGnzq1EnR6H5QR8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fY6BS+xR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fY6BS+xR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAD9C16AAE;
	Mon, 12 Jan 2026 14:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768229936;
	bh=QGi0ds/+im2mb7sW3M1Gg5OlQyOn8wmsoECSS6PGgIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fY6BS+xRY20iHHs/6m1OR0J/RcEcApRX0kBN9I6TdxAq5JabghG3VrWfL5eOzNMMo
	 qPwUAwLNiEGLTffXNW5uLqgW/P98MATZ5/mSQWhbkskrE4//a6jD4qbYmvkpy4x3mG
	 PkbpUnYUtcTgs4sLwhJ3XFtYcjkHNUto3V8Nsh+acXMJ6ZLbOmlMYnYNqSpo4NT2JY
	 K4Ccs/OuQf+Yjpbh4aErpoz032HqA13yrJ1O+q30EM6lFQ/Zds1APjPcDXjIRJp7sT
	 yAxloN1HJuJUr2CjuvKBnlcohKKOh9Cj/MINrqY73+O9Mc9gjYCQmhBw2piPPJYcv1
	 FaV4z/3oKYshQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Martin Kaiser <martin@kaiser.cx>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	bjorn@rivosinc.com,
	songshuaishuai@tinylab.org,
	alexghiti@rivosinc.com,
	kees@kernel.org,
	masahiroy@kernel.org,
	charlie@rivosinc.com,
	linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18] riscv: trace: fix snapshot deadlock with sbi ecall
Date: Mon, 12 Jan 2026 09:58:11 -0500
Message-ID: <20260112145840.724774-10-sashal@kernel.org>
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

From: Martin Kaiser <martin@kaiser.cx>

[ Upstream commit b0d7f5f0c9f05f1b6d4ee7110f15bef9c11f9df0 ]

If sbi_ecall.c's functions are traceable,

echo "__sbi_ecall:snapshot" > /sys/kernel/tracing/set_ftrace_filter

may get the kernel into a deadlock.

(Functions in sbi_ecall.c are excluded from tracing if
CONFIG_RISCV_ALTERNATIVE_EARLY is set.)

__sbi_ecall triggers a snapshot of the ringbuffer. The snapshot code
raises an IPI interrupt, which results in another call to __sbi_ecall
and another snapshot...

All it takes to get into this endless loop is one initial __sbi_ecall.
On RISC-V systems without SSTC extension, the clock events in
timer-riscv.c issue periodic sbi ecalls, making the problem easy to
trigger.

Always exclude the sbi_ecall.c functions from tracing to fix the
potential deadlock.

sbi ecalls can easiliy be logged via trace events, excluding ecall
functions from function tracing is not a big limitation.

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Link: https://patch.msgid.link/20251223135043.1336524-1-martin@kaiser.cx
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Commit Analysis: riscv: trace: fix snapshot deadlock with sbi ecall

## 1. COMMIT MESSAGE ANALYSIS

The commit message clearly describes:
- **Problem**: A deadlock occurs when sbi_ecall.c functions are
  traceable and a snapshot is triggered
- **Root cause**: `__sbi_ecall` triggers a ringbuffer snapshot → raises
  IPI interrupt → causes another `__sbi_ecall` → triggers another
  snapshot → endless loop
- **Trigger condition**: Easy to hit on RISC-V systems without SSTC
  extension, where timer-riscv.c issues periodic SBI ecalls
- **Keywords**: "deadlock", "fix" - strong indicators of a bug fix

The commit message provides a clear technical explanation of the bug
mechanism.

## 2. CODE CHANGE ANALYSIS

Looking at the diff carefully:

**Before the patch:**
- `sbi_ecall.o` was only excluded from ftrace when
  `CONFIG_RISCV_ALTERNATIVE_EARLY` was set
- This left a gap where systems without that config option could hit the
  deadlock

**After the patch:**
- The Makefile is reorganized to consolidate all ftrace exclusions
- `CFLAGS_REMOVE_sbi_ecall.o = $(CC_FLAGS_FTRACE)` is now placed in an
  unconditional `ifdef CONFIG_FTRACE` block
- This means sbi_ecall.o is **always** excluded from tracing when ftrace
  is enabled

The fix is purely a build-time configuration change - it tells the
compiler to not instrument sbi_ecall.c with ftrace hooks.

## 3. CLASSIFICATION

- **Type**: Bug fix (deadlock prevention)
- **Nature**: Build configuration change, not runtime code
- **Not a feature**: It's restricting what can be traced, not adding
  functionality

## 4. SCOPE AND RISK ASSESSMENT

- **Size**: Very small - reorganizes Makefile, effectively moves one
  line
- **Files touched**: 1 file (arch/riscv/kernel/Makefile)
- **Subsystem**: RISC-V architecture specific
- **Risk**: **LOW**
  - Build-time only change
  - Only affects what functions can be traced
  - Commit notes that SBI ecalls can still be logged via trace events
  - No runtime behavior change beyond preventing the tracing of these
    functions

## 5. USER IMPACT

- **Severity**: **HIGH** - This is a deadlock that can completely hang
  the system
- **Affected systems**: RISC-V users with ftrace enabled and without
  CONFIG_RISCV_ALTERNATIVE_EARLY
- **Trigger likelihood**: Easy to trigger on systems without SSTC
  extension (common scenario)
- **User action that triggers it**: Using ftrace snapshot on sbi_ecall
  functions

## 6. STABILITY INDICATORS

- Properly signed off by author and RISC-V maintainer (Paul Walmsley)
- Has a Link: to the patch discussion
- Clear, detailed commit message explaining the issue

## 7. DEPENDENCY CHECK

This is a self-contained Makefile change. The only dependency is that:
- The stable tree has RISC-V architecture support with sbi_ecall.c
- The Makefile structure is similar enough for the patch to apply

The core concept (excluding sbi_ecall.o from ftrace) is simple and
applicable to any kernel version with this file.

## STABLE KERNEL RULES ASSESSMENT

| Criterion | Assessment |
|-----------|------------|
| Obviously correct | ✅ Yes - simple Makefile change to exclude a file
from tracing |
| Fixes real bug | ✅ Yes - fixes a deadlock |
| Important issue | ✅ Yes - deadlock = system hang |
| Small and contained | ✅ Yes - 1 file, Makefile only |
| No new features | ✅ Yes - restricts functionality, doesn't add any |
| Tested | ✅ Merged via maintainer tree |

## RISK VS BENEFIT

- **Benefit**: Prevents a system deadlock on RISC-V platforms
- **Risk**: Minimal - users cannot trace sbi_ecall functions (workaround
  exists via trace events)
- **Trade-off**: Clearly favorable - preventing deadlocks is worth
  losing ability to trace a few functions

## CONCERNS FOR BACKPORTING

The Makefile structure may differ slightly in older stable kernels. The
patch may need minor adjustment but the concept is simple: ensure
`CFLAGS_REMOVE_sbi_ecall.o = $(CC_FLAGS_FTRACE)` is set unconditionally
when CONFIG_FTRACE is enabled.

## CONCLUSION

This is an excellent candidate for stable backporting:
1. Fixes a real, easily-triggerable deadlock
2. Small, surgical fix to build configuration
3. Low risk - only prevents tracing of a few functions
4. Self-contained with no dependencies on other patches
5. Meets all stable kernel rules

**YES**

 arch/riscv/kernel/Makefile | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
index f60fce69b7259..a01f6439d62b1 100644
--- a/arch/riscv/kernel/Makefile
+++ b/arch/riscv/kernel/Makefile
@@ -3,12 +3,6 @@
 # Makefile for the RISC-V Linux kernel
 #
 
-ifdef CONFIG_FTRACE
-CFLAGS_REMOVE_ftrace.o	= $(CC_FLAGS_FTRACE)
-CFLAGS_REMOVE_patch.o	= $(CC_FLAGS_FTRACE)
-CFLAGS_REMOVE_sbi.o	= $(CC_FLAGS_FTRACE)
-CFLAGS_REMOVE_return_address.o	= $(CC_FLAGS_FTRACE)
-endif
 CFLAGS_syscall_table.o	+= $(call cc-disable-warning, override-init)
 CFLAGS_compat_syscall_table.o += $(call cc-disable-warning, override-init)
 
@@ -24,7 +18,6 @@ CFLAGS_sbi_ecall.o := -mcmodel=medany
 ifdef CONFIG_FTRACE
 CFLAGS_REMOVE_alternative.o = $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_cpufeature.o = $(CC_FLAGS_FTRACE)
-CFLAGS_REMOVE_sbi_ecall.o = $(CC_FLAGS_FTRACE)
 endif
 ifdef CONFIG_RELOCATABLE
 CFLAGS_alternative.o += -fno-pie
@@ -43,6 +36,14 @@ CFLAGS_sbi_ecall.o += -D__NO_FORTIFY
 endif
 endif
 
+ifdef CONFIG_FTRACE
+CFLAGS_REMOVE_ftrace.o	= $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_patch.o	= $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_sbi.o	= $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_return_address.o	= $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_sbi_ecall.o = $(CC_FLAGS_FTRACE)
+endif
+
 always-$(KBUILD_BUILTIN) += vmlinux.lds
 
 obj-y	+= head.o
-- 
2.51.0

