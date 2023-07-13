Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312D41F166
	for <patches@lists.linux.dev>; Thu, 13 Jul 2023 16:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689265957; x=1720801957;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QLPVmH8OKhS156FijxUUbjl5TQT038tMDl99vshP4rU=;
  b=S4tpj86MzZHMx4xSz24SgkUQqWLt1cpCVmBaMnLHwc+6unGvb6FoZhOl
   VksVNFxnMiXCAXZtuk4hj+oXkJo9Y1ziJt2dGtLve+bNkTaLmahP2E+05
   hdEfcqH8aOVOfMysJHz56X+8tq8xiO91SraCaX2DrPTYR+G1Bvwk1EHZH
   hNw+/cf589q9oZTmY+89ocyamxGpvRSvs5CKpsheCmnvULzXSfch6MK35
   SD1nLJEbX9UL2RKM2W+HPsNQVstf47lcopTkQncsCL6YfbtxM9O8F88Ox
   T+YNVp68ynfibhhZQSywXHD4UW1uGU7bY80Q0scYdyaDBAyIAYik/dlW9
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="362707671"
X-IronPort-AV: E=Sophos;i="6.01,203,1684825200"; 
   d="scan'208";a="362707671"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2023 09:32:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="722046397"
X-IronPort-AV: E=Sophos;i="6.01,203,1684825200"; 
   d="scan'208";a="722046397"
Received: from agluck-desk3.sc.intel.com ([172.25.222.74])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2023 09:32:23 -0700
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
Subject: [PATCH v3 8/8] selftests/resctrl: Adjust effective L3 cache size when SNC enabled
Date: Thu, 13 Jul 2023 09:32:07 -0700
Message-Id: <20230713163207.219710-9-tony.luck@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230713163207.219710-1-tony.luck@intel.com>
References: <20230713163207.219710-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sub-NUMA Cluster divides CPUs sharing an L3 cache into separate NUMA
nodes. Systems may support splitting into either two or four nodes.

When SNC mode is enabled the effective amount of L3 cache available
for allocation is divided by the number of nodes per L3.

Detect which SNC mode is active by comparing the number of CPUs
that share a cache with CPU0, with the number of CPUs on node0.

Reported-by: "Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>
Closes: https://lore.kernel.org/r/TYAPR01MB6330B9B17686EF426D2C3F308B25A@TYAPR01MB6330.jpnprd01.prod.outlook.com
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 tools/testing/selftests/resctrl/resctrl.h   |  1 +
 tools/testing/selftests/resctrl/resctrlfs.c | 57 +++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/tools/testing/selftests/resctrl/resctrl.h b/tools/testing/selftests/resctrl/resctrl.h
index 87e39456dee0..a8b43210b573 100644
--- a/tools/testing/selftests/resctrl/resctrl.h
+++ b/tools/testing/selftests/resctrl/resctrl.h
@@ -13,6 +13,7 @@
 #include <signal.h>
 #include <dirent.h>
 #include <stdbool.h>
+#include <ctype.h>
 #include <sys/stat.h>
 #include <sys/ioctl.h>
 #include <sys/mount.h>
diff --git a/tools/testing/selftests/resctrl/resctrlfs.c b/tools/testing/selftests/resctrl/resctrlfs.c
index fb00245dee92..79eecbf9f863 100644
--- a/tools/testing/selftests/resctrl/resctrlfs.c
+++ b/tools/testing/selftests/resctrl/resctrlfs.c
@@ -130,6 +130,61 @@ int get_resource_id(int cpu_no, int *resource_id)
 	return 0;
 }
 
+/*
+ * Count number of CPUs in a /sys bit map
+ */
+static int count_sys_bitmap_bits(char *name)
+{
+	FILE *fp = fopen(name, "r");
+	int count = 0, c;
+
+	if (!fp)
+		return 0;
+
+	while ((c = fgetc(fp)) != EOF) {
+		if (!isxdigit(c))
+			continue;
+		switch (c) {
+		case 'f':
+			count++;
+		case '7': case 'b': case 'd': case 'e':
+			count++;
+		case '3': case '5': case '6': case '9': case 'a': case 'c':
+			count++;
+		case '1': case '2': case '4': case '8':
+			count++;
+		}
+	}
+	fclose(fp);
+
+	return count;
+}
+
+/*
+ * Detect SNC by compating #CPUs in node0 with #CPUs sharing LLC with CPU0
+ * Try to get this right, even if a few CPUs are offline so that the number
+ * of CPUs in node0 is not exactly half or a quarter of the CPUs sharing the
+ * LLC of CPU0.
+ */
+static int snc_ways(void)
+{
+	int node_cpus, cache_cpus;
+
+	node_cpus = count_sys_bitmap_bits("/sys/devices/system/node/node0/cpumap");
+	cache_cpus = count_sys_bitmap_bits("/sys/devices/system/cpu/cpu0/cache/index3/shared_cpu_map");
+
+	if (!node_cpus || !cache_cpus) {
+		fprintf(stderr, "Warning could not determine Sub-NUMA Cluster mode\n");
+		return 1;
+	}
+
+	if (4 * node_cpus >= cache_cpus)
+		return 4;
+	else if (2 * node_cpus >= cache_cpus)
+		return 2;
+	return 1;
+}
+
 /*
  * get_cache_size - Get cache size for a specified CPU
  * @cpu_no:	CPU number
@@ -190,6 +245,8 @@ int get_cache_size(int cpu_no, char *cache_type, unsigned long *cache_size)
 			break;
 	}
 
+	if (cache_num == 3)
+		*cache_size /= snc_ways();
 	return 0;
 }
 
-- 
2.40.1

