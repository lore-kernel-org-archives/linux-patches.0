Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D636361DA9
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 04:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782880047; cv=none; b=kt7I+ubE1bPVFExCNNjC7AzwdD2QOGQTgm2QGjAYsFvLCIaLJYsWmz9o3k719EYOfuNXKAGDUIhjnSvmKcFWzW+ruhDQzw8hLSwdzB6fJR+gw36LJrR78+mfU1bgMZLnk8f3kCQ1GY0hNeT2v6UccuvCA6yUOy3nkIUSGfAmM0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782880047; c=relaxed/simple;
	bh=jv7ZNDa6JI2lmMI+Jmrk04umdu3Fkzd56xSIPcIcm1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UvDwbDxkaBhqFEngSW+7plZo3IV2q7yUuSw3E2zF3Dl50leTgmEgl27DUYr8GBlw1mCx10fcop8xYE9RJzHthHSEfjED0gLXHWAd4s2hBL8zZV7nf24ZxFeSlL+jOCG37mfXdhMsZtNM2o0Uqw2nxv/PbS10HH5h2jFPLHX7VOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ehANnJEa; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ehANnJEa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782880044; x=1814416044;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jv7ZNDa6JI2lmMI+Jmrk04umdu3Fkzd56xSIPcIcm1E=;
  b=ehANnJEaS5GMfxqcXzCc6dnuwCjsBBBfUQ8MxfoGuUHnNwEcb7j5jzH5
   uTphrzIH875N5JRWjxSCw35JD/lMgEJjIq3K8A1IP6SxZ6ZCbXpHw93+g
   LX9TDr6OeTUiuXuOSF11fT64SBTwqyRZVkyFtx2at1WdBxJetJnOWn4MF
   i+b4FbdhOf+b2g34m+3E2WW1PTKayRj31JFSOVwR5MNCQpCBDuHk3x1EC
   KkApUUvutAAQ3AwqOUvm1f6g89g6PKbl2QK+zbYagFoJ7BdXROzuKuM+1
   qsfDwfq0EbCxI7UfY67OEIWyX4I+j8aJmGCi+z8VD10rUxfdx2i+6LnXX
   Q==;
X-CSE-ConnectionGUID: cMwedRV0R9+DF/G4oJeVlA==
X-CSE-MsgGUID: 4lsJTlObSSO3enhNS0Hjkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="87514274"
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="87514274"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 21:27:19 -0700
X-CSE-ConnectionGUID: e3uIyLKUTvSbzG+HVZs55g==
X-CSE-MsgGUID: JYSSv+khQ/qhxDED44zSUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="249080602"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 21:27:18 -0700
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
Subject: [PATCH v5 05/10] fs/resctrl: Pass error reading event through to user space
Date: Tue, 30 Jun 2026 21:27:05 -0700
Message-ID: <6b3c66a49788828bd8c04a6911bd74c91ccd56f3.1782857711.git.reinette.chatre@intel.com>
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

Reading of event data is managed through populating a struct rmid_read with
properties of event needing to be read. This data is dispatched to an
appropriate CPU and upon completion any error can be found in rmid_read::err,
or on success the event data will be in rmid_read::val.

rmid_read::err is not updated in the unlikely scenario that the reading
of the event was dispatched to a wrong CPU. If this ever occurs due to
a bug in resctrl the user space read will return "success" but the data
reported will be invalid.

Ensure accurate error reporting so that if there may be an issue with
how resctrl picks a CPU it could be learned with an error to user space
instead of silent failure.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
Changes since v1:
- Add Ben's RB tag.

Changes since V4:
- Add Tony's Reviewed-by tag.
---
 fs/resctrl/monitor.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 29b13a690cf3..7f3fe055f7c9 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -458,8 +458,10 @@ static int __l3_mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 	}
 
 	/* Reading a single domain, must be on a CPU in that domain. */
-	if (!cpumask_test_cpu(cpu, &d->hdr.cpu_mask))
+	if (!cpumask_test_cpu(cpu, &d->hdr.cpu_mask)) {
+		rr->err = -EIO;
 		return -EINVAL;
+	}
 	if (rr->is_mbm_cntr)
 		rr->err = resctrl_arch_cntr_read(rr->r, d, closid, rmid, cntr_id,
 						 rr->evt->evtid, &tval);
@@ -496,8 +498,10 @@ static int __l3_mon_event_count_sum(struct rdtgroup *rdtgrp, struct rmid_read *r
 	}
 
 	/* Summing domains that share a cache, must be on a CPU for that cache. */
-	if (!cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map))
+	if (!cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map)) {
+		rr->err = -EIO;
 		return -EINVAL;
+	}
 
 	/*
 	 * Legacy files must report the sum of an event across all
-- 
2.54.0

