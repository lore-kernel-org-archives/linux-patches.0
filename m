Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5087C35DA65;
	Thu,  2 Jul 2026 16:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010081; cv=none; b=esQdppQDHHmpNaF4uX7CjSMjTAPBfjTvmziUcF43Y5uLVafshjGZBZm1SkTrRUSf6N/Yi+pRWFjLBOCnCegNNypSpNAcAimjcwKPd0U86Etm4Etv2lYqE/nKkeOfYcUKXB9P8vDBoWaMszj0sbMJ3MXITxmbLdfZZQmpJ/a5frk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010081; c=relaxed/simple;
	bh=M+w7wxgLxEuNCCXCC7otThJ8OORuxdzxmfceCv6juRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQaJPd+vPJl/nojUlUd+IibtdtkWdrt4uy4L87Fqp9DzJur4wIIw8CwLJ5lb8PuLWA+p6gW5+zZtFQfJmLruMuFwWyysMtko0uoM+r9vIlyBw/TpVCty0gambqCvqHoNQrX70A6Dc+CIxFuFEGtf0PyMkGtoUO2rmE8kjY+nB/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MbVkHvus; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MbVkHvus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60BC1F000E9;
	Thu,  2 Jul 2026 16:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010080;
	bh=M3CMol38hFy4xPkNzMKhV/jgd3wKfzHEOsxiaywAjWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MbVkHvusozd7QsOE2nGQFqelw39yF0g1A9JtSooaDQEBZ9tgkPBsbvV4k422ac1Ik
	 MpZ4rEpOguZlG6vSeX4XUD74V++EDPPVcUEffuW48RPY8dU7tHz3B1muTQK0zqeTO8
	 zcwthv/JoQ3mjdyKdEvAZC9B6Kj4e2ohtxX4zmKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Jelonek <jelonek.jonas@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.1 101/129] MIPS: smp: report dying CPU to RCU in stop_this_cpu()
Date: Thu,  2 Jul 2026 18:20:20 +0200
Message-ID: <20260702155114.234260002@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jonas Jelonek <jelonek.jonas@gmail.com>

commit 9f3f3bdc6d9dac1a5a8262ee7ad0f2ff1527a7e7 upstream.

smp_send_stop() parks all secondary CPUs in stop_this_cpu(). The function
marks the CPU offline for the scheduler via set_cpu_online(false) but
never informs RCU, so RCU keeps expecting a quiescent state from CPUs
that are now spinning forever with interrupts disabled.

As long as nothing waits for an RCU grace period after smp_send_stop()
this is harmless, which is why it went unnoticed. Since commit
91840be8f710 ("irq_work: Fix use-after-free in irq_work_single() on PREEMPT_RT")
however, irq_work_sync() calls synchronize_rcu() on architectures without
an irq_work self-IPI, i.e. where arch_irq_work_has_interrupt() returns
false. That is the asm-generic default used by MIPS. Any irq_work_sync()
issued in the reboot/shutdown path after smp_send_stop() then blocks on
a grace period that can never complete, hanging the reboot:

  WARNING: CPU: 0 PID: 15 at kernel/irq_work.c:144 irq_work_queue_on
  ...
  rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
  rcu: Offline CPU 1 blocking current GP.
  rcu: Offline CPU 2 blocking current GP.
  rcu: Offline CPU 3 blocking current GP.

This issue was noticed on several Realtek MIPS switch SoCs (MIPS
interAptiv) and came up during kernel bump downstream in OpenWrt from
6.18.33 to 6.18.34, after the backport of the patch to the 6.18 stable
branch. The patch also has been backported all the way back to 6.1.

Call rcutree_report_cpu_dead() once interrupts are disabled, mirroring the
generic CPU-hotplug offline path, so RCU stops waiting on the parked CPUs
and grace periods can still complete. MIPS shuts down all CPUs here
without going through the CPU-hotplug mechanism, so this report is not
otherwise issued. Reporting a dying CPU to RCU outside the regular hotplug
offline path is not unprecedented: arm64 does the same in cpu_die_early().
There it is an exception for a CPU that was coming online and is aborting
bringup, rather than the default shutdown action as on MIPS.

Fixes: 91840be8f710 ("irq_work: Fix use-after-free in irq_work_single() on PREEMPT_RT")
CC: stable@vger.kernel.org
Signed-off-by: Jonas Jelonek <jelonek.jonas@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/kernel/smp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -19,6 +19,7 @@
 #include <linux/sched/mm.h>
 #include <linux/cpumask.h>
 #include <linux/cpu.h>
+#include <linux/rcupdate.h>
 #include <linux/err.h>
 #include <linux/ftrace.h>
 #include <linux/irqdomain.h>
@@ -392,6 +393,7 @@ static void stop_this_cpu(void *dummy)
 	set_cpu_online(smp_processor_id(), false);
 	calculate_cpu_foreign_map();
 	local_irq_disable();
+	rcutree_report_cpu_dead();
 	while (1);
 }
 


