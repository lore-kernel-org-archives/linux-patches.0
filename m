Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92902BF3E2;
	Tue, 10 Mar 2026 11:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141165; cv=none; b=Dcp8quv3edkO5cVViZgztufKf+TC1uMI3ZdDTjGiRTKDxdBrApdEvZNa7HYxTPmRFObwgrei4unrfiH2GjD3Oh6QmG6N/U+mdI/sxiWUYabI/5LNnm7nPlfbqpJQZ+mu6/YTOHp8krNOy4fpD1sAchPYsVzslYPFLxMJl780Gd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141165; c=relaxed/simple;
	bh=SUVJVMFP2Rvsml3kto3kRoV30/DRWOSfs9UYbcZrpI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjVrEswN4lDovb7X44nrPjfEHQHwIUQfoKHORU2eHasFj3gjnTMCEchuBRsmJR8zZm36j7Eig5295IM1WmrcU5KtBQfy1Pxd/98cKhYPNoiJK9i45FvGBmmBDzniEzLLqmViPWXk/mQwCFytrTUUz/TWtXrX8L6MvrkgoUCZEwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o1EeRTxp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o1EeRTxp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41994C2BCB0;
	Tue, 10 Mar 2026 11:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141164;
	bh=SUVJVMFP2Rvsml3kto3kRoV30/DRWOSfs9UYbcZrpI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o1EeRTxpzxAx1fqdhxfWsyk6v3Ak9+Dpy+gvjnYE0f18TRlOyo9U13qi56yYG/VQa
	 1zxOfP6qmuo11vsonGfTx2CNdBapeEft1jYP8FkNtS4UiLODFeAwu6Co/LsgdJ0xjH
	 cKxJO9jHCnISqFX4YaBxe6Z59kdcuvpUDfnj0G1FjpJ6TMN1NewxqiFnqF09KW0UjZ
	 MI3PCELwEJC2DOlSFwTZyuemmCGOPAFnNscE2Y8dzPLOBLK08Lt2iMYSN6O6CCkwmQ
	 7BY6ZyYkNpT7XE95pxmfgUHimriIGGsYbviIAytt1Fq7SN4PKlgyv4PY2t4nTr26j+
	 2mZmnztOwmIbg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nathan Chancellor <nathan@kernel.org>,
	Ed W <lists@wildgooses.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 167/311] kbuild: Split .modinfo out from ELF_DETAILS
Date: Tue, 10 Mar 2026 07:03:34 -0400
Message-ID: <af151eca5424b0a39b0349141cf4c44ea9695474.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <nathan@kernel.org>

commit 8678591b47469fe16357234efef9b260317b8be4 upstream.

