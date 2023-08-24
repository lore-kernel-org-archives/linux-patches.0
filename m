Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5424614A81
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 17:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA84C433C7;
	Thu, 24 Aug 2023 17:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692897471;
	bh=9Rq60ciq67Bgu6wD5AtqgdQ1b/w0DXy0UTeTwxD9Bsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bWxccRRMZx9HOUqKhwJf3442geS9LRih31uJ4AJWGqt6nAwJvv3D+JWlDqtlaNSEP
	 ZIjGhPJxypF0nS8vSOnFwnQMBu2hX43ZDmtWcTRLpi268y/nLTSqjKHFXefu1vIkxH
	 cRpXUBnbUBFM+mgpTCjGy+yOmAkxzwrfs7zj5vTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hemant Kumar <hemantk@codeaurora.org>,
	Alex Elder <elder@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/135] bus: mhi: Move host MHI code to "host" directory
Date: Thu, 24 Aug 2023 19:08:42 +0200
Message-ID: <20230824170619.322043892@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>
References: <20230824170617.074557800@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit a0f5a630668cb8b2ebf5204f08e957875e991780 ]

In preparation of the endpoint MHI support, let's move the host MHI code
to its own "host" directory and adjust the toplevel MHI Kconfig & Makefile.

While at it, let's also move the "pci_generic" driver to "host" directory
as it is a host MHI controller driver.

Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>
Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20220301160308.107452-5-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 6a0c637bfee6 ("bus: mhi: host: Range check CHDBOFF and ERDBOFF")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/Makefile                      |  2 +-
 drivers/bus/mhi/Kconfig                   | 27 ++------------------
 drivers/bus/mhi/Makefile                  |  8 ++----
 drivers/bus/mhi/host/Kconfig              | 31 +++++++++++++++++++++++
 drivers/bus/mhi/{core => host}/Makefile   |  4 ++-
 drivers/bus/mhi/{core => host}/boot.c     |  0
 drivers/bus/mhi/{core => host}/debugfs.c  |  0
 drivers/bus/mhi/{core => host}/init.c     |  0
 drivers/bus/mhi/{core => host}/internal.h |  0
 drivers/bus/mhi/{core => host}/main.c     |  0
 drivers/bus/mhi/{ => host}/pci_generic.c  |  0
 drivers/bus/mhi/{core => host}/pm.c       |  0
 12 files changed, 39 insertions(+), 33 deletions(-)
 create mode 100644 drivers/bus/mhi/host/Kconfig
 rename drivers/bus/mhi/{core => host}/Makefile (54%)
 rename drivers/bus/mhi/{core => host}/boot.c (100%)
 rename drivers/bus/mhi/{core => host}/debugfs.c (100%)
 rename drivers/bus/mhi/{core => host}/init.c (100%)
 rename drivers/bus/mhi/{core => host}/internal.h (100%)
 rename drivers/bus/mhi/{core => host}/main.c (100%)
 rename drivers/bus/mhi/{ => host}/pci_generic.c (100%)
 rename drivers/bus/mhi/{core => host}/pm.c (100%)

diff --git a/drivers/bus/Makefile b/drivers/bus/Makefile
index 397e35392bff8..16c47a0616ae4 100644
--- a/drivers/bus/Makefile
+++ b/drivers/bus/Makefile
@@ -38,4 +38,4 @@ obj-$(CONFIG_VEXPRESS_CONFIG)	+= vexpress-config.o
 obj-$(CONFIG_DA8XX_MSTPRI)	+= da8xx-mstpri.o
 
 # MHI
-obj-$(CONFIG_MHI_BUS)		+= mhi/
+obj-y				+= mhi/
diff --git a/drivers/bus/mhi/Kconfig b/drivers/bus/mhi/Kconfig
index da5cd0c9fc620..4748df7f9cd58 100644
--- a/drivers/bus/mhi/Kconfig
+++ b/drivers/bus/mhi/Kconfig
@@ -2,30 +2,7 @@
 #
 # MHI bus
 #
-# Copyright (c) 2018-2020, The Linux Foundation. All rights reserved.
+# Copyright (c) 2021, Linaro Ltd.
 #
 
