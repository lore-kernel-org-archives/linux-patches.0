Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944A91DF257;
	Wed, 19 Feb 2025 08:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954112; cv=none; b=pYui8ScKPFamU9E5IQ/x9iFIKRpz+3HAEz1eSadOqwVeheT8Zv/dYDHnBHkviQbTW40wO3t3p2xauOBpZ4kXS6qz329m45Z5xF58SqHaomeJpJV9ersTwwm8Ez46/bQZvpLIt8kMbt9T1uKORTKu7eKboQLbTr6sEvBI/EKYeQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954112; c=relaxed/simple;
	bh=JFQreQSOX0iitDO/fg3UuSomc0PW3mTyUxGtvHLytB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQOLJ8UGlU1alZsPdxdgstq0X0I5kiaZTZrEsilQlB3fqLXRv744iuH84UF9ZmK2J9anYTe4WkFt4Bov1EOn856lmSF6VFMj5BrCOgjn3UKKwS0lR2zeBgHSDH9fD61HewC0knssLNSNe80fDI63C2Izf99QrTHx6+AWEHLvWZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VDlIu1LJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VDlIu1LJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14ADFC4CED1;
	Wed, 19 Feb 2025 08:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954112;
	bh=JFQreQSOX0iitDO/fg3UuSomc0PW3mTyUxGtvHLytB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VDlIu1LJHsOz/cNNdcCCRNJXCKn6UrUlO5OE/FZFb4G4weAVnHe6+ryDH7QmYIboE
	 dEy3HJZoRboGjmrXv0Y+r+DMxs3FylT2IjoEiqg2Fv0YQKMda4o7VvN9aOfpIPYfsG
	 btKXDuNgCfyFMLJ/dcqZmtvkPp2M1OVeDGeDiF/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 099/274] vfio/nvgrace-gpu: Expose the blackwell device PF BAR1 to the VM
Date: Wed, 19 Feb 2025 09:25:53 +0100
Message-ID: <20250219082613.495753423@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ankit Agrawal <ankita@nvidia.com>

[ Upstream commit 6a9eb2d125ba90d13b45bcfabcddf9f61268f6a8 ]

There is a HW defect on Grace Hopper (GH) to support the
Multi-Instance GPU (MIG) feature [1] that necessiated the presence
of a 1G region carved out from the device memory and mapped as
uncached. The 1G region is shown as a fake BAR (comprising region 2 and 3)
to workaround the issue.

The Grace Blackwell systems (GB) differ from GH systems in the following
aspects:
1. The aforementioned HW defect is fixed on GB systems.
2. There is a usable BAR1 (region 2 and 3) on GB systems for the
GPUdirect RDMA feature [2].

This patch accommodate those GB changes by showing the 64b physical
device BAR1 (region2 and 3) to the VM instead of the fake one. This
takes care of both the differences.

Moreover, the entire device memory is exposed on GB as cacheable to
the VM as there is no carveout required.

Link: https://www.nvidia.com/en-in/technologies/multi-instance-gpu/ [1]
Link: https://docs.nvidia.com/cuda/gpudirect-rdma/ [2]

Cc: Kevin Tian <kevin.tian@intel.com>
CC: Jason Gunthorpe <jgg@nvidia.com>
Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Link: https://lore.kernel.org/r/20250124183102.3976-3-ankita@nvidia.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 67 +++++++++++++++++++----------
 1 file changed, 45 insertions(+), 22 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index b76368958d1c5..778bfd0655de0 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -17,9 +17,6 @@
 #define RESMEM_REGION_INDEX VFIO_PCI_BAR2_REGION_INDEX
 #define USEMEM_REGION_INDEX VFIO_PCI_BAR4_REGION_INDEX
 
-/* Memory size expected as non cached and reserved by the VM driver */
-#define RESMEM_SIZE SZ_1G
-
 /* A hardwired and constant ABI value between the GPU FW and VFIO driver. */
 #define MEMBLK_SIZE SZ_512M
 
