Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9974729A2;
	Tue, 30 Jul 2024 15:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354985; cv=none; b=k2/aGzbYvb7Y2DunEVox+XClV1IMhwxfQBJg1RdZb9+iIrqIhq8Kk8gJRuvh64Yacwnb32+AhHM2jG7LwTawKFxcumA4WpJxTpfecLJDykVwEoYM59kZuUYyAgmkFz9gxYfQzKHaIr/CsYGFTfc1rQ1Y3K036TAWn1mSQ1V7YZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354985; c=relaxed/simple;
	bh=JfdRxxe2GGqQen7YpzpFiwMOvRabbsCWRWs6dh6VDbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KgbTfGwjfjKrcu/TmQdQA9hWSdNzRlPgREUAU9ENhSsh9vFMxx4vG1REqcugsvFMHpIshO7/y37f/RYLxshTdtojntPqb+HPfEwiUfeYVoFQuIPiMIDSL10k17gjSTljpG1kTuPx2cRt2e3J2OwR8MwNp6JbYigSI/HczazOi+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C3PkMeJg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C3PkMeJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5CFC32782;
	Tue, 30 Jul 2024 15:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354985;
	bh=JfdRxxe2GGqQen7YpzpFiwMOvRabbsCWRWs6dh6VDbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C3PkMeJg+EV58TqavGMfFjcq3HTNKvSOLDunjUDXRuRvFYFPFAt+Kt3nLLo9bVCmm
	 A9wuWyAPFtCXoRgpgB5u8Kq0u7ZjnrY9VrJTmyEwpec4oIwqPCQXnRPEjsmeptuzX5
	 GF+8ELOV88cOzcjUN3RPJOD2+1oHk1fBmaW5WLWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Buddhabhatti <jay.buddhabhatti@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/440] soc: xilinx: rename cpu_number1 to dummy_cpu_number
Date: Tue, 30 Jul 2024 17:44:37 +0200
Message-ID: <20240730151617.483645032@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Jay Buddhabhatti <jay.buddhabhatti@amd.com>

[ Upstream commit 4a95449dd975e2ea6629a034f3e74b46c9634916 ]

The per cpu variable cpu_number1 is passed to xlnx_event_handler as
argument "dev_id", but it is not used in this function. So drop the
initialization of this variable and rename it to dummy_cpu_number.
This patch is to fix the following call trace when the kernel option
CONFIG_DEBUG_ATOMIC_SLEEP is enabled:

BUG: sleeping function called from invalid context at include/linux/sched/mm.h:274
    in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
    preempt_count: 1, expected: 0
    CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.1.0 #53
    Hardware name: Xilinx Versal vmk180 Eval board rev1.1 (QSPI) (DT)
    Call trace:
     dump_backtrace+0xd0/0xe0
     show_stack+0x18/0x40
     dump_stack_lvl+0x7c/0xa0
     dump_stack+0x18/0x34
     __might_resched+0x10c/0x140
     __might_sleep+0x4c/0xa0
     __kmem_cache_alloc_node+0xf4/0x168
     kmalloc_trace+0x28/0x38
     __request_percpu_irq+0x74/0x138
     xlnx_event_manager_probe+0xf8/0x298
     platform_probe+0x68/0xd8

Fixes: daed80ed0758 ("soc: xilinx: Fix for call trace due to the usage of smp_processor_id()")
Signed-off-by: Jay Buddhabhatti <jay.buddhabhatti@amd.com>
Link: https://lore.kernel.org/r/20240408110610.15676-1-jay.buddhabhatti@amd.com
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/xilinx/xlnx_event_manager.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/soc/xilinx/xlnx_event_manager.c b/drivers/soc/xilinx/xlnx_event_manager.c
index 8293cc40047fa..82e3174740238 100644
--- a/drivers/soc/xilinx/xlnx_event_manager.c
+++ b/drivers/soc/xilinx/xlnx_event_manager.c
@@ -3,6 +3,7 @@
  * Xilinx Event Management Driver
  *
  *  Copyright (C) 2021 Xilinx, Inc.
+ *  Copyright (C) 2024 Advanced Micro Devices, Inc.
  *
  *  Abhyuday Godhasara <abhyuday.godhasara@xilinx.com>
  */
@@ -19,7 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
-static DEFINE_PER_CPU_READ_MOSTLY(int, cpu_number1);
+static DEFINE_PER_CPU_READ_MOSTLY(int, dummy_cpu_number);
 
 static int virq_sgi;
 static int event_manager_availability = -EACCES;
@@ -555,7 +556,6 @@ static void xlnx_disable_percpu_irq(void *data)
 static int xlnx_event_init_sgi(struct platform_device *pdev)
 {
 	int ret = 0;
-	int cpu;
 	/*
 	 * IRQ related structures are used for the following:
 	 * for each SGI interrupt ensure its mapped by GIC IRQ domain
@@ -592,11 +592,8 @@ static int xlnx_event_init_sgi(struct platform_device *pdev)
 	sgi_fwspec.param[0] = sgi_num;
 	virq_sgi = irq_create_fwspec_mapping(&sgi_fwspec);
 
-	cpu = get_cpu();
-	per_cpu(cpu_number1, cpu) = cpu;
 	ret = request_percpu_irq(virq_sgi, xlnx_event_handler, "xlnx_event_mgmt",
-				 &cpu_number1);
-	put_cpu();
+				 &dummy_cpu_number);
 
 	WARN_ON(ret);
 	if (ret) {
@@ -612,16 +609,12 @@ static int xlnx_event_init_sgi(struct platform_device *pdev)
 
 static void xlnx_event_cleanup_sgi(struct platform_device *pdev)
 {
-	int cpu = smp_processor_id();
-
-	per_cpu(cpu_number1, cpu) = cpu;
-
 	cpuhp_remove_state(CPUHP_AP_ONLINE_DYN);
 
 	on_each_cpu(xlnx_disable_percpu_irq, NULL, 1);
 
 	irq_clear_status_flags(virq_sgi, IRQ_PER_CPU);
-	free_percpu_irq(virq_sgi, &cpu_number1);
+	free_percpu_irq(virq_sgi, &dummy_cpu_number);
 	irq_dispose_mapping(virq_sgi);
 }
 
-- 
2.43.0



