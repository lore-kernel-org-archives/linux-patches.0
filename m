Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D606480DFF
	for <patches@lists.linux.dev>; Wed, 19 Aug 2026 16:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787156017; cv=none; b=jULl9Wagik+1YGqOZZ9Wt5PFyJXIs0CZLbLyGCGQsFFC3xvMtQA50EUPB5vVsOihYVZtwSBvX7h3kwz5rnMQLIOk3LVgKlUIpoyT+D78aMsdOJFr9mNaGqcAwfeCr35q/JYQldFPY/WC2xJ/f0Ty/5vH8DF8POe9ddr0IhynCEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787156017; c=relaxed/simple;
	bh=WuDNhkqq00kjVqYmDtHZU0GQSxxyzh5NoYhjctJowrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZbur8CM8PNyzKH2lmGhih9cCOrUFAXRv2E7rMjDIElgpzexBhFUMdFIvGMbRY8DgPgeq+DCZhAVf/f76cXEHUjnX7CvHmRZxoU5rxvaU5ihGN8NyI2y4wkMf2YKvGle3RJAuQnXPzJ9oDwNdu9pJ+nnAgBvTTsqTxNcvJVnnl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DzpvWFlk; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DzpvWFlk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787156015; x=1818692015;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WuDNhkqq00kjVqYmDtHZU0GQSxxyzh5NoYhjctJowrU=;
  b=DzpvWFlka5D0z8q3KFaWptALtwSD4on9HpMzFH/CAgrGs8+/cw/RrjZU
   psBkLMU/7j2mbg5pFkFFrZW5UtnG68WPQvQi6F/eOoatYtP8RuC4HV39Z
   tKQ+17NVevF02atVaDMks7yPhNm5HFvgCcluMjs16znGM8mYVnQtAFDgG
   ckWLrOQcUIYIs/S1sF8Y3duB+5M+9m6YQxVXvGOfb1oSEBRjEIwzqcbT3
   tbRm5qIAZWIW/YLziBR3PL1Vmr8TRoKFjEY5Q0eNTJ27VB0VYt7yG/zmP
   tScwkkoc4f89Q8wojUN1RN7SPQ0Rqpu2OULDotNxfMielPWymswXrFa82
   g==;
X-CSE-ConnectionGUID: 7qjmY5UKRlipHKItelBmwQ==
X-CSE-MsgGUID: DOXt5AabQGG27eSbfPkwNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11880"; a="87598047"
X-IronPort-AV: E=Sophos;i="6.25,231,1779174000"; 
   d="scan'208";a="87598047"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2026 09:13:33 -0700
X-CSE-ConnectionGUID: TpOGlf1RQ+G1990Ts1zCpw==
X-CSE-MsgGUID: p29TT35EQbWv46FuIQDk3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,231,1779174000"; 
   d="scan'208";a="290391841"
Received: from rodrigoa-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2026 09:13:33 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH 1/4] x86/resctrl: Check if monitoring features are enabled
Date: Wed, 19 Aug 2026 09:13:19 -0700
Message-ID: <20260819161323.11587-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260819161323.11587-1-tony.luck@intel.com>
References: <20260819161323.11587-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both Intel and AMD manuals say that software must first check
CPUID(0x7,0x0).EBX[12] to see if any monitoring features are enabled
before checking for specific features enabled in subleaves.

Add the check for X86_FEATURE_CQM.

Fixes: cbc82b172638 ("x86: Add support for Intel Cache QoS Monitoring (CQM) detection")
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 55214d6fdc49..2677b8a6c15b 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -968,6 +968,9 @@ static __init bool get_rdt_mon_resources(void)
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
 	bool ret = false;
 
+	if (!cpu_feature_enabled(X86_FEATURE_CQM))
+		return false;
+
 	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
 		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false, 0, NULL);
 		ret = true;
-- 
2.55.0

