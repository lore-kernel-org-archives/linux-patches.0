Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C12F7BB16;
	Wed, 21 Feb 2024 14:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524010; cv=none; b=TcaNRIYIpcgOUxQjPwKMBBE5GN8U/zn+vThPx0Dr+ekdHBcDltsgB0TUDDWE1QgVE099wNpLwAwzyN18qwwE8kVvKQuB1/FxQmCC56HoXMTbnpMnzH3PEAoGY9JhQrRX8vvgI9Z+h3T1TcjzC/qYLmTdizcySubwmS9jXmNl+mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524010; c=relaxed/simple;
	bh=pqPPMU6wWLCngCg8eGE6Av+MmRrqz0rKvezz0ari/zQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y75r/JK91+d4u5yZJi6yn4NXAsJNo0wkU0Ho06Pva5Ui9Gi1xhkE17CgfibXmaRPMOEOng9MiX+iQGo0YmymRtuI/TpkeDAEfSGx+STAP+4+mUqE++0/YF5zbKfFL4MnCoiefD8tq2wIVBuxKRGcpiIQb+nrjGMB3GwEQsaMv28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FJ+BBO3v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FJ+BBO3v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA38C433C7;
	Wed, 21 Feb 2024 14:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524010;
	bh=pqPPMU6wWLCngCg8eGE6Av+MmRrqz0rKvezz0ari/zQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FJ+BBO3vmmgGLPTW9PUWfP4mLr1XDH0WPzNGxL7I0wigOO72IDR4QbjG5/LgSsKmD
	 XWXxu5LhUIw9vF/IB5eQnLTb4UQbOsQU7w/Kxf3B2sokx9SdSdmgSCTHiSmlShJkBk
	 qbsrCSRpy3ssQOsqJfswxsX3aNPZAR3qoIvS2uM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Ma Wupeng <mawupeng1@huawei.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Xiaofei Tan <tanxiaofei@huawei.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	James Morse <james.morse@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 117/379] ACPI: APEI: set memory failure flags as MF_ACTION_REQUIRED on synchronous events
Date: Wed, 21 Feb 2024 14:04:56 +0100
Message-ID: <20240221125958.389074357@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuai Xue <xueshuai@linux.alibaba.com>

[ Upstream commit a70297d2213253853e95f5b49651f924990c6d3b ]

There are two major types of uncorrected recoverable (UCR) errors :

 - Synchronous error: The error is detected and raised at the point of
   the consumption in the execution flow, e.g. when a CPU tries to
   access a poisoned cache line. The CPU will take a synchronous error
   exception such as Synchronous External Abort (SEA) on Arm64 and
   Machine Check Exception (MCE) on X86. OS requires to take action (for
   example, offline failure page/kill failure thread) to recover this
   uncorrectable error.

 - Asynchronous error: The error is detected out of processor execution
   context, e.g. when an error is detected by a background scrubber.
   Some data in the memory are corrupted. But the data have not been
   consumed. OS is optional to take action to recover this uncorrectable
   error.

When APEI firmware first is enabled, a platform may describe one error
source for the handling of synchronous errors (e.g. MCE or SEA notification
), or for handling asynchronous errors (e.g. SCI or External Interrupt
notification). In other words, we can distinguish synchronous errors by
APEI notification. For synchronous errors, kernel will kill the current
process which accessing the poisoned page by sending SIGBUS with
BUS_MCEERR_AR. In addition, for asynchronous errors, kernel will notify the
process who owns the poisoned page by sending SIGBUS with BUS_MCEERR_AO in
early kill mode. However, the GHES driver always sets mf_flags to 0 so that
all synchronous errors are handled as asynchronous errors in memory failure.

To this end, set memory failure flags as MF_ACTION_REQUIRED on synchronous
events.

Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Tested-by: Ma Wupeng <mawupeng1@huawei.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Xiaofei Tan <tanxiaofei@huawei.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/ghes.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 8678e162181f..160606af8b4f 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -99,6 +99,20 @@ static inline bool is_hest_type_generic_v2(struct ghes *ghes)
 	return ghes->generic->header.type == ACPI_HEST_TYPE_GENERIC_ERROR_V2;
 }
 
