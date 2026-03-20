Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C6F369996
	for <patches@lists.linux.dev>; Fri, 20 Mar 2026 22:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774044243; cv=none; b=BJMYzVVy6UBKWdkE1cfdyzckYl90TM/dcR4fYlxGMdPk5V0T+ezIxf0PMPcQYP1snJt86E9AjkZxLtEdAXtHG/gvtfQLF/sAFUuDMJcRS5Ks9aLOgTFY1J5To0rTAsiAgom0kgcOYWD7lM0piqSAjXHXBE9CBYjk0v5lut6hi9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774044243; c=relaxed/simple;
	bh=WuOr17rmOeSXijSalpBw2VvgVcngOVpjuie0BTD4cHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WWtnSL0S5pZOqzHHuoVS49PSkcngycP0p/oTy29h9kohEVmZ4oObzbuMwwM8+E/UaWIjWrWQHDZnz2dcmCnfJMfyLRrziIfMCZJyVPOMQWZfyf1KV0R8PED+pLdkRWfWzKYkJ6AQWDhqAGI1PKrOlnVQp2fJPatSDiren04umSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cUArm1Lt; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cUArm1Lt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774044240; x=1805580240;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WuOr17rmOeSXijSalpBw2VvgVcngOVpjuie0BTD4cHE=;
  b=cUArm1Lt8TVLwl4wwt1mjG8zcfMlXzCB/U1Q6hg0fch2Pv/SohfV8HY/
   j1LBiC26GDXiGWZo8GYztHStxaUIHFhcFqLb+PTJsoAZAgYhkdYpbwvEa
   8euvnh6ozfAIB3WmH9ePvNbQzCCnBuhPJhhMARx959qjOP3cB89EuaW0F
   sSIb72QSxFLhc7II9k+wiOsuB+M2Sa4kcUa3EKdLFH0ON+4dw3+vaRxCa
   STn6uIAWiID0Xdl7WKWmuKoxMShXaJ/XXaAW9yHlyGLfumhG90Zo4oHwq
   ZhOKzDVXbXB4F149j4chaRhmqM0zrhq7xS4wdpKXXyxoZyFKVqCidnfvj
   A==;
X-CSE-ConnectionGUID: qeE/9+1NQXqAfNR/it/cXw==
X-CSE-MsgGUID: qjKd6rZ9T4umUaPgBAUbgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="97758429"
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="97758429"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 15:03:56 -0700
X-CSE-ConnectionGUID: zSK5T1MTT2Gc7XBDpdDXkA==
X-CSE-MsgGUID: ribkLN90S4Cj7R8E95sgwA==
X-ExtLoop1: 1
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 15:03:56 -0700
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
Subject: [PATCH v2 10/14] fs/resctrl: Use accurate and symmetric exit flows
Date: Fri, 20 Mar 2026 15:03:20 -0700
Message-ID: <445ac564270970f5736f39f892c9997728fc9bc0.1774043709.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1774043709.git.reinette.chatre@intel.com>
References: <cover.1774043709.git.reinette.chatre@intel.com>
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

