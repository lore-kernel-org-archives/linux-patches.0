Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999B438757B;
	Tue, 10 Mar 2026 11:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141265; cv=none; b=qU5Asb9bm+6Wzm/hdGYxvdHWSjDek7lNOmhK8ajaERk1PBnkJuEkPcYV6BVpI+dUn0uLU1PuPfiemUpP93oAC/nLPuLmIK+8zP1ra8YrkGqbHFO8SS+Ehwb4D0JrgaTkbjQJ6J+5p/LYjAYAr29XdmgDJM66GHOm+huEAWqTYYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141265; c=relaxed/simple;
	bh=FyT5hmKPAB0nOCLNkGpfu5Lq8+FVO/JKVyTxk3n6cEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSeXcwW5deGvr4oHjVFWY7kfWUGPSHOCMYnha/GHHEpfArhSXjwS9k7SsvsCn/9yxnltpXZQok0bq09bQNGdZKH6CPacbQfVEiK3ff2uHNGS471yteyB7axrBYoavSCIxv2I22OFFiqujKIU5HKwUPv7y3zo5+goeJbIIAZe8Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R1LgDeFE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R1LgDeFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3585BC2BCAF;
	Tue, 10 Mar 2026 11:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141265;
	bh=FyT5hmKPAB0nOCLNkGpfu5Lq8+FVO/JKVyTxk3n6cEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R1LgDeFEqRjskEpqMvmC82vuiyg9yjm0CJjIY/3QQmiTJOoqEiUen6rtEK03u7C2C
	 jD6LsPkVPTiPrD0NN9pCgZDOLZlUUfziU1/tFz1zc+WVMYW7y3DEDwaMAuITkrhqbl
	 W/NfXVs35htqgQj/XXIfOORQua05vaKkJeQmrS48nsI/j54mDPJprP+OVSwzcEY2r2
	 4xYbqfUA4hSJH6Hy6VRGP725E2e/ZGFclzGeENxMt2Hp7mRsVlXUzyiwP95kBFh5G5
	 wNRqX28PN8Pw0Lel5DDNp+MKWweKdoJd8AXmQoU3JEgZg/KMuVpyzm/Q01RCakP3Vf
	 Qp3bCPwBTT2OQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Tony Luck <tony.luck@intel.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Kyle Meyer <kyle.meyer@hpe.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 267/311] x86/topo: Add topology_num_nodes_per_package()
Date: Tue, 10 Mar 2026 07:05:14 -0400
Message-ID: <f303dea6b2a09db6f07b531e5cb55ed820be617a.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit ae6730ff42b3a13d94b405edeb5e40108b6d21b6 ]

Use the MADT and SRAT table data to compute __num_nodes_per_package.

Specifically, SRAT has already been parsed in x86_numa_init(), which is called
before acpi_boot_init() which parses MADT. So both are available in
topology_init_possible_cpus().

This number is useful to divinate the various Intel CoD/SNC and AMD NPS modes,
since the platforms are failing to provide this otherwise.

Doing it this way is independent of the number of online CPUs and
other such shenanigans.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Tony Luck <tony.luck@intel.com>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Chen Yu <yu.c.chen@intel.com>
Tested-by: Kyle Meyer <kyle.meyer@hpe.com>
Link: https://patch.msgid.link/20260303110100.004091624@infradead.org
Stable-dep-of: 528d89a4707e ("x86/topo: Fix SNC topology mess")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/topology.h |  6 ++++++
 arch/x86/kernel/cpu/common.c    |  3 +++
 arch/x86/kernel/cpu/topology.c  | 13 +++++++++++--
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 1fadf0cf520c5..0ba9bdb998717 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -155,6 +155,7 @@ extern unsigned int __max_logical_packages;
 extern unsigned int __max_threads_per_core;
 extern unsigned int __num_threads_per_package;
 extern unsigned int __num_cores_per_package;
+extern unsigned int __num_nodes_per_package;
 
 const char *get_topology_cpu_type_name(struct cpuinfo_x86 *c);
 enum x86_topology_cpu_type get_topology_cpu_type(struct cpuinfo_x86 *c);
@@ -179,6 +180,11 @@ static inline unsigned int topology_num_threads_per_package(void)
 	return __num_threads_per_package;
 }
 
+static inline unsigned int topology_num_nodes_per_package(void)
+{
+	return __num_nodes_per_package;
+}
+
 #ifdef CONFIG_X86_LOCAL_APIC
 int topology_get_logical_id(u32 apicid, enum x86_topology_domains at_level);
 #else
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e7ab22fce3b57..5edafdc9680f1 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -95,6 +95,9 @@ EXPORT_SYMBOL(__max_dies_per_package);
 unsigned int __max_logical_packages __ro_after_init = 1;
 EXPORT_SYMBOL(__max_logical_packages);
 
+unsigned int __num_nodes_per_package __ro_after_init = 1;
+EXPORT_SYMBOL(__num_nodes_per_package);
+
 unsigned int __num_cores_per_package __ro_after_init = 1;
 EXPORT_SYMBOL(__num_cores_per_package);
 
diff --git a/arch/x86/kernel/cpu/topology.c b/arch/x86/kernel/cpu/topology.c
index 23190a786d310..eafcb1fc185ad 100644
--- a/arch/x86/kernel/cpu/topology.c
+++ b/arch/x86/kernel/cpu/topology.c
@@ -31,6 +31,7 @@
 #include <asm/mpspec.h>
 #include <asm/msr.h>
 #include <asm/smp.h>
+#include <asm/numa.h>
 
 #include "cpu.h"
 
@@ -492,11 +493,19 @@ void __init topology_init_possible_cpus(void)
 	set_nr_cpu_ids(allowed);
 
 	cnta = domain_weight(TOPO_PKG_DOMAIN);
-	cntb = domain_weight(TOPO_DIE_DOMAIN);
 	__max_logical_packages = cnta;
+
+	pr_info("Max. logical packages: %3u\n", __max_logical_packages);
+
+	cntb = num_phys_nodes();
+	__num_nodes_per_package = DIV_ROUND_UP(cntb, cnta);
+
+	pr_info("Max. logical nodes:    %3u\n", cntb);
+	pr_info("Num. nodes per package:%3u\n", __num_nodes_per_package);
+
+	cntb = domain_weight(TOPO_DIE_DOMAIN);
 	__max_dies_per_package = 1U << (get_count_order(cntb) - get_count_order(cnta));
 
-	pr_info("Max. logical packages: %3u\n", cnta);
 	pr_info("Max. logical dies:     %3u\n", cntb);
 	pr_info("Max. dies per package: %3u\n", __max_dies_per_package);
 
-- 
2.51.0

