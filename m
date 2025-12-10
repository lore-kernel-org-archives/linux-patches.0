Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A722EBB9E
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 23:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765408495; cv=none; b=n0KwCmG/su6aTAnTTvoT1UNznqktZrFQkxrdi6aFTzzAMsUh4F23RNmoDbb7j2kjWHANAmWnbwLy/sia4d7eOtcYMx48QIbv4oxtn/6iRChAzA5e4+jY9ghM8NeLR0g9TihCsNaSfn/MfhigHrxjn2kvzz2VQhSdgao5889lIe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765408495; c=relaxed/simple;
	bh=vrL7JfY3s49csiMkieoQzxc27A+XOltjUvm7AN7IfJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPo/g166x5ZRxJa9dnZ2Tdtn5FjLi+vl/HcHznW60gMO+6t8uJXwR8Td1439oneyn/Q7QyFhSh3eE8SzzK24h+jSAbXGyP85P0Qducu1IFqyjLovVUaQetIECZ1R07hw+NWnNScrpNiZhLZRb9S9866SPrC0/jWK/UQC6EbeTc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TpCfniad; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TpCfniad"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765408490; x=1796944490;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vrL7JfY3s49csiMkieoQzxc27A+XOltjUvm7AN7IfJk=;
  b=TpCfniadw4cD9mKUcahJVY4uOVmeLkrJmKFGGCO8S/bX/AE8PpilJlLE
   OBdQrj6oPEn2RsaGlJaLFWriaGuWm8q9FMbTAoEBh3kt+GgjoUvene7kd
   E3MYgocaJoXwUXXXXNBmKH90PA78YfuCXp0uLfC+mhkCIeDPsfOHPn48c
   /G6sMHujM6/JvcTpd/rPtVio7kQGdQF0SNIomg0Ynz53xfWOPmwSa5OOQ
   IntpBEWo60w91EJklNYi1QctKyBw6ExKM3f+0w7g0WJHqxG9654yByHox
   Mu9hILZ60r9yplf6B6h6YnJPIsW9kpb6MfOFSvn6ohSWK/ZAPKrc4LiSu
   g==;
X-CSE-ConnectionGUID: m/sFO86dRhGt0PfiVsPuBg==
X-CSE-MsgGUID: bFSOkug+SdGPCsqAk10SLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="69973580"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="69973580"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:14:32 -0800
X-CSE-ConnectionGUID: 1cbVZiJOSBqhEOPVUiHlUQ==
X-CSE-MsgGUID: TFltrmcySruVY/IzgenFWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227297076"
Received: from daliomra-mobl3.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.254])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:14:32 -0800
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
Subject: [PATCH v16 13/32] x86,fs/resctrl: Add an architectural hook called for each mount
Date: Wed, 10 Dec 2025 15:13:52 -0800
Message-ID: <20251210231413.59102-14-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251210231413.59102-1-tony.luck@intel.com>
References: <20251210231413.59102-1-tony.luck@intel.com>
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

