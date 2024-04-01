Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855671CA8F;
	Mon,  1 Apr 2024 16:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988995; cv=none; b=No8yk6dWJ5h/wzRRlLoAb4+sYEOfcY7onqvj/dbh5HU58n5pJnnjaINjxXasEy2GcDnVBY5Or0LN6WJJHc6PV5xKhNAU/wGfm4SqUQJN7elQ4kjIr06505hvJkJAC/r/h/k118PrEQuDciXcVrCd4HpNIbkwZaHVF743VcfKMsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988995; c=relaxed/simple;
	bh=pc+NPIS8ByHTlPuNBpsh5IthWBYUFug3v5JeuE4+1zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmKE09r4Jt1zhBv6JHwTjPJ+xiikUWul3GHR8Ox7kgAh8kKAWMD8geisSMltouvzhRSVdlxWJMO7QPTkkmxcLVhn/i7WNOA4SsSj8L8vYtwD3C0iCXGYhb+JS89YZpF1BS1CkLB7eOsscrO6XdoeUlM7sh7vqy9XLeigs9Nq7Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KF3QeyPH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KF3QeyPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DFCC433C7;
	Mon,  1 Apr 2024 16:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988995;
	bh=pc+NPIS8ByHTlPuNBpsh5IthWBYUFug3v5JeuE4+1zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KF3QeyPHggBafFBKbEX2+//ZhGhARWoiFccnaUhLn146b7OBlUaJQtiQYhX0UYoA+
	 JprrqU+Ug9yh526pHNhkZbCn5TD3bmSVi7wGkyitchnmmEkyZz9mKxRQTsK2cTPz/5
	 QjhRMg/rbGqPA2JNH/wBofGDUjKenXUUluvaKmhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandrs Vinarskis <alex.vinarskis@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.7 322/432] mfd: intel-lpss: Switch to generalized quirk table
Date: Mon,  1 Apr 2024 17:45:09 +0200
Message-ID: <20240401152602.803864741@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandrs Vinarskis <alex.vinarskis@gmail.com>

commit ac9538f6007e1c80f1b8a62db7ecc391b4d78ae5 upstream.

Introduce generic quirk table, and port existing walkaround for select
Microsoft devices to it. This is a preparation for
QUIRK_CLOCK_DIVIDER_UNITY.

Signed-off-by: Aleksandrs Vinarskis <alex.vinarskis@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20231221185142.9224-2-alex.vinarskis@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/intel-lpss-pci.c |   23 +++++++++++++++--------
 drivers/mfd/intel-lpss.c     |    2 +-
 drivers/mfd/intel-lpss.h     |    9 ++++++++-
 3 files changed, 24 insertions(+), 10 deletions(-)

--- a/drivers/mfd/intel-lpss-pci.c
+++ b/drivers/mfd/intel-lpss-pci.c
@@ -18,18 +18,24 @@
 
 #include "intel-lpss.h"
 
-/* Some DSDTs have an unused GEXP ACPI device conflicting with I2C4 resources */
-static const struct pci_device_id ignore_resource_conflicts_ids[] = {
-	/* Microsoft Surface Go (version 1) I2C4 */
-	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_INTEL, 0x9d64, 0x152d, 0x1182), },
-	/* Microsoft Surface Go 2 I2C4 */
-	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_INTEL, 0x9d64, 0x152d, 0x1237), },
+static const struct pci_device_id quirk_ids[] = {
+	{
+		/* Microsoft Surface Go (version 1) I2C4 */
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_INTEL, 0x9d64, 0x152d, 0x1182),
+		.driver_data = QUIRK_IGNORE_RESOURCE_CONFLICTS,
+	},
+	{
+		/* Microsoft Surface Go 2 I2C4 */
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_INTEL, 0x9d64, 0x152d, 0x1237),
+		.driver_data = QUIRK_IGNORE_RESOURCE_CONFLICTS,
+	},
 	{ }
 };
 
 static int intel_lpss_pci_probe(struct pci_dev *pdev,
 				const struct pci_device_id *id)
 {
+	const struct pci_device_id *quirk_pci_info;
 	struct intel_lpss_platform_info *info;
 	int ret;
 
@@ -45,8 +51,9 @@ static int intel_lpss_pci_probe(struct p
 	info->mem = &pdev->resource[0];
 	info->irq = pdev->irq;
 
-	if (pci_match_id(ignore_resource_conflicts_ids, pdev))
-		info->ignore_resource_conflicts = true;
+	quirk_pci_info = pci_match_id(quirk_ids, pdev);
+	if (quirk_pci_info)
+		info->quirks = quirk_pci_info->driver_data;
 
 	pdev->d3cold_delay = 0;
 
--- a/drivers/mfd/intel-lpss.c
+++ b/drivers/mfd/intel-lpss.c
@@ -401,7 +401,7 @@ int intel_lpss_probe(struct device *dev,
 		return ret;
 
 	lpss->cell->swnode = info->swnode;
-	lpss->cell->ignore_resource_conflicts = info->ignore_resource_conflicts;
+	lpss->cell->ignore_resource_conflicts = info->quirks & QUIRK_IGNORE_RESOURCE_CONFLICTS;
 
 	intel_lpss_init_dev(lpss);
 
--- a/drivers/mfd/intel-lpss.h
+++ b/drivers/mfd/intel-lpss.h
@@ -11,16 +11,23 @@
 #ifndef __MFD_INTEL_LPSS_H
 #define __MFD_INTEL_LPSS_H
 
+#include <linux/bits.h>
 #include <linux/pm.h>
 
+/*
+ * Some DSDTs have an unused GEXP ACPI device conflicting with I2C4 resources.
+ * Set to ignore resource conflicts with ACPI declared SystemMemory regions.
+ */
+#define QUIRK_IGNORE_RESOURCE_CONFLICTS BIT(0)
+
 struct device;
 struct resource;
 struct software_node;
 
 struct intel_lpss_platform_info {
 	struct resource *mem;
-	bool ignore_resource_conflicts;
 	int irq;
+	unsigned int quirks;
 	unsigned long clk_rate;
 	const char *clk_con_id;
 	const struct software_node *swnode;


