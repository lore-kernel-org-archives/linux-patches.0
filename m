Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4D73451A5
	for <patches@lists.linux.dev>; Fri, 29 Aug 2025 19:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756496054; cv=none; b=fjbxG6oOcKnHQhssUg2uW06BxF/9Dz8hTcVasMjSvcc8/pbTtEVXGpCGYHCr1+RtGFGkxttDcqnVDYmzy0tNqw923rxeKgImWQZQ3Xp8Z+cy+qLSKmP5xC0VpD3HfAyb/IgHGMVFDOL1lsBKERmEA2aN/vACrPEW8ng/cA529uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756496054; c=relaxed/simple;
	bh=ntO/opyyiJMsNvbOMD75APDmDVxJMO/enXmVwd6H8AY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hOJlV80Wtu9LVAIcb1kxinqUrW7Qzy9CdlEMbVtCsotUWPayoOsBU+O++xpkr9xPliPiHg6WgqJLS7S4dCon/6+3+mXX50TV1lruPokHxwSv0k9k5DOEQETOSBgfUn6jrYu47UZimeXNoP8nwHiQcou/EF6VmS3+TTrHpr+utpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EDwxODWq; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EDwxODWq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756496051; x=1788032051;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ntO/opyyiJMsNvbOMD75APDmDVxJMO/enXmVwd6H8AY=;
  b=EDwxODWqABpT26Vg0sl/kgB1PEZNBEVsaOQYRL+NrgoH6KnEgg9vnaev
   wvAC3jeB5SlaqNEG6fwaJQQ7IurW78TZyHtXo4hMVwEJUOeRFywtgaTmM
   xNP3Is3jC6gbeokA1EXGoSUiBwYj0ZPIPatjMieG2lmShFc2YcSzA1K+q
   hrDhZNKNGBVeYgmTYolW2qwi++tLwr0O1nEyYWaOnpb9LsSqWZL1h0Ivn
   dhdMnIl/6XJEzcGNqia5lapHbR72rp859YZI+37JSBoVkuQjw+tdIFLiO
   JDHZ4Lvjm1uunCECGWbfCu+PookSglGEjpIztVofMCJJ0/czX4DFfGczF
   g==;
X-CSE-ConnectionGUID: kDfEgm98TP+uaXF2AZA7pg==
X-CSE-MsgGUID: p/0t9I+ZTQ22MjzuoCCaEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62625370"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62625370"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:33:57 -0700
X-CSE-ConnectionGUID: LiSFqCuJRaygbcrcYpUBfw==
X-CSE-MsgGUID: iA2dgFL6SSeZz3Z1bT5l6A==
X-ExtLoop1: 1
Received: from ldmartin-desk2.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.202])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:33:56 -0700
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
Subject: [PATCH v9 26/31] fs,x86/resctrl: Compute number of RMIDs as minimum across resources
Date: Fri, 29 Aug 2025 12:33:38 -0700
Message-ID: <20250829193346.31565-27-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829193346.31565-1-tony.luck@intel.com>
References: <20250829193346.31565-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

resctrl assumes that only the L3 resource supports monitor events, so
it simply takes the rdt_resource::num_rmid from RDT_RESOURCE_L3 as
the system's number of RMIDs.

The addition of telemetry events in a different resource breaks that
assumption.

Compute the number of available RMIDs as the minimum value across
all mon_capable resources (analogous to how the number of CLOSIDs
is computed across alloc_capable resources).

Note that mount time enumeration of the telemetry resource means that
this number can be reduced. If this happens, then some memory will
be wasted as the allocations for rdt_l3_mon_domain::states[] will be
larger than needed.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 15 +++++++++++++--
 fs/resctrl/rdtgroup.c              |  5 +++++
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index dbad8d301e03..8aa7d9105971 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -110,12 +110,23 @@ struct rdt_hw_resource rdt_resources_all[RDT_NUM_RESOURCES] = {
 	},
 };
 
+/**
+ * resctrl_arch_system_num_rmid_idx - Compute number of supported RMIDs
+ *				      (minimum across all mon_capable resource)
+ *
+ * Return: Number of supported RMIDs at time of call. Note that mount time
+ * enumeration of resources may reduce the number.
+ */
 u32 resctrl_arch_system_num_rmid_idx(void)
 {
-	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+	u32 num_rmids = U32_MAX;
+	struct rdt_resource *r;
+
+	for_each_mon_capable_rdt_resource(r)
+		num_rmids = min(num_rmids, r->num_rmid);
 
 	/* RMID are independent numbers for x86. num_rmid_idx == num_rmid */
-	return r->num_rmid;
+	return num_rmids == U32_MAX ? 0 : num_rmids;
 }
 
 struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 01e42130e98b..3201e9cad8da 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4116,6 +4116,11 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
  * During boot this may be called before global allocations have been made by
  * resctrl_l3_mon_resource_init().
  *
+ * This routine is called at resctrl init time. The number of supported RMIDs
+ * may be reduced if additional mon_capable resources are enumerated at mount
+ * time. This means the rdt_l3_mon_domain::mbm_states[] and
+ * rdt_l3_mon_domain::rmid_busy_llc allocations may be larger than needed.
+ *
  * Returns 0 for success, or -ENOMEM.
  */
 static int domain_setup_l3_mon_state(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
-- 
2.50.1

