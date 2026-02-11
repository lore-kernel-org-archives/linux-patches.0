Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080C0883F;
	Wed, 11 Feb 2026 12:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770813085; cv=none; b=jbVY30XyBSLyOKshkfUbsbhgPyr/AwnPyugZ/F1qEFWairVdfVfjw62OGrKQw640wGeGM2o0ziR4mBq6LCGQZxkv7xejqUa/RMFkBMUI4pxEJusey3jVrsCRryn9ulfR/8MKyCHc3EF1dUDZ3DKhkstReP/d5FiVnJZKBjCo++s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770813085; c=relaxed/simple;
	bh=dF7buh+/KSmhDiI7blHFt+idgunTa+UYB5eVnlUyFFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YIl3/O+PLDGsPDkZVaZAZbjmlP5xix+6m4Q5uR2kYHOkgwb2dtSFbWQPZyTvAGaL6j9AcRTaVYBD9FLHdrGg0PL/BJFuTmi0iUS2kCBe3QcqbdfNSIDMcZLTynltUE8Y9cJh+kyW7ZoKGg65GTV0LB8r18Tq1OdFUt2b+FtvfS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S50WHrs+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S50WHrs+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9F5C19425;
	Wed, 11 Feb 2026 12:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770813084;
	bh=dF7buh+/KSmhDiI7blHFt+idgunTa+UYB5eVnlUyFFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S50WHrs+UPJFGWTIu/DsOpBeWFQJOH9VSxBAeDmEruFPIQ3mZnXENbDPt7sNz+i3v
	 R0pAMTp/u4koAVWlpjW3pTiH6Nzl3wNNlwoxWiA05ZStkUpVZmj/+PknahrVWXUUMD
	 g/b/WmkyMAn4e8kAwNNi/tnQdtOcElLdMWdU7kStiZfwhk7zAXPymBVLQ/IdXWNXgr
	 EDzM7q6f8Libii/ifvHGhhtk7Oa2SUQIN+tLh+IrwAWvIGHZTiOTgjhjvI41JC++tz
	 xCu91zSBGZc/IUzXb2XyeVNUCGum+CxMHocHNDIL6DlQVn13P+oF9nTCtwduUUWPHV
	 9voaP1GwyyHLg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	nathan@kernel.org,
	agordeev@linux.ibm.com,
	svens@linux.ibm.com,
	iii@linux.ibm.com,
	gor@linux.ibm.com,
	petr.pavlu@suse.com,
	llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.19-6.18] s390/boot: Add -Wno-default-const-init-unsafe to KBUILD_CFLAGS
Date: Wed, 11 Feb 2026 07:30:15 -0500
Message-ID: <20260211123112.1330287-5-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260211123112.1330287-1-sashal@kernel.org>
References: <20260211123112.1330287-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 5ba35a6c13fff0929c34aba6b7602dacbe68686c ]

Add -Wno-default-const-init-unsafe to boot KBUILD_CFLAGS, similar to
scripts/Makefile.extrawarn, since clang generates warnings for the dummy
variable in typecheck():

    CC      arch/s390/boot/version.o
      arch/s390/include/asm/ptrace.h:221:9: warning: default initialization of an object of type 'typeof (regs->psw)' (aka 'const psw_t') leaves the object uninitialized [-Wdefault-const-init-var-unsafe]
        221 |         return psw_bits(regs->psw).pstate;
            |                ^
      arch/s390/include/asm/ptrace.h:98:2: note: expanded from macro 'psw_bits'
         98 |         typecheck(psw_t, __psw);                \
            |         ^
      include/linux/typecheck.h:11:12: note: expanded from macro 'typecheck'
         11 |         typeof(x) __dummy2; \
            |                   ^

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a thorough understanding of this commit. Let me compile my
analysis.

