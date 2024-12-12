Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD465222D66;
	Thu, 12 Dec 2024 16:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019793; cv=none; b=LPeDJZ2iLm/8LcYiZ/9LsGxvnC07V+haUKIla+hWpRrrRQ5FeIcvKmjjYvKP+jQCIUiRFIyFwoF72x9bZFekYWPOHMh5xo63AK/6pJ/c4B3lpz3CencwvTKg2PMCTJJ0KTgf9K0g8NR/8IZVSfgoE8ADCnmauyHuxb78ESorOtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019793; c=relaxed/simple;
	bh=nMP+7LnbOaPyeT0RvMlEkBGBFQNjfA/EJrMHTS4d/gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCBjy4bHIXb5/B00iB5OAsMRyfPNZAG39abNMVl7ID+zyJFxXz84518aYRBy8Jiu6YCSn/l/n3lsUNa4En9eDkC6HrrClAxRbd+ZoTS5faTApPQtcRWnIQczZeM5rGA2FW+mrPcFrAnnopWJZNTLgkhfcUkJvTPsoiufzZB7qyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gVkRlbqn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gVkRlbqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F88C4CECE;
	Thu, 12 Dec 2024 16:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019793;
	bh=nMP+7LnbOaPyeT0RvMlEkBGBFQNjfA/EJrMHTS4d/gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gVkRlbqnecua9B58vHaTlqvbTkCgE/jIhXrMmaTfD43DvN54YAWOp4qkYppys7WYd
	 +viC6E7tUDmmyTc0bFK73DhIRjic7qujuKENUSoKujaAKZXrlqsCdV6hglQG+zsqA+
	 8wARHgcPS+ZP0p/X2yZYGRv7Wr3kQF+vADI/rwUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WANG Xuerui <git@xen0n.name>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>,
	Xi Ruoyao <xry111@xry111.site>
Subject: [PATCH 6.1 300/772] LoongArch: Tweak CFLAGS for Clang compatibility
Date: Thu, 12 Dec 2024 15:54:05 +0100
Message-ID: <20241212144402.295213474@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WANG Xuerui <git@xen0n.name>

[ Upstream commit 38b10b269d04540aee05c34a059dcf304cfce0a8 ]

Now the arch code is mostly ready for LLVM/Clang consumption, it is time
to re-organize the CFLAGS a little to actually enable the LLVM build.
Namely, all -G0 switches from CFLAGS are removed, and -mexplicit-relocs
and -mdirect-extern-access are now wrapped with cc-option (with the
related asm/percpu.h definition guarded against toolchain combos that
are known to not work).

A build with !RELOCATABLE && !MODULE is confirmed working within a QEMU
environment; support for the two features are currently blocked on
LLVM/Clang, and will come later.

Why -G0 can be removed:

In GCC, -G stands for "small data threshold", that instructs the
compiler to put data smaller than the specified threshold in a dedicated
"small data" section (called .sdata on LoongArch and several other
arches).

However, benefiting from this would require ABI cooperation, which is
not the case for LoongArch; and current GCC behave the same whether -G0
(equal to disabling this optimization) is given or not. So, remove -G0
from CFLAGS altogether for one less thing to care about. This also
benefits LLVM/Clang compatibility where the -G switch is not supported.

Why -mexplicit-relocs can now be conditionally applied without
regressions:

Originally -mexplicit-relocs is unconditionally added to CFLAGS in case
of CONFIG_AS_HAS_EXPLICIT_RELOCS, because not having it (i.e. old GCC +
new binutils) would not work: modules will have R_LARCH_ABS_* relocs
inside, but given the rarity of such toolchain combo in the wild, it may
not be worthwhile to support it, so support for such relocs in modules
were not added back when explicit relocs support was upstreamed, and
-mexplicit-relocs is unconditionally added to fail the build early.

Now that Clang compatibility is desired, given Clang is behaving like
-mexplicit-relocs from day one but without support for the CLI flag, we
must ensure the flag is not passed in case of Clang. However, explicit
compiler flavor checks can be more brittle than feature detection: in
this case what actually matters is support for __attribute__((model))
when building modules. Given neither older GCC nor current Clang support
this attribute, probing for the attribute support and #error'ing out
would allow proper UX without checking for Clang, and also automatically
work when Clang support for the attribute is to be added in the future.

Why -mdirect-extern-access is now conditionally applied:

This is actually a nice-to-have optimization that can reduce GOT
accesses, but not having it is harmless either. Because Clang does not
support the option currently, but might do so in the future, conditional
application via cc-option ensures compatibility with both current and
future Clang versions.

