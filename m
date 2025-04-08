Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19280206F18;
	Tue,  8 Apr 2025 12:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114937; cv=none; b=Qqlb2MwmLYGDcgchGvAtMY52OD+/Il2bOLshCGfUFsdgOnpYGT95ag37KLZi3a0jcf1s7AfWxapghytRjwAy9T5sQWxNCqO8FvqMMFMxxyQbd9x1XzL+OzY4I7E7z/xsbVmtkxcSmSp32mJF0aXxijG4rv6zg+dym0Sj+Vujqvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114937; c=relaxed/simple;
	bh=K9inVwYrVV9IF533pB4r85Q270iX2LjwzaUXgrrZ5OI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XBRrQJc1vu+CrVcHhnhMKYSAeSrQFvPtrOoL0jwVCPWWPLilEqCrM7ppPkZF3509OPcdXE96QIJU/2HHshH8TaQAt8CRQxAz8IluyFkjZ3prrpzDUbgYEMo0nHSgjQFY3OZVR46Cj5c4S9NiXAYKaiz8L3CtjyLMqKDzhrGG0xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SDfjA4M/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SDfjA4M/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1674C4CEE5;
	Tue,  8 Apr 2025 12:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114937;
	bh=K9inVwYrVV9IF533pB4r85Q270iX2LjwzaUXgrrZ5OI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SDfjA4M/naDV5BnSGIRgPOJP1koCSOitZjv7MVDdU/6RKujDQUsnhZxkHuTZHxt2f
	 xqM/IuX4xzTuQAQJWV1KlI4pLDcWD+3pA976zQYM+wF9BeHxaYYyHPGu1nzjPAavgr
	 dyC9714N65hOPDuyxKKdhZEU74OPfh7g9cnsesGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Winston Wen <wentao@uniontech.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Yuli Wang <wangyuli@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 289/499] LoongArch: Rework the arch_kgdb_breakpoint() implementation
Date: Tue,  8 Apr 2025 12:48:21 +0200
Message-ID: <20250408104858.424055380@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuli Wang <wangyuli@uniontech.com>

[ Upstream commit 29c92a41c6d2879c1f62220fe4758dce191bb38f ]

The arch_kgdb_breakpoint() function defines the kgdb_breakinst symbol
using inline assembly.

1. There's a potential issue where the compiler might inline
arch_kgdb_breakpoint(), which would then define the kgdb_breakinst
symbol multiple times, leading to a linker error.

To prevent this, declare arch_kgdb_breakpoint() as noinline.

Fix follow error with LLVM-19 *only* when LTO_CLANG_FULL:
    LD      vmlinux.o
  ld.lld-19: error: ld-temp.o <inline asm>:3:1: symbol 'kgdb_breakinst' is already defined
  kgdb_breakinst: break 2
  ^

2. Remove "nop" in the inline assembly because it's meaningless for
LoongArch here.

3. Add "STACK_FRAME_NON_STANDARD" for arch_kgdb_breakpoint() to avoid
the objtool warning.

Fixes: e14dd076964e ("LoongArch: Add basic KGDB & KDB support")
Tested-by: Binbin Zhou <zhoubinbin@loongson.cn>
Co-developed-by: Winston Wen <wentao@uniontech.com>
Signed-off-by: Winston Wen <wentao@uniontech.com>
Co-developed-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Yuli Wang <wangyuli@uniontech.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/kgdb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/kernel/kgdb.c b/arch/loongarch/kernel/kgdb.c
index 445c452d72a79..7be5b4c0c9002 100644
--- a/arch/loongarch/kernel/kgdb.c
+++ b/arch/loongarch/kernel/kgdb.c
@@ -8,6 +8,7 @@
 #include <linux/hw_breakpoint.h>
 #include <linux/kdebug.h>
 #include <linux/kgdb.h>
+#include <linux/objtool.h>
 #include <linux/processor.h>
 #include <linux/ptrace.h>
 #include <linux/sched.h>
@@ -224,13 +225,13 @@ void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long pc)
 	regs->csr_era = pc;
 }
 
-void arch_kgdb_breakpoint(void)
+noinline void arch_kgdb_breakpoint(void)
 {
 	__asm__ __volatile__ (			\
 		".globl kgdb_breakinst\n\t"	\
-		"nop\n"				\
 		"kgdb_breakinst:\tbreak 2\n\t"); /* BRK_KDB = 2 */
 }
+STACK_FRAME_NON_STANDARD(arch_kgdb_breakpoint);
 
 /*
  * Calls linux_debug_hook before the kernel dies. If KGDB is enabled,
-- 
2.39.5



