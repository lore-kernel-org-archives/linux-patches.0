Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D1643ABC;
	Wed, 11 Feb 2026 12:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770813082; cv=none; b=ICugHHCnth/C+NX6xhJ/WCkCyvP7Yp1rU5v9a/K+xwAOMlOtPfirj2hUWywRlMFtkz9lNYQq3BqbxT72p+zLMgLfK+/nJs9CFe6chF+NOBlu7zrrEx0LsARaw2nAscCht7MfrL/yYI84ui64PfwdI88cvS/yhwXogLTJ36eHEEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770813082; c=relaxed/simple;
	bh=rVbYVH5bi8fooUyJXJC6Biqqc9cbSFiCjTBvVVoWd2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fsws/Pm/8jfqrAlYEWpDPfoz/l+Ej9w7FMKa5PlTgst0LyOyNs5Vgx3/hlx05WWyASnFoMxXz14Yj0jHYeszlhdFGl98UTin5Js++GL0S64iy4b3AqV6KhXPQIcD783msSE3rHLk0JI0m/NlWd2m0+zPccO3KgD0woLpbUsPF9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oH/jLeI4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oH/jLeI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9338C19424;
	Wed, 11 Feb 2026 12:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770813082;
	bh=rVbYVH5bi8fooUyJXJC6Biqqc9cbSFiCjTBvVVoWd2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oH/jLeI4lLNHbT9IXFrFTm62G8/0Mogn8ClU0A6lrNX7b4anwUXIKGn2KUeCtobRc
	 bBU+zKfhvKENDCQyalUkPve1b/cOqlcgnYE4/VESGmK70z3I5TcjyLM/ZJ6nHXYZQy
	 RuUC1SB+YzjGoeNozS87C5oCDRpetKdIROiV1n/vibkn+XSiJdKUW23OfFrtUm0FYE
	 E3ybasbzVRVC5GteOi/EC1KUBgTFbM0VwiR2n9FdyQpFx67VrL8xF7e81lcdANupkV
	 U/53DGPh8e+oHUZj1w9+yGW91jd3GPoGaAvwwHf777QoE2u1bKHb0w08MeJsYU6qYr
	 s2j6b9m/eWBNw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	nathan@kernel.org,
	gor@linux.ibm.com,
	ardb@kernel.org,
	samitolvanen@google.com,
	linux-riscv@lists.infradead.org,
	llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.19-5.10] s390/purgatory: Add -Wno-default-const-init-unsafe to KBUILD_CFLAGS
Date: Wed, 11 Feb 2026 07:30:14 -0500
Message-ID: <20260211123112.1330287-4-sashal@kernel.org>
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

[ Upstream commit b4780fe4ddf04b51127a33d705f4a2e224df00fa ]

Add -Wno-default-const-init-unsafe to purgatory KBUILD_CFLAGS, similar
to scripts/Makefile.extrawarn, since clang generates warnings for the
dummy variable in typecheck():

    CC      arch/s390/purgatory/purgatory.o
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

Now I have a thorough understanding. Let me compile my analysis.

## Analysis: s390/purgatory: Add -Wno-default-const-init-unsafe to
KBUILD_CFLAGS

### 1. Commit Message Analysis

The commit adds the `-Wno-default-const-init-unsafe` compiler flag to
the s390 purgatory's `KBUILD_CFLAGS`. The commit message clearly
explains the problem: **clang 21+** introduced a new on-by-default
warning (`-Wdefault-const-init-var-unsafe`) that triggers on the
`typecheck()` macro's dummy variable. The warning fires in
`arch/s390/include/asm/ptrace.h:221` via `psw_bits()` -> `typecheck()`
-> `__dummy2` (line 11 of `include/linux/typecheck.h`).

The commit author is Heiko Carstens, the s390 subsystem maintainer.

### 2. Code Change Analysis

The change is exactly **one line** added to
`arch/s390/purgatory/Makefile`:

```
+KBUILD_CFLAGS += $(call cc-option, -Wno-default-const-init-unsafe)
```

This is wrapped in `$(call cc-option, ...)`, which means it's only
applied when the compiler supports the flag, providing backward
compatibility.

### 3. Root Cause: Why s390 Purgatory Needs Its Own Fix

This is the critical technical detail. The s390 purgatory Makefile
**completely replaces** `KBUILD_CFLAGS` from scratch (line 16):

```16:16:arch/s390/purgatory/Makefile
KBUILD_CFLAGS := -std=gnu11 -fms-extensions -fno-strict-aliasing -Wall
-Wstrict-prototypes
```

