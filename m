Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F183830DEB2
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 22:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760394857; cv=none; b=jRi+mHoEcEQhslnxfosNzpwIiuUE+NnVpNar03ryjDuaPqyuj5c4rgZyXM4GzacEyhtFYdVTt/4QHGvOXiw9XeNd99wpPyQSm1DPdHj72MM9NEQs7j3PfdIOHm8rTrKdvghnoTGQSyE8791Q8MhX3/mnBNav77TdJQCcp7xo6qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760394857; c=relaxed/simple;
	bh=tFgvA6nQK/kEl92p0apikoHu3NYvQAPYawomIGedmNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpQdq6YMxVJKLKV5Iy9KBvEDnscng1DukZVz66LGjYcwJDewgjE0XrLbrjMNrjkFF6kg339Pxgg/SOue1IfqqQItgIIFeeu87jf1uTVOGbYRI/qsoQEZV7CRGNiIMBgc/honT/7n0+TSjRPqwGZkiZD9+idqhQq+amOzkaQDqnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LaU1sWJt; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LaU1sWJt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760394854; x=1791930854;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tFgvA6nQK/kEl92p0apikoHu3NYvQAPYawomIGedmNg=;
  b=LaU1sWJtTaWXaKs1zQxwQrbDUg3RTn3+EGi6X6Wd5ERayxQZMjSmcn1k
   2E/p+dTOghBsfwZVBdXh60+hVFFMMKZwM5SX2bm+svA8Kv/NPOn5NhSIc
   VYqNRtmLp7VuSDBQQ55hQwwC8jmEcKsCHRp/90IlZCbXSA+DZ4G0+IziO
   1XS/F9kM9qRHRaqwMTRd9k8Rsg+jF6pwzV/BzSOtVantT9AgkLTlL/wz4
   XFw9ohw3yOlSj+CTu3XrdWkft2CeZTTgz+BpinckgAxF1P8aKSamMolHp
   vtx9gicEa7Nd3wYtH8BCenFxl7JePgQjRt/6tSi1aj41Pz5ANVRwANAig
   w==;
X-CSE-ConnectionGUID: 3Hql+ggQSQy6foogPdscBw==
X-CSE-MsgGUID: 0Y4LaxuzQrqXVHgvD0izGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="85168889"
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="85168889"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:03 -0700
X-CSE-ConnectionGUID: t60+F4BUQQCliyvPWSbggg==
X-CSE-MsgGUID: d+KxhRPRQbi6anUtiKJvEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="182145310"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.79])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:02 -0700
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
Subject: [PATCH v12 19/31] x86/resctrl: Read telemetry events
Date: Mon, 13 Oct 2025 15:33:33 -0700
Message-ID: <20251013223348.103390-20-tony.luck@intel.com>
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

Telemetry events are enabled during the first mount of the resctrl
file system.

Mark telemetry regions that did not pass the sanity checks by
clearing their MMIO address fields so that they will not be
used when reading events.

Introduce intel_aet_read_event() to read telemetry events for resource
RDT_RESOURCE_PERF_PKG. There may be multiple aggregators tracking each
package, so scan all of them and add up all counters. Aggregators may
return an invalid data indication if they have received no records for
a given RMID. Return success to the user if one or more aggregators
provide valid data.

Resctrl now uses readq() so depends on X86_64. Update Kconfig.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  |  7 ++++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 48 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c   |  3 ++
 fs/resctrl/monitor.c                    | 14 ++++++++
 arch/x86/Kconfig                        |  2 +-
 5 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 886261a82b81..97616c81682b 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -220,9 +220,16 @@ void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
 #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
 bool intel_aet_get_events(void);
 void __exit intel_aet_exit(void);
+int intel_aet_read_event(int domid, u32 rmid, enum resctrl_event_id evtid,
+			 void *arch_priv, u64 *val);
 #else
 static inline bool intel_aet_get_events(void) { return false; }
 static inline void __exit intel_aet_exit(void) { }
+static inline int intel_aet_read_event(int domid, u32 rmid, enum resctrl_event_id evtid,
+				       void *arch_priv, u64 *val)
+{
+	return -EINVAL;
+}
 #endif
 
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index a500b5d384fb..003b6426c8bd 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -12,13 +12,17 @@
 #define pr_fmt(fmt)   "resctrl: " fmt
 
 #include <linux/array_size.h>
