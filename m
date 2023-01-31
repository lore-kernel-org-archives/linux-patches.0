Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFD7AD2F
	for <patches@lists.linux.dev>; Tue, 31 Jan 2023 23:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675208699; x=1706744699;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ar2gkz6ChPb2jBvdRtwjD+KktDkQQZm5UI6aP2nLoyI=;
  b=VTrL32MIOLXVZTNvQKjwErU5iIxSiWKGLGTTdA8UcB7ncfCv47gUOp+g
   MYwhFVjyp0XuBIbNzvD55G5QPHDbNE3vVTLgpkvd5BqHogP//BXZnpZou
   w03H4hpeLD37NDXLnGqag+E+y2j1ufvNfgchTvjSfmrZB1LwlaSvEXJ7d
   vulc9mGWhiom/PmKtEbYgwLTyxCM9r1mPlWDxmIqrQ3fTOVHOVc7FfkOS
   xjnqMm6vqQ5lM/0gyeDuBuzzoKKgo6xdbNG1fVaT3DoirK+Vo6mDYFzwr
   eRRx82G5Cf4HR7G5WC69bkaZAWORjJu0YMmL8/WUqiJ6ZhlfhPXNoKhc4
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="390360432"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="390360432"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 15:44:56 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="773192033"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="773192033"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 15:44:55 -0800
From: Jithu Joseph <jithu.joseph@intel.com>
To: hdegoede@redhat.com,
	markgross@kernel.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	gregkh@linuxfoundation.org,
	rostedt@goodmis.org,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com,
	thiago.macieira@intel.com,
	athenas.jimenez.gonzalez@intel.com,
	sohil.mehta@intel.com
Subject: [PATCH 4/5] platform/x86/intel/ifs: Implement Array BIST test
Date: Tue, 31 Jan 2023 15:43:01 -0800
Message-Id: <20230131234302.3997223-5-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230131234302.3997223-1-jithu.joseph@intel.com>
References: <20230131234302.3997223-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Array BIST test (for a particlular core) is triggered by writing
to MSR_ARRAY_BIST from one sibling of the core.

This will initiate a test for all supported arrays on that
CPU. Array BIST test may be aborted before completing all the
arrays in the event of an interrupt or other reasons.
In this case, kernel will restart the test from that point
onwards. Array test will also be aborted when the test fails,
in which case the test is stopped immediately without further
retry.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
 drivers/platform/x86/intel/ifs/ifs.h     | 12 ++++
 drivers/platform/x86/intel/ifs/runtest.c | 92 ++++++++++++++++++++++++
 2 files changed, 104 insertions(+)

diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
index 07423bc4e368..b1a997e39216 100644
--- a/drivers/platform/x86/intel/ifs/ifs.h
+++ b/drivers/platform/x86/intel/ifs/ifs.h
@@ -127,6 +127,7 @@
 #include <linux/device.h>
 #include <linux/miscdevice.h>
 
+#define MSR_ARRAY_BIST				0x00000105
 #define MSR_COPY_SCAN_HASHES			0x000002c2
 #define MSR_SCAN_HASHES_STATUS			0x000002c3
 #define MSR_AUTHENTICATE_AND_COPY_CHUNK		0x000002c4
@@ -194,6 +195,17 @@ union ifs_status {
 	};
 };
 
+/* MSR_ARRAY_BIST bit fields */
+union ifs_array {
+	u64	data;
+	struct {
+		u32	array_bitmask		:32;
+		u32	array_bank		:16;
+		u32	rsvd			:15;
+		u32	ctrl_result		:1;
+	};
+};
+
 /*
  * Driver populated error-codes
  * 0xFD: Test timed out before completing all the chunks.
diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
index 65e08af70994..ec0ceb6b5890 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -229,6 +229,96 @@ static void ifs_test_core(int cpu, struct device *dev)
 	}
 }
 
+#define SPINUNIT 100 /* 100 nsec */
+static atomic_t array_cpus_out;
+
+/*
+ * Simplified cpu sibling rendezvous loop based on microcode loader __wait_for_cpus()
+ */
+static void wait_for_sibling_cpu(atomic_t *t, long long timeout)
+{
+	int cpu = smp_processor_id();
+	const struct cpumask *smt_mask = cpu_smt_mask(cpu);
+	int all_cpus = cpumask_weight(smt_mask);
+
+	atomic_inc(t);
+	while (atomic_read(t) < all_cpus) {
+		if (timeout < SPINUNIT)
+			return;
+		ndelay(SPINUNIT);
+		timeout -= SPINUNIT;
+		touch_nmi_watchdog();
+	}
+}
+
+static int do_array_test(void *data)
+{
+	int cpu = smp_processor_id();
+	u64 *msrs = data;
+	int first;
+
+	/*
+	 * Only one logical CPU on a core needs to trigger the Array test via MSR write.
+	 */
+	first = cpumask_first(cpu_smt_mask(cpu));
+
+	if (cpu == first) {
+		wrmsrl(MSR_ARRAY_BIST, msrs[0]);
+		/* Pass back the result of the test */
+		rdmsrl(MSR_ARRAY_BIST, msrs[1]);
+	}
+
+	/* Tests complete faster if the sibling is spinning here */
+	wait_for_sibling_cpu(&array_cpus_out, NSEC_PER_SEC);
+
+	return 0;
+}
+
+static void ifs_array_test_core(int cpu, struct device *dev)
+{
+	union ifs_array activate, status;
+	bool timed_out = false;
+	struct ifs_data *ifsd;
+	unsigned long timeout;
+	u64 msrvals[2];
+
+	ifsd = ifs_get_data(dev);
+
+	activate.data = 0;
+	activate.array_bitmask = ~0U;
+	activate.ctrl_result = 0;
+	timeout = jiffies + HZ / 2;
+
+	do {
+		if (time_after(jiffies, timeout)) {
+			timed_out = true;
+			break;
+		}
+
+		msrvals[0] = activate.data;
+
+		atomic_set(&array_cpus_out, 0);
+		stop_core_cpuslocked(cpu, do_array_test, msrvals);
+		status.data = msrvals[1];
+
+		if (status.ctrl_result)
+			break;
+
+		activate.array_bitmask = status.array_bitmask;
+		activate.array_bank = status.array_bank;
+
+	} while (status.array_bitmask);
+
+	ifsd->scan_details = status.data;
+
+	if (status.ctrl_result)
+		ifsd->status = SCAN_TEST_FAIL;
+	else if (timed_out || status.array_bitmask)
+		ifsd->status = SCAN_NOT_TESTED;
+	else
+		ifsd->status = SCAN_TEST_PASS;
+}
+
 /*
  * Initiate per core test. It wakes up work queue threads on the target cpu and
  * its sibling cpu. Once all sibling threads wake up, the scan test gets executed and
@@ -253,6 +343,8 @@ int do_core_test(int cpu, struct device *dev)
 		ifs_test_core(cpu, dev);
 		break;
 	case IFS_ARRAY:
+		ifs_array_test_core(cpu, dev);
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
2.25.1

