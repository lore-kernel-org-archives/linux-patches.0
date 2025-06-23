Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9C930E84D;
	Mon, 23 Jun 2025 13:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685677; cv=none; b=gn0C/UGQpI2pRFpSbCxBMp5rV3T4smvrJ/1EG2UXHmkIjcyo/HFELzVZyBZV5njByGwRlvXvQkcGndknZN6zT0aT3w4ivJtYufSccioRC9mkXT7ZgRlcPFIVObvIKTH5zyM4Yf6RhbyvmbrWOcca5VHJaXa9+xMIrws3LVgWoUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685677; c=relaxed/simple;
	bh=SAxtojSf+yuuZtNE6wCuoXcaAjS9kbQk7S13Aw91jNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fw2ElBMRY118hJJh/v1W9M0hH1Gggt1NMgYnpOjulosu0itQvY1lfCCy2DG2vSL5yt5u9lktd3ALkq/nz7ZLkS2RmFkOMPIcSMxS0M5Ct/bGhp+YEROtmcGHenNbMfjB2QmhPXoDzOftp6NL25aFbNm+q+mciYzXiQJvM7DpBgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sFwQWHR5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sFwQWHR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12220C4CEF0;
	Mon, 23 Jun 2025 13:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685677;
	bh=SAxtojSf+yuuZtNE6wCuoXcaAjS9kbQk7S13Aw91jNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sFwQWHR5+1Nc17oQ9sqgkY+keVsyEeHaWGrpUuHoMR4Veztz5veFxaIC2nReWKXda
	 pEG/U0YcwQ+TLcpD4My9GZt1RJvW65C3dfN4crtZsUU8hOOh0uhTN5Fw0gxEp0vvvS
	 ab/KhMkwy9WcDr6aaSLQpP+Vp8pK6wsG0aPrV17s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Huang Yiwei <quic_hyiwei@quicinc.com>,
	Gavin Shan <gshan@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/411] firmware: SDEI: Allow sdei initialization without ACPI_APEI_GHES
Date: Mon, 23 Jun 2025 15:03:00 +0200
Message-ID: <20250623130634.089863809@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huang Yiwei <quic_hyiwei@quicinc.com>

[ Upstream commit 59529bbe642de4eb2191a541d9b4bae7eb73862e ]

SDEI usually initialize with the ACPI table, but on platforms where
ACPI is not used, the SDEI feature can still be used to handle
specific firmware calls or other customized purposes. Therefore, it
is not necessary for ARM_SDE_INTERFACE to depend on ACPI_APEI_GHES.

In commit dc4e8c07e9e2 ("ACPI: APEI: explicit init of HEST and GHES
in acpi_init()"), to make APEI ready earlier, sdei_init was moved
into acpi_ghes_init instead of being a standalone initcall, adding
ACPI_APEI_GHES dependency to ARM_SDE_INTERFACE. This restricts the
flexibility and usability of SDEI.

This patch corrects the dependency in Kconfig and splits sdei_init()
into two separate functions: sdei_init() and acpi_sdei_init().
sdei_init() will be called by arch_initcall and will only initialize
the platform driver, while acpi_sdei_init() will initialize the
device from acpi_ghes_init() when ACPI is ready. This allows the
initialization of SDEI without ACPI_APEI_GHES enabled.

Fixes: dc4e8c07e9e2 ("ACPI: APEI: explicit init of HEST and GHES in apci_init()")
Cc: Shuai Xue <xueshuai@linux.alibaba.com>
Signed-off-by: Huang Yiwei <quic_hyiwei@quicinc.com>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/20250507045757.2658795-1-quic_hyiwei@quicinc.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/Kconfig   |  1 +
 drivers/acpi/apei/ghes.c    |  2 +-
 drivers/firmware/Kconfig    |  1 -
 drivers/firmware/arm_sdei.c | 11 ++++++++---
 include/linux/arm_sdei.h    |  4 ++--
 5 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
index 6b18f8bc7be35..71e0d64a7792e 100644
--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -23,6 +23,7 @@ config ACPI_APEI_GHES
 	select ACPI_HED
 	select IRQ_WORK
 	select GENERIC_ALLOCATOR
+	select ARM_SDE_INTERFACE if ARM64
 	help
 	  Generic Hardware Error Source provides a way to report
 	  platform hardware errors (such as that from chipset). It
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index a6c8514110736..72087e05b5a5f 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -1478,7 +1478,7 @@ void __init ghes_init(void)
 {
 	int rc;
 
-	sdei_init();
+	acpi_sdei_init();
 
 	if (acpi_disabled)
 		return;
diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index b4d83c08acef8..059cb18f4bece 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -40,7 +40,6 @@ config ARM_SCPI_POWER_DOMAIN
 config ARM_SDE_INTERFACE
 	bool "ARM Software Delegated Exception Interface (SDEI)"
 	depends on ARM64
-	depends on ACPI_APEI_GHES
 	help
 	  The Software Delegated Exception Interface (SDEI) is an ARM
 	  standard for registering callbacks from the platform firmware
diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
index 3e8051fe82965..71e2a9a89f6ad 100644
--- a/drivers/firmware/arm_sdei.c
+++ b/drivers/firmware/arm_sdei.c
@@ -1062,13 +1062,12 @@ static bool __init sdei_present_acpi(void)
 	return true;
 }
 
-void __init sdei_init(void)
+void __init acpi_sdei_init(void)
 {
 	struct platform_device *pdev;
 	int ret;
 
-	ret = platform_driver_register(&sdei_driver);
-	if (ret || !sdei_present_acpi())
+	if (!sdei_present_acpi())
 		return;
 
 	pdev = platform_device_register_simple(sdei_driver.driver.name,
@@ -1081,6 +1080,12 @@ void __init sdei_init(void)
 	}
 }
 
+static int __init sdei_init(void)
+{
+	return platform_driver_register(&sdei_driver);
+}
+arch_initcall(sdei_init);
+
 int sdei_event_handler(struct pt_regs *regs,
 		       struct sdei_registered_event *arg)
 {
diff --git a/include/linux/arm_sdei.h b/include/linux/arm_sdei.h
index 255701e1251b4..f652a5028b590 100644
--- a/include/linux/arm_sdei.h
+++ b/include/linux/arm_sdei.h
@@ -46,12 +46,12 @@ int sdei_unregister_ghes(struct ghes *ghes);
 /* For use by arch code when CPU hotplug notifiers are not appropriate. */
 int sdei_mask_local_cpu(void);
 int sdei_unmask_local_cpu(void);
-void __init sdei_init(void);
+void __init acpi_sdei_init(void);
 void sdei_handler_abort(void);
 #else
 static inline int sdei_mask_local_cpu(void) { return 0; }
 static inline int sdei_unmask_local_cpu(void) { return 0; }
-static inline void sdei_init(void) { }
+static inline void acpi_sdei_init(void) { }
 static inline void sdei_handler_abort(void) { }
 #endif /* CONFIG_ARM_SDE_INTERFACE */
 
-- 
2.39.5



