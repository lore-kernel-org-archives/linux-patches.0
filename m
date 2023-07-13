Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2694F1F197
	for <patches@lists.linux.dev>; Thu, 13 Jul 2023 16:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689265951; x=1720801951;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cXZtGgbLWRfM3llFgBerTG/qiILJWd0SfRKH1JDQjUE=;
  b=Wb+4pNuLn1Ud0jHvYCzYHX3KLUO+E/oQLvPSzgN81tF56sgyOXyEn/4P
   xS2AzHwMvLZUdAX2pf9D/EQQgB5TtQy2KV8A9IOjHrgnpeRMJXb3Umheb
   luyZBeo/URG4kYbchxTU++vUeFV5olpQoYKrGPS0FwU9rF2Xk/vAd56Mo
   jj0klxUjx7Kr/aSVfpPwjutsVaV5tyz8hRnvNoIZMDgxlxdFNngzcwTSH
   VRLho/o53f0ASh7/q5V0RQi97bdV2cxb8hwNggLX3TEo+kOQMJ4VfTLMN
   /LWj8n0Zc4xXgsnHJbgNdGfIHhHXTNPp0Ol5tkbgtKRLGNQoYMie5CJsm
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="362707572"
X-IronPort-AV: E=Sophos;i="6.01,203,1684825200"; 
   d="scan'208";a="362707572"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2023 09:32:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="722046367"
X-IronPort-AV: E=Sophos;i="6.01,203,1684825200"; 
   d="scan'208";a="722046367"
Received: from agluck-desk3.sc.intel.com ([172.25.222.74])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2023 09:32:21 -0700
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
Subject: [PATCH v3 0/8] x86/resctrl: Add support for Sub-NUMA cluster (SNC) systems
Date: Thu, 13 Jul 2023 09:31:59 -0700
Message-Id: <20230713163207.219710-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There isn't a simple hardware enumeration to indicate to software that
a system is running with Sub-NUMA Clustering enabled.

Compare the number of NUMA nodes with the number of L3 caches to calculate
the number of Sub-NUMA nodes per L3 cache.

When Sub-NUMA clustering mode is enabled in BIOS setup, the RMID counters
are distributed equally between the SNC nodes within each socket.

E.g. if there are 400 RMID counters, and the system is configured with
two SNC nodes per socket, then RMID counter 0..199 are used on SNC node
0 on the socket, and RMID counter 200..399 on SNC node 1.

A model specific MSR (0xca0) can change the configuration of the RMIDs
when SNC mode is enabled.

The MSR controls the interpretation of the RMID field in the
IA32_PQR_ASSOC MSR so that the appropriate hardware counters within the
SNC node are updated. If reconfigured from default, RMIDs are divided
evenly across clusters.

Also initialize a per-cpu RMID offset value. Use this to calculate the
value to write to the IA32_QM_EVTSEL MSR when reading RMID event values.

N.B. this works well for well-behaved NUMA applications that access
memory predominantly from the local memory node. For applications that
access memory across multiple nodes it may be necessary for the user
to read counters for all SNC nodes on a socket and add the values to
get the actual LLC occupancy or memory bandwidth. Perhaps this isn't
all that different from applications that span across multiple sockets
in a legacy system.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

Changes since v2:

* Rebased to v6.5-rc1

Peter Newman:	Found that I'd reversed the actions writing to the new
		MSR to enable/disable RMID remapping for SNC mode.
* Fixed.

Peter Newman:	Provided Reviewed-by: and Tested-by: tags

* Included in this series.

Randy Dunlap:	Reported a run-on sentence in the documentation.

* Broke the sentence into two as suggested.

Shaopeng Tan:	Reported that the CMT resctrl self-test failed

* Added extra patch to the series to make the resctrl test detect when SNC
  mode is enabled and adjust effective cache size.

* I also patched the rdtgroup_cbm_to_size() function to adjust the cache
  size reported in the "size" files in resctrl groups when SNC is active.

Shaopeng Tan:	Noted the for_each_capable_rdt_resource() macro is no longer used.

* Deleted defintion of this macro.

Tony Luck (8):
  x86/resctrl: Refactor in preparation for node-scoped resources
  x86/resctrl: Remove hard code of RDT_RESOURCE_L3 in monitor.c
  x86/resctrl: Add a new node-scoped resource to rdt_resources_all[]
  x86/resctrl: Add code to setup monitoring at L3 or NODE scope.
  x86/resctrl: Add package scoped resource
  x86/resctrl: Update documentation with Sub-NUMA cluster changes
  x86/resctrl: Determine if Sub-NUMA Cluster is enabled and initialize.
  selftests/resctrl: Adjust effective L3 cache size when SNC enabled

 Documentation/arch/x86/resctrl.rst          |  10 +-
 include/linux/resctrl.h                     |   5 +-
 arch/x86/include/asm/resctrl.h              |   2 +
 arch/x86/kernel/cpu/resctrl/internal.h      |  20 ++-
 tools/testing/selftests/resctrl/resctrl.h   |   1 +
 arch/x86/kernel/cpu/resctrl/core.c          | 154 ++++++++++++++++++--
 arch/x86/kernel/cpu/resctrl/monitor.c       |  24 +--
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c   |   2 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c      |   6 +-
 tools/testing/selftests/resctrl/resctrlfs.c |  57 ++++++++
 10 files changed, 248 insertions(+), 33 deletions(-)


base-commit: 06c2afb862f9da8dc5efa4b6076a0e48c3fbaaa5
-- 
2.40.1

