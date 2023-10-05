Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1D44122E
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 19:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="je1Q6847"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696535746; x=1728071746;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W0bEWWgNT9CiXugP8M24uRKr5rb4of+/WbVzOiaRxgM=;
  b=je1Q6847+3x3lOObxBKTVE0XvYv4+09Gie3+jxoJqGg5nkwB8DoHM2Kt
   pzUrk9l8q8zvd0W7kdhbzGLTQfQ4GcDopBfMf4eM4S9tCF7Nc9FbSwFNz
   QSu90KfglZUK1eGcdDaxsXNY4vwl7oesOhBeSc+dU+DUuImoEly+Bisv0
   9JU3Loog7nSK6+SU0YFcKQzaQgXqBRVsYvDspiPBJnj6T3V227dvRXBIQ
   gHBKZOi0199b5WGTs1hiawgEN2zCBdZuASlDYJmJihdR4sj9XBF2ahHOn
   eBwDx/jMw8KLdlieqSPCW93Hr1idFVOFw/Ot1GnyHSntXnTxeCtjeT8p5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10854"; a="386432540"
X-IronPort-AV: E=Sophos;i="6.03,203,1694761200"; 
   d="scan'208";a="386432540"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 12:55:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10854"; a="755600115"
X-IronPort-AV: E=Sophos;i="6.03,203,1694761200"; 
   d="scan'208";a="755600115"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 12:55:43 -0700
From: Jithu Joseph <jithu.joseph@intel.com>
To: ilpo.jarvinen@linux.intel.com,
	hdegoede@redhat.com,
	markgross@kernel.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rostedt@goodmis.org,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com,
	pengfei.xu@intel.com
Subject: [PATCH v4 1/9] platform/x86/intel/ifs: Store IFS generation number
Date: Thu,  5 Oct 2023 12:51:29 -0700
Message-Id: <20231005195137.3117166-2-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231005195137.3117166-1-jithu.joseph@intel.com>
References: <20230929202436.2850388-1-jithu.joseph@intel.com>
 <20231005195137.3117166-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

IFS generation number is reported via MSR_INTEGRITY_CAPS.  As IFS
support gets added to newer CPUs, some differences are expected during
IFS image loading and test flows.

Define MSR bitmasks to extract and store the generation in driver data,
so that driver can modify its MSR interaction appropriately.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
---
 arch/x86/include/asm/msr-index.h      | 1 +
 drivers/platform/x86/intel/ifs/ifs.h  | 2 ++
 drivers/platform/x86/intel/ifs/core.c | 3 +++
 3 files changed, 6 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 1d111350197f..838e5a013a07 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -222,6 +222,7 @@
 #define MSR_INTEGRITY_CAPS_ARRAY_BIST          BIT(MSR_INTEGRITY_CAPS_ARRAY_BIST_BIT)
 #define MSR_INTEGRITY_CAPS_PERIODIC_BIST_BIT	4
 #define MSR_INTEGRITY_CAPS_PERIODIC_BIST	BIT(MSR_INTEGRITY_CAPS_PERIODIC_BIST_BIT)
+#define MSR_INTEGRITY_CAPS_SAF_GEN_MASK	GENMASK_ULL(10, 9)
 
 #define MSR_LBR_NHM_FROM		0x00000680
 #define MSR_LBR_NHM_TO			0x000006c0
diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
index 93191855890f..d666aeed20fc 100644
--- a/drivers/platform/x86/intel/ifs/ifs.h
+++ b/drivers/platform/x86/intel/ifs/ifs.h
@@ -229,6 +229,7 @@ struct ifs_test_caps {
  * @status: it holds simple status pass/fail/untested
  * @scan_details: opaque scan status code from h/w
  * @cur_batch: number indicating the currently loaded test file
+ * @generation: IFS test generation enumerated by hardware
  */
 struct ifs_data {
 	int	loaded_version;
@@ -238,6 +239,7 @@ struct ifs_data {
 	int	status;
 	u64	scan_details;
 	u32	cur_batch;
+	u32	generation;
 };
 
 struct ifs_work {
diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
index 306f886b52d2..4ff2aa4b484b 100644
--- a/drivers/platform/x86/intel/ifs/core.c
+++ b/drivers/platform/x86/intel/ifs/core.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright(c) 2022 Intel Corporation. */
 
+#include <linux/bitfield.h>
 #include <linux/module.h>
 #include <linux/kdev_t.h>
 #include <linux/semaphore.h>
@@ -94,6 +95,8 @@ static int __init ifs_init(void)
 	for (i = 0; i < IFS_NUMTESTS; i++) {
 		if (!(msrval & BIT(ifs_devices[i].test_caps->integrity_cap_bit)))
 			continue;
+		ifs_devices[i].rw_data.generation = FIELD_GET(MSR_INTEGRITY_CAPS_SAF_GEN_MASK,
+							      msrval);
 		ret = misc_register(&ifs_devices[i].misc);
 		if (ret)
 			goto err_exit;
-- 
2.25.1

