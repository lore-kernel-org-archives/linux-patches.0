Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4433B269D03;
	Tue,  8 Apr 2025 12:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116742; cv=none; b=PYf3aCB3EzU+IUzz6A9W5NWiPnmtvrrXqmmgFGZX2sgC4CkoT2XL2CMQJye4lpBgVZvGgehfh8Fh5BVpCE5f0BUgYPFF68REJVjuzf7ayfNkfptXgA/OHu4tNS+4XyAQlJuk8ItxZwKZN2kXMxAy2SBCPaIn0MHVMANRkW0Zaqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116742; c=relaxed/simple;
	bh=5Ovo2ivKI0MVqwdXB0rqK1mXRhcOUO2Yf9BBh5xCjAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqwcG3FnyL02+qzLMWHFI6RXFUqTTeLyUhaf7JJg5jv4UBAF1L3dBtNIm+riQqTvyiNt+yJ5hj7QvuREWWdcZ0weOAF2cHVox4bHw00zAY9bg1ARcnOSacekyjUR7lbqgq8RYQtGIkf8fPCh7MEk4WUTNyR8QdfhIIdk4zUB1qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JNR1zehX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JNR1zehX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9E1C4CEE5;
	Tue,  8 Apr 2025 12:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116742;
	bh=5Ovo2ivKI0MVqwdXB0rqK1mXRhcOUO2Yf9BBh5xCjAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JNR1zehXLYJUrprNbbX8iywVLxY3qNHYC8Ev0GZXAiB46ERWXfowm89XYJ7Gw+G2z
	 WT3kAr6vbOhPXXwb7wf7iJ0a0ri+D8VpGHkw8AwUEDlZo3c+YjwwZA4rci4+p76W0T
	 a+wB1r1R9iXO/IaivA5ftFo50XdgiRgqJFAjltKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 251/423] objtool/loongarch: Add unwind hints in prepare_frametrace()
Date: Tue,  8 Apr 2025 12:49:37 +0200
Message-ID: <20250408104851.584258286@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 7c977393b8277ed319e92e4b598b26598c9d30c0 ]

If 'regs' points to a local stack variable, prepare_frametrace() stores
all registers to the stack.  This confuses objtool as it expects them to
be restored from the stack later.

The stores don't affect stack tracing, so use unwind hints to hide them
from objtool.

Fixes the following warnings:

  arch/loongarch/kernel/traps.o: warning: objtool: show_stack+0xe0: stack state mismatch: reg1[22]=-1+0 reg2[22]=-2-160
  arch/loongarch/kernel/traps.o: warning: objtool: show_stack+0xe0: stack state mismatch: reg1[23]=-1+0 reg2[23]=-2-152

Fixes: cb8a2ef0848c ("LoongArch: Add ORC stack unwinder support")
Reported-by: kernel test robot <lkp@intel.com>
Tested-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/270cadd8040dda74db2307f23497bb68e65db98d.1743481539.git.jpoimboe@kernel.org
Closes: https://lore.kernel.org/oe-kbuild-all/202503280703.OARM8SrY-lkp@intel.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/stacktrace.h   |  3 +++
 arch/loongarch/include/asm/unwind_hints.h | 10 +++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/include/asm/stacktrace.h b/arch/loongarch/include/asm/stacktrace.h
index f23adb15f418f..fc8b64773794a 100644
--- a/arch/loongarch/include/asm/stacktrace.h
+++ b/arch/loongarch/include/asm/stacktrace.h
@@ -8,6 +8,7 @@
 #include <asm/asm.h>
 #include <asm/ptrace.h>
 #include <asm/loongarch.h>
+#include <asm/unwind_hints.h>
 #include <linux/stringify.h>
 
 enum stack_type {
@@ -43,6 +44,7 @@ int get_stack_info(unsigned long stack, struct task_struct *task, struct stack_i
 static __always_inline void prepare_frametrace(struct pt_regs *regs)
 {
 	__asm__ __volatile__(
+		UNWIND_HINT_SAVE
 		/* Save $ra */
 		STORE_ONE_REG(1)
 		/* Use $ra to save PC */
@@ -80,6 +82,7 @@ static __always_inline void prepare_frametrace(struct pt_regs *regs)
 		STORE_ONE_REG(29)
 		STORE_ONE_REG(30)
 		STORE_ONE_REG(31)
+		UNWIND_HINT_RESTORE
 		: "=m" (regs->csr_era)
 		: "r" (regs->regs)
 		: "memory");
diff --git a/arch/loongarch/include/asm/unwind_hints.h b/arch/loongarch/include/asm/unwind_hints.h
index a01086ad9ddea..2c68bc72736c9 100644
--- a/arch/loongarch/include/asm/unwind_hints.h
+++ b/arch/loongarch/include/asm/unwind_hints.h
@@ -23,6 +23,14 @@
 	UNWIND_HINT sp_reg=ORC_REG_SP type=UNWIND_HINT_TYPE_CALL
 .endm
 
-#endif /* __ASSEMBLY__ */
+#else /* !__ASSEMBLY__ */
+
+#define UNWIND_HINT_SAVE \
+	UNWIND_HINT(UNWIND_HINT_TYPE_SAVE, 0, 0, 0)
+
+#define UNWIND_HINT_RESTORE \
+	UNWIND_HINT(UNWIND_HINT_TYPE_RESTORE, 0, 0, 0)
+
+#endif /* !__ASSEMBLY__ */
 
 #endif /* _ASM_LOONGARCH_UNWIND_HINTS_H */
-- 
2.39.5



