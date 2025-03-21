Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8072343BE
	for <patches@lists.linux.dev>; Fri, 21 Mar 2025 23:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742598988; cv=none; b=gSM+Ss7ZLrRZ8GieWf5i3D2pVip1JAyxTe77MFdB/40eRfoVgJqdMtKNT+KS+4xUkTflqV1osd4Nq7GdzLBX71fNmYigPgvVHFgqRJUP9z361ose+YGUBxs9iL3L5J5QyACAl2LwLmK/3xV6QyiXiroAXw8q4Yk6tY+O1C+R1xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742598988; c=relaxed/simple;
	bh=cCNSar58WlYhHdFeOp9gxfKGPr/CcucOc0z3EF+w1bE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+CYO87wLWYMNGrLzD5CGoQLh45E9QSlIsKq3jF/Q1S5VXudcFeD3iv1lN0qKNG1/Te9biFFrB7rPLA+KINlBJqF636m9Z2nuQ8ecqmBIvgvKXJTS7JZJO4B+p7MrA2Iq3MDsDH2XwCJ+XjjZVgAyjski1z8wU2POMVB8FOco6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tq+LrrEl; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tq+LrrEl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742598987; x=1774134987;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cCNSar58WlYhHdFeOp9gxfKGPr/CcucOc0z3EF+w1bE=;
  b=Tq+LrrElwDKniiBcquTjH71vTmFwaOYwKAT2Q8pDP6VtL0oS/3pxlall
   p/mj9digXNsSpkdEYIdhBdFBRqP3fmwRQOoHEkins8GATAWyeOqzGuWTe
   j+6ogc9A7GRiimibKOSvOy9+ra3+1vTD3KPFyl02vNcVjtbngCE9bFhvv
   FsyFUDocdAtq5z7c+vV6/XxllL7jQCePNjtWwFhOrPAKu8LeABhJ5c5MC
   KjXud2/5PuVwcWBMR3GsVmvUw/JWLOUqCqcXYUsc9Y7z8RQ5eSN19xqzy
   C9BZN/0Qe0nhAU9sE1Lemw3/cMlVDvMigq9vgdVbFpxPI5ISqF+o6KGws
   w==;
X-CSE-ConnectionGUID: PaiokZ9yRZudGkCG7NDtaA==
X-CSE-MsgGUID: jKJnRJoaRsqq/R7ThoeNFg==
X-IronPort-AV: E=McAfee;i="6700,10204,11380"; a="43604613"
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="43604613"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:23 -0700
X-CSE-ConnectionGUID: 6OtA2PDcRQyzQSn3ckEVdQ==
X-CSE-MsgGUID: LojECj1aTE+LzbfmCtuksw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="128354318"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:23 -0700
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
Subject: [PATCH v2 10/16] x86/resctrl: Allocate per-package structures for known events
Date: Fri, 21 Mar 2025 16:16:00 -0700
Message-ID: <20250321231609.57418-11-tony.luck@intel.com>
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

Use the per-package counts of known events to allocate arrays to
make a copy of just the known events.

Add hook into resctrl_exit() to cleanup.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  |  2 +
 arch/x86/kernel/cpu/resctrl/core.c      |  2 +
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 60 ++++++++++++++++++++++++-
 3 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index ada402c7678b..2503a24e4177 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -170,8 +170,10 @@ int rdt_get_mon_l3_config(struct rdt_resource *r);
 
 #ifdef CONFIG_INTEL_AET_RESCTRL
 int rdt_get_intel_aet_mon_config(void);
+void rdt_intel_aet_exit(void);
 #else
 static inline int rdt_get_intel_aet_mon_config(void) { return 0; }
+static inline void rdt_intel_aet_exit(void) { };
 #endif
 
 bool rdt_cpu_has(int flag);
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 2adf40d8de32..d011c095aafa 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -1095,6 +1095,8 @@ static void __exit resctrl_arch_exit(void)
 {
 	cpuhp_remove_state(rdt_online);
 
+	rdt_intel_aet_exit();
+
 	resctrl_exit();
 }
 
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 67862e81b9e0..e2d8eab997fc 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -188,6 +188,26 @@ static bool count_events(struct pkg_info *pkg, int max_pkgs, struct pmt_feature_
 	return found;
 }
 
+static int setup(struct pkg_info *pkg, int pkgnum, struct pmt_feature_group *p, int slot)
+{
+	struct telem_entry **tentry;
+
+	for (int i = 0; i < p->count; i++) {
+		for (tentry = telem_entry; *tentry; tentry++) {
+			if (!(*tentry)->active)
+				continue;
+			if (pkgnum != p->regions[i].plat_info.package_id)
+				continue;
+			if (p->regions[i].guid != (*tentry)->guid)
+				continue;
+
+			pkg[pkgnum].regions[slot++] =  p->regions[i];
+		}
+	}
+
+	return slot;
+}
+
 DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,	\
 	if (!IS_ERR_OR_NULL(_T))					\
 		intel_pmt_put_feature_group(_T))
@@ -202,6 +222,8 @@ static bool get_events(void)
 	struct pmt_feature_group *p2 __free(intel_pmt_put_feature_group) = NULL;
 	int num_pkgs = topology_max_packages();
 	struct pkg_info *pkg __free(kfree) = NULL;
+	bool found_known_features = false;
+	int i, slot;
 
 	pkg = kmalloc_array(num_pkgs, sizeof(*pkg_info), GFP_KERNEL | __GFP_ZERO);
 	if (!pkg)
@@ -220,13 +242,32 @@ static bool get_events(void)
 		if (!count_events(pkg, num_pkgs, p2))
 			intel_pmt_put_feature_group(no_free_ptr(p2));
 
+	for (i = 0; i < num_pkgs; i++) {
+		if (!pkg[i].count)
+			continue;
+		found_known_features = true;
+		pkg[i].regions = kmalloc_array(pkg[i].count, sizeof(*pkg[i].regions), GFP_KERNEL);
+		if (!pkg[i].regions)
+			goto fail;
+
+		slot = 0;
+		if (!IS_ERR_VALUE(p1))
+			slot = setup(pkg, i, p1, slot);
+		if (!IS_ERR_VALUE(p2))
+			slot = setup(pkg, i, p2, slot);
+	}
+
 	if (!IS_ERR_OR_NULL(p1))
 		feat_energy = no_free_ptr(p1);
 	if (!IS_ERR_OR_NULL(p2))
 		feat_perf = no_free_ptr(p2);
 	pkg_info = no_free_ptr(pkg);
 
-	return true;
+	return found_known_features;
+fail:
+	while (--i > 0)
+		kfree(pkg[i].regions);
+	return false;
 }
 
 /*
@@ -242,6 +283,23 @@ int rdt_get_intel_aet_mon_config(void)
 	return 1;
 }
 
+/* Clean up when resctrl shuts down completely */
+void rdt_intel_aet_exit(void)
+{
+	int num_pkgs = topology_max_packages();
+
+	if (pkg_info) {
+		for (int i = 0; i < num_pkgs; i++)
+			kfree(pkg_info[i].regions);
+		kfree(pkg_info);
+	}
+
+	if (feat_energy)
+		intel_pmt_put_feature_group(feat_energy);
+	if (feat_perf)
+		intel_pmt_put_feature_group(feat_perf);
+}
+
 /*
  * Late (first mount) initialization. Safe to ask OOBMSM which telemetry
  * event groups are supported.
-- 
2.48.1

