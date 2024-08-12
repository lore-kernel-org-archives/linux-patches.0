Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4461EA8D;
	Mon, 12 Aug 2024 16:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478729; cv=none; b=g5wsalkkGXSrc9ledcUemISBTe81D+gN/eGXbiSOGpGj04IqH8x4MdgtEpHsw4WG7tOt8YYk2D4Iv4M71QA37RqQl7FjcU3fCiwv37gLlswu9HEXiH6ufoYEjhoV8l9uBVGa6SaxzShvCs7Rduw0fDlvhhbwQ2jiiOs81SfnRCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478729; c=relaxed/simple;
	bh=KnehJxiYEYUZaivjZp/Nj/7axDHAaLyIt3NpQhLZOAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VL9RZUtY8eRL+C1bb+TcZYAl+aoPQT139SsjTQLgymIcZ8+mKUuQ3zkHacDbIoVAIzpKGHFQ2TNeJtTGOsgBO7Su59mdV3Nvegwto4mgF7NmGrswpcCyYtl8exbwdEnGHniiFFvFHW4RZLDbzv2+xVgXCwmHyVX0bG4iAz8FzVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1r6Ekv5O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1r6Ekv5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8DAC32782;
	Mon, 12 Aug 2024 16:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478729;
	bh=KnehJxiYEYUZaivjZp/Nj/7axDHAaLyIt3NpQhLZOAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1r6Ekv5OLdwvWuKHveIky2FOXU0Fx14ruiAobBh7dDPml5dUStENSy2fEFbxkE3Vb
	 L4Q0DSn5OVtHtM4Fnozyynf8I6mBTFIWxAzFS99iwDfL+MwyebZMmPbK/TAUVyRHgU
	 eTIs6XGXN9ftbdz0hFBTl3NS4wlAvtnb4McUtKZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jithu Joseph <jithu.joseph@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Pengfei Xu <pengfei.xu@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/150] platform/x86/intel/ifs: Gen2 Scan test support
Date: Mon, 12 Aug 2024 18:01:23 +0200
Message-ID: <20240812160125.242223269@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jithu Joseph <jithu.joseph@intel.com>

[ Upstream commit 72b96ee29ed6f7670bbb180ba694816e33d361d1 ]

Width of chunk related bitfields is ACTIVATE_SCAN and SCAN_STATUS MSRs
are different in newer IFS generation compared to gen0.

Make changes to scan test flow such that MSRs are populated
appropriately based on the generation supported by hardware.

Account for the 8/16 bit MSR bitfield width differences between gen0 and
newer generations for the scan test trace event too.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
Link: https://lore.kernel.org/r/20231005195137.3117166-5-jithu.joseph@intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 3114f77e9453 ("platform/x86/intel/ifs: Initialize union ifs_status to zero")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/ifs/ifs.h     | 28 ++++++++++++++++++-----
 drivers/platform/x86/intel/ifs/runtest.c | 29 ++++++++++++++++++------
 include/trace/events/intel_ifs.h         | 16 ++++++-------
 3 files changed, 52 insertions(+), 21 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
index 73c8e91cf144d..1902a1722df1e 100644
--- a/drivers/platform/x86/intel/ifs/ifs.h
+++ b/drivers/platform/x86/intel/ifs/ifs.h
@@ -157,9 +157,17 @@ union ifs_chunks_auth_status {
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
@@ -169,9 +177,17 @@ union ifs_scan {
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
diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
index b2ca2bb4501f6..d6bc2f0b61a34 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -169,21 +169,31 @@ static void ifs_test_core(int cpu, struct device *dev)
 	union ifs_status status;
 	unsigned long timeout;
 	struct ifs_data *ifsd;
+	int to_start, to_stop;
+	int status_chunk;
 	u64 msrvals[2];
 	int retries;
 
 	ifsd = ifs_get_data(dev);
 
-	activate.rsvd = 0;
+	activate.gen0.rsvd = 0;
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
@@ -194,13 +204,14 @@ static void ifs_test_core(int cpu, struct device *dev)
 
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
@@ -209,7 +220,11 @@ static void ifs_test_core(int cpu, struct device *dev)
 			}
 		} else {
 			retries = MAX_IFS_RETRIES;
-			activate.start = status.chunk_num;
+			if (ifsd->generation)
+				activate.gen2.start = status_chunk;
+			else
+				activate.gen0.start = status_chunk;
+			to_start = status_chunk;
 		}
 	}
 
diff --git a/include/trace/events/intel_ifs.h b/include/trace/events/intel_ifs.h
index d7353024016cc..af0af3f1d9b7c 100644
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
-- 
2.43.0



