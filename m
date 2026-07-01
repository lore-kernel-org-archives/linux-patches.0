Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E267380FE6
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 04:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782880044; cv=none; b=M/ma6q1t8GTvFsdPdGyZmCxw3aLVEanFBYe5j1ole185GjU+3rbezJ5TYqeEwk56l/ImJ79f8QxujV0+2UivFiAWXVPlnEpWq8ssIq7uJfn/hCgW9j7gqz8cF8Ynv1pvD9GkxCIzWcDckkT6/+BfVdktqcCGt4EmTYzN5vPSYss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782880044; c=relaxed/simple;
	bh=f+9AORB/VRD4yOaXF+dIlLoZejQIZBjinJqbwOVZBV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CeWZLwV8JF9Q4E/mr4pVyAh2B3lca3+Bfry9/X4szZ2LiHpXgHGNbisiMf9L92VOImMvSdb++NJoTUKhIXIgB/FO9SA2KLsQUGEV082E94b7vhzr8Vy5xGDlZYY5g4cKxX6xP0CPR2rZ3wLJcipGHqQ597na7j4I8F18FD76Fjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ROBwr8Jn; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ROBwr8Jn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782880040; x=1814416040;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f+9AORB/VRD4yOaXF+dIlLoZejQIZBjinJqbwOVZBV0=;
  b=ROBwr8Jn2Xhwy4eRwwvhRhibzEqzFED/ogKBPt/khqMpZ1yPoy0M9Vz9
   Lxx5JusbPaajhQFrB4ac0TVjtgAEUwZ775Q84A6s1T7gYz7LxWjPQfA8h
   +OsDpq4YyWflrqawQzY3Qn+KphACwepZwOAWeMf5BAjopLeug1UxU5tTW
   HgzQY30NhROtVvkGzQww5lCdI03zWEZWZQ41hJSa5HiglRGLp4NyB9uJI
   RgO7/fkMd+BW1dupK7qgCN4yJf77AAE35hPmgExz/5aYwDV5p1tvCWXQA
   K2r3S+PjcPWUWgoEO8SqkM9u7lvYU7IfFtJ6rj0wVIg2L7xYoxjLmNEcu
   Q==;
X-CSE-ConnectionGUID: zsP4ybwPS86mPWUCnJVz0w==
X-CSE-MsgGUID: 2fnDR41QRPKradXR/M/wKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="87514244"
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="87514244"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 21:27:18 -0700
X-CSE-ConnectionGUID: Vwwt6+mQS+uqiOLK21Ft5w==
X-CSE-MsgGUID: FwpNd8epTcGOSI/cbSulbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="249080558"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 21:27:17 -0700
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
	yu.c.chen@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v5 02/10] x86/resctrl: Protect against bad shift
Date: Tue, 30 Jun 2026 21:27:02 -0700
Message-ID: <bc6ec5102227b4617265e015ce84335a8e902bc6.1782857711.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782857711.git.reinette.chatre@intel.com>
References: <cover.1782857711.git.reinette.chatre@intel.com>
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
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
Changes since v3:
- Use pr_warn() instead of WARN_ON().
  sashiko: https://sashiko.dev/#/patchset/cover.1775576382.git.reinette.chatre%40intel.com

Changes since v4:
- Add Tony's Reviewed-by tag.
---
 arch/x86/kernel/cpu/resctrl/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index bca782050198..9b9495174041 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -247,7 +247,11 @@ static __init bool __rdt_get_mem_config_amd(struct rdt_resource *r)
 
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
2.54.0

