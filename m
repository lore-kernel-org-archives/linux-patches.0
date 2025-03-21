Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78851F1516
	for <patches@lists.linux.dev>; Fri, 21 Mar 2025 23:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742598983; cv=none; b=knZkcaYQESMssMZ/yK2hvXNg2BgPLWOIomiWP6MPFG1rMiPfbX4xSHc2RAu669iNR8PuQ58B23v4KHP8qiWgw2TFqbOAi4q9C4RWUYHa70hNjI9rTJFDgfwCTJBkDS/cbv8zELRiYJRhMUuGWa/eVrYt/dnSeIWU84iaIFJS2I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742598983; c=relaxed/simple;
	bh=DzasePM7tlqahns372BpzcFD3OacTZVKVfYZqFTn7rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMoS0v/kDOzJHG7pj9WZ+Oyu8tcCOilDTJXWwSJ9SgDR+KOGVY3rv5P/9XeZ27rsegGG3wNkIupO6x1CQT2UHp8c1QLrGM6k+rjb8vwR207Qeobvlj068xfzD9zu298hPpUTlRupf61yCgJvfpBoI9j8ifZIlJPBotydNvzNwjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JEiiLq7C; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JEiiLq7C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742598982; x=1774134982;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DzasePM7tlqahns372BpzcFD3OacTZVKVfYZqFTn7rk=;
  b=JEiiLq7CgOZfpNOhEjaixFYUhfI/HbqDmzRMElgMTg96dg5q3nns+giM
   hz1bqP9KhAeDKAuId7vkESgNLThsm2agCsc/8InFp0A/h2lX2ZayIGlzj
   5bIExg4xfVm3BQY4VjK5a3ZDP9TjTKos+baf6nqMEP3c1a1bjBhD3BS2s
   WKHCxh8fjOYL6N5qETVNKyI9Ejllfvvl09MPDcN3QvCC4x1C4c2jSQOBb
   iZmUEeXYburBpklzcAZMz+Jrc/VZ8mAY1PkGAWk9/zyZ8Eq3ba2HfjYw7
   k0U5YqxxM7VNXCNCWWT+RLR1xigVIKI8q/LApn40dbynHgOPq+IXe96Pd
   Q==;
X-CSE-ConnectionGUID: Hi0lLx1ERHCUZMSznE6oWQ==
X-CSE-MsgGUID: JGUb6wL4Rm6b9zu7b4sSdw==
X-IronPort-AV: E=McAfee;i="6700,10204,11380"; a="43604554"
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="43604554"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:20 -0700
X-CSE-ConnectionGUID: An+4wk0QR+6U3BzbDpUG+w==
X-CSE-MsgGUID: wLSEA3+ZQYe4EZknD8Ywfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="128354292"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:19 -0700
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
Subject: [PATCH v2 02/16] x86/resctrl: Move L3 initialization out of domain_add_cpu_mon()
Date: Fri, 21 Mar 2025 16:15:52 -0700
Message-ID: <20250321231609.57418-3-tony.luck@intel.com>
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

To prepare for additional types of monitoring domains, move all the
L3 specific initialization into a helper function.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 52 +++++++++++++++++-------------
 1 file changed, 30 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 6ed0d4f5d6a3..4205aeb4f979 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -492,33 +492,12 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
 	}
 }
 
-static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
+static void setup_l3_mon_domain(int cpu, int id, struct rdt_resource *r, struct list_head *add_pos)
 {
-	int id = get_domain_id_from_scope(cpu, r->mon_scope);
-	struct list_head *add_pos = NULL;
 	struct rdt_hw_mon_domain *hw_dom;
-	struct rdt_domain_hdr *hdr;
 	struct rdt_mon_domain *d;
 	int err;
 
-	lockdep_assert_held(&domain_list_lock);
-
-	if (id < 0) {
-		pr_warn_once("Can't find monitor domain id for CPU:%d scope:%d for resource %s\n",
-			     cpu, r->mon_scope, r->name);
-		return;
-	}
-
-	hdr = resctrl_find_domain(&r->mon_domains, id, &add_pos);
-	if (hdr) {
-		if (WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN))
-			return;
-		d = container_of(hdr, struct rdt_mon_domain, hdr);
-
-		cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
-		return;
-	}
-
 	hw_dom = kzalloc_node(sizeof(*hw_dom), GFP_KERNEL, cpu_to_node(cpu));
 	if (!hw_dom)
 		return;
@@ -551,6 +530,35 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 	}
 }
 
+static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
+{
+	int id = get_domain_id_from_scope(cpu, r->mon_scope);
+	struct list_head *add_pos = NULL;
+	struct rdt_domain_hdr *hdr;
+
+	lockdep_assert_held(&domain_list_lock);
+
+	if (id < 0) {
+		pr_warn_once("Can't find monitor domain id for CPU:%d scope:%d for resource %s\n",
+			     cpu, r->mon_scope, r->name);
+		return;
+	}
+
+	hdr = resctrl_find_domain(&r->mon_domains, id, &add_pos);
+	if (hdr) {
+		cpumask_set_cpu(cpu, &hdr->cpu_mask);
+		return;
+	}
+
+	switch (r->rid) {
+	case RDT_RESOURCE_L3:
+		setup_l3_mon_domain(cpu, id, r, add_pos);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+	}
+}
+
 static void domain_add_cpu(int cpu, struct rdt_resource *r)
 {
 	if (r->alloc_capable)
-- 
2.48.1

