Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13113AE6E8;
	Tue, 17 Mar 2026 11:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747175; cv=none; b=UkypXiB5eh02FFsaFRu4p1yEvO3Kk1tIISOTRhpvlL6Juac1ywa7u8L7953KPsbbjHfFK3AiTSs5MYIiK1O2VJrNoDD8eXYYvNJ1kxpFKyGSWeEgkTOh3Vun4teEcm8pzUTGUKMrYV3Ry0Yo9/7hEANMEblgP3pW7sF0aF/5W/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747175; c=relaxed/simple;
	bh=UGyqG5Iwe9p4eN1rv2Et9opy6IVj+2NBMBzUOhP/oP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRyzUslKOMSAztmdRO7SO5J5fg+9Ba5bIAUTQZfDaEidP/8X3z2WYad7+7Pbj6+sGwrzVzk+8QHswWSxVehyXnKZKKZ/+Bd3Qmf8s9mzgxiDmmCX0MnUJkO0BYT2SY/fijnbyoY3mlSnNIuNY1c5e0EnP5mqBKaXAZIAKSIrwRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V60w4glQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V60w4glQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495C7C19425;
	Tue, 17 Mar 2026 11:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773747175;
	bh=UGyqG5Iwe9p4eN1rv2Et9opy6IVj+2NBMBzUOhP/oP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V60w4glQOg+t3XUc3M46GSpTXAVBkIq/aU9RZrPCTxpBsSuyveCK9APO2w6c10dsu
	 OWytaz1zRQ3MQ7XiVtgD/AB3GJyBCBE1QvfUUyRRnp60JLHDzFXKLTCqJ5pGJEIWRG
	 8M3V53GSyU1x0faNdmE9Ke/zoUNVwbQrerQBETxNpqqqF13upp2EhEMfndsPS0eZtN
	 EY7gTMCkGRXB6knWvUsb+AjQpTaneG/p8Gak1sTnGS9DGsMJ9WiQOMNRogTKkuRoVG
	 bZLhiiWYXZiS/znIbFK1I0uVOjSfUCuzGnfaFOelDYzA8vejs+x5cl4C7p+4qsAIVa
	 AVb7Rw5+DybMg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hari Bathini <hbathini@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mpe@ellerman.id.au,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 6.19-6.18] powerpc64/ftrace: fix OOL stub count with clang
Date: Tue, 17 Mar 2026 07:32:35 -0400
Message-ID: <20260317113249.117771-4-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260317113249.117771-1-sashal@kernel.org>
References: <20260317113249.117771-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.8
Content-Transfer-Encoding: 8bit

From: Hari Bathini <hbathini@linux.ibm.com>

[ Upstream commit 875612a7745013a43c67493cb0583ee3f7476344 ]

The total number of out-of-line (OOL) stubs required for function
tracing is determined using the following command:

    $(OBJDUMP) -r -j __patchable_function_entries vmlinux.o

While this works correctly with GNU objdump, llvm-objdump does not
list the expected relocation records for this section. Fix this by
using the -d option and counting R_PPC64_ADDR64 relocation entries.
This works as desired with both objdump and llvm-objdump.

Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260127084926.34497-3-hbathini@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a **build fix**. When building with clang/LLVM toolchain:
1. `llvm-objdump -r -j __patchable_function_entries` produces no
   relocation records
2. `grep -c "$RELOCATION"` finds 0 matches, returns exit code 1
3. With `set -e` at the top of the script, the script aborts
4. The kernel build fails

This is a clear build failure for the LLVM/clang toolchain on powerpc64
with ftrace OOL stubs enabled.

## Analysis

### What the commit fixes
This commit fixes a **build failure** when compiling the Linux kernel
with the LLVM/clang toolchain on powerpc64 with
`CONFIG_PPC_FTRACE_OUT_OF_LINE` enabled. The `llvm-objdump` tool does
not list relocation records the same way as GNU objdump when using `-r
-j __patchable_function_entries`. Adding the `-d` flag makes both GNU
objdump and llvm-objdump produce the expected output.

