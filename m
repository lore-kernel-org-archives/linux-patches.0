Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E594D4195D2;
	Fri,  4 Sep 2026 06:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502626; cv=none; b=cf0+0qGsFmNx+RSnfv/7OE5FyNKKiDzAHSfWQRUBIhB5hoV/7a6jq40kLeaJEhp1/bG7x8thrd7DcdE1sZVlGe9g/TtTH0QGriiWx4g6fXmR/RYVf3n+mUuWzmRoOb376Aitp4B+2IcXREQmooQqguqQ0I5TI2TZJkBA8TIaRcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502626; c=relaxed/simple;
	bh=D0/OIBPFzNWHwcPDGS6lnRJgXTNmY3q16uWb3svHr9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxLsOIxV5391d9FQ9E6HEOnoiyk7PuSJGHR8mc8RQ2H1Cqo4ueb+JhOy7UCuUQKZu9tk1rtShJLMyew1RC9RW/jW3zQYZcHBHePeFSeouIbuoNo+37ZJ+PnzvFs/YqUP3FezhylGXqqED8SC/36nYqxaCdwRjUsF+hLNfn2oJzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pBFE2V69; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pBFE2V69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2531F00A3D;
	Fri,  4 Sep 2026 06:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502624;
	bh=ui+Lx77zKx07n1Qi3K1e4IUk6Nd7QL6xKlRCdoSGkPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pBFE2V69Ik3uDKFgnEwZto2CWfd8BTnR9n9ciye1sNu9wbHKy1BskqGvc3OwR32hV
	 mNGcKrH1MpTmLMkXGPIKtjR25jE+m4fIbEplEP47hotyP+EVpAoHv7beMjlPfJiOX0
	 vZUd5LzalNIepGtSJWRujlAk1uM3Oa/MElXcaRlc=
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
Subject: [PATCH 6.12 230/403] riscv: acpi: Handle LPI architectural context loss flags
Date: Fri,  4 Sep 2026 07:00:33 +0200
Message-ID: <20260904045740.095554736@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


