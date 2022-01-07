Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFB52CA2
	for <patches@lists.linux.dev>; Fri,  7 Jan 2022 22:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641596092; x=1673132092;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qmfpz3SI7hOmx8WOOhlhqqGue2zmZ7OVZMvBYNyL3rY=;
  b=VDoTRGmyOz9u1bXM7vhIsRM+xTwk2p7dA9gWt3pe3mU8dXrwr/LRh8iM
   NUHb+brS29sqU16WtpcSy5bAT+CtyL0WznDUhtm/NxSFSXChEacUcnLVr
   EF2xtW6EjK33EpPObuvfQef83RMMoB9zMvmbZQNI4tNX6UFh+KNgB7AMW
   kNk3QaI6kVwAUTLl9mHyL7mLv66SNPZHWtLYXirKm1aJaZGYwuMrrDXsK
   0hD0/reJozoz5D04WX5K4FICc7Dn18XmBIL8yvw2Vwi96C571fL0sb+O4
   LIgFnOlOLGVoleH8kp0KGTo1043j/eXUvIfl1PE/JRpD33G/VAGdTxlCX
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10220"; a="242907970"
X-IronPort-AV: E=Sophos;i="5.88,271,1635231600"; 
   d="scan'208";a="242907970"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 14:54:49 -0800
X-IronPort-AV: E=Sophos;i="5.88,271,1635231600"; 
   d="scan'208";a="471452469"
Received: from agluck-desk2.sc.intel.com ([10.3.52.146])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 14:54:48 -0800
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Smita Koralahalli Channabasappa <smita.koralahallichannabasappa@amd.com>,
	Wei Huang <wei.huang2@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 5/5] x86/sysfs: Add PPIN in sysfs under cpu topology
Date: Fri,  7 Jan 2022 14:54:42 -0800
Message-Id: <20220107225442.1690165-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220107225442.1690165-1-tony.luck@intel.com>
References: <20220107225442.1690165-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

PPIN is the Protected Processor Identification Number.
This is used to identify the socket as a Field Replaceable Unit (FRU).

Existing code only displays this when reporting errors. But this makes
it inconvenient for large clusters to use it for its intended purpose
of inventory control.

There are several privacy concerns associated with a unique
platform identifier. But making the PPIN available shouldn't
change anything important. Notes:

1) The PPIN is only enabled on server CPUs (E.g. Intel Xeon
"-E5", "-E7" and "-SP" parts).

2) The PPIN MSR is may be implemented on some desktop/laptop parts.
But this is for OEM inventory control. Production BIOS versions
leave the PPIN_CTL MSR in the "locked disabled" mode.

3) There may be a BIOS option to lock the MSR in disabled mode
to prevent Linux from reading it.

4) The /sys file added here is readable only by "root".

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 Documentation/ABI/stable/sysfs-devices-system-cpu  | 4 ++++
 Documentation/ABI/testing/sysfs-devices-system-cpu | 6 ++++++
 arch/x86/include/asm/topology.h                    | 1 +
 drivers/base/topology.c                            | 4 ++++
 include/linux/topology.h                           | 3 +++
 5 files changed, 18 insertions(+)

diff --git a/Documentation/ABI/stable/sysfs-devices-system-cpu b/Documentation/ABI/stable/sysfs-devices-system-cpu
index 3965ce504484..902392d7eddf 100644
--- a/Documentation/ABI/stable/sysfs-devices-system-cpu
+++ b/Documentation/ABI/stable/sysfs-devices-system-cpu
@@ -86,6 +86,10 @@ What:           /sys/devices/system/cpu/cpuX/topology/die_cpus
 Description:    internal kernel map of CPUs within the same die.
 Values:         hexadecimal bitmask.
 
+What:           /sys/devices/system/cpu/cpuX/topology/ppin
+Description:    per-socket protected processor inventory number
+Values:         hexadecimal.
+
 What:           /sys/devices/system/cpu/cpuX/topology/die_cpus_list
 Description:    human-readable list of CPUs within the same die.
                 The format is like 0-3, 8-11, 14,17.
diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 69c65da16dff..18af7459adf8 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -73,6 +73,7 @@ What:		/sys/devices/system/cpu/cpuX/topology/core_id
 		/sys/devices/system/cpu/cpuX/topology/physical_package_id
 		/sys/devices/system/cpu/cpuX/topology/thread_siblings
 		/sys/devices/system/cpu/cpuX/topology/thread_siblings_list
+		/sys/devices/system/cpu/cpuX/topology/ppin
 Date:		December 2008
 Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
 Description:	CPU topology files that describe a logical CPU's relationship
@@ -103,6 +104,11 @@ Description:	CPU topology files that describe a logical CPU's relationship
 		thread_siblings_list: human-readable list of cpuX's hardware
 		threads within the same core as cpuX
 
+		ppin: human-readable Protected Processor Identification
+		Number of the socket the cpu# belongs to. There should be
+		one per physical_package_id. File is readable only to
+		admin.
+
 		See Documentation/admin-guide/cputopology.rst for more information.
 
 
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index cc164777e661..caba7db8c7b6 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -110,6 +110,7 @@ extern const struct cpumask *cpu_clustergroup_mask(int cpu);
 #define topology_logical_die_id(cpu)		(cpu_data(cpu).logical_die_id)
 #define topology_die_id(cpu)			(cpu_data(cpu).cpu_die_id)
 #define topology_core_id(cpu)			(cpu_data(cpu).cpu_core_id)
+#define topology_ppin(cpu)			(cpu_data(cpu).ppin)
 
 extern unsigned int __max_die_per_package;
 
diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index 793c592e533a..4c8674715d36 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -54,6 +54,9 @@ static DEVICE_ATTR_RO(cluster_id);
 define_id_show_func(core_id, "%d");
 static DEVICE_ATTR_RO(core_id);
 
+define_id_show_func(ppin, "%llx");
+static DEVICE_ATTR_ADMIN_RO(ppin);
+
 define_siblings_read_func(thread_siblings, sibling_cpumask);
 static BIN_ATTR_RO(thread_siblings, 0);
 static BIN_ATTR_RO(thread_siblings_list, 0);
@@ -129,6 +132,7 @@ static struct attribute *default_attrs[] = {
 #ifdef CONFIG_SCHED_DRAWER
 	&dev_attr_drawer_id.attr,
 #endif
+	&dev_attr_ppin.attr,
 	NULL
 };
 
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 0b3704ad13c8..789a900039e0 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -192,6 +192,9 @@ static inline int cpu_to_mem(int cpu)
 #ifndef topology_core_id
 #define topology_core_id(cpu)			((void)(cpu), 0)
 #endif
+#ifndef topology_ppin
+#define topology_ppin(cpu)			((void)(cpu), 0ull)
+#endif
 #ifndef topology_sibling_cpumask
 #define topology_sibling_cpumask(cpu)		cpumask_of(cpu)
 #endif
-- 
2.31.1

