Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3E7334391
	for <patches@lists.linux.dev>; Fri, 12 Sep 2025 22:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757715073; cv=none; b=QepVT35vOcQ+5cgibyPIWsHqSXRzzU9V6+GJKjrY/dfs4dSE3GFjdzliY2v8L+DNIrLk331wkpX3DziSqGn7T0o53+RHbpJ102N++BAgxLKB1uaIFS/f54bVA4jUnyFfNRBSwAAjvi9qoJnt3QK9rPQvDjTiYsPMdeGi7kzSVM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757715073; c=relaxed/simple;
	bh=Zo7eX0MprfL/R/qdhLarnJhHu9ZtgO+AShM/+7+ExZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tw/ZHiYWO0mofo7FwMKgBcKiP/11FPIdNcZEuKp3ucMn7XbtOMB0IvdmQDiBNGRQHgw3DdlmbE0nBpgd1HneXKMsZy/5DdRZ9fQVY9inTQCulPFWjss3sUNGmTKl/hvY/Om4SAypEq6FtTcqqkanVTEXmskHohyqmoKYcNzOOAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GvR0G44Y; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GvR0G44Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757715071; x=1789251071;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zo7eX0MprfL/R/qdhLarnJhHu9ZtgO+AShM/+7+ExZk=;
  b=GvR0G44Y3l5fCjH+fJA9XJ1lS0bBudyZe2Ghmu5HAfLMDLtquJ/4uYgY
   P8NMtHsZ5Tmj8m5Bpmv2QAdDJ1JLpSFpoWeMH86/6VACrH9nJPMq/Jxnl
   3bvmT07/TQTC5/OXeDCgfXi6ca9K41bIm2vOrc1xwd/7KxPagLvk76Z7q
   KN8Y8FbDlXkabBP/Z16mbWysDI6WpbZahKMmaudt6q/n9ufwvZ3+QfIF9
   HPB0oTrsjULVD7Hir0mkmkaTJXvEbLsmqomkKNCraluqQtgVck5gtN3bw
   THROgQCBy2OXvaWKhq+tAbUYR7Vx+1Quq37hEA0k4dvZFZpok1vY/lTgb
   A==;
X-CSE-ConnectionGUID: LXQlblEMSFSx/yefVcyKYw==
X-CSE-MsgGUID: BekfcbvpQlurhS3SscRXsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11551"; a="60002742"
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="60002742"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 15:11:07 -0700
X-CSE-ConnectionGUID: bL1u4U3WTqG4WhG4tIdDXg==
X-CSE-MsgGUID: i9/oAuAQTomrj7cdLwCiqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="179265178"
Received: from smoehrl-linux.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.49])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 15:11:06 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v10 13/28] x86,fs/resctrl: Add and initialize rdt_resource for package scope monitor
Date: Fri, 12 Sep 2025 15:10:34 -0700
Message-ID: <20250912221053.11349-14-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250912221053.11349-1-tony.luck@intel.com>
References: <20250912221053.11349-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new PERF_PKG resource and introduce package level scope for
monitoring telemetry events so that CPU hot plug notifiers can build domains
at the package granularity.

Use the physical package ID available via topology_physical_package_id()
to identify the monitoring domains with package level scope. This enables
user space to use:
 /sys/devices/system/cpu/cpuX/topology/physical_package_id
to identify the monitoring domain a CPU is associated with.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 include/linux/resctrl.h            |  2 ++
 fs/resctrl/internal.h              |  2 ++
 arch/x86/kernel/cpu/resctrl/core.c | 10 ++++++++++
 fs/resctrl/rdtgroup.c              |  2 ++
 4 files changed, 16 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 6350064ac8be..ff67224b80c8 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -53,6 +53,7 @@ enum resctrl_res_level {
 	RDT_RESOURCE_L2,
 	RDT_RESOURCE_MBA,
 	RDT_RESOURCE_SMBA,
+	RDT_RESOURCE_PERF_PKG,
 
 	/* Must be the last */
 	RDT_NUM_RESOURCES,
@@ -267,6 +268,7 @@ enum resctrl_scope {
 	RESCTRL_L2_CACHE = 2,
 	RESCTRL_L3_CACHE = 3,
 	RESCTRL_L3_NODE,
+	RESCTRL_PACKAGE,
 };
 
 /**
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 3c87b27375b1..a71f602da816 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -253,6 +253,8 @@ struct rdtgroup {
 
 #define RFTYPE_ASSIGN_CONFIG		BIT(11)
 
+#define RFTYPE_RES_PERF_PKG		BIT(11)
+
 #define RFTYPE_CTRL_INFO		(RFTYPE_INFO | RFTYPE_CTRL)
 
 #define RFTYPE_MON_INFO			(RFTYPE_INFO | RFTYPE_MON)
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 05b9fd415d78..4588c133729e 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -100,6 +100,14 @@ struct rdt_hw_resource rdt_resources_all[RDT_NUM_RESOURCES] = {
 			.schema_fmt		= RESCTRL_SCHEMA_RANGE,
 		},
 	},
+	[RDT_RESOURCE_PERF_PKG] =
+	{
+		.r_resctrl = {
+			.name			= "PERF_PKG",
+			.mon_scope		= RESCTRL_PACKAGE,
+			.mon_domains		= mon_domain_init(RDT_RESOURCE_PERF_PKG),
+		},
+	},
 };
 
 u32 resctrl_arch_system_num_rmid_idx(void)
@@ -433,6 +441,8 @@ static int get_domain_id_from_scope(int cpu, enum resctrl_scope scope)
 		return get_cpu_cacheinfo_id(cpu, scope);
 	case RESCTRL_L3_NODE:
 		return cpu_to_node(cpu);
+	case RESCTRL_PACKAGE:
+		return topology_physical_package_id(cpu);
 	default:
 		break;
 	}
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 223fd8b761e6..c19d87fa96ec 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2330,6 +2330,8 @@ static unsigned long fflags_from_resource(struct rdt_resource *r)
 	case RDT_RESOURCE_MBA:
 	case RDT_RESOURCE_SMBA:
 		return RFTYPE_RES_MB;
+	case RDT_RESOURCE_PERF_PKG:
+		return RFTYPE_RES_PERF_PKG;
 	}
 
 	return WARN_ON_ONCE(1);
-- 
2.51.0

