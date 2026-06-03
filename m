Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6238C3F54BB
	for <patches@lists.linux.dev>; Wed,  3 Jun 2026 03:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780457286; cv=none; b=cA4hnsizPgAes8J7jrNYFD083xXVwXc2NnnHSMdbma81IhBKnlxVUyLcZuCSXNoJyONLZ7E1wyZ3b0PDGBS7nemaTpwBrCKGUlbby969T3wnOsXBPZ81laFfzcs7cQKdp5eDAT45VInwgXztJKj9FrV+coCF6vuAXWOZ/6xPwEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780457286; c=relaxed/simple;
	bh=+bCwbGXodPOyojvefV3AVotYYV06mZ2z2YAeKsYo9NE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dw7M2Qr/74u83AvuHArZOjIznfIfrWPtKbllgxOwlk10Sn/x13rKoJB8TxG4R3CPx5QxaehI472OW7ZEYiEKgX5ZOqzEQ5m0ONwGE3ofss7ExODyK8YzEOA3RkxA4+xNVxpUTv8difYyPr7tR7XLlewkIv6lJM1mVnnLG3fXTTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FJ4UH0z9; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FJ4UH0z9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780457284; x=1811993284;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+bCwbGXodPOyojvefV3AVotYYV06mZ2z2YAeKsYo9NE=;
  b=FJ4UH0z9xfJTlt3sya+7s1brfk/P1V3zFP55mU1F03s2CjlpvbgOV/X+
   4UCSGpA6BmXZTk/R5kIRodazoWshOhkUrpZrgVF2J5mubCNZvNJMENatv
   0aHczjx6Um+8HC7EeF5VgALnG4qbLzR/Fz8zu6loUM6SjXblGmgBSmt0t
   2c8/FlOHpsAtdlXwCK1k4IAy+S+2u7SYu82e64G0jibzw8eJmP2GD9RVX
   X8k0j/0rKZOe5PbUa9TRSnBmOEX7IyMp3WpGiPXBuMwgG1I6RfykDKGpl
   KHL1Djz68O7neX8jZeV4Mh4fVCdkGTmQwonI0+zhtIvNbEyJUhDMMTtCp
   w==;
X-CSE-ConnectionGUID: TjemZ051RIuqxyLYtW72Nw==
X-CSE-MsgGUID: 0/kJbBOOQRmmu84nY57nCg==
X-IronPort-AV: E=McAfee;i="6800,10657,11805"; a="91939030"
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="91939030"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 20:28:01 -0700
X-CSE-ConnectionGUID: I7K+eS4KQmKbRtrIiO8SgA==
X-CSE-MsgGUID: qNzA9OWNSiq/ySxEloFnkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="241110119"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 20:28:00 -0700
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
Subject: [PATCH v4 07/10] fs/resctrl: Fix double-add of pseudo-locked region's RMID to free list
Date: Tue,  2 Jun 2026 20:27:35 -0700
Message-ID: <2eda4d2873e6607b3c3f19bb5cac1d9fa8e2c04d.1780456704.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1780456704.git.reinette.chatre@intel.com>
References: <cover.1780456704.git.reinette.chatre@intel.com>
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

