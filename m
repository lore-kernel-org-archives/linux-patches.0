Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E543B7BC;
	Tue,  3 Oct 2023 19:17:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C88C433C8;
	Tue,  3 Oct 2023 19:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696360620;
	bh=qa6S4IWoXm/M6zG107OAxmdy2bBpcu3QjF1UzJO3TfM=;
	h=From:Date:Subject:To:Cc:From;
	b=K1kZ9KwVvLbX6iUl9Pm88APTVviEmwvor1aP4cFtSp5imd1kRTl6WWxdvTRNc/OMu
	 B8wKbEYtWU67/s2NivJp/s3+1LGF5bpOLjGtbOfLBR39j3LhlwAsIOZLUR4Zjrtu6y
	 ed5gpobcH1/pSRaGaMZJpCbI17EMed36+ib1z3w++MIpESpDkaxx8ewomwz4bR2/Zm
	 u2JTcE5CXU83iXYJQGxWezVmlsJjiAbr6BXv77lvEgiNRffdlvBqQuw6wKST/Zmoxr
	 vSe7DsKo7NraRJEe7xE+1jOEblbhtZlMQ27UW3Vw/YB7Rgf3TO8zXxJYlmIdZw+exc
	 XokA/IGNAUeOQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 03 Oct 2023 12:16:24 -0700
Subject: [PATCH v3] RISC-V: build: Allow LTO to be selected
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231003-riscv-lto-v3-1-8aca61a4ecb4@kernel.org>
X-B4-Tracking: v=1; b=H4sIAIdoHGUC/zXMywrCMBCF4Vcps3ZCLgZTV76HuKjNtB1ompKEK
 pS+u1Fwc+CDw79DpsSU4drskGjjzHGpMKcG+qlbRkL21aClNkpKg4lzv+FcIg5SmSeRd9ZdoP7
 XRAO/f637o3pIMWCZEnX/gpZWfceerWhbrZ1DheXltQh0G0PHs+hjgOP4APlK3d6XAAAA
To: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
 conor@kernel.org
Cc: ndesaulniers@google.com, trix@redhat.com, samitolvanen@google.com, 
 twd2.me@gmail.com, linux-riscv@lists.infradead.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3850; i=nathan@kernel.org;
 h=from:subject:message-id; bh=Ptn92JHDlhTUxkNcTxoXQ6MrMP7Rhv1JALJb/w2MO1g=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDKkyGautLNz4vu2fuJmjO/O544RdE095r/v1MHf1J06r5
 NLpn3U5OkpZGMQ4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBE9pYwMjT1/DUr0Jl2vMJ8
 yo7lJ9hbDmp8KDL6/XHXDaalW9uy16czMmz60jSrM2jSafloLvGsmWZ/tEoP3tFeWHDVYtZlth2
 nnzACAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

From: Wende Tan <twd2.me@gmail.com>

Allow LTO to be selected for RISC-V, only when LLD >= 14, since there is an
issue [1] in prior LLD versions that prevents LLD to generate proper
machine code for RISC-V when writing `nop`s.

I have tested enabling LTO for `defconfig`. The LLD took ~2m21s and ~3GiB
on our Intel Xeon Gold 6140 server and produced an 18MiB Image. The image
can boot to shell using an archriscv rootfs on QEMU.

I have also tested it for `allyesconfig` without COMPILE_TEST, FTRACE,
KASAN, and GCOV. The LLD took ~7h03m and ~335GiB on the server,
successfully producing a 1.7GiB Image. Unfortunately, we cannot boot this
image because the `create_kernel_page_table()` -> `alloc_pmd_early()` ->
`BUG_ON()` logic limits the image to be < 1GiB. Maybe we can fix it in a
separate patch further.

Disable LTO for arch/riscv/kernel/pi, as llvm-objcopy expects an ELF
object file when manipulating the files in that subfolder, rather than
LLVM bitcode.

[1] https://github.com/llvm/llvm-project/issues/50505, resolved by LLVM
    commit e63455d5e0e5 ("[MC] Use local MCSubtargetInfo in writeNops")

Tested-by: Wende Tan <twd2.me@gmail.com>
Signed-off-by: Wende Tan <twd2.me@gmail.com>
Co-developed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
NOTE: I tested LLVM 14 through 18 with defconfig + full/thin LTO and
allmodconfig + thin LTO. allmodconfig + thin LTO with LLVM 15 and 16
shows

  ld.lld: error: section size decrease is too large

when linking vmlinux. This appears to be resolved in LLVM 17 with
https://github.com/llvm/llvm-project/commit/9d37ea95df1b84cca9b5e954d8964c976a5e303e
(I did not bisect but the commit message lines up with the issue). I
kept the existing version check because defconfig worked fine but we may
want to bump it to 17.0.0 if randconfigs trip over this.

Changes in v3:
- Disable LTO in arch/riscv/kernel/pi/Makefile, which was added to the
  kernel after the submission of v2. This change matches arm64.
- Link to v2: https://lore.kernel.org/r/20220512205545.992288-1-twd2.me@gmail.com/

Changes in v2:
- Some textual changes suggested by Nick.
- Drop the changes to `arch/riscv/Makefile`, since the LLVM issue is
  filed and resolved.
- Drop the unnecessary changes to `arch/riscv/kernel/vdso/Makefile`.
- Link to v1: https://lore.kernel.org/r/20210719205208.1023221-1-twd2.me@gmail.com/
---
 arch/riscv/Kconfig            | 3 +++
 arch/riscv/kernel/pi/Makefile | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index d607ab0f7c6d..523640f7441e 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -46,6 +46,9 @@ config RISCV
 	select ARCH_SUPPORTS_CFI_CLANG
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC if MMU
 	select ARCH_SUPPORTS_HUGETLBFS if MMU
+	# LLD >= 14: https://github.com/llvm/llvm-project/issues/50505
+	select ARCH_SUPPORTS_LTO_CLANG if LLD_VERSION >= 140000
+	select ARCH_SUPPORTS_LTO_CLANG_THIN if LLD_VERSION >= 140000
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK if MMU
 	select ARCH_SUPPORTS_PER_VMA_LOCK if MMU
 	select ARCH_USE_MEMTEST
diff --git a/arch/riscv/kernel/pi/Makefile b/arch/riscv/kernel/pi/Makefile
index 07915dc9279e..b75f150b923d 100644
--- a/arch/riscv/kernel/pi/Makefile
+++ b/arch/riscv/kernel/pi/Makefile
@@ -9,6 +9,9 @@ KBUILD_CFLAGS	:= $(subst $(CC_FLAGS_FTRACE),,$(KBUILD_CFLAGS)) -fpie \
 		   -fno-asynchronous-unwind-tables -fno-unwind-tables \
 		   $(call cc-option,-fno-addrsig)
 
+# Disable LTO
+KBUILD_CFLAGS	:= $(filter-out $(CC_FLAGS_LTO), $(KBUILD_CFLAGS))
+
 KBUILD_CFLAGS	+= -mcmodel=medany
 
 CFLAGS_cmdline_early.o += -D__NO_FORTIFY

---
base-commit: 8a749fd1a8720d4619c91c8b6e7528c0a355c0aa
change-id: 20231003-riscv-lto-f013beed8587

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

