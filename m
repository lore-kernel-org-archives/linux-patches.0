Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2E0165FA2
	for <patches@lists.linux.dev>; Wed, 15 May 2024 22:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715811827; cv=none; b=BjwlYy+pWoe7/9xmCHjFigQQIA5ng3MTmDXD+NBVwJ/XkZJgH2R5xhgcpLM5gFtvofNeRZU4pOlGBE9bkcD5NrJyQDK6RW6X6YbKlEd+o0riNGPzFXDqBR4EfhQ0vNTNn+Ky7VF7FtZEvI+Zoj8wRY+h1aq0qCr8M9o/nv+0b2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715811827; c=relaxed/simple;
	bh=xZjqBCuTBBldbea6pHTW+ptVpegP77hRi5Pdpchcfvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=meHlRfLgytxoxDS7oxHlAVUyd9XqIPPVf2UG5nVg3GHaV3K9k4gLcnPw1hbVriO/FXZJGVvI1AyOBJp0QPpgZRAeHvKFJWXB8bFNHiM9mEliDmArIQM6yIhf0N80NIuRZELIhNI4+oWYTBpfhr82juCWiFdPiYzBfAuoaohapes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d/EMYbbO; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d/EMYbbO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715811825; x=1747347825;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xZjqBCuTBBldbea6pHTW+ptVpegP77hRi5Pdpchcfvs=;
  b=d/EMYbbO4k1jhXmirWeyFciiyCp1NSKnkZxpgLiCcTxTzwhp4ZcH5biv
   v2ujhlWs474uyQQ8T59+SAm8moP+rEe0T8/5RvvYfNKPQmm/+IgovQOFF
   No3IPd3Lb4y2Wi6Wr1/DuzXhXcLJgNtFgHgsnhwou/utq1hbc0xY+gAv3
   rEnUSBzf/vQx6uCe1gs0OGdXk4Qw+leve6k5yKyYSYndhzCe6h6xPAFqa
   YMGenMshof89XU7hcAP2/h4+Jf6fwrKxP6x06D5QZg5eMTXg1e1nbgLYS
   wrmtM5Jxo32EzWWbw1dMYOkSQvPnpqenWCOGtjtAKykbPMtyiRJt+dpGP
   w==;
X-CSE-ConnectionGUID: We7LF67SSRWayr1mMoMywQ==
X-CSE-MsgGUID: /fMtol57Rxyq0ORG524LFw==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="15671729"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="15671729"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 15:23:37 -0700
X-CSE-ConnectionGUID: lBBOznPzRu2o2+Nwf8Hq/Q==
X-CSE-MsgGUID: XKlPT9SwSiurhNppnPBdgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="35989193"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 15:23:37 -0700
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
Subject: [PATCH v18 15/17] x86/resctrl: Fix RMID reading sanity check for Sub-NUMA (SNC) mode
Date: Wed, 15 May 2024 15:23:23 -0700
Message-ID: <20240515222326.74166-16-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240515222326.74166-1-tony.luck@intel.com>
References: <20240515222326.74166-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The sanity check that RMIDs are being read from a CPU listed in the
the cpu_mask for the domain is incorrect when summing across multiple
SNC domains. It is safe to read the RMID from any CPU that shares the
same L3 cache instance.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/monitor.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 668d2fdf58cd..e4b92c7af71d 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -15,6 +15,7 @@
  * Software Developer Manual June 2016, volume 3, section 17.17.
  */
 
+#include <linux/cacheinfo.h>
 #include <linux/cpu.h>
 #include <linux/module.h>
 #include <linux/sizes.h>
@@ -281,8 +282,18 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
 
 	resctrl_arch_rmid_read_context_check();
 
-	if (!cpumask_test_cpu(smp_processor_id(), &d->hdr.cpu_mask))
-		return -EINVAL;
+	if (r->mon_scope == r->mon_display_scope) {
+		if (!cpumask_test_cpu(smp_processor_id(), &d->hdr.cpu_mask))
+			return -EINVAL;
+	} else {
+		/*
+		 * SNC: OK to read events on any CPU sharing same L3
+		 * cache instance.
+		 */
+		if (d->display_id != get_cpu_cacheinfo_id(smp_processor_id(),
+							  r->mon_display_scope))
+			return -EINVAL;
+	}
 
 	ret = __rmid_read(rmid, eventid, &msr_val);
 	if (ret)
-- 
2.44.0

