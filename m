Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434973DB8D
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQjlbqNc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5973C433CA;
	Wed, 15 Nov 2023 19:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076079;
	bh=6xd0LZZ3dDEtlyJKd9qI/iysLNaGFjsRWD2l8QF5nec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IQjlbqNcSMcjFPxh59IaL7myk64JhB7ydV5946styOfFLFSsT2npg3RmqK04K/ZSN
	 2VgzMY0+BKEwU8ycaT9JhbvhSFN0XybTPIVsF5ruCSBzGZJuNiyKgx3vql1ZGGXX1o
	 JWdOGaYLtl+PpuschJEYWNoW8Gryj66R7jMQoUO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Michael Kelley <mikelley@microsoft.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 026/550] x86/apic: Fake primary thread mask for XEN/PV
Date: Wed, 15 Nov 2023 14:10:10 -0500
Message-ID: <20231115191602.535505989@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 965e05ff8af98c44f9937366715c512000373164 ]

The SMT control mechanism got added as speculation attack vector
mitigation. The implemented logic relies on the primary thread mask to
be set up properly.

This turns out to be an issue with XEN/PV guests because their CPU hotplug
mechanics do not enumerate APICs and therefore the mask is never correctly
populated.

This went unnoticed so far because by chance XEN/PV ends up with
smp_num_siblings == 2. So cpu_smt_control stays at its default value
CPU_SMT_ENABLED and the primary thread mask is never evaluated in the
context of CPU hotplug.

This stopped "working" with the upcoming overhaul of the topology
evaluation which legitimately provides a fake topology for XEN/PV. That
sets smp_num_siblings to 1, which causes the core CPU hot-plug core to
refuse to bring up the APs.

This happens because cpu_smt_control is set to CPU_SMT_NOT_SUPPORTED which
causes cpu_bootable() to evaluate the unpopulated primary thread mask with
the conclusion that all non-boot CPUs are not valid to be plugged.

The core code has already been made more robust against this kind of fail,
but the primary thread mask really wants to be populated to avoid other
issues all over the place.

Just fake the mask by pretending that all XEN/PV vCPUs are primary threads,
which is consistent because all of XEN/PVs topology is fake or non-existent.

Fixes: 6a4d2657e048 ("x86/smp: Provide topology_is_primary_thread()")
Fixes: f54d4434c281 ("x86/apic: Provide cpu_primary_thread mask")
Reported-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Juergen Gross <jgross@suse.com>
Tested-by: Sohil Mehta <sohil.mehta@intel.com>
Tested-by: Michael Kelley <mikelley@microsoft.com>
Tested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Zhang Rui <rui.zhang@intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20230814085112.210011520@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/apic/apic.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index af49e24b46a43..7e0c7fbdc7d08 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -36,6 +36,8 @@
 #include <linux/smp.h>
 #include <linux/mm.h>
 
+#include <xen/xen.h>
+
 #include <asm/trace/irq_vectors.h>
 #include <asm/irq_remapping.h>
 #include <asm/pc-conf-reg.h>
@@ -2408,6 +2410,15 @@ static int __init smp_init_primary_thread_mask(void)
 {
 	unsigned int cpu;
 
+	/*
+	 * XEN/PV provides either none or useless topology information.
+	 * Pretend that all vCPUs are primary threads.
+	 */
+	if (xen_pv_domain()) {
+		cpumask_copy(&__cpu_primary_thread_mask, cpu_possible_mask);
+		return 0;
+	}
+
 	for (cpu = 0; cpu < nr_logical_cpuids; cpu++)
 		cpu_mark_primary_thread(cpu, cpuid_to_apicid[cpu]);
 	return 0;
-- 
2.42.0



