Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782DF14F9E0
	for <patches@lists.linux.dev>; Mon, 10 Jun 2024 18:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718044547; cv=none; b=TUAj2+fjXKOnQh6M/xThHic1FY3JbWQHhLzsEjfVaczaOxEG3+jZmgsw57GZj0YqQTqk/m6UEtbVB4IPQT3shFr9CsKt6SynZ2IAF6XK5bEh4Esu4gdTSIG/K6Bq5tE4PRrpJmfxO3UQjgXXbJZzTEFx+5r9zHJXx8l+IiQSZYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718044547; c=relaxed/simple;
	bh=6YeS89kWmUZc3iuyIsBWqSSCqJoUH3fqSuDZttW8mlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9+ikGBOFB+zcm/3PxwZIU3z8/DHQmlcuc0z5YIDqXvWWFwz7mbktK/Ivt9Nj7J1jP8ZLJBV240U3SNc0zR/taZ5il/UkIz5JUBHY3+UaCHfiA24zS10wt796fgoYpOPKpc8BLM5KlZPnkOHJDD5PWkOglGRW6rXyP+JoVSdCVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z8iQnxFD; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z8iQnxFD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718044544; x=1749580544;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6YeS89kWmUZc3iuyIsBWqSSCqJoUH3fqSuDZttW8mlk=;
  b=Z8iQnxFDmNPQHFq2m9bXddamL97fD84rTcJFymnJXca827x1wDm5l7WZ
   v0/1yobpYRBt1Km4KZ6J+vKvvHPbDAu1ZH7ksiCowRTqpMyw/vCgVwZvq
   jj9n/dnCi7M+r2sEjzkQc0mxrIGi8KyjO7BIsgdncmgcF/az+0OeVq+NE
   57cUHY6Z+4nXy8fUTE/DxQezYM7tWWt74Ikc7cOQ85B7q6RGohFFYBU4j
   HhZknQ8klmpsktJvpEzIpJLkGgVFD4szqCkYCxgMY7GyELbOpv0YFdQfN
   iScMH53qkptYqLBot8JK4ahwjJOYfvRrHvE86X6KnA3CwxhsR9/E1cxBE
   A==;
X-CSE-ConnectionGUID: H3p8bfbfSLCOrKKd7vhx4Q==
X-CSE-MsgGUID: 1PM7209XSdCYcD2yTx3xaQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="12004818"
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="12004818"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 11:35:38 -0700
X-CSE-ConnectionGUID: 7FEW1etJRxacCajYujSUPQ==
X-CSE-MsgGUID: 8WaP+3JfRVGOsa6rWdd49w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="43576569"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 11:35:38 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v20 07/18] x86/resctrl: Block use of mba_MBps mount option on Sub-NUMA Cluster (SNC) systems
Date: Mon, 10 Jun 2024 11:35:17 -0700
Message-ID: <20240610183528.349198-8-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240610183528.349198-1-tony.luck@intel.com>
References: <20240610183528.349198-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When SNC is enabled there is a mismatch between the MBA control function
which operates at L3 cache scope and the MBM monitor functions which
measure memory bandwidth on each SNC node.

Block use of the mba_MBps when scopes for MBA/MBM do not match.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index eb3bbfa96d5a..a0a43dbe011b 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -2339,10 +2339,12 @@ static void mba_sc_domain_destroy(struct rdt_resource *r,
  */
 static bool supports_mba_mbps(void)
 {
+	struct rdt_resource *rmbm = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
 
 	return (is_mbm_local_enabled() &&
-		r->alloc_capable && is_mba_linear());
+		r->alloc_capable && is_mba_linear() &&
+		r->ctrl_scope == rmbm->mon_scope);
 }
 
 /*
-- 
2.45.0

