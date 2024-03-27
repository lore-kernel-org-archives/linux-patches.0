Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCE51534EB
	for <patches@lists.linux.dev>; Wed, 27 Mar 2024 20:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711569848; cv=none; b=ouLCQkmxZxXujG843JGXX50fCa9XzMdkQ4adZJhRyF0tcW7oyl73qbHEn4/6rxlh8oYx+aivx0jYJZnHZdQy4Vi7nX7G3PiJ9PivypuDndmbGGmdcwfajC7s2aw1qh/uRpDzLALW6s/31LBYrah5kY//x+gQimqh2HpRicy4KFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711569848; c=relaxed/simple;
	bh=DQfB7ziQiSVsGqVtUGTeoCLbXrf9m9tIM71X5OZ5E0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmheun+wuDmOVGP25j0ihEt/WUFpwAMNusQgBDiX8f7wrrfqQLl3kF4Ns81+kS09u5viQ1wpXj3stFtU9/5zJYQDVPu6PWjqA9oNuP0KqXRWAusGc7VAyqt4pfownTC5qAerwPVtb81pe3m98v3z7/Ra99o8YbphTq2/hzqphrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dBOJsikT; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dBOJsikT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711569847; x=1743105847;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DQfB7ziQiSVsGqVtUGTeoCLbXrf9m9tIM71X5OZ5E0M=;
  b=dBOJsikTSJsl0dcUb+Hy9HbuDR2/oX2R5ZGbPyzFEDFzrp78XYf+P0qn
   cKpSMIKnak+xlom2M3OHSScj/OphWxfoaALfn04ljiuBVshwxDrpK39mb
   aOHunPHEwRUZk77DdtFGd3Y4beAs6JF0E6Qh5a72EygtLaa/27CJ9AVQc
   vTQirNKYGdNsWYf2suV4HmAshXyn3v81ZZHuwrAXGJU+HyqI4RAVks0Jl
   YdZ7Ov/vbqVcTG320S4otrmCsLwYNlPS+3QiAFm5UoInItnyfDzGz9MUV
   EJBMXQ+Mv5FsQJe+mjV3ZEgndOV9GRbtetLSrQiVEZe3vJ9kzOzN9GJyM
   Q==;
X-CSE-ConnectionGUID: ZariXCaiTym/LoTM/JD0mg==
X-CSE-MsgGUID: esMVUCXgQnGa1SCiaMmabA==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="18132992"
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="18132992"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 13:04:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="16246122"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 13:04:02 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 05/10] x86/resctrl: Add parent/child information to rdt_resource and rdt_domain
Date: Wed, 27 Mar 2024 13:03:47 -0700
Message-ID: <20240327200352.236835-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240327200352.236835-1-tony.luck@intel.com>
References: <20240327200352.236835-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The L3 resource is a "parent" to the SUBL3 resource in that each of the
domains in L3 is subdivided into two or more SUBL3 domains.

Add parent/child pointers to the rdt_resource structure and a
parent domain id number to the rdt_domain structure.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                |  6 ++++++
 arch/x86/kernel/cpu/resctrl/core.c     | 12 ++++++++++++
 arch/x86/kernel/cpu/resctrl/rdtgroup.c |  4 +++-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index dea79f6a8122..b7ade7627e08 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -70,6 +70,7 @@ struct resctrl_staged_config {
  * @cqm_limbo:		worker to periodically read CQM h/w counters
  * @mbm_work_cpu:	worker CPU for MBM h/w counters
  * @cqm_work_cpu:	worker CPU for CQM h/w counters
+ * @parent:		parent domain number in parent resource
  * @plr:		pseudo-locked region (if any) associated with domain
  * @staged_config:	parsed configuration to be applied
  * @mbps_val:		When mba_sc is enabled, this holds the array of user
@@ -87,6 +88,7 @@ struct rdt_domain {
 	struct delayed_work		cqm_limbo;
 	int				mbm_work_cpu;
 	int				cqm_work_cpu;
+	int				parent;
 	struct pseudo_lock_region	*plr;
 	struct resctrl_staged_config	staged_config[CDP_NUM_TYPES];
 	u32				*mbps_val;
@@ -173,6 +175,8 @@ enum resctrl_scope {
  * @format_str:		Per resource format string to show domain value
  * @parse_ctrlval:	Per resource function pointer to parse control values
  * @evt_list:		List of monitoring events
+ * @parent:		Parent of this resource
+ * @child:		Child of this resource
  * @fflags:		flags to choose base and info files
  * @cdp_capable:	Is the CDP feature available on this resource
  */
@@ -194,6 +198,8 @@ struct rdt_resource {
 						 struct resctrl_schema *s,
 						 struct rdt_domain *d);
 	struct list_head	evt_list;
+	struct rdt_resource	*parent;
+	struct rdt_resource	*child;
 	unsigned long		fflags;
 	bool			cdp_capable;
 };
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 2fa04375da8c..1f5d7ee0096e 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -552,6 +552,18 @@ static void domain_add_cpu(int cpu, struct rdt_resource *r)
 	d->id = id;
 	cpumask_set_cpu(cpu, &d->cpu_mask);
 
+	if (r->parent) {
+		struct rdt_domain *pd;
+
+		list_for_each_entry(pd, &r->parent->domains, list)
+			if (cpumask_test_cpu(cpu, &pd->cpu_mask))
+				goto found;
+		WARN_ON_ONCE(1);
+		return;
+found:
+		d->parent = pd->id;
+	}
+
 	rdt_domain_reconfigure_cdp(r);
 
 	if (r->alloc_capable && domain_setup_ctrlval(r, d)) {
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index a2ebd7e051bb..f2af58a791a4 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -1107,9 +1107,11 @@ static int rdt_mon_features_show(struct kernfs_open_file *of,
 				 struct seq_file *seq, void *v)
 {
 	struct rdt_resource *r = of->kn->parent->priv;
+	struct list_head *evt_list;
 	struct mon_evt *mevt;
 
-	list_for_each_entry(mevt, &r->evt_list, list) {
+	evt_list = r->child ? &r->child->evt_list : &r->evt_list;
+	list_for_each_entry(mevt, evt_list, list) {
 		seq_printf(seq, "%s\n", mevt->name);
 		if (mevt->configurable)
 			seq_printf(seq, "%s_config\n", mevt->name);
-- 
2.44.0

