Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C350231CA5
	for <patches@lists.linux.dev>; Fri, 21 Mar 2025 23:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742598985; cv=none; b=lqZL70zbeAcZcJD8QGuavj8fx1zat5qLoE6stYk/amavalnn4wpsEswKNI21iXHNXOlWdrAjME44ZQssiArYy6uj5AaZuNmOgHzpx/tgJLnkyR4yodNtcNcDkzMeoXf/GlaPsQpaEjz9f5gUH08aocLagMyIqu0D9E5MQg4AD1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742598985; c=relaxed/simple;
	bh=9ieO6iCh64QmqQgaoWo0R5eNrTtSK9vtOxFM7AICgeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDZYhd5LjO9ErF9H4hnEMyYnJ4+rXolqgP7OLcE6Ue8sTSwYN/DLXUp4l7AEc3ts/6zTEO8ujX//Z8nM0dc5hzVkrVQO5+R4pc9R7fe7djEOhli0JseXtVm9L9JLedp9u7KfjfIqMbudvRorCmYjcfmFSkvl/WlpuQqxQYqF0Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TNG/Ydcc; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TNG/Ydcc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742598984; x=1774134984;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9ieO6iCh64QmqQgaoWo0R5eNrTtSK9vtOxFM7AICgeE=;
  b=TNG/YdccxiwUquGZAZm49RZ346zw9QurQOlf93nEvW1gWwPh1iPdFlC3
   msH0e8YJeZ4w52+jIa1/SkmgVjEUSDLS8srPIzdJViYGCfDzUiJ5x1Lub
   udfLPaI/YkMhDiBu7BmolMkPIyne5DWKuIcaBQ09YEdSmBdJZQHU+OFPk
   1JOghJDBR0a2TXNtN9GAI8GFfW9csItK3mjangLs7NHQWsaPWeGiENDAX
   W9I8ixUzSK+dymCAO3A7ayw0QQprxW8rvJOXt57/aPmLj9Z9RTxv93OpB
   sn5yLImWOGxrTVW+L810ebCnN+ez4AMpwLAcAz0XN67wjZo+js+vwDQ0s
   Q==;
X-CSE-ConnectionGUID: pKxU8QUBSdy9qDJC+5ih2w==
X-CSE-MsgGUID: 1RBpSPHPQGmorgZJAVIcng==
X-IronPort-AV: E=McAfee;i="6700,10204,11380"; a="43604575"
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="43604575"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:21 -0700
X-CSE-ConnectionGUID: IwGcQ+W4TIuzrrdoSM8c5w==
X-CSE-MsgGUID: veRMWfJXT7yXN6DpwUziAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="128354302"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:21 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v2 05/16] x86/resctrl: Add and initialize rdt_resource for package scope core monitor
Date: Fri, 21 Mar 2025 16:15:55 -0700
Message-ID: <20250321231609.57418-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250321231609.57418-1-tony.luck@intel.com>
References: <20250321231609.57418-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New resource for monitoring core events reported at package level.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            |  1 +
 include/linux/resctrl_types.h      |  1 +
 fs/resctrl/internal.h              |  2 ++
 arch/x86/kernel/cpu/resctrl/core.c | 11 +++++++++++
 fs/resctrl/rdtgroup.c              |  2 ++
 5 files changed, 17 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 25c3ee78de3d..6c895ec220fe 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -233,6 +233,7 @@ enum resctrl_scope {
 	RESCTRL_L2_CACHE = 2,
 	RESCTRL_L3_CACHE = 3,
 	RESCTRL_L3_NODE,
+	RESCTRL_PACKAGE,
 };
 
 /**
diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
index a7faf2cd5406..8f967e03af5a 100644
--- a/include/linux/resctrl_types.h
+++ b/include/linux/resctrl_types.h
@@ -39,6 +39,7 @@ enum resctrl_res_level {
 	RDT_RESOURCE_L2,
 	RDT_RESOURCE_MBA,
 	RDT_RESOURCE_SMBA,
+	RDT_RESOURCE_INTEL_AET,
 
 	/* Must be the last */
 	RDT_NUM_RESOURCES,
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index ec3863d18f68..3a100007301d 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -240,6 +240,8 @@ struct rdtgroup {
 
 #define RFTYPE_DEBUG			BIT(10)
 
+#define RFTYPE_RES_PKG			BIT(11)
+
 #define RFTYPE_CTRL_INFO		(RFTYPE_INFO | RFTYPE_CTRL)
 
 #define RFTYPE_MON_INFO			(RFTYPE_INFO | RFTYPE_MON)
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index c316268b4442..c8cc3104f56c 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -99,6 +99,15 @@ struct rdt_hw_resource rdt_resources_all[RDT_NUM_RESOURCES] = {
 			.schema_fmt		= RESCTRL_SCHEMA_RANGE,
 		},
 	},
+	[RDT_RESOURCE_INTEL_AET] =
+	{
+		.r_resctrl = {
+			.rid			= RDT_RESOURCE_INTEL_AET,
+			.name			= "PKG",
+			.mon_scope		= RESCTRL_PACKAGE,
+			.mon_domains		= mon_domain_init(RDT_RESOURCE_INTEL_AET),
+		},
+	},
 };
 
 u32 resctrl_arch_system_num_rmid_idx(void)
@@ -430,6 +439,8 @@ static int get_domain_id_from_scope(int cpu, enum resctrl_scope scope)
 		return get_cpu_cacheinfo_id(cpu, scope);
 	case RESCTRL_L3_NODE:
 		return cpu_to_node(cpu);
+	case RESCTRL_PACKAGE:
+		return topology_physical_package_id(cpu);
 	default:
 		break;
 	}
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index dbfb7d3bc3bc..a90291f57330 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2179,6 +2179,8 @@ static unsigned long fflags_from_resource(struct rdt_resource *r)
 	case RDT_RESOURCE_MBA:
 	case RDT_RESOURCE_SMBA:
 		return RFTYPE_RES_MB;
+	case RDT_RESOURCE_INTEL_AET:
+		return RFTYPE_RES_PKG;
 	}
 
 	return WARN_ON_ONCE(1);
-- 
2.48.1

