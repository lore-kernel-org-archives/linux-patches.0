Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A131DFFB;
	Thu, 15 Aug 2024 14:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732634; cv=none; b=AwAXXhc1+XWisbV6flFi17UkipBtwPPjlQQodxtHQil9aWLlElFb0evTZ+u4LcCEX3vh0IWZjy9NbWDRpiSOsqWt0Jn8AhJzPNWAZq/Jsjk8gWyl5zdE0NRqqDteFPNDEU1Hik7AWmTq9Q04jXshCx9RNrwrIfT0sKiMkhwe11c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732634; c=relaxed/simple;
	bh=V5vVn+W0Va2APEE3Zj9ZSpHpRLQdV0L5tWf3FTWG+n4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWBTY/XN3zmZIqeobLD2uFgTtDjt9YY2DdzeAyL7M0lZGIEyB+JEKdV82njAAsLau/y774FAq+bWuk+7l3tJizo+Tbm/gsfpCZ3j3OZ7OtCYRmdmlXiHqF8lIP12ZlAzwL/gcXBVFkk55pdYZCLsJ+2b/f/HCS95QZ6U5yswX4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GEnRxvKU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GEnRxvKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEADEC32786;
	Thu, 15 Aug 2024 14:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732634;
	bh=V5vVn+W0Va2APEE3Zj9ZSpHpRLQdV0L5tWf3FTWG+n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GEnRxvKUFGJLqHn4seTTHgH5pAoOJqr/aSbegY95yH9zdpNtuIO1QWTH1Zu2Cwpzl
	 J4Z0sgxvNPXG76SgKv75WCu68tC9em2PAru3vIXXrauquDvVFyPMuE0AQTIDsuQey0
	 LcdUecCdv5gwmm6gfKT4CZ5EZpXUG/pfX+LVoBo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhe Qiao <qiaozhe@iscas.ac.cn>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 239/352] riscv/mm: Add handling for VM_FAULT_SIGSEGV in mm_fault_error()
Date: Thu, 15 Aug 2024 15:25:05 +0200
Message-ID: <20240815131928.674448483@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhe Qiao <qiaozhe@iscas.ac.cn>

[ Upstream commit 0c710050c47d45eb77b28c271cddefc5c785cb40 ]

Handle VM_FAULT_SIGSEGV in the page fault path so that we correctly
kill the process and we don't BUG() the kernel.

Fixes: 07037db5d479 ("RISC-V: Paging and MMU")
Signed-off-by: Zhe Qiao <qiaozhe@iscas.ac.cn>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20240731084547.85380-1-qiaozhe@iscas.ac.cn
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/fault.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/mm/fault.c b/arch/riscv/mm/fault.c
index 54b12943cc7b0..9bed320891974 100644
--- a/arch/riscv/mm/fault.c
+++ b/arch/riscv/mm/fault.c
@@ -39,26 +39,27 @@ static inline void no_context(struct pt_regs *regs, unsigned long addr)
 
 static inline void mm_fault_error(struct pt_regs *regs, unsigned long addr, vm_fault_t fault)
 {
+	if (!user_mode(regs)) {
+		no_context(regs, addr);
+		return;
+	}
+
 	if (fault & VM_FAULT_OOM) {
 		/*
 		 * We ran out of memory, call the OOM killer, and return the userspace
 		 * (which will retry the fault, or kill us if we got oom-killed).
 		 */
-		if (!user_mode(regs)) {
-			no_context(regs, addr);
-			return;
-		}
 		pagefault_out_of_memory();
 		return;
 	} else if (fault & VM_FAULT_SIGBUS) {
 		/* Kernel mode? Handle exceptions or die */
-		if (!user_mode(regs)) {
-			no_context(regs, addr);
-			return;
-		}
 		do_trap(regs, SIGBUS, BUS_ADRERR, addr);
 		return;
+	} else if (fault & VM_FAULT_SIGSEGV) {
+		do_trap(regs, SIGSEGV, SEGV_MAPERR, addr);
+		return;
 	}
+
 	BUG();
 }
 
-- 
2.43.0



