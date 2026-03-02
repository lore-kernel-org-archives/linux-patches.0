Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA2A379EDB
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 18:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772477194; cv=none; b=fa+2Yy+8Mc7mdxB3lSphDn7o2iktJ/Z9oRGipMiZxylZkCEy5T7/MxgzSxvqEb8lVit89iDQmsIdfE+WyBKwM/n9QQfAUKlBXgrekY6Yq53IrAwiNZ1UmLdBOReireJxl1qsznOW821yF3aqMRua6JffTgQkrXYUasmGjKt4wh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772477194; c=relaxed/simple;
	bh=WuOr17rmOeSXijSalpBw2VvgVcngOVpjuie0BTD4cHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFGX8Df/1fzGW1RFLPaF2Ec5pphFW4uRdGhwZO/KlCTgqQQy3QjvdhodhJ1c+r7wJtb+6KmpE/hc1qb7y767uaFMeBgD816iAP+UxbAeumpRLCu1bArjwuwhFkeA6EbV5yl3rmAYojTj9/Nf/1YYZMfOQeMyXrEPI1MeTHq+9Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bf2Dob/O; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bf2Dob/O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772477192; x=1804013192;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WuOr17rmOeSXijSalpBw2VvgVcngOVpjuie0BTD4cHE=;
  b=Bf2Dob/OAgdPURMQjrOUWb6gcVvZI8R03A9rWQIh9etBO4YCdWDzQdEl
   z730QOWH2qfximAc06BEeuGtkz5pMGjOEjJqB4mkGFbPHYQ8XDv29XSwk
   QkbF5wTNbM4iJhQs55sMOohRp+8y8xuApES+bO9NB5+BOzmoXlx2j0RQ1
   HMpIPNqHzhvZ+0AXNCk3REyO5LLtFLw4+nFv2TdzADHpBNvUVLKOxGJMS
   7sR36Uxhl9qbsraWAZ65srtnSYqZH22hi1y2qel9Dc0qHf/8WYcIawbtU
   a0FEyTaGoxULkxvrKi/ytWZtdEY4WVvGuOaHKIXgDWUsAHzPeyy7FpzAt
   w==;
X-CSE-ConnectionGUID: Vd0KvKxBT1qAMNMhfxsulw==
X-CSE-MsgGUID: IpTX9JrZS5aFwCUEaOXm4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="84135498"
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="84135498"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 10:46:27 -0800
X-CSE-ConnectionGUID: P/TfXnQ8RGKa+2ORRT8PDw==
X-CSE-MsgGUID: Olwv4Q0USdibrUg0kCqD2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="255604098"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 10:46:26 -0800
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
Subject: [PATCH 08/11] fs/resctrl: Use accurate and symmetric exit flows
Date: Mon,  2 Mar 2026 10:46:14 -0800
Message-ID: <f39c86fd55a71e76a38118177e32cfe0379f589c.1772476561.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1772476561.git.reinette.chatre@intel.com>
References: <cover.1772476561.git.reinette.chatre@intel.com>
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
index cc4237c57cbe..a8e7cdcfec6e 100644
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

