Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86EAB234978
	for <patches@lists.linux.dev>; Fri, 21 Mar 2025 23:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742598989; cv=none; b=cfNzDjwe+32XcGPu0LVbPkj+iVs7hDq4pFjHRbAP+bCEgANkNOqMqCEnJwT6MDPOt9ziNaH4/Did9YUuEzyF9NAtkyXHYPMxEJeEy8qFgfHUAnOd+1reHMZxBPr50Cys493pH17lQFnmaj08diyT1kfZ+3/OP0WnhD/GXyp6lkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742598989; c=relaxed/simple;
	bh=wNOnSyJUZyVtqGVHCJp5/qbvQ2/t2PXiy9nfB0mLrQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXFisfvconLa+GYRV50NwcH8c7jmz+VX1k7JTjHsah9V/bX7bWAApVuzpwc7LhXxFYoFWCcFGDfvujiBcjMgTrhCB+L6PHJs6WJT+ZJ7ZLyIJig0YamfCMVMGKKbABfTkwAO41CE4CeYgI/iAz+BHi6i0QempvghXgIHHet1zzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EJVDO9M+; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EJVDO9M+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742598988; x=1774134988;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wNOnSyJUZyVtqGVHCJp5/qbvQ2/t2PXiy9nfB0mLrQE=;
  b=EJVDO9M+r9TW+I8P+InLbFDu7xCPm9pw2MK1N5TLnvV7DwoaPw8+VnPP
   4oDUYZ+/jo23nZQwCmdAc+PTdF/VNPRiUHYJ5AcAA4c1RYH2UMzJ8rwsM
   L86pMmG6HdBHvGZa4g+TT2AHli/sh1qc7JPaivPIoUtj3DXt+W49s/HM+
   /Puf7zBH2no3rbs8WRoVednJJ9j4AprJsl7i4qAThtyEOJz3RembyqSkm
   DxoQqD9bFjLR1b/8Ne7oj/+S3szjjn2dfV2dVyVxkhwxagopiw9yu9B88
   1r5ERBK4H1hY2KL/+FVJDigsxCboSUBiUCOBI92ux+NGnw8i+L77wdJNg
   Q==;
X-CSE-ConnectionGUID: Z8fK2laNRjaVK8dcgayRJw==
X-CSE-MsgGUID: nO5CFDsPTqaBI6RVYijZZQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11380"; a="43604629"
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="43604629"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:24 -0700
X-CSE-ConnectionGUID: BewV8rCOQeuMTEO0qpwK+w==
X-CSE-MsgGUID: PUbPB3lBSMSUITyGOuN4CA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="128354324"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:23 -0700
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
Subject: [PATCH v2 12/16] x86/resctrl: Build lookup table for package events
Date: Fri, 21 Mar 2025 16:16:02 -0700
Message-ID: <20250321231609.57418-13-tony.luck@intel.com>
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

The resctrl filesystem saves the evt_type in the private data pointer
of the kernfs_node of each file in the mon_data directories.

To print the values for each file the show() function will need to map
from this evtid to:

num_rmids - to make sure data for this file exists
guid - to pick the pmt_event(s) for each package
stride/offset - to compute MMIO offset for this RMID/event

Build a lookup table for each event to save searching through
lists and add macros for ease of use.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 9ac912742ef1..bab8e4de26b3 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -39,6 +39,18 @@ enum pmt_event_id {
 	PMT_NUM_EVENTS
 };
 
+static struct evtinfo {
+	struct telem_entry	*telem_entry;
+	struct pmt_event	*pmt_event;
+} evtinfo[PMT_NUM_EVENTS];
+
+#define EVT_NUM_RMIDS(evtid)	(evtinfo[evtid].telem_entry->num_rmids)
+#define EVT_STRIDE(evtid)	(evtinfo[evtid].telem_entry->stride)
+#define EVT_GUID(evtid)		(evtinfo[evtid].telem_entry->guid)
+
+#define EVT_OFFSET(evtid)	(evtinfo[evtid].pmt_event->evt_offset)
+#define EVT_TYPE(evtid)		(evtinfo[evtid].pmt_event->evt_type)
+
 /**
  * enum evt_type - Type for values for each event.
  * @EVT_U64:	Integer up to 64 bits
@@ -328,6 +340,9 @@ void rdt_get_intel_aet_mount(void)
 		for (int i = 0; (*tentry)->evts[i].evt.name; i++) {
 			evt = &(*tentry)->evts[i].evt;
 			list_add_tail(&evt->list, &r->evt_list);
+
+			evtinfo[evt->evtid].telem_entry = *tentry;
+			evtinfo[evt->evtid].pmt_event = &(*tentry)->evts[i];
 			ret = true;
 		}
 		if (!r->num_rmid)
-- 
2.48.1

