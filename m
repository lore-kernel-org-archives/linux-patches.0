Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E572A471268;
	Tue, 21 Jul 2026 20:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664850; cv=none; b=C7Jkx+Z5Q3I+e/p7ZWDuBSXUX6Yirqn76R8Vlrlql8Vg7GlvnjM9JfpxgAH10YON8dlTrzPd7uVq0eXnMrKAtw6gQQXSw6coYTVfat9Bm+6OegOjkEYICGH/qkzEiIBOz//80pRH20bXeA0ciYkX/HkU5sT7kHErzIuo+LTfWHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664850; c=relaxed/simple;
	bh=E41Xkq6uIgQPhJYu8pOFPHnqsRSDNhD0o+xaaxoknqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8l+kzrMjc72iUGMO0DmCg58hVKEmHZ27K+8rwo8Sb8a9ZfE2/z2cMKds7H1DJTcrYM89jebY/FICJ1WKgkMWLXGNRCB0+w755qYa8DZ+qJKNN2m2VkJ1RcyUszvUy8SoROpcFPIADKS9maDaVsRBGr+TvXICU2dY+mfhk2nic4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R//XLHMW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R//XLHMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5765C1F00A3A;
	Tue, 21 Jul 2026 20:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664848;
	bh=RcDCDlGscglczBHGc7HvRZ4BYarKH5OhkD0PKM45WAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R//XLHMWZW65b0uH68ljMe7rtkkWTdck00WLOtAw137pcqM4onlRgjozbAY4+7xfe
	 e+VeK7c9kWq7ltXEgIdbBsA3v8ay5ZLtV2HpevxcYURQddXfHVDA1pTeh7RlYAjLD5
	 3o8RDHSg8VcLav2y3M+eRx+Zd2QW7Yu461WcD4f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Jelonek <jelonek.jonas@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0080/1266] MIPS: smp: report dying CPU to RCU in stop_this_cpu()
Date: Tue, 21 Jul 2026 17:08:37 +0200
Message-ID: <20260721152443.589889513@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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

Call rcu_report_dead() once interrupts are disabled, mirroring the
generic CPU-hotplug offline path, so RCU stops waiting on the parked CPUs
and grace periods can still complete. MIPS shuts down all CPUs here
without going through the CPU-hotplug mechanism, so this report is not
otherwise issued. Reporting a dying CPU to RCU outside the regular hotplug
offline path is not unprecedented: arm64 does the same in cpu_die_early().
There it is an exception for a CPU that was coming online and is aborting
bringup, rather than the default shutdown action as on MIPS.

Note: this differs from the upstream commit in that it calls
rcu_report_dead(smp_processor_id()) instead of rcutree_report_cpu_dead().
The latter, along with the rcutree_report_cpu_dead() name, was introduced
by commit 448e9f34d91d ("rcu: Standardize explicit CPU-hotplug calls")
in v6.7; on this kernel the equivalent function is still named
rcu_report_dead() and takes an explicit CPU argument.

Fixes: 91840be8f710 ("irq_work: Fix use-after-free in irq_work_single() on PREEMPT_RT")
Signed-off-by: Jonas Jelonek <jelonek.jonas@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/smp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index 81f6c4f8fbc154..1a3eb4820eb702 100644
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
@@ -410,6 +411,7 @@ static void stop_this_cpu(void *dummy)
 	set_cpu_online(smp_processor_id(), false);
 	calculate_cpu_foreign_map();
 	local_irq_disable();
+	rcu_report_dead(smp_processor_id());
 	while (1);
 }
 
-- 
2.53.0



