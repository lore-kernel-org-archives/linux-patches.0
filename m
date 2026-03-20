Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E332632E151
	for <patches@lists.linux.dev>; Fri, 20 Mar 2026 22:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774044240; cv=none; b=HT/nPnIZpuYPiXog9nT8MCVjL0mx7DOu0dOV/cyDRV5lC1dEIopvYmTbi/JZM6LEPPIbLPoXhEDflaqm92I0jcHrIIr5zPg6qA9iCcFDOKwonpyFcCH3BAQgQkd+0t5u9UM1zsNdQR/lz02aeYWl2HoQ3vitZXGAPji4TabRo4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774044240; c=relaxed/simple;
	bh=6S4Kbf26Ho80olkPFiZ8UngQhelhtisWM0bMfgO68B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHsOyn6lmic0iGcxN9Pt4bomT/7Tt+mNTt486tZYa5Ec6PFDTbSKTd3q9psANBMRxlSB1yGjwMC6VhbJbVJQ+rAAK77hcnkMN8kRgl1EOfK++rKt8dG47pkQE7Nq0mdI2uww+u6Sautb4hZpboaEDPsibxS/44OZ9RgU08uu1WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N+fXL2oP; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N+fXL2oP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774044238; x=1805580238;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6S4Kbf26Ho80olkPFiZ8UngQhelhtisWM0bMfgO68B4=;
  b=N+fXL2oP004bR0/rTCxa3qVu5NdLsQ0XFd1sZH5WxSdymT+HIBlYywNV
   zmpukLzaEpx68xjBV5aOE+QBuMACg7vIN3gMYsGLNThRX41WdcqFI1FfZ
   cI9vU2GCqfJ0YyWz1aSclkIBGrlB40HHBOMRRo7bFGFjGYi+mdL4MSwzy
   b7cJ+Nn/asDStzPWoMRPYc1xQGDwM4DSJSdXfGnCaQeMSbg2aJtttxgJ3
   gi2Xyd17tqIQ6RqxQ7U/hwYRO7VBE7ghOTYUw8mk7G+/qfL+grS5PcIJH
   GTVHZG4xPu1iAeqYR3/WF7LYsKAFF29bDNbHO+2435O1nMQaTbX7WOrmL
   Q==;
X-CSE-ConnectionGUID: wjPqW7DuSv+GruDTi/JrOA==
X-CSE-MsgGUID: xLuHUL3nSzSub3b1pPN5zQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="97758396"
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="97758396"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 15:03:55 -0700
X-CSE-ConnectionGUID: o6e4Ft09Sp6BLbxL0J9nUQ==
X-CSE-MsgGUID: gV+OJ3KRS6KM/I9o0gt0bQ==
X-ExtLoop1: 1
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 15:03:55 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: tony.luck@intel.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	ben.horgan@arm.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v2 07/14] fs/resctrl: Use accurate type for rdt_resource::rid
Date: Fri, 20 Mar 2026 15:03:17 -0700
Message-ID: <1ae8867b43acb509f6359139297ee3a340bd0441.1774043709.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1774043709.git.reinette.chatre@intel.com>
References: <cover.1774043709.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Every resctrl resource has a unique ID described by enum resctrl_res_level.
enum resctrl_res_level is used in all resource ID initializations and all
resource ID comparisons. All functions consuming the resource ID expects an
enum resctrl_res_level. Of the four structures that contain a resource ID
(struct mon_data, struct mon_evt, struct rdt_domain_hdr, and struct
 rdt_resource) only struct rdt_resource does not use enum resctrl_res_level.

Switch the type of rdt_resource::rid to be enum resctrl_res_level to make
it obvious what values are valid, match the type everywhere this member is
used, and obtain benefits from tools that can flag any enum misuse.

Move define of RDT_NUM_RESOURCES outside the enum to enable tools to catch
when a switch() on the resource ID does not handle all the resources and
thus help flag which switch statements need an update when a new resource
is added.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since v1:
- Use RDT_RESOURCE_LAST = RDT_RESOURCE_PERF_PKG as last entry in enum.(Ben)
---
 include/linux/resctrl.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 0b28049378c8..99a4774735c7 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -54,11 +54,11 @@ enum resctrl_res_level {
 	RDT_RESOURCE_MBA,
 	RDT_RESOURCE_SMBA,
 	RDT_RESOURCE_PERF_PKG,
-
-	/* Must be the last */
-	RDT_NUM_RESOURCES,
+	RDT_RESOURCE_LAST = RDT_RESOURCE_PERF_PKG
 };
 
+#define RDT_NUM_RESOURCES (RDT_RESOURCE_LAST + 1)
+
 /**
  * enum resctrl_conf_type - The type of configuration.
  * @CDP_NONE:	No prioritisation, both code and data are controlled or monitored.
@@ -320,7 +320,7 @@ struct resctrl_mon {
  * @cdp_capable:	Is the CDP feature available on this resource
  */
 struct rdt_resource {
-	int			rid;
+	enum resctrl_res_level	rid;
 	bool			alloc_capable;
 	bool			mon_capable;
 	enum resctrl_scope	ctrl_scope;
-- 
2.50.1

