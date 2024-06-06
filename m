Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10201991C4;
	Thu,  6 Jun 2024 14:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683659; cv=none; b=m/jPzDWP9quNB+GWbOqYazR7YlK++GKkWvkDtbJJP35E5TsdKLMY5khkCVLFCALdUlKwa+K5/PsSewW7KVSqDiE9EGfYHbMsPaVVRKypE4GDpGAbJeKLV+9jSghLKYLgIC3Hk6iVX2mhkvfHgfjycxLypkFgLL5xmwhlBRNsFRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683659; c=relaxed/simple;
	bh=Sj8vSD6sCakhz0yspM+kw/uc+3miWQ97I+sUUGsdI6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GnUowsBoVM1RPmniZmZ+lLCH1+dCvqxfNEYd5gKWreq8g4PqipbAxkd3Ob5PxNqzYlzPuoQWMFLCrAqdVdgMHoZZNoEgi+O23+A88I7kMk3z5TVQO1pPL1AoS+sYhUxOQbOqf6IABmcTBMH/G+j06sh59jkVjBIe58O1kLA15Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/6ovY6O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/6ovY6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE78DC32781;
	Thu,  6 Jun 2024 14:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683658;
	bh=Sj8vSD6sCakhz0yspM+kw/uc+3miWQ97I+sUUGsdI6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/6ovY6OOBGVErfAeDcR2GKzCBVAfOUES9QpFzKkVia4eHzznb9h1tcu9Z7miVELQ
	 Wm7tvZsZ0jhtkQUxXNaGs76fqlIAJi9aMze98dv+CXrQVjO3MuK+nyqXH8bDuiBy58
	 dlLrm4BK7NtVy6hY97nKg7Jkzyjq+AYExfzrFIAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 472/473] riscv: prevent pt_regs corruption for secondary idle threads
Date: Thu,  6 Jun 2024 16:06:41 +0200
Message-ID: <20240606131715.289227358@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



