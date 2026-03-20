Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1149F3246E8
	for <patches@lists.linux.dev>; Fri, 20 Mar 2026 22:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774044239; cv=none; b=Rnn8Cqd5W9mMkgrtS21KWX51e8fX5m+f2AZXTo1tQYYMHIJ6oGX5iSpItMV10AQonOP7Q8+jesr55WkOwV3O1mMVO2bzLBPKTsLFj8tL6FybbGobislWW9+nBTPv3FqWrxpY1qqvSOmqEiZkQYypYi6iqpn2022td8Dpn/qGjco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774044239; c=relaxed/simple;
	bh=XQbrDtV7kC3BagIoRNk2xRfz81oxluInULTjgTirvbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OxQnWC/TJhbfM5r/cXwwfT177agvkTZ5NTFZFLV34nL5oJ1w9xRKSV+YxH0bWg5H9laiBCEQ8MlcuSYNCpPIuxy55r48zpob6uUWD2LDOPuYuWTYrsgjwharJuZ/UE5sbPVDntrSkLOLhcuv21BpQBl0SiFVewsKHX4CEtnsaSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eIeUNT6e; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eIeUNT6e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774044237; x=1805580237;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XQbrDtV7kC3BagIoRNk2xRfz81oxluInULTjgTirvbA=;
  b=eIeUNT6e8wC8fBCMempBqRztqQNho25CgnHDwiLwifRbeGkOfhJlaQDo
   u1Rnb+UUKD5WtmKaNM+cELy+ZSOEW8PCskeJL2flbI/7b8ZJYBzBFCgGN
   bpyw+6GzvvocVkkUMcKeMdqN9esShyXI7pI/kPOS0RQBSQ9JAzZGC1sI/
   SBUgkjL5MnVWHM7ubxuMMlhjHdJ6jO6LhoacU2DvrzNGiV+A/3iTwX2DZ
   icxdbP9fGXXWAbpDn4xmLiXV/1+DzJnKsM7wSws0THYsEf9QS5aT+pUhv
   MNr3w4GL4BVO5Iipr0TfGFHgyTps5v1pw+KMTc9hOnJfN2L5dYIPC1NTA
   w==;
X-CSE-ConnectionGUID: vqw9+D1pRkyrj15aabzZUA==
X-CSE-MsgGUID: VuNTU22rQFikxft1iUov3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="97758375"
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="97758375"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 15:03:54 -0700
X-CSE-ConnectionGUID: Ry5l89fCQ6C2vcyNccHOEQ==
X-CSE-MsgGUID: TaiTYti/QPGKR/HrGD1zAA==
X-ExtLoop1: 1
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 15:03:54 -0700
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
Subject: [PATCH v2 05/14] x86/resctrl: Protect against bad shift
Date: Fri, 20 Mar 2026 15:03:15 -0700
Message-ID: <18825382dd74ef5d7c7871a269204ec236da4790.1774043709.git.reinette.chatre@intel.com>
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

