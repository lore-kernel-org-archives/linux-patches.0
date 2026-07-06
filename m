Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0D236F905
	for <patches@lists.linux.dev>; Mon,  6 Jul 2026 22:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783378001; cv=none; b=FzppcDSnyhs+Rf/fdTCKtmIDTSUX9PNYbfTytzbE3AcxkBD6+qlwtBiutmC5FBC5/HOi13FJFUYFxxtiT3Pv5tYQ9GMqaarWa6WrlWpa84k4EoZtQgGgewPVKcH7wjBvb3yl/j242WdGQZUrHaNP4PJy8qVA33NHpqfkG+ewFnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783378001; c=relaxed/simple;
	bh=VDngnhenflX0tXXsJSrCumBTiF3iz0SbeOHYWEI8Qls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPipWRVhs+XIWXdkH9bC3BkW+CTwMoumELiKFJf4z8q/n0CeIImZQjGMNvT6kM1Lkq7EJTViEQ+CiE/tqezHHvVuMvg1WHsG65WQXM66PNT88PWjr/tMNzSYiEMpJMV4gYICoCD+Rh+rMajFvMvoI4n6jkHfv57MZcOQcTHL0vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iIzMUFyy; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iIzMUFyy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783378000; x=1814914000;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VDngnhenflX0tXXsJSrCumBTiF3iz0SbeOHYWEI8Qls=;
  b=iIzMUFyytnuhF9VPIZ+4zIL8CYk8vqCmNjMOLbOPLyRVhWQbIor9XGWx
   cveEDIHbPxKyiwZBTT8ggnmKeg6LPc+3vVHYGXxOaw+LNr5fxucMbU06Z
   tDiSszThXIYAGY8jdIj5nMdiTFmCuTmY000CtRQU429fAcKi721Bl8vIS
   8ySNh/mDkYDCMKbog67TXes0Ft0hcgQBoVLYpNc09/fyjsyVNhXi/EYg1
   +A1yRqWXHh7pum3ghFMP9IlN9AT1LlFUpGjShvH/RmU3t762VP4JlgviU
   mKBDaX/yb59RvsqriJykUxGvsSUeQZqqRxZwuPym1Ukni3wB90/+pu4AX
   w==;
X-CSE-ConnectionGUID: iF5HHIlCQmWBtgNdSdSAqQ==
X-CSE-MsgGUID: tH/e57U1RDWAzWjh/XXLLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11839"; a="95401471"
X-IronPort-AV: E=Sophos;i="6.25,151,1779174000"; 
   d="scan'208";a="95401471"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2026 15:46:39 -0700
X-CSE-ConnectionGUID: f+ioWRtPQouRjHKvasTHeQ==
X-CSE-MsgGUID: V5uga01eSmahWrwCSJFvwA==
X-ExtLoop1: 1
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2026 15:46:38 -0700
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
Subject: [PATCH v6 01/10] fs/resctrl: Free mon_data structures on rdt_get_tree() failure
Date: Mon,  6 Jul 2026 15:46:21 -0700
Message-ID: <433623b7e3316ffd52323255d1aa4f156ad97cb1.1783377598.git.reinette.chatre@intel.com>
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
Cc: <stable@kernel.org>
---
Changes since V2:
- Reword changelog.

Changes since V3:
- Add Chenyu's Reviewed-by tag that should have been added in V2.
- Add Ben's Reviewed-by tag.
- Add Closes: tag.

Changes since v5:
- Move patch earlier in series and add forward declaration for
  mon_put_kn_priv() to support backporting now that it is needed before
  big patch that moves functions. Forward declaration will be removed
  as part of the big patch that moves functions so net changes are
  same as v5.
- Add Cc: <stable@kernel.org>
---
 fs/resctrl/rdtgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index af2cbab14497..1312b52c7f7b 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -74,6 +74,8 @@ static int rdtgroup_setup_root(struct rdt_fs_context *ctx);
 
 static void rdtgroup_destroy_root(void);
 
+static void mon_put_kn_priv(void);
+
 struct dentry *debugfs_resctrl;
 
 /*
@@ -2893,6 +2895,7 @@ static int rdt_get_tree(struct fs_context *fc)
 		kernfs_remove(kn_mondata);
 out_mongrp:
 	if (resctrl_arch_mon_capable()) {
+		mon_put_kn_priv();
 		rdtgroup_unassign_cntrs(&rdtgroup_default);
 		kernfs_remove(kn_mongrp);
 	}
-- 
2.54.0

