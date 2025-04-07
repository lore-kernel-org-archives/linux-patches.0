Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E69423F273
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 23:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744069265; cv=none; b=YVzYgF6Ydl1VK67/w1tu3UyyPp3TTA1nwEA0QanukT4GLUDMuyEC4SLDJVcp7uWYuY8HJGZLe7aRFTK5Ex04IiwsItIlu+vyu73OPOZDLRzeGH3BYSt3QoQ8nWcKyDRLVWUsj24YF+7GXeod4eGjyWzAkOL74bAQudTi/TwSdjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744069265; c=relaxed/simple;
	bh=VkAushiJg8PznmhNDfBTv79LiMm52vT2It3WEREb5A4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XAV8V2TabavyFyKkQsqcMGuVpyO8sVtE7C8obwcZBmbAAgvwjLP10xIf7vNgP3fba0w6LMYySiBfhVdsD3Yp9618xiM1y8Fd9zAl/d/bZlt+SUkI6cKpxiDwIYHr/+VktNSMuThvqNXmXcIkZMEqBkG41hnHgKq3K78nDAPGP3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UljWvwMU; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UljWvwMU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744069263; x=1775605263;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VkAushiJg8PznmhNDfBTv79LiMm52vT2It3WEREb5A4=;
  b=UljWvwMU7p3g4nm4c+KTbqLRcdpasGehu1WHBAIoMp7MOn6PGuKl4WdH
   jbUmwBDscYP5sz2osP0s3XYKRUsP+ymCP2LBa71pyuXkM5Yb+NpuL2XaP
   nt8AGUDSL3Ye9IOBw6HzfKrrJDEgfcMZVD96E2hOhEpy0Qr8eyRDCYWDL
   ufXo2md2OTTaSKTWb9/alK1VH3O/bQk4r69FyT6UPZHgi3NWO2ZFnQwnQ
   qmtXfMy01+Fham4qbmW70IGNhR2WtPpGT3sVAG3hiJrx0VPK5zCcN9G32
   E3EdPP5+EK+MeDPECvCRfFeTNeCB4xLA6UV/6aEAFyHV8SZp98q7NkxZn
   A==;
X-CSE-ConnectionGUID: 0JLKpq7+QOW6LhzDOu05KA==
X-CSE-MsgGUID: wUtyh9zhSwuADLan6QJ/4g==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="48193250"
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="48193250"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:54 -0700
X-CSE-ConnectionGUID: KptcqHnaR0uqbfanru6Npg==
X-CSE-MsgGUID: XZjxMP3RQ0Gvu4m5VYBGOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="165315505"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:54 -0700
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
Subject: [PATCH v3 18/26] x86/resctrl: Add code to read core telemetry events
Date: Mon,  7 Apr 2025 16:40:20 -0700
Message-ID: <20250407234032.241215-19-tony.luck@intel.com>
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

The new telemetry events will be part of a new resctrl resource.
Add the RDT_RESOURCE_PERF_PKG to enum resctrl_res_level.

Add hook resctrl_arch_rmid_read() to pass reads on this
resource to the telemetry code.

There may be multiple devices tracking each package, so scan all of them
and add up counters.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl_types.h           |  1 +
 arch/x86/kernel/cpu/resctrl/internal.h  |  5 +++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 58 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c   |  6 +++
 4 files changed, 70 insertions(+)

diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
index fbd4b55c41aa..3354f21e82ad 100644
--- a/include/linux/resctrl_types.h
+++ b/include/linux/resctrl_types.h
@@ -39,6 +39,7 @@ enum resctrl_res_level {
 	RDT_RESOURCE_L2,
 	RDT_RESOURCE_MBA,
 	RDT_RESOURCE_SMBA,
+	RDT_RESOURCE_PERF_PKG,
 
 	/* Must be the last */
 	RDT_NUM_RESOURCES,
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 70b63bbc429d..1b1cbb948a9a 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -175,9 +175,14 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 #ifdef CONFIG_INTEL_AET_RESCTRL
 bool intel_aet_get_events(void);
 void __exit intel_aet_exit(void);
+int intel_aet_read_event(int domid, int rmid, int evtid, u64 *val);
 #else
 static inline bool intel_aet_get_events(void) { return false; }
 static inline void intel_aet_exit(void) { };
+static inline int intel_aet_read_event(int domid, int rmid, int evtid, u64 *val)
+{
+	return -EINVAL;
+}
 #endif
 
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 44d2fe747ed8..67a1245858dc 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -73,6 +73,12 @@ static struct evtinfo {
 	struct pmt_event	*pmt_event;
 } evtinfo[QOS_NUM_EVENTS];
 
+#define EVT_NUM_RMIDS(evtid)	(evtinfo[evtid].telem_entry->num_rmids)
+#define EVT_NUM_EVENTS(evtid)	(evtinfo[evtid].telem_entry->num_events)
+#define EVT_GUID(evtid)		(evtinfo[evtid].telem_entry->guid)
+
+#define EVT_OFFSET(evtid)	(evtinfo[evtid].pmt_event->evt_offset)
+
 /* All known telemetry event groups */
 static struct telem_entry *telem_entry[] = {
 	NULL
@@ -224,3 +230,55 @@ void __exit intel_aet_exit(void)
 	}
 	kfree(pkg_info);
 }
+
+#define VALID_BIT	BIT_ULL(63)
+#define DATA_BITS	GENMASK_ULL(62, 0)
+
+/*
+ * Walk the array of telemetry groups on a specific package.
+ * Read and sum values for a specific counter (described by
+ * guid and offset).
+ * Return failure (~0x0ull) if any counter isn't valid.
+ */
+static u64 scan_pmt_devs(int package, int guid, int offset)
+{
+	u64 rval, val;
+	int ndev = 0;
+
+	rval = 0;
+
+	for (int i = 0; i < pkg_info[package].count; i++) {
+		if (pkg_info[package].regions[i].guid != guid)
+			continue;
+		ndev++;
+		val = readq(pkg_info[package].regions[i].addr + offset);
+
+		if (!(val & VALID_BIT))
+			return ~0ull;
+		rval += val & DATA_BITS;
+	}
+
+	return ndev ? rval : ~0ull;
+}
+
+/*
+ * Read counter for an event on a domain (summing all aggregators
+ * on the domain).
+ */
+int intel_aet_read_event(int domid, int rmid, int evtid, u64 *val)
+{
+	u64 evtcount;
+	int offset;
+
+	if (rmid >= EVT_NUM_RMIDS(evtid))
+		return -ENOENT;
+
+	offset = rmid * EVT_NUM_EVENTS(evtid) * sizeof(u64);
+	offset += EVT_OFFSET(evtid);
+	evtcount = scan_pmt_devs(domid, EVT_GUID(evtid), offset);
+
+	if (evtcount != ~0ull || *val == 0)
+		*val += evtcount;
+
+	return evtcount != ~0ull ? 0 : -EINVAL;
+}
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 06623d51d006..4fa297d463ba 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -236,6 +236,12 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
 	u32 prmid;
 	int ret;
 
+	if (r->rid == RDT_RESOURCE_PERF_PKG) {
+		ret = intel_aet_read_event(d->hdr.id, rmid, eventid, val);
+
+		return ret ? ret : 0;
+	}
+
 	resctrl_arch_rmid_read_context_check();
 
 	prmid = logical_rmid_to_physical_rmid(cpu, rmid);
-- 
2.48.1

