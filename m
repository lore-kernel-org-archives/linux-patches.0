Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA5D2D662F
	for <patches@lists.linux.dev>; Tue, 29 Sep 2026 17:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790704363; cv=none; b=jne4GYneNVnyv+U9k9imL+S3B66EO7KItvGcH1SwQvu5pyRRDJaf2awCIWaJWMyBqm7OQGuxV8Id9MFgFzYwxt9mg1WSXk7DiGh24gUDPs4yreaQ8G4B9uU9dKxLq4EDt4tJOPPwaZZXJ/td53jorTnhxYZLjghoeO255p4GuZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790704363; c=relaxed/simple;
	bh=K9m+WUGOtOedBmQHMYyGhKmvaJN56TiY9BPoY//MCcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAiVHqDhi/zFINItt2XzQKnmmPir47Zb0RzbaTD6qzSbeq75mgdB28fXPPSCkKHAzkGyOVw4yL55R27GBbZxKu4sVPURyIsdh5Tulp+/rHaH8ldt9lakZnc9/MfkmdQWfS4yFALOeY01wKM2S3G9JkhwTyxIZZWopM/g7kdFi9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fDs8eLWN; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fDs8eLWN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790704359; x=1822240359;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K9m+WUGOtOedBmQHMYyGhKmvaJN56TiY9BPoY//MCcA=;
  b=fDs8eLWNlQAHc7zZ+fQWgK6iUXcjYWQUJEOwcY3XW+ypy4WyFYF0hYJA
   2MahTvf+k6NJnMHbzOf3nBERrHaKegLB2lTkGVFf1RyRhitzkuoAL+5pW
   1tS2t6HwtM8CU5WR6A4b8bvx5Z0FHY0tVAF6pi6MXmA2f+477MGin4duR
   A2/8UaXTGjwbjNWkRLpl6cdfBabCHfBILC5yb9PAoG5VIT4Q2WKiyIaZu
   g1OKXCaSclZt4KeKU6IaCtd0sik4CsRjeAAIvpDZHCgQzpRU80sQj2w5u
   MSooVhUcY/beJF/0iolFY0VdJigFO8NSThvzYUlWs50y/cjTucWLs/7xS
   Q==;
X-CSE-ConnectionGUID: Klo28Id8QUSgXtn6Jnomvw==
X-CSE-MsgGUID: EbXDWaB0SEGFRSV2VQP/ng==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="90294374"
X-IronPort-AV: E=Sophos;i="6.27,130,1787036400"; 
   d="scan'208";a="90294374"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2026 10:52:38 -0700
X-CSE-ConnectionGUID: U8lbepFQRnK2mL4iRqX+jA==
X-CSE-MsgGUID: eeuvSTb7SWe7AIQr0RmDfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,130,1787036400"; 
   d="scan'208";a="274649233"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.232])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2026 10:52:38 -0700
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
Subject: [PATCH v14.1 19/25] arm,x86,fs/resctrl: Enumerate AET on every resctrl mount
Date: Tue, 29 Sep 2026 10:52:31 -0700
Message-ID: <20260929175231.16576-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928221509.68002-20-tony.luck@intel.com>
References: <20260928221509.68002-20-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The pmt_telemetry driver is built-in, and Application Energy Telemetry (AET)
is only enumerated on the first mount of the resctrl file system.

In order to allow the pmt_telemetry driver to be a module, changes are
needed to place a hold on the driver only while the resctrl file system
is mounted. This means that resctrl must enumerate AET features on every
mount, and clean up on every unmount.

There are changes to three software layers:

1) resctrl file system
   Call architecture code for every mount and unmount. Locking is needed
   here so that architecture code can be sure that every call to
   resctrl_arch_pre_mount() occurs while the file system is not mounted,
   and resctrl_arch_unmount() occurs only to clean up a failed mount or
   to unmount the file system.

2) Architecture code
   New function resctrl_arch_unmount(). On x86 this calls the AET code
   if RDT_RESOURCE_PERF_PKG was marked as supporting monitoring by an
   earlier mount attempt. It completes cleanup by removing all domains
   used by AET.

