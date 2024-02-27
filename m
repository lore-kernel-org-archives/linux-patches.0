Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4273B2F2D;
	Tue, 27 Feb 2024 13:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040893; cv=none; b=FlHnEeKUFtQEjQBjQsEEiZHiELV+aJ5rwmklAtQzZ/yQ3qJPnzPQouGM0AM3BpRzvkj/wUuK790Qvbjf25h5+GVpY+2ILh3y2YC6AqxaZYOOkh8dNAiQArPRqKIdgKAwUsGQyW4/O/A9vNqG/4mOtnXODCTcoy99+DvPHWkNkw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040893; c=relaxed/simple;
	bh=OP+QtjDuCIf05BZ/xSptvcZW7NUMLqX8JxT53hA1htw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UfpFLimseXMt5hUBrMaPIEZu9KDqWXKbGzXzt4KWXaZVsSZgnG7emOY6JS6XPJDkg04tlXetHOP1U+iOrfJb3HLorp9wxQgwfxfEvgqmHLpqylsBqHLZDZIu9hxk7gSISLG+ec5sxptVUyTMVpnD5QAbob2X9yFxJnvJgM02e2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQMsjAOd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQMsjAOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3827C433F1;
	Tue, 27 Feb 2024 13:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040893;
	bh=OP+QtjDuCIf05BZ/xSptvcZW7NUMLqX8JxT53hA1htw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQMsjAOdPSPWAnaosIsffPbPpc2LcolhVGJn5Rz693ciqXGpRFemdqG/4jjTQxJgy
	 /GswKRRu9Q+rqoHS+U3sbVlLwSc99kV+qFAaij63vEdajQmNPPC+YH6nsNw11dtcbF
	 GoYsJsrYVbIPiJM/p+xgGsefeGSR2AoMNpnwxaXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.7 146/334] LoongArch: Update cpu_sibling_map when disabling nonboot CPUs
Date: Tue, 27 Feb 2024 14:20:04 +0100
Message-ID: <20240227131635.169911535@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 752cd08da320a667a833803a8fd6bb266114cce5 upstream.

Update cpu_sibling_map when disabling nonboot CPUs by defining & calling
clear_cpu_sibling_map(), otherwise we get such errors on SMT systems:

jump label: negative count!
WARNING: CPU: 6 PID: 45 at kernel/jump_label.c:263 __static_key_slow_dec_cpuslocked+0xec/0x100
CPU: 6 PID: 45 Comm: cpuhp/6 Not tainted 6.8.0-rc5+ #1340
pc 90000000004c302c ra 90000000004c302c tp 90000001005bc000 sp 90000001005bfd20
a0 000000000000001b a1 900000000224c278 a2 90000001005bfb58 a3 900000000224c280
a4 900000000224c278 a5 90000001005bfb50 a6 0000000000000001 a7 0000000000000001
t0 ce87a4763eb5234a t1 ce87a4763eb5234a t2 0000000000000000 t3 0000000000000000
t4 0000000000000006 t5 0000000000000000 t6 0000000000000064 t7 0000000000001964
t8 000000000009ebf6 u0 9000000001f2a068 s9 0000000000000000 s0 900000000246a2d8
s1 ffffffffffffffff s2 ffffffffffffffff s3 90000000021518c0 s4 0000000000000040
s5 9000000002151058 s6 9000000009828e40 s7 00000000000000b4 s8 0000000000000006
   ra: 90000000004c302c __static_key_slow_dec_cpuslocked+0xec/0x100
  ERA: 90000000004c302c __static_key_slow_dec_cpuslocked+0xec/0x100
 CRMD: 000000b0 (PLV0 -IE -DA +PG DACF=CC DACM=CC -WE)
 PRMD: 00000004 (PPLV0 +PIE -PWE)
 EUEN: 00000000 (-FPE -SXE -ASXE -BTE)
 ECFG: 00071c1c (LIE=2-4,10-12 VS=7)
ESTAT: 000c0000 [BRK] (IS= ECode=12 EsubCode=0)
 PRID: 0014d000 (Loongson-64bit, Loongson-3A6000-HV)
CPU: 6 PID: 45 Comm: cpuhp/6 Not tainted 6.8.0-rc5+ #1340
Stack : 0000000000000000 900000000203f258 900000000179afc8 90000001005bc000
        90000001005bf980 0000000000000000 90000001005bf988 9000000001fe0be0
        900000000224c280 900000000224c278 90000001005bf8c0 0000000000000001
        0000000000000001 ce87a4763eb5234a 0000000007f38000 90000001003f8cc0
        0000000000000000 0000000000000006 0000000000000000 4c206e6f73676e6f
        6f4c203a656d616e 000000000009ec99 0000000007f38000 0000000000000000
        900000000214b000 9000000001fe0be0 0000000000000004 0000000000000000
        0000000000000107 0000000000000009 ffffffffffafdabe 00000000000000b4
        0000000000000006 90000000004c302c 9000000000224528 00005555939a0c7c
        00000000000000b0 0000000000000004 0000000000000000 0000000000071c1c
        ...
