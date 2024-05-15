Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EC5155A57
	for <patches@lists.linux.dev>; Wed, 15 May 2024 21:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715809447; cv=none; b=PjS5bmByIP+CS9Uhxia622BVaVUkmsBVc39RCi/C0e2tGM6VrBvUzNX1SP9kObzrOEznz20P0mJs0rldyOpBLZlsWo+QbVO8zq7RiK6/FBuGiZcvPuwVZL8KtljGoSksAR92qdbcDs5q36FCdkwjM+FZ1zmOV9PrJ69+kWefqu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715809447; c=relaxed/simple;
	bh=5qEbwkLcOrEvBA+Jfj2Sig7VdcHS47eVtQcB3Ya+vhA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=quxy7cgwdBPM0H32e3g0l2TFNKfrYIy4R6JG/rv1OONadvRhCPifrR0wY4wQbkCWBgdGBL6FSv2+1md/K/DzXBeSQb+NQ73tQNw6uFuw3UDU3zZWwn+rtjxMVv0d6kvn2R22OApqxWoAiuBseEILLP5WMYXAiAlgXXMm+A3znn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VXz+v8EP; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VXz+v8EP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715809446; x=1747345446;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5qEbwkLcOrEvBA+Jfj2Sig7VdcHS47eVtQcB3Ya+vhA=;
  b=VXz+v8EPpngZBgJNZZVggACf/ll3vzq/T6NpVa9gY2LNYoZkF3Qmi8z0
   zKevjhmw6Sam+IMed9JXH8a3wdRLWTnqu46Vng/zirmQxoYO8ChNOSvyu
   eVH+2yUloXodxmCo7yUHucUHQjPRSPT0P6UO09hLO50uaBARoI/LMpCyr
   Cr4ZnaNl/JcgPihgLwhxVG0jV49twEThmoCehwGOeDnojhgqKwOlPuZiR
   rkY7lxdbgv88Bw9WovyXkROKeXBIt6i+kLh+zuf8fVyE2zuhEKPyA1uLq
   1+8abVYtg9/C5LCY7EYjeG62DCqsvxMexGMjXsR72KVKgeLYmuLc3n3UJ
   Q==;
X-CSE-ConnectionGUID: JYYt1MrHSym9tnP9p2jcfg==
X-CSE-MsgGUID: jOPEjmmQQvGwkQew2Ho0yg==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="12062141"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="12062141"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 14:44:06 -0700
X-CSE-ConnectionGUID: y+PWi6rLQryn5aDZO4Uggw==
X-CSE-MsgGUID: t4cKo+MIRHKBGvkLVjhNHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="31253888"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 14:44:05 -0700
From: Tony Luck <tony.luck@intel.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] x86/cpu: Fix x86_match_cpu() to match just X86_VENDOR_INTEL
Date: Wed, 15 May 2024 14:43:57 -0700
Message-ID: <20240515214357.73798-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's a wildcard match in arch/x86/kernel/smpboot.c that wants
to hit on any CPU made by Intel. The match used to work because
the check was actually looking for any Intel CPU in family 6.

With the change to ease support for families other than 6,
this wildcard match failed because every entry in the struct x86_cpu_id
was zero. This is used as the end-marker in arrays of x86_cpu_id
structures, so can never match.

Failure to match meant the logic to detect Intel Sub-NUMA cluster
mode didn't operate and there were boot messages about insane
cache configuration.

Fix by changing X86_VENDOR_INTEL to a non-zero value (4 was lowest
unused value, so I picked that).

Fixes: 4db64279bc2b ("x86/cpu: Switch to new Intel CPU model defines")
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index cb4f6c513c48..271c4c95bc37 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -175,10 +175,10 @@ struct cpuinfo_x86 {
 	unsigned		initialized : 1;
 } __randomize_layout;
 
-#define X86_VENDOR_INTEL	0
 #define X86_VENDOR_CYRIX	1
 #define X86_VENDOR_AMD		2
 #define X86_VENDOR_UMC		3
+#define X86_VENDOR_INTEL	4
 #define X86_VENDOR_CENTAUR	5
 #define X86_VENDOR_TRANSMETA	7
 #define X86_VENDOR_NSC		8
-- 
2.44.0

