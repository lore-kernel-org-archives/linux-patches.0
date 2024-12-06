Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FB61FFC6C
	for <patches@lists.linux.dev>; Fri,  6 Dec 2024 16:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733502719; cv=none; b=teBCT+lOgkKPTdXQFfU/QWoSBQT94EzFO7h/m2QTnA4TDnbWlcGaPtYvETiy67Ge2Hr92nt2mtalToyGRFhtY4Xd5Q8PAsF1R+QM8ry3V/JGDOWzM640cY6YnL2nWqpILj6jiXK1nzMUbHTTxSX1uGhhuk64Nstndq4wGyWgsrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733502719; c=relaxed/simple;
	bh=rWIcn0PaSYQyS8fWHC7jQf1kPs48TTM30qA5b05XLoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4xt4UeyRGQMiHTGWZK3nJICjo+Pq7FNWwU4tX+ZatnSP1VFlNPwAprcWqqblH7x4p7+H9KD17XfJ16aIexhilWOcICwuEsLxQUdGdJ+Z0juJycH5jhjvkqkI0V0XFry103sPfqhItDEfnzBWG1q5xPgluIV+xhE+zjNauwpdIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KMz351A4; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KMz351A4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733502718; x=1765038718;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rWIcn0PaSYQyS8fWHC7jQf1kPs48TTM30qA5b05XLoo=;
  b=KMz351A4YFqZWq4RubOFxlItAG7yVDBp4KTX+TAsyFNgOOPg/h5lJQN3
   scDjndUElHEkkMbHs6RaXjxyZxP/b0te6UxoOyLquvcW8erz6KO/8k3zq
   x1UCF/+2775x8H/RfutwrC05+nbQVwfvtYdnMx/9NU0OphOm+ZT3dHYHJ
   hE2gZey5PiIOPNRRe6LCZm3g7g4v7JXPegQMjrNHjbPCAhZts8PBlfCWM
   +PLZcnCBukFF2DGOoV7D50R324+8+D+aCQj0LGvzXfG/eHDrOpjNSCEli
   JHc/FgJmZaizF3ysFucayG9+d/r2xhRYn1j5KC3Q4hyQGGW8dk+iNYJoz
   Q==;
X-CSE-ConnectionGUID: AZoIMjmDSk+Yh0foOkZmSA==
X-CSE-MsgGUID: FBX1abImSNqBkbmmF0Bagw==
X-IronPort-AV: E=McAfee;i="6700,10204,11278"; a="44470422"
X-IronPort-AV: E=Sophos;i="6.12,213,1728975600"; 
   d="scan'208";a="44470422"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2024 08:31:54 -0800
X-CSE-ConnectionGUID: zhswkoOOTmeZHI2Fp6a1TQ==
X-CSE-MsgGUID: sw/ZxsrGRcysPCsKiro9CA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,213,1728975600"; 
   d="scan'208";a="95258520"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2024 08:31:55 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	x86@kernel.org
Cc: James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v11 5/8] x86/resctrl: Make mba_sc use total bandwidth if local is not supported
Date: Fri,  6 Dec 2024 08:31:45 -0800
Message-ID: <20241206163148.83828-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241206163148.83828-1-tony.luck@intel.com>
References: <20241206163148.83828-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The default input measurement to the mba_sc feedback loop for
memory bandwidth control when the user mounts with the "mba_MBps"
option is the local bandwidth event.

But some systems may not support a local bandwidth event.

When local bandwidth event is not supported, check for support
of total bandwidth and use that instead.

Relax the mount option check to allow use of the "mba_MBps"
option for systems when only total bandwidth monitoring is
supported. Also update the error message.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c     | 2 ++
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 94bf559966d6..3d1735ed8d1f 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -965,6 +965,8 @@ static __init bool get_rdt_mon_resources(void)
 
 	if (is_mbm_local_enabled())
 		mba_mbps_default_event = QOS_L3_MBM_LOCAL_EVENT_ID;
+	else if (is_mbm_total_enabled())
+		mba_mbps_default_event = QOS_L3_MBM_TOTAL_EVENT_ID;
 
 	return !rdt_get_mon_l3_config(r);
 }
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 8a52b25ce26b..0659b8e2a71b 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -2341,7 +2341,7 @@ static bool supports_mba_mbps(void)
 	struct rdt_resource *rmbm = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
 
-	return (is_mbm_local_enabled() &&
+	return (is_mbm_enabled() &&
 		r->alloc_capable && is_mba_linear() &&
 		r->ctrl_scope == rmbm->mon_scope);
 }
@@ -2768,7 +2768,7 @@ static int rdt_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		ctx->enable_cdpl2 = true;
 		return 0;
 	case Opt_mba_mbps:
-		msg = "mba_MBps requires local MBM and linear scale MBA at L3 scope";
+		msg = "mba_MBps requires MBM and linear scale MBA at L3 scope";
 		if (!supports_mba_mbps())
 			return invalfc(fc, msg);
 		ctx->enable_mba_mbps = true;
-- 
2.47.0

