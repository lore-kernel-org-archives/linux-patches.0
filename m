Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1607497389
	for <patches@lists.linux.dev>; Tue, 29 Sep 2026 17:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790704357; cv=none; b=b9QGg+nZcbBW5bRBUkhsofgWsu5D5tyZFa4I0tTWM/U+IzqiNmRxm41BrezGJunemoM/3QCEQFCY6OI8Mg+cjyX9vFrH35D1I0q3HinM0OOiNDkOr2L2Es/hOxnvP7Hw5Sx5KGGf6bmNqrpN8pBkKnKt0jGdwnVCkY/E073B51Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790704357; c=relaxed/simple;
	bh=j1Z5bfCxqQ914Rixqv/n9+8vAenQaHc/PM2jNbZaxy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5jBNkxYgvaCdnpoCItLxDFKHXZ/O9+NMp7uyrqt9i8iJqtN0ntbRvli5F/1E1VGrbFv98ijQAJDwlnf/rVTxCLrOQpEN2T9THKVDhqA3ksu5ZYs1579oXLncbSBahHgK6LVrQPKuIgvaQp6/KMmvJeiUdkCZ3a2uEOkyDcNlmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RSKoUOzC; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RSKoUOzC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790704352; x=1822240352;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j1Z5bfCxqQ914Rixqv/n9+8vAenQaHc/PM2jNbZaxy0=;
  b=RSKoUOzCZf+WVsDqJ/CNz+uTp8ajcNz2oLtShdn3sHYS86cnbSsD+79t
   BrqGyFUzjk+zXZdgxELWuN+IhrIDzpG1RsmHFwUyX+8WxHFjot+Pnmrpu
   AJkpyijyBlLiTZG9LBDRc1MIOY+SHggWUT5QLFMmC0rV3IcJ5veso0+h5
   rKDdY7lV1AYFv8U/B63MSoPW39t9/mHsEvkGcQ8qSd7MizqXHdonI2q/t
   O4TYk6FxTgXGjDYggCB+cvh3SETk03F4MGIzhERGkprlOsb5dM94tDgQN
   kt5Y+bxog6eS0IfpEK96rzt5qdU3/stQExG5GGuR1CyXa5pDY6LZNjUbk
   g==;
X-CSE-ConnectionGUID: xLWznuhxS96Nbv6wLcgBuA==
X-CSE-MsgGUID: t+UFpTefRjuGmcyf3JAhwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="90198059"
X-IronPort-AV: E=Sophos;i="6.27,130,1787036400"; 
   d="scan'208";a="90198059"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2026 10:52:31 -0700
X-CSE-ConnectionGUID: 3IHIoIpaQk2J/KjSeizPvQ==
X-CSE-MsgGUID: grBByMTfQxaVhI9nr17OCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,130,1787036400"; 
   d="scan'208";a="274542425"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.232])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2026 10:52:31 -0700
From: Tony Luck <tony.luck@intel.com>
To: tony.luck@intel.com
Cc: Dave.Martin@arm.com,
	babu.moger@amd.com,
	david.e.box@intel.com,
	dfustini@baylibre.com,
	fenghuay@nvidia.com,
	hch@infradead.org,
	james.morse@arm.com,
	linux-kernel@vger.kernel.org,
	maciej.wieczor-retman@intel.com,
	patches@lists.linux.dev,
	peternewman@google.com,
	reinette.chatre@intel.com,
	x86@kernel.org,
	yu.c.chen@intel.com
Subject: [PATCH v14.1 18/25] x86/resctrl: Use registered function pointers for AET enumeration
Date: Tue, 29 Sep 2026 10:52:24 -0700
Message-ID: <20260929175224.16565-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928221509.68002-19-tony.luck@intel.com>
References: <20260928221509.68002-19-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The pmt_telemetry driver registers enumeration functions with resctrl
Application Energy Telemetry (AET) code.

Use the function pointers instead of direct function calls in preparation
for the telemetry driver to be a loadable module.

The pmt_telemetry is forced to be built-in to the kernel, so it does not matter
at this point that there is no matching module_put() for the try_module_get()
in intel_aet_pre_mount(). This must be resolved with additions in the file
system unmount path before pmt_telemetry can be configured as a module.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v14:
	Updates to resolve locking problems reported by Sashiko in v13.

	AET is now going to use a single mutex for both registration
	and in a later patch for device removal. So change the name
	from aet_register_lock to just aet_lock.

	Reverse locking hierarchy between AET and pmt_telemetry.
	No longer OK to call into pmt_telemetry to enumerate
	features with the aet_lock held. Instead, make use of
	module pinning while holding aet_lock.
---
 arch/x86/kernel/cpu/resctrl/internal.h  |  4 +-
 arch/x86/kernel/cpu/resctrl/core.c      |  2 +-
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 59 ++++++++++++++++++++++---
 3 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index c038b7d80ce3..8406addc05f5 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -234,15 +234,15 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
 
 #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
-bool intel_aet_get_events(void);
 void __exit intel_aet_exit(void);
+bool intel_aet_pre_mount(void);
 int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
 void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
 				struct list_head *add_pos);
 bool intel_handle_aet_option(bool force_off, char *tok);
 #else
