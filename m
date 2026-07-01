Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2617322ACFA
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 04:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782880048; cv=none; b=CzO2r3h1JHHsw5Gi4hjL9lybkJOSpQwUuSOd8ZLYOjn+YdSAjxbhpuf+BNIGUcl/vYBMw1pv9O1I781OajwtvPFLHA+eK4b9MsYDjRo8KHwgIy1b6v2fD3tMum7ib8acadZeKBSrc8P8w42PClUoVR49N6Y9GkwCyDLO6kyX3Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782880048; c=relaxed/simple;
	bh=FR8WF6xtJvkuB+BKmyZ2v+jUrczJ3ROzU6NoDp6zOIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tpU+D9UCuMFCmeO9X5Mh8/OUHXu0z4ryYXI13lEt65hYoBLR6lM9v/MP/1pFNiB/zagprKQPuMomWPnOz82kgTTDvtS3II8izm5FcH3o+JuRCp9jwZqcSFC0CgWCo6CC560/GN+iL56+DN0qWDw8LvzA+SEbToxBrSVV/CMq0aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CFIpvuJX; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CFIpvuJX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782880045; x=1814416045;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FR8WF6xtJvkuB+BKmyZ2v+jUrczJ3ROzU6NoDp6zOIU=;
  b=CFIpvuJXPto1ObTYx0uStDlWm01KeV4XNSCAVVbAhHEBF6PXjPU7pyer
   Nmt0rQ8XrlS0eBWtgjGb0tNe3+yxxaFMUT0iZ5b4C/NMzqtE6webbSkdf
   H6OXGl1HNFQhWdCumQwC/gDXUQpFu0NIfgHbdNpdHwHcFrJCSMD6yXyZB
   hejqiDC+3q25hlVezATDp73oHWubhSNFQmXYYivjQa+bwbDUoZbHQ9n4K
   UfaqSTn6TO5M/B3W0noPTxMdl1L86JhUfEq7VKSyA/SKX1HsDrOQnASj/
   1eqB/WkleyyOqHkcVZecrAfhR4eZl7u5iS3dZtDWCpt1uyRnYSA29eWhN
   w==;
X-CSE-ConnectionGUID: FDoaZimORm+l+/cH/PgJDQ==
X-CSE-MsgGUID: p33BGrA3TaqOW0IepirveQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="87514284"
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="87514284"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 21:27:19 -0700
X-CSE-ConnectionGUID: +9hlKeFlSAmLYsGv1BXY8Q==
X-CSE-MsgGUID: 2sk9vn3VR4CEp61Oq3LhNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="249080615"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 21:27:19 -0700
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
Subject: [PATCH v5 06/10] fs/resctrl: Use accurate and symmetric exit flows
Date: Tue, 30 Jun 2026 21:27:06 -0700
Message-ID: <4cdd79d612dc6d62ccd490e1c31298025d66d385.1782857711.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782857711.git.reinette.chatre@intel.com>
References: <cover.1782857711.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During schemata file write handling there is one error exit path labeled
"out" that handles all cleanup and unlocking needed on exit. The staged
configs cleared during an error exit may not have been used at the time
of exit making the clearing of the staged configs unnecessary.

Access the exit code using two labels and only clear the staged
configuration if it was in use at the time of exit. Doing so makes the
code flow obvious and simplifies upcoming changes that improve the
handling of failures during early input parsing.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
Changes since v4:
- Add Tony's Reviewed-by tag.
---
 fs/resctrl/ctrlmondata.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index 2b29fb5a8702..e6ad8927cf50 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -331,7 +331,7 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
 	if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED) {
 		ret = -EINVAL;
 		rdt_last_cmd_puts("Resource group is pseudo-locked\n");
-		goto out;
+		goto out_unlock;
 	}
 
 	rdt_staged_configs_clear();
@@ -341,16 +341,16 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
 		if (!tok) {
 			rdt_last_cmd_puts("Missing ':'\n");
 			ret = -EINVAL;
-			goto out;
+			goto out_clear_staged;
 		}
 		if (tok[0] == '\0') {
 			rdt_last_cmd_printf("Missing '%s' value\n", resname);
 			ret = -EINVAL;
-			goto out;
+			goto out_clear_staged;
 		}
 		ret = rdtgroup_parse_resource(resname, tok, rdtgrp);
 		if (ret)
-			goto out;
+			goto out_clear_staged;
 	}
 
 	list_for_each_entry(s, &resctrl_schema_all, list) {
@@ -365,7 +365,7 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
 
 		ret = resctrl_arch_update_domains(r, rdtgrp->closid);
 		if (ret)
-			goto out;
+			goto out_clear_staged;
 	}
 
 	if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP) {
@@ -378,8 +378,9 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
 		ret = rdtgroup_pseudo_lock_create(rdtgrp);
 	}
 
-out:
+out_clear_staged:
 	rdt_staged_configs_clear();
+out_unlock:
 	rdtgroup_kn_unlock(of->kn);
 	return ret ?: nbytes;
 }
-- 
2.54.0

