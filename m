Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3ADF3750BC
	for <patches@lists.linux.dev>; Fri, 22 May 2026 19:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779477327; cv=none; b=iOj1PTisNw7rPunbrFfqMHjma3Ddqdt2x10kxMDKJfH5UQ/U8JLjPomcl5Xk+XBlWDH96hYnNqP4WWmNaYpJXvmMQW4yC5THutS6fVfdk+5VAuvC6MLYe87IlOQg2YdH6n6XXNKgGlNCSbopFPAjmsmGsYpYs0fxt7cNCxy2xkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779477327; c=relaxed/simple;
	bh=UpITk+dcAwtfiVSJvVbxBz6SS0IuTrTZiZwGKZ+EDiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2KZhNAOUvwYbZZqi6v5ij6kT4y/8hswuz1KkpWklLunp+4zoRZsnM1cgOcVHKcddhx1Uuh03vWb8UO/5IESzgeAAqxoSY8EHkUt9imYIvn99NDntPwul3IZZfwu2fu6qhpR/E60a7mtQaVsT0044u72syHccLY24VkwXJQtPmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dJ9+lz32; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dJ9+lz32"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779477326; x=1811013326;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UpITk+dcAwtfiVSJvVbxBz6SS0IuTrTZiZwGKZ+EDiY=;
  b=dJ9+lz32P6N/i3whvUt076VkpNB59+7NfYdtPvJ2EQOL0s8n0YqJjGBq
   AbVvUk+9IfXkhaxEuWReixo3keqdvU4/JKq308BpamLwMf11h8Rukv/Vw
   CrasQ+S33n4IfxG4eW7YSH/JRoWacvscwiP9o1btT66ujHv5wMQZ46c0G
   eQw/dcYqVtfd23P51FSfSjKysATi0mCqRIII3TqPuDKg3FEpvCXvq/BUo
   sAhdnvhpfYkARNf7Y1q5NzidT4lDm+q17YZV9VhkIQopAMdUPIWQtN6hK
   50euwsjVf/MKVlx6v5FgLDjX4PMEPfFBIbBYa6DzVjJlT1wo1sl2jji93
   w==;
X-CSE-ConnectionGUID: EzPqnEibSHOw9QHDzxQByw==
X-CSE-MsgGUID: Pve4Q695Rvey+9CJImmv6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11794"; a="80140440"
X-IronPort-AV: E=Sophos;i="6.24,162,1774335600"; 
   d="scan'208";a="80140440"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2026 12:15:23 -0700
X-CSE-ConnectionGUID: GS8TE41WQwyZPNfqBqUtUQ==
X-CSE-MsgGUID: 0Up5ztFuTK++DKDp0SQqeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,162,1774335600"; 
   d="scan'208";a="271336462"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2026 12:15:24 -0700
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
Subject: [PATCH v3 2/9] fs/resctrl: Free mon_data structures on rdt_get_tree() failure
Date: Fri, 22 May 2026 12:15:06 -0700
Message-ID: <9ef75c3c853c29e5051c8915901d43edff011a1c.1779476724.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1779476724.git.reinette.chatre@intel.com>
References: <cover.1779476724.git.reinette.chatre@intel.com>
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
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since V2:
- Reword changelog.
---
 fs/resctrl/rdtgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 91922fe1ea08..f573db9e6e84 100644
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

