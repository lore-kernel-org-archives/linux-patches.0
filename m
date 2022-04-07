Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDCF2593
	for <patches@lists.linux.dev>; Thu,  7 Apr 2022 19:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649358864; x=1680894864;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=EpuU9FnJFmOX+BA1Irm1YxgXVJdK5TXoe/7lCiqp/zk=;
  b=lXQudSzWrFlPYYTMr+/0o4imC+2Hk58tiqAFf6/BWn8QUXwKNJOz475L
   665cnB71RRjI4+Iew/NLSPZ9RoqQRmhH6DNYQBsFu0MsTwU1sWQbpa33e
   WjZNukhGLIVlGAmNAoVBC8hCI1r575EJJ6QxzJRHAYXeEcEwQ39umVXK9
   G99bk/xXc6abOhJ1OybLSI6nMsOhnkfvtSFp3JeEYo7WNc5gIWP4ZDREf
   eEL3N0r56bdvQG0fyWZCp3VsrWX/bv7+MBCMrrjgSrMl8fTo+hTZmzWYq
   aATjyNn5+Nibs0wBuvcEuyVpk5kWPu2rrWuIbSKoTfLonfezVVa2sIjV/
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="322111015"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="322111015"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 12:14:19 -0700
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="571193735"
Received: from coffy.sc.intel.com ([10.3.79.166])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 12:14:19 -0700
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
	dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com
Subject: [PATCH v2 10/10] trace: platform/x86/intel/ifs: Add trace point to track Intel IFS operations
Date: Thu,  7 Apr 2022 12:13:47 -0700
Message-Id: <20220407191347.9681-11-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220407191347.9681-1-jithu.joseph@intel.com>
References: <20220407191347.9681-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Tony Luck <tony.luck@intel.com>

Add tracing support which may be useful for debugging systems that fail to complete
In Field Scan tests.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 drivers/platform/x86/intel/ifs/runtest.c |  5 ++++
 include/trace/events/intel_ifs.h         | 38 ++++++++++++++++++++++++
 2 files changed, 43 insertions(+)
 create mode 100644 include/trace/events/intel_ifs.h

diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
index f9c98d84183f..b9fac2ac7107 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -10,6 +10,9 @@
 
 #include "ifs.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/intel_ifs.h>
+
 bool ifs_disabled;
 
 static int ifs_retry_set(const char *val, const struct kernel_param *kp);
@@ -204,6 +207,8 @@ static void ifs_work_func(struct work_struct *work)
 
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
2.17.1

