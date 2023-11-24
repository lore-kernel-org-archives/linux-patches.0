Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500362511F;
	Fri, 24 Nov 2023 18:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XWm0Z3wB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A0BC433C8;
	Fri, 24 Nov 2023 18:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849701;
	bh=C1obxVqTt1hEOSqXgCtn/BLDX/Vpv7mWnlYiB9MFYAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XWm0Z3wBSuzYhzr+/hZa5XNumeekmQc60lRdb3lf+X116XPI+d7HJK8V1V0XgpkUZ
	 l3vozXfO181Xka2CSW1ihUU9yyyYaDGBDSHVUEVgnVxrOMOHoYCnC53Ki9WPX5amha
	 khRHJM1l38HtQdIYVHFRsQVcmhmdlYz6piPbu3DU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	Jason Andryuk <jandryuk@gmail.com>,
	Michal Wilczynski <michal.wilczynski@intel.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.6 268/530] acpi/processor: sanitize _OSC/_PDC capabilities for Xen dom0
Date: Fri, 24 Nov 2023 17:47:14 +0000
Message-ID: <20231124172036.190614961@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Pau Monne <roger.pau@citrix.com>

commit bfa993b355d33a438a746523e7129391c8664e8a upstream.

The Processor capability bits notify ACPI of the OS capabilities, and
so ACPI can adjust the return of other Processor methods taking the OS
capabilities into account.

When Linux is running as a Xen dom0, the hypervisor is the entity
in charge of processor power management, and hence Xen needs to make
sure the capabilities reported by _OSC/_PDC match the capabilities of
the driver in Xen.

Introduce a small helper to sanitize the buffer when running as Xen
dom0.

When Xen supports HWP, this serves as the equivalent of commit
a21211672c9a ("ACPI / processor: Request native thermal interrupt
handling via _OSC") to avoid SMM crashes.  Xen will set bit
ACPI_PROC_CAP_COLLAB_PROC_PERF (bit 12) in the capability bits and the
_OSC/_PDC call will apply it.

[ jandryuk: Mention Xen HWP's need.  Support _OSC & _PDC ]
Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
Reviewed-by: Michal Wilczynski <michal.wilczynski@intel.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20231108212517.72279-1-jandryuk@gmail.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/acpi.h           |   14 ++++++++++++++
 arch/x86/include/asm/xen/hypervisor.h |    9 +++++++++
 drivers/xen/pcpu.c                    |   22 ++++++++++++++++++++++
 3 files changed, 45 insertions(+)

--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -16,6 +16,9 @@
 #include <asm/x86_init.h>
 #include <asm/cpufeature.h>
 #include <asm/irq_vectors.h>
+#include <asm/xen/hypervisor.h>
+
+#include <xen/xen.h>
 
 #ifdef CONFIG_ACPI_APEI
 # include <asm/pgtable_types.h>
@@ -127,6 +130,17 @@ static inline void arch_acpi_set_proc_ca
 	if (!cpu_has(c, X86_FEATURE_MWAIT) ||
 	    boot_option_idle_override == IDLE_NOMWAIT)
 		*cap &= ~(ACPI_PROC_CAP_C_C1_FFH | ACPI_PROC_CAP_C_C2C3_FFH);
+
+	if (xen_initial_domain()) {
+		/*
+		 * When Linux is running as Xen dom0, the hypervisor is the
+		 * entity in charge of the processor power management, and so
+		 * Xen needs to check the OS capabilities reported in the
+		 * processor capabilities buffer matches what the hypervisor
+		 * driver supports.
+		 */
+		xen_sanitize_proc_cap_bits(cap);
+	}
 }
 
 static inline bool acpi_has_cpu_in_madt(void)
--- a/arch/x86/include/asm/xen/hypervisor.h
+++ b/arch/x86/include/asm/xen/hypervisor.h
@@ -100,4 +100,13 @@ static inline void leave_lazy(enum xen_l
 
 enum xen_lazy_mode xen_get_lazy_mode(void);
 
+#if defined(CONFIG_XEN_DOM0) && defined(CONFIG_ACPI)
+void xen_sanitize_proc_cap_bits(uint32_t *buf);
+#else
+static inline void xen_sanitize_proc_cap_bits(uint32_t *buf)
+{
+	BUG();
+}
+#endif
+
 #endif /* _ASM_X86_XEN_HYPERVISOR_H */
--- a/drivers/xen/pcpu.c
+++ b/drivers/xen/pcpu.c
@@ -47,6 +47,9 @@
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
 
+#ifdef CONFIG_ACPI
+#include <acpi/processor.h>
+#endif
 
 /*
  * @cpu_id: Xen physical cpu logic number
@@ -400,4 +403,23 @@ bool __init xen_processor_present(uint32
 
 	return online;
 }
+
+void xen_sanitize_proc_cap_bits(uint32_t *cap)
+{
+	struct xen_platform_op op = {
+		.cmd			= XENPF_set_processor_pminfo,
+		.u.set_pminfo.id	= -1,
+		.u.set_pminfo.type	= XEN_PM_PDC,
+	};
+	u32 buf[3] = { ACPI_PDC_REVISION_ID, 1, *cap };
+	int ret;
+
+	set_xen_guest_handle(op.u.set_pminfo.pdc, buf);
+	ret = HYPERVISOR_platform_op(&op);
+	if (ret)
+		pr_err("sanitize of _PDC buffer bits from Xen failed: %d\n",
+		       ret);
+	else
+		*cap = buf[2];
+}
 #endif


