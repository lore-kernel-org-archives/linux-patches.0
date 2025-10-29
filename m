Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0416C355027
	for <patches@lists.linux.dev>; Wed, 29 Oct 2025 16:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761754904; cv=none; b=PzbsINme9ikSxLMY0pcCry0/xYWX8WP7mwDWDO/vr1fRb9IOg2eJd+y/JiKg8dBsbHGZTahr12BQWfrAisU/VkTA6D/dNvvrzMCv1Cht6mcukq1a72BKbvMbcjD23QVSKNTTefCR3bayzqHrLDksP/6ffUiu3abMKJlTztJ6eIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761754904; c=relaxed/simple;
	bh=rtvkHw99GXszw5v3CuR672XgqNLmNSKrcHULKOOi5TA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZTzJp7CH1eI7zexNadi6z9wu9X4hi15DQeEdiuALOvpAEjzVIc/cv4q8SDmLTeAtXcRUv076lNt2VmO6ggr/cxtM3YfwWGfxXAcgcdTK151JqNyuf84xknINV/bF96MhvGhHxCGI5hdOh6pNzGQv3v3/i7ERNRHOGoAjNBYYGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=msnAGspi; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="msnAGspi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761754902; x=1793290902;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rtvkHw99GXszw5v3CuR672XgqNLmNSKrcHULKOOi5TA=;
  b=msnAGspicCJ2upGdVJqQz+5cWu8AyMdQge/mSgnASMNoTB+QOV+bxq/u
   DrY4SkcF0MqeEtrk1ni8WuELhUxrEWrtECUX+o+EnWHVPMKNNihLhUFx5
   /mWEIPc1rF0JWtajluU3irgklV6AKoq7XnbcsecM9mwFhhZFkpbTXj2KQ
   GadwmIcp2NyAtBeUPwYlKvjm5tYjTuLtBUVLGF+D4e/kk0r06z/D2d8NQ
   7IyvIpP7zVTUnylBaqHe85Ru+c7thn6P+wdKwoPe6FykCQoXxUmy+m2TG
   ROsxpUkszqlXD9Un8fj7U9GF8vYk7LFSno8y0amjnx8Uuwus6NgALkhVj
   Q==;
X-CSE-ConnectionGUID: ZVoNMAE+T2WXeiY+6QNIbQ==
X-CSE-MsgGUID: OEzI7WnXRYyLZ/f+bVLOkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="74481332"
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="74481332"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 09:21:32 -0700
X-CSE-ConnectionGUID: YkQqccUeQZuX7Q06SPvWzw==
X-CSE-MsgGUID: Wik4tObFRmKVTAAmVdMYTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="184901379"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.146])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 09:21:32 -0700
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
Subject: [PATCH v13 20/32] x86/resctrl: Read telemetry events
Date: Wed, 29 Oct 2025 09:21:03 -0700
Message-ID: <20251029162118.40604-21-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251029162118.40604-1-tony.luck@intel.com>
References: <20251029162118.40604-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce intel_aet_read_event() to read telemetry events for resource
RDT_RESOURCE_PERF_PKG. There may be multiple aggregators tracking each
package, so scan all of them and add up all counters. Aggregators may
return an invalid data indication if they have received no records for
a given RMID. User will see "Unavailable" if none of the aggregators
on a package provide valid counts.

Resctrl now uses readq() so depends on X86_64. Update Kconfig.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  |  7 ++++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 52 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c   |  4 ++
 fs/resctrl/monitor.c                    | 14 +++++++
 arch/x86/Kconfig                        |  2 +-
 5 files changed, 78 insertions(+), 1 deletion(-)

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
index e8da70eaa7c6..f64fb7d0c8a9 100644
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
@@ -217,3 +221,51 @@ void __exit intel_aet_exit(void)
 		}
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
index 2f62a834787d..3f511543748d 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -251,6 +251,10 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 	int ret;
 
 	resctrl_arch_rmid_read_context_check();
+
+	if (r->rid == RDT_RESOURCE_PERF_PKG)
+		return intel_aet_read_event(hdr->id, rmid, eventid, arch_priv, val);
+
 	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		return -EINVAL;
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 9cc54d04b2ac..a04c1724fc44 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -514,6 +514,20 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 		return __l3_mon_event_count(rdtgrp, rr, d);
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

