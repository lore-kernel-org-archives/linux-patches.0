Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C080E23A3
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 12:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30899C433D6;
	Fri, 28 Oct 2022 12:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666958865;
	bh=+aFTizV0vCk2pV4eNYbyHyxWM8g6bdKNZ9uxhT+vEyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bbmH7cBnLZSthlyfUzuY0S+XWd3wzsVp5N6Ek1yxHpDlauovmFruP+cka+bW8hgFC
	 hufGJ7cVrwrd99rU0raFbnewrybFP8nNqMsRBz5O8MTKjjlXKkGQVKxMyPiUf761pu
	 KGQkkmO1u2DmTIGd1nEY5COUUcbcly4F3VyUa9z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Atish Patra <atishp@rivosinc.com>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 5.10 64/73] arm64: topology: move store_cpu_topology() to shared code
Date: Fri, 28 Oct 2022 14:04:01 +0200
Message-Id: <20221028120235.153028625@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Conor Dooley <conor.dooley@microchip.com>

commit 456797da792fa7cbf6698febf275fe9b36691f78 upstream.

arm64's method of defining a default cpu topology requires only minimal
changes to apply to RISC-V also. The current arm64 implementation exits
early in a uniprocessor configuration by reading MPIDR & claiming that
uniprocessor can rely on the default values.

This is appears to be a hangover from prior to '3102bc0e6ac7 ("arm64:
topology: Stop using MPIDR for topology information")', because the
current code just assigns default values for multiprocessor systems.

With the MPIDR references removed, store_cpu_topolgy() can be moved to
the common arch_topology code.

Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/topology.c |   40 ----------------------------------------
 drivers/base/arch_topology.c |   19 +++++++++++++++++++
 2 files changed, 19 insertions(+), 40 deletions(-)

--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -22,46 +22,6 @@
 #include <asm/cputype.h>
 #include <asm/topology.h>
 
-void store_cpu_topology(unsigned int cpuid)
-{
-	struct cpu_topology *cpuid_topo = &cpu_topology[cpuid];
-	u64 mpidr;
-
-	if (cpuid_topo->package_id != -1)
-		goto topology_populated;
-
-	mpidr = read_cpuid_mpidr();
-
-	/* Uniprocessor systems can rely on default topology values */
-	if (mpidr & MPIDR_UP_BITMASK)
-		return;
-
-	/*
-	 * This would be the place to create cpu topology based on MPIDR.
-	 *
-	 * However, it cannot be trusted to depict the actual topology; some
-	 * pieces of the architecture enforce an artificial cap on Aff0 values
-	 * (e.g. GICv3's ICC_SGI1R_EL1 limits it to 15), leading to an
-	 * artificial cycling of Aff1, Aff2 and Aff3 values. IOW, these end up
-	 * having absolutely no relationship to the actual underlying system
-	 * topology, and cannot be reasonably used as core / package ID.
-	 *
-	 * If the MT bit is set, Aff0 *could* be used to define a thread ID, but
-	 * we still wouldn't be able to obtain a sane core ID. This means we
-	 * need to entirely ignore MPIDR for any topology deduction.
-	 */
-	cpuid_topo->thread_id  = -1;
-	cpuid_topo->core_id    = cpuid;
-	cpuid_topo->package_id = cpu_to_node(cpuid);
-
-	pr_debug("CPU%u: cluster %d core %d thread %d mpidr %#016llx\n",
-		 cpuid, cpuid_topo->package_id, cpuid_topo->core_id,
-		 cpuid_topo->thread_id, mpidr);
-
-topology_populated:
-	update_siblings_masks(cpuid);
-}
-
 #ifdef CONFIG_ACPI
 static bool __init acpi_cpu_is_threaded(int cpu)
 {
--- a/drivers/base/arch_topology.c
+++ b/drivers/base/arch_topology.c
@@ -596,4 +596,23 @@ void __init init_cpu_topology(void)
 	else if (of_have_populated_dt() && parse_dt_topology())
 		reset_cpu_topology();
 }
+
+void store_cpu_topology(unsigned int cpuid)
+{
+	struct cpu_topology *cpuid_topo = &cpu_topology[cpuid];
+
+	if (cpuid_topo->package_id != -1)
+		goto topology_populated;
+
+	cpuid_topo->thread_id = -1;
+	cpuid_topo->core_id = cpuid;
+	cpuid_topo->package_id = cpu_to_node(cpuid);
+
+	pr_debug("CPU%u: package %d core %d thread %d\n",
+		 cpuid, cpuid_topo->package_id, cpuid_topo->core_id,
+		 cpuid_topo->thread_id);
+
+topology_populated:
+	update_siblings_masks(cpuid);
+}
 #endif


