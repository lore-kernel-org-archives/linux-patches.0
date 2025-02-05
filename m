Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63F7170A37;
	Wed,  5 Feb 2025 15:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768067; cv=none; b=Yk+HNB1mXjT65RF7F07b+z09RWMVQPrOZRssP/GnYrW/4n0hPRegF2yrlecDyxv+C8rLf+pYp6giaHfNdTpHzNfUMw9xV5ZI/3JfpjARFP3JT754kJKm0h1KI6TyVvs94VHgjpDPB8zj1Gn55arTiIxZVdgV+hJFOG0+Ee/SykM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768067; c=relaxed/simple;
	bh=beNGa3uQONwQYJn6AVvwfrwzvEttVIsd2I8v+GHhSzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNDlpx+mi3wz8ikz8ZdwS3r6xwxWzcM5Y7OI89bf054dVQXEPyUIH1Zcsacknt4AMnIWhm3sWS+vgaK6ELkMlpIgmriHnWB7te1G2Pm+UpwOGVO8LLUkDj3W4Hb2TxQnUtsX2SiEvPN1q1Q57wqp02JMX9lIALt/zNammkq0a/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QoVPmF1t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QoVPmF1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C856CC4CED1;
	Wed,  5 Feb 2025 15:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768067;
	bh=beNGa3uQONwQYJn6AVvwfrwzvEttVIsd2I8v+GHhSzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QoVPmF1tm/tnnFjnH3HNYGMF7vkOormhBvXjz6pd9NnB4OWsvCbzjrmc4GyW+PZeI
	 rnNAfFvkURt/ZtvlDhbS48Fi3HFKFI5MJxn5lHzVvzoevvdCCVdmAsWdRHxI+WCLDD
	 JjTR+b02UFauv8pmwPuCveNMcGWq3GQTvzPOYBFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 491/623] LoongArch: Fix warnings during S3 suspend
Date: Wed,  5 Feb 2025 14:43:53 +0100
Message-ID: <20250205134515.001664428@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 26c0a2d93af55d30a46d5f45d3e9c42cde730168 ]

The enable_gpe_wakeup() function calls acpi_enable_all_wakeup_gpes(),
and the later one may call the preempt_schedule_common() function,
resulting in a thread switch and causing the CPU to be in an interrupt
enabled state after the enable_gpe_wakeup() function returns, leading
to the warnings as follow.

[ C0] WARNING: ... at kernel/time/timekeeping.c:845 ktime_get+0xbc/0xc8
[ C0]          ...
[ C0] Call Trace:
[ C0] [<90000000002243b4>] show_stack+0x64/0x188
[ C0] [<900000000164673c>] dump_stack_lvl+0x60/0x88
[ C0] [<90000000002687e4>] __warn+0x8c/0x148
[ C0] [<90000000015e9978>] report_bug+0x1c0/0x2b0
[ C0] [<90000000016478e4>] do_bp+0x204/0x3b8
[ C0] [<90000000025b1924>] exception_handlers+0x1924/0x10000
[ C0] [<9000000000343bbc>] ktime_get+0xbc/0xc8
[ C0] [<9000000000354c08>] tick_sched_timer+0x30/0xb0
[ C0] [<90000000003408e0>] __hrtimer_run_queues+0x160/0x378
[ C0] [<9000000000341f14>] hrtimer_interrupt+0x144/0x388
[ C0] [<9000000000228348>] constant_timer_interrupt+0x38/0x48
[ C0] [<90000000002feba4>] __handle_irq_event_percpu+0x64/0x1e8
[ C0] [<90000000002fed48>] handle_irq_event_percpu+0x20/0x80
[ C0] [<9000000000306b9c>] handle_percpu_irq+0x5c/0x98
[ C0] [<90000000002fd4a0>] generic_handle_domain_irq+0x30/0x48
[ C0] [<9000000000d0c7b0>] handle_cpu_irq+0x70/0xa8
[ C0] [<9000000001646b30>] handle_loongarch_irq+0x30/0x48
[ C0] [<9000000001646bc8>] do_vint+0x80/0xe0
[ C0] [<90000000002aea1c>] finish_task_switch.isra.0+0x8c/0x2a8
[ C0] [<900000000164e34c>] __schedule+0x314/0xa48
[ C0] [<900000000164ead8>] schedule+0x58/0xf0
[ C0] [<9000000000294a2c>] worker_thread+0x224/0x498
[ C0] [<900000000029d2f0>] kthread+0xf8/0x108
[ C0] [<9000000000221f28>] ret_from_kernel_thread+0xc/0xa4
[ C0]
[ C0] ---[ end trace 0000000000000000 ]---

The root cause is acpi_enable_all_wakeup_gpes() uses a mutex to protect
acpi_hw_enable_all_wakeup_gpes(), and acpi_ut_acquire_mutex() may cause
a thread switch. Since there is no longer concurrent execution during
loongarch_acpi_suspend(), we can call acpi_hw_enable_all_wakeup_gpes()
directly in enable_gpe_wakeup().

The solution is similar to commit 22db06337f590d01 ("ACPI: sleep: Avoid
breaking S3 wakeup due to might_sleep()").

Fixes: 366bb35a8e48 ("LoongArch: Add suspend (ACPI S3) support")
Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/power/platform.c | 2 +-
 drivers/acpi/acpica/achware.h   | 2 --
 include/acpi/acpixf.h           | 1 +
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/loongarch/power/platform.c b/arch/loongarch/power/platform.c
index 0909729dc2e15..5bbdb9fd76e5d 100644
--- a/arch/loongarch/power/platform.c
+++ b/arch/loongarch/power/platform.c
@@ -17,7 +17,7 @@ void enable_gpe_wakeup(void)
 	if (acpi_gbl_reduced_hardware)
 	       return;
 
-	acpi_enable_all_wakeup_gpes();
+	acpi_hw_enable_all_wakeup_gpes();
 }
 
 void enable_pci_wakeup(void)
diff --git a/drivers/acpi/acpica/achware.h b/drivers/acpi/acpica/achware.h
index 79bbfe00d241f..b8543a34caead 100644
--- a/drivers/acpi/acpica/achware.h
+++ b/drivers/acpi/acpica/achware.h
@@ -103,8 +103,6 @@ acpi_hw_get_gpe_status(struct acpi_gpe_event_info *gpe_event_info,
 
 acpi_status acpi_hw_enable_all_runtime_gpes(void);
 
-acpi_status acpi_hw_enable_all_wakeup_gpes(void);
-
 u8 acpi_hw_check_all_gpes(acpi_handle gpe_skip_device, u32 gpe_skip_number);
 
 acpi_status
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index d076ebd19a61e..78b24b0904888 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -763,6 +763,7 @@ ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
 						     *event_status))
 ACPI_HW_DEPENDENT_RETURN_UINT32(u32 acpi_dispatch_gpe(acpi_handle gpe_device, u32 gpe_number))
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status acpi_hw_disable_all_gpes(void))
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status acpi_hw_enable_all_wakeup_gpes(void))
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status acpi_disable_all_gpes(void))
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status acpi_enable_all_runtime_gpes(void))
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status acpi_enable_all_wakeup_gpes(void))
-- 
2.39.5



