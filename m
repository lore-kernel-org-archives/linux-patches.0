Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C053203AB
	for <patches@lists.linux.dev>; Mon, 24 Nov 2025 18:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010495; cv=none; b=V9ojTCBr/y6LIHyfj+IjrGmSLp4znt1SV9mJPPqttZy3/z7ivRjHj2DSpWYPQgwSLM9iU39N3A8LouZtXsDoiu20i6ymfQbmvoboM/S9oMYvsbYBf6Pb08wKmiz4kWEX9DjDM1p4ewwfeu73+OplOMVWubnjFPpBSyBes7A/SmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010495; c=relaxed/simple;
	bh=vrL7JfY3s49csiMkieoQzxc27A+XOltjUvm7AN7IfJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExFf1/lpZT6OyF1Z3Sb2JbmlKxVkqUwlRP06O+ctNmG0VqKK1UFSd1F88wBSpzdtOADHrgIboJWw4fn527msY5jD7XqwRKSf1KL5/f8iHKIJdd0gM/YhnyxqNpcbT3GWjGQvmDyWSt/mQOqo98lkn/HPHR1TW2slWxfaxjA6fd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lh3shTe9; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lh3shTe9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764010494; x=1795546494;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vrL7JfY3s49csiMkieoQzxc27A+XOltjUvm7AN7IfJk=;
  b=lh3shTe90yD9tQGw9HJjsDbPPAs+HpH1/J4Ux7RoXEETsXLTBYIzq7Re
   qdkPS3DCpIGm6QPTqJBKsPaNiwtuZVhvOGvL07xtXGl/gHscwPihpgpeL
   iMmB1FglE9DHN122lU2nkLIqJhphMhwYkR+EEbJpFor2OaU1wukywjJZF
   scEydZxcX4dmdm5+5xTBXBe80Vsw+IzgCn5qE2Ezs7HMpfqiIiaygGFY7
   l6TGcBY4J7zOzPNqoThoWEHvA/9gVeY/tIGBIuLPTyq8fv5F9EiZeKdLK
   PUa9RX2AeRNy6L/L5AFBD6sWSYYhi8ZD8B6WAr7nmm7HH4aKWM6oOqSox
   g==;
X-CSE-ConnectionGUID: RWQ0nkwCTnCLyY6D/Q0DCA==
X-CSE-MsgGUID: wy9BB6MPT/mDWwMGMZRLRQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="76636633"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="76636633"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:26 -0800
X-CSE-ConnectionGUID: uRCHphlSRdKicO5nOUxWCw==
X-CSE-MsgGUID: laNvu1i8Qqmpis/M5wPOwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="192224983"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:26 -0800
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
Subject: [PATCH v14 13/32] x86,fs/resctrl: Add an architectural hook called for each mount
Date: Mon, 24 Nov 2025 10:53:50 -0800
Message-ID: <20251124185412.24155-14-tony.luck@intel.com>
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

