Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7476E41220;
	Tue,  5 Dec 2023 23:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ofJioA7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1C2C43391;
	Tue,  5 Dec 2023 23:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701820441;
	bh=ba9h7X86HRdFrwM84UeL/FEcVW5UbtpdyhVkFXYpoFE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ofJioA7ajxhroSG6pbg/v8t+WNd/24XLW0AF0EDyyzI4OweyCQPg1OC3rqxd/9aSs
	 vdnCDjHBHy6iKqW25viUm1LzyKW7Wtzw6CKu2uWJ3rGmn8hYcTZyxkzfBewIbYn9Om
	 v07FRFNDn/hX3VcWF8p/03ruM7F+KySYEFZFLYfm+f4uFkVGHo6YJ0S+IOG65U0L1g
	 +RvSA5jp1INWT+ybaGEksBn4lLL8VJKrycF7vgNBFZqcuFakAoTH1isQDhKwJCx6/+
	 39e+BrunYszmi9AmAHVfk8clcznqyz/J7huKOKJZbDwm/lwfNU17lMRYrUfZJ1MHJ8
	 AKbgIq0y0w7+A==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 05 Dec 2023 16:53:52 -0700
Subject: [PATCH v2 3/3] lib/Kconfig.debug: Update AS_HAS_NON_CONST_LEB128
 comment and name
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231205-riscv-restrict-dwarf5-llvm-v2-3-aedf00a382ac@kernel.org>
References: <20231205-riscv-restrict-dwarf5-llvm-v2-0-aedf00a382ac@kernel.org>
In-Reply-To: <20231205-riscv-restrict-dwarf5-llvm-v2-0-aedf00a382ac@kernel.org>
To: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
 conor@kernel.org
Cc: maskray@google.com, ndesaulniers@google.com, 
 linux-riscv@lists.infradead.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.12.4
X-Developer-Signature: v=1; a=openpgp-sha256; l=2652; i=nathan@kernel.org;
 h=from:subject:message-id; bh=ba9h7X86HRdFrwM84UeL/FEcVW5UbtpdyhVkFXYpoFE=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKn5O8Qtlz4tNM1ofLfhkoW1Ra3BRw8Z+ZPiPIJGdWf+3
 v9beFaxo5SFQYyLQVZMkaX6sepxQ8M5ZxlvnJoEM4eVCWQIAxenAExkfx8jw0Orx23NbNlW184l
 5S84tcruQCJzEdOSHROtlAVzt5qfO8TIMLdBiV1lV5pEhq1rolvs3x69kOiqkt8fzQ9dCpol8T6
 FBwA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Fangrui noted that the comment around CONFIG_AS_HAS_NON_CONST_LEB128
could be made more accurate because explicit .sleb128 directives are not
emitted, only .uleb128 directives are. Rename the symbol to
CONFIG_AS_HAS_NON_CONST_ULEB128 as a result.

Further clarifications include replacing "symbol deltas" with the more
accurate "label differences", noting that this issue has been resolved
in newer binutils (2.41+), and it only occurs when a port uses RISC-V
style linker relaxation.

Suggested-by: Fangrui Song <maskray@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 lib/Kconfig.debug | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a0ebce05a368..76c2cc697573 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -231,9 +231,10 @@ config DEBUG_INFO
 	  in the "Debug information" choice below, indicating that debug
 	  information will be generated for build targets.
 
-# Clang is known to generate .{s,u}leb128 with symbol deltas with DWARF5, which
-# some targets may not support: https://sourceware.org/bugzilla/show_bug.cgi?id=27215
-config AS_HAS_NON_CONST_LEB128
+# Clang generates .uleb128 with label differences for DWARF v5, a feature that
+# older binutils ports do not support when utilizing RISC-V style linker
+# relaxation: https://sourceware.org/bugzilla/show_bug.cgi?id=27215
+config AS_HAS_NON_CONST_ULEB128
 	def_bool $(as-instr,.uleb128 .Lexpr_end4 - .Lexpr_start3\n.Lexpr_start3:\n.Lexpr_end4:)
 
 choice
@@ -258,7 +259,7 @@ config DEBUG_INFO_NONE
 config DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
 	bool "Rely on the toolchain's implicit default DWARF version"
 	select DEBUG_INFO
-	depends on !CC_IS_CLANG || AS_IS_LLVM || CLANG_VERSION < 140000 || (AS_IS_GNU && AS_VERSION >= 23502 && AS_HAS_NON_CONST_LEB128)
+	depends on !CC_IS_CLANG || AS_IS_LLVM || CLANG_VERSION < 140000 || (AS_IS_GNU && AS_VERSION >= 23502 && AS_HAS_NON_CONST_ULEB128)
 	help
 	  The implicit default version of DWARF debug info produced by a
 	  toolchain changes over time.
@@ -283,7 +284,7 @@ config DEBUG_INFO_DWARF5
 	bool "Generate DWARF Version 5 debuginfo"
 	select DEBUG_INFO
 	depends on !ARCH_HAS_BROKEN_DWARF5
-	depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS_VERSION >= 23502 && AS_HAS_NON_CONST_LEB128)
+	depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS_VERSION >= 23502 && AS_HAS_NON_CONST_ULEB128)
 	help
 	  Generate DWARF v5 debug info. Requires binutils 2.35.2, gcc 5.0+ (gcc
 	  5.0+ accepts the -gdwarf-5 flag but only had partial support for some

-- 
2.43.0

