Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D023A1CB324;
	Tue, 30 Jul 2024 16:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355254; cv=none; b=OUQh0iENkAuhhgoS/I3DgISGsScwcBljK3EdFQ69BYJX5ZgHkWAENMBCcRegbqG1XDKE3Li+1B+j7mxyiI3WjkShxWXclpKRyG3pCa6Wi8A3hjpjBhAlflBIx5WqIXqH1iK4GI5PNariiEBCO3LTKPWR1X5mH9vsnRocLGQ+wpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355254; c=relaxed/simple;
	bh=9B5G9xRK/4nVOZPUYz7lSVVXmMgFnscjOfP+CRuBxwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJEInUt37W8U3zh+sfUmOlbxjuKHH8PUGke8roh09r5vNIKWRPIzAkfWophYmMu8IoGWBimAvVu6Q8HhuMk4g7UXepzMQRaI8v9CRH419SsD0fjWgNszB2yaX4cml07+QtX2r1yZUwOzlw010XDGhEJ9VOLkwZab4uOKqbq7hxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dpaKmFnW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dpaKmFnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FCDAC32782;
	Tue, 30 Jul 2024 16:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355254;
	bh=9B5G9xRK/4nVOZPUYz7lSVVXmMgFnscjOfP+CRuBxwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dpaKmFnWT3dSbmN6GdUpIWqNsgimC2GmVqDQE7HoK8foaUbU4X6zK0VRIN23OWgeB
	 o0Jak7hprmSDUy/Vcomn6vkmGfDaeC0dn/oK6E5+cL8G/PyOAe4D1IiiCOi7P7uSyP
	 O6okdwvKXSmkuVzkJYxJDJLbN/dk/cDogs+F4AbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Doug Anderson <dianders@chromium.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 034/809] arm64: smp: Fix missing IPI statistics
Date: Tue, 30 Jul 2024 17:38:30 +0200
Message-ID: <20240730151726.001408855@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 916b93f4e865b35563902f5862b443fc122631b4 ]

commit 83cfac95c018 ("genirq: Allow interrupts to be excluded from
/proc/interrupts") is to avoid IPIs appear twice in /proc/interrupts.
But the commit 331a1b3a836c ("arm64: smp: Add arch support for backtrace
using pseudo-NMI") and commit 2f5cd0c7ffde("arm64: kgdb: Implement
kgdb_roundup_cpus() to enable pseudo-NMI roundup") set CPU_BACKTRACE and
KGDB_ROUNDUP IPIs "IRQ_HIDDEN" flag but not show them in
arch_show_interrupts(), which cause the interrupt kstat_irqs accounting
is missing in display.

Before this patch, CPU_BACKTRACE and KGDB_ROUNDUP IPIs are missing:
	/ # cat /proc/interrupts
	           CPU0       CPU1       CPU2       CPU3
	 11:        466        600        309        332     GICv3  27 Level     arch_timer
	 13:         24          0          0          0     GICv3  33 Level     uart-pl011
	 15:         64          0          0          0     GICv3  78 Edge      virtio0
	 16:          0          0          0          0     GICv3  79 Edge      virtio1
	 17:          0          0          0          0     GICv3  34 Level     rtc-pl031
	 18:          3          3          3          3     GICv3  23 Level     arm-pmu
	 19:          0          0          0          0 9030000.pl061   3 Edge      GPIO Key Poweroff
	IPI0:         7         14          9         26       Rescheduling interrupts
	IPI1:       354         93        233        255       Function call interrupts
	IPI2:         0          0          0          0       CPU stop interrupts
	IPI3:         0          0          0          0       CPU stop (for crash dump) interrupts
	IPI4:         0          0          0          0       Timer broadcast interrupts
	IPI5:         1          0          0          0       IRQ work interrupts
	Err:          0

After this pacth, CPU_BACKTRACE and KGDB_ROUNDUP IPIs are displayed:
	/ # cat /proc/interrupts
	           CPU0       CPU1       CPU2       CPU3
	 11:        393        281        532        449     GICv3  27 Level     arch_timer
	 13:         15          0          0          0     GICv3  33 Level     uart-pl011
	 15:         64          0          0          0     GICv3  78 Edge      virtio0
	 16:          0          0          0          0     GICv3  79 Edge      virtio1
	 17:          0          0          0          0     GICv3  34 Level     rtc-pl031
	 18:          2          2          2          2     GICv3  23 Level     arm-pmu
	 19:          0          0          0          0 9030000.pl061   3 Edge      GPIO Key Poweroff
	IPI0:        11         19          4         23       Rescheduling interrupts
	IPI1:       279        347        222         72       Function call interrupts
	IPI2:         0          0          0          0       CPU stop interrupts
	IPI3:         0          0          0          0       CPU stop (for crash dump) interrupts
	IPI4:         0          0          0          0       Timer broadcast interrupts
	IPI5:         1          0          0          1       IRQ work interrupts
	IPI6:         0          0          0          0       CPU backtrace interrupts
	IPI7:         0          0          0          0       KGDB roundup interrupts
	Err:          0

Fixes: 331a1b3a836c ("arm64: smp: Add arch support for backtrace using pseudo-NMI")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Suggested-by: Doug Anderson <dianders@chromium.org>
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20240620063600.573559-1-ruanjinjie@huawei.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/smp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 31c8b3094dd7b..5de85dccc09cd 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -767,13 +767,15 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 	}
 }
 
-static const char *ipi_types[NR_IPI] __tracepoint_string = {
+static const char *ipi_types[MAX_IPI] __tracepoint_string = {
 	[IPI_RESCHEDULE]	= "Rescheduling interrupts",
 	[IPI_CALL_FUNC]		= "Function call interrupts",
 	[IPI_CPU_STOP]		= "CPU stop interrupts",
 	[IPI_CPU_CRASH_STOP]	= "CPU stop (for crash dump) interrupts",
 	[IPI_TIMER]		= "Timer broadcast interrupts",
 	[IPI_IRQ_WORK]		= "IRQ work interrupts",
+	[IPI_CPU_BACKTRACE]	= "CPU backtrace interrupts",
+	[IPI_KGDB_ROUNDUP]	= "KGDB roundup interrupts",
 };
 
 static void smp_cross_call(const struct cpumask *target, unsigned int ipinr);
@@ -784,7 +786,7 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 {
 	unsigned int cpu, i;
 
-	for (i = 0; i < NR_IPI; i++) {
+	for (i = 0; i < MAX_IPI; i++) {
 		seq_printf(p, "%*s%u:%s", prec - 1, "IPI", i,
 			   prec >= 4 ? " " : "");
 		for_each_online_cpu(cpu)
-- 
2.43.0



