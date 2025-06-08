Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712E820AF62;
	Sun,  8 Jun 2025 12:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749387297; cv=none; b=YySakVvzMzUrOHQIzF4wpOT/g2qtRXcl0C2XbEqwJ3iJD44EzbSy+UBcbHYx8y27lMfIYKMyzXjfAw/fK1/jZs10eGzX86HoPX1K8RxKozMkaS1tEx4lO+iwb0h932U0SZfjr4kkPYRNcbnT7L89pF7GhcAnAy1gLUqpiyOhYFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749387297; c=relaxed/simple;
	bh=LBTJXmlrYsDcfFHxuwx1fzWjfL7JKqlsW9s7XolAjqg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s0GZuJfP5wQTAdyklFYRwQRz/U+IUp33rqgvulPoYZ5uTXHqkY0/Ne6Mm9T+gnPPuoT0hBQdDu/zYJyISnMdhjAOsoKi+3MZLYSDfGJL9YFiA2YcLsjcqh4WhcZP3CvHrgOuGflOFamu7X92t7L2Jp36P74ORea2jyTQPItxeJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mtohAMLn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mtohAMLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D845DC4CEF4;
	Sun,  8 Jun 2025 12:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749387296;
	bh=LBTJXmlrYsDcfFHxuwx1fzWjfL7JKqlsW9s7XolAjqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mtohAMLnNbroWezimQunEdl5ayIANs16s9LAuC+ONFBFeFPVO2M5ayEknvASoTUbi
	 1iECbipajPloFNH3aaLnpFai2Dy5jLeVxQ8P7IvsUc6+4lXE/+OqNUML2Lf/3WvoCj
	 GSVJ7imEPkTZY06G3CaNhz025DbmTpPhDtVUbF6TwldP2fjwhlsz/tu0MLo7S4sPR4
	 g76maTEFmmQ17PWtU7tVfDuPG5cOECmNZVNk+dZfckqLsiJMMZY7W8Fhv0FFzcdbGR
	 m7wulSEy4x3hNxQeqi4sOYSVI2gXqjoN/rrb8fb2Pe2El+wY19an9sr1bIZMmvervJ
	 YjgRwohQ5AM2w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rudraksha Gupta <guptarud@gmail.com>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	alex.gaynor@gmail.com,
	nathan@kernel.org,
	rust-for-linux@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.14 04/10] rust: arm: fix unknown (to Clang) argument '-mno-fdpic'
Date: Sun,  8 Jun 2025 08:54:41 -0400
Message-Id: <20250608125447.933686-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250608125447.933686-1-sashal@kernel.org>
References: <20250608125447.933686-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.10
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rudraksha Gupta <guptarud@gmail.com>

[ Upstream commit 977c4308ee4270cf46e2c66b37de8e04670daa0c ]

Currently rust on arm fails to compile due to '-mno-fdpic'. This flag
disables a GCC feature that we don't want for kernel builds, so let's
skip it as it doesn't apply to Clang.

    UPD     include/generated/asm-offsets.h
    CALL    scripts/checksyscalls.sh
    RUSTC L rust/core.o
    BINDGEN rust/bindings/bindings_generated.rs
    BINDGEN rust/bindings/bindings_helpers_generated.rs
    CC      rust/helpers/helpers.o
    Unable to generate bindings: clang diagnosed error: error: unknown argument: '-mno-fdpic'
    make[2]: *** [rust/Makefile:369: rust/bindings/bindings_helpers_generated.rs] Error 1
    make[2]: *** Deleting file 'rust/bindings/bindings_helpers_generated.rs'
    make[2]: *** Waiting for unfinished jobs....
    Unable to generate bindings: clang diagnosed error: error: unknown argument: '-mno-fdpic'
    make[2]: *** [rust/Makefile:349: rust/bindings/bindings_generated.rs] Error 1
    make[2]: *** Deleting file 'rust/bindings/bindings_generated.rs'
    make[1]: *** [/home/pmos/build/src/linux-next-next-20250521/Makefile:1285: prepare] Error 2
    make: *** [Makefile:248: __sub-make] Error 2