-static inline bool intel_aet_get_events(void) { return false; }
 static inline void __exit intel_aet_exit(void) { }
+static inline bool intel_aet_pre_mount(void) { return false; }
 static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
 {
 	return -EINVAL;
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 0262174df7ad..ac67b4523b2d 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -795,7 +795,7 @@ void resctrl_arch_pre_mount(void)
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	int cpu;
 
-	if (!intel_aet_get_events())
+	if (!intel_aet_pre_mount())
 		return;
 
 	/*
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 6c4f0bf3b876..d79c459f4c54 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -12,6 +12,7 @@
 #define pr_fmt(fmt)   "resctrl: " fmt
 
 #include <linux/bits.h>
+#include <linux/cleanup.h>
 #include <linux/compiler_types.h>
 #include <linux/container_of.h>
 #include <linux/cpumask.h>
@@ -25,6 +26,7 @@
 #include <linux/io.h>
 #include <linux/minmax.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/printk.h>
 #include <linux/rculist.h>
 #include <linux/rcupdate.h>
@@ -293,6 +295,18 @@ static enum pmt_feature_id lookup_pfid(const char *pfname)
 	return FEATURE_INVALID;
 }
 
+/*
+ * Serialises AET's view of pmt_telemetry:
+ *   - pmt_module, get_feature, put_feature
+ *   - every event_group's ->pfg
+ *
+ * Lock ordering with pmt/telemetry.c's ep_lock is ep_lock -> aet_lock.
+ * AET therefore must not call get_feature() (which takes ep_lock) while
+ * holding aet_lock. put_feature() does not take ep_lock and may be
+ * invoked with aet_lock held.
+ */
+static DEFINE_MUTEX(aet_lock);
+
 static struct module *pmt_module;
 static struct pmt_feature_group *(*get_feature)(enum pmt_feature_id id);
 static void (*put_feature)(struct pmt_feature_group *p);
@@ -308,7 +322,8 @@ static void (*put_feature)(struct pmt_feature_group *p);
  * struct pmt_feature_group to indicate that its events are successfully
  * enabled.
  */
-bool intel_aet_get_events(void)
+static bool aet_get_events(struct pmt_feature_group *(*get)(enum pmt_feature_id id),
+			   void (*put)(struct pmt_feature_group *p))
 {
 	struct pmt_feature_group *p;
 	enum pmt_feature_id pfid;
@@ -317,14 +332,16 @@ bool intel_aet_get_events(void)
 
 	for_each_event_group(peg) {
 		pfid = lookup_pfid((*peg)->pfname);
-		p = intel_pmt_get_regions_by_feature(pfid);
+		p = get(pfid);
 		if (IS_ERR_OR_NULL(p))
 			continue;
 		if (enable_events(*peg, p)) {
-			(*peg)->pfg = p;
+			scoped_guard(mutex, &aet_lock) {
+				(*peg)->pfg = p;
+			}
 			ret = true;
 		} else {
-			intel_pmt_put_feature_group(p);
+			put(p);
 		}
 	}
 
@@ -335,6 +352,7 @@ void intel_aet_register_enumeration(struct module *module,
 				    struct pmt_feature_group *(*get)(enum pmt_feature_id id),
 				    void (*put)(struct pmt_feature_group *p))
 {
+	guard(mutex)(&aet_lock);
 	get_feature = get;
 	put_feature = put;
 	pmt_module = module;
@@ -343,19 +361,50 @@ EXPORT_SYMBOL_NS_GPL(intel_aet_register_enumeration, "INTEL_PMT");
 
 void intel_aet_unregister_enumeration(void)
 {
+	guard(mutex)(&aet_lock);
 	pmt_module = NULL;
 	get_feature = NULL;
 	put_feature = NULL;
 }
 EXPORT_SYMBOL_NS_GPL(intel_aet_unregister_enumeration, "INTEL_PMT");
 
+bool intel_aet_pre_mount(void)
+{
+	struct pmt_feature_group *(*get)(enum pmt_feature_id id);
+	void (*put)(struct pmt_feature_group *p);
+	struct module *mod;
+
+	/*
+	 * Snapshot the callbacks and pin the pmt_telemetry module under
+	 * aet_lock. The module reference keeps pmt_telem_exit() from
+	 * running intel_aet_unregister_enumeration() and changing these
+	 * pointers, so the snapshot remains valid after dropping aet_lock.
+	 */
+	scoped_guard(mutex, &aet_lock) {
+		if (!get_feature || !put_feature)
+			return false;
+		if (!try_module_get(pmt_module))
+			return false;
+		mod = pmt_module;
+		get = get_feature;
+		put = put_feature;
+	}
+
+	if (!aet_get_events(get, put)) {
+		module_put(mod);
+		return false;
+	}
+
+	return true;
+}
+
 void __exit intel_aet_exit(void)
 {
 	struct event_group **peg;
 
 	for_each_event_group(peg) {
 		if ((*peg)->pfg) {
-			intel_pmt_put_feature_group((*peg)->pfg);
+			put_feature((*peg)->pfg);
 			(*peg)->pfg = NULL;
 		}
 	}
-- 
2.55.0