Call Trace:
[<9000000000224528>] show_stack+0x48/0x1a0
[<900000000179afc8>] dump_stack_lvl+0x78/0xa0
[<9000000000263ed0>] __warn+0x90/0x1a0
[<90000000017419b8>] report_bug+0x1b8/0x280
[<900000000179c564>] do_bp+0x264/0x420
[<90000000004c302c>] __static_key_slow_dec_cpuslocked+0xec/0x100
[<90000000002b4d7c>] sched_cpu_deactivate+0x2fc/0x300
[<9000000000266498>] cpuhp_invoke_callback+0x178/0x8a0
[<9000000000267f70>] cpuhp_thread_fun+0xf0/0x240
[<90000000002a117c>] smpboot_thread_fn+0x1dc/0x2e0
[<900000000029a720>] kthread+0x140/0x160
[<9000000000222288>] ret_from_kernel_thread+0xc/0xa4

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/smp.c |  121 ++++++++++++++++++++++++--------------------
 1 file changed, 68 insertions(+), 53 deletions(-)

--- a/arch/loongarch/kernel/smp.c
+++ b/arch/loongarch/kernel/smp.c
@@ -88,6 +88,73 @@ void show_ipi_list(struct seq_file *p, i
 	}
 }
 
+static inline void set_cpu_core_map(int cpu)
+{
+	int i;
+
+	cpumask_set_cpu(cpu, &cpu_core_setup_map);
+
+	for_each_cpu(i, &cpu_core_setup_map) {
+		if (cpu_data[cpu].package == cpu_data[i].package) {
+			cpumask_set_cpu(i, &cpu_core_map[cpu]);
+			cpumask_set_cpu(cpu, &cpu_core_map[i]);
+		}
+	}
+}
+
+static inline void set_cpu_sibling_map(int cpu)
+{
+	int i;
+
+	cpumask_set_cpu(cpu, &cpu_sibling_setup_map);
+
+	for_each_cpu(i, &cpu_sibling_setup_map) {
+		if (cpus_are_siblings(cpu, i)) {
+			cpumask_set_cpu(i, &cpu_sibling_map[cpu]);
+			cpumask_set_cpu(cpu, &cpu_sibling_map[i]);
+		}
+	}
+}
+
+static inline void clear_cpu_sibling_map(int cpu)
+{
+	int i;
+
+	for_each_cpu(i, &cpu_sibling_setup_map) {
+		if (cpus_are_siblings(cpu, i)) {
+			cpumask_clear_cpu(i, &cpu_sibling_map[cpu]);
+			cpumask_clear_cpu(cpu, &cpu_sibling_map[i]);
+		}
+	}
+
+	cpumask_clear_cpu(cpu, &cpu_sibling_setup_map);
+}
+
+/*
+ * Calculate a new cpu_foreign_map mask whenever a
+ * new cpu appears or disappears.
+ */
+void calculate_cpu_foreign_map(void)
+{
+	int i, k, core_present;
+	cpumask_t temp_foreign_map;
+
+	/* Re-calculate the mask */
+	cpumask_clear(&temp_foreign_map);
+	for_each_online_cpu(i) {
+		core_present = 0;
+		for_each_cpu(k, &temp_foreign_map)
+			if (cpus_are_siblings(i, k))
+				core_present = 1;
+		if (!core_present)
+			cpumask_set_cpu(i, &temp_foreign_map);
+	}
+
+	for_each_online_cpu(i)
+		cpumask_andnot(&cpu_foreign_map[i],
+			       &temp_foreign_map, &cpu_sibling_map[i]);
+}
+
 /* Send mailbox buffer via Mail_Send */
 static void csr_mail_send(uint64_t data, int cpu, int mailbox)
 {
@@ -300,6 +367,7 @@ int loongson_cpu_disable(void)
 	numa_remove_cpu(cpu);
 #endif
 	set_cpu_online(cpu, false);
+	clear_cpu_sibling_map(cpu);
 	calculate_cpu_foreign_map();
 	local_irq_save(flags);
 	irq_migrate_all_off_this_cpu();
@@ -377,59 +445,6 @@ static int __init ipi_pm_init(void)
 core_initcall(ipi_pm_init);
 #endif
 
-static inline void set_cpu_sibling_map(int cpu)
-{
-	int i;
-
-	cpumask_set_cpu(cpu, &cpu_sibling_setup_map);
-
-	for_each_cpu(i, &cpu_sibling_setup_map) {
-		if (cpus_are_siblings(cpu, i)) {
-			cpumask_set_cpu(i, &cpu_sibling_map[cpu]);
-			cpumask_set_cpu(cpu, &cpu_sibling_map[i]);
-		}
-	}
-}
-
-static inline void set_cpu_core_map(int cpu)
-{
-	int i;
-
-	cpumask_set_cpu(cpu, &cpu_core_setup_map);
-
-	for_each_cpu(i, &cpu_core_setup_map) {
-		if (cpu_data[cpu].package == cpu_data[i].package) {
-			cpumask_set_cpu(i, &cpu_core_map[cpu]);
-			cpumask_set_cpu(cpu, &cpu_core_map[i]);
-		}
-	}
-}
-
-/*
- * Calculate a new cpu_foreign_map mask whenever a
- * new cpu appears or disappears.
- */
-void calculate_cpu_foreign_map(void)
-{
-	int i, k, core_present;
-	cpumask_t temp_foreign_map;
-
-	/* Re-calculate the mask */
-	cpumask_clear(&temp_foreign_map);
-	for_each_online_cpu(i) {
-		core_present = 0;
-		for_each_cpu(k, &temp_foreign_map)
-			if (cpus_are_siblings(i, k))
-				core_present = 1;
-		if (!core_present)
-			cpumask_set_cpu(i, &temp_foreign_map);
-	}
-
-	for_each_online_cpu(i)
-		cpumask_andnot(&cpu_foreign_map[i],
-			       &temp_foreign_map, &cpu_sibling_map[i]);
-}
-
 /* Preload SMP state for boot cpu */
 void smp_prepare_boot_cpu(void)
 {


