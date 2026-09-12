Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89D6372ECF;
	Sat, 12 Sep 2026 08:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200420; cv=none; b=DZIjCwpoQfs5gaZNocZpHWWjBRuEsMC8JkZnSBKVRA/V7Y6Rj2JU/YF39MMpLclnO/DTY7uHaE1JQT+PQKfncAZ5317xyWPjBgrRaHO/fyVz65qLtnRM6L3eFXtkG9GWddEr1mfZ5vXitg0tc0LwyHxd1tjsN8Xcc81/+cubM2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200420; c=relaxed/simple;
	bh=nj+TSi/DQ2kXFE7IT4zLJf7hyikryzYieMSr3ZCADeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGDAfQbRuILloXTZVo91Q+BYQ4WSxeqJoUeuSnLcDVu67fYkhHgi338lO7YjNJkJL1Lb9GdoSExEMPNrJikBmOdaSxFQIm+MzsL17M+eRQlB2Ky6KM0cK78Vx5pSBfymyxbwL+lqjIs/hw/uUaTDNxvfS68/oNbxylErxVyBVDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BMzfQCJB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BMzfQCJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5845B1F000FF;
	Sat, 12 Sep 2026 08:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200418;
	bh=qhdbDBq68yRTndJcOSmZZYNpv4GVVyR9b/fwWnGvqZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BMzfQCJBzeDTsKhLQhnS0AE5wHHGneZMcBWvieCEqiVouHvnkH7za3QDmYWTcSYd1
	 poy+ddvnP/kd/JM1OIMA99j0drJknTsUT9zva3pKQWy70Oj1LK1gJdfsOiUjZdkqo7
	 U0UBp1ZvVYOBW83GbAIAvmGi5UBWItlGtTp2NzNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Yuvaraj Ranganathan <yuvaraj.ranganathan@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0787/1815] firmware: qcom: scm: add trace events for the SMC call interface
Date: Sat, 12 Sep 2026 08:42:17 +0200
Message-ID: <20260912065707.384148913@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuvaraj Ranganathan <yuvaraj.ranganathan@oss.qualcomm.com>

[ Upstream commit f6bb2daa4584229af155c2488b83151999315293 ]

The SCM SMC call path is opaque at runtime. Stalls caused by firmware
congestion, QCOM_SCM_WAITQ_SLEEP/RESUME cycles, and EBUSY retry loops
are invisible without recompiling the kernel with temporary printk
statements or attaching a hardware debugger.

Add five TRACE_EVENTs covering the complete lifecycle of an SCM call:

  scm_smc_request
    Emit before each arm_smccc_smc_quirk() invocation. Records the
    SMC function ID, decoded service and command identifiers, argument
    count, and up to six register arguments in hex and decimal. Because
    the caller loops on QCOM_SCM_INTERRUPTED, this event fires once per
    physical SMC instruction including inte

  scm_smc_done
    Emit after the outer __scm_smc_do() returns, pairing each
    request with its final outcome. Records the SMC function ID, the
    kernel error code returned to the caller, and the four firmware
    result registers a0-a3.

  scm_waitq_sleep
    Emit when the firmware returns QCOM_SCM_WAITQ_SLEEP. Records
    the wait-queue context and the SMC call context handles required
    to issue the matching WAITQ_RESUME.

  scm_waitq_resume
    Emit just before constructing and sending the WAITQ_RESUME
    follow-up call. Records the SMC call context handle being resumed.

  scm_waitq_get_wq_ctx
    Emit after a successful WAITQ_GET_WQ_CTX fast-call. Records
    the returned wait-queue context, flags, and more_pending indicator.

These events let ftrace and perf reconstruct the full sequence of
firmware interactions, measure per-call and end-to-end latency, and
attribute waitqueue stalls to specific service/command pairs without
modifying driver source.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Yuvaraj Ranganathan <yuvaraj.ranganathan@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260522-scm-tracepoints-v2-1-e27cdbe0c585@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 966d23c7e68e ("firmware: qcom: scm: Fix NULL dereference in IRQ handler before __scm is published")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/qcom_scm_trace.h | 143 +++++++++++++++++++++++++
 1 file changed, 143 insertions(+)
 create mode 100644 drivers/firmware/qcom/qcom_scm_trace.h

