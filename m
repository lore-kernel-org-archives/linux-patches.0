Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF68101C2
	for <patches@lists.linux.dev>; Tue,  3 Oct 2023 16:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696349292; x=1727885292;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GxY6djkdXGLXDWuW+6GGDFodlat750WRBGDESi40hYk=;
  b=n7bBl5G5G8jnX1RINBJGtyPm06J+MJL0OBv39nasAcbBhBcWQqzgOgbJ
   R/3qgjFZEaJuxp4BUKHHwUH96tL9zqLqE5M/3PssDuq8FWLz0MdQ1rV0n
   /5lSizQcczEKVaWrpS31WbUhz9E5PuYeELf3kOL33KjxdzPq5isWyey05
   Fcs7dzCYZ8bMZZNA/7jmHNDylKEpKlxk5UnijoFNwEKU6nChfY+t5sEOo
   KAFMMDoxc/cvkDE+5QLabokpCrf6lMigO4H3B6FiEpJvjmSo/XgbHd0NB
   KKZ0WJ3+i7Lx0P+SAlLKVMtHuXkicJblkko2/Lhh79tHbY21AQYWn74Bo
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10852"; a="447083210"
X-IronPort-AV: E=Sophos;i="6.03,197,1694761200"; 
   d="scan'208";a="447083210"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2023 09:08:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10852"; a="998098083"
X-IronPort-AV: E=Sophos;i="6.03,197,1694761200"; 
   d="scan'208";a="998098083"
Received: from agluck-desk3.sc.intel.com ([172.25.222.74])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2023 09:08:09 -0700
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
Subject: [PATCH v7 0/8] Add support for Sub-NUMA cluster (SNC) systems
Date: Tue,  3 Oct 2023 09:07:51 -0700
Message-ID: <20231003160800.8601-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230928191350.205703-1-tony.luck@intel.com>
References: <20230928191350.205703-1-tony.luck@intel.com>
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

 Documentation/arch/x86/resctrl.rst        |  23 +-
 include/linux/resctrl.h                   |  85 +++--
 arch/x86/include/asm/msr-index.h          |   1 +
 arch/x86/kernel/cpu/resctrl/internal.h    |  66 ++--
 arch/x86/kernel/cpu/resctrl/core.c        | 400 +++++++++++++++++-----
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c |  58 ++--
 arch/x86/kernel/cpu/resctrl/monitor.c     |  58 ++--
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c |  14 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 132 +++----
 9 files changed, 591 insertions(+), 246 deletions(-)


base-commit: 6465e260f48790807eef06b583b38ca9789b6072
-- 
2.41.0

