Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041121917FA
	for <patches@lists.linux.dev>; Fri, 22 Nov 2024 23:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732318939; cv=none; b=HQ/glAedKKp45qRU9ZehbqrfTZekqWrfYXSV64zLsiRqFCUpyRoSx0gYRE2/WuIGq1j7qXVHX84BpQFNnGsEsMqabOBTE96j7hdh+3nt5sxdYiDlusyUywYNIHXMbACHn7ubmaACrQ1w3y9eml4ec4bG7eXW5XfrPu5oUONj5Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732318939; c=relaxed/simple;
	bh=C0i500WgD2lccswvFFcSvmhoAnAR88Bb6mcliSF2Nx8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CZk9zEmA98uqVnakCWY1D80Z6Xce8l+kLuvVk35mzYwUemVGFF/NZa5KoZ2hHmikh8Otna9FHDl0gzN5CR2BLR5PqVdxBV6KlUIcTUQA2EP2exaHLOjNgQ+pufxEtSZ9qmU04uLK4hgW5+iWlx4kN0yw817MbcVVQGfDkn0egEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EaeSXbVh; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EaeSXbVh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732318938; x=1763854938;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=C0i500WgD2lccswvFFcSvmhoAnAR88Bb6mcliSF2Nx8=;
  b=EaeSXbVhmTDeB0MXoh1wNkvGPJ7OZsS7MUDRl+WJx1hkTwDE8ZtQYeui
   Fwxlt6OAQqz3xn/oQAXnlJXaG5GiggPQDKFdnNWev8BwAfvTEkBytzr+q
   fQl13p+JscdMwYxc0RDOsgbkXa7agyU/LF3Z4gOy/DXplDIWICwQt/5tJ
   XT2k7Ig1lWlbbtfDsmRFKzsEEgNNMSbkDiWxOSl9ZjTRg7hqHovSVFRAD
   IllDwJ9LjCptmGmV5X/sotD3hYRoVOsnFr185BTNmbMWsiRcx5HvGUkE7
   xxvCJ4sGxya8tR09reKJAxOvU5xQy8B0v1fXEwdOdFFgikB/h2BimHtgi
   Q==;
X-CSE-ConnectionGUID: jcyThLSyQF+FObhjgJolIQ==
X-CSE-MsgGUID: YH+l2HS3Si62vr9qOXF2mQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11264"; a="43102487"
X-IronPort-AV: E=Sophos;i="6.12,177,1728975600"; 
   d="scan'208";a="43102487"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 15:42:17 -0800
X-CSE-ConnectionGUID: qWM46LcdRuK7M7vHUKYzAA==
X-CSE-MsgGUID: gUTmPxVpRhqwbYWQ8cjCbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="95767511"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 15:42:17 -0800
From: Tony Luck <tony.luck@intel.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Adeel Ashad <adeel.arshad@intel.com>
Subject: [PATCH] x86/cpu: Fix PPIN initialization
Date: Fri, 22 Nov 2024 15:42:12 -0800
Message-ID: <20241122234212.27451-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On systems that enumerate PPIN (protected processor inventory
number) using CPUID, but where the BIOS locked the MSR to
prevent access /proc/cpuinfo reports "intel_ppin" feature as
present on all logical CPUs except for CPU 0.

This happens because ppin_init() uses x86_match_cpu() to
determine whether PPIN is supported. When called on CPU 0
the test for locked PPIN MSR results in:

	clear_cpu_cap(c, info->feature);

This clears the X86 FEATURE bit in boot_cpu_data. When other
CPUs are brought online the x86_match_cpu() fails, and the
PPIN FEATURE bit remains set for those other CPUs.

Fix by using setup_clear_cpu_cap() instead of clear_cpu_cap()
which force clears the FEATURE bit for all CPUS.

Reported-by: Adeel Ashad <adeel.arshad@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 02637365d1a9..52c3f941c2b1 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -169,7 +169,7 @@ static void ppin_init(struct cpuinfo_x86 *c)
 	}
 
 clear_ppin:
-	clear_cpu_cap(c, info->feature);
+	setup_clear_cpu_cap(info->feature);
 }
 
 static void default_init(struct cpuinfo_x86 *c)
-- 
2.47.0

