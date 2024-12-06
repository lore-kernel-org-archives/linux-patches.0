Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302711FFC40
	for <patches@lists.linux.dev>; Fri,  6 Dec 2024 16:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733502718; cv=none; b=b8j1HYkl2nx0jSozmt2MgSDKFSbOb7yCHeEVxkVoCL/ehjmXNxIgP0hgzmX5ONIwibdsy73f6B177bCVK3Ciucw/ap7mijIVVOJFS+vynd790VTBI2peIZCEKbN4xkIIB534VoRtRF20BK58I7+Eiog9O2RhkKYmGwRvVTpecXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733502718; c=relaxed/simple;
	bh=gi6s4jrFwCELUNGcLkgK6oa6vovHsOyBVbYmIAfSobM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXGXS5LyIltDyr7t/G0Mp1AAwhYSM7c3/w8FnDilX7WXyAj/VyElUvdg5iPXZyxTalwRxDPrmWWbBa//tUv70knAmV61bsZQrCGGrPhgBNYj7n7cAGqdBOqjofESMJcs2gJDSZkjw7lKfZT+/XSfiRrh1fYYrpwVnfsCitqcV2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hjy1h64x; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hjy1h64x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733502717; x=1765038717;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gi6s4jrFwCELUNGcLkgK6oa6vovHsOyBVbYmIAfSobM=;
  b=Hjy1h64x7fWdO3mktt68X26FICrIRZ3fyDswMD5AFGktVNGjcykb3vvi
   YzH7k2EFQ68IhMJuFdT8q5DeZLLJDROuZnG1H7U0GKvzbsZFkuDQQQUml
   +FgJhn60eND73hBZdfWazesXqE9a/rgVnuGHqJ2smWMK+Rh0t6fDE4JbW
   9HAfm5ASbjxkY5FMN+wO49BxdcEsQmgZ8lpGaOxyHahCTUMKFHdlBkfLS
   mYPkRg9feT1/enALa9Zy62UNmD2K91APiUoU1n/vuE373O2e/w8S3rxqa
   yQDClRiDC2lR65omvmK7zL+3477dGduNj8xmCJMsxupHc9QF6vmIwa8QJ
   g==;
X-CSE-ConnectionGUID: t3BOJXOlQLWNXci3Ac0ulw==
X-CSE-MsgGUID: R9RcIGK4QDqzzUypl/jOAg==
X-IronPort-AV: E=McAfee;i="6700,10204,11278"; a="44470401"
X-IronPort-AV: E=Sophos;i="6.12,213,1728975600"; 
   d="scan'208";a="44470401"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2024 08:31:54 -0800
X-CSE-ConnectionGUID: 6sxGJr5GTySj+sv/bm1sGA==
X-CSE-MsgGUID: /IFPpwMbQWSt4AKcFnwVKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,213,1728975600"; 
   d="scan'208";a="95258511"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2024 08:31:54 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	x86@kernel.org
Cc: James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v11 3/8] x86/resctrl: Modify update_mba_bw() to use per CTRL_MON group event
Date: Fri,  6 Dec 2024 08:31:43 -0800
Message-ID: <20241206163148.83828-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241206163148.83828-1-tony.luck@intel.com>
References: <20241206163148.83828-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

update_mba_bw() hard codes use of the memory bandwidth local event which
prevents more flexible options from being deployed.

Change this function to use the event specified in the rdtgroup that is
being processed.

Mount time checks for the "mba_MBps" option ensure that local memory
bandwidth is enabled. So drop the redundant is_mbm_local_enabled() check.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/monitor.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 69bdc11bacf8..adb18f088979 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -752,20 +752,20 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
 	u32 closid, rmid, cur_msr_val, new_msr_val;
 	struct mbm_state *pmbm_data, *cmbm_data;
 	struct rdt_ctrl_domain *dom_mba;
+	enum resctrl_event_id evt_id;
 	struct rdt_resource *r_mba;
-	u32 cur_bw, user_bw, idx;
 	struct list_head *head;
 	struct rdtgroup *entry;
-
-	if (!is_mbm_local_enabled())
-		return;
+	u32 cur_bw, user_bw;
 
 	r_mba = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
+	evt_id = rgrp->mba_mbps_event;
 
 	closid = rgrp->closid;
 	rmid = rgrp->mon.rmid;
-	idx = resctrl_arch_rmid_idx_encode(closid, rmid);
-	pmbm_data = &dom_mbm->mbm_local[idx];
+	pmbm_data = get_mbm_state(dom_mbm, closid, rmid, evt_id);
+	if (WARN_ON_ONCE(!pmbm_data))
+		return;
 
 	dom_mba = get_ctrl_domain_from_cpu(smp_processor_id(), r_mba);
 	if (!dom_mba) {
@@ -784,7 +784,9 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
 	 */
 	head = &rgrp->mon.crdtgrp_list;
 	list_for_each_entry(entry, head, mon.crdtgrp_list) {
-		cmbm_data = &dom_mbm->mbm_local[entry->mon.rmid];
+		cmbm_data = get_mbm_state(dom_mbm, entry->closid, entry->mon.rmid, evt_id);
+		if (WARN_ON_ONCE(!cmbm_data))
+			return;
 		cur_bw += cmbm_data->prev_bw;
 	}
 
-- 
2.47.0

