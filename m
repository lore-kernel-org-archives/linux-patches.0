Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93FA11F7071;
	Tue,  3 Dec 2024 14:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237789; cv=none; b=YPmVcvSUFW0+Lh7QsmOj/g4l9UMZlvYQGA1efOHXbGQRc7rE4QulbbvcQKCkzvk4mTEMQGgz+GMDkm8RPpk76qveRBuLhu21qmsFjiSxFd4NBrhYoR+wOefdPJQw714AblMzEbI5n3413FJZYEtlDxp0ZlfsGHemTdoYhW8jLts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237789; c=relaxed/simple;
	bh=vs4MY5p1V+1aZTy95OmEHN44awV3OzoWRsu/bHiR0IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwWmAtXHur4nSCdKYhaHH+jNEjjNLeb8ZOO01N81L3M2AUcFkcGhpe78UzACCoFptTlsF7S4figudu/DPHvGCZV5b3vcPybtbnR2R/spPK470Sv/skcJa9uG/8ab6o44igS/JD/pG89N09UUjiuK7OTdisnV1ebok46wetRzj70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NLiT+YO8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NLiT+YO8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C9BC4CED8;
	Tue,  3 Dec 2024 14:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237789;
	bh=vs4MY5p1V+1aZTy95OmEHN44awV3OzoWRsu/bHiR0IA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NLiT+YO8TQkz3juAM17s5kss0veNYo0ZfbS91x/UwHzvNz02yUqhPxJjjoWJNbMem
	 T+G1EcYsiIa5hZ40Xd3Uo79UIZdU69qoMe6Frh+fO4Tlkx9vQukGwpCUcw3o44myiF
	 XeXaswim4z3lgUPOfQTaWufMb4tNoxq3xa5OL6a8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 039/817] LoongArch: For all possible CPUs setup logical-physical CPU mapping
Date: Tue,  3 Dec 2024 15:33:31 +0100
Message-ID: <20241203143957.183967734@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit a6654a40a852a4ca18aacced4cf5ca87997818d7 ]

In order to support ACPI-based physical CPU hotplug, we suppose for all
"possible" CPUs cpu_logical_map() can work. Because some drivers want to
use cpu_logical_map() for all "possible" CPUs, while currently we only
setup logical-physical mapping for "present" CPUs. This lack of mapping
also causes cpu_to_node() cannot work for hot-added CPUs.

All "possible" CPUs are listed in MADT, and the "present" subset is
marked as ACPI_MADT_ENABLED. To setup logical-physical CPU mapping for
all possible CPUs and keep present CPUs continuous in cpu_present_mask,
we parse MADT twice. The first pass handles CPUs with ACPI_MADT_ENABLED
and the second pass handles CPUs without ACPI_MADT_ENABLED.

The global flag (cpu_enumerated) is removed because acpi_map_cpu() calls
cpu_number_map() rather than set_processor_mask() now.

Reported-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/acpi.c | 81 +++++++++++++++++++++++-------------
 arch/loongarch/kernel/smp.c  |  3 +-
 2 files changed, 55 insertions(+), 29 deletions(-)

diff --git a/arch/loongarch/kernel/acpi.c b/arch/loongarch/kernel/acpi.c
index 929a497c987e8..de9e34414e614 100644
--- a/arch/loongarch/kernel/acpi.c
+++ b/arch/loongarch/kernel/acpi.c
@@ -57,48 +57,48 @@ void __iomem *acpi_os_ioremap(acpi_physical_address phys, acpi_size size)
 		return ioremap_cache(phys, size);
 }
 
-static int cpu_enumerated = 0;
-
 #ifdef CONFIG_SMP
-static int set_processor_mask(u32 id, u32 flags)
+static int set_processor_mask(u32 id, u32 pass)
 {
-	int nr_cpus;
-	int cpu, cpuid = id;
-
-	if (!cpu_enumerated)
-		nr_cpus = NR_CPUS;
-	else
-		nr_cpus = nr_cpu_ids;
+	int cpu = -1, cpuid = id;
 
-	if (num_processors >= nr_cpus) {
+	if (num_processors >= NR_CPUS) {
 		pr_warn(PREFIX "nr_cpus limit of %i reached."
-			" processor 0x%x ignored.\n", nr_cpus, cpuid);
+			" processor 0x%x ignored.\n", NR_CPUS, cpuid);
 
 		return -ENODEV;
 
 	}
+
 	if (cpuid == loongson_sysconf.boot_cpu_id)
 		cpu = 0;
-	else
-		cpu = find_first_zero_bit(cpumask_bits(cpu_present_mask), NR_CPUS);
-
-	if (!cpu_enumerated)
-		set_cpu_possible(cpu, true);
 
-	if (flags & ACPI_MADT_ENABLED) {
+	switch (pass) {
+	case 1: /* Pass 1 handle enabled processors */
+		if (cpu < 0)
+			cpu = find_first_zero_bit(cpumask_bits(cpu_present_mask), NR_CPUS);
 		num_processors++;
 		set_cpu_present(cpu, true);
-		__cpu_number_map[cpuid] = cpu;
-		__cpu_logical_map[cpu] = cpuid;
-	} else
+		break;
+	case 2: /* Pass 2 handle disabled processors */
+		if (cpu < 0)
+			cpu = find_first_zero_bit(cpumask_bits(cpu_possible_mask), NR_CPUS);
 		disabled_cpus++;
+		break;
+	default:
+		return cpu;
+	}
+
+	set_cpu_possible(cpu, true);
+	__cpu_number_map[cpuid] = cpu;
+	__cpu_logical_map[cpu] = cpuid;
 
 	return cpu;
 }
 #endif
 
 static int __init
