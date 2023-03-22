Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268ED15A6
	for <patches@lists.linux.dev>; Wed, 22 Mar 2023 00:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679445488; x=1710981488;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Jo23zFkwsDwbXcptMJ4++GJBxyXgWzFG3F/uuQmQl5Q=;
  b=CmZoU6wMWG6qjStj1V+Ln0cGOToV1AVbwRvmcxBCO/98Gx6BToR31Tp8
   mMpWgCnHneKlkYIJREu1SY0pkwwiIpxUh0Zl92SSpDsTqgcbycJf05c9Q
   1JiePf4NYart6lVvBIujsdeyORCcxjZLXcJno6KUEubxj4fvoKLEJ2v/y
   Z3U6Y9sKGBa5Ni9w/cMgerFcy82wKZc7zHCU0LjCWl9k2QpsAkyvieeiA
   MQ7E9Tg6vzlaIu7ZEm9+l9SNJXmBXlR7Dyzhox0OeM3nxuoHTlqdxJ7HT
   LfeywHSv8OgbHsn9sbO295LbfTx2NtE6QVbZo+TzL3QqLUepJQ9Vjm3JH
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="322934946"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="322934946"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 17:38:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="675076061"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="675076061"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 17:38:06 -0700
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
Subject: [PATCH v4 7/9] platform/x86/intel/ifs: Implement Array BIST test
Date: Tue, 21 Mar 2023 17:33:57 -0700
Message-Id: <20230322003359.213046-8-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230322003359.213046-1-jithu.joseph@intel.com>
References: <20230301015942.462799-1-jithu.joseph@intel.com>
 <20230322003359.213046-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Array BIST test (for a particular core) is triggered by writing
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
 drivers/platform/x86/intel/ifs/runtest.c | 81 ++++++++++++++++++++++++
 2 files changed, 93 insertions(+)

diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
index a7d87fb4c412..048131df13bc 100644
--- a/drivers/platform/x86/intel/ifs/ifs.h
+++ b/drivers/platform/x86/intel/ifs/ifs.h
@@ -127,6 +127,7 @@
 #include <linux/device.h>
 #include <linux/miscdevice.h>
 
+#define MSR_ARRAY_BIST				0x00000105
 #define MSR_COPY_SCAN_HASHES			0x000002c2
 #define MSR_SCAN_HASHES_STATUS			0x000002c3
 #define MSR_AUTHENTICATE_AND_COPY_CHUNK		0x000002c4
@@ -192,6 +193,17 @@ union ifs_status {
 	};
 };
 
+/* MSR_ARRAY_BIST bit fields */
+union ifs_array {
+	u64	data;
+	struct {
+		u32	array_bitmask;
+		u16	array_bank;
+		u16	rsvd			:15;
+		u16	ctrl_result		:1;
+	};
+};
+
 /*
  * Driver populated error-codes
  * 0xFD: Test timed out before completing all the chunks.
diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
index 323752fe5034..1061eb7ec399 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -229,6 +229,85 @@ static void ifs_test_core(int cpu, struct device *dev)
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
+	union ifs_array *command = data;
+	int cpu = smp_processor_id();
+	int first;
+
+	/*
+	 * Only one logical CPU on a core needs to trigger the Array test via MSR write.
+	 */
+	first = cpumask_first(cpu_smt_mask(cpu));
+
+	if (cpu == first) {
+		wrmsrl(MSR_ARRAY_BIST, command->data);
+		/* Pass back the result of the test */
+		rdmsrl(MSR_ARRAY_BIST, command->data);
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
+	union ifs_array command = {};
+	bool timed_out = false;
+	struct ifs_data *ifsd;
+	unsigned long timeout;
+
+	ifsd = ifs_get_data(dev);
+
+	command.array_bitmask = ~0U;
+	timeout = jiffies + HZ / 2;
+
+	do {
+		if (time_after(jiffies, timeout)) {
+			timed_out = true;
+			break;
+		}
+		atomic_set(&array_cpus_out, 0);
+		stop_core_cpuslocked(cpu, do_array_test, &command);
+
+		if (command.ctrl_result)
+			break;
+	} while (command.array_bitmask);
+
+	ifsd->scan_details = command.data;
+
+	if (command.ctrl_result)
+		ifsd->status = SCAN_TEST_FAIL;
+	else if (timed_out || command.array_bitmask)
+		ifsd->status = SCAN_NOT_TESTED;
+	else
+		ifsd->status = SCAN_TEST_PASS;
+}
+
 /*
  * Initiate per core test. It wakes up work queue threads on the target cpu and
  * its sibling cpu. Once all sibling threads wake up, the scan test gets executed and
@@ -256,6 +335,8 @@ int do_core_test(int cpu, struct device *dev)
 		ifs_test_core(cpu, dev);
 		break;
 	case IFS_TYPE_ARRAY_BIST:
+		ifs_array_test_core(cpu, dev);
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
2.25.1

