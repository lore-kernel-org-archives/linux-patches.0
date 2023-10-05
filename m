Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9514176A
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 19:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hs5Wxl9O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696535752; x=1728071752;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U2Lr0pfVDqRHalBrvCeshsIcvSYCxtMoo95ef61DmXc=;
  b=hs5Wxl9O84V91otTjb2gL5dv/DRmIdBQw9kN3xZzsKE56Ugvdejx2zQf
   RuJampatEkeKPWBbPKXVNOE/uylElSx3kmaptpVB0MZNB5dSA1mGCpSOd
   7m15MPyUCN69fxXiBTxKhBlUedFf18aSRxUseoEqFMSulQyXNKgIpawdh
   jEGmGoUYghB5mqcSIkQ21e8m6vJ9pfLEKuEthj43gJymkHTCmm/svU6lI
   Dq4wXDF/t+ZtbSuPsQpfBVasaQip7Zc2kXYThnEPvAo8yf2km5edlki4l
   j2Mvi7KeDoPx3dwVN2bRlnab4Qoql4pWf/csz70aanSYdIUijEaKOSXRu
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10854"; a="386432604"
X-IronPort-AV: E=Sophos;i="6.03,203,1694761200"; 
   d="scan'208";a="386432604"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 12:55:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10854"; a="755600146"
X-IronPort-AV: E=Sophos;i="6.03,203,1694761200"; 
   d="scan'208";a="755600146"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 12:55:45 -0700
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
Subject: [PATCH v4 9/9] platform/x86/intel/ifs: ARRAY BIST for Sierra Forest
Date: Thu,  5 Oct 2023 12:51:37 -0700
Message-Id: <20231005195137.3117166-10-jithu.joseph@intel.com>
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
Content-Transfer-Encoding: 8bit

Array BIST MSR addresses, bit definition and semantics are different for
Sierra Forest. Branch into a separate Array BIST flow on Sierra Forest
when user invokes Array Test.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
---
 drivers/platform/x86/intel/ifs/ifs.h     |  7 +++++
 drivers/platform/x86/intel/ifs/core.c    | 15 +++++-----
 drivers/platform/x86/intel/ifs/runtest.c | 37 +++++++++++++++++++++++-
 3 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
index f0dd849b3400..2dd5e3406dac 100644
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
@@ -146,6 +148,9 @@
 #define IFS_TYPE_SAF			0
 #define IFS_TYPE_ARRAY_BIST		1
 
+#define ARRAY_GEN_0			0
+#define ARRAY_GEN_1			1
+
 /* MSR_SCAN_HASHES_STATUS bit fields */
 union ifs_scan_hashes_status {
 	u64	data;
@@ -272,6 +277,7 @@ struct ifs_test_caps {
  * @cur_batch: number indicating the currently loaded test file
  * @generation: IFS test generation enumerated by hardware
  * @chunk_size: size of a test chunk
+ * @array_gen: test generation of array test
  */
 struct ifs_data {
 	int	loaded_version;
@@ -283,6 +289,7 @@ struct ifs_data {
 	u32	cur_batch;
 	u32	generation;
 	u32	chunk_size;
+	u32	array_gen;
 };
 
 struct ifs_work {
diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
index 0c8927916373..0a872b874af8 100644
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
+	X86_MATCH(SAPPHIRERAPIDS_X, ARRAY_GEN_0),
+	X86_MATCH(EMERALDRAPIDS_X, ARRAY_GEN_0),
+	X86_MATCH(GRANITERAPIDS_X, ARRAY_GEN_0),
+	X86_MATCH(GRANITERAPIDS_D, ARRAY_GEN_0),
+	X86_MATCH(ATOM_CRESTMONT_X, ARRAY_GEN_1),
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
index 4fe544d79946..9ac75420c15e 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -329,6 +329,38 @@ static void ifs_array_test_core(int cpu, struct device *dev)
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
@@ -356,7 +388,10 @@ int do_core_test(int cpu, struct device *dev)
 		ifs_test_core(cpu, dev);
 		break;
 	case IFS_TYPE_ARRAY_BIST:
-		ifs_array_test_core(cpu, dev);
+		if (ifsd->array_gen == ARRAY_GEN_0)
+			ifs_array_test_core(cpu, dev);
+		else
+			ifs_array_test_gen1(cpu, dev);
 		break;
 	default:
 		return -EINVAL;
-- 
2.25.1

