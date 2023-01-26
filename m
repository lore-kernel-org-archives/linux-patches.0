Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7E14C92
	for <patches@lists.linux.dev>; Thu, 26 Jan 2023 18:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674758552; x=1706294552;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=S3DfwWWHVjW08Y4Sj57WtWmKbuBdHRvdkYJVizXcOyE=;
  b=DS/lUWB1/TgsBIiObhPekZCCJ9S0+6pR1l+O2NmxAdCwr88UqULHJiwD
   lpslH3zxIx39g44hJdwYSXy9nzUKBJ1WiRUfkXwEef1U+5wbOBTTlU4Ka
   tUb73q5aHlB0nL9D22gnO74rzA1dJ2fogvW6FxYu6webxqZjC/D06Wr1G
   NLL7fu5jNd42VEe2ZyAYFz/8QP8b0LzMh7Xt8muC+dNvk+K7VxDBJv0rU
   lLBaYqPa7uO0yKT4AoFEUnquY7tM0afU3r4rl59iJDEYW38LIoSzUFvQX
   aHf0HPSoj6ez1FhS1Nzbgq4G7D8N22lIMzghY9mfC3g+UlbIkPY/jWpPR
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="354203312"
X-IronPort-AV: E=Sophos;i="5.97,249,1669104000"; 
   d="scan'208";a="354203312"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2023 10:42:05 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="991745435"
X-IronPort-AV: E=Sophos;i="5.97,249,1669104000"; 
   d="scan'208";a="991745435"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2023 10:42:05 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	x86@kernel.org
Cc: Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 0/7] x86/resctrl: Add support for Sub-NUMA cluster (SNC) systems
Date: Thu, 26 Jan 2023 10:41:50 -0800
Message-Id: <20230126184157.27626-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Intel server systems starting with Skylake support a mode that logically
partitions each socket. E.g. when partitioned two ways, half the cores,
L3 cache, and memory controllers are allocated to each of the partitions.
This may reduce average latency to access L3 cache and memory, with the
tradeoff that only half the L3 cache is available for subnode-local memory
access.

The existing Linux resctrl system mishandles RDT monitoring on systems
with SNC mode enabled.

But, with some simple changes, this can be fixed. When SNC mode is
enabled, the RDT RMID counters are also partitioned with the low numbered
counters going to the first partition, and the high numbered counters
to the second partition[1]. The key is to adjust the RMID value written
to the IA32_PQR_ASSOC MSR on context switch, and the value written to
the IA32_QM_EVTSEL when reading out counters, and to change the scaling
factor that was read from CPUID(0xf,1).EBX

E.g. in 2-way Sub-NUMA cluster with 200 RMID counters there are only
100 available counters to the resctrl code. When running on the first
SNC node RMID values 0..99 are used as before. But when running on the
second node, a task that is assigned resctrl rmid=10 must load 10+100
into IA32_PQR_ASSOC to use RMID counter 110.

There should be no changes to functionality on other architectures,
or on Intel systems with SNC disabled, where snc_ways == 1.

-Tony

[1] Some systems also support a 4-way split. All the above still
applies, just need to account for cores, cache, memory controllers
and RMID counters being divided four ways instead of two.

Tony Luck (7):
  x86/resctrl: Refactor in preparation for node-scoped resources
  x86/resctrl: Remove hard code of RDT_RESOURCE_L3 in monitor.c
  x86/resctrl: Add a new node-scoped resource to rdt_resources_all[]
  x86/resctrl: Add code to setup monitoring at L3 or NODE scope.
  x86/resctrl: Add a new "snc_ways" file to the monitoring info
    directory.
  x86/resctrl: Update documentation with Sub-NUMA cluster changes
  x86/resctrl: Determine if Sub-NUMA Cluster is enabled and initialize.

 Documentation/x86/resctrl.rst             | 15 +++-
 include/linux/resctrl.h                   |  4 +-
 arch/x86/include/asm/resctrl.h            |  4 +-
 arch/x86/kernel/cpu/resctrl/internal.h    |  9 +++
 arch/x86/kernel/cpu/resctrl/core.c        | 83 ++++++++++++++++++++---
 arch/x86/kernel/cpu/resctrl/monitor.c     | 24 ++++---
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c |  2 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 22 +++++-
 8 files changed, 136 insertions(+), 27 deletions(-)

-- 
2.39.1

