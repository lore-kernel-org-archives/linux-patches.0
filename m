Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686121D6AA
	for <patches@lists.linux.dev>; Thu, 14 Nov 2024 00:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731543446; cv=none; b=qJzOcxAWGpkKOyQxELTcDsZNP/i+qCqxONcwDoZXeDdcgSfl2M9gwP1x2IN3ymRruYV8XwrjEh8b8PjNAplkgbHutlt3xetVWF+jpRpYZaV1TZ4dU15dVTHpjFjeIc1VRzowy+Yptr/IBfxpv/xbhk8OS5Tlxax8X+SVIFlbaio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731543446; c=relaxed/simple;
	bh=sams9RAjayhA8eov6q7XFBsoSi+1xtqlPnrjKc9CSyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFRzhmF7WEWGJgOREdIqoqOXndcPlU5aBfADspUKhi/riKwK1TqzyZCiiGom0CO30Dn8UrXrNjX9n94Ra5KIoubHfVkqaOUTJCptmA+ZRtG5K+XrEqMJa/m6GaFX4KvocoQJOaGzAvZH5vFwIb3iRImu5YTCXIgAVySGoZyF9bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GUS1Y++q; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GUS1Y++q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731543444; x=1763079444;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sams9RAjayhA8eov6q7XFBsoSi+1xtqlPnrjKc9CSyg=;
  b=GUS1Y++qlhvEpOhIc6eHrBWapf4Fw1Sd42VA01tjyjMs5ZwrM0dxU6Bv
   A2lflO9faN9syXFHn+prc8tPZOzgsu44AQ1k2LrPOppo2PVIB7S4xBHnj
   D5+0+nic6g0tyAjxhECEbxS3q4ulOmmsLjL+sDCk4Xp7icAiEutrSlg02
   GqJvPbmi84gu2dwqwDGXQV0oGy9SzcbfOnNokSNDxMFLYfJQNPRKgaxi/
   7XZRjii3ltFPyTcimOvToqMCi8y4ChtwzDjeyumv6WqfvFkssP2ONPLki
   7PDK0gf1yT3d4iMleF+WOy2Xhi7Lacg6HkVUYC9nb1FpCOLbOC5IdTqzB
   Q==;
X-CSE-ConnectionGUID: Kyg82BIcTEOD5bTXBmAqtw==
X-CSE-MsgGUID: VzjXRDqgQUG9vRf7s7Xf+Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11255"; a="30869530"
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="30869530"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 16:17:19 -0800
X-CSE-ConnectionGUID: TVVv+jAbSdS/vw4vyysAfQ==
X-CSE-MsgGUID: Uep8lmumTDqekhDZXaaqYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="92081172"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 16:17:19 -0800
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
Subject: [PATCH v9 8/9] x86/resctrl: Make mba_sc use total bandwidth if local is not supported
Date: Wed, 13 Nov 2024 16:17:10 -0800
Message-ID: <20241114001712.80315-9-tony.luck@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241114001712.80315-1-tony.luck@intel.com>
References: <20241114001712.80315-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The default input measurement to the mba_sc feedback loop for
memory bandwidth control when the user mounts with the "mba_MBps"
option has historically been the local bandwidth event.

But some systems may not support a local bandwidth event.

When local bandwidth event is not supported, check for support
of total bandwidth and use that instead.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 2 ++
 1 file changed, 2 insertions(+)

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
-- 
2.47.0

