Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795C24207F;
	Wed,  6 Nov 2024 12:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896262; cv=none; b=SNNDYodOZglYxxgVF8M0RAme/AeSbyfMNz2GGm3NdjQie1dZtiDYqKaIJyCA/XVPE3LE/hUXIRDvXqbmastK92RXb5p9ZUO7Y7t5sXkFULWwXNhvhKML28zJqcZ6bhp8zdJQp8hTkTx4WHZ/aXf9j79CDYCGRoh8WZWtUwkRMY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896262; c=relaxed/simple;
	bh=4Lqv67WK/agUJU9p1dm/pMwrrQRdHu/UIrZ3hQsQIGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4SO6YAI4IbWVfy9XNdAlqQJ0+ScH6o/ZQw/Rb+r1+BB6SFxZVJASjfopLjVeZviKjGs7dswlzEAFsPQvee5ebRe1gPcaTE/ohzgDCwIER53eC5hT7O4lSJ6+dNUks0aESkHFAc4J4vrxtYNze6orvR0D2pLa8Bs7gaQpRKOtho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PXWrV82t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PXWrV82t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82BBC4CECD;
	Wed,  6 Nov 2024 12:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896262;
	bh=4Lqv67WK/agUJU9p1dm/pMwrrQRdHu/UIrZ3hQsQIGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PXWrV82tp5Ub7hXVWuJmj9pRlsX5CKHcnt08onUp9E7AbzsYsyQpu0xpIPnFNMn+M
	 1ArYhekPbdRBBR+sElXLMS4bgmCGc99IFZDWD7OLP4XSHL83bL4GPGmDgA3G1+rDdl
	 vNAo8HQ5lhCTTt5VysSzqH+LKhrk+yQVyZ4mhcxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Price <gourry@gourry.net>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Alejandro Lucero <alucerop@amd.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.11 144/245] cxl/port: Fix CXL port initialization order when the subsystem is built-in
Date: Wed,  6 Nov 2024 13:03:17 +0100
Message-ID: <20241106120322.771576419@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 6575b268157f37929948a8d1f3bafb3d7c055bc1 upstream.

When the CXL subsystem is built-in the module init order is determined
by Makefile order. That order violates expectations. The expectation is
that cxl_acpi and cxl_mem can race to attach. If cxl_acpi wins the race,
cxl_mem will find the enabled CXL root ports it needs. If cxl_acpi loses
the race it will retrigger cxl_mem to attach via cxl_bus_rescan(). That
flow only works if cxl_acpi can assume ports are enabled immediately
upon cxl_acpi_probe() return. That in turn can only happen in the
CONFIG_CXL_ACPI=y case if the cxl_port driver is registered before
cxl_acpi_probe() runs.

Fix up the order to prevent initialization failures. Ensure that
cxl_port is built-in when cxl_acpi is also built-in, arrange for
Makefile order to resolve the subsys_initcall() order of cxl_port and
cxl_acpi, and arrange for Makefile order to resolve the
device_initcall() (module_init()) order of the remaining objects.

As for what contributed to this not being found earlier, the CXL
regression environment, cxl_test, builds all CXL functionality as a
module to allow to symbol mocking and other dynamic reload tests.  As a
result there is no regression coverage for the built-in case.

Reported-by: Gregory Price <gourry@gourry.net>
Closes: http://lore.kernel.org/20241004212504.1246-1-gourry@gourry.net
Tested-by: Gregory Price <gourry@gourry.net>
Fixes: 8dd2bc0f8e02 ("cxl/mem: Add the cxl_mem driver")
Cc: stable@vger.kernel.org
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Tested-by: Alejandro Lucero <alucerop@amd.com>
Reviewed-by: Alejandro Lucero <alucerop@amd.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Link: https://patch.msgid.link/172988474904.476062.7961350937442459266.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/Kconfig  |    1 +
 drivers/cxl/Makefile |   20 ++++++++++++++------
 drivers/cxl/port.c   |   17 ++++++++++++++++-
 3 files changed, 31 insertions(+), 7 deletions(-)

--- a/drivers/cxl/Kconfig
+++ b/drivers/cxl/Kconfig
@@ -60,6 +60,7 @@ config CXL_ACPI
 	default CXL_BUS
 	select ACPI_TABLE_LIB
 	select ACPI_HMAT
+	select CXL_PORT
 	help
 	  Enable support for host managed device memory (HDM) resources
 	  published by a platform's ACPI CXL memory layout description.  See
--- a/drivers/cxl/Makefile
+++ b/drivers/cxl/Makefile
@@ -1,13 +1,21 @@
 # SPDX-License-Identifier: GPL-2.0
+
+# Order is important here for the built-in case:
+# - 'core' first for fundamental init
+# - 'port' before platform root drivers like 'acpi' so that CXL-root ports
+#   are immediately enabled
+# - 'mem' and 'pmem' before endpoint drivers so that memdevs are
+#   immediately enabled
+# - 'pci' last, also mirrors the hardware enumeration hierarchy
 obj-y += core/
-obj-$(CONFIG_CXL_PCI) += cxl_pci.o
-obj-$(CONFIG_CXL_MEM) += cxl_mem.o
+obj-$(CONFIG_CXL_PORT) += cxl_port.o
 obj-$(CONFIG_CXL_ACPI) += cxl_acpi.o
 obj-$(CONFIG_CXL_PMEM) += cxl_pmem.o
-obj-$(CONFIG_CXL_PORT) += cxl_port.o
+obj-$(CONFIG_CXL_MEM) += cxl_mem.o
+obj-$(CONFIG_CXL_PCI) += cxl_pci.o
 
-cxl_mem-y := mem.o
-cxl_pci-y := pci.o
+cxl_port-y := port.o
 cxl_acpi-y := acpi.o
 cxl_pmem-y := pmem.o security.o
-cxl_port-y := port.o
+cxl_mem-y := mem.o
+cxl_pci-y := pci.o
--- a/drivers/cxl/port.c
+++ b/drivers/cxl/port.c
@@ -208,7 +208,22 @@ static struct cxl_driver cxl_port_driver
 	},
 };
 
-module_cxl_driver(cxl_port_driver);
+static int __init cxl_port_init(void)
+{
+	return cxl_driver_register(&cxl_port_driver);
+}
+/*
+ * Be ready to immediately enable ports emitted by the platform CXL root
+ * (e.g. cxl_acpi) when CONFIG_CXL_PORT=y.
+ */
+subsys_initcall(cxl_port_init);
+
+static void __exit cxl_port_exit(void)
+{
+	cxl_driver_unregister(&cxl_port_driver);
+}
+module_exit(cxl_port_exit);
+
 MODULE_DESCRIPTION("CXL: Port enumeration and services");
 MODULE_LICENSE("GPL v2");
 MODULE_IMPORT_NS(CXL);


