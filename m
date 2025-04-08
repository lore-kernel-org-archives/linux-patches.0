Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F15F2638B8;
	Tue,  8 Apr 2025 12:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115070; cv=none; b=rQlpAP+TQ9IEKxtmllBwE5ecJv+adfmXtfBzDrnTMczuDRKSWwmY7F7csX2C0M5aMdJ6J8/P0Aqh6X/1wX2neRbbBcTAgmoe8KdZlzlgcAJo0lzHwSm9XXsqX6fD1ZhtTeEoYR1OkJr6RwrCxOpoeJUaY2XFbm9Zn+7VeZ0fnAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115070; c=relaxed/simple;
	bh=Al2ZnEHR5TetOzIxVZ/BkKR1/BTLuA4syuMjSqzQd70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=brDXr48kuvEefX8JBRLxADeIznXwk3Cuiuk736lb90SuYK9aFBeqI+dzb9TUhhRxe9ov9j9uE9JDruK1F8VWwkbKhmGKS0wtkFBM8dnEZu2X1Ughd+f5pyRJN3KA8eRELZlaj0tgjaXsg6j/kybHd/GOmyjmH3U5miB8JfjIwzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0plPLLqA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0plPLLqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B5CC4CEE5;
	Tue,  8 Apr 2025 12:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115070;
	bh=Al2ZnEHR5TetOzIxVZ/BkKR1/BTLuA4syuMjSqzQd70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0plPLLqARwCoaF6WBkvmKyDO2CMC5GjWXggC4F+Y83dcfIP14BeiOPAYLLBFmjZ4a
	 OtV3G4LmZuYh0LhddV2s8hNmnmd4fOLeboqC62TDb++TttrQ27aUJ/QaXgE3HhTDla
	 7HHoR/fQEQe7vlMRpx+untmQ+V4jrs1MjoUBvjNA=
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
Subject: [PATCH 6.13 298/499] objtool/loongarch: Add unwind hints in prepare_frametrace()
Date: Tue,  8 Apr 2025 12:48:30 +0200
Message-ID: <20250408104858.647827756@linuxfoundation.org>
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



