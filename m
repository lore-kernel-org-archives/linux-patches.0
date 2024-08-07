Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876EA81AB1;
	Wed,  7 Aug 2024 15:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043146; cv=none; b=QBZAXYECqIcgQ/gCPDg5G4m33eqMNktAiRPMWoRgHbZLemjlLQ0EkWlpvlR2xugV/iJN0PVpY+Ov7bne6ZYg9E1lMLCMRt2Me4ItSb70SmchXvAeAt+y8HJLCre8Fs7NUT4ZjKhIv5PEvcIS/1O4LfIWNpD16INgoFtWdLwKwkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043146; c=relaxed/simple;
	bh=99fnrKr/ED1gaMfrx/qNtgchem7D3l8/sWjEEXQPeNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUndHfl4npA2cO84Z74ZrOokfvLoII/rllfeIwhX2Rg6+BMS0XduE3CS3DT0zx33jvs7L/x/NAG63MZr79jg54Q6brK3+6cF9CGmsMb98nlEQOD3sAC3wBex+3A3mZAEVhKOuFoHplvAn8TzscSKfdOKSjTdRwhxHqd227uOMtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zAlBK/SY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zAlBK/SY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF96C32781;
	Wed,  7 Aug 2024 15:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043146;
	bh=99fnrKr/ED1gaMfrx/qNtgchem7D3l8/sWjEEXQPeNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zAlBK/SY5gekUIzP/6yQT7+HfwXpERd9lWPDfWFI3pcnSxvScqQZau5vwJBbsYgIY
	 ArUQ80Cb8mMHbp5iD7rIDDnAZ935OoWEBWwYVnzomOygFL94B9A6bdI+/3yYohdPt/
	 gAlLGkJzruguSje+zax+W7nXUHOIPCmC8RbE/H6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhe Qiao <qiaozhe@iscas.ac.cn>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 071/123] riscv/mm: Add handling for VM_FAULT_SIGSEGV in mm_fault_error()
Date: Wed,  7 Aug 2024 16:59:50 +0200
Message-ID: <20240807150023.099930927@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5224f37338022..a9f2b4af8f3f1 100644
--- a/arch/riscv/mm/fault.c
+++ b/arch/riscv/mm/fault.c
@@ -61,26 +61,27 @@ static inline void no_context(struct pt_regs *regs, unsigned long addr)
 
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
 	} else if (fault & (VM_FAULT_SIGBUS | VM_FAULT_HWPOISON | VM_FAULT_HWPOISON_LARGE)) {
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



