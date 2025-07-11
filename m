Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CC82376F7
	for <patches@lists.linux.dev>; Fri, 11 Jul 2025 23:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752278043; cv=none; b=d234oFHXwc36439ihKWektQ6g39aHDx3ergaoSW99UXZ0jxxJpbqUHvxSuxNyfuO3qJxqWRQWRTgD6uRImoUd+l5oAXxbI0PSGefmL51J/RpXvXSv9EBl54f2zWw/5r8XZSZ4N1ddG147U6fBlLuNa+mzR8Htwfq6dMr/jLlVBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752278043; c=relaxed/simple;
	bh=RuDPAVv20v1ihSOXLdGfI0iErN0OH8Y3gkYvUvOoUGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1ByeUGBW5HX357Rc+fKQLm604MzgVY1qUXuKvE/cVsZkvRmNyH6+8rQ2ACT0EKytGJLlZQyl2YDOlQvlFcAx4P+f1vesxfCEU3ErAxKcV/tEyRKzdBhoa1/XG4GhtFW3nI5YyntJpRBc1p5KGV3N/t9b1HKiPlfgULVRga01WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IX70vwoL; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IX70vwoL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752278041; x=1783814041;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RuDPAVv20v1ihSOXLdGfI0iErN0OH8Y3gkYvUvOoUGY=;
  b=IX70vwoLfvARNb4zkQnxQjhKmX6YVn5nJBE0JGB3E5iyZyZGGl0AS6bS
   liuA53SByq0nGcaUMudIK4rXGKsTw+uiBDX89bG69ZRvM2nBGE8SaM9JO
   oWMXR6FdaWIuKlWd4T39w6hOYKqZb2o1RXG2uMIPU8iwhhYepqjH26Rwx
   tSYXb6SW9P1J/+OZDsCMAffMlPHrmnjxfC3Ogl5uc0igj4ajghd2lkuzs
   AaFuBl/cc0sirFiaIgEJMwbzTMTm4y/LzUWJfP4mRddr9Bv1Do8pe4yWd
   VmbMCEkMASxgjtu8LEW7Ec4t5XsSpwRVL2GT98ho5sPw23dQ1TOMUg1DN
   A==;
X-CSE-ConnectionGUID: AL83UVaYQ1KljSVN2hAggA==
X-CSE-MsgGUID: fDV1iARUTTS3ZnjsIiWfHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54292692"
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="54292692"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:53:59 -0700
X-CSE-ConnectionGUID: IlvRsKYeQnWA4N+ugy4zSw==
X-CSE-MsgGUID: jaq1vAD9R36Ke+vuppiI2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="155902131"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:53:59 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v7 15/31] x86,fs/resctrl: Add an architectural hook called for each mount
Date: Fri, 11 Jul 2025 16:53:22 -0700
Message-ID: <20250711235341.113933-16-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250711235341.113933-1-tony.luck@intel.com>
References: <20250711235341.113933-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enumeration of Intel telemetry events is not complete when the
resctrl "late_init" code is executed.

Add a hook at the beginning of the mount code that will be used
to check for telemetry events and initialize if any are found.

The hook is called on every attempted mount. But expectations are that
most actions (like enumeration) will only need to be performed
on the first call.

The call is made with no locks held. Architecture code is responsible
for any required locking.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            | 6 ++++++
 arch/x86/kernel/cpu/resctrl/core.c | 9 +++++++++
 fs/resctrl/rdtgroup.c              | 2 ++
 3 files changed, 17 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index e9a1cabfc724..d2fc0fcd0226 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -460,6 +460,12 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 void resctrl_online_cpu(unsigned int cpu);
 void resctrl_offline_cpu(unsigned int cpu);
 
+/*
+ * Architecture hook called for each attempted file system mount.
+ * No locks are held.
+ */
+void resctrl_arch_pre_mount(void);
+
 /**
  * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
  *			      for this resource and domain.
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 0286d3cf6754..22ff91b666d0 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -717,6 +717,15 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
 	return 0;
 }
 
+void resctrl_arch_pre_mount(void)
+{
+	static atomic_t only_once = ATOMIC_INIT(0);
+	int old = 0;
+
+	if (!atomic_try_cmpxchg(&only_once, &old, 1))
+		return;
+}
+
 enum {
 	RDT_FLAG_CMT,
 	RDT_FLAG_MBM_TOTAL,
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 6df06bf0e694..627243a1175c 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2585,6 +2585,8 @@ static int rdt_get_tree(struct fs_context *fc)
 	struct rdt_resource *r;
 	int ret;
 
+	resctrl_arch_pre_mount();
+
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 	/*
-- 
2.50.0

