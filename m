Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485813D974
	for <patches@lists.linux.dev>; Tue,  3 Oct 2023 21:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696368661; x=1727904661;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jWw9kygA8K5rcCRCyTuFBc1LYN0qi8dbYF3tBjYmDGk=;
  b=mwQZ5HIGXveo5mro2IMXIG6yOMCVDtuALsLm7RMMWx2gB05Vf4wTcP0y
   qlmz9uyEW1zSkpgzvDxPZpt4DELHgmAZ90t/IzlcGeI//WiU7sQxjioNm
   fwDL/oWhlQnnDLJDfaFbeUcTlac+OmpepQRJhIXHLiCshzSkztT9rp5v5
   Na1o/sY2otEI8o4OMmcGCqGEBg2EYIacCI/AolRDjsUyRNYbnAX5xPqXb
   x35ndRJky49bslhCVwZyhnq+/cBI7TOX4qwjZS6v5WCVS7/Nk2ZKwxJYN
   tlrcmy9fvUW3vURTPtk/j1w+T/3/Qs4/zz+s0PGSweymFFKRq+YO//u7g
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10852"; a="1580458"
X-IronPort-AV: E=Sophos;i="6.03,198,1694761200"; 
   d="scan'208";a="1580458"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2023 14:30:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10852"; a="924802005"
X-IronPort-AV: E=Sophos;i="6.03,198,1694761200"; 
   d="scan'208";a="924802005"
Received: from agluck-desk3.sc.intel.com ([172.25.222.74])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2023 14:30:52 -0700
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
Subject: [PATCH v8 8/8] x86/resctrl: Update documentation with Sub-NUMA cluster changes
Date: Tue,  3 Oct 2023 14:30:43 -0700
Message-ID: <20231003213043.13565-9-tony.luck@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231003213043.13565-1-tony.luck@intel.com>
References: <20230928191350.205703-1-tony.luck@intel.com>
 <20231003213043.13565-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With Sub-NUMA Cluster mode enabled the scope of monitoring resources is
per-NODE instead of per-L3 cache. Suffixes of directories with "L3" in
their name refer to Sub-NUMA nodes instead of L3 cache ids.

Users should be aware that SNC mode also affects the amount of L3 cache
available for allocation within each SNC node.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

Changes since v5:

Added addtional details about challenges tracking tasks when SNC
mode is enabled.

---
diff --git a/Documentation/arch/x86/resctrl.rst b/Documentation/arch/x86/resctrl.rst
index cb05d90111b4..222c507089a5 100644
--- a/Documentation/arch/x86/resctrl.rst
+++ b/Documentation/arch/x86/resctrl.rst
@@ -345,9 +345,9 @@ When control is enabled all CTRL_MON groups will also contain:
 When monitoring is enabled all MON groups will also contain:
 
 "mon_data":
-	This contains a set of files organized by L3 domain and by
-	RDT event. E.g. on a system with two L3 domains there will
-	be subdirectories "mon_L3_00" and "mon_L3_01".	Each of these
+	This contains a set of files organized by L3 domain or by NUMA
+	node (depending on whether Sub-NUMA Cluster (SNC) mode is disabled
+	or enabled respectively) and by RDT event.  Each of these
 	directories have one file per event (e.g. "llc_occupancy",
 	"mbm_total_bytes", and "mbm_local_bytes"). In a MON group these
 	files provide a read out of the current value of the event for
@@ -452,6 +452,23 @@ and 0xA are not.  On a system with a 20-bit mask each bit represents 5%
 of the capacity of the cache. You could partition the cache into four
 equal parts with masks: 0x1f, 0x3e0, 0x7c00, 0xf8000.
 
+Notes on Sub-NUMA Cluster mode
+==============================
+When SNC mode is enabled Linux may load balance tasks between Sub-NUMA
+nodes much more readily than between regular NUMA nodes since the CPUs
+on Sub-NUMA nodes share the same L3 cache and the system may report
+the NUMA distance between Sub-NUMA nodes with a lower value than used
+for regular NUMA nodes.  Users who do not bind tasks to the CPUs of a
+specific Sub-NUMA node must read the "llc_occupancy", "mbm_total_bytes",
+and "mbm_local_bytes" for all Sub-NUMA nodes where the tasks may execute
+to get the full view of traffic for which the tasks were the source.
+
+The cache allocation feature still provides the same number of
+bits in a mask to control allocation into the L3 cache. But each
+of those ways has its capacity reduced because the cache is divided
+between the SNC nodes. The values reported in the resctrl
+"size" files are adjusted accordingly.
+
 Memory bandwidth Allocation and monitoring
 ==========================================
 
