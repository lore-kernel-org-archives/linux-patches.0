Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B4B3D6CD7
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 21:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784754708; cv=none; b=jshGgJ11R2m4e3fomN9znqInLl50Jdy9R1fHlu3PdFW7Vs5ygz9YMdMJMBgwBdMadzSnOBVXFkOF1rKzTzle4iY09752UXDMkJ7j55fS+mVC2TUCyBVpMYR8xPFg/8Pj8IPLUumSBHvG63oIQWl3AYEGUuyzY1eocN7rz1Dx/N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784754708; c=relaxed/simple;
	bh=praoXRV/fG7SznymE2nqldu69IadWPrXvZ0yMi2ddSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHAtDMTp+mq9mG/d5Ya8/0QKiM9npxojLUlhtLYXdnO5Ihr50yoTVtZZ+2uWM63UDAsgCW6eHq+8zmI21owToIKUflpUD+QN/df9a1LFwORhgn50z8xI7UMEnilrcTNyjh3X8U2p2KA9mGLFkUDakFZ5flAyvkhkmi5e2ETmeO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=URlz20lo; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="URlz20lo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784754706; x=1816290706;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=praoXRV/fG7SznymE2nqldu69IadWPrXvZ0yMi2ddSo=;
  b=URlz20loLfzjoJ5MVvF3irNSf3JHUs1JfSq1yo/evCz5i2W/qmFH0B5R
   6vOdWLT6KkvVH6+W0NkccQk8hF4lj18MC5vSRVzu1M9tHbiyVgB48plOu
   JRBpvUK4vzHURPhlJOpegwFFCZvz7RPq2gHfKf3m/My9THkAqSml8Ae6n
   58mkSyMbX+4Hc+s0/uyhZM6Qw0has1gJ5A+gp3CZnHv00q0QpTWuSDMxH
   RMqiF+6/Vv/aMeK8BsjMXkBlIg3XQX5UiWlEe3sZmx+bfXjThIkxHpVo0
   U6cH8ZpJP8QpKA4BydpCzyJh3zUP55SNnoZmh4zpbjTGfwPn/B3jUbET4
   A==;
X-CSE-ConnectionGUID: Sf0I60dBQpKt3ztQ5m64wg==
X-CSE-MsgGUID: LJ0zL+FQTZmTlodgk+c6Bg==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="102814607"
X-IronPort-AV: E=Sophos;i="6.25,179,1779174000"; 
   d="scan'208";a="102814607"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 14:11:45 -0700
X-CSE-ConnectionGUID: bYpbdaFnRfiH2q9ZYG4y3Q==
X-CSE-MsgGUID: lPBqD2kTSt2b8KiPvQSrPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,179,1779174000"; 
   d="scan'208";a="255553335"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 14:11:45 -0700
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
Subject: [PATCH v5.1 02/10] x86/resctrl: Protect against bad shift
Date: Wed, 22 Jul 2026 14:11:38 -0700
Message-ID: <dd9fc3505c0ed250c5f14898b0ed6d7460a3cb82.1784753375.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260722200311.GFamEh_2Z6p3MrXpVr@fat_crate.local>
References: <20260722200311.GFamEh_2Z6p3MrXpVr@fat_crate.local>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The size of the bandwidth field is enumerated from AMD hardware. resctrl
uses this field width to determine the maximum bandwidth supported that is
stored in resctrl_membw::max_bw. User space allocation requests ("control
values") are compared against this maximum for validity before being
programmed to hardware.

resctrl filesystem and resctrl x86 architecture code only support u32
control values: resctrl_membw::max_bw is a u32, the control value provided
by user space is parsed into u32 local variables, and after validity checks,
the control value is staged into the u32 resctrl_staged_config::new_ctrl
for architecture consumption. The resctrl x86 architecture code in turn
caches the new control value into the u32 array rdt_hw_ctrl_domain::ctrl_val[].

The AMD bandwidth field to which control values are written can be up to
64 bits wide. While not an issue with current hardware (bandwidths that
require more than a u32, more than 536870911.875 GB/s, seem unreasonable
today), it is theoretically possible that enumeration of maximum bandwidth
field width will return values that are according to specification but
cannot be supported by resctrl.

Static checkers complain about this size mismatch.

Fix the static checker complaint by explicitly encoding the fact that
resctrl is unable to support all values that the hardware specification
allows. Switch to BIT() instead of open-coding the bitshift to avoid signed
integer overflow if the number of bits is a valid 31.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
Changes since v3:
- Use pr_warn() instead of WARN_ON().
  sashiko: https://sashiko.dev/#/patchset/cover.1775576382.git.reinette.chatre%40intel.com

Changes since v4:
- Add Tony's Reviewed-by tag.

Changes since v5:
- Rewrite changelog to highlight that resctrl cannot support bandwidth
  needing more than u32 and what this patch really fixes. (Boris)
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

