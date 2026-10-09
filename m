Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CFE4E50AC;
	Fri,  9 Oct 2026 14:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555648; cv=none; b=WbnhNT3p6O2AUc+N8NRp8Kz3TI8IhTS6MTInkalv8pkZDfRbh8u/mZjuFHjxjwGO7iN9lueQfR3lhHTrjNZMHJy7vtINQF3Yw+YH1fl2Ou1luVOdnXnl0kZ9p071Z2gYkw1IfATmKKR1DZ5v3ZuIN/BPPWhZyYcpWq8iKD8SOYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555648; c=relaxed/simple;
	bh=X0JFuKHN/aDEwA/GCZc1tJm2/RbXzVhZC+sPaJLqgqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5CKN4U2Y0B1xSN0mChsTDEd/h1CAtXDp/2CzYhZGlpHJNbevxH7boIY4I+/ZP0qGzgamz+r3daKWgFuT+pcxybGudW3W5EYpPP2WJNtXleQ+ToOJUIuVa/xqerwsc42dJxlEUv1vZWzzsmdgho20+tmqqksfFfWi8L13FjW8Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0AKHteB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0AKHteB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6A61F00899;
	Fri,  9 Oct 2026 14:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555645;
	bh=ECDnkJW7N599iNpfDQ0wYiBPMDL/SSLL3604U6hqwBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K0AKHteBJOrBsGHnH+3raxl9QK/LXpYHtd+H/DTdUCvJvUjTdxYaJPYqRuxD8EYfN
	 LEdRQUll6L3kd0Mts+agrPts8ur5BJVZNFyorqBe3a56AubjodnSWcvQ7Cn56rHk5p
	 ApW5mqiR8vZijhdbzZFQ/ku+lYzLi+IAXhJeUz4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 7.2 042/428] random: vDSO: avoid call to memset() when zeroing reserved parameter
Date: Fri,  9 Oct 2026 16:06:19 +0200
Message-ID: <20261009140947.024207620@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit eb13a1ff271b0d180687eebb30611b0b276d5193 upstream.

After a recent change in LLVM [1], builds with the random vDSO
implementation, such as PowerPC and RISC-V, fail when checking the vDSO:

  arch/powerpc/kernel/vdso/vdso32.so.dbg: dynamic relocations are not supported
  arch/riscv/kernel/vdso/vdso.so.dbg: dynamic relocations are not supported

memset() is now generated when zeroing params->reserved for some builds
because LLVM has an optimization (now run in more instances) that can
recognize at compile time when it is assigning a static value to a
contiguous area of memory and turn that into a call to memset(). Both
clang and GCC assume memset() is always available [2].

Clang has an internal fiddly hook, -max-store-memset, which we can set
to a high number, to disable generating out of line memset calls [3].
Similarly, GCC has -finline-stringops=memset to do the same [4], should
this issue ever hit future version of GCC. While these options wouldn't
make sense for normal kernel code, it is fine for the extremely limited
and intentionally compact vDSO code.

Link: https://github.com/llvm/llvm-project/commit/90cebef1411617fc3eedd359bdf00cb44b1c2439 [1]
Link: https://gcc.gnu.org/onlinedocs/gcc-16.2.0/gcc/Standards.html#index-ffreestanding [2]
Link: https://github.com/llvm/llvm-project/commit/b28eeb28bea39148738dc375e8a97072a1907e64 [3]
Link: https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html#index-finline-stringops [4]
Closes: https://github.com/ClangBuiltLinux/linux/issues/2183
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/vdso/Makefile     |    2 +-
 arch/loongarch/vdso/Makefile        |    1 +
 arch/powerpc/kernel/vdso/Makefile   |    1 +
 arch/riscv/kernel/vdso/Makefile     |    1 +
 arch/s390/kernel/vdso/Makefile      |    1 +
 arch/x86/entry/vdso/vdso64/Makefile |    2 +-
 init/Kconfig                        |    5 +++++
 7 files changed, 11 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/vdso/Makefile
+++ b/arch/arm64/kernel/vdso/Makefile
@@ -41,7 +41,7 @@ CC_FLAGS_REMOVE_VDSO := $(CC_FLAGS_FTRAC
 			$(CC_FLAGS_LTO) $(CC_FLAGS_CFI) \
 			-Wmissing-prototypes -Wmissing-declarations
 
-CC_FLAGS_ADD_VDSO := -O2 -mcmodel=tiny -fasynchronous-unwind-tables
+CC_FLAGS_ADD_VDSO := -O2 -mcmodel=tiny -fasynchronous-unwind-tables $(CONFIG_CC_OPT_INLINE_MEMSET)
 
 CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_REMOVE_VDSO)
 CFLAGS_REMOVE_vgetrandom.o = $(CC_FLAGS_REMOVE_VDSO)
