Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E625339FDD;
	Fri, 24 Nov 2023 18:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nmSosg4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B1CC433C7;
	Fri, 24 Nov 2023 18:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850789;
	bh=+3FYMxv6Ygctl/GxjzFXxZQxWrVF4iMvOQu03IP/Rrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nmSosg4E30dXUBgbDU9RQeH0L+hNCqSI4G7BUHptV5sJ8Kd3+ZCM1rkFW/FQkVbsB
	 29PvgmUazbeXiMCJHyY2680y4TYPfHEoY7VFOLCeWQ9v/lfhQLSA95XTWMIj4c/UIg
	 G/POlp94PWzdAe5AatLjHMzulkJbW8QeB15cXaLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcaov@gmail.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Guo Ren <guoren@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 165/491] riscv: provide riscv-specific is_trap_insn()
Date: Fri, 24 Nov 2023 17:46:41 +0000
Message-ID: <20231124172029.429389439@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcaov@gmail.com>

[ Upstream commit b701f9e726f0a30a94ea6af596b74c1f07b95b6b ]

uprobes expects is_trap_insn() to return true for any trap instructions,
not just the one used for installing uprobe. The current default
implementation only returns true for 16-bit c.ebreak if C extension is
enabled. This can confuse uprobes if a 32-bit ebreak generates a trap
exception from userspace: uprobes asks is_trap_insn() who says there is no
trap, so uprobes assume a probe was there before but has been removed, and
return to the trap instruction. This causes an infinite loop of entering
and exiting trap handler.

Instead of using the default implementation, implement this function
speficially for riscv with checks for both ebreak and c.ebreak.

Fixes: 74784081aac8 ("riscv: Add uprobes supported")
Signed-off-by: Nam Cao <namcaov@gmail.com>
Tested-by: Björn Töpel <bjorn@rivosinc.com>
Reviewed-by: Guo Ren <guoren@kernel.org>
Link: https://lore.kernel.org/r/20230829083614.117748-1-namcaov@gmail.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/probes/uprobes.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/riscv/kernel/probes/uprobes.c b/arch/riscv/kernel/probes/uprobes.c
index 194f166b2cc40..4b3dc8beaf77d 100644
--- a/arch/riscv/kernel/probes/uprobes.c
+++ b/arch/riscv/kernel/probes/uprobes.c
@@ -3,6 +3,7 @@
 #include <linux/highmem.h>
 #include <linux/ptrace.h>
 #include <linux/uprobes.h>
+#include <asm/insn.h>
 
 #include "decode-insn.h"
 
@@ -17,6 +18,11 @@ bool is_swbp_insn(uprobe_opcode_t *insn)
 #endif
 }
 
+bool is_trap_insn(uprobe_opcode_t *insn)
+{
+	return riscv_insn_is_ebreak(*insn) || riscv_insn_is_c_ebreak(*insn);
+}
+
 unsigned long uprobe_get_swbp_addr(struct pt_regs *regs)
 {
 	return instruction_pointer(regs);
-- 
2.42.0



