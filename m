Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD27B198A17
	for <patches@lists.linux.dev>; Thu,  6 Jun 2024 16:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717692058; cv=none; b=D6BKkZQncwxHjnJw5h0s/d4RuTAOk2DVsCLN4It1gJNzSjDYlF7P4tkVNss0WjsVKSWOWfoQ1TWLRga6FUnJW7BFNncrD6OVwCmDB/s6Z9KcCQ1MSLXHGsdj20BOhsklnBlwvj00EtHKtdWLJwA9h4wg4aIGI1mYXtZGJK8U4TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717692058; c=relaxed/simple;
	bh=6rrX6toUJNh2iWuLJcY/kYBZd3jveCiUOS6TDW2IT/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miITMioZQ3iS45YwNSyU+zjqPX8SQDn5amPnsI9nv1H3uVMrGBKPK+XIsZdPmzuVlwPRzh7PG0gmlebJyJUBuGdkG9ytw+LJmFVNcQzOza+yX2BmBohrcNrsPf8NjCrA6lXswLxT0iwijUnDBk15TAVROHEQrAhANqUvBLLC01g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EhdGlMBt; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EhdGlMBt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717692057; x=1749228057;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6rrX6toUJNh2iWuLJcY/kYBZd3jveCiUOS6TDW2IT/U=;
  b=EhdGlMBtF6RqPs8HvE8wxrEqL7bSfOrTfqh/ayJVEnhkqzXihEXPw0/g
   OKlOR7801a0l00S1Ql3cMWJ6NS50XShVJHQ6XbvnAJm3eSzo3OEiIqARr
   5PTlhNGqzW4lhqF40EOlLa4R2tE2P6WXa1DZLeKOZ7v31hGdRM6LJheS0
   b0DE3w8fEAN6nHC+rH1TWky9ehbbqHjVU6LrzBrAz54OfpEVsVTJXQFw/
   g5biS4uuC45I8DTWHxxaIJfZ+ynTPDQh9LC68qBiZRmyhgvgAT/j0C7/D
   7ltjmFfadBmV5ywFfIT6DK0QgNEYYxbSfD0bPKGXK1+DP0T2WBy9o8ZN8
   A==;
X-CSE-ConnectionGUID: sezoXqxdTQe0eVpGoJPxTg==
X-CSE-MsgGUID: 8tIJFxv8RoSej+hOcU9uAQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11095"; a="14214919"
X-IronPort-AV: E=Sophos;i="6.08,219,1712646000"; 
   d="scan'208";a="14214919"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 09:40:55 -0700
X-CSE-ConnectionGUID: NM4/4XLLQZGPgwO9mU2GDA==
X-CSE-MsgGUID: XLhw5Y4XRjK/DziMCoFu9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,219,1712646000"; 
   d="scan'208";a="38033091"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 09:40:54 -0700
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
Subject: [PATCH v3 1/2] cacheinfo: Add function to get cacheinfo for a given (cpu, cachelevel)
Date: Thu,  6 Jun 2024 09:40:46 -0700
Message-ID: <20240606164047.318378-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240606164047.318378-1-tony.luck@intel.com>
References: <20240606164047.318378-1-tony.luck@intel.com>
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
index 2cb15fe4fe12..530a16980aea 100644
--- a/include/linux/cacheinfo.h
+++ b/include/linux/cacheinfo.h
@@ -3,6 +3,7 @@
 #define _LINUX_CACHEINFO_H
 
 #include <linux/bitops.h>
+#include <linux/cpu.h>
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

