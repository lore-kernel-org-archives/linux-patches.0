Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A701375
	for <patches@lists.linux.dev>; Tue, 19 Apr 2022 16:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650386352; x=1681922352;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GiGJaH71F5oTpM1VXhMQYtv9L+oZv5Oh7aW9Jy9k+CQ=;
  b=X+ZWXoyl7yOAI84i+O+SE4r0Qq97VN48eJFx5UBWd3lN1N9MMKEd8/sr
   xwC0pYf2cgy7DV9jsg6Zka6iUc0uiIMYkD4uYvw+8BK44mTu9jrxc2lWm
   kVl4LKiJbj7/5vF0SW5wxUjkIjodcAVZ9jG7seVxgz8QRrIvd8NKaRvM5
   zxf3wFFRu+KuwMGJoLQSc+x546pSLT+MoDpfPavO12RwdWfGjJ76Rfxai
   AgbUv3YGVpE6aPLHLmMpywB7IAzD+ddKi9UJibFL3oNrN0VwF/0zr6vDo
   asYy+4akRzZaJChKgPt4j5RzXknWR6IuySjCh03sKiogIEgSN0wZK6aSi
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="244395739"
X-IronPort-AV: E=Sophos;i="5.90,273,1643702400"; 
   d="scan'208";a="244395739"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 09:39:10 -0700
X-IronPort-AV: E=Sophos;i="5.90,273,1643702400"; 
   d="scan'208";a="554802172"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 09:39:09 -0700
From: Tony Luck <tony.luck@intel.com>
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
	dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com
Subject: [PATCH v3 10/11] trace: platform/x86/intel/ifs: Add trace point to track Intel IFS operations
Date: Tue, 19 Apr 2022 09:38:58 -0700
Message-Id: <20220419163859.2228874-11-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419163859.2228874-1-tony.luck@intel.com>
References: <20220407191347.9681-1-jithu.joseph@intel.com>
 <20220419163859.2228874-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add tracing support which may be useful for debugging systems that fail to complete
In Field Scan tests.

Reviewed-by: Dan Williams <dan.j.williams@intel.com
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 MAINTAINERS                              |  1 +
 drivers/platform/x86/intel/ifs/runtest.c |  5 ++++
 include/trace/events/intel_ifs.h         | 38 ++++++++++++++++++++++++
 3 files changed, 44 insertions(+)
 create mode 100644 include/trace/events/intel_ifs.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 9e372a960fa5..b488ff628a43 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9867,6 +9867,7 @@ R:	Ashok Raj <ashok.raj@intel.com>
 R:	Tony Luck <tony.luck@intel.com>
 S:	Maintained
 F:	drivers/platform/x86/intel/ifs
+F:	include/trace/events/intel_ifs.h
 
 INTEL INTEGRATED SENSOR HUB DRIVER
 M:	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
index 246eff250563..c6fa9385dda0 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -24,6 +24,9 @@ static atomic_t siblings_out;
 static int cpu_sibl_ct;
 static bool scan_enabled = true;
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/intel_ifs.h>
+
 struct ifs_work {
 	struct work_struct w;
 	struct device *dev;
@@ -217,6 +220,8 @@ static void ifs_work_func(struct work_struct *work)
 
 		rdmsrl(MSR_SCAN_STATUS, status.data);
 
+		trace_ifs_status(activate, status);
+
 		/* Some cases can be retried, give up for others */
 		if (!can_restart(status))
 			break;
diff --git a/include/trace/events/intel_ifs.h b/include/trace/events/intel_ifs.h
new file mode 100644
index 000000000000..0611f370cb37
--- /dev/null
+++ b/include/trace/events/intel_ifs.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM intel_ifs
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
+		__field(	u64,	status	)
+		__field(	u8,	start	)
+		__field(	u8,	stop	)
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
2.35.1

