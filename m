Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA51188CCB
	for <patches@lists.linux.dev>; Wed,  5 Jun 2024 16:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717604083; cv=none; b=prtnDbHRqUQiZ7W+H2+tBpDBjRSNkaMPHf8+3HMIXV2pVI4EbXuTukNJ6rWdsoo84MOJbgkeLfxVNvl5Xkz6O8vs1M5HBq4U6j0z3kAyAbtSzqrtd58/4qrOsinknJvqgRCnDyf0OO5kop77e8BsE0m91fNFPeYR+EFmO8CCotw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717604083; c=relaxed/simple;
	bh=mtXhJIqFcxEurjVvwCm6Vo/pYjEoRRPxXTYeDGZw23k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TlEubt/6QJOve8RUYaqo1TtESYyjj2V5ns1kVt3rRN/5WHfHb6ZpEXbK8icYm6xvoKsMVOm03QsQsX+Y16nBAxSLVH/eeNFBasZ7ubTlhrsNE9xOtl8xcThxyZHvzuhdTpmCrbntkuyvcIVoji3sqe3e7dbSI2vUC3eIEKnJzHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HJYvTF4y; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HJYvTF4y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717604082; x=1749140082;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mtXhJIqFcxEurjVvwCm6Vo/pYjEoRRPxXTYeDGZw23k=;
  b=HJYvTF4ylciUTZOgDW8gaWQF9zQ1NyssNrvWIIbarR1KAs4/CX4JplAy
   r1ns2ssYTQcAiepI7YNsp6fE+FnWrlsou/vgppUyyoUnIZzrAFkez3CyX
   thttIZFIZJ12/UztO1d2OEaG0JJAgAM+O916a0KvrPIR1RH0l1TY78p16
   ndP8VytfLiIQOWcR/bxF4B2qzvcWwg8PesisB1mIkJHE8fM9xgK2dXvO/
   qNur27wPfzH2naKMXJKZqXMigliCnoqtf/FMqGQoI07y2eFi4suPwLIjc
   iDdIM5qbV3YhysQ4YytUgy1/eS8d6y2kfz0V+HCUuX6nUiFhAMOtcbxs3
   g==;
X-CSE-ConnectionGUID: 9TImMKu1TM+qO22LMN0Onw==
X-CSE-MsgGUID: VPJqNldsQ5KQQwjp+SIAKw==
X-IronPort-AV: E=McAfee;i="6600,9927,11094"; a="31772307"
X-IronPort-AV: E=Sophos;i="6.08,217,1712646000"; 
   d="scan'208";a="31772307"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2024 09:14:37 -0700
X-CSE-ConnectionGUID: rT5y1NMdTs2EDzChbX7i+Q==
X-CSE-MsgGUID: H0F+atmnTIOAf2GYbyjy8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,217,1712646000"; 
   d="scan'208";a="42581905"
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
Subject: [PATCH v2 3/3] x86/resctrl: Replace open code cacheinfo search in rdtgroup_cbm_to_size()
Date: Wed,  5 Jun 2024 09:14:27 -0700
Message-ID: <20240605161427.312994-4-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

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

