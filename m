Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B41E377577
	for <patches@lists.linux.dev>; Wed, 29 Apr 2026 15:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777475212; cv=none; b=Mo7juemGcuYLFxRRFGuDiQLdCOI2e1KrgqyjGjIoXFAhJXPWYOO5Q033Ap+cXBfbUvCpbCgORiuvV/fRmcpBlULFrUSI39IMmiOISzH8zrE2fC6dIEF4DNMlQJgoxDtZyI+OhoQttHy1Lt5F3aTSy8YHIP09floqghnpCTZ6OtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777475212; c=relaxed/simple;
	bh=/aVegcj2Gd/PPwuq0w7v0DVXLWgC36AnHuP/93CopIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=figFtBap7QkijgUwTkvdlVeqA5VX0oS5rC1XXKSgk9nZOzt2oHjPY8WLu1P5br08B8IGEXPEdGHnV0SqapJ/UT0+t9uVMzJ2XW5hssyH678y7Y2hFqtog2jJ2xowiN1fn3X2AqXMoUKbyrGxs0UYTvbHAXO/yL3Y2K8N/EIeFdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hXYWg+yP; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hXYWg+yP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777475212; x=1809011212;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/aVegcj2Gd/PPwuq0w7v0DVXLWgC36AnHuP/93CopIQ=;
  b=hXYWg+yP93Rg/CA7n5nlM2UTp2mCahYbIc87B7jfxec6U9NN2FsF45Z+
   Mx2VJspl9je4zXWPmcoJk3S1ysiS3DhCfDM3y+4JhlfxWZ2rsTCrwPmWi
   cjTzmFfrnIsTKtfmJamkqXqDEaeOD6/oYCU67Ho5xwltrnCWGtit3+pru
   EiRxQBroqdLUc5l/gs4ZGAguwjBSLXY7XE/7e8CsCUs0r6/JZLSAJCb7g
   9B5WoHtMyHZe0obp4phtvi2j/PuUqAL3ry5IRRz2R1p2BgqZ/JBg4h7qI
   c00xW6ZPiA7xf94ACXyBa34rYIdBcnnHoEblscCxagoiyOc6gStByVdnP
   Q==;
X-CSE-ConnectionGUID: E6eEaADHSHKeePYz31pOBg==
X-CSE-MsgGUID: gDJfNWmyTImoCToSc+3PwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="78424378"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="78424378"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 08:06:47 -0700
X-CSE-ConnectionGUID: OqGiyrtoRYOE/iCEjM08Ow==
X-CSE-MsgGUID: MigMWvkSSqe+RsgkAqaepQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="233445015"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 08:06:47 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: tony.luck@intel.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	ben.horgan@arm.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v4 06/10] fs/resctrl: Add last_cmd_status support for writes to max_threshold_occupancy
Date: Wed, 29 Apr 2026 08:06:36 -0700
Message-ID: <567dc8417d4bf6254407ee3a5bc5c593999804e7.1777419024.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1777419024.git.reinette.chatre@intel.com>
References: <cover.1777419024.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

info/last_cmd_status is intended to contain more information if a write to
any resctrl file fails. Writes to max_threshold_occupancy did not receive
last_cmd_status support during initial last_cmd_status enabling. Add it now.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since v1:
- Add Ben's RB tag.

Changes since v2:
- Switch to guard(). (Chenyu)
- Drop Ben's RB tag due to significant code change.
---
 fs/resctrl/rdtgroup.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 5dfdaa6f9d8f..5e3ea92cc243 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -12,6 +12,7 @@
 
 #define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
 
+#include <linux/cleanup.h>
 #include <linux/cpu.h>
 #include <linux/debugfs.h>
 #include <linux/fs.h>
@@ -1238,12 +1239,20 @@ static ssize_t max_threshold_occ_write(struct kernfs_open_file *of,
 	unsigned int bytes;
 	int ret;
 
+	guard(mutex)(&rdtgroup_mutex);
+	rdt_last_cmd_clear();
+
 	ret = kstrtouint(buf, 0, &bytes);
-	if (ret)
+	if (ret) {
+		rdt_last_cmd_puts("Invalid input\n");
 		return ret;
+	}
 
-	if (bytes > resctrl_rmid_realloc_limit)
+	if (bytes > resctrl_rmid_realloc_limit) {
+		rdt_last_cmd_printf("Exceeds limit (before adjustment) of %u bytes\n",
+				    resctrl_rmid_realloc_limit);
 		return -EINVAL;
+	}
 
 	resctrl_rmid_realloc_threshold = resctrl_arch_round_mon_val(bytes);
 
-- 
2.50.1

