Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8FC30C37A
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 20:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764881669; cv=none; b=m38z44CxGy/aW+MD3YOqV2N/8F/5h2wvY6PTWvsMBPoeZdURBtyP1l3A8P9SDpBv7/OPY59S1SUCfDqLSBPOrFPjc9/+nUU00StZ094opuJs5OBn2rr0kfqYlHNQqQh99Eu1xcTSF/n9YrL+fO8pO8DfsxsGEwcDLg+6cqUGGmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764881669; c=relaxed/simple;
	bh=vrL7JfY3s49csiMkieoQzxc27A+XOltjUvm7AN7IfJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nkln/8xMXbAoroH4gzmm4gdw+I+DtORpUlegwuKDCWFvrOPmlndJVqoSsyaL4yxXsSlNcfBvHZdpaXAD462UtrLwupFwEAg+tSObIa6tGgmwVvJ8ULYde/UFXaUQaXV0jSEixdTPboIvDJuKt6HsW7O2aucBvqn9qbhNmeb9wBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lOqGRzkV; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lOqGRzkV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764881665; x=1796417665;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vrL7JfY3s49csiMkieoQzxc27A+XOltjUvm7AN7IfJk=;
  b=lOqGRzkVwJ6/+DDSeFvZbuLellyOIxKlXQPoUVlD04jpcf4BfdpHG+6l
   mF0LS6RJsz8VH2emeXNNtOV4HCdWWvZOVwHwocmrNDp/lcBKhrPZmegP1
   CKHUnGKV7S/Df6ri4ZdjNUkVPCkl0TtLiSPNpERGZU8IoIMfd/V7/d8xo
   8a5e4+MQlmSJF6MahFI10RtAWnLhoN05EBqBObafOpVx5NORNCfboJRTt
   wh/iSLOBXpO5m/ubSO9AmYR4/l1PFKGDIMEuu0BBVNNnwfdJF8I3L4t54
   g/JFmYr0frvQYctTWGclq9BjEptHwwd+g9tpv99WYOsLXkiPuBWGesSya
   Q==;
X-CSE-ConnectionGUID: RJ+M5oJrR7aDRPlQLbsdgg==
X-CSE-MsgGUID: 0XIr3Ym2Qlmz5lTEDf+NjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11632"; a="69510952"
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="69510952"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 12:54:21 -0800
X-CSE-ConnectionGUID: Pq08iDA/QrabcNT6uDg1Ug==
X-CSE-MsgGUID: 9LocSSarRWuCYkCl+gROgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="225752780"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.165])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 12:54:20 -0800
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
Subject: [PATCH v15 13/32] x86,fs/resctrl: Add an architectural hook called for each mount
Date: Thu,  4 Dec 2025 12:53:43 -0800
Message-ID: <20251204205404.12763-14-tony.luck@intel.com>
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

Enumeration of Intel telemetry events is an asynchronous process involving
several mutually dependent drivers added as auxiliary devices during
the device_initcall() phase of Linux boot. The process finishes after
the probe functions of these drivers completes. But this happens after
resctrl_arch_late_init() is executed.

Tracing the enumeration process shows that it does complete a full seven
seconds before the earliest possible mount of the resctrl file system (when
included in /etc/fstab for automatic mount by systemd).

Add a hook at the beginning of the mount code that will be used to check
for telemetry events and initialize if any are found.

Call the hook on every attempted mount. Expectations are that most actions
(like enumeration) will only need to be performed on the first call.

resctrl filesystem calls the hook with no locks held. Architecture code is
responsible for any required locking.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 include/linux/resctrl.h            | 6 ++++++
 arch/x86/kernel/cpu/resctrl/core.c | 9 +++++++++
 fs/resctrl/rdtgroup.c              | 2 ++
 3 files changed, 17 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index c43526cdf304..dc148b7feb71 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -514,6 +514,12 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 void resctrl_online_cpu(unsigned int cpu);
 void resctrl_offline_cpu(unsigned int cpu);
 
+/*
+ * Architecture hook called at beginning of each file system mount attempt.
+ * No locks are held.
+ */
+void resctrl_arch_pre_mount(void);
+
 /**
  * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
  *			      for this resource and domain.
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 9222eee7ce07..2dd48b59ba9b 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -726,6 +726,15 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
 	return 0;
 }
 
+void resctrl_arch_pre_mount(void)
+{
+	static atomic_t only_once = ATOMIC_INIT(0);
+	int old = 0;
+
+	if (!atomic_try_cmpxchg(&only_once, &old, 1))
+		return;
+}
+
 enum {
 	RDT_FLAG_CMT,
 	RDT_FLAG_MBM_TOTAL,
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 771e40f02ba6..b20d104ea0c9 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2785,6 +2785,8 @@ static int rdt_get_tree(struct fs_context *fc)
 	struct rdt_resource *r;
 	int ret;
 
+	resctrl_arch_pre_mount();
+
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 	/*
-- 
2.51.1

