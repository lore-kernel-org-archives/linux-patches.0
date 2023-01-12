Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F0479C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FB2C433D2;
	Thu, 12 Jan 2023 14:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673534210;
	bh=iqwrW3CgJQWwTSrpoF0EThayW2GbJHNbR7LwrhnWWlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJlcH32YOYVza3ioCd4SrEUQmdqatVGB8OJFfsXf1sd7fJkyoGmgT78Wcn4kGudcS
	 T9CtjpGqWRSbUdPnVSTAqlX+KF4ivd5Y+AokaT06I2Ey13hV2wiNClFtSn6DNRkJmL
	 Hybr8hzgaIFIuFRp90ioAxSdi9KijabADg+soFqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 702/783] x86/kprobes: Fix optprobe optimization check with CONFIG_RETHUNK
Date: Thu, 12 Jan 2023 14:56:58 +0100
Message-Id: <20230112135556.888596062@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 63dc6325ff41ee9e570bde705ac34a39c5dbeb44 ]

Since the CONFIG_RETHUNK and CONFIG_SLS will use INT3 for stopping
speculative execution after function return, kprobe jump optimization
always fails on the functions with such INT3 inside the function body.
(It already checks the INT3 padding between functions, but not inside
 the function)

To avoid this issue, as same as kprobes, check whether the INT3 comes
from kgdb or not, and if so, stop decoding and make it fail. The other
INT3 will come from CONFIG_RETHUNK/CONFIG_SLS and those can be
treated as a one-byte instruction.

Fixes: e463a09af2f0 ("x86: Add straight-line-speculation mitigation")
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/167146051929.1374301.7419382929328081706.stgit@devnote3
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/kprobes/opt.c | 28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index 4299fc865732..3d6201492006 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -15,6 +15,7 @@
 #include <linux/extable.h>
 #include <linux/kdebug.h>
 #include <linux/kallsyms.h>
+#include <linux/kgdb.h>
 #include <linux/ftrace.h>
 #include <linux/objtool.h>
 #include <linux/pgtable.h>
@@ -272,19 +273,6 @@ static int insn_is_indirect_jump(struct insn *insn)
 	return ret;
 }
 
-static bool is_padding_int3(unsigned long addr, unsigned long eaddr)
-{
-	unsigned char ops;
-
-	for (; addr < eaddr; addr++) {
-		if (get_kernel_nofault(ops, (void *)addr) < 0 ||
-		    ops != INT3_INSN_OPCODE)
-			return false;
-	}
-
-	return true;
-}
-
 /* Decode whole function to ensure any instructions don't jump into target */
 static int can_optimize(unsigned long paddr)
 {
@@ -327,15 +315,15 @@ static int can_optimize(unsigned long paddr)
 		ret = insn_decode(&insn, (void *)recovered_insn, MAX_INSN_SIZE, INSN_MODE_KERN);
 		if (ret < 0)
 			return 0;
-
+#ifdef CONFIG_KGDB
 		/*
-		 * In the case of detecting unknown breakpoint, this could be
-		 * a padding INT3 between functions. Let's check that all the
-		 * rest of the bytes are also INT3.
+		 * If there is a dynamically installed kgdb sw breakpoint,
+		 * this function should not be probed.
 		 */
-		if (insn.opcode.bytes[0] == INT3_INSN_OPCODE)
-			return is_padding_int3(addr, paddr - offset + size) ? 1 : 0;
-
+		if (insn.opcode.bytes[0] == INT3_INSN_OPCODE &&
+		    kgdb_has_hit_break(addr))
+			return 0;
+#endif
 		/* Recover address */
 		insn.kaddr = (void *)addr;
 		insn.next_byte = (void *)(addr + insn.length);
-- 
2.35.1



