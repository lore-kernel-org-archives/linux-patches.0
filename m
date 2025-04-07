Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD60F22D4FA
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 23:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744069257; cv=none; b=S2CyKVbxeTMygMldzU4LmI7cu+ZtAu7GyFcVm6lINyLxH6J0YwXbm2Jk8Gnp7ujZxOvKraf7Yeosx0CjDg0zLr/KDXMGCL6kf174vJnHE80xifJ0MvccbHk3zLQHHr+0Q87j8e6cQy1LH48ymXXBhYL/6tnIr/mZQaI13w2BIMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744069257; c=relaxed/simple;
	bh=g+/8Y2uc0TuA2I3bexR6A5aqjZ/2NdNAOcXDeZ/avNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wxkymx9WgyBgC75HvaDDebyaX616HheLpkcSVr4oxCxauBFtZueoOkt7cQJ4m6BFKUBGYcRY/b9XDStcmRj+4hKRQwex8wKJ/O9yQ/CUXlPjES/Jj2+8UC1ROQOlDfuxDAuYL51h15fHJjEEHmd+CBsEjnFSt/+dDGdihmz8620=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JyvFFYTC; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JyvFFYTC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744069255; x=1775605255;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g+/8Y2uc0TuA2I3bexR6A5aqjZ/2NdNAOcXDeZ/avNo=;
  b=JyvFFYTCgVnFFZerq7pb9XRH13IRd1308gqIbOzYeSPo0sORjn+ttdji
   5NSKJptgt2D7IpCe6inYJZOAw9sbXku7AN6BhUMpjQSffH0xcknIE1fIn
   yaO3G6aMw+iz0TW50HwQpOJmbiXzn1seGXPyINk/JAAb4tobVxMG8xi2v
   viLHpKb25tw7FPu/rbZeUcQLIrSp+3uujOAJgI3Zka9RN0iKP+02z2br2
   pJK8LNsI7EwJutjhDn2NwOkEMc6SyjIOYv37p4Jxpgu9+73+7Ai4sy2Rz
   3Hgvb0jFKDHOMHqpApNaoYoDUVkLOsqzNpPNlBnFzobcdrkaMJMpAi4r5
   A==;
X-CSE-ConnectionGUID: 7OVIblMMQzyIACWQVI0AWg==
X-CSE-MsgGUID: W1lFUdLJR5mQYRPkqzDcUQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="48193160"
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="48193160"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:48 -0700
X-CSE-ConnectionGUID: ylIp3db+QfeTmHgfW12LqQ==
X-CSE-MsgGUID: HSx07/NKTJGd7tJcayfqIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="165315465"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:47 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 07/26] x86/resctrl: Move L3 initialization out of domain_add_cpu_mon()
Date: Mon,  7 Apr 2025 16:40:09 -0700
Message-ID: <20250407234032.241215-8-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250407234032.241215-1-tony.luck@intel.com>
References: <20250407234032.241215-1-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/resctrl/core.c | 57 ++++++++++++++++++------------
 1 file changed, 35 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index d82a4a2db699..703423b0be0e 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -493,33 +493,12 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
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
-		if (WARN_ON_ONCE(hdr->type != DOMTYPE(r->rid, DOMTYPE_MON)))
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
@@ -552,6 +531,40 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 	}
 }
 
+static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
+{
+	int id = get_domain_id_from_scope(cpu, r->mon_scope);
+	struct list_head *add_pos = NULL;
+	struct rdt_domain_hdr *hdr;
+	struct rdt_mon_domain *d;
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
+		if (WARN_ON_ONCE(hdr->type != DOMTYPE(r->rid, DOMTYPE_MON)))
+			return;
+		d = container_of(hdr, struct rdt_mon_domain, hdr);
+
+		cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
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

