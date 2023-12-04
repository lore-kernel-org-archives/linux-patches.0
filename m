Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB4C2EAFA
	for <patches@lists.linux.dev>; Mon,  4 Dec 2023 18:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AV91oxXG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701716049; x=1733252049;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MmH/laKEGnp2y/uGerX+E7RxvQ9TncUwvCwOiPDkDoQ=;
  b=AV91oxXG/YyqSUSjvYJEY3zxX4jpTk5fcet9bSjeNkSH0GQ4bCZqbaga
   EYBCKUvhzmkCgqARXa85cdE8XGYPigWDKGF/byVDVDcVe13eAG7wrg+d5
   I9c/7GE6dnHmXPL/oFpKldgJ3L9xUIu4j0X0RAqUYZcacQUeZNT7F9u3Q
   zUFry8l3jI6ZpHL9skqtZdumL9ufeNFqNvrcn6uJqauJ7jFjYVzap4rIU
   DMeONqeSMbDygqJqiMtUmiSHHQq0LOn9DcYHZ8ol/CilP/LnhhnpE+McV
   z4imAEaaY3B+scUPgrgdNeVWiRE2Di5JLM9TWfCXo8fhaE1Q5CC5kTMg6
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="838439"
X-IronPort-AV: E=Sophos;i="6.04,250,1695711600"; 
   d="scan'208";a="838439"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 10:54:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="836687184"
X-IronPort-AV: E=Sophos;i="6.04,250,1695711600"; 
   d="scan'208";a="836687184"
Received: from agluck-desk3.sc.intel.com ([172.25.222.74])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 10:54:07 -0800
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
Subject: [PATCH v13 0/8] Add support for Sub-NUMA cluster (SNC) systems
Date: Mon,  4 Dec 2023 10:53:49 -0800
Message-ID: <20231204185357.120501-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231130003418.89964-1-tony.luck@intel.com>
References: <20231130003418.89964-1-tony.luck@intel.com>
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

Changes since v12:

All:
	Reinette - put commit tags in right order for TIP (Tested-by before
	Reviewed-by)

Patch 7:
	Fam Zheng - Check for -1 return from get_cpu_cacheinfo_id() and
	increase size of bitmap tracking # of L3 instances.
	Reinette - Add extra sanity checks. Note that this patch has
	some additional tweaks beyond the e-mail discussion.
		1) "3" is a valid return in addition to 1, 2, 4
		2) Added a warning if the sanity checks fail that
		prints number of CPU nodes and number of L3 cache
		instances that were found.

Patch 8:
	Babu - Fix grammar with an additional comma.


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
 arch/x86/kernel/cpu/resctrl/core.c        | 433 +++++++++++++++++-----
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c |  58 +--
 arch/x86/kernel/cpu/resctrl/monitor.c     |  68 ++--
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c |  26 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 149 ++++----
 9 files changed, 629 insertions(+), 282 deletions(-)


base-commit: 2cc14f52aeb78ce3f29677c2de1f06c0e91471ab
-- 
2.41.0

