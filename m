Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB4D377EDB
	for <patches@lists.linux.dev>; Wed, 29 Apr 2026 15:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777475213; cv=none; b=prnRCmWql1cLBU7+FHFVQ1fVXU9+uwX3r+TGNrD1AQoK+kxGT9I7LmE3y9km7MngSMWlCcDWGcBnfGGVdO8NLplD9g+f1MDEv8vXjyoPA7MmfPfe8yV2n+f8dQG+cmPswqIsP+TkS358P+/IaSh3QPJFLhLp1LZjoXtHp7q4RiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777475213; c=relaxed/simple;
	bh=DBmG70Xr4+Z1t3xjsxbRIErkOrffXvoW6wckmtG8CM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIHUipwi72yJHV0ySCpAr1LwVETO0xIAM2kB0KuR3QwJQMaNlzZBnpCOBb5k1KT5iYB/t5U496BERb99ytzB3BldxX9Ihf80+zpqCsasfK+F/8gafRz69vdo6kubO8AAuLBHRWcaBQkdH0dWucpTKsIz48wWORZ6gK7vwfaBeXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ao4S4boZ; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ao4S4boZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777475213; x=1809011213;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DBmG70Xr4+Z1t3xjsxbRIErkOrffXvoW6wckmtG8CM4=;
  b=Ao4S4boZJbU5MAovKVgyhEBmYj7I1cdAcLeGMys2UoCcOBb9A8pWLped
   hj2g07n4jUA6flecHthIayus2SbpK2l2xWu0ztikloLkDN+dbO2uk1NP9
   PKTXmJWHbxIvNWPj+ool3hyjKq/zweB5OTLoCCzAZgk1ZLABaromfPS6x
   Jai8CEHdekuT5rmJ/jLYUjQuKUXDIJMFRGyWoVNm9uuRNZUH/V1YuEWBv
   HRA2HEfD7UMWm5fB2NyEvo2qH0B+QTuZIfovBxHL6JbIM8D+6hlmiOg/R
   IQsCs/uMuP9INLn5dXzXuH3Fyt0TZdK3HGwIJCl/+3GEIvGteHPBxOUuw
   Q==;
X-CSE-ConnectionGUID: C2jVQhaXTtGRFaxqnypZhw==
X-CSE-MsgGUID: rEx+6JLWSNOjVjRc4+otGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="78424388"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="78424388"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 08:06:47 -0700
X-CSE-ConnectionGUID: Qp9d7dCgTlWGEe4eU3VudQ==
X-CSE-MsgGUID: cnJdusrBQaOoudcCdPupMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="233445019"
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
Subject: [PATCH v4 07/10] fs/resctrl: Use accurate and symmetric exit flows
Date: Wed, 29 Apr 2026 08:06:37 -0700
Message-ID: <74a640427ad531bdca4e6ff72bdaffe622d7a846.1777419024.git.reinette.chatre@intel.com>
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

