Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6194A1272AC
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643303; cv=none; b=jy+Lufg18mXjaeNpKoAdQgLkG8s5U+pxCQJaLMkCLqOEPzhILDXeM19qL1vUqqVeLp2tpmzSKfMKl1EU4F+5deG1xIl5Y65cEqC8G3QqxRlUu7fyOVTyu5wntF8pVXzenZDT1gnXZC6/A5lwyne1yGiSPxMJuIFH7WQkcABCfVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643303; c=relaxed/simple;
	bh=KWBh8g5qezvg7G7Awmc1JPz7LX3fEPmblNlcvDU1Zbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8dtqZkWWyb53g6XS0+kMJf1rFxFCOBSjHA5NsZgIY4gGyOghjhUd7en3yiPBAILDsyWlWC9YyQ6sef0y7ShwS8J5fYWE5wpVFVN0vyXFbEcu9f1WPPNByhge/Azfy1rEsFRoLKvdxpmfCf0FHosMbqVuoCxwYlPv5zT9yvNU/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NMh6eIKw; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NMh6eIKw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643299; x=1743179299;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KWBh8g5qezvg7G7Awmc1JPz7LX3fEPmblNlcvDU1Zbw=;
  b=NMh6eIKwpWfK4yW66iofreXlLXbmKfAQTp2YKRDOnDdgK/lCXhbzDPBH
   rtVajipXVl0ma+IdZjjgaH7YMbPPdYbtU20YBv78AewsVAKNlgD2usmYx
   x4iqCjoJWBvPdXykYv0tyoTUubqqoc7PKRx6rYYoe/yMyPcGr6Al6Cwes
   djmmGbUjkT8mf6KeSFyamLC3Nkxd8iG1onk+YXiEuwE+g5zM+7si3tT3R
   E1FXcJ0DPIxGVNyxim6aAUoWrLQXeTML2i+Q+fMIt2GYHZ/HYcEb/FRBt
   pVJ+qUZjjdKgb2dHbXUG6z2cGRZZT1vwD1VKDDhPNp38hpH3PGeZLF7xz
   Q==;
X-CSE-ConnectionGUID: xiYX1kh6TSqcWIzciwUBiA==
X-CSE-MsgGUID: aKWwSKM/RdK+jamGePQKVw==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294716"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294716"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16725945"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:21 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 01/74] x86/cpu/vfm: Add/initialize x86_vfm field to struct cpuinfo_x86
Date: Thu, 28 Mar 2024 09:26:55 -0700
Message-ID: <20240328162820.242778-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328090459.242500-tony.luck@intel.com>
References: <20240328090459.242500-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor struct cpuinfo_x86 so that the vendor, family, and model
fields are overlayed in a union with a 32-bit field that combines
all three (together with a one byte reserved field in the upper
byte).

This will make it easy, cheap, and reliable to check all three
values at once.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/processor.h | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 811548f131f4..87115e5d884f 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -108,9 +108,15 @@ struct cpuinfo_topology {
 };
 
 struct cpuinfo_x86 {
-	__u8			x86;		/* CPU family */
-	__u8			x86_vendor;	/* CPU vendor */
-	__u8			x86_model;
+	union {
+		struct {
+			__u8	x86_vendor;	/* CPU vendor */
+			__u8	x86;		/* CPU family */
+			__u8	x86_model;
+			__u8	x86_reserved;
+		};
+		__u32		x86_vfm;	/* combined vendor, family, model */
+	};
 	__u8			x86_stepping;
 #ifdef CONFIG_X86_64
 	/* Number of 4K pages in DTLB/ITLB combined(in pages): */
-- 
2.44.0

