Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9AF15F322
	for <patches@lists.linux.dev>; Wed,  5 Jun 2024 16:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717604082; cv=none; b=jOnWFAlJdevb3CdwW2dP4KJw+YlW32syQm0NPv6siIj9gAvNQhpwdbrfQVgzl/OkfjSBwW855/mc7byVHk3kari4ANQj6mSYRH3jlFkF5wyS2KJTSfUUSVz83s8SfVZTJ6Hu3qljKHNCXi3JMGfXsrtTQI987MHQ/Ywb5xnNu/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717604082; c=relaxed/simple;
	bh=/HprfpwiUePty9wSFJRY3CNQ9aV3syZxAQmyCvvz/FY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ru8vsAp/BiyyyITPKJOVimVo25uYQ0aUsqhOtwQuNxTmMWKVXCyKzchcKi/bBqz+ZPX/mON+dSCr3Uh814/YwIy+7wxd0DZeJltMRo8jjwXhCaeSY26SmF6CZu89/+g2rJYNhiGBsD0qVvoEeISiwEUnm845fJ+xRj5MhYc7ZOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uu0RyfSz; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uu0RyfSz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717604081; x=1749140081;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/HprfpwiUePty9wSFJRY3CNQ9aV3syZxAQmyCvvz/FY=;
  b=Uu0RyfSzawqe/rmicudvcDLELv/w4OhTVXrdhWzHTKoPtfbVah5HDKdG
   IALwox3Pj7MaVnFK32gfJse6DuGsIP94cs2pwOTciICBXq3ISoA8S9c7f
   lRx2/ZpEoay4IgTLt0JK1QeRYmQ7CKf2RrQlc0bKgJRUO9um1roiArYHP
   gvYz5O8gSh1rTtkro93p+AxTds+rk/cjU7+VcgJyEHt6urFMpsF3Yqtlj
   fiX7GH314hQDUA3FFFP5ouJen8mMiJhL4Ajdl49U2vlKMPR2u3CLb0WSE
   JgVsDnXNKqjc44dyMUHEVZa1tRk/KzMkoSiQk8i/O+qD9CGPec3YihN/z
   w==;
X-CSE-ConnectionGUID: 1aD59g2iTuSDl5Y5nHohUg==
X-CSE-MsgGUID: L0zlq7iKQKWm5Xm5zlB2MQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11094"; a="31772299"
X-IronPort-AV: E=Sophos;i="6.08,217,1712646000"; 
   d="scan'208";a="31772299"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2024 09:14:37 -0700
X-CSE-ConnectionGUID: Fnvn3mh+TyCMfVK9Cxg1kA==
X-CSE-MsgGUID: ankv2ZDmTkSaV5CBK2+oWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,217,1712646000"; 
   d="scan'208";a="42581902"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2024 09:14:37 -0700
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
Subject: [PATCH v2 2/3] x86/resctrl: Replace open code cacheinfo search in pseudo_lock_region_init()
Date: Wed,  5 Jun 2024 09:14:26 -0700
Message-ID: <20240605161427.312994-3-tony.luck@intel.com>
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

Use get_cpu_cacheinfo_level() instead of open coded search.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

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
-- 
2.45.0