diff --git a/drivers/firmware/qcom/qcom_scm_trace.h b/drivers/firmware/qcom/qcom_scm_trace.h
new file mode 100644
index 0000000000000..6c911124fc56b
--- /dev/null
+++ b/drivers/firmware/qcom/qcom_scm_trace.h
@@ -0,0 +1,143 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
+ */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM qcom_scm
+
+#if !defined(_TRACE_SCM_SMC_INTERFACE_H) || defined(TRACE_HEADER_MULTI_READ)
+
+#define _TRACE_SCM_SMC_INTERFACE_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(scm_smc_request,
+
+	TP_PROTO(unsigned long a0, const struct arm_smccc_args *smc),
+
+	TP_ARGS(a0, smc),
+
+	TP_STRUCT__entry(
+		__field(u64, smc_id)
+		__field(u8, svc_id)
+		__field(u8, cmd_id)
+		__field(u8, args_cnt)
+		__dynamic_array(unsigned long, args,
+				min_t(u8, (smc->args[1] & 0xF), (u8)6))
+	),
+
+	TP_fast_assign(
+		__entry->smc_id = a0;
+		__entry->svc_id = (smc->args[0] >> 8) & 0xFF;
+		__entry->cmd_id = smc->args[0] & 0xFF;
+		u8 n = min_t(u8, (smc->args[1] & 0xF), (u8)6);
+
+		__entry->args_cnt = n;
+
+		unsigned long *dst = __get_dynamic_array(args);
+
+		for (int i = 0; i < n; i++)
+			dst[i] = smc->args[2 + i];
+	),
+
+	TP_printk("smc_id:0x%08llx svc_id:0x%02x cmd_id:0x%02x args_cnt:%u args:%s",
+		  __entry->smc_id, __entry->svc_id, __entry->cmd_id, __entry->args_cnt,
+		  __print_dynamic_array(args, sizeof(unsigned long)))
+);
+
+TRACE_EVENT(scm_waitq_sleep,
+
+	TP_PROTO(u32 wq_ctx, u32 smc_ctx),
+
+	TP_ARGS(wq_ctx, smc_ctx),
+
+	TP_STRUCT__entry(
+		__field(u32, wq_ctx)
+		__field(u32, smc_call_ctx)
+	),
+
+	TP_fast_assign(
+		__entry->wq_ctx = wq_ctx;
+		__entry->smc_call_ctx = smc_ctx;
+	),
+
+	TP_printk("wq_ctx:%u, smc_call_ctx:%u", __entry->wq_ctx, __entry->smc_call_ctx)
+);
+
+TRACE_EVENT(scm_waitq_resume,
+
+	TP_PROTO(u32 smc_ctx),
+
+	TP_ARGS(smc_ctx),
+
+	TP_STRUCT__entry(
+		__field(u32, smc_call_ctx)
+	),
+
+	TP_fast_assign(
+		__entry->smc_call_ctx = smc_ctx;
+	),
+
+	TP_printk("smc_call_ctx:%u", __entry->smc_call_ctx)
+);
+
+TRACE_EVENT(scm_waitq_get_wq_ctx,
+
+	TP_PROTO(u32 wq_ctx, u32 flags, u32 pending),
+
+	TP_ARGS(wq_ctx, flags, pending),
+
+	TP_STRUCT__entry(
+		__field(u32, wq_ctx)
+		__field(u32, flags)
+		__field(u32, more_pending)
+	),
+
+	TP_fast_assign(
+		__entry->wq_ctx = wq_ctx;
+		__entry->flags = flags;
+		__entry->more_pending = pending;
+	),
+
+	TP_printk("wq_ctx:%u, flags:%u, more_pending:%u",
+		  __entry->wq_ctx, __entry->flags, __entry->more_pending)
+);
+
+TRACE_EVENT(scm_smc_done,
+
+	TP_PROTO(int ret, u64 smc_id, struct arm_smccc_res *smc_res),
+
+	TP_ARGS(ret, smc_id, smc_res),
+
+	TP_STRUCT__entry(
+		__field(int, ret)
+		__field(u64, smc_id)
+		__field(unsigned long, res)
+		__field(unsigned long, res0)
+		__field(unsigned long, res1)
+		__field(unsigned long, res2)
+	),
+
+	TP_fast_assign(
+		__entry->ret = ret;
+		__entry->smc_id = smc_id;
+		__entry->res = smc_res->a0;
+		__entry->res0 = smc_res->a1;
+		__entry->res1 = smc_res->a2;
+		__entry->res2 = smc_res->a3;
+	),
+
+	TP_printk("smc_id:0x%08llx, ret:%d res_to_callee:0x%lx res0:0x%lx res1:0x%lx res2:0x%lx",
+		  __entry->smc_id, __entry->ret, __entry->res,
+		  __entry->res0, __entry->res1, __entry->res2)
+);
+
+#endif /* _TRACE_SCM_SMC_INTERFACE_H */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE qcom_scm_trace
+
+#include <trace/define_trace.h>
+
-- 
2.53.0



