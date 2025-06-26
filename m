Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0372F0E21
	for <patches@lists.linux.dev>; Thu, 26 Jun 2025 16:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750956609; cv=none; b=eHG7l8expQ96PLqb0uMJIjruBUrl3ynAF4UAflyLUXPcHzzYihibpoQwi50uJifjhrA7xxX3elOpYyG/X/4IHDItX9K5nIoI84DQob4maWMQ14xrRZfoTPT8Y5TFJ9ao2wrsjWaOPydLVKGhpecUHKsnzme5A+sLgYA+LpfpBwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750956609; c=relaxed/simple;
	bh=OiptYH8E0/SvM8nBFEDnaTRh4DAi+rqMk7MELfRmaWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgiXJ9dJfER+dZ7shQPZliJhXfYbcc3GaawRyKDZdPihLg+TuLaA5LfKv6BKbR7w4q6xtLTKHsX98IRF83G/9Utxlu4cAX1C1eL/iwea1+zTr12fGJ9QQ9vkZnCH/0g2t/VMVjtd3tbh1cq9PKk/y/+qefcYxhKV5r00JN4kJcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cU+oHyMu; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cU+oHyMu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750956608; x=1782492608;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OiptYH8E0/SvM8nBFEDnaTRh4DAi+rqMk7MELfRmaWI=;
  b=cU+oHyMu4WsDlLLYbu+vomoeOffHw7hCbbKzpuF55FqTWxE8Ko5t0jOr
   B00+O8b0ZgSE678pACG0PdX1MrmvPCt0SQFq636W/P3pVB2kNAfZmUWYj
   UkQjG4XBj3KsoQveJu1/aYZluMnU6oNsGHV765MEG44RWeVxDhFU/W3Pi
   puX/WhsSi9W/C+5lZLqg7DtrTDvronOEo5UcTiUClPLsQFMvgbL8+Hw/a
   uHFK5oeHkaIJ1nj6a0QssiO7LMTEfE/mV5k6gm9/NCb8G0kyTm8TdimnF
   b+4amwlQ044kYiFX437fkjTBZl87/nhD5SBoAjfFRcaC2O9p4ppYcQ5tG
   w==;
X-CSE-ConnectionGUID: DC4kz2CoTmqS8YPtEchvfg==
X-CSE-MsgGUID: uWcdtacLRn6EWWY4cw49VQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="53136495"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="53136495"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:50:01 -0700
X-CSE-ConnectionGUID: bGXSNcmLTBGRDJA7+O5ivQ==
X-CSE-MsgGUID: liI7gRN9Sc26EVSgoIQF0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="153069283"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:50:00 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v6 22/30] x86/resctrl: Read core telemetry events
Date: Thu, 26 Jun 2025 09:49:31 -0700
Message-ID: <20250626164941.106341-23-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250626164941.106341-1-tony.luck@intel.com>
References: <20250626164941.106341-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The resctrl file system passes requests to read event monitor files to
the architecture resctrl_arch_rmid_read() to collect values
from hardware counters.

Use the resctrl resource to differentiate between calls to read legacy
L3 events from the new telemetry events (which are attached to
RDT_RESOURCE_PERF_PKG).

There may be multiple aggregators tracking each package, so scan all of
them and add up all counters.

Enable the events marked as readable from any CPU providing an
mon_evt::arch_priv pointer to the struct pmt_event for each
event.

At run time when a user reads an event file the file system code
provides the enum resctrl_event_id for the event and the arch_priv
pointer that was supplied when the event was enabled.

Resctrl now uses readq() so depends on X86_64. Update Kconfig.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  |  2 ++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 46 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c   |  3 ++
 arch/x86/Kconfig                        |  2 +-
 4 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index e93b15bf6aab..e8d2a754bc0c 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -171,5 +171,7 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 
 bool intel_aet_get_events(void);
 void __exit intel_aet_exit(void);
+int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid,
+			 void *arch_priv, u64 *val);
 
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index f9b2959693a0..10fd8b04105e 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -14,6 +14,7 @@
 #include <linux/cleanup.h>
 #include <linux/cpu.h>
 #include <linux/intel_vsec.h>
+#include <linux/io.h>
 #include <linux/resctrl.h>
 #include <linux/slab.h>
 
@@ -206,6 +207,13 @@ static int configure_events(struct event_group *e, struct pmt_feature_group *p)
 	}
 	e->pkginfo = no_free_ptr(pkginfo);
 
+	for (int i = 0; i < e->num_events; i++) {
+		enum resctrl_event_id eventid;
+
+		eventid = e->evts[i].id;
+		resctrl_enable_mon_event(eventid, true, e->evts[i].bin_bits, &e->evts[i]);
+	}
+
 	return 0;
 }
 
@@ -268,3 +276,41 @@ void __exit intel_aet_exit(void)
 		free_mmio_info((*peg)->pkginfo);
 	}
 }
+
+#define DATA_VALID	BIT_ULL(63)
+#define DATA_BITS	GENMASK_ULL(62, 0)
+
+/*
+ * Read counter for an event on a domain (summing all aggregators
+ * on the domain).
+ */
+int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id eventid,
+			 void *arch_priv, u64 *val)
+{
+	struct pmt_event *pevt = arch_priv;
+	struct mmio_info *mmi;
+	struct event_group *e;
+	u64 evtcount;
+	void *pevt0;
+	int idx;
+
+	pevt0 = pevt - pevt->idx;
+	e = container_of(pevt0, struct event_group, evts);
+	idx = rmid * e->num_events;
+	idx += pevt->idx;
+	mmi = e->pkginfo[domid];
+
+	if (idx * sizeof(u64) + sizeof(u64) > e->mmio_size) {
+		pr_warn_once("MMIO index %d out of range\n", idx);
+		return -EIO;
+	}
+
+	for (int i = 0; i < mmi->num_regions; i++) {
+		evtcount = readq(mmi->addrs[i] + idx * sizeof(u64));
+		if (!(evtcount & DATA_VALID))
+			return -EINVAL;
+		*val += evtcount & DATA_BITS;
+	}
+
+	return 0;
+}
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 185b203f6321..51d7d99336c6 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -232,6 +232,9 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 
 	resctrl_arch_rmid_read_context_check();
 
+	if (r->rid == RDT_RESOURCE_PERF_PKG)
+		return intel_aet_read_event(hdr->id, rmid, eventid, arch_priv, val);
+
 	if (r->rid != RDT_RESOURCE_L3)
 		return -EINVAL;
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8eb68d2230be..a6b6ecbd3877 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -507,7 +507,7 @@ config X86_MPPARSE
 
 config X86_CPU_RESCTRL
 	bool "x86 CPU resource control support"
-	depends on X86 && (CPU_SUP_INTEL || CPU_SUP_AMD)
+	depends on X86_64 && (CPU_SUP_INTEL || CPU_SUP_AMD)
 	depends on MISC_FILESYSTEMS
 	select ARCH_HAS_CPU_RESCTRL
 	select RESCTRL_FS
-- 
2.49.0

