Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F4E1474CC;
	Tue, 21 Jul 2026 18:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659281; cv=none; b=bqD3mXEnh0LwuRVj5S3t4Egt2NbqzceIzcGWmfUTlmrzN1FQ7/ysocBtQWDt6MK4VnZmTx7Wss1AqDb8YI6dNyqUJquABsR1cqL5fHW1LB1WylhcQ/2woJutyrdAq9Sq3FdGD0anZg1zYbkvYJl5OzVG3kut6KHNUYQSTWyiQlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659281; c=relaxed/simple;
	bh=FIXuYLCsEshVVRIKkslIIux/hqW1VVymWcsTplLmViM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xmv6YyiTkIBmDYyRhkhkJESHBYOe0ptsAEmTSo0/VqplEUa+3c+uIzGFMCXZmLPdAwH//RIwaQFKapz9BlZ9eo3GzygAXrauAzH32uwqkE0SJm+oTsDOBcKowlHsddQcRikL2eyD0mdtar/ERgOibR+zIuYP2xQZj74xGsBQqUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vcb6EcJl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vcb6EcJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFF81F000E9;
	Tue, 21 Jul 2026 18:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659279;
	bh=AV1owLmiUjNLrqKNEsvkQJ7Kx/oCW20yhHX+EOXcM1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vcb6EcJl3g1vMXwbOwuzJMV61Ktzyemh11f0T0zzIqFe+NJAkGDj5vFA7RpnDuuMq
	 RXC5LW2qedTo4NzjkwJzsjvnQgA5g4TJTtoVvY8d0RK+wD7eriOoIvJ5SZbRFWIkkH
	 5U/oMVkZ2iEfvQ2Z4ltRZX9h3iMy9ZYEsh0PnSYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Cameron <jic23@kernel.org>,
	James Morse <james.morse@arm.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.18 1461/1611] cpu/hotplug: Fix NULL kobject warning in cpuhp_smt_enable()
Date: Tue, 21 Jul 2026 17:26:17 +0200
Message-ID: <20260721152548.309843342@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit f9a82544c7174851f5c7524622f5966dcafd3a47 upstream.

On arm64, when booting with `maxcpus` greater than the number of present
CPUs (e.g., QEMU -smp cpus=4,maxcpus=8), some CPUs are marked as 'present'
but have not yet been registered via register_cpu(). Consequently,
the per-cpu device objects for these CPUs are not yet initialized.

In cpuhp_smt_enable(), the code iterates over all present CPUs. Calling
_cpu_up() for these unregistered CPUs eventually leads to
sysfs_create_group() being called with a NULL kobject (or a kobject
without a directory), triggering the following warning in
fs/sysfs/group.c:

  WARNING: fs/sysfs/group.c:137 at internal_create_group+0x41c/0x4bc, CPU#2: sh/181
  [...]
  Call trace:
    internal_create_group+0x41c/0x4bc (P)
    sysfs_create_group+0x18/0x24
    topology_add_dev+0x1c/0x28
    cpuhp_invoke_callback+0x104/0x20c
    __cpuhp_invoke_callback_range+0x94/0x11c
    _cpu_up+0x200/0x37c

When booting with ACPI, arm64 smp_prepare_cpus() currently sets all
enumerated CPUs as "present" regardless of their status in the MADT. This
causes issues with SMT hotplug control. For instance, with QEMU's
"-smp 4,maxcpus=8" configuration, the MADT GICC entries are populated as
follows:

1. The first four CPUs: `Enabled` set but `Online Capable` not set.

2. The remaining four CPUs: `Online Capable` set but `Enabled` not set
   to support potential hot-plugging.

Fix this by:

1. When booting with ACPI, checking the ACPI_MADT_ENABLED flag in the GICC
   entry before calling set_cpu_present() during SMP initialization.

2. Properly managing the present mask in acpi_map_cpu() and
   acpi_unmap_cpu() to support actual CPU hotplug events, This aligns with
   other architectures like x86 and LoongArch.

3. Update the arm64 CPU hotplug documentation to no longer state that all
   online-capable vCPUs are marked as present by the kernel at boot time.

This ensures that only physically available or explicitly enabled CPUs
are in the present mask, keeping the SMT control logic consistent with
the actual hardware state.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: stable@vger.kernel.org
Link: https://uefi.org/specs/ACPI/6.5/05_ACPI_Software_Programming_Model.html#gic-cpu-interface-gicc-structure
Fixes: eed4583bcf9a ("arm64: Kconfig: Enable HOTPLUG_SMT")
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arch/arm64/cpu-hotplug.rst |   28 ++++++++++++++++------------
 arch/arm64/kernel/acpi.c                 |    2 ++
 arch/arm64/kernel/smp.c                  |   12 +++++++++++-
 3 files changed, 29 insertions(+), 13 deletions(-)

