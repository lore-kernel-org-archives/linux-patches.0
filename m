Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E9146AF2F;
	Fri,  9 Oct 2026 14:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555436; cv=none; b=EMxoE16gEh4tLNw1JEeNJbx5Lz4aMICS1x8y9eDzfQX6ycIzBOjlqB8j47U63GFdJ8yZGL49ytAqJ1kLiZKdJS6scpyCNOhz8Mk/RooapTPWtovwhd3wntOp9BlSpdTub0LgVZZ47/UTFUvYgC2xKp+OSX09kzW86kpJT8WGIa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555436; c=relaxed/simple;
	bh=eVR9Cl4gVFqPneuhchYNYLfsKCI4prHLqp1POIT/B/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYTqWfvwnmrZ03O3t4HQGxY3uzdo/sCDNV32It2en1OpLfQIpA6YSeQP6V0XJS6SfLeV+71o9CL7XLukaTe/ukMsZbZJKgbKZ2w5t4rac2HDoH9S4sVr3Z2/Jn9aQNAI9qupVowJFsLQUhxoL30vefeX5sPdrmDoV4ictGQOLiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kV78S7d6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kV78S7d6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD4C1F00893;
	Fri,  9 Oct 2026 14:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555432;
	bh=5Q83MtqT42GL90HpLHAWNA9l/Gh3h8qokBY9nKvHsdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kV78S7d6VUCHjHC28AapimZfJ9UfDnDhkeqgzgIhF++G6/JTjUl4rx1rX16peuoWk
	 SblxcpPVRwfoc9oGsaBYCp2Na5TbyKM+uz2f2gVlcFHWWgmN5wYoGUGOVJewoRNAdu
	 NqdkM8PeWohl6Ot287fwUEUpNP5whiwpqeDQHVGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 055/403] random: vDSO: avoid call to memset() when zeroing reserved parameter
Date: Fri,  9 Oct 2026 16:06:56 +0200
Message-ID: <20261009140953.387581755@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[nathan: Backport to 6.18]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/vdso/Makefile   | 2 +-
 arch/loongarch/vdso/Makefile      | 1 +
 arch/powerpc/kernel/vdso/Makefile | 1 +
 arch/riscv/kernel/vdso/Makefile   | 1 +
 arch/s390/kernel/vdso64/Makefile  | 1 +
 arch/x86/entry/vdso/Makefile      | 1 +
 init/Kconfig                      | 5 +++++
 7 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
index 7dec05dd33b70..f6619e1cb2ce7 100644
--- a/arch/arm64/kernel/vdso/Makefile
+++ b/arch/arm64/kernel/vdso/Makefile
@@ -41,7 +41,7 @@ CC_FLAGS_REMOVE_VDSO := $(CC_FLAGS_FTRACE) -Os $(CC_FLAGS_SCS) \
 			$(CC_FLAGS_LTO) $(CC_FLAGS_CFI) \
 			-Wmissing-prototypes -Wmissing-declarations
 
-CC_FLAGS_ADD_VDSO := -O2 -mcmodel=tiny -fasynchronous-unwind-tables
+CC_FLAGS_ADD_VDSO := -O2 -mcmodel=tiny -fasynchronous-unwind-tables $(CONFIG_CC_OPT_INLINE_MEMSET)
 
 CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_REMOVE_VDSO)
 CFLAGS_REMOVE_vgetrandom.o = $(CC_FLAGS_REMOVE_VDSO)
diff --git a/arch/loongarch/vdso/Makefile b/arch/loongarch/vdso/Makefile
index f4d076ce18436..5db5a650ed446 100644
--- a/arch/loongarch/vdso/Makefile
+++ b/arch/loongarch/vdso/Makefile
@@ -13,6 +13,7 @@ ccflags-vdso := \
 	$(filter -E%,$(KBUILD_CFLAGS)) \
 	$(filter -march=%,$(KBUILD_CFLAGS)) \
 	$(filter -m%-float,$(KBUILD_CFLAGS)) \