3) AET code
   Disables all AET events and informs pmt_telemetry driver that it is no
   longer using the pmt_feature_group structures it received during mount.
   Releases the hold on the pmt_telemetry driver allowing it to be unloaded.
   All cleanup is handled by intel_aet_unmount() and intel_aet_exit() is
   no longer needed.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v14:
	aet_register_lock name changed to aet_lock.
---
 include/linux/resctrl.h                 | 10 +++++++--
 arch/x86/kernel/cpu/resctrl/internal.h  |  4 ++--
 arch/x86/kernel/cpu/resctrl/core.c      | 21 +++++++++++++++--
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 29 +++++++++++++++++++-----
 drivers/resctrl/mpam_resctrl.c          |  4 ++++
 fs/resctrl/rdtgroup.c                   | 30 ++++++++++++++++++++-----
 6 files changed, 81 insertions(+), 17 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index c77e24c0d8b6..c40d72e4a957 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -611,11 +611,17 @@ void resctrl_online_cpu(unsigned int cpu);
 void resctrl_offline_cpu(unsigned int cpu);
 
 /*
- * Architecture hook called at beginning of first file system mount attempt.
- * No locks are held.
+ * Architecture hook called at beginning of each file system mount attempt.
+ * Serialized against other mount and unmount attempts.
  */
 void resctrl_arch_pre_mount(void);
 
+/*
+ * Architecture hook called when mount fails, or on unmount.
+ * Serialized against other mount and unmount attempts.
+ */
+void resctrl_arch_unmount(void);
+
 /**
  * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
  *			      for this resource and domain.
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 8406addc05f5..c66954bc01e7 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -234,15 +234,15 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
 
 #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
-void __exit intel_aet_exit(void);
 bool intel_aet_pre_mount(void);
+void intel_aet_unmount(void);
 int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
 void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
 				struct list_head *add_pos);
 bool intel_handle_aet_option(bool force_off, char *tok);
 #else
-static inline void __exit intel_aet_exit(void) { }
 static inline bool intel_aet_pre_mount(void) { return false; }
+static inline void intel_aet_unmount(void) { }
 static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
 {
 	return -EINVAL;
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index ac67b4523b2d..40466f29e48e 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -811,6 +811,25 @@ void resctrl_arch_pre_mount(void)
 	cpus_read_unlock();
 }
 
+void resctrl_arch_unmount(void)
+{
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
+	int cpu;
+
+	if (!r->mon_capable)
+		return;
+
+	intel_aet_unmount();
+
+	cpus_read_lock();
+	mutex_lock(&domain_list_lock);
+	for_each_online_cpu(cpu)
+		domain_remove_cpu_mon(cpu, r);
+	r->mon_capable = false;
+	mutex_unlock(&domain_list_lock);
+	cpus_read_unlock();
+}
+
 enum {
 	RDT_FLAG_CMT,
 	RDT_FLAG_MBM_TOTAL,
@@ -1161,8 +1180,6 @@ late_initcall(resctrl_arch_late_init);
 
 static void __exit resctrl_arch_exit(void)
 {
-	intel_aet_exit();
-
 	cpuhp_remove_state(rdt_online);
 
 	resctrl_exit();
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index d79c459f4c54..e7cd7d8a80cd 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -297,7 +297,7 @@ static enum pmt_feature_id lookup_pfid(const char *pfname)
 
 /*
  * Serialises AET's view of pmt_telemetry:
- *   - pmt_module, get_feature, put_feature
+ *   - pmt_module, get_feature, put_feature, pmt_in_use
  *   - every event_group's ->pfg
  *
  * Lock ordering with pmt/telemetry.c's ep_lock is ep_lock -> aet_lock.
@@ -311,6 +311,11 @@ static struct module *pmt_module;
 static struct pmt_feature_group *(*get_feature)(enum pmt_feature_id id);
 static void (*put_feature)(struct pmt_feature_group *p);
 
+/*
+ * Track whether pmt_telemetry enumeration succeeded during mount for use during unmount.
+ */
+static bool pmt_in_use;
+
 /*
  * Request a copy of struct pmt_feature_group for each event group. If there is
  * one, the returned structure has an array of telemetry_region structures,
@@ -395,19 +400,33 @@ bool intel_aet_pre_mount(void)
 		return false;
 	}
 
+	pmt_in_use = true;
+
 	return true;
 }
 
-void __exit intel_aet_exit(void)
+void intel_aet_unmount(void)
 {
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
 	struct event_group **peg;
 
+	guard(mutex)(&aet_lock);
+	if (!pmt_in_use)
+		return;
+
 	for_each_event_group(peg) {
-		if ((*peg)->pfg) {
-			put_feature((*peg)->pfg);
-			(*peg)->pfg = NULL;
+		struct event_group *e = *peg;
+
+		if (e->pfg) {
+			for (int i = 0; i < e->num_events; i++)
+				resctrl_disable_mon_event(e->evts[i].id);
+			put_feature(e->pfg);
+			e->pfg = NULL;
 		}
 	}
+	module_put(pmt_module);
+	pmt_in_use = false;
+	r->mon.num_rmid = 0;
 }
 
 #define DATA_VALID	BIT_ULL(63)
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 360a50eb0cd3..ecea2239afa4 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -121,6 +121,10 @@ void resctrl_arch_pre_mount(void)
 {
 }
 
+void resctrl_arch_unmount(void)
+{
+}
+
 bool resctrl_arch_get_cdp_enabled(enum resctrl_res_level rid)
 {
 	return mpam_resctrl_controls[rid].cdp_enabled;
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index ecdb5da50179..20e579067570 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -30,6 +30,9 @@
 
 #include "internal.h"
 
+/* Mutex protecting resctrl_mounted and mount/unmount operations */
+static DEFINE_MUTEX(resctrl_mount_lock);
+
 /* Mutex to protect rdtgroup access. */
 DEFINE_MUTEX(rdtgroup_mutex);
 
