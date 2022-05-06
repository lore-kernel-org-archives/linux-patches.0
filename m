Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496AE3D87
	for <patches@lists.linux.dev>; Fri,  6 May 2022 22:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651877664; x=1683413664;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UrSGBxwCGvd9hm8lvSEMIixJeqTEhSZoyFHz3/ZwcIQ=;
  b=Fc+51UGky+D2Assmf6oVo5iu3HTVggDNuYNTDaNQGx6FjoqSWtDpj43Y
   rhfX/njiSVBN6IwOI2VJQ6QL6Vc+NkBw+Xo94plL1lPsTx0vk6dedPls2
   GROyWi2Tx/ok9B91QLAvy/4OqIayMYhfoVX3Jk5/BF4yySiNnknFg7ELM
   IdneT6hL7E7Aa5WoUypuHtwuMLvRZ1bs13sEbsP1PmPljUlrmK5zuHjRm
   YlEyds+kkvxRzdLs15W7bLhKsTNIOcq62P9BLD5AfZergwhgfgnY2cEx2
   vdLpFi6VyQMay+BbAiUf9amd16FEYa5cJnFP3zvkdNyZfrCozYZUV6SEr
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="355030707"
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="355030707"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 15:54:21 -0700
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="695383647"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 15:54:21 -0700
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
Subject: [PATCH v7 10/12] trace: platform/x86/intel/ifs: Add trace point to track Intel IFS operations
Date: Fri,  6 May 2022 15:54:08 -0700
Message-Id: <20220506225410.1652287-11-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220506225410.1652287-1-tony.luck@intel.com>
References: <20220506014035.1173578-1-tony.luck@intel.com>
 <20220506225410.1652287-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add tracing support which may be useful for debugging systems that fail to complete
In Field Scan tests.

Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS                              |  1 +
 drivers/platform/x86/intel/ifs/runtest.c |  5 +++
 include/trace/events/intel_ifs.h         | 41 ++++++++++++++++++++++++
 3 files changed, 47 insertions(+)
 create mode 100644 include/trace/events/intel_ifs.h

diff --git a/MAINTAINERS b/MAINTAINERS
index bb0c4ff25942..6864fa039974 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9868,6 +9868,7 @@ R:	Ashok Raj <ashok.raj@intel.com>
 R:	Tony Luck <tony.luck@intel.com>
 S:	Maintained
 F:	drivers/platform/x86/intel/ifs
+F:	include/trace/events/intel_ifs.h
 
 INTEL INTEGRATED SENSOR HUB DRIVER
 M:	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
index 7efcce35e0e9..b2ca2bb4501f 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -17,6 +17,9 @@
  * core will update results of the test.
  */
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/intel_ifs.h>
+
 /* Max retries on the same chunk */
 #define MAX_IFS_RETRIES  5
 
@@ -191,6 +194,8 @@ static void ifs_test_core(int cpu, struct device *dev)
 
 		status.data = msrvals[1];
 
+		trace_ifs_status(cpu, activate, status);
+
 		/* Some cases can be retried, give up for others */
 		if (!can_restart(status))
 			break;
diff --git a/include/trace/events/intel_ifs.h b/include/trace/events/intel_ifs.h
new file mode 100644
index 000000000000..d7353024016c
--- /dev/null
+++ b/include/trace/events/intel_ifs.h
@@ -0,0 +1,41 @@
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
+	TP_PROTO(int cpu, union ifs_scan activate, union ifs_status status),
+
+	TP_ARGS(cpu, activate, status),
+
+	TP_STRUCT__entry(
+		__field(	u64,	status	)
+		__field(	int,	cpu	)
+		__field(	u8,	start	)
+		__field(	u8,	stop	)
+	),
+
+	TP_fast_assign(
+		__entry->cpu	= cpu;
+		__entry->start	= activate.start;
+		__entry->stop	= activate.stop;
+		__entry->status	= status.data;
+	),
+
+	TP_printk("cpu: %d, start: %.2x, stop: %.2x, status: %llx",
+		__entry->cpu,
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

