Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEE24C93
	for <patches@lists.linux.dev>; Thu, 26 Jan 2023 18:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674758553; x=1706294553;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sfw55e9pOISjtn87W0zcDQDfivg/FZE8hQOsm+yl2hY=;
  b=CKl9IuXDRd4D8dGvvL8E1JZqnTrpitmzLV859YDgf0stN9Z0yqG8TRJk
   LWJml0fZk8gHEiSBHbx3URuG5L6avywXS3VCxUQJ8izpw3X7Cuhok01nK
   2uf4DUFV5v9AjMza8pjMtQ+oYch137pynUUikRikRwV8BO/LP+1WobVfB
   nmlJaSGMBmrK8wJKvNGqmgG7B5OsPGUi9X1Dm2e46yxmfm5cg6tA73ado
   MfEaUCpCv84IJZU1UF5a8sTA3vddmcgM1E0NK973XdNA1qP+3KVEFErGw
   PIAbW7AASZkDcor86kuOGkA3VoUtY0cjVS7ofehSc9omJEBazW20opl1C
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="354203342"
X-IronPort-AV: E=Sophos;i="5.97,249,1669104000"; 
   d="scan'208";a="354203342"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2023 10:42:06 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="991745445"
X-IronPort-AV: E=Sophos;i="5.97,249,1669104000"; 
   d="scan'208";a="991745445"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2023 10:42:05 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	x86@kernel.org
Cc: Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 3/7] x86/resctrl: Add a new node-scoped resource to rdt_resources_all[]
Date: Thu, 26 Jan 2023 10:41:53 -0800
Message-Id: <20230126184157.27626-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230126184157.27626-1-tony.luck@intel.com>
References: <20230126184157.27626-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a placeholder in the array of struct rdt_hw_resource to be used
for event monitoring of systems with Sub-NUMA Cluster enabled.

Update get_domain_id() to handle SCOPE_NODE.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h |  2 ++
 arch/x86/kernel/cpu/resctrl/core.c     | 12 ++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 15cea517efaa..39a62babd60b 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -409,12 +409,14 @@ enum resctrl_res_level {
 	RDT_RESOURCE_L3,
 	RDT_RESOURCE_L2,
 	RDT_RESOURCE_MBA,
+	RDT_RESOURCE_NODE,
 
 	/* Must be the last */
 	RDT_NUM_RESOURCES,
 };
 
 enum resctrl_scope {
+	SCOPE_NODE,
 	SCOPE_L2_CACHE = 2,
 	SCOPE_L3_CACHE = 3
 };
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 6914232acf84..19be6fe42ef3 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -100,6 +100,16 @@ struct rdt_hw_resource rdt_resources_all[] = {
 			.fflags			= RFTYPE_RES_MB,
 		},
 	},
+	[RDT_RESOURCE_NODE] =
+	{
+		.r_resctrl = {
+			.rid			= RDT_RESOURCE_NODE,
+			.name			= "L3",
+			.scope			= SCOPE_NODE,
+			.domains		= domain_init(RDT_RESOURCE_NODE),
+			.fflags			= RFTYPE_RES_MB,
+		},
+	},
 };
 
 /*
@@ -464,6 +474,8 @@ static int arch_domain_mbm_alloc(u32 num_rmid, struct rdt_hw_domain *hw_dom)
 
 static int get_domain_id(int cpu, enum resctrl_scope scope)
 {
+	if (scope == SCOPE_NODE)
+		return cpu_to_node(cpu);
 	return get_cpu_cacheinfo_id(cpu, scope);
 }
 
-- 
2.39.1

