Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF1C1852
	for <patches@lists.linux.dev>; Mon, 10 Jun 2024 00:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717979980; cv=none; b=SPRmahg3COdPxqGwYUAKz9sXgSTc9I7zCBn0x30gRkJAGOytd9Cx6D2ZZ2ppHuQzghZYJVEQak+HwdMcnCjKCvnNbUYt7vO02DEKTXplxl4vOf7kRw31ZnwEJa33KCOUuX4TEgYDV7VQ7RC5/JEFCdOkVZ189Xg3WdsvpUruWI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717979980; c=relaxed/simple;
	bh=RmlyFZFXIPl3nE3NosJA82cQlJCREl1lNzarMkr1BuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDcuUL/JVP33fQlcB+uIx1qNW/3nPYAG8miiFl8qeCA7+7IVrI7Tx9us6ORqjlsRVsJUE2rZGHbf0CBvDY3ab0Ew8o6fR2QJNnaKmiDenscXaZa9BNGn7gET/7/Mio1COneK6RgUT83Yu+efXBzpOux4BiEe1Ho+OoRRWcgnRQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nlHU+imG; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nlHU+imG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717979978; x=1749515978;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RmlyFZFXIPl3nE3NosJA82cQlJCREl1lNzarMkr1BuQ=;
  b=nlHU+imGRdR2MZ15/V1Pc1HwzmcDDJCHikw1y9gWXfZq0qzp85o+e1lW
   c4/xHzMUEA4MWiVn6ztTlwr/Yt52RHl99FqX8lx9fhEG7D5jaIjRaFZ/l
   JztjkzvzeKGvsPEKB0fgLQdUFAzdwtFUfhcXZawqAyQ+lMuS0wftQUolS
   ZbFRZQE2pCTjcYXJG4Q+rifQhSTRLE1+EIiZBaeac3WTiamgMQ6huS/CH
   PH2eytDC5nBJlhUIekMv624kvmIEygGJR/i0d9buazzZaUXg/RVUXQ6CL
   GVoqySE+Fr3H1ew9YikWmunvpHVjvew/TvDa3mfjdwZ4NFqf3KePdr+I0
   A==;
X-CSE-ConnectionGUID: xpQoCznqT+mSZcjDLYszEQ==
X-CSE-MsgGUID: BtKQcIyxRaeVyOkgPiO0vQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11098"; a="37154987"
X-IronPort-AV: E=Sophos;i="6.08,226,1712646000"; 
   d="scan'208";a="37154987"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2024 17:39:36 -0700
X-CSE-ConnectionGUID: 7h+fxINfQfe2DNAQAI8j7Q==
X-CSE-MsgGUID: XBNWwJQeQFCgJi5+7zGlvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,226,1712646000"; 
   d="scan'208";a="38829888"
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
Subject: [PATCH v4 4/4] x86/resctrl: Replace open code cacheinfo searches
Date: Sun,  9 Jun 2024 17:39:27 -0700
Message-ID: <20240610003927.341707-5-tony.luck@intel.com>
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

pseudo_lock_region_init() and rdtgroup_cbm_to_size() open code
a search for details of a particular cache level.

Replace with get_cpu_cacheinfo_level()

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c | 17 ++++++-----------
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 14 +++++---------
 2 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
index aacf236dfe3b..1bbfd3c1e300 100644
--- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
+++ b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
@@ -292,9 +292,8 @@ static void pseudo_lock_region_clear(struct pseudo_lock_region *plr)
  */
 static int pseudo_lock_region_init(struct pseudo_lock_region *plr)
 {
-	struct cpu_cacheinfo *ci;
+	struct cacheinfo *ci;
 	int ret;
-	int i;
 
 	/* Pick the first cpu we find that is associated with the cache. */
 	plr->cpu = cpumask_first(&plr->d->cpu_mask);
@@ -306,15 +305,11 @@ static int pseudo_lock_region_init(struct pseudo_lock_region *plr)
 		goto out_region;
 	}
 
-	ci = get_cpu_cacheinfo(plr->cpu);
-
-	plr->size = rdtgroup_cbm_to_size(plr->s->res, plr->d, plr->cbm);
-
-	for (i = 0; i < ci->num_leaves; i++) {
-		if (ci->info_list[i].level == plr->s->res->cache_level) {
-			plr->line_size = ci->info_list[i].coherency_line_size;
-			return 0;
-		}
+	ci = get_cpu_cacheinfo_level(plr->cpu, plr->s->res->cache_level);
+	if (ci) {
+		plr->line_size = ci->coherency_line_size;
+		plr->size = rdtgroup_cbm_to_size(plr->s->res, plr->d, plr->cbm);
+		return 0;
 	}
 
 	ret = -1;
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 02f213f1c51c..cb68a121dabb 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -1450,18 +1450,14 @@ static ssize_t rdtgroup_mode_write(struct kernfs_open_file *of,
 unsigned int rdtgroup_cbm_to_size(struct rdt_resource *r,
 				  struct rdt_domain *d, unsigned long cbm)
 {
-	struct cpu_cacheinfo *ci;
 	unsigned int size = 0;
-	int num_b, i;
+	struct cacheinfo *ci;
+	int num_b;
 
 	num_b = bitmap_weight(&cbm, r->cache.cbm_len);
-	ci = get_cpu_cacheinfo(cpumask_any(&d->cpu_mask));
-	for (i = 0; i < ci->num_leaves; i++) {
-		if (ci->info_list[i].level == r->cache_level) {
-			size = ci->info_list[i].size / r->cache.cbm_len * num_b;
-			break;
-		}
-	}
+	ci = get_cpu_cacheinfo_level(cpumask_any(&d->cpu_mask), r->cache_level);
+	if (ci)
+		size = ci->size / r->cache.cbm_len * num_b;
 
 	return size;
 }
-- 
2.45.0

