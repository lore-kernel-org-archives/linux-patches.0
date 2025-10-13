Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECA430E825
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 22:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760394860; cv=none; b=JFHzkVnjOMoGiC8vsT3jp5wjsT+BF4tqiPEutI/mBMynhToteyR+dqsSd4wsUuPrMvAneRc3bTlor2hqbnzZZuimxdyAlFsuMfgy0I1WXWwXBHvi3uahr6NSCLKAjK4jFSzGpw22+fK107FKEEQZKXwcS2akC+0lEapU6oba0Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760394860; c=relaxed/simple;
	bh=/3NNEA3KZZkBujit4VvPeaGBZdcq5KPSwjAraIT71X0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWvkTypFYYbijuprkmP85x2PkMDhHIgoW7B8bWRxiuI9gokqIE4nTFrZSHEwstM/cdEnpM6JQnkrk/rkEJ3G+TJhG77O++feR8okgaMmsSO0IlkbZe9w8j9d5/n4Lhs4+VFgHdzjgNRtmnEPdeaZPa4qfQIiw6i0+LxIu2U3x9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O9C5Idsx; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O9C5Idsx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760394858; x=1791930858;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/3NNEA3KZZkBujit4VvPeaGBZdcq5KPSwjAraIT71X0=;
  b=O9C5IdsxoIw++Rj/gxe6XZxcsLCqJ1Fihmh2GAs6FOcMP6fxyHLcc1NB
   PdOTL/QdNeqOBrj8yNZb0X557pKnFu828vXgJ9R65VmnKgQGqOL3i3QFu
   n+F6LQCy0ijzWI2RdL5k2icyygbcxiWhP8sGVKxFs0eyFPB07/qiVU1GJ
   gefwhOH0JpolxLybHD868dWGgm2Qii4JgvaViGpLvGVSCgZ/mrGXyej4d
   1FZIxzkMzdB2bFPIjloFKvCVewStcEk7TTTKVODgXpk/+7iehgT+171x9
   u4hnaFmZZ4Ov1A5DrFKhynPvTAUrTfaOGy1dZTZS8YeZinoeyB/hqx2K9
   A==;
X-CSE-ConnectionGUID: yxrhX0qURJSWBqsBAPSirg==
X-CSE-MsgGUID: yPrVGxKrSVWp5LjsqGkydA==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="85168929"
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="85168929"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:03 -0700
X-CSE-ConnectionGUID: MhE5DcsVTLGI6flho91jnA==
X-CSE-MsgGUID: xhgZaHauSjyzGAlqvi3qKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="182145329"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.79])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:03 -0700
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
Subject: [PATCH v12 25/31] fs/resctrl: Move allocation/free of closid_num_dirty_rmid[]
Date: Mon, 13 Oct 2025 15:33:39 -0700
Message-ID: <20251013223348.103390-26-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013223348.103390-1-tony.luck@intel.com>
References: <20251013223348.103390-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

closid_num_dirty_rmid[] and rmid_ptrs[] are allocated together during resctrl
initialization and freed together during resctrl exit.

Telemetry events are enumerated on resctrl mount so only at resctrl mount will
the number of RMID supported by all monitoring resources and needed as size for
rmid_ptrs[] be known.

Separate closid_num_dirty_rmid[] and rmid_ptrs[] allocation and free in
preparation for rmid_ptrs[] to be allocated on resctrl mount.

Keep the rdtgroup_mutex protection around the allocation and free of
closid_num_dirty_rmid[] as ARM needs this to guarantee memory ordering.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/monitor.c | 77 ++++++++++++++++++++++++++++----------------
 1 file changed, 49 insertions(+), 28 deletions(-)

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 84a0cbe90748..2782e2e212f6 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -910,36 +910,14 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
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
@@ -975,11 +953,6 @@ static void dom_data_exit(struct rdt_resource *r)
 	if (!r->mon_capable)
 		goto out_unlock;
 
-	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
-		kfree(closid_num_dirty_rmid);
-		closid_num_dirty_rmid = NULL;
-	}
-
 	kfree(rmid_ptrs);
 	rmid_ptrs = NULL;
 
@@ -1816,6 +1789,43 @@ ssize_t mbm_L3_assignments_write(struct kernfs_open_file *of, char *buf,
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
@@ -1836,10 +1846,16 @@ int resctrl_l3_mon_resource_init(void)
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
@@ -1884,5 +1900,10 @@ void resctrl_l3_mon_resource_exit(void)
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