[ Naresh provided the draft diff [1].

  Ben explained [2]:

    FDPIC is only relevant with no-MMU targets, and then only for userspace.
    When configured for the arm-*-uclinuxfdpiceabi target, GCC enables FDPIC
    by default to facilitate compiling userspace programs. FDPIC is never
    used for the kernel, and we pass -mno-fdpic when building the kernel to
    override the default and make sure FDPIC is disabled.

  and [3]:

    -mno-fdpic disables a GCC feature that we don't want for kernel builds.
    clang does not support this feature, so it always behaves as though
    -mno-fdpic is passed. Therefore, it should be fine to mix the two, at
    least as far as FDPIC is concerned.

  [1] https://lore.kernel.org/rust-for-linux/CA+G9fYt4otQK4pHv8pJBW9e28yHSGCDncKquwuJiJ_1ou0pq0w@mail.gmail.com/
  [2] https://lore.kernel.org/rust-for-linux/aAKrq2InExQk7f_k@dell-precision-5540/
  [3] https://lore.kernel.org/rust-for-linux/aAo_F_UP1Gd4jHlZ@dell-precision-5540/

    - Miguel ]

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Closes: https://lore.kernel.org/all/CA+G9fYvOanQBYXKSg7C6EU30k8sTRC0JRPJXYu7wWK51w38QUQ@mail.gmail.com/
Suggested-by: Miguel Ojeda <ojeda@kernel.org>
Acked-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Rudraksha Gupta <guptarud@gmail.com>
Link: https://lore.kernel.org/r/20250522-rust-mno-fdpic-arm-fix-v2-1-a6f691d9c198@gmail.com
[ Reworded title. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Build Fix Characteristics
This commit fixes a concrete build failure affecting ARM Rust builds.
The error message is clear and specific:
```
Unable to generate bindings: clang diagnosed error: error: unknown
argument: '-mno-fdpic'
```

This represents a fundamental build breakage where Rust compilation
completely fails on ARM when using Clang-based bindgen.

## Code Change Analysis
The fix is surgically precise - it adds `-mno-fdpic` to the
`bindgen_skip_c_flags` list in `/rust/Makefile:276`. This follows the
exact same pattern as numerous other similar fixes that have been
successfully backported.

Looking at the context from `/home/sasha/linux/rust/Makefile:255-277`,
the `bindgen_skip_c_flags` mechanism exists specifically to handle GCC
flags that Clang doesn't understand. The comment explains this is "a
hack" but necessary because "bindgen relies on libclang to parse C" and
there are compatibility issues.

## Historical Precedent from Similar Commits
The provided examples show a clear pattern:

1. **Similar Commit #1 (Backported: YES)** - LoongArch GCC build fix
   adding flags to bindgen skip list
2. **Similar Commit #3 (Backported: NO)** - fstrict-flex-arrays bindgen
   fix
3. **Similar Commit #4 (Backported: YES)** - fzero-init-padding-bits
   bindgen fix

Examining the kernel history, I found additional precedent:
- `a9c621a21712` - Recent commit adding `-fzero-init-padding-bits` to
  bindgen skip flags
- `869b5016e94e` - Added `-fmin-function-alignment` to bindgen skip
  flags

These demonstrate that bindgen compatibility fixes are regularly
backported.

## Technical Context
From `/home/sasha/linux/arch/arm/Makefile:26`, I can see that `-mno-
fdpic` is used in ARM kernel builds:
```makefile
# Disable FDPIC ABI
KBUILD_CFLAGS += $(call cc-option,-mno-fdpic)
```

The commit message explains that FDPIC is a GCC feature for no-MMU
userspace targets that should never be used for kernel builds. Clang
doesn't support this feature and always behaves as if `-mno-fdpic` is
passed. Therefore, filtering it out for bindgen is safe and correct.

## Stable Tree Criteria Compliance
- ✅ **Fixes important bug**: ARM Rust builds completely fail without
  this
- ✅ **Small and contained**: Single line addition to skip flag list
- ✅ **No architectural changes**: Follows established pattern for
  bindgen flag filtering
- ✅ **Minimal regression risk**: Only affects bindgen flag filtering, no
  functional changes
- ✅ **Clear side effects**: None beyond fixing the build failure

## Impact Assessment
This fix enables ARM Rust support to work properly with the standard
toolchain configuration. Without it, any ARM platform wanting to use
Rust features would hit a hard build failure. The change is completely
backward compatible and only affects the flag filtering logic for
bindgen.

The fix matches the exact same pattern as Similar Commits #1 and #4
which were both backported, and addresses the same category of issue -
GCC/Clang toolchain compatibility for Rust builds.

 rust/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/Makefile b/rust/Makefile
index a84c6d4b6ca21..5d33c812835fc 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -245,7 +245,7 @@ bindgen_skip_c_flags := -mno-fp-ret-in-387 -mpreferred-stack-boundary=% \
 	-fzero-call-used-regs=% -fno-stack-clash-protection \
 	-fno-inline-functions-called-once -fsanitize=bounds-strict \
 	-fstrict-flex-arrays=% -fmin-function-alignment=% \
-	-fzero-init-padding-bits=% \
+	-fzero-init-padding-bits=% -mno-fdpic \
 	--param=% --param asan-%
 
 # Derived from `scripts/Makefile.clang`.
-- 
2.39.5

