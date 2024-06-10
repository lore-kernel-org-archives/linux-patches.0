Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7C5139B
	for <patches@lists.linux.dev>; Mon, 10 Jun 2024 00:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717979979; cv=none; b=MOpO0ugIibs8MVNzJboa8dmeiCQtB4oHokJJVlcR1NWndqs7zNvzX4Q0SuafnQwK1ioaKTwHl/H4vk0sbSl1BA2E7MkPuzflXI1U29SgliTlqcliCsVNi3SZEhm+TpONNgEGArSlSEk8EQ8tQ69UsbdPx2yZO4KzkyRlgDHK4AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717979979; c=relaxed/simple;
	bh=6tR3TRLrX53cLsdGkoplDT3xXp3OFcHxLciQEPKbwNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZiAnSgmcuXfcpj7BP8JYYWb/kuxRw8Af1kOOjIXtU7UJJcDzKwLgjoh4y9SAPJEUyAlOR5mkPU+34rnJM/zHqaLc5XDE3ZFvxM8xa3ZpOxIrYkDl5dQKUfbxrj7D6qVrfOV3LTIFcvO22k7aSXsYypMlJAkyKseYGK+ZISRFIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TB46BOFD; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TB46BOFD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717979978; x=1749515978;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6tR3TRLrX53cLsdGkoplDT3xXp3OFcHxLciQEPKbwNo=;
  b=TB46BOFD2KOYmJNctdHfV3Tdr/I57uFmclY13XbPLBjsDZsYRlDK3/Ii
   B7WS2pQktoXRUV5dK/rp6NPdt7y9OD5pa5NYREC7SRAzCP87jlmMyyQ0Y
   LabFIEYjOKlugNl2n0UOtS0F1nHVouHja7TC/4gvNrHBd+jhJIp2pG24N
   tq6CgHy8m+QmN8/TbWhsjwWGl2ImZodvfYdAXQcXY2Q/oVUpzpoh6rkjR
   9A6ZpMiL5O4pVN8Pe5iWeE6HcHiBQzhl4E/TCxtWZkbWmWXmby/uSHzmX
   GyqeWAPT6lNR+viY5WJsbOGE0IWEILWm8OlHxTP81xgje1dQjme2zpW4G
   A==;
X-CSE-ConnectionGUID: /tdg9G2ATyaoSSBEUvaKvQ==
X-CSE-MsgGUID: GCi5tdkOQOWMZL3XS30UJg==
X-IronPort-AV: E=McAfee;i="6600,9927,11098"; a="37154979"
X-IronPort-AV: E=Sophos;i="6.08,226,1712646000"; 
   d="scan'208";a="37154979"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2024 17:39:36 -0700
X-CSE-ConnectionGUID: Irl6ZMMHRFeRp55P1SRhJw==
X-CSE-MsgGUID: tdOPD4pmSFatYaNa0G7+pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,226,1712646000"; 
   d="scan'208";a="38829884"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2024 17:39:36 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 3/4] cacheinfo: Add function to get cacheinfo for a given (cpu, cachelevel)
Date: Sun,  9 Jun 2024 17:39:26 -0700
Message-ID: <20240610003927.341707-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240610003927.341707-1-tony.luck@intel.com>
References: <20240610003927.341707-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Resctrl code open codes a search for information about a given cache
level in a couple of places (and more are on the way).

Provide a new inline function get_cpu_cacheinfo_level() in
<linux/cacheinfo.h> to do the search and return a pointer to
the cacheinfo structure.

Add lockdep_assert_cpus_held() to enforce the comment that cpuhp
lock must be held.

Simplify the existing get_cpu_cacheinfo_id() by using this new
function to do the search.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 include/linux/cacheinfo.h | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/include/linux/cacheinfo.h b/include/linux/cacheinfo.h
index 2cb15fe4fe12..3dde175f4108 100644
--- a/include/linux/cacheinfo.h
+++ b/include/linux/cacheinfo.h
@@ -3,6 +3,7 @@
 #define _LINUX_CACHEINFO_H
 
 #include <linux/bitops.h>
+#include <linux/cpuhplock.h>
 #include <linux/cpumask.h>
 #include <linux/smp.h>
 
@@ -113,23 +114,37 @@ int acpi_get_cache_info(unsigned int cpu,
 const struct attribute_group *cache_get_priv_group(struct cacheinfo *this_leaf);
 
 /*
- * Get the id of the cache associated with @cpu at level @level.
+ * Get the cacheinfo structure for the cache associated with @cpu at
+ * level @level.
  * cpuhp lock must be held.
  */
-static inline int get_cpu_cacheinfo_id(int cpu, int level)
+static inline struct cacheinfo *get_cpu_cacheinfo_level(int cpu, int level)
 {
 	struct cpu_cacheinfo *ci = get_cpu_cacheinfo(cpu);
 	int i;
 
+	lockdep_assert_cpus_held();
+
 	for (i = 0; i < ci->num_leaves; i++) {
 		if (ci->info_list[i].level == level) {
 			if (ci->info_list[i].attributes & CACHE_ID)
-				return ci->info_list[i].id;
-			return -1;
+				return &ci->info_list[i];
+			return NULL;
 		}
 	}
 
-	return -1;
+	return NULL;
+}
+
+/*
+ * Get the id of the cache associated with @cpu at level @level.
+ * cpuhp lock must be held.
+ */
+static inline int get_cpu_cacheinfo_id(int cpu, int level)
+{
+	struct cacheinfo *ci = get_cpu_cacheinfo_level(cpu, level);
+
+	return ci ? ci->id : -1;
 }
 
 #ifdef CONFIG_ARM64
-- 
2.45.0