--- a/Documentation/arch/arm64/cpu-hotplug.rst
+++ b/Documentation/arch/arm64/cpu-hotplug.rst
@@ -47,11 +47,12 @@ ever have can be described at boot. Ther
 as such devices are emulated.
 
 CPU Hotplug on virtual systems is supported. It is distinct from physical
-CPU Hotplug as all resources are described as ``present``, but CPUs may be
-marked as disabled by firmware. Only the CPU's online/offline behaviour is
-influenced by firmware. An example is where a virtual machine boots with a
-single CPU, and additional CPUs are added once a cloud orchestrator deploys
-the workload.
+CPU Hotplug as all vCPU resources are statically described in the firmware
+configuration tables (e.g. MADT), meaning their maximum possible count is
+known at boot. However, vCPUs that are not enabled at boot are not marked
+as ``present`` by the kernel until they are hotplugged. An example is where
+a virtual machine boots with a single CPU, and additional CPUs are added
+once a cloud orchestrator deploys the workload.
 
 For a virtual machine, the VMM (e.g. Qemu) plays the part of firmware.
 
@@ -60,16 +61,19 @@ brought online. Firmware can enforce its
 ``DENIED``.
 
 The ACPI tables must describe all the resources of the virtual machine. CPUs
-that firmware wishes to disable either from boot (or later) should not be
-``enabled`` in the MADT GICC structures, but should have the ``online capable``
-bit set, to indicate they can be enabled later. The boot CPU must be marked as
-``enabled``.  The 'always on' GICR structure must be used to describe the
-redistributors.
+that are hot-pluggable must have the ``online capable`` bit set and the
+``enabled`` bit cleared in the MADT GICC structures to indicate they can be
+enabled later. The boot CPU must be marked as ``enabled`` with its
+``online capable`` bit cleared. The 'always on' GICR structure must be used
+to describe the redistributors.
 
 CPUs described as ``online capable`` but not ``enabled`` can be set to enabled
 by the DSDT's Processor object's _STA method. On virtual systems the _STA method
-must always report the CPU as ``present``. Changes to the firmware policy can
-be notified to the OS via device-check or eject-request.
+must always set the ``ACPI_STA_DEVICE_PRESENT`` bit, while toggling the
+``ACPI_STA_DEVICE_ENABLED`` bit to reflect its plug status. The kernel will
+then dynamically mark the vCPU as ``present`` within the OS when the
+``ACPI_STA_DEVICE_ENABLED`` bit becomes set during hot-add. Changes to the
+firmware policy can be notified to the OS via device-check or eject-request.
 
 CPUs described as ``enabled`` in the static table, should not have their _STA
 modified dynamically by firmware. Soft-restart features such as kexec will
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -448,12 +448,14 @@ int acpi_map_cpu(acpi_handle handle, phy
 		return *pcpu;
 	}
 
+	set_cpu_present(*pcpu, true);
 	return 0;
 }
 EXPORT_SYMBOL(acpi_map_cpu);
 
 int acpi_unmap_cpu(int cpu)
 {
+	set_cpu_present(cpu, false);
 	return 0;
 }
 EXPORT_SYMBOL(acpi_unmap_cpu);
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -556,6 +556,11 @@ struct acpi_madt_generic_interrupt *acpi
 }
 EXPORT_SYMBOL_GPL(acpi_cpu_get_madt_gicc);
 
+static bool acpi_cpu_is_present(int cpu)
+{
+	return acpi_cpu_get_madt_gicc(cpu)->flags & ACPI_MADT_ENABLED;
+}
+
 /*
  * acpi_map_gic_cpu_interface - parse processor MADT entry
  *
@@ -660,6 +665,10 @@ static void __init acpi_parse_and_init_c
 		early_map_cpu_to_node(i, acpi_numa_get_nid(i));
 }
 #else
+static bool acpi_cpu_is_present(int cpu)
+{
+	return false;
+}
 #define acpi_parse_and_init_cpus(...)	do { } while (0)
 #endif
 
@@ -798,7 +807,8 @@ void __init smp_prepare_cpus(unsigned in
 		if (err)
 			continue;
 
-		set_cpu_present(cpu, true);
+		if (acpi_disabled || acpi_cpu_is_present(cpu))
+			set_cpu_present(cpu, true);
 		numa_store_cpu_info(cpu);
 	}
 }


