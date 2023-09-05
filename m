Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA00A53;
	Tue,  5 Sep 2023 23:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837C9C433CA;
	Tue,  5 Sep 2023 23:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1693955204;
	bh=QQ+Y7wEtz+kXYSbt5wclwVZagbHgBVjGTkbxadwLDG0=;
	h=From:Date:Subject:To:Cc:From;
	b=FQzH5/VFiTVnvr6iYubVj9yTYZFPmX0ybuOzE//f4oGSKkk2XOOepZWVHH+ajJVkB
	 +dM4j5mxx/U/oPAqWnOVEIIJVuq3wNOM5DHdYw5tEnrDhf1cdeLNvjMunb4scJT8mr
	 mzKJzZ1gJy8DNl+Ogc6k4mqMtbQQ0mgR3zbgXOQufXc4/NwTU+0hXrSDRZ4/jr4OUX
	 p/cCxGkTIVWycwODghk0/rsKbpm+EW/aY4vn5BdLJCqHr42quDc+4ADN+WsqRAB6MZ
	 7v42QmdOumES3w0fzC8K7tcLiofVuylbVF0DdeFhS3DkjxBdiDAsff+7KtIlwiGLi4
	 IvSoIztU7z2hQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 05 Sep 2023 16:06:33 -0700
Subject: [PATCH] LoongArch: Drop unused parse_r and parse_v macros
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230905-loongarch-fix-clang-lto-parse_r-v1-1-d991ee630222@kernel.org>
X-B4-Tracking: v=1; b=H4sIAHi092QC/x2NUQqDMBAFryL73YVoFW2vUqTE9KkLIZGNSEG8e
 5d+DgwzJxWooNCzOklxSJGcDOpbRWH1aQHLx5ga19zdw3Ucc06L17DyLF8O0RyOe+bNa8FbeZj
 aYe5rAD6QVTaFif/Da7yuH/SVVPpxAAAA
To: chenhuacai@kernel.org, kernel@xen0n.name
Cc: loongarch@lists.linux.dev, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=5128; i=nathan@kernel.org;
 h=from:subject:message-id; bh=QQ+Y7wEtz+kXYSbt5wclwVZagbHgBVjGTkbxadwLDG0=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCnft7Q0qL68Ln+9ovX/j3esT68dNljR51097+mBN9cfy
 9eUbBQ81lHKwiDGwSArpshS/Vj1uKHhnLOMN05NgpnDygQyhIGLUwAmYp7CyHD2rKqyh+bkzwzP
 Hbsu+GsfXLXFQ9t5e43pZb+TTAY8nK8Y/hlP+MHmuuiRwcrXEtrnOeKc/a1V+xznM2xPWtnNp3t
 UjxUA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building with CONFIG_LTO_CLANG_FULL, there are several errors due
to the way that parse_r is defined with an __asm__ statement in a
header:

  ld.lld: error: ld-temp.o <inline asm>:105:1: macro 'parse_r' is already defined
  .macro  parse_r var r
  ^

This was an issue for arch/mips as well, which was resolved by
commit 67512a8cf5a7 ("MIPS: Avoid macro redefinitions").

However, parse_r is unused in arch/loongarch after
commit 83d8b38967d2 ("LoongArch: Simplify the invtlb wrappers"), so
doing the same change does not make much sense now. Just remove parse_r
(and parse_v, which is also unused) to resolve the redefinition error.
If it needs to be brought back due to an actual use, it should be
brought back with the same changes as the aforementioned arch/mips
commit.

Closes: https://github.com/ClangBuiltLinux/linux/issues/1924
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/loongarch/include/asm/asmmacro.h  | 107 ---------------------------------
 arch/loongarch/include/asm/loongarch.h |  43 -------------
 2 files changed, 150 deletions(-)

diff --git a/arch/loongarch/include/asm/asmmacro.h b/arch/loongarch/include/asm/asmmacro.h
index 8aaecd85aa81..c9544f358c33 100644
--- a/arch/loongarch/include/asm/asmmacro.h
+++ b/arch/loongarch/include/asm/asmmacro.h
@@ -10,113 +10,6 @@
 #include <asm/fpregdef.h>
 #include <asm/loongarch.h>
 