### Stable kernel criteria assessment
1. **Obviously correct and tested**: Yes. The fix adds `-d` to objdump
   invocations. It has `Tested-by:` from Venkat Rao Bagalkote. The
   commit message clearly explains the problem and solution.
2. **Fixes a real bug**: Yes. Build failure with LLVM/clang toolchain.
3. **Fixes an important issue**: Yes. Build fixes are explicitly listed
   as acceptable for stable trees per stable kernel rules. Users
   building with LLVM toolchain cannot build a working kernel without
   this fix.
4. **Small and contained**: Yes. Only 2 lines changed - adding `-d` flag
   to two objdump invocations in a shell script.
5. **No new features or APIs**: Correct. No new features.

### Scope and risk
- **2 lines changed**: Minimal scope, adding a single flag to objdump
  commands.
- **Only affects build tooling**: A shell script used during build, not
  runtime kernel code.
- **Cross-toolchain compatible**: The fix works with both GNU objdump
  and llvm-objdump.
- **Risk**: Extremely low. The `-d` (disassemble) flag is standard for
  both objdump implementations and the commit message confirms testing
  with both.

### Affected versions
- The file was introduced in v6.13 (commit eec37961a56aa)
- The fix is in v7.0-rc4
- Stable trees v6.13.y and v6.14.y are affected

### Dependencies
No dependencies on other commits. The fix is self-contained.

### User impact
Anyone building the powerpc64 kernel with clang/LLVM and
CONFIG_PPC_FTRACE_OUT_OF_LINE enabled hits a build failure. The
clang/LLVM toolchain is increasingly used for kernel builds
(ClangBuiltLinux project), making this a real-world issue.

## Verification

- `git log --follow -- arch/powerpc/tools/ftrace-gen-ool-stubs.sh`
  confirmed the file was introduced in commit eec37961a56aa (v6.13)
- `git merge-base --is-ancestor eec37961a56aa v6.13` confirmed the file
  is in v6.13 but not v6.12
- `git tag --contains 875612a774501` confirmed the fix landed in
  v7.0-rc4
- Read `arch/powerpc/kernel/trace/ftrace.c:190-239` confirmed that wrong
  stub count leads to WARN_ON and -EINVAL (ftrace failure)
- Read `arch/powerpc/tools/ftrace-gen-ool-stubs.sh` confirmed `set -e`
  at line 5, meaning grep returning exit code 1 (zero matches) would
  abort the script and fail the build
- `git tag -l 'v6.13.*'` and `git tag -l 'v6.14.*'` confirmed both
  stable trees exist and need this fix
- The diff is exactly 2 lines changed (adding `-d` flag) - verified from
  the commit diff

**YES**

 arch/powerpc/tools/ftrace-gen-ool-stubs.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/tools/ftrace-gen-ool-stubs.sh b/arch/powerpc/tools/ftrace-gen-ool-stubs.sh
index bac186bdf64a7..9218d43aeb548 100755
--- a/arch/powerpc/tools/ftrace-gen-ool-stubs.sh
+++ b/arch/powerpc/tools/ftrace-gen-ool-stubs.sh
@@ -15,9 +15,9 @@ if [ -z "$is_64bit" ]; then
 	RELOCATION=R_PPC_ADDR32
 fi
 
-num_ool_stubs_total=$($objdump -r -j __patchable_function_entries "$vmlinux_o" |
+num_ool_stubs_total=$($objdump -r -j __patchable_function_entries -d "$vmlinux_o" |
 		      grep -c "$RELOCATION")
-num_ool_stubs_inittext=$($objdump -r -j __patchable_function_entries "$vmlinux_o" |
+num_ool_stubs_inittext=$($objdump -r -j __patchable_function_entries -d "$vmlinux_o" |
 			 grep -e ".init.text" -e ".text.startup" | grep -c "$RELOCATION")
 num_ool_stubs_text=$((num_ool_stubs_total - num_ool_stubs_inittext))
 
-- 
2.51.0

