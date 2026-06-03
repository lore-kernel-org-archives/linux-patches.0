Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB72D3F2106
	for <patches@lists.linux.dev>; Wed,  3 Jun 2026 03:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780457282; cv=none; b=pz37sCeAbL6oOmBH75jB/Lz3D9Ph1Dmi52cFCtD8zbGyOo6f9d+Rgvs70CVL2w3erozWHwfwVcWfcRlHRb75+s8aWWl8psl0pFSx//i2QoCnQ0yHJKDGbjpOxclSGGxJyMOfRLZEx6wR8PDj9Gmj4lFxuY2s34jnKr7kGzlfS0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780457282; c=relaxed/simple;
	bh=C8hY132qG+xjkRnVVTukTcbYF6pljAiJfoDuxTvymqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwv6i8ZC9hYukQsJRy8O2Xcayy/oldjU4sj7zK5Gk+LceJl+HuQvOkwZFzLY7RCNCG3ppFAAwo/jqQe53Y9Po4wGSPPFWLAVeyscFolb+JDqu3uOoKdDu5mVWzugTF036ufqnjOvHl4xcrdNzA/4LN2Y7HKV5Kq50nKbSTw9irQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hf0kSrZg; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hf0kSrZg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780457282; x=1811993282;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C8hY132qG+xjkRnVVTukTcbYF6pljAiJfoDuxTvymqU=;
  b=Hf0kSrZgAL+bGmqHmYa5FVaDz04fr/LnGLdz3JeAQTYSWSG86wLSK3HZ
   1LJVQDWAaQ8/VJLBEZ5xnJ6G0kEcIUK+0RDF0PUO1XgbPiKk/rsp/3PhB
   dciH36vYdXWywA+hwepvYe6uhTuZ/jlftZweG1uxiBAKHyOpqxgxRdXt4
   Ugw6usOuNRePaA6CpWEdipi1+gHO9hTQZHEJyoZ5ehpQ/eD4soG7149Fa
   58LBKBLRHdP07iBNHXVB5S0jKPt3T531semjfE3Xgrr1iuoJm1/qSD8tx
   VyuORjjMOgIY0YRYNAURFd/16XaitXL1ukuTX6lXN10EA1YiUTfEAmDUH
   A==;
X-CSE-ConnectionGUID: mX4TvoWBSCeOq369XutQKA==
X-CSE-MsgGUID: JakPWQ/lSN6Y787Vshv2uw==
X-IronPort-AV: E=McAfee;i="6800,10657,11805"; a="91938990"
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="91938990"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 20:28:00 -0700
X-CSE-ConnectionGUID: j4VKF9jvTUqPXgHdZo7cQA==
X-CSE-MsgGUID: bUkltbcWQwi8Pk5mgLa0BA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="241110103"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 20:27:59 -0700
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
Subject: [PATCH v4 03/10] fs/resctrl: Free mon_data structures on rdt_get_tree() failure
Date: Tue,  2 Jun 2026 20:27:31 -0700
Message-ID: <ae8539a3cd23b82f78f14809c120db63632d4318.1780456704.git.reinette.chatre@intel.com>
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

