Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C7E246BA5
	for <patches@lists.linux.dev>; Fri, 29 Aug 2025 19:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756496041; cv=none; b=Hxxx1z8zSu9WylJrx0820ttXDeDFXimF1fPkpiATBJhDlYxknlmbLHZ8Ma66YaC2CKUVAUvzs/K+LyeYG5QLEmTGqdemSgtGQAX4GVzJ5DDEuJU78zll5GTqhy4fSjOa1AM4mIBW49oBzhRCWn+0LwpcUeOznj2qcyGEtcdlx+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756496041; c=relaxed/simple;
	bh=sgTn18NxUgyf/UEH420jefEbiBwbco3CCd8zQ7xR3sE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZC3+Ug1YkIBMBJE00ci/49L/OihCk37/hB+shWapPcU6tWAtyR1qkEzOi3GnRm0qamxGQHhx0PNOCh7N1956j0wKGSCnHLLAIqLIW0x4GW48y6EyMhdBgAZ/Rtiik0dOEbAzHcmbOodnuoxNtqBzS8Dd5cpcPCb3l/ADHoX4wJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jk0KWtph; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jk0KWtph"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756496039; x=1788032039;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sgTn18NxUgyf/UEH420jefEbiBwbco3CCd8zQ7xR3sE=;
  b=Jk0KWtphDfzZm8bXtMZL9PCiBFgrQTs4zLma6ccu+eI4BCVr93x2DIfO
   DzHQ2m6cIdYqKN7iVU7ui7Lf3tJ0c7eGMBG9iPGr8aFl4VD4fYI7zpH8Z
   4X5YyJS8UlwSNWU22F1I2ZbtS7Rlo9/LlklLqnd+gwjWKNBll7OfLGPAJ
   W8Cl8O7UmpoiWBkqf1Tyjgt4J8NO1SymbcVIJWt7kx1AvYp7gWXvAte6L
   EL2oRuMOILT+xGAv1gjQggQInUKqfe20Ow4F5AGn5Y7YdYETxLFj7gceB
   rjPvCPzU+OBzUaqrHy0o6B628X/i2E8g7TwfZfzra2+fsN9/O2nrqX/8C
   A==;
X-CSE-ConnectionGUID: L3L7c4SGRsqF9Ai3PbxrUw==
X-CSE-MsgGUID: fUijrZwASEmp/8xwDNa/aw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62625199"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62625199"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:33:53 -0700
X-CSE-ConnectionGUID: 9S+jYt04QceijoUcjwksyQ==
X-CSE-MsgGUID: kf5JAKVMRCK/SUGaYRdf+A==
X-ExtLoop1: 1
Received: from ldmartin-desk2.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.202])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:33:53 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v9 08/31] x86/resctrl: Clean up domain_remove_cpu_ctrl()
Date: Fri, 29 Aug 2025 12:33:20 -0700
Message-ID: <20250829193346.31565-9-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829193346.31565-1-tony.luck@intel.com>
References: <20250829193346.31565-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For symmetry with domain_remove_cpu_mon() refactor
domain_remove_cpu_ctrl() to take an early return when removing
a CPU does not empty the domain.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index f1b215b72844..44572973bcd4 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -600,28 +600,27 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
 		return;
 	}
 
+	cpumask_clear_cpu(cpu, &hdr->cpu_mask);
+	if (!cpumask_empty(&hdr->cpu_mask))
+		return;
+
 	if (!domain_header_is_valid(hdr, RESCTRL_CTRL_DOMAIN, r->rid))
 		return;
 
 	d = container_of(hdr, struct rdt_ctrl_domain, hdr);
 	hw_dom = resctrl_to_arch_ctrl_dom(d);
 
-	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
-	if (cpumask_empty(&d->hdr.cpu_mask)) {
-		resctrl_offline_ctrl_domain(r, d);
-		list_del_rcu(&d->hdr.list);
-		synchronize_rcu();
-
-		/*
-		 * rdt_ctrl_domain "d" is going to be freed below, so clear
-		 * its pointer from pseudo_lock_region struct.
-		 */
-		if (d->plr)
-			d->plr->d = NULL;
-		ctrl_domain_free(hw_dom);
+	resctrl_offline_ctrl_domain(r, d);
+	list_del_rcu(&hdr->list);
+	synchronize_rcu();
 
-		return;
-	}
+	/*
+	 * rdt_ctrl_domain "d" is going to be freed below, so clear
+	 * its pointer from pseudo_lock_region struct.
+	 */
+	if (d->plr)
+		d->plr->d = NULL;
+	ctrl_domain_free(hw_dom);
 }
 
 static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
-- 
2.50.1

