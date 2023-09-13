Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE8C17FD
	for <patches@lists.linux.dev>; Wed, 13 Sep 2023 18:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694630286; x=1726166286;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EjDox062EDhdZ+SfdzKgsTzvA5pkiDGzCn8j0HCk/Ec=;
  b=jh2fquYjD91+uwzZOyq+1RzKtfZTKejPuNB6BkioxROGhfdcJdR7CBld
   7icSVwKjbgDLbBqWhZPQRqJvfAxfpem/dDVwBhjIvu004NNHLN/poIQRj
   Ef2nAZvUZ6Rpj8a7vKktRYujb4lWvgcP5CckgJaInXkiwlnWbq8Lz4Xhz
   1ZwM8BnGa7vrlLwWCxAeHeOu+qSiiikhs3msylSxCT0EgU4ioIwMCIVyG
   Zld9um/04O18f7DErbD1rwHIm/eK3k3+mqlrJGQQBowxfdPeDaibHRl3I
   O55OhXiRDMmtCD90+hyVlHWNsI+1aLyxrZQ7vGUAxGMEQLO+1U1CKI2Ef
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="369019210"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="369019210"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 11:37:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="744238606"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="744238606"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 11:37:57 -0700
From: Jithu Joseph <jithu.joseph@intel.com>
To: hdegoede@redhat.com,
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
Subject: [PATCH 10/10] platform/x86/intel/ifs: ARRAY BIST for Sierra Forest
Date: Wed, 13 Sep 2023 11:33:48 -0700
Message-Id: <20230913183348.1349409-11-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230913183348.1349409-1-jithu.joseph@intel.com>
References: <20230913183348.1349409-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Array BIST MSR addresses, bit definition and semantics
are different for Sierra Forest. Branch into a separate
Array BIST flow on Sierra Forest when user invokes Array Test.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
---
 drivers/platform/x86/intel/ifs/ifs.h     |  4 +++
 drivers/platform/x86/intel/ifs/core.c    | 15 +++++-----
 drivers/platform/x86/intel/ifs/runtest.c | 37 +++++++++++++++++++++++-
 3 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
index 3265a6d8a6f3..2f20588a71f1 100644
--- a/drivers/platform/x86/intel/ifs/ifs.h
+++ b/drivers/platform/x86/intel/ifs/ifs.h
@@ -137,6 +137,8 @@
 #define MSR_CHUNKS_AUTHENTICATION_STATUS	0x000002c5
 #define MSR_ACTIVATE_SCAN			0x000002c6
 #define MSR_SCAN_STATUS				0x000002c7
+#define MSR_ARRAY_TRIGGER			0x000002d6
+#define MSR_ARRAY_STATUS			0x000002d7
 #define MSR_SAF_CTRL				0x000004f0
 
 #define SCAN_NOT_TESTED				0
@@ -270,6 +272,7 @@ struct ifs_test_caps {
  * @cur_batch: number indicating the currently loaded test file
  * @generation: IFS test generation enumerated by hardware
  * @chunk_size: size of a test chunk
+ * @array_gen: test generation of array test
  */
 struct ifs_data {
 	int	loaded_version;
@@ -281,6 +284,7 @@ struct ifs_data {
 	u32	cur_batch;
 	u32	generation;
 	u32	chunk_size;
+	u32	array_gen;
 };
 
 struct ifs_work {
diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
index 0938bfbd9086..e8b570930c16 100644
--- a/drivers/platform/x86/intel/ifs/core.c
+++ b/drivers/platform/x86/intel/ifs/core.c
@@ -10,16 +10,16 @@
 
 #include "ifs.h"
 
-#define X86_MATCH(model)				\
+#define X86_MATCH(model, array_gen)				\
 	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(INTEL, 6,	\
-		INTEL_FAM6_##model, X86_FEATURE_CORE_CAPABILITIES, NULL)
+		INTEL_FAM6_##model, X86_FEATURE_CORE_CAPABILITIES, array_gen)
 
 static const struct x86_cpu_id ifs_cpu_ids[] __initconst = {
-	X86_MATCH(SAPPHIRERAPIDS_X),
-	X86_MATCH(EMERALDRAPIDS_X),
-	X86_MATCH(GRANITERAPIDS_X),
-	X86_MATCH(GRANITERAPIDS_D),
-	X86_MATCH(ATOM_CRESTMONT_X),
+	X86_MATCH(SAPPHIRERAPIDS_X, 0),
+	X86_MATCH(EMERALDRAPIDS_X, 0),
+	X86_MATCH(GRANITERAPIDS_X, 0),
+	X86_MATCH(GRANITERAPIDS_D, 0),
+	X86_MATCH(ATOM_CRESTMONT_X, 1),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, ifs_cpu_ids);
@@ -99,6 +99,7 @@ static int __init ifs_init(void)
 			continue;
 		ifs_devices[i].rw_data.generation = (msrval & MSR_INTEGRITY_CAPS_SAF_GEN_REV_MASK)
 							>> MSR_INTEGRITY_CAPS_SAF_GEN_REV_SHIFT;
+		ifs_devices[i].rw_data.array_gen = (u32)m->driver_data;
 		ret = misc_register(&ifs_devices[i].misc);
 		if (ret)
 			goto err_exit;
diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
index 997d2f07aa0c..9cfd5c015cb2 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -327,6 +327,38 @@ static void ifs_array_test_core(int cpu, struct device *dev)
 		ifsd->status = SCAN_TEST_PASS;
 }
 
+#define ARRAY_GEN1_TEST_ALL_ARRAYS	(0x0ULL)
+#define ARRAY_GEN1_STATUS_FAIL		(0x1ULL)
+
+static int do_array_test_gen1(void *status)
+{
+	int cpu = smp_processor_id();
+	int first;
+
+	first = cpumask_first(cpu_smt_mask(cpu));
+
+	if (cpu == first) {
+		wrmsrl(MSR_ARRAY_TRIGGER, ARRAY_GEN1_TEST_ALL_ARRAYS);
+		rdmsrl(MSR_ARRAY_STATUS, *((u64 *)status));
+	}
+
+	return 0;
+}
+
+static void ifs_array_test_gen1(int cpu, struct device *dev)
+{
+	struct ifs_data *ifsd = ifs_get_data(dev);
+	u64	status = 0;
+
+	stop_core_cpuslocked(cpu, do_array_test_gen1, &status);
+	ifsd->scan_details = status;
+
+	if (status & ARRAY_GEN1_STATUS_FAIL)
+		ifsd->status = SCAN_TEST_FAIL;
+	else
+		ifsd->status = SCAN_TEST_PASS;
+}
+
 /*
  * Initiate per core test. It wakes up work queue threads on the target cpu and
  * its sibling cpu. Once all sibling threads wake up, the scan test gets executed and
@@ -354,7 +386,10 @@ int do_core_test(int cpu, struct device *dev)
 		ifs_test_core(cpu, dev);
 		break;
 	case IFS_TYPE_ARRAY_BIST:
-		ifs_array_test_core(cpu, dev);
+		if (ifsd->array_gen == 0)
+			ifs_array_test_core(cpu, dev);
+		else
+			ifs_array_test_gen1(cpu, dev);
 		break;
 	default:
 		return -EINVAL;
-- 
2.25.1

