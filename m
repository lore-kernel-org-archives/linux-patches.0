Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA3A324B2E
	for <patches@lists.linux.dev>; Mon, 24 Nov 2025 18:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010504; cv=none; b=RfSSCNNkMWy99BrndoKKNj9q7ItS/gdlpikeMstIGoB+8OqUdc+yMvBNP0jqGxLGVIJRJg4mTNPGpMXXpMw/jbSRCiRv8dp5K2aKnKEDzfV1VcTf+cFaf+g+QhXemNAfYEBWGEzmOBdGYKwBg61Vcj95pFZO2wQ7MIrHtvaYab0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010504; c=relaxed/simple;
	bh=elSTMcZpYXJ1U1xYtin17erduBVFEv4aqYAbm0URDn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gc+uerl6WTXuXVndrYJI/vKKvtZXmC1XTYIZ8mDXuABZbbP2613Q2O8KLKuzALsIYCoyBgmnWWkwMUSUOn2lVfcpa8LRojoH6O3kEGzTnhNBCOWSl2v32qTwkdq00Jkj+a0iUdXpIOpz7mdqnso871UWV7tqOsTMFp7LefALv3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kxa85m4T; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kxa85m4T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764010503; x=1795546503;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=elSTMcZpYXJ1U1xYtin17erduBVFEv4aqYAbm0URDn0=;
  b=kxa85m4T5Ohozdx9nuis35PGzI8515+DPIfanvTYHFI3EaJ6K8tIHMJy
   gfN4em5mgv5xBtbv4dhGfoVzmE9HVvwsEZ6dRolRUEsrdYuvsW2ZJGgEc
   r0LIQTJ4Ynsryt6dZHIvgLFliYT1ZX7gua4PrtmCXu9XoqBYiz2y2Yo9q
   hzmUk0nPjveDd9G9tNEvEAfPIWohdMj61utgLx75duxdUTZKQOJbn4lOt
   ZDOJ4jJagS/RuWk7wdhI6adnQYl49vmBu3N9VkEJt9rWTKA/LhogTakin
   PBVJ98X4rWXZ7zbrycN3YNvTp1Lmi7m9i32lFpblH8ShTGIMrKIiFBfDh
   g==;
X-CSE-ConnectionGUID: gAk/4QMTSkqv/hnqzwH6HQ==
X-CSE-MsgGUID: 8VQ+xp4zRDqDgXeVZ1Qutw==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="76636771"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="76636771"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:29 -0800
X-CSE-ConnectionGUID: hG7iwNwoRAWn8Er2/HK+pQ==
X-CSE-MsgGUID: nvyew+SYRgWLcQ3Q/ggTTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="192225011"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:28 -0800
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
Subject: [PATCH v14 20/32] x86/resctrl: Read telemetry events
Date: Mon, 24 Nov 2025 10:53:57 -0800
Message-ID: <20251124185412.24155-21-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251124185412.24155-1-tony.luck@intel.com>
References: <20251124185412.24155-1-tony.luck@intel.com>
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
---
 arch/x86/kernel/cpu/resctrl/internal.h  |  5 +++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 51 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c   |  4 ++
 fs/resctrl/monitor.c                    | 14 +++++++
 arch/x86/Kconfig                        |  2 +-
 5 files changed, 75 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index e15300b6bae9..88095cae4ac2 100644
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
index b6b50650e634..bf3c70590d4c 100644
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
@@ -221,3 +225,50 @@ void __exit intel_aet_exit(void)
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
index 338a122dfcff..8c90a24ae0d0 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -520,6 +520,20 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 			return __l3_mon_event_count(rdtgrp, rr);
 		else
 			return __l3_mon_event_count_sum(rdtgrp, rr);
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
index 126c89afcf69..afd32ca41c72 100644
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