-acpi_parse_processor(union acpi_subtable_headers *header, const unsigned long end)
+acpi_parse_p1_processor(union acpi_subtable_headers *header, const unsigned long end)
 {
 	struct acpi_madt_core_pic *processor = NULL;
 
@@ -109,12 +109,29 @@ acpi_parse_processor(union acpi_subtable_headers *header, const unsigned long en
 	acpi_table_print_madt_entry(&header->common);
 #ifdef CONFIG_SMP
 	acpi_core_pic[processor->core_id] = *processor;
-	set_processor_mask(processor->core_id, processor->flags);
+	if (processor->flags & ACPI_MADT_ENABLED)
+		set_processor_mask(processor->core_id, 1);
 #endif
 
 	return 0;
 }
 
+static int __init
+acpi_parse_p2_processor(union acpi_subtable_headers *header, const unsigned long end)
+{
+	struct acpi_madt_core_pic *processor = NULL;
+
+	processor = (struct acpi_madt_core_pic *)header;
+	if (BAD_MADT_ENTRY(processor, end))
+		return -EINVAL;
+
+#ifdef CONFIG_SMP
+	if (!(processor->flags & ACPI_MADT_ENABLED))
+		set_processor_mask(processor->core_id, 2);
+#endif
+
+	return 0;
+}
 static int __init
 acpi_parse_eio_master(union acpi_subtable_headers *header, const unsigned long end)
 {
@@ -142,12 +159,14 @@ static void __init acpi_process_madt(void)
 	}
 #endif
 	acpi_table_parse_madt(ACPI_MADT_TYPE_CORE_PIC,
-			acpi_parse_processor, MAX_CORE_PIC);
+			acpi_parse_p1_processor, MAX_CORE_PIC);
+
+	acpi_table_parse_madt(ACPI_MADT_TYPE_CORE_PIC,
+			acpi_parse_p2_processor, MAX_CORE_PIC);
 
 	acpi_table_parse_madt(ACPI_MADT_TYPE_EIO_PIC,
 			acpi_parse_eio_master, MAX_IO_PICS);
 
-	cpu_enumerated = 1;
 	loongson_sysconf.nr_cpus = num_processors;
 }
 
@@ -306,6 +325,10 @@ static int __ref acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
 	int nid;
 
 	nid = acpi_get_node(handle);
+
+	if (nid != NUMA_NO_NODE)
+		nid = early_cpu_to_node(cpu);
+
 	if (nid != NUMA_NO_NODE) {
 		set_cpuid_to_node(physid, nid);
 		node_set(nid, numa_nodes_parsed);
@@ -320,12 +343,14 @@ int acpi_map_cpu(acpi_handle handle, phys_cpuid_t physid, u32 acpi_id, int *pcpu
 {
 	int cpu;
 
-	cpu = set_processor_mask(physid, ACPI_MADT_ENABLED);
-	if (cpu < 0) {
+	cpu = cpu_number_map(physid);
+	if (cpu < 0 || cpu >= nr_cpu_ids) {
 		pr_info(PREFIX "Unable to map lapic to logical cpu number\n");
-		return cpu;
+		return -ERANGE;
 	}
 
+	num_processors++;
+	set_cpu_present(cpu, true);
 	acpi_map_cpu2node(handle, cpu, physid);
 
 	*pcpu = cpu;
diff --git a/arch/loongarch/kernel/smp.c b/arch/loongarch/kernel/smp.c
index b1329fe01fae9..5a8cb31a4e6b7 100644
--- a/arch/loongarch/kernel/smp.c
+++ b/arch/loongarch/kernel/smp.c
@@ -325,11 +325,11 @@ void __init loongson_prepare_cpus(unsigned int max_cpus)
 	int i = 0;
 
 	parse_acpi_topology();
+	cpu_data[0].global_id = cpu_logical_map(0);
 
 	for (i = 0; i < loongson_sysconf.nr_cpus; i++) {
 		set_cpu_present(i, true);
 		csr_mail_send(0, __cpu_logical_map[i], 0);
-		cpu_data[i].global_id = __cpu_logical_map[i];
 	}
 
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
@@ -374,6 +374,7 @@ void loongson_init_secondary(void)
 		     cpu_logical_map(cpu) / loongson_sysconf.cores_per_package;
 	cpu_data[cpu].core = pptt_enabled ? cpu_data[cpu].core :
 		     cpu_logical_map(cpu) % loongson_sysconf.cores_per_package;
+	cpu_data[cpu].global_id = cpu_logical_map(cpu);
 }
 
 void loongson_smp_finish(void)
-- 
2.43.0



