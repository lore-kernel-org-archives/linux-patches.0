Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E630208A2
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 22:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mdtfh7xQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698789944; x=1730325944;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=IwpVz6MF9Gm8aHgWudjf+PhbOFRizyKxWaZV8j9bj5E=;
  b=Mdtfh7xQZFWl3kjvRWGxNaRUXoj0eiRTfclxrBil5+/boL/OQPW4+17O
   rCXhVWPQ34QyEkLArNPDAMTDvKY2XmpsUXDy2/vtmiB33kybn1OEbI/jf
   1JP/F6/7UAyta+6tY+H4nv2WCWJoa8oNU52HAj03+wHc89vEyda222Yq/
   pKXtbVVTB2TjV7hw+cHfczYat0EMyhqjnuKT9/t7d6uxwBTNPqSwCAggx
   kwJC4LAkJnMP/KgiDZaOyAhbPg1QhwCyWcmTfTcyUWktzvEhirhMsNxmN
   hSHfdmqyywv+d26EdVmJptUINUFIiE9plswALXsvhFpD/nr2YobVLcoF5
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="391251401"
X-IronPort-AV: E=Sophos;i="6.03,266,1694761200"; 
   d="scan'208";a="391251401"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 15:05:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,266,1694761200"; 
   d="scan'208";a="8456911"
Received: from agluck-desk3.sc.intel.com ([172.25.222.74])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 15:05:43 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	x86@kernel.org
Cc: Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] x86/resctrl: Fix unused variable warning in cache_alloc_hsw_probe()
Date: Tue, 31 Oct 2023 15:05:34 -0700
Message-ID: <20231031220534.37730-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In a "W=1" build gcc throws a warning:

arch/x86/kernel/cpu/resctrl/core.c: In function ‘cache_alloc_hsw_probe’:
arch/x86/kernel/cpu/resctrl/core.c:139:16: warning: variable ‘h’ set but not used

Fix by switching from rdmsr() to rdmsrl() using a single u64 argument
for the MSR value instead of the pair of u32 for the high and low
halves.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
This has been annoying me for a while as the only warning from the
resctrl code when building with W=1.

N.B. compile tested only. I don't have a Haswell system to check this works.

 arch/x86/kernel/cpu/resctrl/core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 19e0681f0435..4084131d391d 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -136,15 +136,16 @@ static inline void cache_alloc_hsw_probe(void)
 {
 	struct rdt_hw_resource *hw_res = &rdt_resources_all[RDT_RESOURCE_L3];
 	struct rdt_resource *r  = &hw_res->r_resctrl;
-	u32 l, h, max_cbm = BIT_MASK(20) - 1;
+	u32 max_cbm = BIT_MASK(20) - 1;
+	u64 l3_cbm_0;
 
 	if (wrmsr_safe(MSR_IA32_L3_CBM_BASE, max_cbm, 0))
 		return;
 
-	rdmsr(MSR_IA32_L3_CBM_BASE, l, h);
+	rdmsrl(MSR_IA32_L3_CBM_BASE, l3_cbm_0);
 
 	/* If all the bits were set in MSR, return success */
-	if (l != max_cbm)
+	if (l3_cbm_0 != max_cbm)
 		return;
 
 	hw_res->num_closid = 4;
-- 
2.41.0

