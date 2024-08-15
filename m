Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06927DA7D;
	Thu, 15 Aug 2024 13:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730316; cv=none; b=IAgLLp+8RalrIhauQEBDkbiirR8CnDk9Kvon3HuLs2aKGxIOZf+Txr0+5hQMA9mX1AFZH8neXn2zGraC6K3cL31PprSPbh8GDV6MY40cBujtHH6kOX48eM9QY/tt1pIzRLz7C3KytBLOnZWDwuO2wVc+HBI2vk5MzJ1WZJfRz88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730316; c=relaxed/simple;
	bh=HfiDz/K5yrqG358L+kFX0aWtOoMHEShBG0A09Dp4sis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U9wJSSskVZM1Bc1mhMd65xudTP2Ny8SCXll1ZhZNrEm3EbojUjQBssPCzkWSgcc+P89XEcAIImGFnIzbxeP9HHxPR4GW3p+i0wV67eY/fC14Rkxv6KgoLrXZ279/5B6ENESWsgjjx3vbidL3UlVKCEYqKEA/iEIP7Jj4f3QctRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i2vFwr/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i2vFwr/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28193C32786;
	Thu, 15 Aug 2024 13:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730316;
	bh=HfiDz/K5yrqG358L+kFX0aWtOoMHEShBG0A09Dp4sis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i2vFwr/Bj4f2VMP6B8KPOZXMAvQO+h38e0v1Y0+xJ5/JrggndiKd5Ry7q6z2/jdvl
	 6KlFhy/vOHvpPc01g++Beq8Hf3ae7K/AMYFYgVXYBdKTExyUHkJA6jWry5/tifONkw
	 hfANwUJIigBINcEbYRjCMg0uogLyLBw+ymJu10M4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhe Qiao <qiaozhe@iscas.ac.cn>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 340/484] riscv/mm: Add handling for VM_FAULT_SIGSEGV in mm_fault_error()
Date: Thu, 15 Aug 2024 15:23:18 +0200
Message-ID: <20240815131954.547642753@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 884a3c76573cf..3fc62e05bac11 100644
--- a/arch/riscv/mm/fault.c
+++ b/arch/riscv/mm/fault.c
@@ -60,26 +60,27 @@ static inline void no_context(struct pt_regs *regs, unsigned long addr)
 
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



