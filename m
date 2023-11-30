Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B2F137C
	for <patches@lists.linux.dev>; Thu, 30 Nov 2023 00:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RMAKgOuZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701304466; x=1732840466;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t1wNRfyKVn+hdnCko9yKkK+HNhlf1f/vbMudAv6pV6Q=;
  b=RMAKgOuZeFaoVcgBPuWa/F8OdRE2HCeWSQQ9M9fyEVzsZh0pdSFa3bq3
   IjRlgl1UiDugTGhKAAvDGjCB9kJpbfNRefr3HNsa9cdI0tdJZ8p1Hozb4
   Ujh7LJSboJ4qTPI+gLqTKHknoQqPaxcnn6KWvNKwo8El4HYaLSa7gTsaq
   fXOIU8m8qml5TdXCvH3F6hSMKnLnR4azxRVNFwI2bphHFlUerP/wYZMAN
   W7iJiPwvorrIESVeyAT3MD+xuUgSg6h4adI+KU09KbCO6yqMU3BNXtOND
   ffGEOTl5e6qMaIR7abRuA91cbI1bg481fjrRtzYQP17UPdzIGushDn3KS
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10909"; a="392990593"
X-IronPort-AV: E=Sophos;i="6.04,237,1695711600"; 
   d="scan'208";a="392990593"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2023 16:34:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10909"; a="762499565"
X-IronPort-AV: E=Sophos;i="6.04,237,1695711600"; 
   d="scan'208";a="762499565"
Received: from agluck-desk3.sc.intel.com ([172.25.222.74])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2023 16:34:25 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	x86@kernel.org
Cc: Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v12 0/8] Add support for Sub-NUMA cluster (SNC) systems
Date: Wed, 29 Nov 2023 16:34:10 -0800
Message-ID: <20231130003418.89964-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231109230915.73600-1-tony.luck@intel.com>
References: <20231109230915.73600-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Sub-NUMA cluster feature on some Intel processors partitions the CPUs
that share an L3 cache into two or more sets. This plays havoc with the
Resource Director Technology (RDT) monitoring features.  Prior to this
patch Intel has advised that SNC and RDT are incompatible.

Some of these CPU support an MSR that can partition the RMID counters in
the same way. This allows monitoring features to be used. With the caveat
that users must be aware that Linux may migrate tasks more frequently
between SNC nodes than between "regular" NUMA nodes, so reading counters
from all SNC nodes may be needed to get a complete picture of activity
for tasks.

Cache and memory bandwidth allocation features continue to operate at
the scope of the L3 cache.

Signed-off-by: Tony Luck <tony.luck@intel.com>

Changes since v11:

Global: (comment from Reinette)
	Reorder tags with Signed-off-by: first, then Reviewed/Tested

Patch1: (comment from Reinette)
	Add error message to domain_remove_cpu() [matching the one in
	domain_add_cpu()] for the case where get_cpu_cacheinfo_id()
	failed to find a cache ID for the current CPU.

Patch3: (comment from Reinette)
	When splitting the domain_add_cpu() and domain_remove_cpu()
	functions add "control" and "monitor" to the warning messages.
	Fix the:
		pr_warn("Couldn't find control scope id=%d for CPU %d\n", id, cpu);
	message:
		s/Couldn't/Can't/
		s/control scope/control domain with/
		Add resource name.
	Ditto for similar monitor message.

Patch6: (comment from Reinette)
	Used Reinette's rewrite into imperative mood for latter part
	of commit message.

Patch8: (comment from Randy)
	s/have/has/  s/cache. But/cache, but/

Added Reinette's "Reviewed-by:" to all patches except patch 3.

Added Shaopeng Tan's Reviewed and Tested to all patches.

Rebased to v6.7-rc3

Tony Luck (8):
  x86/resctrl: Prepare for new domain scope
  x86/resctrl: Prepare to split rdt_domain structure
  x86/resctrl: Prepare for different scope for control/monitor
    operations
  x86/resctrl: Split the rdt_domain and rdt_hw_domain structures
  x86/resctrl: Add node-scope to the options for feature scope
  x86/resctrl: Introduce snc_nodes_per_l3_cache
  x86/resctrl: Sub NUMA Cluster detection and enable
  x86/resctrl: Update documentation with Sub-NUMA cluster changes

 Documentation/arch/x86/resctrl.rst        |  25 +-
 include/linux/resctrl.h                   |  85 +++--
 arch/x86/include/asm/msr-index.h          |   1 +
 arch/x86/kernel/cpu/resctrl/internal.h    |  66 ++--
 arch/x86/kernel/cpu/resctrl/core.c        | 411 +++++++++++++++++-----
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c |  58 +--
 arch/x86/kernel/cpu/resctrl/monitor.c     |  68 ++--
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c |  26 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 149 ++++----
 9 files changed, 607 insertions(+), 282 deletions(-)


base-commit: 2cc14f52aeb78ce3f29677c2de1f06c0e91471ab
-- 
2.41.0

