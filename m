Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F65013E41C
	for <patches@lists.linux.dev>; Tue, 28 May 2024 22:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716934822; cv=none; b=LV0aX+ow9Q6ORL6J0O1k1bM7f4w9nHMieixijfVw5pYCPaGqoos/0H1ZD6cONbwPVQxiJJV7eCtR7WLYm3XKQyfDY6mlVTYGDbQJz3vxQ/kwWGoIb9BSvLVnXIbZVxj5Uwn9X1SrnM647SI11zatYgWSzkhDyKysykjPn3tXeDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716934822; c=relaxed/simple;
	bh=Z98ziZarYICAVphRTOHb1SbLcVID2nk5s6aKEDY0vks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TsPePphKU1VMrZorEFgkzTUDt+ES3HGeBtWw1CdHAcIAPIauv6gVyXrpbSHBuELiAJd47QyQiO3qEl4Cc0PlBJcUFzil69VGLsLcr+2HLJDblOLPVfaNOW4f2IH4ysqJvmJzwIn1JYh4GDfDZFZ1enJejbOXLlNWdL/iOdVgJnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MrY5hase; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MrY5hase"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716934821; x=1748470821;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z98ziZarYICAVphRTOHb1SbLcVID2nk5s6aKEDY0vks=;
  b=MrY5hasenHow3TVK6tcNLTzElNt3R4h5YhJEumyI2BBHy+VHqHhFwWin
   mKz/rGbxC4S9ARCCCz/HvoViZWRkqGeVbTg9hNhVdBj6dr3Emiwa7h7fX
   jwEgK0iIjg01Ac25lqv9ImBbPbMrKsPPiLGklokYxogWsGnjM+ztCmWAI
   trIievD1ydsBJpNR64d1TkM9ibOyoXPFfU0PhpNQlwF6mVNSf7pGQrZcr
   lzBEvxsnAVcryl50Wt6+e6Ek96aiMkXY0UrqD+RnuR7PztjfYHiJEuCkV
   a4jtyZevNVo8PhV7u0ojKzaZ6BUsG4SAYh8mICs7hYZBJPqQz7k5O/Rly
   A==;
X-CSE-ConnectionGUID: njupA6xGT/GJvH5ioFkJyw==
X-CSE-MsgGUID: K09oXC4BSpWYQlzFTYG3hw==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="30812183"
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="30812183"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 15:20:17 -0700
X-CSE-ConnectionGUID: ZDVryoqgQO27/6KJWYLq+w==
X-CSE-MsgGUID: TSd0MCchTYKKPyPS5fNjlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="40090731"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 15:20:16 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v19 07/20] x86/resctrl: Block use of mba_MBps mount option on Sub-NUMA Cluster (SNC) systems
Date: Tue, 28 May 2024 15:19:52 -0700
Message-ID: <20240528222006.58283-8-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240528222006.58283-1-tony.luck@intel.com>
References: <20240528222006.58283-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When SNC is enabled there is a mismatch between the MBA control function
which operates at L3 cache scope and the MBM monitor functions which
measure memory bandwidth on each SNC node.

Block use of the mba_MBps when scopes for MBA/MBM do not match.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index cc31ede1a1e7..1cc4794d5a2e 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -2343,10 +2343,12 @@ static void mba_sc_domain_destroy(struct rdt_resource *r,
  */
 static bool supports_mba_mbps(void)
 {
+	struct rdt_resource *rmbm = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
 
 	return (is_mbm_local_enabled() &&
-		r->alloc_capable && is_mba_linear());
+		r->alloc_capable && is_mba_linear() &&
+		r->ctrl_scope == rmbm->mon_scope);
 }
 
 /*
-- 
2.45.0

