Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFBC430E8;
	Tue, 17 Oct 2023 22:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OvBREbvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDADC433C8;
	Tue, 17 Oct 2023 22:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1697581272;
	bh=+fbBrH01A4z4Q/htd056bjoXXyg9yXR/YaOstQWBWjo=;
	h=From:Date:Subject:To:Cc:From;
	b=OvBREbvqWTLv87kM888ykcgWoXc/bBm5U4bLkAjHRzzwu0HCu+yxsPwzccwmB/70p
	 /Crbggvcqv2MNC11GNGP8LUcppIg/pWJ3+jUSFEQTQdeU7Fz6MZimO9a4C2LIDE9YY
	 SPShs0mx1Ksi1I37QH+zjzQSK4bRWcYFch9Pn65O6xI+flH0JOTaV5MbboXA5HMXQ3
	 QxfH1TrbHJzqygTwWF5/YvV/tHijlMW6cPJpHYkjWjKz9q3uveFDuU/R90xVElhOK9
	 PRmBru7IlVMPd+RFv6W8eZMgoYSIVP+nVkOsBTDcJ/17jnCCaUupUnhiNzshWcbW2r
	 3hsJqF+ywwmHA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 17 Oct 2023 15:21:04 -0700
Subject: [PATCH v4] RISC-V: build: Allow LTO to be selected
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231017-riscv-lto-v4-1-e7810b24e805@kernel.org>
X-B4-Tracking: v=1; b=H4sIAM8IL2UC/22OywqDMBREf6Vk3YQ8TBu78j+KixivGqqm3ATbI
 v57o9BdNwMHZg6zkgjoIZLbaSUIi48+zBmK84m4wc49UN9mJpJLJThXFH10Cx1ToB0XqgFojTZ
 XkvtPhM6/D9e9ztxhmGgaEOzPILkWe+hCs7KU0hgqaHq1kk1Q9ZP1I3Nh2l2Djyng57i1qN347
 8Gi8t5YZy/CFuCaonoAzjCygD2pt237Ak0WjA7fAAAA
To: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
 conor@kernel.org
Cc: ndesaulniers@google.com, trix@redhat.com, samitolvanen@google.com, 
 twd2.me@gmail.com, linux-riscv@lists.infradead.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=5712; i=nathan@kernel.org;
 h=from:subject:message-id; bh=6DF5TQYgQXh8UF8vonZlb3mmg4CViQmZyu8y06LElhY=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDKn6HNf37nkcbPZf507Cd7mjsxrsJKLl1Qt5zdyYHuRNK
 XjP+XBNRykLgxgHg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZhIzwKG/3FG5ZyLM2L/e5Vf
 ftY1XYNPi+nVI7W9dx8ubAzk7D5xdR8jw1PZVUuXfKrc4Hb0zZ2saONvEdzJ0xd5GoRb3py64ND
 63YwA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

From: Wende Tan <twd2.me@gmail.com>

Allow LTO to be selected for RISC-V, only when LLD >= 14, since there is
an issue [1] in prior LLD versions that prevents LLD to generate proper
machine code for RISC-V when writing `nop`s.

To avoid boot failures in QEMU [2], '-mattr=+c' and '-mattr=+relax'
need to be passed via '-mllvm' to ld.lld, as there appears to be an
issue with LLVM's target-features and LTO [3], which can result in
incorrect relocations to branch targets [4]. Once this is fixed in LLVM,
it can be made conditional on affected ld.lld versions.

Disable LTO for arch/riscv/kernel/pi, as llvm-objcopy expects an ELF
object file when manipulating the files in that subfolder, rather than
LLVM bitcode.

[1] https://github.com/llvm/llvm-project/issues/50505, resolved by LLVM
    commit e63455d5e0e5 ("[MC] Use local MCSubtargetInfo in writeNops")
[2] https://github.com/ClangBuiltLinux/linux/issues/1942
[3] https://github.com/llvm/llvm-project/issues/59350
[4] https://github.com/llvm/llvm-project/issues/65090

Tested-by: Wende Tan <twd2.me@gmail.com>
Signed-off-by: Wende Tan <twd2.me@gmail.com>
Co-developed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Testing notes from Nathan:

I tested LLVM 14 through 18 with defconfig + full/thin LTO and
allmodconfig + thin LTO. allmodconfig + thin LTO with LLVM 15 and 16
shows

  ld.lld: error: section size decrease is too large

when linking vmlinux. This appears to be resolved in LLVM 17 with
https://github.com/llvm/llvm-project/commit/9d37ea95df1b84cca9b5e954d8964c976a5e303e
(I did not bisect but the commit message lines up with the issue). I
kept the existing version check because defconfig worked fine but we may
want to bump it to 17.0.0 if randconfigs trip over this.

v4 now boots in QEMU for me with both full and thin LTO.

Testing notes from Wende:

I have tested enabling LTO for `defconfig`. The LLD took ~2m21s and ~3GiB
on our Intel Xeon Gold 6140 server and produced an 18MiB Image. The image
can boot to shell using an archriscv rootfs on QEMU.

I have also tested it for `allyesconfig` without COMPILE_TEST, FTRACE,
KASAN, and GCOV. The LLD took ~7h03m and ~335GiB on the server,
successfully producing a 1.7GiB Image. Unfortunately, we cannot boot this
image because the `create_kernel_page_table()` -> `alloc_pmd_early()` ->
`BUG_ON()` logic limits the image to be < 1GiB. Maybe we can fix it in a
separate patch further.

Changes in v4:
- Pass '-mattr=+c' and '-mattr=+relax' to ld.lld via '-mllvm' flags when
  doing LTO due to LLVM not appearing to honor target-features when
  performing LTO, which can result in incorrect branch targets. This
  fixes boot with CONFIG_LTO_CLANG=y with LLVM 15.0.0+.
- Tidy up commit message and move testing notes to below the fold, as it
  is not too relevant to the git history and it makes the rest of the
  message more of an imperative mood.
- Link to v3: https://lore.kernel.org/r/20231003-riscv-lto-v3-1-8aca61a4ecb4@kernel.org

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
 arch/riscv/Makefile           | 5 +++++
 arch/riscv/kernel/pi/Makefile | 3 +++
 3 files changed, 11 insertions(+)

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
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 1329e060c548..709400ceac60 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -52,6 +52,11 @@ ifndef CONFIG_AS_IS_LLVM
 	KBUILD_CFLAGS += -Wa,-mno-relax
 	KBUILD_AFLAGS += -Wa,-mno-relax
 endif
+# LLVM has an issue with target-features and LTO: https://github.com/llvm/llvm-project/issues/59350
+# Ensure it is aware of linker relaxation with LTO, otherwise relocations may
+# be incorrect: https://github.com/llvm/llvm-project/issues/65090
+else ifeq ($(CONFIG_LTO_CLANG),y)
+	KBUILD_LDFLAGS += -mllvm -mattr=+c -mllvm -mattr=+relax
 endif
 endif
 
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

