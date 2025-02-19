Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD7A1DE2CD;
	Wed, 19 Feb 2025 08:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954941; cv=none; b=jU1GQQfx2COy89Ezff22whC1/liaAWKsoDzMYwSEUHkZYJiYGmAJqkD7f30XKZ9v18ByT1XZNu/kipH9MlkJI8oSZ6WS/vRiPi0+hyQWhLpB9sA5G0rhCwM5O/Flzq/+k8hL2EcxfjXzZTA5EYDG92WmWIMrph+Ljr1cdqeSKCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954941; c=relaxed/simple;
	bh=1MUgg7JV7bIVJl6Ev3Qb5nOl8838Sxwc/JtRjl+QcJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWMrQqmhj9dLOlkk6L1lv3r6YPjcHYTcu/7GJfevtffW8DlSecxVTeTbD3Ly9V50/N6IHG74Oi4YEAXrfrE3YhO+C9o0seCEV5Ge+6AYoykSkSOLne0MGAIFDwnaIBlKlPuk+BGbJmTTlvTlHdOySoOTAOzdA9WL6wCydsNQHzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=whX9cgi+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="whX9cgi+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08C4C4CEE8;
	Wed, 19 Feb 2025 08:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954941;
	bh=1MUgg7JV7bIVJl6Ev3Qb5nOl8838Sxwc/JtRjl+QcJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=whX9cgi+9D/Qn6Zvy/wT3uhPyjvNHPz2tRl7txjvqK/MibqGW5sdeaK1kVu44b6pe
	 v/AXMRk8+IbsxrRYPdYrYYBnDI7AVpCidEOXRxSTu6xaENvtpjM0rvDzXPogQTWzBk
	 3JzG232v1GBZ9X3DTBZpn7bHM6RQXYRQio5x0zuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/230] vfio/nvgrace-gpu: Read dvsec register to determine need for uncached resmem
Date: Wed, 19 Feb 2025 09:26:40 +0100
Message-ID: <20250219082604.947853951@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ankit Agrawal <ankita@nvidia.com>

[ Upstream commit bd53764a60ad586ad5b6ed339423ad5e67824464 ]

NVIDIA's recently introduced Grace Blackwell (GB) Superchip is a
continuation with the Grace Hopper (GH) superchip that provides a
cache coherent access to CPU and GPU to each other's memory with
an internal proprietary chip-to-chip cache coherent interconnect.

There is a HW defect on GH systems to support the Multi-Instance
GPU (MIG) feature [1] that necessiated the presence of a 1G region
with uncached mapping carved out from the device memory. The 1G
region is shown as a fake BAR (comprising region 2 and 3) to
workaround the issue. This is fixed on the GB systems.

The presence of the fix for the HW defect is communicated by the
device firmware through the DVSEC PCI config register with ID 3.
The module reads this to take a different codepath on GB vs GH.

Scan through the DVSEC registers to identify the correct one and use
it to determine the presence of the fix. Save the value in the device's
nvgrace_gpu_pci_core_device structure.

Link: https://www.nvidia.com/en-in/technologies/multi-instance-gpu/ [1]

CC: Jason Gunthorpe <jgg@nvidia.com>
CC: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Link: https://lore.kernel.org/r/20250124183102.3976-2-ankita@nvidia.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index a7fd018aa5483..178ee4180d5c4 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -23,6 +23,11 @@
 /* A hardwired and constant ABI value between the GPU FW and VFIO driver. */
 #define MEMBLK_SIZE SZ_512M
 
+#define DVSEC_BITMAP_OFFSET 0xA
+#define MIG_SUPPORTED_WITH_CACHED_RESMEM BIT(0)
+
+#define GPU_CAP_DVSEC_REGISTER 3
+
 /*
  * The state of the two device memory region - resmem and usemem - is
  * saved as struct mem_region.
@@ -46,6 +51,7 @@ struct nvgrace_gpu_pci_core_device {
 	struct mem_region resmem;
 	/* Lock to control device memory kernel mapping */
 	struct mutex remap_lock;
+	bool has_mig_hw_bug;
 };
 
 static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_vdev)
@@ -812,6 +818,26 @@ nvgrace_gpu_init_nvdev_struct(struct pci_dev *pdev,
 	return ret;
 }
 
+static bool nvgrace_gpu_has_mig_hw_bug(struct pci_dev *pdev)
+{
+	int pcie_dvsec;
+	u16 dvsec_ctrl16;
+
+	pcie_dvsec = pci_find_dvsec_capability(pdev, PCI_VENDOR_ID_NVIDIA,
+					       GPU_CAP_DVSEC_REGISTER);
+
+	if (pcie_dvsec) {
+		pci_read_config_word(pdev,
+				     pcie_dvsec + DVSEC_BITMAP_OFFSET,
+				     &dvsec_ctrl16);
+
+		if (dvsec_ctrl16 & MIG_SUPPORTED_WITH_CACHED_RESMEM)
+			return false;
+	}
+
+	return true;
+}
+
 static int nvgrace_gpu_probe(struct pci_dev *pdev,
 			     const struct pci_device_id *id)
 {
@@ -832,6 +858,8 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
 	dev_set_drvdata(&pdev->dev, &nvdev->core_device);
 
 	if (ops == &nvgrace_gpu_pci_ops) {
+		nvdev->has_mig_hw_bug = nvgrace_gpu_has_mig_hw_bug(pdev);
+
 		/*
 		 * Device memory properties are identified in the host ACPI
 		 * table. Set the nvgrace_gpu_pci_core_device structure.
-- 
2.39.5



