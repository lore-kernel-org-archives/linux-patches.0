Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A30616F26E
	for <patches@lists.linux.dev>; Fri, 21 Jun 2024 22:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719009555; cv=none; b=WPmcFMdnDK/G9AYc178WqKDU7LovOAkFs10ZW4xsuG3flcPV7L28E2OxRff4zIZW8+DgjJoxWXgVrieWcsEU6gnUZ94U613hv5CPl8IyHQlTVsERHxhZHktSCrxa+eX/anInFUuj6mq3xdz+Q81R0WvuWDXgWEfAV3MXI6AANF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719009555; c=relaxed/simple;
	bh=gz1z/3g1Nrw89Bjr8uc1k0BwiwWN8+XZ/T4I7q5sEe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+ABcSIgg1yF/fIrpFXGeF3zdQfy9XJjtmsJIpEZX+sliLeEpmxBu+IX/vhpSAI8XGZ+hWRKQnHBzHbjdViFqx3uzkAUF8POIoXApRxGYBdVrhDvXKItG6IcqKf5WoEq/O48ISrOrQ+6kYLZ8f8lWgWQWcVhkwmwDyneZ36DR9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e4dklSXQ; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e4dklSXQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719009553; x=1750545553;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gz1z/3g1Nrw89Bjr8uc1k0BwiwWN8+XZ/T4I7q5sEe4=;
  b=e4dklSXQqFpe5g7e5jpurak2D0hMjLGyKs0DxexvIyzw2MH2JI+iX3yh
   eHn2AQTqKMMzwcc0fY/BoyVSZ+wInYbLGc6SHk1SChDOiBDenNHkbS4kV
   yTTotEav2ExTl5qjY4Wqmzj287fAH0X3vWMiqcqzzq4/UzwwAcfuml3tT
   BJFa79yPhoKoF061HyAGSdzaXd/+Z/Zp5gJy1LcwQCtmi4r/wjBi37Uul
   cPocH8lKBqPZKtqAhfURiJn0eX47ebhcZJ49akcbU1x4dwj8RveOAUlx4
   on/HcYqD8QhgAkJtH9Hy6QnlE1gasfKoW73e+5DtXLPY8unV2PDvARR21
   Q==;
X-CSE-ConnectionGUID: Tnjtvw6CQpGBA84g/cIL9A==
X-CSE-MsgGUID: sagca7gxSjq/y62MELOVAw==
X-IronPort-AV: E=McAfee;i="6700,10204,11110"; a="26691299"
X-IronPort-AV: E=Sophos;i="6.08,256,1712646000"; 
   d="scan'208";a="26691299"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2024 15:39:08 -0700
X-CSE-ConnectionGUID: N0TpG8ZERT6QWt4ZgB143A==
X-CSE-MsgGUID: eKGtGhyuRj2amQSkZw4WEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,256,1712646000"; 
   d="scan'208";a="73935659"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2024 15:39:08 -0700
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
Subject: [PATCH v21 07/18] x86/resctrl: Block use of mba_MBps mount option on Sub-NUMA Cluster (SNC) systems
Date: Fri, 21 Jun 2024 15:38:48 -0700
Message-ID: <20240621223859.43471-8-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240621223859.43471-1-tony.luck@intel.com>
References: <20240621223859.43471-1-tony.luck@intel.com>
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

Improve user diagnostics by adding invalfc() message when mba_MBps
is not supported.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index eb3bbfa96d5a..d3b0fa958266 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -2335,14 +2335,18 @@ static void mba_sc_domain_destroy(struct rdt_resource *r,
 
 /*
  * MBA software controller is supported only if
- * MBM is supported and MBA is in linear scale.
+ * MBM is supported and MBA is in linear scale,
+ * and the MBM monitor scope is the same as MBA
+ * control scope.
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
@@ -2750,6 +2754,7 @@ static int rdt_parse_param(struct fs_context *fc, struct fs_parameter *param)
 {
 	struct rdt_fs_context *ctx = rdt_fc2context(fc);
 	struct fs_parse_result result;
+	const char *msg;
 	int opt;
 
 	opt = fs_parse(fc, rdt_fs_parameters, param, &result);
@@ -2764,8 +2769,9 @@ static int rdt_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		ctx->enable_cdpl2 = true;
 		return 0;
 	case Opt_mba_mbps:
+		msg = "mba_MBps requires local MBM and linear scale MBA at L3 scope";
 		if (!supports_mba_mbps())
-			return -EINVAL;
+			return invalfc(fc, msg);
 		ctx->enable_mba_mbps = true;
 		return 0;
 	case Opt_debug:
-- 
2.45.2