Commit 3e86e4d74c04 ("kbuild: keep .modinfo section in
vmlinux.unstripped") added .modinfo to ELF_DETAILS while removing it
from COMMON_DISCARDS, as it was needed in vmlinux.unstripped and
ELF_DETAILS was present in all architecture specific vmlinux linker
scripts. While this shuffle is fine for vmlinux, ELF_DETAILS and
COMMON_DISCARDS may be used by other linker scripts, such as the s390
and x86 compressed boot images, which may not expect to have a .modinfo
section. In certain circumstances, this could result in a bootloader
failing to load the compressed kernel [1].

Commit ddc6cbef3ef1 ("s390/boot/vmlinux.lds.S: Ensure bzImage ends with
SecureBoot trailer") recently addressed this for the s390 bzImage but
the same bug remains for arm, parisc, and x86. The presence of .modinfo
in the x86 bzImage was the root cause of the issue worked around with
commit d50f21091358 ("kbuild: align modinfo section for Secureboot
Authenticode EDK2 compat"). misc.c in arch/x86/boot/compressed includes
lib/decompress_unzstd.c, which in turn includes lib/xxhash.c and its
MODULE_LICENSE / MODULE_DESCRIPTION macros due to the STATIC definition.

Split .modinfo out from ELF_DETAILS into its own macro and handle it in
all vmlinux linker scripts. Discard .modinfo in the places where it was
previously being discarded from being in COMMON_DISCARDS, as it has
never been necessary in those uses.

Cc: stable@vger.kernel.org
Fixes: 3e86e4d74c04 ("kbuild: keep .modinfo section in vmlinux.unstripped")
Reported-by: Ed W <lists@wildgooses.com>
Closes: https://lore.kernel.org/587f25e0-a80e-46a5-9f01-87cb40cfa377@wildgooses.com/ [1]
Tested-by: Ed W <lists@wildgooses.com> # x86_64
Link: https://patch.msgid.link/20260225-separate-modinfo-from-elf-details-v1-1-387ced6baf4b@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/kernel/vmlinux.lds.S           | 1 +
 arch/arc/kernel/vmlinux.lds.S             | 1 +
 arch/arm/boot/compressed/vmlinux.lds.S    | 1 +
 arch/arm/kernel/vmlinux-xip.lds.S         | 1 +
 arch/arm/kernel/vmlinux.lds.S             | 1 +
 arch/arm64/kernel/vmlinux.lds.S           | 1 +
 arch/csky/kernel/vmlinux.lds.S            | 1 +
 arch/hexagon/kernel/vmlinux.lds.S         | 1 +
 arch/loongarch/kernel/vmlinux.lds.S       | 1 +
 arch/m68k/kernel/vmlinux-nommu.lds        | 1 +
 arch/m68k/kernel/vmlinux-std.lds          | 1 +
 arch/m68k/kernel/vmlinux-sun3.lds         | 1 +
 arch/mips/kernel/vmlinux.lds.S            | 1 +
 arch/nios2/kernel/vmlinux.lds.S           | 1 +
 arch/openrisc/kernel/vmlinux.lds.S        | 1 +
 arch/parisc/boot/compressed/vmlinux.lds.S | 1 +
 arch/parisc/kernel/vmlinux.lds.S          | 1 +
 arch/powerpc/kernel/vmlinux.lds.S         | 1 +
 arch/riscv/kernel/vmlinux.lds.S           | 1 +
 arch/s390/kernel/vmlinux.lds.S            | 1 +
 arch/sh/kernel/vmlinux.lds.S              | 1 +
 arch/sparc/kernel/vmlinux.lds.S           | 1 +
 arch/um/kernel/dyn.lds.S                  | 1 +
 arch/um/kernel/uml.lds.S                  | 1 +
 arch/x86/boot/compressed/vmlinux.lds.S    | 2 +-
 arch/x86/kernel/vmlinux.lds.S             | 1 +
 include/asm-generic/vmlinux.lds.h         | 4 +++-
 27 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/kernel/vmlinux.lds.S b/arch/alpha/kernel/vmlinux.lds.S
index 2efa7dfc798a9..2d136c63db161 100644
--- a/arch/alpha/kernel/vmlinux.lds.S
+++ b/arch/alpha/kernel/vmlinux.lds.S
@@ -71,6 +71,7 @@ SECTIONS
 
 	STABS_DEBUG
 	DWARF_DEBUG
+	MODINFO
 	ELF_DETAILS
 
 	DISCARDS
diff --git a/arch/arc/kernel/vmlinux.lds.S b/arch/arc/kernel/vmlinux.lds.S
index 61a1b2b96e1d8..6af63084ff285 100644
--- a/arch/arc/kernel/vmlinux.lds.S
+++ b/arch/arc/kernel/vmlinux.lds.S
@@ -123,6 +123,7 @@ SECTIONS
 	_end = . ;
 
 	STABS_DEBUG
+	MODINFO
 	ELF_DETAILS
 	DISCARDS
 
diff --git a/arch/arm/boot/compressed/vmlinux.lds.S b/arch/arm/boot/compressed/vmlinux.lds.S
index d411abd4310ea..2d916647df03c 100644
--- a/arch/arm/boot/compressed/vmlinux.lds.S
+++ b/arch/arm/boot/compressed/vmlinux.lds.S
@@ -21,6 +21,7 @@ SECTIONS
     COMMON_DISCARDS
     *(.ARM.exidx*)
     *(.ARM.extab*)
+    *(.modinfo)
     *(.note.*)
     *(.rel.*)
     *(.printk_index)
diff --git a/arch/arm/kernel/vmlinux-xip.lds.S b/arch/arm/kernel/vmlinux-xip.lds.S
index f2e8d4fac0687..5afb725998ec0 100644
--- a/arch/arm/kernel/vmlinux-xip.lds.S
+++ b/arch/arm/kernel/vmlinux-xip.lds.S
@@ -154,6 +154,7 @@ SECTIONS
 
 	STABS_DEBUG
 	DWARF_DEBUG
+	MODINFO
 	ARM_DETAILS
 
 	ARM_ASSERTS
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index d592a203f9c6b..c07843c3c53d3 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -153,6 +153,7 @@ SECTIONS
 
 	STABS_DEBUG
 	DWARF_DEBUG
+	MODINFO
 	ARM_DETAILS
 
 	ARM_ASSERTS
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index ad6133b89e7a4..2964aad0362e4 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -349,6 +349,7 @@ SECTIONS
 
 	STABS_DEBUG
 	DWARF_DEBUG
+	MODINFO
 	ELF_DETAILS
 
 	HEAD_SYMBOLS
diff --git a/arch/csky/kernel/vmlinux.lds.S b/arch/csky/kernel/vmlinux.lds.S
index d718961786d24..81943981b3af4 100644
--- a/arch/csky/kernel/vmlinux.lds.S
+++ b/arch/csky/kernel/vmlinux.lds.S
@@ -109,6 +109,7 @@ SECTIONS
 
 	STABS_DEBUG
 	DWARF_DEBUG
+	MODINFO
 	ELF_DETAILS
 
 	DISCARDS
diff --git a/arch/hexagon/kernel/vmlinux.lds.S b/arch/hexagon/kernel/vmlinux.lds.S
index 1150b77fa281c..aae22283b5e00 100644
--- a/arch/hexagon/kernel/vmlinux.lds.S
+++ b/arch/hexagon/kernel/vmlinux.lds.S
@@ -62,6 +62,7 @@ SECTIONS
 
 	STABS_DEBUG
 	DWARF_DEBUG
+	MODINFO
 	ELF_DETAILS
 	.hexagon.attributes 0 : { *(.hexagon.attributes) }
 
diff --git a/arch/loongarch/kernel/vmlinux.lds.S b/arch/loongarch/kernel/vmlinux.lds.S
index 08ea921cdec16..d0e1377a041d6 100644
--- a/arch/loongarch/kernel/vmlinux.lds.S
+++ b/arch/loongarch/kernel/vmlinux.lds.S
@@ -147,6 +147,7 @@ SECTIONS
 
 	STABS_DEBUG
 	DWARF_DEBUG
+	MODINFO
 	ELF_DETAILS
 
 #ifdef CONFIG_EFI_STUB
diff --git a/arch/m68k/kernel/vmlinux-nommu.lds b/arch/m68k/kernel/vmlinux-nommu.lds
index 2624fc18c131f..45d7f4b0177b4 100644
--- a/arch/m68k/kernel/vmlinux-nommu.lds
+++ b/arch/m68k/kernel/vmlinux-nommu.lds
@@ -85,6 +85,7 @@ SECTIONS {
 	_end = .;
 
 	STABS_DEBUG
+	MODINFO
 	ELF_DETAILS
 
 	/* Sections to be discarded */
diff --git a/arch/m68k/kernel/vmlinux-std.lds b/arch/m68k/kernel/vmlinux-std.lds
index 1ccdd04ae4624..7326586afe15f 100644
--- a/arch/m68k/kernel/vmlinux-std.lds
+++ b/arch/m68k/kernel/vmlinux-std.lds
@@ -58,6 +58,7 @@ SECTIONS
   _end = . ;
 
   STABS_DEBUG
+  MODINFO
   ELF_DETAILS
 
   /* Sections to be discarded */
diff --git a/arch/m68k/kernel/vmlinux-sun3.lds b/arch/m68k/kernel/vmlinux-sun3.lds
index f13ddcc2af5c2..1b19fef201fba 100644
--- a/arch/m68k/kernel/vmlinux-sun3.lds
+++ b/arch/m68k/kernel/vmlinux-sun3.lds
@@ -51,6 +51,7 @@ __init_begin = .;
   _end = . ;
 
   STABS_DEBUG
+  MODINFO
   ELF_DETAILS
 
   /* Sections to be discarded */
diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
index 2b708fac8d2c1..579b2cc1995ae 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -217,6 +217,7 @@ SECTIONS
 
 	STABS_DEBUG
 	DWARF_DEBUG
+	MODINFO
 	ELF_DETAILS
 
 	/* These must appear regardless of  .  */
diff --git a/arch/nios2/kernel/vmlinux.lds.S b/arch/nios2/kernel/vmlinux.lds.S
index 37b9580550646..206f92445bfad 100644
--- a/arch/nios2/kernel/vmlinux.lds.S
+++ b/arch/nios2/kernel/vmlinux.lds.S
@@ -57,6 +57,7 @@ SECTIONS
 
 	STABS_DEBUG
 	DWARF_DEBUG
+	MODINFO
 	ELF_DETAILS
 
 	DISCARDS
diff --git a/arch/openrisc/kernel/vmlinux.lds.S b/arch/openrisc/kernel/vmlinux.lds.S
index 049bff45f6126..9b29c3211774c 100644
--- a/arch/openrisc/kernel/vmlinux.lds.S
+++ b/arch/openrisc/kernel/vmlinux.lds.S
@@ -101,6 +101,7 @@ SECTIONS
 	/* Throw in the debugging sections */
 	STABS_DEBUG
 	DWARF_DEBUG
+	MODINFO
 	ELF_DETAILS
 
         /* Sections to be discarded -- must be last */
diff --git a/arch/parisc/boot/compressed/vmlinux.lds.S b/arch/parisc/boot/compressed/vmlinux.lds.S
index ab7b439908578..87d24cc824b66 100644
--- a/arch/parisc/boot/compressed/vmlinux.lds.S
+++ b/arch/parisc/boot/compressed/vmlinux.lds.S
@@ -90,6 +90,7 @@ SECTIONS
 	/* Sections to be discarded */
 	DISCARDS
 	/DISCARD/ : {
+		*(.modinfo)
 #ifdef CONFIG_64BIT
 		/* temporary hack until binutils is fixed to not emit these
 		 * for static binaries
diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux.lds.S
index b445e47903cfd..0ca93d6d72354 100644
--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -165,6 +165,7 @@ SECTIONS
 	_end = . ;
 
 	STABS_DEBUG
+	MODINFO
 	ELF_DETAILS
 	.note 0 : { *(.note) }
 
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 15850296c0a9c..8fc11d6565bfb 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -397,6 +397,7 @@ SECTIONS
 	_end = . ;
 
 	DWARF_DEBUG
+	MODINFO
 	ELF_DETAILS
 
 	DISCARDS
diff --git a/arch/riscv/kernel/vmlinux.lds.S b/arch/riscv/kernel/vmlinux.lds.S
index 61bd5ba6680a7..997f9eb3b22b1 100644
--- a/arch/riscv/kernel/vmlinux.lds.S
+++ b/arch/riscv/kernel/vmlinux.lds.S
@@ -170,6 +170,7 @@ SECTIONS
 
 	STABS_DEBUG
 	DWARF_DEBUG
+	MODINFO
 	ELF_DETAILS
 	.riscv.attributes 0 : { *(.riscv.attributes) }
 
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 53bcbb91bb9bd..2b62395e35bfb 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -221,6 +221,7 @@ SECTIONS
 	/* Debugging sections.	*/
 	STABS_DEBUG
 	DWARF_DEBUG
+	MODINFO
 	ELF_DETAILS
 
 	/*
diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.S
index 008c30289eaa6..169c63fb3c1dc 100644
--- a/arch/sh/kernel/vmlinux.lds.S
+++ b/arch/sh/kernel/vmlinux.lds.S
@@ -89,6 +89,7 @@ SECTIONS
 
 	STABS_DEBUG
 	DWARF_DEBUG
+	MODINFO
 	ELF_DETAILS
 
 	DISCARDS
diff --git a/arch/sparc/kernel/vmlinux.lds.S b/arch/sparc/kernel/vmlinux.lds.S
index f1b86eb303404..7ea510d9b42f2 100644
--- a/arch/sparc/kernel/vmlinux.lds.S
+++ b/arch/sparc/kernel/vmlinux.lds.S
@@ -191,6 +191,7 @@ SECTIONS
 
 	STABS_DEBUG
 	DWARF_DEBUG
+	MODINFO
 	ELF_DETAILS
 
 	DISCARDS
diff --git a/arch/um/kernel/dyn.lds.S b/arch/um/kernel/dyn.lds.S
index a36b7918a011a..ad3cefeff2acb 100644
--- a/arch/um/kernel/dyn.lds.S
+++ b/arch/um/kernel/dyn.lds.S
@@ -172,6 +172,7 @@ SECTIONS
 
   STABS_DEBUG
   DWARF_DEBUG
+  MODINFO
   ELF_DETAILS
 
   DISCARDS
diff --git a/arch/um/kernel/uml.lds.S b/arch/um/kernel/uml.lds.S
index a409d4b66114f..30aa24348d60c 100644
--- a/arch/um/kernel/uml.lds.S
+++ b/arch/um/kernel/uml.lds.S
@@ -113,6 +113,7 @@ SECTIONS
 
   STABS_DEBUG
   DWARF_DEBUG
+  MODINFO
   ELF_DETAILS
 
   DISCARDS
diff --git a/arch/x86/boot/compressed/vmlinux.lds.S b/arch/x86/boot/compressed/vmlinux.lds.S
index 587ce3e7c5048..e0b152715d9c6 100644
--- a/arch/x86/boot/compressed/vmlinux.lds.S
+++ b/arch/x86/boot/compressed/vmlinux.lds.S
@@ -88,7 +88,7 @@ SECTIONS
 	/DISCARD/ : {
 		*(.dynamic) *(.dynsym) *(.dynstr) *(.dynbss)
 		*(.hash) *(.gnu.hash)
-		*(.note.*)
+		*(.note.*) *(.modinfo)
 	}
 
 	.got.plt (INFO) : {
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index d7af4a64c211b..4ed82b1fe173b 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -424,6 +424,7 @@ SECTIONS
 	.llvm_bb_addr_map : { *(.llvm_bb_addr_map) }
 #endif
 
+	MODINFO
 	ELF_DETAILS
 
 	DISCARDS
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 8ca130af301fc..7b38ec8dc8dd3 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -848,12 +848,14 @@
 
 /* Required sections not related to debugging. */
 #define ELF_DETAILS							\
-		.modinfo : { *(.modinfo) . = ALIGN(8); }		\
 		.comment 0 : { *(.comment) }				\
 		.symtab 0 : { *(.symtab) }				\
 		.strtab 0 : { *(.strtab) }				\
 		.shstrtab 0 : { *(.shstrtab) }
 
+#define MODINFO								\
+		.modinfo : { *(.modinfo) . = ALIGN(8); }
+
 #ifdef CONFIG_GENERIC_BUG
 #define BUG_TABLE							\
 	. = ALIGN(8);							\
-- 
2.51.0

