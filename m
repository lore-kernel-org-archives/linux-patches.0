Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EACA3E1687
	for <patches@lists.linux.dev>; Tue,  9 Jun 2026 21:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781038982; cv=none; b=MmDi01KQbPu932Fk0Hczs/2KWCeYxEZGX7t71P7w4/05LouGZbLj3XZXXa/E1OrkqbNhXrynyA89Gy98jhhGRaO9vjE0cT69EV9CmDziLxJgdoU4X0cNDMmLhU+kKVFrpgz2xGtUoJ0T3Hds5mkvY8GM2Dt2LoUiOwtDGVaaKqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781038982; c=relaxed/simple;
	bh=+bCwbGXodPOyojvefV3AVotYYV06mZ2z2YAeKsYo9NE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X68wm1XyLlzxS57X1mPABYNQJWM87aRcDgWKkp2IEltoei0uDxhfCCEaVFP/F2c8OjMW4parVMp/QSx1W/wgXDq8H+ouhVR5toaiZ5Iiuab/cIZPvcC1tb8X8TdeNFU4NZ6jNJMfdPsZcFsmxU/a43vfOhR+jX/FJh3YkscR/eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YLHu2TZ0; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YLHu2TZ0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781038978; x=1812574978;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+bCwbGXodPOyojvefV3AVotYYV06mZ2z2YAeKsYo9NE=;
  b=YLHu2TZ0e9pj+k8hypede3i12t9FBGaI5Jr9/aO7kSMatZP7X2GSyRBH
   Eyxmam+31DgCj0L5zjQxfLtkRN+vsyKXcakfkAoN5MkxmQ2uZr4iC7H1T
   9Rlowjl8DFQjBkHgHSBSEOgvUlJUAnUy5uQRbEe20v1njcJ094Z5iRN0V
   X4UcUMppz4sYAAKvQn/w6KONdjdJ7XI0GjQzK5jzXdHKzKDeb5qyoXSFw
   8uoRNiPRydfN8fLFiNY6XZpaws8IEYA/l3Nu+Vsc1lry6h6pgqaa5DvqF
   HulkxVbCRRFlZMYIKtPaR/PwFTQr397BFdDsax11CqQEslGfMe0kqqn6V
   w==;
X-CSE-ConnectionGUID: WdoRb4FuQbOUVzuimZOKnQ==
X-CSE-MsgGUID: 8T19ODMmRz+UxfHhbxuHwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11812"; a="81725086"
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="81725086"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 14:02:57 -0700
X-CSE-ConnectionGUID: 2BfXSEApSom7RWqB9qZ8SQ==
X-CSE-MsgGUID: nnBGRo/IRfqwZx8M0962XQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="251045736"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 14:02:55 -0700
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
	yu.c.chen@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v5 08/11] fs/resctrl: Fix double-add of pseudo-locked region's RMID to free list
Date: Tue,  9 Jun 2026 14:02:34 -0700
Message-ID: <137b53e306e268af9e925e7966af304cc5ad01b3.1781029125.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1781029125.git.reinette.chatre@intel.com>
References: <cover.1781029125.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A pseudo-locked group's RMID is freed when it is created. On unmount
rmdir_all_sub() unconditionally frees all RMID of all groups, resulting
in a double-free of the pseudo-locked group's RMID. The consequence of this
is that the original free results in the pseudo-locked group's RMID being
added to the rmid_free_lru linked list and the second free then attempts
to add the same RMID entry to the rmid_free_lru again.

Do not double-free a pseudo-locked group's RMID.

Fixes: e0bdfe8e36f3 ("x86/intel_rdt: Support creation/removal of pseudo-locked region")
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since V2:
- New patch

Changes since V3:
- Extract the double-add/double-free fix from all the other pseudo-locking
  fixes that will be deferred. This issue was uncovered during testing
  of the race fixes so drop all the Reported-by and Closes tags.
---
 fs/resctrl/rdtgroup.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index c04424c081a4..77c9d22017bc 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2885,10 +2885,6 @@ static void rmdir_all_sub(void)
 		if (rdtgrp == &rdtgroup_default)
 			continue;
 
-		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP ||
-		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED)
-			rdtgroup_pseudo_lock_remove(rdtgrp);
-
 		/*
 		 * Give any CPUs back to the default group. We cannot copy
 		 * cpu_online_mask because a CPU might have executed the
@@ -2899,7 +2895,13 @@ static void rmdir_all_sub(void)
 
 		rdtgroup_unassign_cntrs(rdtgrp);
 
-		free_rmid(rdtgrp->closid, rdtgrp->mon.rmid);
+		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP ||
+		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED) {
+			rdtgroup_pseudo_lock_remove(rdtgrp);
+		} else {
+			/* Pseudo-locked group's RMID is freed during setup. */
+			free_rmid(rdtgrp->closid, rdtgrp->mon.rmid);
+		}
 
 		kernfs_remove(rdtgrp->kn);
 		list_del(&rdtgrp->rdtgroup_list);
-- 
2.50.1

