Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6BB236423
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 23:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744069261; cv=none; b=hjPqscZX+3exLVn8wYHe6NJnaSxo5SR1gwyCvlTjSRG9igNDKyUavk0jr0YFBXAlMILo2dkh38LCT3aWeMDbjHEn7w8WNlrLWPrrKDHPIm6uNV+h/6Acyhcb1loxtGl3E19/rFbXlt9KBFGtJlqXm+YhDn0EcT5eOxJyOhzWX24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744069261; c=relaxed/simple;
	bh=FH4fm+YFMpdxaCRCCGQAHD19eZAKYvKow7hQiaY7EVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m91ynwRRPwyyeEkL+MsVuCeyoAKCXNUc6pE87DC1PyufhGQ6s7hz5EUJFq14miNPgJm8kv/ucQdOz+hXqaYDWOD8V4UCxvKWQfXdPeOZ2Uxtk7+sF9e1g5b2ZEXT5AuRXHm/mA+mD7KhNaiB1zhI/vGNslKc49TOzCMvry+YCy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TaP4m/0+; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TaP4m/0+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744069260; x=1775605260;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FH4fm+YFMpdxaCRCCGQAHD19eZAKYvKow7hQiaY7EVs=;
  b=TaP4m/0+l4O7OduNREWrZQTy8cygtFXxxL1kJlD9uMI3Km8Oz/DC09sI
   EITHU0W0351xe+8lBpPByBHcMaz1WM+/820U1IcgFmnjaQHxYkR8Lc/uY
   +2ksJ0srsQYfRfP50uK801PmxKmdxFVj5mLco7O0VWQzCOJjdU9kYGMkA
   4Au+COs6YjUBB9xgn61tLbOxHbHu+yYwKW+nExeF+gF5nZVYjW9qSEW6w
   FHOJ7ly7fVoi4F7owVYYizPs2KAFubrRUjqtHibhHvLlRjDioOM79ecq5
   RWZTwm+PjN2tOFUGUXLfGtw9kjeE76emhgoPrCMNTiMUlvbRX1xoAqPci
   A==;
X-CSE-ConnectionGUID: yjbs9cKtTnWMJ347vFrfyw==
X-CSE-MsgGUID: 7PtIlxkTThGs47Jx8Vf9ew==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="48193210"
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="48193210"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:51 -0700
X-CSE-ConnectionGUID: uxzFegGjT0iniZpR9xejLw==
X-CSE-MsgGUID: uP6oC0ZCRtanI5AHXAgjww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="165315487"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:51 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 13/26] fs/resctrl: Add an architectural hook called for each mount
Date: Mon,  7 Apr 2025 16:40:15 -0700
Message-ID: <20250407234032.241215-14-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250407234032.241215-1-tony.luck@intel.com>
References: <20250407234032.241215-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enumeration of Intel telemetry events is not complete when the
resctrl "late_init" code is executed.

Add a hook at the beginning of the mount code that will be used
to check for telemetry events and initialize if any are found.

The hook is called on every mount. But expectations are that
most actions (like enumeration) will only need to be performed
on the first call.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            | 3 +++
 arch/x86/kernel/cpu/resctrl/core.c | 9 +++++++++
 fs/resctrl/rdtgroup.c              | 2 ++
 3 files changed, 14 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 8ac77b738de5..25f51a57b0b7 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -421,6 +421,9 @@ void resctrl_offline_cpu(unsigned int cpu);
 int resctrl_set_event_attributes(enum resctrl_event_id evt,
 				 enum resctrl_event_type type, bool any_cpu);
 
+/* Architecture hook called for each file system mount */
+void resctrl_arch_mount(void);
+
 /**
  * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
  *			      for this resource and domain.
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 59844fd7105f..a066a9c54a1f 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -711,6 +711,15 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
 	return 0;
 }
 
+void resctrl_arch_mount(void)
+{
+	static bool only_once;
+
+	if (only_once)
+		return;
+	only_once = true;
+}
+
 enum {
 	RDT_FLAG_CMT,
 	RDT_FLAG_MBM_TOTAL,
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index bd41f7a0f416..5ca6de6a6e5c 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2564,6 +2564,8 @@ static int rdt_get_tree(struct fs_context *fc)
 	struct rdt_resource *r;
 	int ret;
 
+	resctrl_arch_mount();
+
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 	/*
-- 
2.48.1

