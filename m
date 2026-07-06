Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E213D953E
	for <patches@lists.linux.dev>; Mon,  6 Jul 2026 22:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783378003; cv=none; b=PDbHYOmkzVUg4AcYRGF2a/H7EgZNjDN34auGSnEZrOOg3gh+I6HL4h+b9egL4orX9vlhmbmJyVHfGIuHI+rCzzl58ObFCOP/oHhwCjuu0383d30WBpV3zOpafZbhAQg8ylMO0GaO5HA27nglMq+twjiz0S8z/NwYVtnbiAaGTRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783378003; c=relaxed/simple;
	bh=anlmMS7/6YMTq/rgrpAy9SFCR5hXkrfnO2xLWVaTbMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lB2KyaPgRjJTv9RUMGN/7AXlnBGudXve30H6EnxE6HIDNTwhtx3Sk9fDuI2xAh2eMAeYp8QOF3Ov0+2YuH4cXGLnvXXQKmPnbY56jj+1/qvbf5l480lFGkDiprTpHCVmDKMlrgDXdwIaIWJAuvHd2ZTrQUebmRvjMZT6/Cl2OLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dw0ym9Lh; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dw0ym9Lh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783378002; x=1814914002;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=anlmMS7/6YMTq/rgrpAy9SFCR5hXkrfnO2xLWVaTbMo=;
  b=Dw0ym9LhTHXL1YD2W2tX3LKNOv5MacwOoaD1TTc2GdLMWFbcLHLIKlVG
   Rp2PiPB338aZo6/RACUmVgTyCM8/hQWdywqJOBMmypzPsHNqa4dbsK459
   qUdXEVGb/jr+YKguuG3M2M6HgjGYvIayNy9pbUThT9Xsn6UexnsmBZBRU
   mK/iTr8EqmEKqPzcgq6tiSGz4bv65214EQLt/y6AlwBggT3TUb/2VTvRJ
   0/FNxFcGfBNvZ5kxmnx9uglgnKY7kROjWeBBSmvvb+mN/8yCzGW3gerwT
   i8286x8E7n56deoaOh8IsAhso3UiIJ7n7l9yguLivvauajV/aFlHGruLZ
   g==;
X-CSE-ConnectionGUID: /8oD27/YQJi31buuO3T6wg==
X-CSE-MsgGUID: kbVLKhyUQjGdtANMCJazyw==
X-IronPort-AV: E=McAfee;i="6800,10657,11839"; a="95401492"
X-IronPort-AV: E=Sophos;i="6.25,151,1779174000"; 
   d="scan'208";a="95401492"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2026 15:46:40 -0700
X-CSE-ConnectionGUID: 7MFuJ6GgR7isTVc/cSZdbA==
X-CSE-MsgGUID: Xg1r9/i9T526eddDx/a9Kg==
X-ExtLoop1: 1
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2026 15:46:39 -0700
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
Subject: [PATCH v6 03/10] fs/resctrl: Fix double-add of pseudo-locked region's RMID to free list
Date: Mon,  6 Jul 2026 15:46:23 -0700
Message-ID: <551432dd7e624a862b8e58314c38aaba0afff3e9.1783377598.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1783377598.git.reinette.chatre@intel.com>
References: <cover.1783377598.git.reinette.chatre@intel.com>
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
Cc: <stable@kernel.org>
---
Changes since V2:
- New patch

Changes since V3:
- Extract the double-add/double-free fix from all the other pseudo-locking
  fixes that will be deferred. This issue was uncovered during testing
  of the race fixes so drop all the Reported-by and Closes tags.

Changes since v5:
- Move earlier in series.
- Add Cc: <stable@kernel.org>
---
 fs/resctrl/rdtgroup.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index ce277f16ea12..cc9966ff6cdf 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3084,10 +3084,6 @@ static void rmdir_all_sub(void)
 		if (rdtgrp == &rdtgroup_default)
 			continue;
 
-		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP ||
-		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED)
-			rdtgroup_pseudo_lock_remove(rdtgrp);
-
 		/*
 		 * Give any CPUs back to the default group. We cannot copy
 		 * cpu_online_mask because a CPU might have executed the
@@ -3098,7 +3094,13 @@ static void rmdir_all_sub(void)
 
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
2.54.0