--- a/arch/loongarch/vdso/Makefile
+++ b/arch/loongarch/vdso/Makefile
@@ -16,6 +16,7 @@ ccflags-vdso := \
 	$(filter -m64,$(KBUILD_CFLAGS)) \
 	$(filter -march=%,$(KBUILD_CFLAGS)) \
 	$(filter -m%-float,$(KBUILD_CFLAGS)) \
+	$(CONFIG_CC_OPT_INLINE_MEMSET) \
 	$(CLANG_FLAGS) \
 	-D__VDSO__
 
--- a/arch/powerpc/kernel/vdso/Makefile
+++ b/arch/powerpc/kernel/vdso/Makefile
@@ -43,6 +43,7 @@ ccflags-y := -fno-common -fno-builtin -D
 ccflags-y += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 ccflags-y += $(call cc-option, -fno-stack-protector)
 ccflags-y += -DDISABLE_BRANCH_PROFILING
+ccflags-y += $(CONFIG_CC_OPT_INLINE_MEMSET)
 ccflags-y += -ffreestanding -fasynchronous-unwind-tables
 ccflags-remove-y := $(CC_FLAGS_FTRACE)
 ldflags-y := -Wl,--hash-style=both -nostdlib -shared -z noexecstack $(CLANG_FLAGS)
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -36,6 +36,7 @@ endif
 ccflags-y := -fno-stack-protector
 ccflags-y += -DDISABLE_BRANCH_PROFILING
 ccflags-y += -fno-builtin
+ccflags-y += $(CONFIG_CC_OPT_INLINE_MEMSET)
 ccflags-y += $(KBUILD_BASE_ISA)$(CFI_MARCH)
 ccflags-y += $(CFI_FULL)
 asflags-y += $(KBUILD_BASE_ISA)$(CFI_MARCH)
--- a/arch/s390/kernel/vdso/Makefile
+++ b/arch/s390/kernel/vdso/Makefile
@@ -29,6 +29,7 @@ KBUILD_CFLAGS_VDSO := $(filter-out -muna
 KBUILD_CFLAGS_VDSO := $(filter-out -fno-asynchronous-unwind-tables,$(KBUILD_CFLAGS_VDSO))
 KBUILD_CFLAGS_VDSO += -fPIC -fno-common -fno-builtin -fasynchronous-unwind-tables
 KBUILD_CFLAGS_VDSO += -fno-stack-protector $(DISABLE_KSTACK_ERASE)
+KBUILD_CFLAGS_VDSO += $(CONFIG_CC_OPT_INLINE_MEMSET)
 ldflags-y := -shared -soname=linux-vdso.so.1 \
 	     --hash-style=both --build-id=sha1 \
 	     $(call ld-option, --eh-frame-hdr) -T
--- a/arch/x86/entry/vdso/vdso64/Makefile
+++ b/arch/x86/entry/vdso/vdso64/Makefile
@@ -14,7 +14,7 @@ vobjs-$(CONFIG_X86_SGX)			+= vsgx.o
 vobjs-$(CONFIG_FUTEX_ROBUST_UNLOCK)	+= vfutex.o
 
 # Compilation flags
-flags-y				:= -DBUILD_VDSO64 -m64 -mcmodel=small
+flags-y				:= -DBUILD_VDSO64 -m64 -mcmodel=small $(CONFIG_CC_OPT_INLINE_MEMSET)
 
 # The location of this include matters!
 include $(src)/../common/Makefile.include
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -173,6 +173,11 @@ config CC_HAS_ALLOC_TOKEN
 config CC_HAS_MULTIDIMENSIONAL_NONSTRING
 	def_bool $(success,echo 'char tag[][4] __attribute__((__nonstring__)) = { };' | $(CC) $(CLANG_FLAGS) -x c - -c -o /dev/null -Werror)
 
+config CC_OPT_INLINE_MEMSET
+	string
+	default "-finline-stringops=memset" if $(cc-option,-finline-stringops=memset)
+	default "-mllvm -max-store-memset=4294967294" if $(cc-option,-mllvm -max-store-memset=4294967294)
+
 config LD_CAN_USE_KEEP_IN_OVERLAY
 	# ld.lld prior to 21.0.0 did not support KEEP within an overlay description
 	# https://github.com/llvm/llvm-project/pull/130661


