Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFC617DE1D
	for <patches@lists.linux.dev>; Fri, 31 May 2024 19:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717185458; cv=none; b=mL3vM2mbjZSyIWlSfoZgOKrg4Mo+POGoEOwyBu8ODFaNSdVxV37PwQUi2f97C//bqNnZeiNLrjdxGHX6/gTYaXSoCHNrhiELpEweMGHZYjf7sdUvkb7MCTY1vnxCaYYydhU0Vp983MFqQI7RNtAACQxz+/lo4gJ84FF+u1EKMaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717185458; c=relaxed/simple;
	bh=waO47AVKQXebwki+vP6AIbp5ruc9+vs3ozpJycT6ARA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9pl5SBc6JO0BFeBXveDE87KbETbomPMk90SF+iJgH8xKwKfVxQ5VzMPnQys1t8/wWhv70+inArICNoZD4alJkyG/aJmvUCaBbl38zQfA3jwQtX50EyaMdsUVx8u+V94l9J3REBo7FGszlVVJQvXizzIvEFRpdTpjN8JKvQGcKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SdsRnDqn; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SdsRnDqn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717185457; x=1748721457;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=waO47AVKQXebwki+vP6AIbp5ruc9+vs3ozpJycT6ARA=;
  b=SdsRnDqngIY/gjuwLjQHTaAEYGSlrWwhYxK27cycQkDKi8AIMzwQDw0u
   92Rhd189cGUk3zV4GeSX1rsWyefdy+6JpDBkuO8uA4ebzBJvDgnUjAEAN
   EenGxak5rZZ4R+kktrJHsy4GYImlEvdjgidUafqm/9MwJjCfDZfrxL3d2
   JmnSXVyOgCBo43huKKzmnt5dRnFQ/wcwCcQofQnOJqDdlHIxasY6a8AhQ
   6eEQHjbNuIa4Vr993F0upzOOqQdseUBTaL59knz0kDaOBpN/q1aYzgrMB
   PqlqBuGbvN1kHKCDtqNrvvEJAXVNNj4pla55m5xxKwY9UixhOhtyDTYEZ
   w==;
X-CSE-ConnectionGUID: j7rAyElbRPCZlKFFdeqYnA==
X-CSE-MsgGUID: 1SZwZvkOQnm7FiS7qDPScg==
X-IronPort-AV: E=McAfee;i="6600,9927,11089"; a="13501158"
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="13501158"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 12:57:33 -0700
X-CSE-ConnectionGUID: /+Q61v0/Q8CNZEn5CRgApA==
X-CSE-MsgGUID: ArwkRCBhT3WOD32XSQ+O9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="59438876"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 12:57:32 -0700
From: Tony Luck <tony.luck@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
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
Subject: [PATCH 3/3] x86/resctrl: Replace open code cacheinfo search in rdtgroup_cbm_to_size()
Date: Fri, 31 May 2024 12:57:20 -0700
Message-ID: <20240531195720.232561-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240531195720.232561-1-tony.luck@intel.com>
References: <20240531195720.232561-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use get_cpu_cacheinfo_level() instead of open coded search.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 02f213f1c51c..4a5ab0f6a412 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -1450,18 +1450,14 @@ static ssize_t rdtgroup_mode_write(struct kernfs_open_file *of,
 unsigned int rdtgroup_cbm_to_size(struct rdt_resource *r,
 				  struct rdt_domain *d, unsigned long cbm)
 {
-	struct cpu_cacheinfo *ci;
+	struct cacheinfo *ci;
 	unsigned int size = 0;
-	int num_b, i;
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