+#include <linux/bits.h>
 #include <linux/cleanup.h>
 #include <linux/compiler_types.h>
+#include <linux/container_of.h>
 #include <linux/cpu.h>
 #include <linux/err.h>
+#include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/intel_pmt_features.h>
 #include <linux/intel_vsec.h>
+#include <linux/io.h>
 #include <linux/overflow.h>
 #include <linux/printk.h>
 #include <linux/resctrl.h>
@@ -230,3 +234,47 @@ void __exit intel_aet_exit(void)
 		(*peg)->pfg = NULL;
 	}
 }
+
+#define DATA_VALID	BIT_ULL(63)
+#define DATA_BITS	GENMASK_ULL(62, 0)
+
+/*
+ * Read counter for an event on a domain (summing all aggregators
+ * on the domain). If an aggregator hasn't received any data for a
+ * specific RMID, the MMIO read indicates that data is not valid.
+ * Return success if at least one aggregator has valid data.
+ */
+int intel_aet_read_event(int domid, u32 rmid, enum resctrl_event_id eventid,
+			 void *arch_priv, u64 *val)
+{
+	struct pmt_event *pevt = arch_priv;
+	struct event_group *e;
+	bool valid = false;
+	u64 evtcount;
+	void *pevt0;
+	u32 idx;
+
+	pevt0 = pevt - pevt->idx;
+	e = container_of(pevt0, struct event_group, evts);
+	idx = rmid * e->num_events;
+	idx += pevt->idx;
+
+	if (idx * sizeof(u64) + sizeof(u64) > e->mmio_size) {
+		pr_warn_once("MMIO index %u out of range\n", idx);
+		return -EIO;
+	}
+
+	for (int i = 0; i < e->pfg->count; i++) {
+		if (!e->pfg->regions[i].addr)
+			continue;
+		if (e->pfg->regions[i].plat_info.package_id != domid)
+			continue;
+		evtcount = readq(e->pfg->regions[i].addr + idx * sizeof(u64));
+		if (!(evtcount & DATA_VALID))
+			continue;
+		*val += evtcount & DATA_BITS;
+		valid = true;
+	}
+
+	return valid ? 0 : -EINVAL;
+}
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 5565a8752266..6804b83934e8 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -252,6 +252,9 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 
 	resctrl_arch_rmid_read_context_check();
 
+	if (r->rid == RDT_RESOURCE_PERF_PKG)
+		return intel_aet_read_event(hdr->id, rmid, eventid, arch_priv, val);
+
 	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		return -EINVAL;
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index faaa2851c5c2..84a0cbe90748 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -526,12 +526,26 @@ static bool cpu_on_correct_domain(struct rmid_read *rr)
 
 static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 {
+	u64 tval = 0;
+
 	if (!cpu_on_correct_domain(rr))
 		return -EINVAL;
 
 	switch (rr->r->rid) {
 	case RDT_RESOURCE_L3:
 		return __l3_mon_event_count(rdtgrp, rr);
+
+	case RDT_RESOURCE_PERF_PKG:
+		rr->err = resctrl_arch_rmid_read(rr->r, rr->hdr, rdtgrp->closid,
+						 rdtgrp->mon.rmid, rr->evt->evtid,
+						 rr->evt->arch_priv,
+						 &tval, rr->arch_mon_ctx);
+		if (rr->err)
+			return rr->err;
+
+		rr->val += tval;
+
+		return 0;
 	default:
 		return -EINVAL;
 	}
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index da5775056ec8..60ace4427ede 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -538,7 +538,7 @@ config X86_CPU_RESCTRL
 
 config X86_CPU_RESCTRL_INTEL_AET
 	bool "Intel Application Energy Telemetry"
-	depends on X86_CPU_RESCTRL && CPU_SUP_INTEL && INTEL_PMT_TELEMETRY=y && INTEL_TPMI=y
+	depends on X86_64 && X86_CPU_RESCTRL && CPU_SUP_INTEL && INTEL_PMT_TELEMETRY=y && INTEL_TPMI=y
 	help
 	  Enable per-RMID telemetry events in resctrl.
 
-- 
2.51.0

