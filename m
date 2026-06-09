Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B840540D574
	for <patches@lists.linux.dev>; Tue,  9 Jun 2026 21:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781038973; cv=none; b=Bwy/TvGbIfQu1FksKGdj+tmyLFSx6PxgRVABH2pzqsmfqeCQfPRfT1BvIuXanIetBXftIX0JjaGGnZGRtHe6JjaokW4N6qPCs7BCcVENKwR7LySucSwpEescB+UN9TlqOXfGGfQI30MFGIuxpd488GsWL333AXojnEJ675rJ+oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781038973; c=relaxed/simple;
	bh=C8hY132qG+xjkRnVVTukTcbYF6pljAiJfoDuxTvymqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DmNPR4uc5Q4ReiB4mJ7Y6Paa1hKFy4r/dLx1kUH6Jxoihkqbf6Ay49RF7JlQhWhlSobZSwSLp82DkchxqPMAf22RygzQ8IQ4/WSo+iGahSapUIqNshoTisZLhFEDuloDmDN5DYS5gyPdzOJZlQ+wPc6ek0kky4ttSKlhfrAvYro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QN4sDmMB; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QN4sDmMB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781038973; x=1812574973;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C8hY132qG+xjkRnVVTukTcbYF6pljAiJfoDuxTvymqU=;
  b=QN4sDmMBLKQZENIBEkGgR8ZjO4nIJ+bbptGjlARCrV7/GCsEdSYzhHLC
   xXMe1ZwLTklFXWuPYRYTgWz7WZs9+arFJqWpOLAvmSvpLc/cfLUbBxEYJ
   r4DVBip4kNyz/v/9rm3Ai6OQ7/um3rwnavbKRnjVU7+1Sb2vUnE2kHkNc
   3Dwr5v59FYCKmcXCqKhUI5Gq6jhxWRVa65Yp4s/HUERqaDeZzBXJTZpuh
   FgVKV4+uTEG6t7fKXngVQdmstPmXHL3DVzfDCbbZ8fYF9vpCi8iGsVDqV
   EHtneEPxDOdiwCP4/iuNGDF4z1sw/SkbbH2InRn2B+3bkKuGRnrBLaNqo
   g==;
X-CSE-ConnectionGUID: CJl7xv9lRuyXDVVr8w3heA==
X-CSE-MsgGUID: PXVUGX8US4uS4x+bhxYdRQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11812"; a="81725061"
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="81725061"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 14:02:53 -0700
X-CSE-ConnectionGUID: Nh3OGGcdRTWACpYQ7tKkIQ==
X-CSE-MsgGUID: gd3spaAYQTa5FCtEWLIr4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="251045678"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 14:02:51 -0700
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
Subject: [PATCH v5 04/11] fs/resctrl: Free mon_data structures on rdt_get_tree() failure
Date: Tue,  9 Jun 2026 14:02:30 -0700
Message-ID: <52880d6ee4d38599f69cbb42493e16f3903e7f52.1781029125.git.reinette.chatre@intel.com>
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

From: Tony Luck <tony.luck@intel.com>

If mkdir_mondata_all() or a subsequent call in rdt_get_tree() fails, the
mon_data structures allocated by mon_get_kn_priv() are leaked.

Add mon_put_kn_priv() to the out_mongrp error path to free the mon_data
structures.

Fixes: 2a6566038544 ("x86/resctrl: Expand the width of domid by replacing mon_data_bits")
Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Closes: https://lore.kernel.org/lkml/5d38c1fb-8f91-472b-8897-24b2f50c772b@intel.com/
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since V2:
- Reword changelog.

Changes since V3:
- Add Chenyu's Reviewed-by tag that should have been added in V2.
- Add Ben's Reviewed-by tag.
- Add Closes: tag.
---
 fs/resctrl/rdtgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 2b624cf02147..31cfb54a5488 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3081,6 +3081,7 @@ static int rdt_get_tree(struct fs_context *fc)
 		kernfs_remove(kn_mondata);
 out_mongrp:
 	if (resctrl_arch_mon_capable()) {
+		mon_put_kn_priv();
 		rdtgroup_unassign_cntrs(&rdtgroup_default);
 		kernfs_remove(kn_mongrp);
 	}
-- 
2.50.1

