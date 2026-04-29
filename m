Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D06D35F605
	for <patches@lists.linux.dev>; Wed, 29 Apr 2026 15:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777475210; cv=none; b=I+mSIzfQ0z/WwQ0P4f0mhF1wUedLmhm9nfOYnMXqlq5X+FatD45G43+3rOcTufNH/sHZJrmtdoYOAoKv4oKd5tnPenk03PHeUob/C4DNsaQfuWIrP915wWKSXnKWJhFU2tecX5Hkubw7xnFDjFuqNXSIKAOWB+OqqS27Fv7X7Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777475210; c=relaxed/simple;
	bh=R3jq/Tn2MlbSH1wGWOLouK4xxwRvjuiHY+8vjleDYHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d688eFijURv1YY+OCcD1jxHPuRU0urBUB0edUqsatUDX4LlrB4gbBmcFWxoV/1NLARq79s5I5CiKS4enxWic9f9SIajVYCI6CIMQ+0w1Vv0rT1PT9h8xkJw5cSGuil0hLAe/f7VaDsT14HY/oaO1zRBzGiPAvOfwHvJZjDvrZvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dsLZNXT9; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dsLZNXT9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777475209; x=1809011209;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R3jq/Tn2MlbSH1wGWOLouK4xxwRvjuiHY+8vjleDYHY=;
  b=dsLZNXT9Egxm7rXudrSSz9ekuXuSDgruqMlUjd/MsZoKq+HuWgBPg0n8
   F4MTgneqIoRHi1bKuTpCnEy/9YzlFZTzDAhKvX+HXlC4L68f4qOPTe5R1
   4g5ZdXn2T7mzVk1dsIWXxFOPj5nSYVEJh5FPEcUVQwPxFADDB3kgOo1Y8
   BO/PP8Rpi3vWKMpdvLFia9HVSdMMn/VNZFCOtjbvb5Fa+6a4a0v7i5g7Q
   mdReHXCvKADNNA4YQwEgrWc06lkb9ul0cF5dMRnZ09ssBBGSbdA+QCwpe
   RZx4G0m1WScq4W26M06q1k+e61tYq9k42FYAuHDzgit51LfCYo6kho7tr
   w==;
X-CSE-ConnectionGUID: 2opUa5qjTAKCeokV0D9yHg==
X-CSE-MsgGUID: z/B63fpjT/u2d3K1xY0D2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="78424340"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="78424340"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 08:06:47 -0700
X-CSE-ConnectionGUID: QIlayKz+TjKSgeKN/RVIfw==
X-CSE-MsgGUID: x3JMnl/tSGWOeppinepJ1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="233445003"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 08:06:46 -0700
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
Subject: [PATCH v4 02/10] x86/resctrl: Protect against bad shift
Date: Wed, 29 Apr 2026 08:06:32 -0700
Message-ID: <e8a768b5c4dd0698112cc97fbb844b5a530bb11b.1777419024.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1777419024.git.reinette.chatre@intel.com>
References: <cover.1777419024.git.reinette.chatre@intel.com>
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
Changes since v3:
- Use pr_warn() instead of WARN_ON().
  sashiko: https://sashiko.dev/#/patchset/cover.1775576382.git.reinette.chatre%40intel.com
---
 arch/x86/kernel/cpu/resctrl/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 7667cf7c4e94..778a2d3a26b7 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -246,7 +246,11 @@ static __init bool __rdt_get_mem_config_amd(struct rdt_resource *r)
 
 	cpuid_count(0x80000020, subleaf, &eax, &ebx, &ecx, &edx);
 	hw_res->num_closid = edx + 1;
-	r->membw.max_bw = 1 << eax;
+	if (BITS_PER_TYPE(r->membw.max_bw) <= eax) {
+		pr_warn("Unable to support hardware's maximum bandwidth\n");
+		return false;
+	}
+	r->membw.max_bw = BIT(eax);
 
 	/* AMD does not use delay */
 	r->membw.delay_linear = false;
-- 
2.50.1

