Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3AC24E019;
	Mon, 23 Jun 2025 13:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685188; cv=none; b=aq5YUkRAJfVQHwqd7i3OyazEJBY55NNRTx0LStJ0f2yj+N59Cff97NIUpMulNVj9V6Yz2xt7dGX1XjBGySvLPVLjD7RBue7RY+0crNLy7jYVmRutoQNqawMdVZMpiqKdMNWDv4TEPM1daC/FtHO/wJhrK8s+yLLSu7RPQYmPLXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685188; c=relaxed/simple;
	bh=QYk016cU+/VScHnPh/XRLJdNVvvQf3BRcQS8F/zEQB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRhvVvNbo+9FO3kksYHMvBoWbSxZu+jKnGTBIqpkq5tW3EoBC4AB/LeIcQ8J9toS61ygvmX8cy89IB/WXwf/BBnrum00bgX02AidGiNwnjL8P3yxjlxj5xkbjOoStbZYmqW0Bv5BHw5A4HiVdYOHKJWjuinKfS5xOWyFfAjmbeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Emnc1kys; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Emnc1kys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028F5C4CEEA;
	Mon, 23 Jun 2025 13:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685188;
	bh=QYk016cU+/VScHnPh/XRLJdNVvvQf3BRcQS8F/zEQB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Emnc1kysYjBx/8GJhNaoSlmJCjpHlrw12oZYFdN05dgoENPJoVHTGqBpbxgpphpWQ
	 rBo2x2JUEo0QyEnPYAIuZmhtdbYMBSNmddFAzonUBmEQBZctKc7nZnWYyfBdRyt+Ns
	 gpAdtm8xh98NQ0B1y6FekZdQY1O0FFMt7bAFUrAI=
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
Subject: [PATCH 5.10 033/355] firmware: SDEI: Allow sdei initialization without ACPI_APEI_GHES
Date: Mon, 23 Jun 2025 15:03:54 +0200
Message-ID: <20250623130627.805901717@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a83101310e34f..67023e184bb17 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -72,7 +72,6 @@ config ARM_SCPI_POWER_DOMAIN
 config ARM_SDE_INTERFACE
 	bool "ARM Software Delegated Exception Interface (SDEI)"
 	depends on ARM64
-	depends on ACPI_APEI_GHES
 	help
 	  The Software Delegated Exception Interface (SDEI) is an ARM
 	  standard for registering callbacks from the platform firmware
diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
index b160851c524cf..0fbf12df19d04 100644
--- a/drivers/firmware/arm_sdei.c
+++ b/drivers/firmware/arm_sdei.c
@@ -1063,13 +1063,12 @@ static bool __init sdei_present_acpi(void)
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
@@ -1082,6 +1081,12 @@ void __init sdei_init(void)
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



