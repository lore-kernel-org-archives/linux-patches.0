Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC47F35A28B
	for <patches@lists.linux.dev>; Fri, 12 Sep 2025 22:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757715081; cv=none; b=GfYgNldxtOltL94uBmZen6pwKGAGHwlk/7Up1ZOHJ814mrUHPwTjfzv/RhWzzmaDuisn4H0T2XUDGcnTue9ZFeA3ZOWMEgF4pNTK4t113c0uKji53xBXXWlh2YoLntZqt98mAEd1U8fnRnf+HW2pzy92SJZXnCXbGUJKPQ/wmN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757715081; c=relaxed/simple;
	bh=EzjN/wToyJrF8+nXn5+4obGTeCpKUsFUbozD5vzJcF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ruhxpx/aArIEde1v2hkRS5B9wArQER0fdkn9FyZd3jSXYjYh3azK+avZQwu7tu1z8i8gtQQXv3aqcOtxr7I0xLIaDDv27hSUwBI2u3NBAj2GO/X672UezPdLfKhkAxRy7W/JILyuZlIkzp3OzduypL7nZdPWkye1cMOj+oihUWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DsFILA6t; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DsFILA6t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757715080; x=1789251080;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EzjN/wToyJrF8+nXn5+4obGTeCpKUsFUbozD5vzJcF4=;
  b=DsFILA6tS/0CeRa2Er/fZA4DVoyBiAY3QTQpFB+gxjoLVfmn7OnN4aeR
   loflvX7FizZglESzvZ9VaQTU5epIuIGeedAzJtsESb3y52SFPwVDUbHzP
   J7hdL8PXe9d++bHk2iCyGB9tLt5iSgZLlt6J50mCklm5/I8Ftl3HnLA6U
   OrgHjTk7Z+uWOyIgqqTdsVsZ8gIf9ohVBiVivvbfxMv26XscaCMh9xhWv
   LYVHkPeqqKhFO6SIdZr3p3i6QsfYKK5sOdknrgyCAI+WxGXpqv5Yvtvw0
   wS4UMi4uJC8yNsclN2thjtYL2nHm44xDMMCUIb4USTM+nAOFwGoNN/Jlg
   g==;
X-CSE-ConnectionGUID: dUbGz0gJQGafW6XCpgxyFg==
X-CSE-MsgGUID: cxWiWuhRQz233i5tP1GQyw==
X-IronPort-AV: E=McAfee;i="6800,10657,11551"; a="60002816"
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="60002816"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 15:11:12 -0700
X-CSE-ConnectionGUID: 3Qf1bFpJQ2O94VGqEtSxJw==
X-CSE-MsgGUID: RvNLw+bYQ5idQuwGbvZ89Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="179265217"
Received: from smoehrl-linux.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.49])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 15:11:11 -0700
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
Subject: [PATCH v10 22/28] fs/resctrl: Move allocation/free of closid_num_dirty_rmid[]
Date: Fri, 12 Sep 2025 15:10:43 -0700
Message-ID: <20250912221053.11349-23-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250912221053.11349-1-tony.luck@intel.com>
References: <20250912221053.11349-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

closid_num_dirty_rmid[] is allocated in dom_data_init() during resctrl
initialization and freed by dom_data_exit() during resctrl exit giving
it the same life cycle as rmid_ptrs[].

Move closid_num_dirty_rmid[] allocaction/free out to
resctrl_l3_mon_resource_init() and resctrl_l3_mon_resource_exit() in
preparation for rmid_ptrs[] to be allocated on resctrl mount in support
of the new telemetry events.

