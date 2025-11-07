Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B34730F941;
	Fri,  7 Nov 2025 21:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762552630; cv=none; b=bPWrBF+MvYYh/h5F3U1SqpRqj2iNa0FgynoS0Vs2fReHsNBC+kr/t3SIJSXvhfWrVY7PUhqQP48MpQh681j8lnG71YJcBZS+3glYlmxEjDm1d348I4J5r+OHzdSG5JP+DKtA5NCnNLOx8L2IQJoETY5okCxGy/XFMhjJs3eTqxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762552630; c=relaxed/simple;
	bh=Xkt+of8KxrqMro0Ntcjzu/R8T+v1krSu+SWLso+jtvE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=RaJ5/9l9EGb6/bA+073Sam9Kcwygv3uyQxhrUocAMXkhxNw4ZenhNex0vpE1Nnz4OJogKIu6/eZOXxayPOdBXfYAx3s1vVN54CcP8jkj9Da/P7zS1ZHMiqaokwl4KU6KF4vwO5k6gUyKcYcoDPNaaULusk2pycRWCjZWkn41rD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eUGErAHX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eUGErAHX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB72BC4CEF7;
	Fri,  7 Nov 2025 21:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762552630;
	bh=Xkt+of8KxrqMro0Ntcjzu/R8T+v1krSu+SWLso+jtvE=;
	h=From:Date:Subject:To:Cc:From;
	b=eUGErAHXK2x/+G8M7EcDFbx+giSXDUAc4NNp9fY2jxETB2kFEo+UAyss0DFFjz6Z0
	 zRXewVmUxciyGbWFGrVjQvYIfPiSPRqS4Jx6uBfDAg8qbGTmYGAPU6U9iiC+nDZCBT
	 n9rEN+lfrSXK5KA4z1Pp9QMQRVUPKUVT/aXeV/Sg+QHwgDIwUfReqBAaTLSOsm9mEN
	 E/caEEHTk/1s4DVR7L9Q1QNgpLHdXI4CRTtVbF/9jvlluoOq/xkEmKo+FfYRgJ2/5B
	 FCFfeLjnOMGJRc9fHYeJsC6DxToyVCvhBwD/P8BKD7alwER6fGUfysol05GHIrBBOE
	 6drHIiez785bg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 07 Nov 2025 14:56:59 -0700
Subject: [PATCH fixes] riscv: Fix CONFIG_AS_HAS_INSN for new .insn usage
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20251107-riscv-fix-new-insn-usage-v1-1-9a186c5928a0@kernel.org>
X-B4-Tracking: v=1; b=H4sIACprDmkC/yWMQQqDQAxFryJZG5iJ2JFepbiQMdZsokyoFWTub
 mh3/8F7/wLjImzwbC4ofIjJpg6xbSCvk74ZZXYGCtTHGBIWsXzgIicqf1HUFD82uUf0iF1KmeZ
 uAM/3wm79rl/wX2OtN4W/7sZxAAAA
X-Change-ID: 20251107-riscv-fix-new-insn-usage-2261377c2d38
To: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Alexandre Ghiti <alex@ghiti.fr>
Cc: Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Andrew Jones <ajones@ventanamicro.com>, 
 Ben Dooks <ben.dooks@codethink.co.uk>, linux-riscv@lists.infradead.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3034; i=nathan@kernel.org;
 h=from:subject:message-id; bh=Xkt+of8KxrqMro0Ntcjzu/R8T+v1krSu+SWLso+jtvE=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDJl82cZmFkwsb82PlhVoueaXBP/W9w2dbr77/GZVFcVJO
 Xx+BnwdpSwMYlwMsmKKLNWPVY8bGs45y3jj1CSYOaxMIEMYuDgFYCJfdBkZJkczznOM73faWvRV
 SFVn9+G8y1eF2F89D3W439KYkaW2iZFhP9+kbYp3uLvCKhZliUjnTrb6uGRtnrD14SlOlxhUuix
 4AQ==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After commit 44aa25c000b4 ("riscv: asm: use .insn for making custom
instructions"), builds using LLVM older that 19 or binutils older than
2.38 fail with:

  arch/riscv/include/asm/vdso/processor.h: Assembler messages:
  arch/riscv/include/asm/vdso/processor.h:27: Error: unrecognized opcode `0x100000f'
  arch/riscv/include/asm/vdso/processor.h:27: Error: unrecognized opcode `0x100000f'
  arch/riscv/include/asm/vdso/processor.h:27: Error: unrecognized opcode `0x100000f'
  arch/riscv/include/asm/vdso/processor.h:27: Error: unrecognized opcode `0x100000f'
  make[4]: *** [scripts/Makefile.build:287: arch/riscv/kernel/vdso/vgettimeofday.o] Error 1

  In file included from <built-in>:4:
  In file included from lib/vdso/gettimeofday.c:6:
  In file included from include/vdso/datapage.h:21:
  In file included from include/vdso/processor.h:10:
  arch/riscv/include/asm/vdso/processor.h:23:2: error: expected instruction format
     23 |         ALT_RISCV_PAUSE();
        |         ^
  arch/riscv/include/asm/errata_list.h:47:3: note: expanded from macro 'ALT_RISCV_PAUSE'
     47 |                 RISCV_PAUSE, /* Original RISC‑V pause insn */ \
        |                 ^
  arch/riscv/include/asm/insn-def.h:259:21: note: expanded from macro 'RISCV_PAUSE'
    259 | #define RISCV_PAUSE     ASM_INSN_I("0x100000f")
        |                         ^
  arch/riscv/include/asm/asm.h:16:26: note: expanded from macro 'ASM_INSN_I'
     16 | #define ASM_INSN_I(__x) ".insn " __x
        |                          ^
  <inline asm>:5:7: note: instantiated into assembly here
      5 | .insn 0x100000f
        |       ^

binutils gained support for '.insn <value>' in 2.38 [1] and LLVM gained
support in 19 [2]. Adjust the test for CONFIG_AS_HAS_INSN to ensure that
all versions of .insn are supported before being used.

Fixes: 44aa25c000b4 ("riscv: asm: use .insn for making custom instructions")
Link: https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=a262b82fdbf4cda3b0648b1adc32245ca3f78b7a [1]
Link: https://github.com/llvm/llvm-project/commit/2a086dce691e3cc34a2fc27f4fb255bb2cbbfac9 [2]
Suggested-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/riscv/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 22cda9c452d2..fadec20b87a8 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -367,7 +367,7 @@ config RISCV_NONSTANDARD_CACHE_OPS
 	  systems to handle cache management.
 
 config AS_HAS_INSN
-	def_bool $(as-instr,.insn r 51$(comma) 0$(comma) 0$(comma) t0$(comma) t0$(comma) zero)
+	def_bool $(as-instr,.insn 0x100000f)
 
 config AS_HAS_OPTION_ARCH
 	# https://github.com/llvm/llvm-project/commit/9e8ed3403c191ab9c4903e8eeb8f732ff8a43cb4

---
base-commit: a882126c42fc53275ac91969d460d939191db7b0
change-id: 20251107-riscv-fix-new-insn-usage-2261377c2d38

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