## Detailed Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit subject clearly states it adds `-Wno-default-const-init-
unsafe` to the s390 boot `KBUILD_CFLAGS`. The commit message explains it
mirrors the same flag already added in `scripts/Makefile.extrawarn` (now
`scripts/Makefile.warn`) and provides a concrete compiler warning output
demonstrating the problem. The author is Heiko Carstens, the s390
subsystem maintainer.

### 2. CODE CHANGE ANALYSIS

The change is a **single line addition** to `arch/s390/boot/Makefile`:

```
KBUILD_CFLAGS += $(call cc-option, -Wno-default-const-init-unsafe)
```

This uses `cc-option`, which means:
- If the compiler supports the flag, it's added
- If the compiler doesn't support the flag (older clang, any gcc), it's
  silently ignored
- **Zero risk of breaking anything on any compiler version**

### 3. WHY THE S390 BOOT CODE NEEDS A SEPARATE FIX

The key architectural issue is that the s390 boot code builds with its
own **completely independent** compiler flags. Looking at
`arch/s390/Makefile` lines 25-38, `KBUILD_CFLAGS_DECOMPRESSOR` is
constructed from scratch:

```25:38:arch/s390/Makefile
KBUILD_CFLAGS_DECOMPRESSOR := $(CLANG_FLAGS) -m64 -O2 -mpacked-stack
-std=gnu11 -fms-extensions
KBUILD_CFLAGS_DECOMPRESSOR += -DDISABLE_BRANCH_PROFILING -D__NO_FORTIFY
// ... more flags built independently ...
```

Then in `arch/s390/boot/Makefile` line 21:

```21:21:arch/s390/boot/Makefile
KBUILD_CFLAGS := $(filter-out
$(CC_FLAGS_MARCH),$(KBUILD_CFLAGS_DECOMPRESSOR))
```

This **completely replaces** the global `KBUILD_CFLAGS` with the
decompressor-specific flags. So the `-Wno-default-const-init-unsafe`
flag added by the main fix (`d0afcfeb9e381`, "kbuild: Disable -Wdefault-
const-init-unsafe") in `scripts/Makefile.warn` is **never seen** by the
s390 boot code.

### 4. BUILD FAILURE CONFIRMED WITH CONFIG_WERROR

From `scripts/Makefile.lib` line 28, the actual compilation uses:
```
$(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(ccflags-y)
```

While `KBUILD_CFLAGS` is overridden for s390 boot, `KBUILD_CPPFLAGS`
(which includes `-Werror` when `CONFIG_WERROR=y`) is NOT overridden.
This means with clang 21+ and `CONFIG_WERROR=y`, the s390 boot code will
**fail to compile** with:

```
error: default initialization of an object of type 'typeof (regs->psw)'
(aka 'const psw_t') leaves the object uninitialized [-Werror,-Wdefault-
const-init-var-unsafe]
```

The warning comes from the `psw_bits()` macro in
`arch/s390/include/asm/ptrace.h` line 98 which uses `typecheck()`, and
`typecheck()` in `include/linux/typecheck.h` line 11 creates a dummy
variable that triggers this clang 21+ warning.

### 5. RELATIONSHIP TO THE PARENT FIX

The parent commit `d0afcfeb9e381` ("kbuild: Disable -Wdefault-const-
init-unsafe") by Nathan Chancellor was explicitly tagged `Cc:
stable@vger.kernel.org`, confirming the upstream maintainers consider
this class of fix appropriate for stable. The parent fix handles the
global build system, but misses the s390 boot code because of its
independent build flags. This commit is the necessary companion fix.

### 6. CLASSIFICATION

This is a **build fix** — one of the categories explicitly allowed in
stable kernel rules. It:
- Prevents compilation warnings that become errors with `CONFIG_WERROR`
- Affects a real architecture (s390/IBM Z mainframes) used heavily in
  enterprise
- Is needed when building with clang 21+ (which has the warning enabled
  by default)
- Has zero runtime impact — it only affects the compiler's warning
  behavior

### 7. SCOPE AND RISK ASSESSMENT

- **Lines changed:** 1
- **Files changed:** 1
- **Risk:** Essentially zero
  - `cc-option` ensures no effect on compilers that don't support the
    flag
  - No runtime behavioral change whatsoever
  - No code generation change
  - Only suppresses a warning
- **Self-contained:** Yes, completely independent. No dependencies on
  other patches.

### 8. USER IMPACT

- **Who is affected:** s390 users building with clang 21+ (enterprise
  Linux distributions on IBM Z)
- **Severity without fix:** Build failure with `CONFIG_WERROR=y`,
  annoying warnings without it
- **Impact with fix:** Clean build, zero runtime change

### 9. STABILITY

- Written by Heiko Carstens, the s390 subsystem maintainer
- Trivial one-line change with no possible regression path
- Mirrors exactly what was already done for the global build system

### Conclusion

This is a textbook stable kernel candidate. It's a **one-line build
fix** that prevents compilation warnings/errors on s390 when using clang
21+. The parent fix (`d0afcfeb9e381`) was already explicitly tagged for
stable, and this commit is the necessary companion to handle the s390
boot code's independent build environment. The risk is essentially zero
(uses `cc-option` for safe degradation), the fix is self-contained, and
it addresses a real build issue for s390 enterprise users.

**YES**

 arch/s390/boot/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/boot/Makefile b/arch/s390/boot/Makefile
index 490167faba7a4..a1e719a79d38c 100644
--- a/arch/s390/boot/Makefile
+++ b/arch/s390/boot/Makefile
@@ -21,6 +21,7 @@ KBUILD_AFLAGS := $(filter-out $(CC_FLAGS_MARCH),$(KBUILD_AFLAGS_DECOMPRESSOR))
 KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_MARCH),$(KBUILD_CFLAGS_DECOMPRESSOR))
 KBUILD_AFLAGS += $(CC_FLAGS_MARCH_MINIMUM) -D__DISABLE_EXPORTS
 KBUILD_CFLAGS += $(CC_FLAGS_MARCH_MINIMUM) -D__DISABLE_EXPORTS
+KBUILD_CFLAGS += $(call cc-option, -Wno-default-const-init-unsafe)
 
 CFLAGS_sclp_early_core.o += -I$(srctree)/drivers/s390/char
 
-- 
2.51.0

