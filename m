Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD9A36A01D
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 16:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775577764; cv=none; b=sS+Wk9aoZ/HjzVQBhKw7+c2wx5zdgNb//s4cdxBoES90tdDnPZkZFEzFoiyw8zxiHHXg7vm2KHQpDSTxOXZwL68kuFPBw23QkZQBHWF27CDWBni4m4GPdhXOrSe9xRZWpP8PkUIanb3GVHZCSkrQec0Pr25QwsjZ/RINlq9e0pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775577764; c=relaxed/simple;
	bh=XQbrDtV7kC3BagIoRNk2xRfz81oxluInULTjgTirvbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RbBhsOZjsKW32GQUQsZE5/w8W7C2PWqZ8lgLO98F4h1n0vSG3ZjSbytbQx9XRLK6KYeeq6JHdo23ti9cYdZ8tnfkoMZAdqH+Q9ndPJwMYnqDEq/usNqB3xBMxj7yD01IuNGLFkBM/nFxqSilz67oftiQ5s0nfwszHj4GVpFjMWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=huqannJZ; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="huqannJZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775577755; x=1807113755;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XQbrDtV7kC3BagIoRNk2xRfz81oxluInULTjgTirvbA=;
  b=huqannJZa+vypkUVOBu6trlp8ugtbSrxHFqcmXL5tA7qiQzZzDk6oy2I
   A8en3iD4IWwszWKioll/Zg20rpzhkWRTPTcJld1cKlvBMPaGoGwT6C5Z3
   FF9xFENgeFxwwoI9ftG/gvf6SsBSeri8Wujk+U1P+GfilyyVIH3J7P7XA
   kPM35Ao/WyYZqQtEB0IUuYtfgT0LI6XxGgJhCrEA03DKKBydun+X+rQEi
   epEwa2gd7unWRrGirkmwkPUl25dDSb9ocwMlU3lc85/Oeq7UE/nYv3x32
   ynhT6Rq9qGgOWf5xYVxuCGeSU/K0FaR22GOx8Vz96ToUYPDD+/QVrWAHB
   g==;
X-CSE-ConnectionGUID: hTrvcrPTS3moKwobeJ22ew==
X-CSE-MsgGUID: 9vz54yvzStCPuiBxKKZKhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11752"; a="80432688"
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="80432688"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 09:02:19 -0700
X-CSE-ConnectionGUID: 2soKQzR9SfidKoRKe14YCg==
X-CSE-MsgGUID: lYGr73d7RAK7EVqt3miV3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="228119043"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 09:02:18 -0700
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
Subject: [PATCH v3 05/13] x86/resctrl: Protect against bad shift
Date: Tue,  7 Apr 2026 09:02:02 -0700
Message-ID: <280c162f8b935d6c755027aa382d55e84ba31116.1775576382.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1775576382.git.reinette.chatre@intel.com>
References: <cover.1775576382.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The size of the bandwidth specifier field is enumerated from AMD hardware.
resctrl uses this field width to determine the maximum bandwidth supported
that is stored in resctrl_membw::max_bw to which user space allocation
requests are compared for validity.

resctrl_membw::max_bw is of type u32 while the register containing the
bandwidth specifier field, L3QOS_BW_CONTROL_n, is 64 bits. While not an
issue with current hardware it is theoretically possible that enumeration
of maximum bandwidth may trigger invalid behavior if a future system can
use a bandwidth specifier field larger than 32 bits. Whether this could
ever represent a reasonable bandwidth value is unknown but addressing the
issue will appease static checkers.

Ensure resctrl can accommodate the hardware's bandwidth specifier field
width with an additional check. Switch to BIT() instead of open-coding the
bitshift to avoid signed integer overflow if the number of bits is a
valid 31.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 7667cf7c4e94..db787c4dee61 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -246,7 +246,9 @@ static __init bool __rdt_get_mem_config_amd(struct rdt_resource *r)
 
 	cpuid_count(0x80000020, subleaf, &eax, &ebx, &ecx, &edx);
 	hw_res->num_closid = edx + 1;
-	r->membw.max_bw = 1 << eax;
+	if (WARN_ON(BITS_PER_TYPE(r->membw.max_bw) <= eax))
+		return false;
+	r->membw.max_bw = BIT(eax);
 
 	/* AMD does not use delay */
 	r->membw.delay_linear = false;
-- 
2.50.1

