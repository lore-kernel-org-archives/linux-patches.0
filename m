Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6825137CD5F
	for <patches@lists.linux.dev>; Fri, 15 May 2026 19:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778873993; cv=none; b=bMthq7/bl8j7tRcHGE5z5fl+fBPc22vV80hd0ArWWJLmYtfysRoQ59GSI/Kp61wucK4KNFOzdEqmDA9wuJMcRReSlMA9UpBKSDD5b4OQUZopI4BdicEMDcWpY6VYwO73AwRo2qVQfPpoW5H33VJLKBWBxg5scQsWSbvaQmvwweI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778873993; c=relaxed/simple;
	bh=X4x+mkcVH3JVpkvi/x15BSTyz8Uh2BO3EPGaBv9xpes=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hJ0ucWZQu607jco2Z4wX+FEakQscUh4GNc71s+9bvKngcbbb6uFDlv8zUbgfFThHWv6gGaHsIAQGlK2ukY+ooGXXpAEDQdHv9iZFpsFrZdCBap1aKGMK8Q25NJ2tE7O4rwB1dLCgvGKn427YyPkMfmSQ9YbDtIXWh89Ci7VZ6s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TgwpUdpl; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TgwpUdpl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778873991; x=1810409991;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=X4x+mkcVH3JVpkvi/x15BSTyz8Uh2BO3EPGaBv9xpes=;
  b=TgwpUdplnxtg20SS++qRZhEyuRVqMB3WvqGd8yBQEznLsQL2gKLMe3CE
   ILNpMprl4mq/B9zljaRCewf9VEHq2r9ZEKVGeh0SVEhodrt3+dGfTp30M
   g0GFYWubH38+LiLcYFs6i2AJ8oiuFquonvOrOTdT/lg6DwwOB/3IL5Upa
   u7oBfF6xPrDUspVUKmSinmd3xEPOkMPSKTdfy2bgBQd+Fwu2OkoojF918
   ehGkhr0hQ5JiT4aUXMkrOQAL7BTloEgpRF+9oY8qHnFvDggSTHaqLu2Lh
   JvHSlTHCqyPzUzdyRzuJYuQk1R43FhVX7XoZV6/LNMRdXNW78hZVf2or7
   Q==;
X-CSE-ConnectionGUID: 4NkMPgPESCKrTExQdofBew==
X-CSE-MsgGUID: nSupkAa6SAGWDSu5vH9t6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11787"; a="78972205"
X-IronPort-AV: E=Sophos;i="6.23,236,1770624000"; 
   d="scan'208";a="78972205"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2026 12:39:50 -0700
X-CSE-ConnectionGUID: JmNF1P69Rr+En7DFOZSwJw==
X-CSE-MsgGUID: Sa8LqCErQrqDFZ1Wcydljg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,236,1770624000"; 
   d="scan'208";a="237916556"
Received: from hanvin-mobl3.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.27])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2026 12:39:50 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v2 0/5] fs/resctrl: Fix four long-standing issues
Date: Fri, 15 May 2026 12:39:39 -0700
Message-ID: <20260515193944.15114-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sashiko reported a deadlock during mount, and a use-after-free when an
L3 domain is removed during CPU offline. Reinette found a memory leak
in the mount error path while refactoring code for a solution to the
mount hang. Sashiko found the unmount issue in review of v1 of this
series.

First version of series posted here:
Link: https://lore.kernel.org/all/20260508182143.14592-1-tony.luck@intel.com/

Numerous changes based on comments to v1.

Patch 1 just reorders some code so that fixes can be applied without
adding additional forward declaration of functions.

Patch 2 fixes the memory leak found by Reinette

Patch 3 fixes use-after-free during unmount

Patch 4 fixes the mount deadlock

Patch 5 fixes issues with CPU offline

N.B. Reinette did all the work for patches 4 & 5, so I listed her
as author an me as Co-developer. Those patches need her sign-off.

Reinette Chatre (2):
  fs/resctrl: Fix deadlock for errors during mount
  fs/resctrl: Fix issues with worker threads when CPUs are taken offline

Tony Luck (3):
  fs/resctrl: Move functions to avoid forward references in subsequent
    fixes
  fs/resctrl: Free mon_data structures on rdt_get_tree() failure
  fs/resctrl: Fix use-after-free during unmount

 fs/resctrl/monitor.c  |  55 +++++
 fs/resctrl/rdtgroup.c | 473 +++++++++++++++++++++++-------------------
 2 files changed, 320 insertions(+), 208 deletions(-)


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
2.54.0

