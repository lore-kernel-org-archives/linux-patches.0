Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E66348E83
	for <patches@lists.linux.dev>; Fri, 22 Sep 2023 23:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695425419; x=1726961419;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2+Jeemb14YT94QywKDuACyHIVjPi3obb4Vw18keeVVI=;
  b=TZF6Jc8pzGbgRZvNhOZa1b/QHmvikHRHuXzEJSductRN4TOfYuAartU3
   oiaBJfbtN8poqfw3WW9hfinuo+/Bef/f8OlcIvdMHl5Nq0odnoWSrn4M4
   jon6r/RBiEotzhlXxqKfIGOc0bUoW7+29fwm0k5ocbYv4OwbdlVf7Rm5J
   Kl+GrLOVo4ZniI0fUS9s7JFgGT3plO6Db3+Me6iiIEq85wUNSNdvTQi0k
   cqk0hJ0yVTJ/sF0whnnJBRdqOShngEnehotx25JRJL1VtFD9hUdNqPpg0
   e+0ymQS/Ysx+YjnKTTGRwCTDGb0obl2URn8Qpe2aNnAJ8EzU2khCIG/g3
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="411896992"
X-IronPort-AV: E=Sophos;i="6.03,169,1694761200"; 
   d="scan'208";a="411896992"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2023 16:30:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="921350856"
X-IronPort-AV: E=Sophos;i="6.03,169,1694761200"; 
   d="scan'208";a="921350856"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2023 16:30:14 -0700
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
	pengfei.xu@intel.com,
	ilpo.jarvinen@linux.intel.com
Subject: [PATCH v2 9/9] platform/x86/intel/ifs: ARRAY BIST for Sierra Forest
Date: Fri, 22 Sep 2023 16:26:06 -0700
Message-Id: <20230922232606.1928026-10-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230922232606.1928026-1-jithu.joseph@intel.com>
References: <20230913183348.1349409-1-jithu.joseph@intel.com>
 <20230922232606.1928026-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Array BIST MSR addresses, bit definition and semantics are different for
Sierra Forest. Branch into a separate Array BIST flow on Sierra Forest
when user invokes Array Test.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
---
 drivers/platform/x86/intel/ifs/ifs.h     |  4 +++
 drivers/platform/x86/intel/ifs/core.c    | 15 +++++-----
 drivers/platform/x86/intel/ifs/runtest.c | 37 +++++++++++++++++++++++-
 3 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
index cd213b89d278..73268f5dcff1 100644
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
@@ -272,6 +274,7 @@ struct ifs_test_caps {
  * @cur_batch: number indicating the currently loaded test file
  * @generation: IFS test generation enumerated by hardware
  * @chunk_size: size of a test chunk
+ * @array_gen: test generation of array test
  */
 struct ifs_data {
 	int	loaded_version;
@@ -283,6 +286,7 @@ struct ifs_data {
 	u32	cur_batch;
 	u32	generation;
 	u32	chunk_size;
+	u32	array_gen;
 };
 
 struct ifs_work {
diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
index 0c8927916373..934eaf348f9d 100644
--- a/drivers/platform/x86/intel/ifs/core.c
+++ b/drivers/platform/x86/intel/ifs/core.c
@@ -11,16 +11,16 @@
 
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
@@ -100,6 +100,7 @@ static int __init ifs_init(void)
 			continue;
 		ifs_devices[i].rw_data.generation = FIELD_GET(MSR_INTEGRITY_CAPS_SAF_GEN_MASK,
 							      msrval);
+		ifs_devices[i].rw_data.array_gen = (u32)m->driver_data;
 		ret = misc_register(&ifs_devices[i].misc);
 		if (ret)
 			goto err_exit;
diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
index a29f7b8fa48e..bf3310bedcdc 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -326,6 +326,38 @@ static void ifs_array_test_core(int cpu, struct device *dev)
 		ifsd->status = SCAN_TEST_PASS;
 }
 
+#define ARRAY_GEN1_TEST_ALL_ARRAYS	0x0ULL
+#define ARRAY_GEN1_STATUS_FAIL		0x1ULL
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
+	u64 status = 0;
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
@@ -353,7 +385,10 @@ int do_core_test(int cpu, struct device *dev)
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