-config MHI_BUS
-	tristate "Modem Host Interface (MHI) bus"
-	help
-	  Bus driver for MHI protocol. Modem Host Interface (MHI) is a
-	  communication protocol used by the host processors to control
-	  and communicate with modem devices over a high speed peripheral
-	  bus or shared memory.
-
-config MHI_BUS_DEBUG
-	bool "Debugfs support for the MHI bus"
-	depends on MHI_BUS && DEBUG_FS
-	help
-	  Enable debugfs support for use with the MHI transport. Allows
-	  reading and/or modifying some values within the MHI controller
-	  for debug and test purposes.
-
-config MHI_BUS_PCI_GENERIC
-	tristate "MHI PCI controller driver"
-	depends on MHI_BUS
-	depends on PCI
-	help
-	  This driver provides MHI PCI controller driver for devices such as
-	  Qualcomm SDX55 based PCIe modems.
-
+source "drivers/bus/mhi/host/Kconfig"
diff --git a/drivers/bus/mhi/Makefile b/drivers/bus/mhi/Makefile
index 0a2d778d6fb42..5f5708a249f54 100644
--- a/drivers/bus/mhi/Makefile
+++ b/drivers/bus/mhi/Makefile
@@ -1,6 +1,2 @@
-# core layer
-obj-y += core/
-
-obj-$(CONFIG_MHI_BUS_PCI_GENERIC) += mhi_pci_generic.o
-mhi_pci_generic-y += pci_generic.o
-
+# Host MHI stack
+obj-y += host/
diff --git a/drivers/bus/mhi/host/Kconfig b/drivers/bus/mhi/host/Kconfig
new file mode 100644
index 0000000000000..da5cd0c9fc620
--- /dev/null
+++ b/drivers/bus/mhi/host/Kconfig
@@ -0,0 +1,31 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# MHI bus
+#
+# Copyright (c) 2018-2020, The Linux Foundation. All rights reserved.
+#
+
+config MHI_BUS
+	tristate "Modem Host Interface (MHI) bus"
+	help
+	  Bus driver for MHI protocol. Modem Host Interface (MHI) is a
+	  communication protocol used by the host processors to control
+	  and communicate with modem devices over a high speed peripheral
+	  bus or shared memory.
+
+config MHI_BUS_DEBUG
+	bool "Debugfs support for the MHI bus"
+	depends on MHI_BUS && DEBUG_FS
+	help
+	  Enable debugfs support for use with the MHI transport. Allows
+	  reading and/or modifying some values within the MHI controller
+	  for debug and test purposes.
+
+config MHI_BUS_PCI_GENERIC
+	tristate "MHI PCI controller driver"
+	depends on MHI_BUS
+	depends on PCI
+	help
+	  This driver provides MHI PCI controller driver for devices such as
+	  Qualcomm SDX55 based PCIe modems.
+
diff --git a/drivers/bus/mhi/core/Makefile b/drivers/bus/mhi/host/Makefile
similarity index 54%
rename from drivers/bus/mhi/core/Makefile
rename to drivers/bus/mhi/host/Makefile
index c3feb4130aa37..859c2f38451c6 100644
--- a/drivers/bus/mhi/core/Makefile
+++ b/drivers/bus/mhi/host/Makefile
@@ -1,4 +1,6 @@
 obj-$(CONFIG_MHI_BUS) += mhi.o
-
 mhi-y := init.o main.o pm.o boot.o
 mhi-$(CONFIG_MHI_BUS_DEBUG) += debugfs.o
+
+obj-$(CONFIG_MHI_BUS_PCI_GENERIC) += mhi_pci_generic.o
+mhi_pci_generic-y += pci_generic.o
diff --git a/drivers/bus/mhi/core/boot.c b/drivers/bus/mhi/host/boot.c
similarity index 100%
rename from drivers/bus/mhi/core/boot.c
rename to drivers/bus/mhi/host/boot.c
diff --git a/drivers/bus/mhi/core/debugfs.c b/drivers/bus/mhi/host/debugfs.c
similarity index 100%
rename from drivers/bus/mhi/core/debugfs.c
rename to drivers/bus/mhi/host/debugfs.c
diff --git a/drivers/bus/mhi/core/init.c b/drivers/bus/mhi/host/init.c
similarity index 100%
rename from drivers/bus/mhi/core/init.c
rename to drivers/bus/mhi/host/init.c
diff --git a/drivers/bus/mhi/core/internal.h b/drivers/bus/mhi/host/internal.h
similarity index 100%
rename from drivers/bus/mhi/core/internal.h
rename to drivers/bus/mhi/host/internal.h
diff --git a/drivers/bus/mhi/core/main.c b/drivers/bus/mhi/host/main.c
similarity index 100%
rename from drivers/bus/mhi/core/main.c
rename to drivers/bus/mhi/host/main.c
diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/host/pci_generic.c
similarity index 100%
rename from drivers/bus/mhi/pci_generic.c
rename to drivers/bus/mhi/host/pci_generic.c
diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/host/pm.c
similarity index 100%
rename from drivers/bus/mhi/core/pm.c
rename to drivers/bus/mhi/host/pm.c
-- 
2.40.1



