Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFF2436BF8;
	Thu, 30 Jul 2026 15:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426285; cv=none; b=AEh6cx2b5iozJouIvHG7TlFyFnYfnk/YjcKS4r+5/UdMtlpLjnBy44Qty9cni9h1jWAr4bLwl9XJas5PYY8gDnWPzwfn4GAx4lp79tdFGPT3VNnyL2E4Z/vWhDWbxAS6vGll4zdAHmnpFs+3YErxfX/WtoENFRJL5wbxTfdz3Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426285; c=relaxed/simple;
	bh=nP0rF/xKtK7CFgL8ZFU7e7wm5Nie8nMwUkJh8Mh2hso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=th3eqRW0izrFCMASxC80CEB8agSFYGzmEWQNmsI4x0OhZS6n9zIc8TdKMX3v9UCIOPC4qhDa/pEYPd1Pps5jk0OQyWs4Q7FCxLTj7BQ6b1iPpBFbra/QKKI8GWWETeEc22DQ+tE9BXbLABfIY/3vUhYFHK2BKXa8wo5DlWrqPUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dSq9Kfbb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dSq9Kfbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44BE91F000E9;
	Thu, 30 Jul 2026 15:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426283;
	bh=s2zqIvAutg9Dt+RCkCzbNwx2I2LvVRnKDTcDeliTNtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dSq9KfbbpVrdMQg/W6HrAX3xC7RkP8Iv389Qvx/5t+E4x40Gc0GGoT0PkK/kr6Dlb
	 UVtnGmorXqVFUTaQwA/mbGuH/yidbvyzn72MGPm/dFB90WPH5oY8RiaKTaFL55QqA6
	 pdOAGDsyFhgxpBdfUq0AP+/c3oFiH67yyEtZ8Zek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingcong Bai <jeffbai@aosc.io>,
	Xi Ruoyao <xry111@xry111.site>,
	Rong Bao <rong.bao@csmantle.top>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 364/602] LoongArch: Retrieve CPU package ID from PPTT when available
Date: Thu, 30 Jul 2026 16:12:36 +0200
Message-ID: <20260730141443.608262540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rong Bao <rong.bao@csmantle.top>

commit 4e8f58620f6717f72f3d88a2c8f25c0c656d0ba7 upstream.

Currently, the LoongArch CPU topology initialization code calculates
each core's package ID by dividing its physical ID by loongson_sysconf.
cores_per_package. This relies on the assumption that cores_per_package
counts in the same domain as physical IDs.

On Loongson-3B6000 (XB612B0V_1.2), cores_per_package matches the visible
core count -- 24 in this case. However, the physical IDs range from 0 to
31 in a noncontinuous fashion:

        $ cat /proc/cpuinfo | grep -i -F 'global_id'
        global_id               : 0
        global_id               : 1
        global_id               : 4
        global_id               : 5
        global_id               : 6
        global_id               : 7
        global_id               : 8
        global_id               : 9
        global_id               : 10
        global_id               : 11
        global_id               : 14
        global_id               : 15
        global_id               : 16
        global_id               : 17
        global_id               : 20
        global_id               : 21
        global_id               : 22
        global_id               : 23
        global_id               : 26
        global_id               : 27
        global_id               : 28
        global_id               : 29
        global_id               : 30
        global_id               : 31

Retrieve the exact package ID from ACPI PPTT when available, in the same
style as retrieving the core ID and thread ID in parse_acpi_topology().
Use this information in loongson_init_secondary() when the PPTT readout
is successful. The original division logic is kept as a fallback.

Meanwhile, since some existing code paths like loongson3_cpufreq expect
a continuous integer sequence of package IDs in [0, MAX_PACKAGES) when
retrieving from cpu_data[], here we also canonicalize the package ID to
be filled in parse_acpi_topology() to meet such an expectation.

Cc: stable@vger.kernel.org
Tested-by: Mingcong Bai <jeffbai@aosc.io>
Co-developed-by: Xi Ruoyao <xry111@xry111.site>
Signed-off-by: Xi Ruoyao <xry111@xry111.site>
Signed-off-by: Rong Bao <rong.bao@csmantle.top>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/acpi.c |   27 ++++++++++++++++++++++++++-
 arch/loongarch/kernel/smp.c  |    4 ++--
 2 files changed, 28 insertions(+), 3 deletions(-)

--- a/arch/loongarch/kernel/acpi.c
+++ b/arch/loongarch/kernel/acpi.c
@@ -200,10 +200,12 @@ static void __init acpi_process_madt(voi
 }
 
 int pptt_enabled;
+static int acpi_nr_packages;
+static int acpi_package_ids[MAX_PACKAGES];
 
 int __init parse_acpi_topology(void)
 {
-	int cpu, topology_id;
+	int i, cpu, topology_id;
 
 	for_each_possible_cpu(cpu) {
 		topology_id = find_acpi_cpu_topology(cpu, 0);
@@ -221,6 +223,29 @@ int __init parse_acpi_topology(void)
 
 			cpu_data[cpu].core = topology_id;
 		}
+
+		topology_id = find_acpi_cpu_topology_package(cpu);
+		if (topology_id < 0) {
+			pr_warn("Invalid BIOS PPTT\n");
+			return -ENOENT;
+		}
+
+		for (i = 0; i < acpi_nr_packages; i++)
+			if (acpi_package_ids[i] == topology_id)
+				break;
+
+		if (i == acpi_nr_packages)
+			acpi_package_ids[acpi_nr_packages++] = topology_id;
+
+		cpu_data[cpu].package = topology_id;
+	}
+
+	for_each_possible_cpu(cpu) {
+		for (i = 0; i < acpi_nr_packages; i++)
+			if (cpu_data[cpu].package == acpi_package_ids[i]) {
+				cpu_data[cpu].package = i; /* Canonicalize */
+				break;
+			}
 	}
 
 	pptt_enabled = 1;
--- a/arch/loongarch/kernel/smp.c
+++ b/arch/loongarch/kernel/smp.c
@@ -377,10 +377,10 @@ void loongson_init_secondary(void)
 	numa_add_cpu(cpu);
 #endif
 	per_cpu(cpu_state, cpu) = CPU_ONLINE;
-	cpu_data[cpu].package =
-		     cpu_logical_map(cpu) / loongson_sysconf.cores_per_package;
 	cpu_data[cpu].core = pptt_enabled ? cpu_data[cpu].core :
 		     cpu_logical_map(cpu) % loongson_sysconf.cores_per_package;
+	cpu_data[cpu].package = pptt_enabled ? cpu_data[cpu].package :
+		     cpu_logical_map(cpu) / loongson_sysconf.cores_per_package;
 	cpu_data[cpu].global_id = cpu_logical_map(cpu);
 }
 


