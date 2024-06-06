Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC9719754F;
	Thu,  6 Jun 2024 14:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683759; cv=none; b=LixGxnQc/vh+odISqS2zhVs2UTg7iNhfJ4nmooYpwbTARgRqf6NC4hF7NrBcE9dkLXp0Rv0w/zETxC4/Lwm7jNkG8iDhpwhiWMrKie9uFRf45JPR4FoYUOEBm9FFdQKtJwhXlY6bLhHWJbvPLuA43PMVw9qgzAUhBC/MR+7F+Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683759; c=relaxed/simple;
	bh=gUwmUZP3PzukVvD5RvX3+wlNog+B0NuUhUubJF4eam4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nEUePz7XqaeGnEQ1kEn7f5v9i2HW7mL5MRgzLA/rCTsOgxegFxsxXV8mpBGWMjFVKG+q5I8ml4r57zzJOKb4x9FJCpW0lAWRn3TidkCFQArhJUv1XYvHY0CNss0zdHw6OHPDkhXtnS5wEiMPTZ9mss5loJi8YlYne5SUjl+tIiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xBxvu+9U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xBxvu+9U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60790C2BD10;
	Thu,  6 Jun 2024 14:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683759;
	bh=gUwmUZP3PzukVvD5RvX3+wlNog+B0NuUhUubJF4eam4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xBxvu+9UjCaBgJZQa2UVHBNPWsKMkaLzpN1kDGgC047zvgvao2FDI0Wqjyv98FlfI
	 opSTAT/JfYbPqpW3d77kbuKNlAx37LSoodsX3AgFNQ+tDW9e21tccuVSru2kZN/F1j
	 vQl+iuYHoTECLYA66dCzWOjcYi4GQTj3ruUC1GU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 735/744] riscv: prevent pt_regs corruption for secondary idle threads
Date: Thu,  6 Jun 2024 16:06:47 +0200
Message-ID: <20240606131756.040207070@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Matyukevich <sergey.matyukevich@syntacore.com>

[ Upstream commit a638b0461b58aa3205cd9d5f14d6f703d795b4af ]

Top of the kernel thread stack should be reserved for pt_regs. However
this is not the case for the idle threads of the secondary boot harts.
Their stacks overlap with their pt_regs, so both may get corrupted.

Similar issue has been fixed for the primary hart, see c7cdd96eca28
("riscv: prevent stack corruption by reserving task_pt_regs(p) early").
However that fix was not propagated to the secondary harts. The problem
has been noticed in some CPU hotplug tests with V enabled. The function
smp_callin stored several registers on stack, corrupting top of pt_regs
structure including status field. As a result, kernel attempted to save
or restore inexistent V context.

Fixes: 9a2451f18663 ("RISC-V: Avoid using per cpu array for ordered booting")
Fixes: 2875fe056156 ("RISC-V: Add cpu_ops and modify default booting method")
Signed-off-by: Sergey Matyukevich <sergey.matyukevich@syntacore.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20240523084327.2013211-1-geomatsi@gmail.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/cpu_ops_sbi.c      | 2 +-
 arch/riscv/kernel/cpu_ops_spinwait.c | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kernel/cpu_ops_sbi.c b/arch/riscv/kernel/cpu_ops_sbi.c
index efa0f0816634c..93cbc38d18057 100644
--- a/arch/riscv/kernel/cpu_ops_sbi.c
+++ b/arch/riscv/kernel/cpu_ops_sbi.c
@@ -72,7 +72,7 @@ static int sbi_cpu_start(unsigned int cpuid, struct task_struct *tidle)
 	/* Make sure tidle is updated */
 	smp_mb();
 	bdata->task_ptr = tidle;
-	bdata->stack_ptr = task_stack_page(tidle) + THREAD_SIZE;
+	bdata->stack_ptr = task_pt_regs(tidle);
 	/* Make sure boot data is updated */
 	smp_mb();
 	hsm_data = __pa(bdata);
diff --git a/arch/riscv/kernel/cpu_ops_spinwait.c b/arch/riscv/kernel/cpu_ops_spinwait.c
index d98d19226b5f5..691e0c5366d2b 100644
--- a/arch/riscv/kernel/cpu_ops_spinwait.c
+++ b/arch/riscv/kernel/cpu_ops_spinwait.c
@@ -34,8 +34,7 @@ static void cpu_update_secondary_bootdata(unsigned int cpuid,
 
 	/* Make sure tidle is updated */
 	smp_mb();
-	WRITE_ONCE(__cpu_spinwait_stack_pointer[hartid],
-		   task_stack_page(tidle) + THREAD_SIZE);
+	WRITE_ONCE(__cpu_spinwait_stack_pointer[hartid], task_pt_regs(tidle));
 	WRITE_ONCE(__cpu_spinwait_task_pointer[hartid], tidle);
 }
 
-- 
2.43.0



