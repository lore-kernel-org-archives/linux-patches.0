Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1314F187FEC;
	Tue, 30 Jul 2024 16:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355337; cv=none; b=TWjEZ9IimS1iwZaqtlD3akqmJDbKbOQgSX+ELUzub1ZD6xDoARvwVEMhUA8u++/foxBU6cAy8n+D600GZsprWIUU+I8wvs9yDhEsWl/hMa2CTghNrw1NrloaBAeu+TjJPsForKmQH1hBqmnO924AcGY6fJCK68Y+kOTHE8V5hrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355337; c=relaxed/simple;
	bh=oocCd/P5ukromBPGWa72hjSXMxJLx8zldo3UN0d5Rmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDul7iW8uAVI7aOo8AVmkmQ9z0Qme3tZXg+XjrHv/rHE7xBmCTi34y3MGCvyN83E3FfWMWnsecGBIAon9nP/wtaeaDM3ClNz/f5XQA+as/sJsCThRMckKdeZ1o0veGiwaVQh7U8cEdrIVDjFUjOn58hXAU68+hwubJT5hxHbHNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HNXRTFSY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNXRTFSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45591C32782;
	Tue, 30 Jul 2024 16:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355336;
	bh=oocCd/P5ukromBPGWa72hjSXMxJLx8zldo3UN0d5Rmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HNXRTFSYbX42qGMps+35mku/M9mDg5+FKCvR8JhSOmE8OPeRK5Y84V7GTcLIiwlXb
	 GIt1zDoK/K375BHtCHCETcvxjHxllftOmm8eaPt2bex6xbM1uPgaVk4zB3C+CUzPpO
	 2qo6kyEeQh2AM8zkl7KmmKUgSQNhywlEqS08kpkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Buddhabhatti <jay.buddhabhatti@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/568] soc: xilinx: rename cpu_number1 to dummy_cpu_number
Date: Tue, 30 Jul 2024 17:42:36 +0200
Message-ID: <20240730151641.755684818@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
index 042553abe1bf8..098a2ecfd5c68 100644
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



