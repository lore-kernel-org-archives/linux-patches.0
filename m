Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9B33431FA
	for <patches@lists.linux.dev>; Fri, 29 Aug 2025 19:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756496053; cv=none; b=XbJ8XvMk0bXrUJKBt+zzwFLW+wzq1bKevJ/bUZxeFtdHVtmEhjQz/ROOHY9n3WAmZpuN4wM13++JK0U43mNYnCVO3jesMA0zUypGlvSAOv8h/SiR1lLBpUVE6suG4v09Up6wIf2d/EUjTVotZTFrx1tdMseGHEDjO1B3GWSB/lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756496053; c=relaxed/simple;
	bh=jiulF38hrV5VG0cK4TzLddi4RpYVUDqHWNzidI8dD4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OvrbfHrId4koRwk0aYQ8spVRRCwxC+/MqLlYFI6fbsyT3mhX48pYe112U7EqqTOZ97vjUUyYJTe9BR+UksRnj/MKyewSHUm8aqmt8lv+LTPimYEeKpL+jrD8xQLQXsR0Xkd6/X5DEvH1rOp+ibXh/tX80A4jq+OlOps0aBeDjhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nuEqyGH5; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nuEqyGH5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756496051; x=1788032051;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jiulF38hrV5VG0cK4TzLddi4RpYVUDqHWNzidI8dD4o=;
  b=nuEqyGH5iKiEbWBsQHi2nDHk/CptxcizgCWJG0M/VAQ46ZaNdOCpeIfn
   MKCm/QlcrkFTwPlqZWltm2vPbPp6gfUtWwF0vo11SVxkmHEygmOGUlpDk
   z3ktnnHP38V91gd10HMsL+jiMkv30oKFkcqaEqosPBfm2L6pyx+5Lwsmi
   c2Keu9qoTqTq33WkTa1Fw1sc35mniZ7mEJnMXCts1O6y4j1DfJe3fyXcu
   2PnHLg3FUaUKp2Fk4E2a0BzQZWQ3TVEIaAwo214IRD8Ezmob6JtBC3TBK
   v2DRabqKbjhpKCYBsGz9l1BBEVHCnWxuzw5Q9zuXKo0ZvyOXO3+uDTNmW
   A==;
X-CSE-ConnectionGUID: xAUGUlmNQNWIf+ySW+CHag==
X-CSE-MsgGUID: Umo5kqWDTWGEubLt5//4aQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62625356"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62625356"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:33:57 -0700
X-CSE-ConnectionGUID: glCNMx6vSMmfbyTNnQ7tmA==
X-CSE-MsgGUID: m3eF1lJiTLy+S1NeofxsTw==
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
Subject: [PATCH v9 25/31] fs/resctrl: Move allocation/free of closid_num_dirty_rmid
Date: Fri, 29 Aug 2025 12:33:37 -0700
Message-ID: <20250829193346.31565-26-tony.luck@intel.com>
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

closid_num_dirty_rmid[] is allocated in dom_data_init() during resctrl
initialization and freed by dom_data_exit() during resctrl exit giving
it the same life cycle as rmid_ptrs[].

Move closid_num_dirty_rmid[] allocaction/free out to
resctrl_l3_mon_resource_init() and resctrl_l3_mon_resource_exit() in
preparation for rmid_ptrs[] to be allocated on resctrl mount in support
of the new telemetry events.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/monitor.c | 56 ++++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 33432a7f56da..d5b96aca5d03 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -805,36 +805,14 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
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
@@ -870,11 +848,6 @@ static void dom_data_exit(struct rdt_resource *r)
 	if (!r->mon_capable)
 		goto out_unlock;
 
-	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
-		kfree(closid_num_dirty_rmid);
-		closid_num_dirty_rmid = NULL;
-	}
-
 	kfree(rmid_ptrs);
 	rmid_ptrs = NULL;
 
@@ -957,9 +930,31 @@ int resctrl_l3_mon_resource_init(void)
 	if (!r->mon_capable)
 		return 0;
 
+	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
+		u32 num_closid = resctrl_arch_get_num_closid(r);
+		u32 *tmp;
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
+	}
+
 	ret = dom_data_init(r);
-	if (ret)
+	if (ret) {
+		if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
+			kfree(closid_num_dirty_rmid);
+			closid_num_dirty_rmid = NULL;
+		}
 		return ret;
+	}
 
 	if (resctrl_arch_is_evt_configurable(QOS_L3_MBM_TOTAL_EVENT_ID)) {
 		mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].configurable = true;
@@ -984,5 +979,10 @@ void resctrl_l3_mon_resource_exit(void)
 {
 	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
 
+	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
+		kfree(closid_num_dirty_rmid);
+		closid_num_dirty_rmid = NULL;
+	}
+
 	dom_data_exit(r);
 }
-- 
2.50.1

