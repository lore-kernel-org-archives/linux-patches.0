Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966B2D512
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5BFC433D2;
	Mon, 15 May 2023 16:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168451;
	bh=+5mz1x5jdiJpnkBFiD3RXZakAi3ujrJ1uSjpm7EZesU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=icYiWScBOmSkMRAgwS+9BSA4zciv20T5vJ1KntxPijeHUGnC+3SkJCmPiORkR91Tm
	 nxAU9cWXnDx+gsOn5VZAzDepezBGjqEjZ9t539lKLUPFE22c/Aw7deJG0cwHWXcJ0B
	 PD5v2tGN+4NwCXgONW8dSxc1yDD/92jgLJIiqdXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Li <liwei391@huawei.com>,
	Sumit Garg <sumit.garg@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 026/116] arm64: kgdb: Set PSTATE.SS to 1 to re-enable single-step
Date: Mon, 15 May 2023 18:25:23 +0200
Message-Id: <20230515161659.149231862@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161658.228491273@linuxfoundation.org>
References: <20230515161658.228491273@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sumit Garg <sumit.garg@linaro.org>

[ Upstream commit af6c0bd59f4f3ad5daad2f7b777954b1954551d5 ]

Currently only the first attempt to single-step has any effect. After
that all further stepping remains "stuck" at the same program counter
value.

Refer to the ARM Architecture Reference Manual (ARM DDI 0487E.a) D2.12,
PSTATE.SS=1 should be set at each step before transferring the PE to the
'Active-not-pending' state. The problem here is PSTATE.SS=1 is not set
since the second single-step.

After the first single-step, the PE transferes to the 'Inactive' state,
with PSTATE.SS=0 and MDSCR.SS=1, thus PSTATE.SS won't be set to 1 due to
kernel_active_single_step()=true. Then the PE transferes to the
'Active-pending' state when ERET and returns to the debugger by step
exception.

Before this patch:
==================
Entering kdb (current=0xffff3376039f0000, pid 1) on processor 0 due to Keyboard Entry
[0]kdb>

[0]kdb>
[0]kdb> bp write_sysrq_trigger
Instruction(i) BP #0 at 0xffffa45c13d09290 (write_sysrq_trigger)
    is enabled   addr at ffffa45c13d09290, hardtype=0 installed=0

[0]kdb> go
$ echo h > /proc/sysrq-trigger

Entering kdb (current=0xffff4f7e453f8000, pid 175) on processor 1 due to Breakpoint @ 0xffffad651a309290
[1]kdb> ss

Entering kdb (current=0xffff4f7e453f8000, pid 175) on processor 1 due to SS trap @ 0xffffad651a309294
[1]kdb> ss

Entering kdb (current=0xffff4f7e453f8000, pid 175) on processor 1 due to SS trap @ 0xffffad651a309294
[1]kdb>

After this patch:
=================
Entering kdb (current=0xffff6851c39f0000, pid 1) on processor 0 due to Keyboard Entry
[0]kdb> bp write_sysrq_trigger
Instruction(i) BP #0 at 0xffffc02d2dd09290 (write_sysrq_trigger)
    is enabled   addr at ffffc02d2dd09290, hardtype=0 installed=0

[0]kdb> go
$ echo h > /proc/sysrq-trigger

Entering kdb (current=0xffff6851c53c1840, pid 174) on processor 1 due to Breakpoint @ 0xffffc02d2dd09290
[1]kdb> ss

Entering kdb (current=0xffff6851c53c1840, pid 174) on processor 1 due to SS trap @ 0xffffc02d2dd09294
[1]kdb> ss

Entering kdb (current=0xffff6851c53c1840, pid 174) on processor 1 due to SS trap @ 0xffffc02d2dd09298
[1]kdb> ss

Entering kdb (current=0xffff6851c53c1840, pid 174) on processor 1 due to SS trap @ 0xffffc02d2dd0929c
[1]kdb>

Fixes: 44679a4f142b ("arm64: KGDB: Add step debugging support")
Co-developed-by: Wei Li <liwei391@huawei.com>
Signed-off-by: Wei Li <liwei391@huawei.com>
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Daniel Thompson <daniel.thompson@linaro.org>
Tested-by: Daniel Thompson <daniel.thompson@linaro.org>
Link: https://lore.kernel.org/r/20230202073148.657746-3-sumit.garg@linaro.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/debug-monitors.h | 1 +
 arch/arm64/kernel/debug-monitors.c      | 5 +++++
 arch/arm64/kernel/kgdb.c                | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/arch/arm64/include/asm/debug-monitors.h b/arch/arm64/include/asm/debug-monitors.h
index 41b065f1be88c..13630e8078ff4 100644
--- a/arch/arm64/include/asm/debug-monitors.h
+++ b/arch/arm64/include/asm/debug-monitors.h
@@ -125,6 +125,7 @@ void user_regs_reset_single_step(struct user_pt_regs *regs,
 void kernel_enable_single_step(struct pt_regs *regs);
 void kernel_disable_single_step(void);
 int kernel_active_single_step(void);
+void kernel_rewind_single_step(struct pt_regs *regs);
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 int reinstall_suspended_bps(struct pt_regs *regs);
diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
index 2ccd0a99d8b35..970ce09078873 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -434,6 +434,11 @@ int kernel_active_single_step(void)
 }
 NOKPROBE_SYMBOL(kernel_active_single_step);
 
+void kernel_rewind_single_step(struct pt_regs *regs)
+{
+	set_regs_spsr_ss(regs);
+}
+
 /* ptrace API */
 void user_enable_single_step(struct task_struct *task)
 {
diff --git a/arch/arm64/kernel/kgdb.c b/arch/arm64/kernel/kgdb.c
index 7fd7a9cd86161..05790fce1a854 100644
--- a/arch/arm64/kernel/kgdb.c
+++ b/arch/arm64/kernel/kgdb.c
@@ -223,6 +223,8 @@ int kgdb_arch_handle_exception(int exception_vector, int signo,
 		 */
 		if (!kernel_active_single_step())
 			kernel_enable_single_step(linux_regs);
+		else
+			kernel_rewind_single_step(linux_regs);
 		err = 0;
 		break;
 	default:
-- 
2.39.2