+/*
+ * A platform may describe one error source for the handling of synchronous
+ * errors (e.g. MCE or SEA), or for handling asynchronous errors (e.g. SCI
+ * or External Interrupt). On x86, the HEST notifications are always
+ * asynchronous, so only SEA on ARM is delivered as a synchronous
+ * notification.
+ */
+static inline bool is_hest_sync_notify(struct ghes *ghes)
+{
+	u8 notify_type = ghes->generic->notify.type;
+
+	return notify_type == ACPI_HEST_NOTIFY_SEA;
+}
+
 /*
  * This driver isn't really modular, however for the time being,
  * continuing to use module_param is the easiest way to remain
@@ -461,7 +475,7 @@ static bool ghes_do_memory_failure(u64 physical_addr, int flags)
 }
 
 static bool ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata,
-				       int sev)
+				       int sev, bool sync)
 {
 	int flags = -1;
 	int sec_sev = ghes_severity(gdata->error_severity);
@@ -475,7 +489,7 @@ static bool ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata,
 	    (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED))
 		flags = MF_SOFT_OFFLINE;
 	if (sev == GHES_SEV_RECOVERABLE && sec_sev == GHES_SEV_RECOVERABLE)
-		flags = 0;
+		flags = sync ? MF_ACTION_REQUIRED : 0;
 
 	if (flags != -1)
 		return ghes_do_memory_failure(mem_err->physical_addr, flags);
@@ -483,9 +497,11 @@ static bool ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata,
 	return false;
 }
 
-static bool ghes_handle_arm_hw_error(struct acpi_hest_generic_data *gdata, int sev)
+static bool ghes_handle_arm_hw_error(struct acpi_hest_generic_data *gdata,
+				       int sev, bool sync)
 {
 	struct cper_sec_proc_arm *err = acpi_hest_get_payload(gdata);
+	int flags = sync ? MF_ACTION_REQUIRED : 0;
 	bool queued = false;
 	int sec_sev, i;
 	char *p;
@@ -510,7 +526,7 @@ static bool ghes_handle_arm_hw_error(struct acpi_hest_generic_data *gdata, int s
 		 * and don't filter out 'corrected' error here.
 		 */
 		if (is_cache && has_pa) {
-			queued = ghes_do_memory_failure(err_info->physical_fault_addr, 0);
+			queued = ghes_do_memory_failure(err_info->physical_fault_addr, flags);
 			p += err_info->length;
 			continue;
 		}
@@ -631,6 +647,7 @@ static bool ghes_do_proc(struct ghes *ghes,
 	const guid_t *fru_id = &guid_null;
 	char *fru_text = "";
 	bool queued = false;
+	bool sync = is_hest_sync_notify(ghes);
 
 	sev = ghes_severity(estatus->error_severity);
 	apei_estatus_for_each_section(estatus, gdata) {
@@ -648,13 +665,13 @@ static bool ghes_do_proc(struct ghes *ghes,
 			ghes_edac_report_mem_error(sev, mem_err);
 
 			arch_apei_report_mem_error(sev, mem_err);
-			queued = ghes_handle_memory_failure(gdata, sev);
+			queued = ghes_handle_memory_failure(gdata, sev, sync);
 		}
 		else if (guid_equal(sec_type, &CPER_SEC_PCIE)) {
 			ghes_handle_aer(gdata);
 		}
 		else if (guid_equal(sec_type, &CPER_SEC_PROC_ARM)) {
-			queued = ghes_handle_arm_hw_error(gdata, sev);
+			queued = ghes_handle_arm_hw_error(gdata, sev, sync);
 		} else {
 			void *err = acpi_hest_get_payload(gdata);
 
-- 
2.43.0



