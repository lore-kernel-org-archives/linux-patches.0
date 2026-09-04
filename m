Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB1E30C366;
	Fri,  4 Sep 2026 05:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501171; cv=none; b=VlaE09Op/PMobW+2W3BzwCDXK03VtmFMrQLzDT79raMnD+2QowBhyUE7lUOU05+l5VW1oGYRoUVoRx1oFgixDZI3Errl0GPl/I2ct8kwxLMcCW/Aw7XEokPiE6eQBK3S+XPF5V5HAEQTBypWSSWtBCWkrB35tTaJVEnrfCZG9LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501171; c=relaxed/simple;
	bh=+vb/oOM6EjIbDRbqI94id+mOC/wdogDXIltJOFCYqiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evrTtsjL0+x7nEHlU9tQxo+AtH/5jLg351BtkfltBjEo+fp68CQamvE8fw+eOV4bYBI9kDN0Sx10qOj3M3GiYMrfKP+WbipwaYQo+w+qsGPUIY42Suy8aNzAcm+A83WrphwfoOdqcrvPJKSiJvF9x1Vuv8pqU1AIv/YlqDaQrHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A9z9f3Ii; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A9z9f3Ii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8001F00A3D;
	Fri,  4 Sep 2026 05:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501169;
	bh=VQIgUwcizAohAIC9o+qwJHcvmI754pvlW+IGDcWhzbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A9z9f3IikN1TApil+/sZBdBhW9QjVDzcZb1hY5hcrWHthMm+yjhQPaqlZt1Abo/1i
	 AHBM7Z++WvsnpL0FtNvvOQdo6aqGQWstIC7jc7+ooKSiZ1Sg50jhK5DS2io6y+PKiK
	 6KBwLJySK67oYad1mMPw7LSBYzz+tsBfBESkp3cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Yixun Lan <dlan@kernel.org>,
	Sunil V L <sunilvl@oss.qualcomm.com>,
	Huisong Li <lihuisong@huawei.com>,
	Peixin Xie <peixin.xie@linux.spacemit.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.18 316/552] riscv: acpi: Handle LPI architectural context loss flags
Date: Fri,  4 Sep 2026 06:57:53 +0200
Message-ID: <20260904045757.441844084@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peixin Xie <peixin.xie@linux.spacemit.com>

commit 7e4cb63d61a7e0bef20f0d00e831c7fac06e4a1c upstream.

Commit 4785aa802853 ("cpuidle, ACPI: Evaluate LPI arch_flags for
broadcast timer") replaced the generic nonzero check for LPI
architectural context loss flags with arch_get_idle_state_flags().
RISC-V does not implement the helper, so it falls back to the stub
that returns 0. Consequently, CPUIDLE_FLAG_TIMER_STOP is not set when
an LPI state loses the hart timer context, preventing cpuidle from
using a broadcast timer for that state.

Implement the RISC-V helper and map the hart timer context loss flag
to CPUIDLE_FLAG_TIMER_STOP.

Fixes: 4785aa802853 ("cpuidle, ACPI: Evaluate LPI arch_flags for broadcast timer")
Cc: stable@vger.kernel.org
Acked-by: Sudeep Holla <sudeep.holla@kernel.org>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Reviewed-by: Sunil V L <sunilvl@oss.qualcomm.com>
Reviewed-by: Huisong Li <lihuisong@huawei.com>
Signed-off-by: Peixin Xie <peixin.xie@linux.spacemit.com>
Link: https://patch.msgid.link/20260803-riscv-acpi-lpi-timer-v3-1-520fa13732f5@linux.spacemit.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/acpi.h |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/arch/riscv/include/asm/acpi.h
+++ b/arch/riscv/include/asm/acpi.h
@@ -12,6 +12,8 @@
 #ifndef _ASM_ACPI_H
 #define _ASM_ACPI_H
 
+#include <linux/cpuidle.h>
+
 /* Basic configuration for ACPI */
 #ifdef CONFIG_ACPI
 
@@ -71,6 +73,23 @@ int acpi_get_riscv_isa(struct acpi_table
 
 void acpi_get_cbo_block_size(struct acpi_table_header *table, u32 *cbom_size,
 			     u32 *cboz_size, u32 *cbop_size);
+
+/*
+ * RISC-V Functional Fixed Hardware Specification Version v1.0.1,
+ * Chapter 3.1.2, Table 4: Arch. Context Lost Flags
+ */
+#define RISCV_LPI_HART_TIMER_CTXT_LOST		BIT(0)
+
+static inline unsigned int arch_get_idle_state_flags(u32 arch_flags)
+{
+	if (arch_flags & RISCV_LPI_HART_TIMER_CTXT_LOST)
+		return CPUIDLE_FLAG_TIMER_STOP;
+
+	return 0;
+}
+
+#define arch_get_idle_state_flags arch_get_idle_state_flags
+
 #else
 static inline void acpi_init_rintc_map(void) { }
 static inline struct acpi_madt_rintc *acpi_cpu_get_madt_rintc(int cpu)


