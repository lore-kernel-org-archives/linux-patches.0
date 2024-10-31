Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203521C9ED2
	for <patches@lists.linux.dev>; Thu, 31 Oct 2024 18:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730401064; cv=none; b=XuXkbo20kNdZLk12JTdeEM6GY+4UokmOh0vOyr1yhY360vCWwgP7Vyu07K1oKCC5LV6Hg5UMgAWhKy+ztCzO3FsCGnN/8uERJGcM5OC2p2oYmy+9G7e6QDXfCFDT1PhOeI+okskvnLg5pNM3Kn0iEZ7gsAhw3Ojn/WyfI2mnULI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730401064; c=relaxed/simple;
	bh=YQqpWCkSnImhXNI/iZYJv1bT6VeGrsVO5CNqjgqxDQA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CwYkPKtmylVSjrFNk3yygxJ/aQp/CSQpS2lJEAES/QC4yU9xXCXXxwCVf4miVoR9lGgelToFv4ro+GJp5GqKU/woHx2KU1pOsxR02v3ts7oTJZGBS8jijDLYWyuM8GMyNaNUc7FJCnijmYQ6jMrQUXpBtQnAAH4Z1pYXbIVz6vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZFF2TtKY; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZFF2TtKY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730401061; x=1761937061;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YQqpWCkSnImhXNI/iZYJv1bT6VeGrsVO5CNqjgqxDQA=;
  b=ZFF2TtKYvNhF431zDflkkh7Mvx17YI1uBuReSAceWZ675Cl3k1n293zf
   pBNnJ9RK/4Yv529SJ9EfBRM7+Wu0VfGANkIoziq1cUt7bS9tAfLrZJgqg
   qFu7N9VnE9pja453lw+Up4CMYBXk21dkA8OOpzSFbvaErm7Vic2ut7YHF
   lYQ7jTtdeNfWTzQUj28aVfjmzTGyJpeM/4Gt7OLBu/N3LdycUzMRcFdzn
   6qwobnUmva/6Z+9jRJwmWByI2k79zbunyqZ+2NaHz+0cXwiVWXCvLcXlW
   JGV+qhigC05rKEbRI/nwdX4nlTd9xw5kxxwOEuX50iDGb1x6M34pCHVnS
   g==;
X-CSE-ConnectionGUID: h9yiI07hS6Sm8V3KlVjFLA==
X-CSE-MsgGUID: MgG7FPp4Rp+V4gcMs/fsOw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="47621410"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="47621410"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 11:57:41 -0700
X-CSE-ConnectionGUID: XokQ4S8jSVaFwS/Ri//kAA==
X-CSE-MsgGUID: QWrYPH+hSnOcbtcS6OJXrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="83137569"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 11:57:40 -0700
From: Tony Luck <tony.luck@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] x86/cpu: Fix FAM5_QUARK_X1000 to use X86_MATCH_VFM()
Date: Thu, 31 Oct 2024 11:57:33 -0700
Message-ID: <20241031185733.17327-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This family 5 CPU escaped notice when cleaning up all the family 6
CPUs.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/intel-family.h             | 1 -
 arch/x86/platform/efi/quirks.c                  | 3 +--
 arch/x86/platform/intel-quark/imr.c             | 2 +-
 arch/x86/platform/intel-quark/imr_selftest.c    | 2 +-
 drivers/thermal/intel/intel_quark_dts_thermal.c | 2 +-
 5 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 1a42f829667a..d2570420bc8b 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -177,7 +177,6 @@
 #define INTEL_XEON_PHI_KNM		IFM(6, 0x85) /* Knights Mill */
 
 /* Family 5 */
-#define INTEL_FAM5_QUARK_X1000		0x09 /* Quark X1000 SoC */
 #define INTEL_QUARK_X1000		IFM(5, 0x09) /* Quark X1000 SoC */
 
 /* Family 19 */
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index f0cc00032751..846bf49f2508 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -656,8 +656,7 @@ static int qrk_capsule_setup_info(struct capsule_info *cap_info, void **pkbuff,
 }
 
 static const struct x86_cpu_id efi_capsule_quirk_ids[] = {
-	X86_MATCH_VENDOR_FAM_MODEL(INTEL, 5, INTEL_FAM5_QUARK_X1000,
-				   &qrk_capsule_setup_info),
+	X86_MATCH_VFM(INTEL_QUARK_X1000, &qrk_capsule_setup_info),
 	{ }
 };
 
diff --git a/arch/x86/platform/intel-quark/imr.c b/arch/x86/platform/intel-quark/imr.c
index d3d456925b2a..ee25b032c0b3 100644
--- a/arch/x86/platform/intel-quark/imr.c
+++ b/arch/x86/platform/intel-quark/imr.c
@@ -569,7 +569,7 @@ static void __init imr_fixup_memmap(struct imr_device *idev)
 }
 
 static const struct x86_cpu_id imr_ids[] __initconst = {
-	X86_MATCH_VENDOR_FAM_MODEL(INTEL, 5, INTEL_FAM5_QUARK_X1000, NULL),
+	X86_MATCH_VFM(INTEL_QUARK_X1000, NULL),
 	{}
 };
 
diff --git a/arch/x86/platform/intel-quark/imr_selftest.c b/arch/x86/platform/intel-quark/imr_selftest.c
index 84ba715f44d1..657925b0f428 100644
--- a/arch/x86/platform/intel-quark/imr_selftest.c
+++ b/arch/x86/platform/intel-quark/imr_selftest.c
@@ -105,7 +105,7 @@ static void __init imr_self_test(void)
 }
 
 static const struct x86_cpu_id imr_ids[] __initconst = {
-	X86_MATCH_VENDOR_FAM_MODEL(INTEL, 5, INTEL_FAM5_QUARK_X1000, NULL),
+	X86_MATCH_VFM(INTEL_QUARK_X1000, NULL),
 	{}
 };
 
diff --git a/drivers/thermal/intel/intel_quark_dts_thermal.c b/drivers/thermal/intel/intel_quark_dts_thermal.c
index 47296a14db3c..89498eb29a89 100644
--- a/drivers/thermal/intel/intel_quark_dts_thermal.c
+++ b/drivers/thermal/intel/intel_quark_dts_thermal.c
@@ -401,7 +401,7 @@ static struct soc_sensor_entry *alloc_soc_dts(void)
 }
 
 static const struct x86_cpu_id qrk_thermal_ids[] __initconst  = {
-	X86_MATCH_VENDOR_FAM_MODEL(INTEL, 5, INTEL_FAM5_QUARK_X1000, NULL),
+	X86_MATCH_VFM(INTEL_QUARK_X1000, NULL),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, qrk_thermal_ids);
-- 
2.47.0