-	.macro	parse_v var val
-	\var	= \val
-	.endm
-
-	.macro	parse_r var r
-	\var	= -1
-	.ifc	\r, $r0
-	\var	= 0
-	.endif
-	.ifc	\r, $r1
-	\var	= 1
-	.endif
-	.ifc	\r, $r2
-	\var	= 2
-	.endif
-	.ifc	\r, $r3
-	\var	= 3
-	.endif
-	.ifc	\r, $r4
-	\var	= 4
-	.endif
-	.ifc	\r, $r5
-	\var	= 5
-	.endif
-	.ifc	\r, $r6
-	\var	= 6
-	.endif
-	.ifc	\r, $r7
-	\var	= 7
-	.endif
-	.ifc	\r, $r8
-	\var	= 8
-	.endif
-	.ifc	\r, $r9
-	\var	= 9
-	.endif
-	.ifc	\r, $r10
-	\var	= 10
-	.endif
-	.ifc	\r, $r11
-	\var	= 11
-	.endif
-	.ifc	\r, $r12
-	\var	= 12
-	.endif
-	.ifc	\r, $r13
-	\var	= 13
-	.endif
-	.ifc	\r, $r14
-	\var	= 14
-	.endif
-	.ifc	\r, $r15
-	\var	= 15
-	.endif
-	.ifc	\r, $r16
-	\var	= 16
-	.endif
-	.ifc	\r, $r17
-	\var	= 17
-	.endif
-	.ifc	\r, $r18
-	\var	= 18
-	.endif
-	.ifc	\r, $r19
-	\var	= 19
-	.endif
-	.ifc	\r, $r20
-	\var	= 20
-	.endif
-	.ifc	\r, $r21
-	\var	= 21
-	.endif
-	.ifc	\r, $r22
-	\var	= 22
-	.endif
-	.ifc	\r, $r23
-	\var	= 23
-	.endif
-	.ifc	\r, $r24
-	\var	= 24
-	.endif
-	.ifc	\r, $r25
-	\var	= 25
-	.endif
-	.ifc	\r, $r26
-	\var	= 26
-	.endif
-	.ifc	\r, $r27
-	\var	= 27
-	.endif
-	.ifc	\r, $r28
-	\var	= 28
-	.endif
-	.ifc	\r, $r29
-	\var	= 29
-	.endif
-	.ifc	\r, $r30
-	\var	= 30
-	.endif
-	.ifc	\r, $r31
-	\var	= 31
-	.endif
-	.iflt	\var
-	.error	"Unable to parse register name \r"
-	.endif
-	.endm
-
 	.macro	cpu_save_nonscratch thread
 	stptr.d	s0, \thread, THREAD_REG23
 	stptr.d	s1, \thread, THREAD_REG24
diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
index d1324e8accfe..33531d432b49 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -12,49 +12,6 @@
 #ifndef __ASSEMBLY__
 #include <larchintrin.h>
 
-/*
- * parse_r var, r - Helper assembler macro for parsing register names.
- *
- * This converts the register name in $n form provided in \r to the
- * corresponding register number, which is assigned to the variable \var. It is
- * needed to allow explicit encoding of instructions in inline assembly where
- * registers are chosen by the compiler in $n form, allowing us to avoid using
- * fixed register numbers.
- *
- * It also allows newer instructions (not implemented by the assembler) to be
- * transparently implemented using assembler macros, instead of needing separate
- * cases depending on toolchain support.
- *
- * Simple usage example:
- * __asm__ __volatile__("parse_r addr, %0\n\t"
- *			"#invtlb op, 0, %0\n\t"
- *			".word ((0x6498000) | (addr << 10) | (0 << 5) | op)"
- *			: "=r" (status);
- */
-
-/* Match an individual register number and assign to \var */
-#define _IFC_REG(n)				\
-	".ifc	\\r, $r" #n "\n\t"		\
-	"\\var	= " #n "\n\t"			\
-	".endif\n\t"
-
-__asm__(".macro	parse_r var r\n\t"
-	"\\var	= -1\n\t"
-	_IFC_REG(0)  _IFC_REG(1)  _IFC_REG(2)  _IFC_REG(3)
-	_IFC_REG(4)  _IFC_REG(5)  _IFC_REG(6)  _IFC_REG(7)
-	_IFC_REG(8)  _IFC_REG(9)  _IFC_REG(10) _IFC_REG(11)
-	_IFC_REG(12) _IFC_REG(13) _IFC_REG(14) _IFC_REG(15)
-	_IFC_REG(16) _IFC_REG(17) _IFC_REG(18) _IFC_REG(19)
-	_IFC_REG(20) _IFC_REG(21) _IFC_REG(22) _IFC_REG(23)
-	_IFC_REG(24) _IFC_REG(25) _IFC_REG(26) _IFC_REG(27)
-	_IFC_REG(28) _IFC_REG(29) _IFC_REG(30) _IFC_REG(31)
-	".iflt	\\var\n\t"
-	".error	\"Unable to parse register name \\r\"\n\t"
-	".endif\n\t"
-	".endm");
-
-#undef _IFC_REG
-
 /* CPUCFG */
 #define read_cpucfg(reg) __cpucfg(reg)
 

---
base-commit: 68800bf8cd1a5e392089f10c58730a4e6a82e41d
change-id: 20230905-loongarch-fix-clang-lto-parse_r-8b48f71eeeac

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

