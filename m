Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04C0EEC9;
	Tue, 10 Sep 2024 09:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962292; cv=none; b=lYpJhwSP+mzt5HZ6ZDxWYxH5uq5OgQInf8f2ND+8tFHH6ezxAlKby67+q7WRI+rAgkUe4cl1XeWaw8YER1828OVjIyZCoiMhk5++dMtJG1A0RK01T1L0zzY4y89HR0bDwJBCCSMzLBNa5+5UsSBMPH9b+tYeYLN4gmH1JD7iLUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962292; c=relaxed/simple;
	bh=LOeSfIQg3lqCSjid826tZPB6cmYmgn5Zk3aqViHJK9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CdBGEmoFbSV/6JBbCsbV2XArA2YojCI+gdKny6XVYJf7SW2fxbDPy0wOgjDSFM9s+C77luffecMbBqlF8xis/fEGT/TSFu4obwP+kStZfOJfqn5oCYxvOfDpdG+GmwFoDvYEST2YsScUHY2rml/Hl4/oZW1krvM0jGizSzyOdWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1fxjfCXk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1fxjfCXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46EA7C4CEC3;
	Tue, 10 Sep 2024 09:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962292;
	bh=LOeSfIQg3lqCSjid826tZPB6cmYmgn5Zk3aqViHJK9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1fxjfCXklCICV8bOiJRntB2oWMTMgdnYF+Jl1+unGEp6Ql+TCW0kU9W4XF/xBJ4aH
	 c3Y4KG4yI8QxtLms6ZRbH+gdXMwuz3fYd/YWM6/JevLNusRgTurFgoOJyAyOC32wK5
	 3d0infxmyxzSXgfTVZttc9HTkjohp0dEVW7weyX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jones <ajones@ventanamicro.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 360/375] riscv: Add tracepoints for SBI calls and returns
Date: Tue, 10 Sep 2024 11:32:37 +0200
Message-ID: <20240910092634.704439433@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Holland <samuel.holland@sifive.com>

[ Upstream commit 56c1c1a09ab93c7b7c957860f01f8600d6c03143 ]

These are useful for measuring the latency of SBI calls. The SBI HSM
extension is excluded because those functions are called from contexts
such as cpuidle where instrumentation is not allowed.

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Link: https://lore.kernel.org/r/20240321230131.1838105-1-samuel.holland@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Stable-dep-of: 1ff95eb2bebd ("riscv: Fix RISCV_ALTERNATIVE_EARLY")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/trace.h | 54 ++++++++++++++++++++++++++++++++++
 arch/riscv/kernel/sbi.c        |  7 +++++
 2 files changed, 61 insertions(+)
 create mode 100644 arch/riscv/include/asm/trace.h

diff --git a/arch/riscv/include/asm/trace.h b/arch/riscv/include/asm/trace.h
new file mode 100644
index 000000000000..6151cee5450c
--- /dev/null
+++ b/arch/riscv/include/asm/trace.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM riscv
+
+#if !defined(_TRACE_RISCV_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_RISCV_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT_CONDITION(sbi_call,
+	TP_PROTO(int ext, int fid),
+	TP_ARGS(ext, fid),
+	TP_CONDITION(ext != SBI_EXT_HSM),
+
+	TP_STRUCT__entry(
+		__field(int, ext)
+		__field(int, fid)
+	),
+
+	TP_fast_assign(
+		__entry->ext = ext;
+		__entry->fid = fid;
+	),
+
+	TP_printk("ext=0x%x fid=%d", __entry->ext, __entry->fid)
+);
+
+TRACE_EVENT_CONDITION(sbi_return,
+	TP_PROTO(int ext, long error, long value),
+	TP_ARGS(ext, error, value),
+	TP_CONDITION(ext != SBI_EXT_HSM),
+
+	TP_STRUCT__entry(
+		__field(long, error)
+		__field(long, value)
+	),
+
+	TP_fast_assign(
+		__entry->error = error;
+		__entry->value = value;
+	),
+
+	TP_printk("error=%ld value=0x%lx", __entry->error, __entry->value)
+);
+
+#endif /* _TRACE_RISCV_H */
+
+#undef TRACE_INCLUDE_PATH
+#undef TRACE_INCLUDE_FILE
+
+#define TRACE_INCLUDE_PATH asm
+#define TRACE_INCLUDE_FILE trace
+
+#include <trace/define_trace.h>
diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
index e66e0999a800..a1d21d8f5293 100644
--- a/arch/riscv/kernel/sbi.c
+++ b/arch/riscv/kernel/sbi.c
@@ -14,6 +14,9 @@
 #include <asm/smp.h>
 #include <asm/tlbflush.h>
 
+#define CREATE_TRACE_POINTS
+#include <asm/trace.h>
+
 /* default SBI version is 0.1 */
 unsigned long sbi_spec_version __ro_after_init = SBI_SPEC_VERSION_DEFAULT;
 EXPORT_SYMBOL(sbi_spec_version);
@@ -31,6 +34,8 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 {
 	struct sbiret ret;
 
+	trace_sbi_call(ext, fid);
+
 	register uintptr_t a0 asm ("a0") = (uintptr_t)(arg0);
 	register uintptr_t a1 asm ("a1") = (uintptr_t)(arg1);
 	register uintptr_t a2 asm ("a2") = (uintptr_t)(arg2);
@@ -46,6 +51,8 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 	ret.error = a0;
 	ret.value = a1;
 
+	trace_sbi_return(ext, ret.error, ret.value);
+
 	return ret;
 }
 EXPORT_SYMBOL(sbi_ecall);
-- 
2.43.0



