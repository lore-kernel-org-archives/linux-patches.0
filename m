Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C523B3C6A56
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 16:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775577777; cv=none; b=egAyUkJpnB0tRRHXjv0RWpp7ZjaluTEsckeP6ZNmwrzEPm/V2Rnl0sLqDwxr/1Rra8f5Tck2nqsbcntj/tZq+Q7sSgw4D4T+mWGbrm742YNRuANT8I/KAxL1f5wiHXXyw4NEpLJSA6JZBpx6LfWcQOZX8pUbSXKxdEpPDxTozj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775577777; c=relaxed/simple;
	bh=DBmG70Xr4+Z1t3xjsxbRIErkOrffXvoW6wckmtG8CM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TvwFdEpC7R/S96+r8LvLHeCF8Xd8l7225ae6RxnneeZjFrESgooxZ4gHLA6oZ4XN1rUgPAz4YO2ZSBGJFXASNmO0Qy24PY4pBjowilZfxS5+DpCyGBEpxNr+bMpAbCgs/eKMwovzHWXaMc83q7besvaGYnODOifBbAKKKw3h824=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k6rbc9l5; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k6rbc9l5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775577770; x=1807113770;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DBmG70Xr4+Z1t3xjsxbRIErkOrffXvoW6wckmtG8CM4=;
  b=k6rbc9l5Ott4idUX9gTvUeHNvDcNo1953bMCgU/HmqFrFdQ4D4u8S088
   QYOFDqIzwA//U9vCqtsfCNIH3FQv3paQmwXGInQl7zM76rR9sBxLU8UkT
   kZyYSsHTsJ5SrGdSCIZHO+EvTdoEbBgc8fLza9mWjtl4pq5ccETxJYtau
   gbnAsPPRuevpLSVHV4XmjTszNj9CIVlAZsmlGMvBiB5tj3+zQ68xKzMHL
   myDp3OsjGn2Gy4sYgKmITI+0kypPtizZCOz/A5QvTXENHgidBgZg4rKiC
   8wkjYqMUOIGFjVtuz9PRDJ9lZyfZ9R3kYe9IVRiwl8CeWsOdKtW7aT0RC
   A==;
X-CSE-ConnectionGUID: 1zWyelOEQK6J/aRBVka5mA==
X-CSE-MsgGUID: 3OHIyX20TQGzqWlwmYqmmA==
X-IronPort-AV: E=McAfee;i="6800,10657,11752"; a="80432745"
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="80432745"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 09:02:19 -0700
X-CSE-ConnectionGUID: BSgNVgdgT+ml23rXCqpn/g==
X-CSE-MsgGUID: SJZQJCeKT6WR5TCpc7f0bQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="228119059"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 09:02:18 -0700
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
Subject: [PATCH v3 10/13] fs/resctrl: Use accurate and symmetric exit flows
Date: Tue,  7 Apr 2026 09:02:07 -0700
Message-ID: <1762225e701717c34ba544e9d92bc1af9f453f7e.1775576382.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1775576382.git.reinette.chatre@intel.com>
References: <cover.1775576382.git.reinette.chatre@intel.com>
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
---
 fs/resctrl/ctrlmondata.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index 9a7dfc48cb2e..8a43efe67a95 100644
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
2.50.1

