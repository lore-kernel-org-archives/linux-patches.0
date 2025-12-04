Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423AC328616
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 20:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764881675; cv=none; b=rhA8nKF1shlTqKoYW5Tn13LvSridh32iiQyAaPnQc4WxMo3guCc6YWODObtuZjqRL/ByMgs9sUrVUpfjyG49MXeswpFj+bp+KbHnqiALexpAeBhWdEj6LNWQPTvmKI1CYKAD8Yo40IzA4Q6OP8DJUqDlPeC5/a4R3zVZgmAx+H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764881675; c=relaxed/simple;
	bh=upL5fYFchnBxZeE3JP/gOFxFpTtLRTRKUexJZ+e8PrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbIIEyUrGBroUOMiJGVjj1q05qPbNGJBt3cJ6gMpBj1qo+rlbGUVLHedKBz1rWgP1lrF8Tyac2cujG1vaqakm24371VvECj9mR+UCTbOMcwgnzNGEZSqsRDdMngZS24/gxSR+T2uazjHU28K9WBuifrigQRt4mM6Y9SfIqiAB9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wgawbprl; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wgawbprl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764881673; x=1796417673;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=upL5fYFchnBxZeE3JP/gOFxFpTtLRTRKUexJZ+e8PrQ=;
  b=Wgawbprl83MA2zX+O0NNu6+1sNOW7sE8XAfCReh23wEt/ul6p8HhN1r1
   vlK6XyBb0kGhDGdVzomgRJUIycpkwOj6jkwDQjVmOrnxAv4Rs7SiyCSA3
   D0ZAz7bPZc1vnCfiLKcFYpuJNhVYT5otMO08pBBqUtzclrFTpH7bCF7Qj
   d53glicRHtKzHgt7yKcZo1UoX3VngL3ExjwL9aq63CF0a1WzlIOvHeh4Y
   RXMpZITvP7NfG5daIMdOv6DPQ8URmxbws94sIDAtgREFnZXPh1eYG8nKv
   zM7lNhh/df197BvlVAVH56YvBK3Bc1AmOSDdgtEcOtZca493BRDhDlhC9
   Q==;
X-CSE-ConnectionGUID: W8nrZ8ErR9GE8qV2pDCF7w==
X-CSE-MsgGUID: lkyPnbXsTNaV7J1+/5OteA==
X-IronPort-AV: E=McAfee;i="6800,10657,11632"; a="69511019"
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="69511019"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 12:54:26 -0800
X-CSE-ConnectionGUID: mcbMgTZxSD2A/lDhhp0/Gw==
X-CSE-MsgGUID: N3PEGpoHSquRuoUjDk0h7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="225752829"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.165])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 12:54:26 -0800
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
Subject: [PATCH v15 20/32] x86/resctrl: Read telemetry events
Date: Thu,  4 Dec 2025 12:53:50 -0800
Message-ID: <20251204205404.12763-21-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251204205404.12763-1-tony.luck@intel.com>
References: <20251204205404.12763-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce intel_aet_read_event() to read telemetry events for resource
RDT_RESOURCE_PERF_PKG. There may be multiple aggregators tracking each package,
so scan all of them and add up all counters. Aggregators may return an invalid
data indication if they have received no records for a given RMID. User will
see "Unavailable" if none of the aggregators on a package provide valid counts.

Resctrl now uses readq() so depends on X86_64. Update Kconfig.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  |  5 +++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 51 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c   |  4 ++
 fs/resctrl/monitor.c                    | 14 +++++++
 arch/x86/Kconfig                        |  2 +-
 5 files changed, 75 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index f2e6e3577df0..10743f5d5fd4 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -225,9 +225,14 @@ void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
 #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
 bool intel_aet_get_events(void);
 void __exit intel_aet_exit(void);
+int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
 #else
 static inline bool intel_aet_get_events(void) { return false; }
 static inline void __exit intel_aet_exit(void) { }
+static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
+{
+	return -EINVAL;
+}
 #endif
 
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index bc42df4498f8..85ca24e42ec1 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -11,11 +11,15 @@
 
 #define pr_fmt(fmt)   "resctrl: " fmt
 
+#include <linux/bits.h>
 #include <linux/compiler_types.h>
+#include <linux/container_of.h>
 #include <linux/err.h>
+#include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/intel_pmt_features.h>
 #include <linux/intel_vsec.h>
+#include <linux/io.h>
 #include <linux/printk.h>
 #include <linux/resctrl.h>
 #include <linux/resctrl_types.h>
@@ -237,3 +241,50 @@ void __exit intel_aet_exit(void)
 		}
 	}
 }
+
+#define DATA_VALID	BIT_ULL(63)
+#define DATA_BITS	GENMASK_ULL(62, 0)
+
+/*
+ * Read counter for an event on a domain (summing all aggregators on the
+ * domain). If an aggregator hasn't received any data for a specific RMID,
+ * the MMIO read indicates that data is not valid.  Return success if at
+ * least one aggregator has valid data.
+ */
+int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
+{
+	struct pmt_event *pevt = arch_priv;
+	struct event_group *e;
+	bool valid = false;
+	u64 total = 0;
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
+		total += evtcount & DATA_BITS;
+		valid = true;
+	}
+
+	if (valid)
+		*val = total;
+
+	return valid ? 0 : -EINVAL;
+}
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 6929614ba6e6..e6a154240b8d 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -251,6 +251,10 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 	int ret;
 
 	resctrl_arch_rmid_read_context_check();
+
+	if (r->rid == RDT_RESOURCE_PERF_PKG)
+		return intel_aet_read_event(hdr->id, rmid, arch_priv, val);
+
 	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		return -EINVAL;
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 83652130a8a6..8d2b0bb0bfc9 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -528,6 +528,20 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 		} else {
 			return __l3_mon_event_count_sum(rdtgrp, rr);
 		}
+	case RDT_RESOURCE_PERF_PKG: {
+		u64 tval = 0;
+
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
+	}
 	default:
 		rr->err = -EINVAL;
 		return -EINVAL;
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 52dda19d584d..4cf9de520baf 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -540,7 +540,7 @@ config X86_CPU_RESCTRL
 
 config X86_CPU_RESCTRL_INTEL_AET
 	bool "Intel Application Energy Telemetry"
-	depends on X86_CPU_RESCTRL && CPU_SUP_INTEL && INTEL_PMT_TELEMETRY=y && INTEL_TPMI=y
+	depends on X86_64 && X86_CPU_RESCTRL && CPU_SUP_INTEL && INTEL_PMT_TELEMETRY=y && INTEL_TPMI=y
 	help
 	  Enable per-RMID telemetry events in resctrl.
 
-- 
2.51.1

