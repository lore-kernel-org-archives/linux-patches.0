Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0536548E8A
	for <patches@lists.linux.dev>; Fri, 22 Sep 2023 23:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695425418; x=1726961418;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cxXofeerr15tyc6seHR71QAwrN0OZbSQ1GKIOtuE5kg=;
  b=OqYNovNwY5zfa/rS5haqkxVYGFJhjfVyPfKm2BmZKdyS0XZRHy4Cz7Qq
   uGTDbxjB0jECdXWpdoVZGDyjmmH/MWHKq+ooUPzxQxFWIkrP8pMU+HmIy
   vOJ8DX5yB/fOZQaA8P7wD25VW9+CYuOf3kco+s7dt0YjgTtkbCP0brGGl
   E0hj9EKfEe2JF3KY/38K7CN6daL/B/ByNl+/OpMClXI8PiNAZRdBKqu23
   dTYTb7K9ilwAKWV1GKWXyVt6uNauTKJ5YqlsiFpNvZGsw9oualiCE1cmC
   MPMBJA4loKnqLOlwAhV7AhLC8hjA8267TQRDna8RKb8RkdNdyav+kACgg
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="411896958"
X-IronPort-AV: E=Sophos;i="6.03,169,1694761200"; 
   d="scan'208";a="411896958"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2023 16:30:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="921350837"
X-IronPort-AV: E=Sophos;i="6.03,169,1694761200"; 
   d="scan'208";a="921350837"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2023 16:30:12 -0700
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
Subject: [PATCH v2 4/9] platform/x86/intel/ifs: Gen2 Scan test support
Date: Fri, 22 Sep 2023 16:26:01 -0700
Message-Id: <20230922232606.1928026-5-jithu.joseph@intel.com>
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

Width of chunk related bitfields is ACTIVATE_SCAN and SCAN_STATUS MSRs
are different in newer IFS generation compared to gen0.

Make changes to scan test flow such that MSRs are populated
appropriately based on the generation supported by hardware.

Account for the 8/16 bit MSR bitfield width differences between gen0 and
newer generations for the scan test trace event too.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
---
 drivers/platform/x86/intel/ifs/ifs.h     | 28 +++++++++++++++++++-----
 include/trace/events/intel_ifs.h         | 16 +++++++-------
 drivers/platform/x86/intel/ifs/runtest.c | 26 ++++++++++++++++------
 3 files changed, 49 insertions(+), 21 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
index 43281d456a09..cd213b89d278 100644
--- a/drivers/platform/x86/intel/ifs/ifs.h
+++ b/drivers/platform/x86/intel/ifs/ifs.h
@@ -199,9 +199,17 @@ union ifs_chunks_auth_status_gen2 {
 union ifs_scan {
 	u64	data;
 	struct {
-		u32	start	:8;
-		u32	stop	:8;
-		u32	rsvd	:16;
+		union {
+			struct {
+				u8	start;
+				u8	stop;
+				u16	rsvd;
+			} gen0;
+			struct {
+				u16	start;
+				u16	stop;
+			} gen2;
+		};
 		u32	delay	:31;
 		u32	sigmce	:1;
 	};
@@ -211,9 +219,17 @@ union ifs_scan {
 union ifs_status {
 	u64	data;
 	struct {
-		u32	chunk_num		:8;
-		u32	chunk_stop_index	:8;
-		u32	rsvd1			:16;
+		union {
+			struct {
+				u8	chunk_num;
+				u8	chunk_stop_index;
+				u16	rsvd1;
+			} gen0;
+			struct {
+				u16	chunk_num;
+				u16	chunk_stop_index;
+			} gen2;
+		};
 		u32	error_code		:8;
 		u32	rsvd2			:22;
 		u32	control_error		:1;
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
index 1061eb7ec399..94d486e5d263 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -171,21 +171,30 @@ static void ifs_test_core(int cpu, struct device *dev)
 	union ifs_status status;
 	unsigned long timeout;
 	struct ifs_data *ifsd;
+	int to_start, to_stop;
+	int status_chunk;
 	u64 msrvals[2];
 	int retries;
 
 	ifsd = ifs_get_data(dev);
 
-	activate.rsvd = 0;
 	activate.delay = IFS_THREAD_WAIT;
 	activate.sigmce = 0;
-	activate.start = 0;
-	activate.stop = ifsd->valid_chunks - 1;
+	to_start = 0;
+	to_stop = ifsd->valid_chunks - 1;
+
+	if (ifsd->generation) {
+		activate.gen2.start = to_start;
+		activate.gen2.stop = to_stop;
+	} else {
+		activate.gen0.start = to_start;
+		activate.gen0.stop = to_stop;
+	}
 
 	timeout = jiffies + HZ / 2;
 	retries = MAX_IFS_RETRIES;
 
-	while (activate.start <= activate.stop) {
+	while (to_start <= to_stop) {
 		if (time_after(jiffies, timeout)) {
 			status.error_code = IFS_SW_TIMEOUT;
 			break;
@@ -196,13 +205,14 @@ static void ifs_test_core(int cpu, struct device *dev)
 
 		status.data = msrvals[1];
 
-		trace_ifs_status(cpu, activate, status);
+		trace_ifs_status(cpu, to_start, to_stop, status.data);
 
 		/* Some cases can be retried, give up for others */
 		if (!can_restart(status))
 			break;
 
-		if (status.chunk_num == activate.start) {
+		status_chunk = ifsd->generation ? status.gen2.chunk_num : status.gen0.chunk_num;
+		if (status_chunk == to_start) {
 			/* Check for forward progress */
 			if (--retries == 0) {
 				if (status.error_code == IFS_NO_ERROR)
@@ -211,7 +221,9 @@ static void ifs_test_core(int cpu, struct device *dev)
 			}
 		} else {
 			retries = MAX_IFS_RETRIES;
-			activate.start = status.chunk_num;
+			ifsd->generation ? (activate.gen2.start = status_chunk) :
+			(activate.gen0.start = status_chunk);
+			to_start = status_chunk;
 		}
 	}
 
-- 
2.25.1

