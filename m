Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11DA2EAEA;
	Fri, 24 Nov 2023 19:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vGovsuPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43A0C433C8;
	Fri, 24 Nov 2023 19:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853392;
	bh=mW9Q2X+82V10ODppgLXk3jJEv43rjZx/EDdgRZzkjMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vGovsuPrS/dqyM7Uzs5kS8o7nk3YHK2412c/4A9vOGYT+OENm/UHRsBDOz5g2Athz
	 ttIdROhFtHU1zS+jDozj0AqmBlG3+CJKRtfYxZaBTfWn6HjHCeUyZQSVcdAIC507TZ
	 AqshFWvMBhJR77PVImMlBfTLM9Kx1m3Zeen515uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	jirislaby@kernel.org,
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: [PATCH 5.15 170/297] tty/sysrq: replace smp_processor_id() with get_cpu()
Date: Fri, 24 Nov 2023 17:53:32 +0000
Message-ID: <20231124172006.208722231@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

commit dd976a97d15b47656991e185a94ef42a0fa5cfd4 upstream.

The smp_processor_id() shouldn't be called from preemptible code.
Instead use get_cpu() and put_cpu() which disables preemption in
addition to getting the processor id. Enable preemption back after
calling schedule_work() to make sure that the work gets scheduled on all
cores other than the current core. We want to avoid a scenario where
current core's stack trace is printed multiple times and one core's
stack trace isn't printed because of scheduling of current task.

This fixes the following bug:

[  119.143590] sysrq: Show backtrace of all active CPUs
[  119.143902] BUG: using smp_processor_id() in preemptible [00000000] code: bash/873
[  119.144586] caller is debug_smp_processor_id+0x20/0x30
[  119.144827] CPU: 6 PID: 873 Comm: bash Not tainted 5.10.124-dirty #3
[  119.144861] Hardware name: QEMU QEMU Virtual Machine, BIOS 2023.05-1 07/22/2023
[  119.145053] Call trace:
[  119.145093]  dump_backtrace+0x0/0x1a0
[  119.145122]  show_stack+0x18/0x70
[  119.145141]  dump_stack+0xc4/0x11c
[  119.145159]  check_preemption_disabled+0x100/0x110
[  119.145175]  debug_smp_processor_id+0x20/0x30
[  119.145195]  sysrq_handle_showallcpus+0x20/0xc0
[  119.145211]  __handle_sysrq+0x8c/0x1a0
[  119.145227]  write_sysrq_trigger+0x94/0x12c
[  119.145247]  proc_reg_write+0xa8/0xe4
[  119.145266]  vfs_write+0xec/0x280
[  119.145282]  ksys_write+0x6c/0x100
[  119.145298]  __arm64_sys_write+0x20/0x30
[  119.145315]  el0_svc_common.constprop.0+0x78/0x1e4
[  119.145332]  do_el0_svc+0x24/0x8c
[  119.145348]  el0_svc+0x10/0x20
[  119.145364]  el0_sync_handler+0x134/0x140
[  119.145381]  el0_sync+0x180/0x1c0

Cc: jirislaby@kernel.org
Cc: stable@vger.kernel.org
Fixes: 47cab6a722d4 ("debug lockups: Improve lockup detection, fix generic arch fallback")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Link: https://lore.kernel.org/r/20231009162021.3607632-1-usama.anjum@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/sysrq.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -263,13 +263,14 @@ static void sysrq_handle_showallcpus(int
 		if (in_hardirq())
 			regs = get_irq_regs();
 
-		pr_info("CPU%d:\n", smp_processor_id());
+		pr_info("CPU%d:\n", get_cpu());
 		if (regs)
 			show_regs(regs);
 		else
 			show_stack(NULL, NULL, KERN_INFO);
 
 		schedule_work(&sysrq_showallcpus);
+		put_cpu();
 	}
 }
 