@@ -48,7 +51,10 @@ LIST_HEAD(resctrl_schema_all);
  */
 static LIST_HEAD(mon_data_kn_priv_list);
 
-/* The filesystem can only be mounted once. */
+/*
+ * The filesystem can only be mounted once. Can only be updated
+ * while holding both resctrl_mount_lock and rdtgroup_mutex.
+ */
 bool resctrl_mounted;
 
 /* Kernel fs node for "info" directory under root */
@@ -3147,6 +3153,7 @@ static void resctrl_unmount(void)
 {
 	struct rdt_resource *r;
 
+	mutex_lock(&resctrl_mount_lock);
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 
@@ -3164,6 +3171,8 @@ static void resctrl_unmount(void)
 	resctrl_mounted = false;
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
+	resctrl_arch_unmount();
+	mutex_unlock(&resctrl_mount_lock);
 }
 
 static int rdt_get_tree(struct fs_context *fc)
@@ -3175,24 +3184,27 @@ static int rdt_get_tree(struct fs_context *fc)
 	struct rdt_resource *r;
 	int ret;
 
-	DO_ONCE_SLEEPABLE(resctrl_arch_pre_mount);
+	mutex_lock(&resctrl_mount_lock);
 
-	cpus_read_lock();
-	mutex_lock(&rdtgroup_mutex);
 	/*
 	 * resctrl file system can only be mounted once.
 	 */
 	if (resctrl_mounted) {
 		ret = -EBUSY;
-		goto out;
+		goto out_mount_unlock;
 	}
 
 	/* Avoid races from pending operations from a previous mount */
 	if (atomic_read(&rdtgroup_default.waitcount) != 0) {
 		ret = -EBUSY;
-		goto out;
+		goto out_mount_unlock;
 	}
 
+	resctrl_arch_pre_mount();
+
+	cpus_read_lock();
+	mutex_lock(&rdtgroup_mutex);
+
 	if (!resctrl_alloc_capable() && !resctrl_mon_capable()) {
 		ret = invalfc(fc, "No allocation or monitoring features are available or enabled");
 		goto out;
@@ -3287,6 +3299,8 @@ static int rdt_get_tree(struct fs_context *fc)
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
 
+	mutex_unlock(&resctrl_mount_lock);
+
 	ret = kernfs_get_tree(fc);
 	/*
 	 * resctrl can only be mounted once, new superblock only expected
@@ -3318,6 +3332,10 @@ static int rdt_get_tree(struct fs_context *fc)
 out:
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
+	resctrl_arch_unmount();
+out_mount_unlock:
+	mutex_unlock(&resctrl_mount_lock);
+
 	return ret;
 }
 
-- 
2.55.0

