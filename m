Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E186FCD
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 23:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693352679; x=1724888679;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W50SnzGPp61eZeJgGcuceM/gz96TAeNxN0R4JpIxMcg=;
  b=StxLAPeduIskLhJGdms+cLocJykKR7sTV3rYNEaKVgjsLHLS2bhyF7aS
   1nj4lJ1vQZhGNluOb/XhV61p6Y3fbDmLNdcXrj+yxtVxk+0pNCDBDlyyc
   UskPdem0miUL2/rsjaqL1+clqVNMv2IPlgrSMsTdJIN+wGcqahTAWbKLU
   0uj6I0+75pzFleFrEigkPIiYZZGBScR2wYWFcFov+AZV2evaHhTE05F+s
   5Zs3rrOvyvtUiSTzyBXVAFwq6/i0A4oJYSBTllXVyCmmkn7cr9XHqYOht
   lgA+1mQ/XbqjztSan0d6r4M0KCoekYdYwI42HESdfPS2UZQKOR4vBPiQT
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10817"; a="355015403"
X-IronPort-AV: E=Sophos;i="6.02,211,1688454000"; 
   d="scan'208";a="355015403"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2023 16:44:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10817"; a="688691016"
X-IronPort-AV: E=Sophos;i="6.02,211,1688454000"; 
   d="scan'208";a="688691016"
Received: from agluck-desk3.sc.intel.com ([172.25.222.74])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2023 16:44:36 -0700
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
Subject: [PATCH v5 0/8] Add support for Sub-NUMA cluster (SNC) systems
Date: Tue, 29 Aug 2023 16:44:18 -0700
Message-ID: <20230829234426.64421-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230722190740.326190-1-tony.luck@intel.com>
References: <20230722190740.326190-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Sub-NUMA cluster feature on some Intel processors partitions
the CPUs that share an L3 cache into two or more sets. This plays
havoc with the Resource Director Technology (RDT) monitoring features.
Prior to this patch Intel has advised that SNC and RDT are incompatible.

Some of these CPU support an MSR that can partition the RMID
counters in the same way. This allows for monitoring features
to be used (with the caveat that memory accesses between different
SNC NUMA nodes may still not be counted accuratlely.

Note that this patch series improves resctrl reporting considerably
on systems with SNC enabled, but there will still be some anomalies
for processes accessing memory from other sub-NUMA nodes.

Signed-off-by: Tony Luck <tony.luck@intel.com>

Changes since v4:

Rebased to upstream v6.5

Addressed problems reported by Reinette in follow-up messages to
v4 posting:
   https://lore.kernel.org/r/20230722190740.326190-1-tony.luck@intel.com

Broke the patch series into a (hopefully) more logical progression.

First two patches are infrastructure changes to allow resctrl
domains to have scopes that are not defined by which CPUs share
a particular cache instance, and to allow resources to have different
scope for control an monitor features.

Patch 3 cleans up some loose ends from the first two patches by
adding a new variant of the rdt_domain structure with just monitoring
fields, and removing the monitor fields from the original rdt_domain
structure since it is now only used for control features.

Patch 4 adds "node" as a scope option.

Patch 5 adjusts all code paths that need to be aware of SNC mode.

Patch 6 detects SNC mode, modifies the MSR that adjusts interpretation
of physical RMID counters.

Patch 7 updates documentation.

Patch 8 does a partial update for the resctrl selftests.

Tony Luck (8):
  x86/resctrl: Prepare for new domain scope
  x86/resctrl: Prepare for different scope for control/monitor
    operations
  x86/resctrl: Split the rdt_domain structure
  x86/resctrl: Add node-scope to the options for feature scope
  x86/resctrl: Introduce snc_nodes_per_l3_cache
  x86/resctrl: Sub NUMA Cluster detection and enable
  x86/resctrl: Update documentation with Sub-NUMA cluster changes
  selftests/resctrl: Adjust effective L3 cache size when SNC enabled

 Documentation/arch/x86/resctrl.rst          |  25 +-
 include/linux/resctrl.h                     |  64 ++--
 arch/x86/include/asm/msr-index.h            |   1 +
 arch/x86/kernel/cpu/resctrl/internal.h      |  42 ++-
 tools/testing/selftests/resctrl/resctrl.h   |   1 +
 arch/x86/kernel/cpu/resctrl/core.c          | 321 ++++++++++++++++----
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c   |   6 +-
 arch/x86/kernel/cpu/resctrl/monitor.c       |  58 ++--
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c   |  15 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c      |  69 +++--
 tools/testing/selftests/resctrl/resctrlfs.c |  57 ++++
 11 files changed, 508 insertions(+), 151 deletions(-)


base-commit: 2dde18cd1d8fac735875f2e4987f11817cc0bc2c
-- 
2.41.0

