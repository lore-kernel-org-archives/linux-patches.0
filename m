Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AC8416139;
	Thu, 30 Jul 2026 14:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422840; cv=none; b=tHJoNqJGQTUh+cYx7DK5Ib3H8n6HApX2qXaC7Pba/U3IYfsZ+m5hO06DHlzKF/Whm+LQ3pS2ps3xENHbmVbCuq5Cl/iwdqZHlIdQfinCofKFEXvDFU4cU8fke6oWqA4Wu/5uzbkmFnZCHsTEHvW7oMJmPZrbJtQsAu2ttY9b/Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422840; c=relaxed/simple;
	bh=DhVTRadtdPW/l8N4hGVNayyE9paV7OY+UJYjGbvX/1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9LWWwvKOpo3muEL9V//XM0jG/IgGS1+fGw0X/69bpMr3o0uaY3kJvIfLSsvbrbyH8DM2UL5iAEgeieQlFUuROoYTpv7AWB3Tvu+BjDVyMXmMUezsrtjP44Cpcbo6EnIzW/F/lfHgsqJ/f01hkWWb6N1+029Utjyftq7kOGSD3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSxRuXZH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSxRuXZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8868D1F000E9;
	Thu, 30 Jul 2026 14:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422839;
	bh=26IB0aq1eo7FV70rPfd4cHWcdVVY4pQ1t5UOH3hO4io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BSxRuXZHt9Lxh3LKQbKIegm1hL3mLGYWmO95HUS3l5XcLvWrwy2gycDBA8NhiTvEa
	 1iEFjDrjPN6iHajzoAXJWmmZkMstQWRAmaIqdA3X8sVuj3/LCBSeGKAH+iXZi0ZLG+
	 sj31McHrWVoWfCAsSVoo4C8ZDsYiIdTVAnuXkwiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingcong Bai <jeffbai@aosc.io>,
	Xi Ruoyao <xry111@xry111.site>,
	Rong Bao <rong.bao@csmantle.top>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.1 574/744] LoongArch: Retrieve CPU package ID from PPTT when available
Date: Thu, 30 Jul 2026 16:14:07 +0200
Message-ID: <20260730141456.485976612@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -201,10 +201,12 @@ static void __init acpi_process_madt(voi
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
@@ -222,6 +224,29 @@ int __init parse_acpi_topology(void)
 
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
@@ -425,10 +425,10 @@ void loongson_init_secondary(void)
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
 


