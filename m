Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907E97C
	for <patches@lists.linux.dev>; Tue,  1 Mar 2022 19:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646164575; x=1677700575;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Fl34ROTLcd+eMllC9hzRVku13lC3x4b2npFrIe2SmFc=;
  b=QsnqapRzD8XloKV8BRgTjPXlcqvjS72fBZMUr9E4T+TZtXj8UUxLsFEV
   HBtJYnO+EEz9pDDwHJ5ug18NJ8KfmSPTPq735Oe+aBWxxQ9K35kaMZGGH
   D3xPvqhbu2LOmzJshBnPacOpBY/d1wBMsaAHXAMpWegvRiUVmhPshAS54
   BpIt5GftXmLgH7QymL/r6xSnAxo0n85cOBUjaQHe69eGa64urEO50XZsE
   /0ViNQdEFDAitVpRfUDQjKWeyGDm58zuaZukDOg7KxMWJa4ybYCVnyxdD
   PEi8M3fI9OXhSPov694l/2JukSiVg8EdMv2r05NMftxzmt4bsyb7Xj9Qa
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10273"; a="233842079"
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="233842079"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 11:55:54 -0800
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="630133183"
Received: from coffy.sc.intel.com ([10.3.79.166])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 11:55:54 -0800
From: Jithu Joseph <jithu.joseph@intel.com>
To: hdegoede@redhat.com,
	markgross@kernel.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	corbet@lwn.net,
	gregkh@linuxfoundation.org,
	andriy.shevchenko@linux.intel.com,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	rostedt@goodmis.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com
Subject: [RFC 10/10] trace: platform/x86/intel/ifs: Add trace point to track Intel IFS operations
Date: Tue,  1 Mar 2022 11:54:57 -0800
Message-Id: <20220301195457.21152-11-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220301195457.21152-1-jithu.joseph@intel.com>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Tony Luck <tony.luck@intel.com>

Add tracing support which may be useful for debugging systems that fail to complete
In Field Scan tests.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/platform/x86/intel/ifs/core.c |  5 ++++
 include/trace/events/ifs.h            | 38 +++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)
 create mode 100644 include/trace/events/ifs.h

diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
index c9ca385082e9..dec2a72eb95a 100644
--- a/drivers/platform/x86/intel/ifs/core.c
+++ b/drivers/platform/x86/intel/ifs/core.c
@@ -13,6 +13,9 @@
 
 #include "ifs.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/ifs.h>
+
 static enum cpuhp_state cpuhp_scan_state;
 struct ifs_params ifs_params;
 int cpu_sibl_ct;
@@ -217,6 +220,8 @@ static int scan_test_worker(void *info)
 
 			rdmsrl(MSR_SCAN_STATUS, status.data);
 
+			trace_ifs_status(activate, status);
+
 			/* Some cases can be retried, give up for others */
 			if (!can_restart(status))
 				break;
diff --git a/include/trace/events/ifs.h b/include/trace/events/ifs.h
new file mode 100644
index 000000000000..3c6ef33c7b3b
--- /dev/null
+++ b/include/trace/events/ifs.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM ifs
+
+#if !defined(_TRACE_IFS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_IFS_H
+
+#include <linux/ktime.h>
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(ifs_status,
+
+	TP_PROTO(union ifs_scan activate, union ifs_status status),
+
+	TP_ARGS(activate, status),
+
+	TP_STRUCT__entry(
+		__field(	u8,	start	)
+		__field(	u8,	stop	)
+		__field(	u64,	status	)
+	),
+
+	TP_fast_assign(
+		__entry->start	= activate.start;
+		__entry->stop	= activate.stop;
+		__entry->status	= status.data;
+	),
+
+	TP_printk("start: %.2x, stop: %.2x, status: %llx",
+		__entry->start,
+		__entry->stop,
+		__entry->status)
+);
+
+#endif /* _TRACE_IFS_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
2.17.1