+	$(CONFIG_CC_OPT_INLINE_MEMSET) \
 	$(CLANG_FLAGS) \
 	-D__VDSO__
 
diff --git a/arch/powerpc/kernel/vdso/Makefile b/arch/powerpc/kernel/vdso/Makefile
index 8834dfe9d7279..4d465d2024d98 100644
--- a/arch/powerpc/kernel/vdso/Makefile
+++ b/arch/powerpc/kernel/vdso/Makefile
@@ -43,6 +43,7 @@ ccflags-y := -fno-common -fno-builtin -DBUILD_VDSO
 ccflags-y += $(DISABLE_LATENT_ENTROPY_PLUGIN)
 ccflags-y += $(call cc-option, -fno-stack-protector)
 ccflags-y += -DDISABLE_BRANCH_PROFILING
+ccflags-y += $(CONFIG_CC_OPT_INLINE_MEMSET)
 ccflags-y += -ffreestanding -fasynchronous-unwind-tables
 ccflags-remove-y := $(CC_FLAGS_FTRACE)
 ldflags-y := -Wl,--hash-style=both -nostdlib -shared -z noexecstack $(CLANG_FLAGS)
diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index 340bbd945591e..e67d9bae96de4 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -27,6 +27,7 @@ endif
 ccflags-y := -fno-stack-protector
 ccflags-y += -DDISABLE_BRANCH_PROFILING
 ccflags-y += -fno-builtin
+ccflags-y += $(CONFIG_CC_OPT_INLINE_MEMSET)
 
 ifneq ($(c-gettimeofday-y),)
   CFLAGS_vgettimeofday.o += -fPIC -include $(c-gettimeofday-y)
diff --git a/arch/s390/kernel/vdso64/Makefile b/arch/s390/kernel/vdso64/Makefile
index d8f0df7428096..b6b6d1d62c613 100644
--- a/arch/s390/kernel/vdso64/Makefile
+++ b/arch/s390/kernel/vdso64/Makefile
@@ -32,6 +32,7 @@ KBUILD_CFLAGS_64 := $(filter-out -mno-pic-data-is-text-relative,$(KBUILD_CFLAGS_
 KBUILD_CFLAGS_64 := $(filter-out -munaligned-symbols,$(KBUILD_CFLAGS_64))
 KBUILD_CFLAGS_64 := $(filter-out -fno-asynchronous-unwind-tables,$(KBUILD_CFLAGS_64))
 KBUILD_CFLAGS_64 += -m64 -fPIC -fno-common -fno-builtin -fasynchronous-unwind-tables
+KBUILD_CFLAGS_64 += $(CONFIG_CC_OPT_INLINE_MEMSET)
 ldflags-y := -shared -soname=linux-vdso64.so.1 \
 	     --hash-style=both --build-id=sha1 -T
 
diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index f247f5f5cb44d..5836d77aa974b 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -54,6 +54,7 @@ $(obj)/vdso-image-%.c: $(obj)/vdso%.so.dbg $(obj)/vdso%.so $(obj)/vdso2c FORCE
 CFL := $(PROFILING) -mcmodel=small -fPIC -O2 -fasynchronous-unwind-tables -m64 \
        $(filter -g%,$(KBUILD_CFLAGS)) -fno-stack-protector \
        -fno-omit-frame-pointer -foptimize-sibling-calls \
+       $(CONFIG_CC_OPT_INLINE_MEMSET) \
        -DDISABLE_BRANCH_PROFILING -DBUILD_VDSO
 
 ifdef CONFIG_MITIGATION_RETPOLINE
diff --git a/init/Kconfig b/init/Kconfig
index 6ce315af48c15..1858e55bfd7cd 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -142,6 +142,11 @@ config CC_HAS_COUNTED_BY
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
-- 
2.53.0