Keep the rdtgroup_mutex protection around the allocation/free of
closid_num_dirty_rmid[] as ARM needs this to guarantee memory
ordering.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/monitor.c | 77 ++++++++++++++++++++++++++++----------------
 1 file changed, 49 insertions(+), 28 deletions(-)

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 6b22d2815734..8f15bdf40593 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -885,36 +885,14 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
 static int dom_data_init(struct rdt_resource *r)
 {
 	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
-	u32 num_closid = resctrl_arch_get_num_closid(r);
 	struct rmid_entry *entry = NULL;
 	int err = 0, i;
 	u32 idx;
 
 	mutex_lock(&rdtgroup_mutex);
-	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
-		u32 *tmp;
-
-		/*
-		 * If the architecture hasn't provided a sanitised value here,
-		 * this may result in larger arrays than necessary. Resctrl will
-		 * use a smaller system wide value based on the resources in
-		 * use.
-		 */
-		tmp = kcalloc(num_closid, sizeof(*tmp), GFP_KERNEL);
-		if (!tmp) {
-			err = -ENOMEM;
-			goto out_unlock;
-		}
-
-		closid_num_dirty_rmid = tmp;
-	}
 
 	rmid_ptrs = kcalloc(idx_limit, sizeof(struct rmid_entry), GFP_KERNEL);
 	if (!rmid_ptrs) {
-		if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
-			kfree(closid_num_dirty_rmid);
-			closid_num_dirty_rmid = NULL;
-		}
 		err = -ENOMEM;
 		goto out_unlock;
 	}
@@ -950,11 +928,6 @@ static void dom_data_exit(struct rdt_resource *r)
 	if (!r->mon_capable)
 		goto out_unlock;
 
-	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
-		kfree(closid_num_dirty_rmid);
-		closid_num_dirty_rmid = NULL;
-	}
-
 	kfree(rmid_ptrs);
 	rmid_ptrs = NULL;
 
@@ -1791,6 +1764,43 @@ ssize_t mbm_L3_assignments_write(struct kernfs_open_file *of, char *buf,
 	return ret ?: nbytes;
 }
 
+static int closid_num_dirty_rmid_alloc(struct rdt_resource *r)
+{
+	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
+		u32 num_closid = resctrl_arch_get_num_closid(r);
+		u32 *tmp;
+
+		/* For ARM memory ordering access to closid_num_dirty_rmid */
+		mutex_lock(&rdtgroup_mutex);
+
+		/*
+		 * If the architecture hasn't provided a sanitised value here,
+		 * this may result in larger arrays than necessary. Resctrl will
+		 * use a smaller system wide value based on the resources in
+		 * use.
+		 */
+		tmp = kcalloc(num_closid, sizeof(*tmp), GFP_KERNEL);
+		if (!tmp)
+			return -ENOMEM;
+
+		closid_num_dirty_rmid = tmp;
+
+		mutex_unlock(&rdtgroup_mutex);
+	}
+
+	return 0;
+}
+
+static void closid_num_dirty_rmid_free(void)
+{
+	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
+		mutex_lock(&rdtgroup_mutex);
+		kfree(closid_num_dirty_rmid);
+		closid_num_dirty_rmid = NULL;
+		mutex_unlock(&rdtgroup_mutex);
+	}
+}
+
 /**
  * resctrl_l3_mon_resource_init() - Initialise global monitoring structures.
  *
@@ -1811,10 +1821,16 @@ int resctrl_l3_mon_resource_init(void)
 	if (!r->mon_capable)
 		return 0;
 
-	ret = dom_data_init(r);
+	ret = closid_num_dirty_rmid_alloc(r);
 	if (ret)
 		return ret;
 
+	ret = dom_data_init(r);
+	if (ret) {
+		closid_num_dirty_rmid_free();
+		return ret;
+	}
+
 	if (resctrl_arch_is_evt_configurable(QOS_L3_MBM_TOTAL_EVENT_ID)) {
 		mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].configurable = true;
 		resctrl_file_fflags_init("mbm_total_bytes_config",
@@ -1859,5 +1875,10 @@ void resctrl_l3_mon_resource_exit(void)
 {
 	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
 
+	if (!r->mon_capable)
+		return;
+
+	closid_num_dirty_rmid_free();
+
 	dom_data_exit(r);
 }
-- 
2.51.0

