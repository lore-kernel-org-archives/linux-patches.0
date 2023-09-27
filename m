Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D10EACC
	for <patches@lists.linux.dev>; Wed, 27 Sep 2023 18:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695840753; x=1727376753;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MQ0uyvyitsUR5wpJxHzYcH82109tYU4SRG/CvaLk8sQ=;
  b=muamd1vS/DGFB8pVdKl5KqJPqaMK5SmoQj8I3iHOgDWmFnJ0nfAJoqXF
   FY2Ck+sTZzGV1hbYVPmHoK7XjMhW2HZaW2Nb4aIw6RNC0HDw92kyBGxlm
   82LC0xBIjlEicjqLMp/0xWZaXOCdJmcQgNFbjhbYgH8KWSXVR9Dyp7Zra
   Lf8rvf4MEvS83OHkBj+4DRbWlxSx8XhwupSoE0ku/QErmy+Py3272YvVM
   qiFYkt5nwo3ladptTfzW/aU+Kl9UMjnT1MxVaGKY6dTAH0avENLqg6Mvl
   XII3TFPHub8Ku9TxsLGk39prquzR9xtpAgJSqY0+8qxiZ9VIb/AUBj96q
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="468186508"
X-IronPort-AV: E=Sophos;i="6.03,182,1694761200"; 
   d="scan'208";a="468186508"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2023 11:52:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="725928273"
X-IronPort-AV: E=Sophos;i="6.03,182,1694761200"; 
   d="scan'208";a="725928273"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2023 11:52:30 -0700
From: Jithu Joseph <jithu.joseph@intel.com>
To: hdegoede@redhat.com,
	markgross@kernel.org
Cc: ashok.raj@intel.com,
	tony.luck@intel.com,
	linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 1/1] platform/x86/intel/ifs: release cpus_read_lock()
Date: Wed, 27 Sep 2023 11:48:24 -0700
Message-Id: <20230927184824.2566086-1-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Couple of error paths in do_core_test() was returning directly without
doing a necessary cpus_read_unlock().

Following lockdep warning was observed when exercising these scenarios
with PROVE_RAW_LOCK_NESTING enabled:

[  139.304775] ================================================
[  139.311185] WARNING: lock held when returning to user space!
[  139.317593] 6.6.0-rc2ifs01+ #11 Tainted: G S      W I
[  139.324499] ------------------------------------------------
[  139.330908] bash/11476 is leaving the kernel with locks still held!
[  139.338000] 1 lock held by bash/11476:
[  139.342262]  #0: ffffffffaa26c930 (cpu_hotplug_lock){++++}-{0:0}, at:
do_core_test+0x35/0x1c0 [intel_ifs]

Fix the flow so that all scenarios release the lock prior to returning
from the function.

Fixes: 5210fb4e1880 ("platform/x86/intel/ifs: Sysfs interface for Array BIST")
Cc: stable@vger.kernel.org
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 drivers/platform/x86/intel/ifs/runtest.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
index 1061eb7ec399..43c864add778 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -331,14 +331,15 @@ int do_core_test(int cpu, struct device *dev)
 	switch (test->test_num) {
 	case IFS_TYPE_SAF:
 		if (!ifsd->loaded)
-			return -EPERM;
-		ifs_test_core(cpu, dev);
+			ret = -EPERM;
+		else
+			ifs_test_core(cpu, dev);
 		break;
 	case IFS_TYPE_ARRAY_BIST:
 		ifs_array_test_core(cpu, dev);
 		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
 	}
 out:
 	cpus_read_unlock();

base-commit: 6465e260f48790807eef06b583b38ca9789b6072
-- 
2.25.1