@@ -72,7 +69,7 @@ nvgrace_gpu_memregion(int index,
 	if (index == USEMEM_REGION_INDEX)
 		return &nvdev->usemem;
 
-	if (index == RESMEM_REGION_INDEX)
+	if (nvdev->resmem.memlength && index == RESMEM_REGION_INDEX)
 		return &nvdev->resmem;
 
 	return NULL;
@@ -757,40 +754,67 @@ nvgrace_gpu_init_nvdev_struct(struct pci_dev *pdev,
 			      u64 memphys, u64 memlength)
 {
 	int ret = 0;
+	u64 resmem_size = 0;
 
 	/*
-	 * The VM GPU device driver needs a non-cacheable region to support
-	 * the MIG feature. Since the device memory is mapped as NORMAL cached,
-	 * carve out a region from the end with a different NORMAL_NC
-	 * property (called as reserved memory and represented as resmem). This
-	 * region then is exposed as a 64b BAR (region 2 and 3) to the VM, while
-	 * exposing the rest (termed as usable memory and represented using usemem)
-	 * as cacheable 64b BAR (region 4 and 5).
+	 * On Grace Hopper systems, the VM GPU device driver needs a non-cacheable
+	 * region to support the MIG feature owing to a hardware bug. Since the
+	 * device memory is mapped as NORMAL cached, carve out a region from the end
+	 * with a different NORMAL_NC property (called as reserved memory and
+	 * represented as resmem). This region then is exposed as a 64b BAR
+	 * (region 2 and 3) to the VM, while exposing the rest (termed as usable
+	 * memory and represented using usemem) as cacheable 64b BAR (region 4 and 5).
 	 *
 	 *               devmem (memlength)
 	 * |-------------------------------------------------|
 	 * |                                           |
 	 * usemem.memphys                              resmem.memphys
+	 *
+	 * This hardware bug is fixed on the Grace Blackwell platforms and the
+	 * presence of the bug can be determined through nvdev->has_mig_hw_bug.
+	 * Thus on systems with the hardware fix, there is no need to partition
+	 * the GPU device memory and the entire memory is usable and mapped as
+	 * NORMAL cached (i.e. resmem size is 0).
 	 */
+	if (nvdev->has_mig_hw_bug)
+		resmem_size = SZ_1G;
+
 	nvdev->usemem.memphys = memphys;
 
 	/*
 	 * The device memory exposed to the VM is added to the kernel by the
-	 * VM driver module in chunks of memory block size. Only the usable
-	 * memory (usemem) is added to the kernel for usage by the VM
-	 * workloads. Make the usable memory size memblock aligned.
+	 * VM driver module in chunks of memory block size. Note that only the
+	 * usable memory (usemem) is added to the kernel for usage by the VM
+	 * workloads.
 	 */
-	if (check_sub_overflow(memlength, RESMEM_SIZE,
+	if (check_sub_overflow(memlength, resmem_size,
 			       &nvdev->usemem.memlength)) {
 		ret = -EOVERFLOW;
 		goto done;
 	}
 
 	/*
-	 * The USEMEM part of the device memory has to be MEMBLK_SIZE
-	 * aligned. This is a hardwired ABI value between the GPU FW and
-	 * VFIO driver. The VM device driver is also aware of it and make
-	 * use of the value for its calculation to determine USEMEM size.
+	 * The usemem region is exposed as a 64B Bar composed of region 4 and 5.
+	 * Calculate and save the BAR size for the region.
+	 */
+	nvdev->usemem.bar_size = roundup_pow_of_two(nvdev->usemem.memlength);
+
+	/*
+	 * If the hardware has the fix for MIG, there is no requirement
+	 * for splitting the device memory to create RESMEM. The entire
+	 * device memory is usable and will be USEMEM. Return here for
+	 * such case.
+	 */
+	if (!nvdev->has_mig_hw_bug)
+		goto done;
+
+	/*
+	 * When the device memory is split to workaround the MIG bug on
+	 * Grace Hopper, the USEMEM part of the device memory has to be
+	 * MEMBLK_SIZE aligned. This is a hardwired ABI value between the
+	 * GPU FW and VFIO driver. The VM device driver is also aware of it
+	 * and make use of the value for its calculation to determine USEMEM
+	 * size. Note that the device memory may not be 512M aligned.
 	 */
 	nvdev->usemem.memlength = round_down(nvdev->usemem.memlength,
 					     MEMBLK_SIZE);
@@ -809,10 +833,9 @@ nvgrace_gpu_init_nvdev_struct(struct pci_dev *pdev,
 	}
 
 	/*
-	 * The memory regions are exposed as BARs. Calculate and save
-	 * the BAR size for them.
+	 * The resmem region is exposed as a 64b BAR composed of region 2 and 3
+	 * for Grace Hopper. Calculate and save the BAR size for the region.
 	 */
-	nvdev->usemem.bar_size = roundup_pow_of_two(nvdev->usemem.memlength);
 	nvdev->resmem.bar_size = roundup_pow_of_two(nvdev->resmem.memlength);
 done:
 	return ret;
-- 
2.39.5