Note the `:=` assignment operator — this discards ALL previously-set
global flags, including the `-Wno-default-const-init-unsafe` that was
already added to `scripts/Makefile.warn` (formerly
`scripts/Makefile.extrawarn`) by commit `d0afcfeb9e381` ("kbuild:
Disable -Wdefault-const-init-unsafe").

In contrast, other purgatory Makefiles (x86, riscv, powerpc) use
`filter-out` patterns like:
```
KBUILD_CFLAGS := $(filter-out -fprofile-sample-use=%
...,$(KBUILD_CFLAGS))
```
which **preserve** the global flags (including the warning suppression).
Only s390's purgatory builds from scratch and needs this companion fix.

### 4. Is This a Build Fix?

**Yes, definitively.** With `CONFIG_WERROR=y` (enabled in many distro
configs and CI systems), the clang 21+ warning becomes a build error.
The commit message shows the exact warning output from `CC
arch/s390/purgatory/purgatory.o`. The trigger path is:

- `purgatory.o` includes `asm/ptrace.h`
- `ptrace.h:221` calls `psw_bits(regs->psw).pstate`
- `psw_bits` macro (line 98) calls `typecheck(psw_t, __psw)`
- `typecheck` macro (`include/linux/typecheck.h:11`) declares `typeof(x)
  __dummy2;` — an uninitialized const variable
- clang 21+ flags this with `-Wdefault-const-init-var-unsafe`

### 5. Relationship to Parent Commit

The parent commit `d0afcfeb9e381` ("kbuild: Disable -Wdefault-const-
init-unsafe") was explicitly tagged with `Cc: stable@vger.kernel.org`,
indicating the kernel community considers this warning fix important for
stable. That commit fixed the global build system, but the s390
purgatory was missed because it builds its own CFLAGS from scratch. This
commit is the necessary companion fix.

However, this commit is **self-contained** — it doesn't depend on
`d0afcfeb9e381` being present in stable. The s390 purgatory always
builds its own CFLAGS independently.

### 6. Risk Assessment

- **Lines changed**: 1
- **Files changed**: 1 Makefile
- **Runtime risk**: **Zero**. This is purely a compile-time flag that
  suppresses a spurious compiler warning. No runtime behavior change
  whatsoever.
- **Backward compatibility**: The `$(call cc-option, ...)` wrapper
  ensures the flag is silently ignored on compilers that don't support
  it (older clang, all gcc).
- **Side effects**: None. The warning being suppressed (`-Wdefault-
  const-init-var-unsafe`) is well-audited — the `typecheck()` macro's
  dummy variable is never used; it exists solely for compile-time type
  checking.

### 7. Stable Relevance

- The s390 purgatory (kexec code) exists in all stable kernel trees
  going back many years.
- The `psw_bits()` / `typecheck()` code path exists in all these trees.
- Users building stable kernels with newer clang + `CONFIG_WERROR=y`
  **will** get build failures.
- Build fixes are explicitly listed as appropriate for stable in
  `Documentation/process/stable-kernel-rules.rst`.

### 8. Dependency Check

The commit is fully self-contained. The only "dependency" is the s390
purgatory Makefile itself, which has existed unchanged (in terms of the
KBUILD_CFLAGS structure) for many kernel versions. The `$(call cc-
option, ...)` mechanism is available in all stable trees.

### Summary

This is a textbook build fix for stable:
- **One line**, zero risk, zero runtime impact
- Fixes a **real build failure** with newer clang + CONFIG_WERROR
- Self-contained, no dependencies
- Companion to a commit already tagged `Cc: stable@vger.kernel.org`
- Uses `cc-option` for backward compatibility
- Written by the s390 subsystem maintainer

**YES**

 arch/s390/purgatory/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/purgatory/Makefile b/arch/s390/purgatory/Makefile
index 0c196a5b194af..61d240a37633d 100644
--- a/arch/s390/purgatory/Makefile
+++ b/arch/s390/purgatory/Makefile
@@ -23,6 +23,7 @@ KBUILD_CFLAGS += -D__DISABLE_EXPORTS
 KBUILD_CFLAGS += $(CLANG_FLAGS)
 KBUILD_CFLAGS += $(if $(CONFIG_CC_IS_CLANG),-Wno-microsoft-anon-tag)
 KBUILD_CFLAGS += $(call cc-option,-fno-PIE)
+KBUILD_CFLAGS += $(call cc-option, -Wno-default-const-init-unsafe)
 KBUILD_AFLAGS := $(filter-out -DCC_USING_EXPOLINE,$(KBUILD_AFLAGS))
 KBUILD_AFLAGS += -D__DISABLE_EXPORTS
 
-- 
2.51.0

