Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E9515A84D
	for <patches@lists.linux.dev>; Wed,  5 Jun 2024 16:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717604081; cv=none; b=AmN8abYg46jzBk3pstmUEJR2VJhAcWIfZt/JJxUlQTFh4G+j3FrUL5s8OWGaD7UpbYV7qvVPW1s6cXf4k3rSdroqWokB6LU4wkaqkPfjFuCz26udFc+amhW6cSiDU582y0XmdaO2nQgk5Azh0UuNW3XYayrR/cENqiIUmNPJ2Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717604081; c=relaxed/simple;
	bh=yanHfd6jlJmGT0zmUR9ubQ+HVlgEg5ygOb5UbWWoM5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dy0pJOf9RgndyZ0vtwTrhjAfSh+nuXMRcbEYEhGzECYvvDah3DwqIh2KZ5zWEQ3S6jNEEGQA2j1DrFhBOumIGUEXZsrSMgqm+u220QYoamHaRSMWlPn4ZZgvDtOX70wrAi5SQul9udVOGQiSFBrNP8SN9mPdlqBxcSW4cgwQ77o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fMci9Pmq; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fMci9Pmq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717604080; x=1749140080;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yanHfd6jlJmGT0zmUR9ubQ+HVlgEg5ygOb5UbWWoM5o=;
  b=fMci9Pmq9NgdOGi2PQfy3TXR9PEnKWhSkPyh2a1ilk6N40uH4WnoXSJM
   ZI2IlIvbLRw0WD0AddqDGld4jFe62W8GA2Xx3DdGqYYAWDPlxMVrg86Ly
   R/ffwCEo4aOYzex7P0L4TykWjdNMQcdYwDThalCn1X0TxGYqNNe+oEFic
   oXUfco6QSRZG7rO2lxKEnnvHtqia0g9IDINjSDkVO3AtGPhQPsCvYsUBk
   LePIUQu8OmuK7Slnw93LSaDyT1sjoWSocvAO8/7M5pbeiFCghSYz636Oa
   SXsTlrawRuVLUg/eDptJGQR9QG89vp2/Qh4U1ppv26tscacD3sgeQwn1f
   w==;
X-CSE-ConnectionGUID: BtV70waCSLuqBnGW46UprQ==
X-CSE-MsgGUID: +yH8m9VFQt2/bP4NoplbxA==
X-IronPort-AV: E=McAfee;i="6600,9927,11094"; a="31772290"
X-IronPort-AV: E=Sophos;i="6.08,217,1712646000"; 
   d="scan'208";a="31772290"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2024 09:14:37 -0700
X-CSE-ConnectionGUID: AQuyBpvDQACNsZSEi0KIFw==
X-CSE-MsgGUID: YmYw7eXRSMuVIMIaAiQw7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,217,1712646000"; 
   d="scan'208";a="42581898"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2024 09:14:36 -0700
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
Subject: [PATCH v2 1/3] cacheinfo: Add function to get cacheinfo for a given (cpu, cachelevel)
Date: Wed,  5 Jun 2024 09:14:25 -0700
Message-ID: <20240605161427.312994-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240605161427.312994-1-tony.luck@intel.com>
References: <20240605161427.312994-1-tony.luck@intel.com>
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

Simplify the existing get_cpu_cacheinfo_id() by using this new
function to do the search.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 include/linux/cacheinfo.h | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/include/linux/cacheinfo.h b/include/linux/cacheinfo.h
index 2cb15fe4fe12..b4d99052d186 100644
--- a/include/linux/cacheinfo.h
+++ b/include/linux/cacheinfo.h
@@ -113,10 +113,11 @@ int acpi_get_cache_info(unsigned int cpu,
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
@@ -124,12 +125,23 @@ static inline int get_cpu_cacheinfo_id(int cpu, int level)
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

