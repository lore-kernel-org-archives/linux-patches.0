Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C99B1D31AE
	for <patches@lists.linux.dev>; Fri, 22 Nov 2024 23:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732319923; cv=none; b=a5CscZDLt3236svqyt/L/TkOqLgEIOi1kXujHXX/qvIgtlmj/gel03cROU4mj0+bwhJgL/fzm47ZxWgOUU3VhSzyiHuffhkHGImX5Nnowp+zvZM4fcjNTtDyrFbAWTC9kwWo0/4/JJB41m7nyg1uwWCcd/2p3p7D3FJhZa+0oQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732319923; c=relaxed/simple;
	bh=Bg6SlYlXirA+vF8zbaUcEyBxCSwRzWcikhAsk3FfFC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PM9rHiZjt5ROcCPxgZw7T5Ch82L5++b9gzHxcBc1jYZZ9IrqKM8RIwCzYGoSnBSLAndpDhto8AvAa/T2Kj3Zwe6vbwpGDCh4rw8FMqxbO2arKbwbgnZ2p4q7afdMQh19KqjA+VkxVjZNcTatZf8DNtZsdhJ3eQlB1LltUZ0zEKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZmR9XtHx; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZmR9XtHx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732319922; x=1763855922;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bg6SlYlXirA+vF8zbaUcEyBxCSwRzWcikhAsk3FfFC0=;
  b=ZmR9XtHxyW7XSFTCjgH2faBOBnRXsNmdw6MrGDjp6pb822b9F5cJmSr3
   VkoGXOoLPzotomIDhB6ucmBlleBQwCRA7xXjxkXWByk+LygZAvJJ3JwBv
   IBLUzJPKi1uzBMQR+rEV0Y9xEuzZjAbRJ8q9X1ECss58twy2mDLwQf1MX
   EmhZuiRTaf7tiigu2QRKUOLL48KkM/vSSUWUmAg9O11UjL8TYe2+vMpUS
   jsz35/4S8805Rr5Vi8elFMyvG/K6sxNIcnrGDQmvx1YDb+PZ7aq5sKllv
   TcypI9H5/nZ0IsSfeR3jmzBK0uc1PCgu10ZRA/V9AK+eiTWtwTKoDzRUV
   g==;
X-CSE-ConnectionGUID: CCwT9De2TdSoXO3J2+TS3A==
X-CSE-MsgGUID: XMi93ocLR5+/5akUQd3qcA==
X-IronPort-AV: E=McAfee;i="6700,10204,11264"; a="32642734"
X-IronPort-AV: E=Sophos;i="6.12,177,1728975600"; 
   d="scan'208";a="32642734"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 15:58:39 -0800
X-CSE-ConnectionGUID: wUMzVUoDT8S/x+x8+o8gKg==
X-CSE-MsgGUID: cromQMalRjefqA1PTbHDcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,177,1728975600"; 
   d="scan'208";a="90850906"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 15:58:39 -0800
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
Subject: [PATCH v10 5/8] x86/resctrl: Make mba_sc use total bandwidth if local is not supported
Date: Fri, 22 Nov 2024 15:58:29 -0800
Message-ID: <20241122235832.27498-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241122235832.27498-1-tony.luck@intel.com>
References: <20241122235832.27498-1-tony.luck@intel.com>
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
index 2d42d69ddbe5..98d27199c2fe 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -2343,7 +2343,7 @@ static bool supports_mba_mbps(void)
 	struct rdt_resource *rmbm = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
 
-	return (is_mbm_local_enabled() &&
+	return (is_mbm_enabled() &&
 		r->alloc_capable && is_mba_linear() &&
 		r->ctrl_scope == rmbm->mon_scope);
 }
@@ -2770,7 +2770,7 @@ static int rdt_parse_param(struct fs_context *fc, struct fs_parameter *param)
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

