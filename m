Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33522AB3D
	for <patches@lists.linux.dev>; Tue,  3 Oct 2023 21:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696368656; x=1727904656;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wiY0eeufMNNk9jH1XIadte3o5RqKY1pTvxQYoyPVqyk=;
  b=eQUPmgshH1r3QPenFOIT9lhAkBc2WgFsJayMoB7Ono7te0iidC5dpUzs
   YvA1FvfVV4VBa3DhheKFMiTT6sepjSjaWGJeKJNfhs48JRmd9ODKOANGQ
   ABQ+OqFBhaM/I/5HiUalcxRA8qGa7qNUi6Nl0sa146deoW49Z7milmh0u
   IaT2xDlJCfaskw8ssUrS7xH+guU5qs78V8SXt5w5dYUdoYQM2j4WdhmvC
   tPflHblmCEocYABbzYezr66gqTnHoPcIWja1fr8UtoLv+ZYrQtSAkiOhC
   4ArpccN05dQ07Dbms07oNndVtX8Lwk9z4QiUYIuvwLlVwQRPzB4uplzFv
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10852"; a="1580367"
X-IronPort-AV: E=Sophos;i="6.03,198,1694761200"; 
   d="scan'208";a="1580367"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2023 14:30:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10852"; a="924801966"
X-IronPort-AV: E=Sophos;i="6.03,198,1694761200"; 
   d="scan'208";a="924801966"
Received: from agluck-desk3.sc.intel.com ([172.25.222.74])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2023 14:30:50 -0700
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
Subject: [PATCH v8 0/8] Add support for Sub-NUMA cluster (SNC) systems
Date: Tue,  3 Oct 2023 14:30:35 -0700
Message-ID: <20231003213043.13565-1-tony.luck@intel.com>
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
SNC NUMA nodes may still not be counted accurately.

Note that this patch series improves resctrl reporting considerably
on systems with SNC enabled, but there will still be some anomalies
for processes accessing memory from other sub-NUMA nodes.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---
Please ignore v7 posting. There was some glitch in how I created
the patches with "git format-patch" that meant part 0004 would not
apply.

Changes since v6:

* Fixed spelling of "accurately" in cover letter.

* Applied changes from Peter Newman's review
Link: https://lore.kernel.org/r/CALPaoChB5ryT96ZZBQb6+3=xO+A0uR-ToN0TWqUjLJ7bgi==Rg@mail.gmail.com
(and follow-on posts against other patches in the v6 series).

See comments in indivdual patches for specific details.

Added Peter's "Reviewed-by" to parts 4-7.q

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

