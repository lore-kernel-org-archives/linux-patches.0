Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6AFC15D5A9
	for <patches@lists.linux.dev>; Wed, 15 May 2024 22:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715811823; cv=none; b=hFlFSfaIGQ1X3GiTVwtcMMYOtWToPeImtAHn+wSwN5Oej7LUzVaPxS/GIzRO4UmQ8nlxRHUmgDvZ5BzmeiVHVxiXI9/nY8tOg8U///dr3TOy4+71AnrR7RjKDbqhIBo82EFgpuiGEiJ6K34TmLbGqOJbjd5llkCLZUzcNeLIgDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715811823; c=relaxed/simple;
	bh=LarkljTO1TuSW0PW1sO1YhzFVecG19h5R10xs4DTYOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQVS/tDO2KQMgqBuKoiYL+CX2/h9ZyORg4LSkl/ONnb+1C0AXbGZM4lIkjOccSOEG/SuJbZXzC7nxU5pvmWpePsXURtlCPzSOV30xeOUkOHM498PIUr7GV0nAPrRJOfaFb21QZUAyHywYkEVoxtk9BUdyHzTwRngNflPlrmpMrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VgaaP0dH; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VgaaP0dH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715811821; x=1747347821;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LarkljTO1TuSW0PW1sO1YhzFVecG19h5R10xs4DTYOw=;
  b=VgaaP0dH73jZy705zHkRfiVgLNCJGJQACI447ekQrwAfewHoXqIbT0Nx
   zR4/BiDavbm9qAaerlofHgdZHstRW/Z3CZbWQZ20W1Hf4ZGnQIsHu8EKP
   WckWjM8TOuJ1OJYPlgjGfKzsBSTBTLPEymaPULJRsO4ba1ah2YQj7rcBj
   zlz8CsXrRAiDrjkxebFBXYsrkbo6KocR/wY4i0xueRGfCFik+dkOmpaIw
   lryVkJfxk8hrHy6/Wpa078YiltxSlYD+sdxfJoZAMvRL4n9RGD445mash
   0ulw3F+TrIiH9zFm1Z9wN7PbDWPVC3ElkOIeWJwdIAeucAHq4miE6AREN
   w==;
X-CSE-ConnectionGUID: 3FsVmDrAQ0atTVENSn78QQ==
X-CSE-MsgGUID: c9wDQ0rEQgaPJbIoYgy6PQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="15671649"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="15671649"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 15:23:35 -0700
X-CSE-ConnectionGUID: 8gXHIyn+S5OoEkHb9RwAug==
X-CSE-MsgGUID: 9VdmnPIgTwm8oEWxYeRdqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="35989168"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 15:23:35 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v18 08/17] x86/resctrl: Add and initialize display_id field to struct rdt_mon_domain
Date: Wed, 15 May 2024 15:23:16 -0700
Message-ID: <20240515222326.74166-9-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240515222326.74166-1-tony.luck@intel.com>
References: <20240515222326.74166-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When Sub-NUMA (SNC) mode is enabled monitoring domains are created at
SNC node scope. Add a field that holds the identity of the L3 cache for
each domain to make it easy to find all domains that share the same
L3 cache instance. There are three places where this is needed. In
all cases code is operating on a domain where "d->id" refers to the
SNC node id.

1) When making monitor directories.
   Need the L3 cache instance ID to make the mon_L3_XX directory
   that will contain the legacy monitor reporting files and the
   mon_sub_L3_YY directory for this domain.
2) When removing monitor directories.
   Similar to making directories.
3) When reporting data from one of the L3-scoped legacy files.
   This requires summing data from each SNC node that shares the
   same L3 cache instance id.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            | 2 ++
 arch/x86/kernel/cpu/resctrl/core.c | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 98c0ff8ba005..2f8ac925bc18 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -96,6 +96,7 @@ struct rdt_ctrl_domain {
 /**
  * struct rdt_mon_domain - group of CPUs sharing a resctrl monitor resource
  * @hdr:		common header for different domain types
+ * @display_id:		shared id used to identify domains to be summed for display
  * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
  * @mbm_total:		saved state for MBM total bandwidth
  * @mbm_local:		saved state for MBM local bandwidth
@@ -106,6 +107,7 @@ struct rdt_ctrl_domain {
  */
 struct rdt_mon_domain {
 	struct rdt_domain_hdr		hdr;
+	int				display_id;
 	unsigned long			*rmid_busy_llc;
 	struct mbm_state		*mbm_total;
 	struct mbm_state		*mbm_local;
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 15856254fea7..dd40c998df72 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -614,6 +614,14 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 
 	d = &hw_dom->d_resctrl;
 	d->hdr.id = id;
+	d->display_id = get_domain_id_from_scope(cpu, r->mon_display_scope);
+	if (d->display_id < 0) {
+		pr_warn_once("Can't find monitor domain display id for CPU:%d scope:%d for resource %s\n",
+			     cpu, r->mon_display_scope, r->name);
+		mon_domain_free(hw_dom);
+		return;
+	}
+
 	d->hdr.type = RESCTRL_MON_DOMAIN;
 	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
 
-- 
2.44.0

