Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731B21898EF;
	Tue, 30 Jul 2024 16:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355560; cv=none; b=QfGqpnbcZVgxGsp7y3WjCk159+HjfhSuK6Dlhr9TKanafglD1wjI1PCWvNuIQs9ikzP1FrEhS+BzPTj1h87K7DnNuW9tplkW0C1+oaPUUOM4cgB/pjU8CYZaUpkWOW8K5eqleTvPmjl3rsjfHXwk+HvVYyeHtT3MWq8R9PqPBKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355560; c=relaxed/simple;
	bh=/zix5YrsPEXjN9y1+0W4iir0zWEnTILrvtKTDL8kWEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IblSvW8Q255R3qUPdUYrqmUFw3usK1tojD+20FEXP20d9Qr58XcKObQUL1JpBlnCru7tmGegOwNUk0LHuzMgLaN58RWlPgQx7oWCaIxYMsBRlYfucveGbbe86rBSjcO6BPxE/0IlQdjA1dyF2vmyWZfaV4jpC37wPVct1gk5oyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vOWa7Jl9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vOWa7Jl9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D3DC4AF0C;
	Tue, 30 Jul 2024 16:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355560;
	bh=/zix5YrsPEXjN9y1+0W4iir0zWEnTILrvtKTDL8kWEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vOWa7Jl9pzgnAD7s1IJcWkbOhWleugrMzD7vg3eAEmut3HyIntp+kG9P7GKLyF5HJ
	 ++1BMFnC/h26cCPPGGNpgGpJrBPD1LMVjj8Pxx0lPrgWPTNuQgbwpExonxDvGa1anz
	 msCcVqz3IKw5QBQ5RPa9RmFd+WUbDTYRDD+f/1A0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Buddhabhatti <jay.buddhabhatti@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 066/809] soc: xilinx: rename cpu_number1 to dummy_cpu_number
Date: Tue, 30 Jul 2024 17:39:02 +0200
Message-ID: <20240730151727.249895776@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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
index 253299e4214d0..366018f6a0ee0 100644
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
@@ -570,7 +571,6 @@ static void xlnx_disable_percpu_irq(void *data)
 static int xlnx_event_init_sgi(struct platform_device *pdev)
 {
 	int ret = 0;
-	int cpu;
 	/*
 	 * IRQ related structures are used for the following:
 	 * for each SGI interrupt ensure its mapped by GIC IRQ domain
@@ -607,11 +607,8 @@ static int xlnx_event_init_sgi(struct platform_device *pdev)
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
@@ -627,16 +624,12 @@ static int xlnx_event_init_sgi(struct platform_device *pdev)
 
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



