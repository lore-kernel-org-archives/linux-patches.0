Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D2062E
	for <patches@lists.linux.dev>; Wed, 13 Sep 2023 18:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694630284; x=1726166284;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z8Z0UQUOAbWvwtFJniXI4N/ipWPW87ZWVEGdjD0eBS0=;
  b=Zr55Kcgp8CQo5W8xxe3QvSZJCxD5hyJezGzCfQCoHJMFSZY2bitTE6MJ
   ms3EP4FnKx766d/xUZhu3e/gYsBKJrJEojcXgHJcb0w1296qNbU5i4lWE
   mw9elBkLmcuJFkKqj6jXy/EJANVQa3NjsYbVTN9r0POQvywMV4neCjjKn
   b+VtR/QAmwHVEjadfLYt0oTRw3DIwKd1FpfBtjcTVBsNlr7fAJ+VZWBUj
   1Gzk8kmqFXNE/mJxxPrWEAvYs6HKXgwwZzl6LgiXHpA+oahelEppMMudW
   cUDI5qkLEYHlrRRPJifDCPQ0m//FzMhC8UpBGjR4Lw78Z8PP/ANpHiQ96
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="369019157"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="369019157"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 11:37:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="744238587"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="744238587"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 11:37:55 -0700
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
Subject: [PATCH 05/10] trace: platform/x86/intel/ifs: Modify scan trace
Date: Wed, 13 Sep 2023 11:33:43 -0700
Message-Id: <20230913183348.1349409-6-jithu.joseph@intel.com>
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

Account for the 8/16 bit MSR bitfield width differences between
gen0 and newer generations in the scan trace path.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
---
 include/trace/events/intel_ifs.h         | 16 ++++++++--------
 drivers/platform/x86/intel/ifs/runtest.c |  2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/trace/events/intel_ifs.h b/include/trace/events/intel_ifs.h
index d7353024016c..af0af3f1d9b7 100644
--- a/include/trace/events/intel_ifs.h
+++ b/include/trace/events/intel_ifs.h
@@ -10,25 +10,25 @@
 
 TRACE_EVENT(ifs_status,
 
-	TP_PROTO(int cpu, union ifs_scan activate, union ifs_status status),
+	TP_PROTO(int cpu, int start, int stop, u64 status),
 
-	TP_ARGS(cpu, activate, status),
+	TP_ARGS(cpu, start, stop, status),
 
 	TP_STRUCT__entry(
 		__field(	u64,	status	)
 		__field(	int,	cpu	)
-		__field(	u8,	start	)
-		__field(	u8,	stop	)
+		__field(	u16,	start	)
+		__field(	u16,	stop	)
 	),
 
 	TP_fast_assign(
 		__entry->cpu	= cpu;
-		__entry->start	= activate.start;
-		__entry->stop	= activate.stop;
-		__entry->status	= status.data;
+		__entry->start	= start;
+		__entry->stop	= stop;
+		__entry->status	= status;
 	),
 
-	TP_printk("cpu: %d, start: %.2x, stop: %.2x, status: %llx",
+	TP_printk("cpu: %d, start: %.4x, stop: %.4x, status: %.16llx",
 		__entry->cpu,
 		__entry->start,
 		__entry->stop,
diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
index 4bbab6be2fa2..ba3f9ad88a82 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -206,7 +206,7 @@ static void ifs_test_core(int cpu, struct device *dev)
 
 		status.data = msrvals[1];
 
-		trace_ifs_status(cpu, activate, status);
+		trace_ifs_status(cpu, to_start, to_stop, status.data);
 
 		/* Some cases can be retried, give up for others */
 		if (!can_restart(status))
-- 
2.25.1

