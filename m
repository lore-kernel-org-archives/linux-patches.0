Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC4D1974EC;
	Thu,  6 Jun 2024 14:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683088; cv=none; b=dympGYgg3wjDTuRRNfKEF6xCsrKoDNNQddX253NjEd8IrPQjnEs2pPAfgp1NSeS5hHM94m7/YFDfCVrhHyMTFOUqZU84dd7JWaEAJeruyr7agJjhJAQbE2hAhbkcGAlI1zFmu445X13sK798/utAZRxtvFLctgsV003Cwvx9Uv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683088; c=relaxed/simple;
	bh=r/zHN4gnLjcCEtVys50Z/Q4ttAVEkcoPKAgGWRONi2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vn/EFhjfB2iFVwdLtUL5qwBt8vjaNvNphIImqMlECVvULw8MRPnd7fmhY+HXPQxlR4lomJWMY3Dcb2g5bMOvPc1FhLKxTAqbR8QOWs1qT60ldEWov4TVMk04e8GXblUpqAjSo8komS1G4fft5Ql701uOljZcWrbQ2IBGtkkSa+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=17QUd9GU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="17QUd9GU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2C5C32782;
	Thu,  6 Jun 2024 14:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683087;
	bh=r/zHN4gnLjcCEtVys50Z/Q4ttAVEkcoPKAgGWRONi2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=17QUd9GU+hLFuwfz4aEHv7wKAUT3kPUKZYQ59o2hj0f3ImQLHPp2uiRB24hOoQbK9
	 v86d4+vS7wfPSZPoG9SVncuanJJXlsXZckZzhbwmqPd55lgRM3LC/oy12zjluiQIA9
	 JLwQ5Hk2K/3+snZ57VleGRztyp4ga8qv4j+KUHao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carsten Tolkmit <ctolkmit@ennit.de>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.9 368/374] x86/topology: Handle bogus ACPI tables correctly
Date: Thu,  6 Jun 2024 16:05:47 +0200
Message-ID: <20240606131704.204411235@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 9d22c96316ac59ed38e80920c698fed38717b91b upstream.

The ACPI specification clearly states how the processors should be
enumerated in the MADT:

 "To ensure that the boot processor is supported post initialization,
  two guidelines should be followed. The first is that OSPM should
  initialize processors in the order that they appear in the MADT. The
  second is that platform firmware should list the boot processor as the
  first processor entry in the MADT.
  ...
  Failure of OSPM implementations and platform firmware to abide by
  these guidelines can result in both unpredictable and non optimal
  platform operation."

The kernel relies on that ordering to detect the real BSP on crash kernels
which is important to avoid sending a INIT IPI to it as that would cause a
full machine reset.

On a Dell XPS 16 9640 the BIOS ignores this rule and enumerates the CPUs in
the wrong order. As a consequence the kernel falsely detects a crash kernel
and disables the corresponding CPU.

Prevent this by checking the IA32_APICBASE MSR for the BSP bit on the boot
CPU. If that bit is set, then the MADT based BSP detection can be safely
ignored. If the kernel detects a mismatch between the BSP bit and the first
enumerated MADT entry then emit a firmware bug message.

This obviously also has to be taken into account when the boot APIC ID and
the first enumerated APIC ID match. If the boot CPU does not have the BSP
bit set in the APICBASE MSR then there is no way for the boot CPU to
determine which of the CPUs is the real BSP. Sending an INIT to the real
BSP would reset the machine so the only sane way to deal with that is to
limit the number of CPUs to one and emit a corresponding warning message.

Fixes: 5c5682b9f87a ("x86/cpu: Detect real BSP on crash kernels")
Reported-by: Carsten Tolkmit <ctolkmit@ennit.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Carsten Tolkmit <ctolkmit@ennit.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/87le48jycb.ffs@tglx
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218837
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/topology.c | 55 +++++++++++++++++++++++++++++++---
 1 file changed, 51 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/topology.c b/arch/x86/kernel/cpu/topology.c
index d17c9b71eb4a..621a151ccf7d 100644
--- a/arch/x86/kernel/cpu/topology.c
+++ b/arch/x86/kernel/cpu/topology.c
@@ -128,6 +128,9 @@ static void topo_set_cpuids(unsigned int cpu, u32 apic_id, u32 acpi_id)
 
 static __init bool check_for_real_bsp(u32 apic_id)
 {
+	bool is_bsp = false, has_apic_base = boot_cpu_data.x86 >= 6;
+	u64 msr;
+
 	/*
 	 * There is no real good way to detect whether this a kdump()
 	 * kernel, but except on the Voyager SMP monstrosity which is not
@@ -144,17 +147,61 @@ static __init bool check_for_real_bsp(u32 apic_id)
 	if (topo_info.real_bsp_apic_id != BAD_APICID)
 		return false;
 
-	if (apic_id == topo_info.boot_cpu_apic_id) {
-		topo_info.real_bsp_apic_id = apic_id;
-		return false;
+	/*
+	 * Check whether the enumeration order is broken by evaluating the
+	 * BSP bit in the APICBASE MSR. If the CPU does not have the
+	 * APICBASE MSR then the BSP detection is not possible and the
+	 * kernel must rely on the firmware enumeration order.
+	 */
+	if (has_apic_base) {
+		rdmsrl(MSR_IA32_APICBASE, msr);
+		is_bsp = !!(msr & MSR_IA32_APICBASE_BSP);
 	}
 
-	pr_warn("Boot CPU APIC ID not the first enumerated APIC ID: %x > %x\n",
+	if (apic_id == topo_info.boot_cpu_apic_id) {
+		/*
+		 * If the boot CPU has the APIC BSP bit set then the
+		 * firmware enumeration is agreeing. If the CPU does not
+		 * have the APICBASE MSR then the only choice is to trust
+		 * the enumeration order.
+		 */
+		if (is_bsp || !has_apic_base) {
+			topo_info.real_bsp_apic_id = apic_id;
+			return false;
+		}
+		/*
+		 * If the boot APIC is enumerated first, but the APICBASE
+		 * MSR does not have the BSP bit set, then there is no way
+		 * to discover the real BSP here. Assume a crash kernel and
+		 * limit the number of CPUs to 1 as an INIT to the real BSP
+		 * would reset the machine.
+		 */
+		pr_warn("Enumerated BSP APIC %x is not marked in APICBASE MSR\n", apic_id);
+		pr_warn("Assuming crash kernel. Limiting to one CPU to prevent machine INIT\n");
+		set_nr_cpu_ids(1);
+		goto fwbug;
+	}
+
+	pr_warn("Boot CPU APIC ID not the first enumerated APIC ID: %x != %x\n",
 		topo_info.boot_cpu_apic_id, apic_id);
+
+	if (is_bsp) {
+		/*
+		 * The boot CPU has the APIC BSP bit set. Use it and complain
+		 * about the broken firmware enumeration.
+		 */
+		topo_info.real_bsp_apic_id = topo_info.boot_cpu_apic_id;
+		goto fwbug;
+	}
+
 	pr_warn("Crash kernel detected. Disabling real BSP to prevent machine INIT\n");
 
 	topo_info.real_bsp_apic_id = apic_id;
 	return true;
+
+fwbug:
+	pr_warn(FW_BUG "APIC enumeration order not specification compliant\n");
+	return false;
 }
 
 static unsigned int topo_unit_count(u32 lvlid, enum x86_topology_domains at_level,
-- 
2.45.2



