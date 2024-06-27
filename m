Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D493F1A2565
	for <patches@lists.linux.dev>; Thu, 27 Jun 2024 20:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719520758; cv=none; b=LqUFVJbsn4pKyNkvl5ZJvKQzflHDjNHzEm/epB9CcP2IAN9KdP44xmF3YNj7q5HQX5Roub1O/xarGkwlYS8UYuovf715ohe1B5XpvwPapd4xu/APIOoUNiI6vFzq2LftGjYa6h2jbKcozY+YgmXoid1r20+7gzHam28s4ur+YSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719520758; c=relaxed/simple;
	bh=7gwzf/trQEcQpsp3Q62b5pMAB6BI8DFeIhWQ/vV4hOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y07SKSAa3OOQ2X3Eaa637cw++D/M7Lti+hrddwsOCprllD9ZBTBJLPEXXd8yfvUsnb48XjD5ptD3P0+6p7vwLcnDYw1UBOkF2rxtaVJSxlDl0ADNdsEj5jeJuLBzuYQI1fuG/XAJpb5fDqN7FA2VCuL47N7noSc3d2tLrbn9Zg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ds0mw30W; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ds0mw30W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719520757; x=1751056757;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7gwzf/trQEcQpsp3Q62b5pMAB6BI8DFeIhWQ/vV4hOM=;
  b=ds0mw30WidbAXcIofWAnOcaeUdnR7SKYEkZY7n7Ss6mzJUDP3DuwwPue
   0HtJpGuDkE+XgDOuy8M+2Qd8ObEo799EwwGXk51YmN8X6YWOoMEn1AQMI
   vkWB02jgPhWHB06EPJHkkBBUZLHtVikJr7pcVHxQ6n8+EQtE5ojFsfzhd
   N/mJoM8K4/Lgu5YfaExFWcH8211bOqiTaBMGsvkbQ3GVkRcXUyvtVJumr
   TfeAle6T508vUwSUR+4SarJXcCMyU7DpVUSoMQR595/jBNak5Pd99QntI
   AKN5+S7cN6nxEXgC3SR1MLqxyveKJRM6FM/jowxr4IvCqnyZFljdFES7O
   A==;
X-CSE-ConnectionGUID: TccpD2yQTea2GLlrvkagZA==
X-CSE-MsgGUID: g38YSiKOQCyaiQAhJcaHSg==
X-IronPort-AV: E=McAfee;i="6700,10204,11116"; a="16809822"
X-IronPort-AV: E=Sophos;i="6.09,167,1716274800"; 
   d="scan'208";a="16809822"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2024 13:39:10 -0700
X-CSE-ConnectionGUID: DF7eNT5fR2Cw5eRCLGviSA==
X-CSE-MsgGUID: PT57qZM0QGK+BXaQfjpPYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,167,1716274800"; 
   d="scan'208";a="82052913"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2024 13:39:10 -0700
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
Subject: [PATCH v22 12/18] x86/resctrl: Create Sub-NUMA Cluster (SNC) monitor files
Date: Thu, 27 Jun 2024 13:38:50 -0700
Message-ID: <20240627203856.66628-13-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240627203856.66628-1-tony.luck@intel.com>
References: <20240627203856.66628-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When SNC mode is enabled, create subdirectories and files to monitor
at the SNC node granularity. Legacy behavior is preserved by tagging
the monitor files at the L3 granularity with the "sum" attribute.
When the user reads these files the kernel will read monitor data
from all SNC nodes that share the same L3 cache instance and return
the aggregated value to the user.

Note that the "domid" field for files that must sum across SNC domains
has the L3 cache instance id, while non-summing files use the domain id.

The "sum" files do not need to make a call to mon_event_read() to
initialize the MBM counters. This will be handled by initializing the
individual SNC nodes that share the L3.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 62 +++++++++++++++++++-------
 1 file changed, 46 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 9c38ddcfe150..8502385e389f 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -3026,7 +3026,8 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
 }
 
 static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
-			     struct rdt_resource *r, struct rdtgroup *prgrp)
+			     struct rdt_resource *r, struct rdtgroup *prgrp,
+			     bool do_sum)
 {
 	struct rmid_read rr = {0};
 	union mon_data_bits priv;
@@ -3037,14 +3038,15 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
 		return -EPERM;
 
 	priv.u.rid = r->rid;
-	priv.u.domid = d->hdr.id;
+	priv.u.domid = do_sum ? d->ci->id : d->hdr.id;
+	priv.u.sum = do_sum;
 	list_for_each_entry(mevt, &r->evt_list, list) {
 		priv.u.evtid = mevt->evtid;
 		ret = mon_addfile(kn, mevt->name, priv.priv);
 		if (ret)
 			return ret;
 
-		if (is_mbm_event(mevt->evtid))
+		if (!do_sum && is_mbm_event(mevt->evtid))
 			mon_event_read(&rr, r, d, prgrp, mevt->evtid, true);
 	}
 
@@ -3055,23 +3057,51 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 				struct rdt_mon_domain *d,
 				struct rdt_resource *r, struct rdtgroup *prgrp)
 {
-	struct kernfs_node *kn;
+	struct kernfs_node *kn, *ckn;
 	char name[32];
-	int ret;
+	bool snc_mode;
+	int ret = 0;
 
-	sprintf(name, "mon_%s_%02d", r->name, d->hdr.id);
-	/* create the directory */
-	kn = kernfs_create_dir(parent_kn, name, parent_kn->mode, prgrp);
-	if (IS_ERR(kn))
-		return PTR_ERR(kn);
+	lockdep_assert_held(&rdtgroup_mutex);
 
-	ret = rdtgroup_kn_set_ugid(kn);
-	if (ret)
-		goto out_destroy;
+	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
+	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci->id : d->hdr.id);
+	kn = kernfs_find_and_get(parent_kn, name);
+	if (kn) {
+		/*
+		 * rdtgroup_mutex will prevent this directory from being
+		 * removed. No need to keep this hold.
+		 */
+		kernfs_put(kn);
+	} else {
+		kn = kernfs_create_dir(parent_kn, name, parent_kn->mode, prgrp);
+		if (IS_ERR(kn))
+			return PTR_ERR(kn);
 
-	ret = mon_add_all_files(kn, d, r, prgrp);
-	if (ret)
-		goto out_destroy;
+		ret = rdtgroup_kn_set_ugid(kn);
+		if (ret)
+			goto out_destroy;
+		ret = mon_add_all_files(kn, d, r, prgrp, snc_mode);
+		if (ret)
+			goto out_destroy;
+	}
+
+	if (snc_mode) {
+		sprintf(name, "mon_sub_%s_%02d", r->name, d->hdr.id);
+		ckn = kernfs_create_dir(kn, name, parent_kn->mode, prgrp);
+		if (IS_ERR(ckn)) {
+			ret = -EINVAL;
+			goto out_destroy;
+		}
+
+		ret = rdtgroup_kn_set_ugid(ckn);
+		if (ret)
+			goto out_destroy;
+
+		ret = mon_add_all_files(ckn, d, r, prgrp, false);
+		if (ret)
+			goto out_destroy;
+	}
 
 	kernfs_activate(kn);
 	return 0;
-- 
2.45.2

