Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC67371CEF
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 05:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774589228; cv=none; b=XetFY/+0xHahnPVyDM70/h5j7QVa+9z4CJpSFIbUe5NW4tEXk419dTIu0zYC8hn2ZJTHO13kw5uftFfJ3Ghke80p1glwcn09OQrubVoY6kt6hHQL4SYBSnCW5TPFxNRAtM0l3Zj/9B59bz6FxoS5tYxMX2j2ydyHw4RGV6555q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774589228; c=relaxed/simple;
	bh=y1ozZXftLOrksn4DKyTYJ/LzrVPKRXY30kCj/Gx5zbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jAbTw/mOaRfspzbDnDDhhjSF96XtPkNSHsoqyZ5/hnbppr8vNA+C3hy3zSb3qJl9g73l57LewiSx9H8lNplhUv96CSkEeBXx4RRLlBHTOsSti/MRcNLlFgqr+t1onAsjEkJcH9F+bDqo0s7iORA0lRc3ASsf9eocVfEwHYmzjHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WIVg3Zed; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WIVg3Zed"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774589228; x=1806125228;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y1ozZXftLOrksn4DKyTYJ/LzrVPKRXY30kCj/Gx5zbA=;
  b=WIVg3ZedonqYCL+PbKxLicb8gRuiNqTP2z9KYcbhqDDxfwwjNl2y50hE
   xVw61AEmTuyJJy/x4pdwWSvJMpwHsK+YroNbCQddQkZiRLf271syJCFPP
   fZS+kDh8lPok/2qYVeqNWYekUE7H/pZT9k7toywQFDA3s1VqXqChJDV/L
   f/PGCRsXP2d5W8ugA/cPhqY0IihmJJ+0Mbef9iLgaSIrHxemIsgol6NLb
   D+1w5Snz9IM4EM44GYu66VkBO5CuAsJUI30dj9Jebd0s2FEvA2PKF64Qs
   NQLFIMEH/Sjy+Sm7W7DIyFZUF3kIX1HUr+yzOit8lF/mMnpSTB8BWuooP
   g==;
X-CSE-ConnectionGUID: nf+oniDQS/60e32WkTswMQ==
X-CSE-MsgGUID: JzxJ3sIdSYKYEpagWlhcRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11741"; a="101117945"
X-IronPort-AV: E=Sophos;i="6.23,143,1770624000"; 
   d="scan'208";a="101117945"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 22:27:05 -0700
X-CSE-ConnectionGUID: /p0j3IKVR9GADyzMyCXAkw==
X-CSE-MsgGUID: 7r8nF/8BQZ2ukqeZi0GoKw==
X-ExtLoop1: 1
Received: from dwillia2-desk.jf.intel.com ([10.88.27.145])
  by fmviesa003.fm.intel.com with ESMTP; 26 Mar 2026 22:27:05 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: dave.jiang@intel.com
Cc: patches@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com
Subject: [PATCH 2/9] dax/cxl: Fix HMEM dependencies
Date: Thu, 26 Mar 2026 22:28:14 -0700
Message-ID: <20260327052821.440749-3-dan.j.williams@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260327052821.440749-1-dan.j.williams@intel.com>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The expectation is that DEV_DAX_HMEM=y should be disallowed if any of
CXL_ACPI, or CXL_PCI are set =m. Also DEV_DAX_CXL=y should be disallowed if
DEV_DAX_HMEM=m. Use "$config || !$config" syntax for each dependency.
Otherwise, the invalid DEV_DAX_HMEM=m && DEV_DAX_CXL=y configuration is
allowed.

Lastly, dax_hmem depends on the availability of the
cxl_region_contains_resource() symbol published by the cxl_core.ko module.
So, also prevent DEV_DAX_HMEM from being built-in when the cxl_core module
is not built-in.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/Kconfig | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index 3683bb3f2311..504f7f735ef5 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -32,6 +32,9 @@ config DEV_DAX_HMEM
 	depends on EFI_SOFT_RESERVE
 	select NUMA_KEEP_MEMINFO if NUMA_MEMBLKS
 	default DEV_DAX
+	depends on CXL_ACPI || !CXL_ACPI
+	depends on CXL_PCI || !CXL_PCI
+	depends on CXL_BUS || !CXL_BUS
 	help
 	  EFI 2.8 platforms, and others, may advertise 'specific purpose'
 	  memory. For example, a high bandwidth memory pool. The
@@ -48,8 +51,7 @@ config DEV_DAX_CXL
 	tristate "CXL DAX: direct access to CXL RAM regions"
 	depends on CXL_BUS && CXL_REGION && DEV_DAX
 	default CXL_REGION && DEV_DAX
-	depends on CXL_ACPI >= DEV_DAX_HMEM
-	depends on CXL_PCI >= DEV_DAX_HMEM
+	depends on DEV_DAX_HMEM || !DEV_DAX_HMEM
 	help
 	  CXL RAM regions are either mapped by platform-firmware
 	  and published in the initial system-memory map as "System RAM", mapped
-- 
2.53.0