Suggested-by: Xi Ruoyao <xry111@xry111.site> # cc-option changes
Signed-off-by: WANG Xuerui <git@xen0n.name>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Stable-dep-of: 947d5d036c78 ("LoongArch: Fix build failure with GCC 15 (-std=gnu23)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/Makefile             | 21 +++++++++++++--------
 arch/loongarch/include/asm/percpu.h |  6 +++++-
 arch/loongarch/vdso/Makefile        |  2 +-
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/arch/loongarch/Makefile b/arch/loongarch/Makefile
index ed47a3a87768e..275d4d5260c72 100644
--- a/arch/loongarch/Makefile
+++ b/arch/loongarch/Makefile
@@ -41,8 +41,8 @@ ld-emul			= $(64bit-emul)
 cflags-y		+= -mabi=lp64s
 endif
 
-cflags-y			+= -G0 -pipe -msoft-float
-LDFLAGS_vmlinux			+= -G0 -static -n -nostdlib
+cflags-y			+= -pipe -msoft-float
+LDFLAGS_vmlinux			+= -static -n -nostdlib
 
 # When the assembler supports explicit relocation hint, we must use it.
 # GCC may have -mexplicit-relocs off by default if it was built with an old
@@ -51,13 +51,18 @@ LDFLAGS_vmlinux			+= -G0 -static -n -nostdlib
 # When the assembler does not supports explicit relocation hint, we can't use
 # it.  Disable it if the compiler supports it.
 #
-# If you've seen "unknown reloc hint" message building the kernel and you are
-# now wondering why "-mexplicit-relocs" is not wrapped with cc-option: the
-# combination of a "new" assembler and "old" compiler is not supported.  Either
-# upgrade the compiler or downgrade the assembler.
+# The combination of a "new" assembler and "old" GCC is not supported, given
+# the rarity of this combo and the extra complexity needed to make it work.
+# Either upgrade the compiler or downgrade the assembler; the build will error
+# out if it is the case (by probing for the model attribute; all supported
+# compilers in this case would have support).
+#
+# Also, -mdirect-extern-access is useful in case of building with explicit
+# relocs, for avoiding unnecessary GOT accesses. It is harmless to not have
+# support though.
 ifdef CONFIG_AS_HAS_EXPLICIT_RELOCS
-cflags-y			+= -mexplicit-relocs
-KBUILD_CFLAGS_KERNEL		+= -mdirect-extern-access
+cflags-y			+= $(call cc-option,-mexplicit-relocs)
+KBUILD_CFLAGS_KERNEL		+= $(call cc-option,-mdirect-extern-access)
 else
 cflags-y			+= $(call cc-option,-mno-explicit-relocs)
 KBUILD_AFLAGS_KERNEL		+= -Wa,-mla-global-with-pcrel
diff --git a/arch/loongarch/include/asm/percpu.h b/arch/loongarch/include/asm/percpu.h
index c90c560941685..7e804140500f1 100644
--- a/arch/loongarch/include/asm/percpu.h
+++ b/arch/loongarch/include/asm/percpu.h
@@ -14,7 +14,11 @@
  * loaded. Tell the compiler this fact when using explicit relocs.
  */
 #if defined(MODULE) && defined(CONFIG_AS_HAS_EXPLICIT_RELOCS)
-#define PER_CPU_ATTRIBUTES    __attribute__((model("extreme")))
+# if __has_attribute(model)
+#  define PER_CPU_ATTRIBUTES __attribute__((model("extreme")))
+# else
+#  error compiler support for the model attribute is necessary when a recent assembler is used
+# endif
 #endif
 
 /* Use r21 for fast access */
diff --git a/arch/loongarch/vdso/Makefile b/arch/loongarch/vdso/Makefile
index d89e2ac75f7b8..67cfb4934bcf8 100644
--- a/arch/loongarch/vdso/Makefile
+++ b/arch/loongarch/vdso/Makefile
@@ -23,7 +23,7 @@ endif
 cflags-vdso := $(ccflags-vdso) \
 	-isystem $(shell $(CC) -print-file-name=include) \
 	$(filter -W%,$(filter-out -Wa$(comma)%,$(KBUILD_CFLAGS))) \
-	-O2 -g -fno-strict-aliasing -fno-common -fno-builtin -G0 \
+	-O2 -g -fno-strict-aliasing -fno-common -fno-builtin \
 	-fno-stack-protector -fno-jump-tables -DDISABLE_BRANCH_PROFILING \
 	$(call cc-option, -fno-asynchronous-unwind-tables) \
 	$(call cc-option, -fno-stack-protector)
-- 
2.43.0



