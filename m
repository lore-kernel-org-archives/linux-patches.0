Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74A02EE61C
	for <patches@lists.linux.dev>; Fri, 29 Aug 2025 19:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756496051; cv=none; b=KPRjE9kcwag/+CUKctdELm8hfj+TPQNb6NO7rtnHCpRaor4A4JtHMY4qU9IPe8IbEwt+bR1Ld8r1YPbAzJzcgQt+ybyMlSKcNQqcxZf2vap+jvocK1htQuRi1T/KYvzUmCa1pTuTVr1IEhIuIrskZUJfC9rXZU+CyDq0uIYD8J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756496051; c=relaxed/simple;
	bh=7QMN9b7SlJZlu5xFqH/n2H6loELeuLunhM+odA40Ix4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=na0PeEeC5911RFhtjxYVs2ABKeQpVoIVDUc9jPIMtkaIdZSrbNvKBiPcDtkCszX/kaazF00+VPiobiAl+fIqWQaophixrTiqLSOgDVfsIgNQchdyJWYuRRls6Sd19JZMHCFns0MQxw2sd//e4AwLltR6QcBE40cwjrJ38mjWYmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YLaOXhZK; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YLaOXhZK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756496048; x=1788032048;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7QMN9b7SlJZlu5xFqH/n2H6loELeuLunhM+odA40Ix4=;
  b=YLaOXhZKxi+qt962beqSDZQKN3ZkV0I84Zo+1bub0ro0DmJ0n74ReAlJ
   BU305iPWTzuU4mwxxsdKnWHT8eqOfDvEsq1iuFf2rS8+1XLlgFpxpr4yT
   XkXJp5cqqJ0Pe22OKDmvXQ8t+wgu8WN4bH7q0qSYVZnOHSqTVeDiDu5yO
   1FqJgOMEh/+P6FupTAZ9wxlo0qVfxMrVs1D1aeD5ptLgT2tXx0u1qzXQE
   3+G56pvNaiOTGhHRLaMy+KWSPJXT28uvIXTeNRUpwlSR4ik4fFEf1xxMR
   BPf4T7bEEQUCU1VxECYiSLCCKeeTaEpQ7mRGFxdC/ukyOvbpG42LP8zho
   w==;
X-CSE-ConnectionGUID: nFx8qnY3R8Cp2s/4pOobzg==
X-CSE-MsgGUID: fDsvl2TRReerjuDM7ySWjg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62625334"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62625334"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:33:56 -0700
X-CSE-ConnectionGUID: 2ER0hYQvSBykVlbLYQT19A==
X-CSE-MsgGUID: /DVzThcES+y5qNQkor3DkA==
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
Subject: [PATCH v9 22/31] x86/resctrl: Handle domain creation/deletion for RDT_RESOURCE_PERF_PKG
Date: Fri, 29 Aug 2025 12:33:34 -0700
Message-ID: <20250829193346.31565-23-tony.luck@intel.com>
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

The L3 resource has several requirements for domains. There are per-domain
structures that hold the 64-bit values of counters, and elements to keep
track of the overflow and limbo threads.

None of these are needed for the PERF_PKG resource. The hardware counters
are wide enough that they do not wrap around for decades.

Define a new rdt_perf_pkg_mon_domain structure which just consists of
the standard rdt_domain_hdr to keep track of domain id and CPU mask.

Support the PERF_PKG resource in the CPU online/offline handlers.
Allocate and initialize the rdt_perf_pkg_mon_domain structure when the
first CPU of a domain comes online and do necessary cleanup when the
last CPU of a domain goes offline.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  | 13 +++++++++++++
 arch/x86/kernel/cpu/resctrl/core.c      | 12 ++++++++++++
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 24 ++++++++++++++++++++++++
 3 files changed, 49 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 8986071dd72a..b054c7cd13f1 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -75,6 +75,14 @@ static inline struct rdt_hw_l3_mon_domain *resctrl_to_arch_mon_dom(struct rdt_l3
 	return container_of(r, struct rdt_hw_l3_mon_domain, d_resctrl);
 }
 
+/**
+ * struct rdt_perf_pkg_mon_domain - CPUs sharing an package scoped resctrl monitor resource
+ * @hdr:	common header for different domain types
+ */
+struct rdt_perf_pkg_mon_domain {
+	struct rdt_domain_hdr   hdr;
+};
+
 /**
  * struct msr_param - set a range of MSRs from a domain
  * @res:       The resource to use
@@ -174,6 +182,8 @@ bool intel_aet_get_events(void);
 void __exit intel_aet_exit(void);
 int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid,
 			 void *arch_priv, u64 *val);
+void intel_aet_setup_mon_domain(int cpu, int id, struct rdt_resource *r,
+				struct list_head *add_pos);
 #else
 static inline bool intel_aet_get_events(void) { return false; }
 static inline void __exit intel_aet_exit(void) { }
@@ -182,6 +192,9 @@ static inline int intel_aet_read_event(int domid, int rmid, enum resctrl_event_i
 {
 	return -EINVAL;
 }
+
+static inline void intel_aet_setup_mon_domain(int cpu, int id, struct rdt_resource *r,
+					      struct list_head *add_pos) { }
 #endif
 
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 039a00c58514..5745c6979293 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -574,6 +574,9 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 	case RDT_RESOURCE_L3:
 		l3_mon_domain_setup(cpu, id, r, add_pos);
 		break;
+	case RDT_RESOURCE_PERF_PKG:
+		intel_aet_setup_mon_domain(cpu, id, r, add_pos);
+		break;
 	default:
 		pr_warn_once("Unknown resource rid=%d\n", r->rid);
 		break;
@@ -671,6 +674,15 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 		synchronize_rcu();
 		l3_mon_domain_free(hw_dom);
 		break;
+	case RDT_RESOURCE_PERF_PKG:
+		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_PERF_PKG))
+			return;
+
+		resctrl_offline_mon_domain(r, hdr);
+		list_del_rcu(&hdr->list);
+		synchronize_rcu();
+		kfree(container_of(hdr, struct rdt_perf_pkg_mon_domain, hdr));
+		break;
 	default:
 		pr_warn_once("Unknown resource rid=%d\n", r->rid);
 		break;
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 9239740e9647..71aed96f9499 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -255,3 +255,27 @@ int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id eventid,
 
 	return valid ? 0 : -EINVAL;
 }
+
+void intel_aet_setup_mon_domain(int cpu, int id, struct rdt_resource *r,
+				struct list_head *add_pos)
+{
+	struct rdt_perf_pkg_mon_domain *d;
+	int err;
+
+	d = kzalloc_node(sizeof(*d), GFP_KERNEL, cpu_to_node(cpu));
+	if (!d)
+		return;
+
+	d->hdr.id = id;
+	d->hdr.type = RESCTRL_MON_DOMAIN;
+	d->hdr.rid = r->rid;
+	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
+	list_add_tail_rcu(&d->hdr.list, add_pos);
+
+	err = resctrl_online_mon_domain(r, &d->hdr);
+	if (err) {
+		list_del_rcu(&d->hdr.list);
+		synchronize_rcu();
+		kfree(d);
+	}
+}
-- 
2.50.1

