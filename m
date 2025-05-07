Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85D9214813;
	Wed,  7 May 2025 19:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645195; cv=none; b=Ws6bp79Zs/34K8LiAppjLdcFuEg4i9JkvUqLoSzJNzpM1wUrkUSWi2dSWspzPqSfPeRP8+QMnv8sCTaF2P2Xdn4AUo4PYZ6Rv8n+C0JXXWfb02OUHf8Bxf74gdttFrGoQJit4wyDsuHNrLlralOZC53bHfo00VCMluSbhov9Gt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645195; c=relaxed/simple;
	bh=m7kr8s0SHRqECJ82HYLUT1Aw3L0IgUXBl0y08T1bDqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rn7eO0RgEQY4ETMSuQpxUGywjmKbqii8ZJGZU0+Ad9aO1cGCWyT5JVFoSPbxNhycKjXZkEIvfW0AeC4bUMbZ8HuR+4YDyOvabIHi/OhxV9X1u9/zTWhAINCgB5HATtltoiHi9c0V4LfarK2g/E9R/XetPxZYnM3fz3r3p2+m7xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zs2wuNdU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zs2wuNdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B8EC4CEE2;
	Wed,  7 May 2025 19:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645195;
	bh=m7kr8s0SHRqECJ82HYLUT1Aw3L0IgUXBl0y08T1bDqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zs2wuNdU2A5KcNXaVI4D7WzO+M5rbx7aDaevVmVbgmop5hLdTSFs2gIs0rGJkwQJS
	 bWsSgeuBXEMZZXwH7d2kPJrIV/Tvtk/Jtujs2V4lH4uoExjmYqnXT1RxvElVjtNSng
	 Hyfpjy8eBZGhq1eTzxNL8/KQJSwyJGDWWD5P2vZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 125/129] iommu/arm-smmu-v3: Fix iommu_device_probe bug due to duplicated stream ids
Date: Wed,  7 May 2025 20:41:01 +0200
Message-ID: <20250507183818.655729303@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

[ Upstream commit b00d24997a11c10d3e420614f0873b83ce358a34 ]

ASPEED VGA card has two built-in devices:
 0008:06:00.0 PCI bridge: ASPEED Technology, Inc. AST1150 PCI-to-PCI Bridge (rev 06)
 0008:07:00.0 VGA compatible controller: ASPEED Technology, Inc. ASPEED Graphics Family (rev 52)

Its toplogy looks like this:
 +-[0008:00]---00.0-[01-09]--+-00.0-[02-09]--+-00.0-[03]----00.0  Sandisk Corp Device 5017
                             |               +-01.0-[04]--
                             |               +-02.0-[05]----00.0  NVIDIA Corporation Device
                             |               +-03.0-[06-07]----00.0-[07]----00.0  ASPEED Technology, Inc. ASPEED Graphics Family
                             |               +-04.0-[08]----00.0  Renesas Technology Corp. uPD720201 USB 3.0 Host Controller
                             |               \-05.0-[09]----00.0  Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller
                             \-00.1  PMC-Sierra Inc. Device 4028

The IORT logic populaties two identical IDs into the fwspec->ids array via
DMA aliasing in iort_pci_iommu_init() called by pci_for_each_dma_alias().

Though the SMMU driver had been able to handle this situation since commit
563b5cbe334e ("iommu/arm-smmu-v3: Cope with duplicated Stream IDs"), that
got broken by the later commit cdf315f907d4 ("iommu/arm-smmu-v3: Maintain
a SID->device structure"), which ended up with allocating separate streams
with the same stuffing.

On a kernel prior to v6.15-rc1, there has been an overlooked warning:
  pci 0008:07:00.0: vgaarb: setting as boot VGA device
  pci 0008:07:00.0: vgaarb: bridge control possible
  pci 0008:07:00.0: vgaarb: VGA device added: decodes=io+mem,owns=none,locks=none
  pcieport 0008:06:00.0: Adding to iommu group 14
  ast 0008:07:00.0: stream 67328 already in tree   <===== WARNING
  ast 0008:07:00.0: enabling device (0002 -> 0003)
  ast 0008:07:00.0: Using default configuration
  ast 0008:07:00.0: AST 2600 detected
  ast 0008:07:00.0: [drm] Using analog VGA
  ast 0008:07:00.0: [drm] dram MCLK=396 Mhz type=1 bus_width=16
  [drm] Initialized ast 0.1.0 for 0008:07:00.0 on minor 0
  ast 0008:07:00.0: [drm] fb0: astdrmfb frame buffer device

With v6.15-rc, since the commit bcb81ac6ae3c ("iommu: Get DT/ACPI parsing
into the proper probe path"), the error returned with the warning is moved
to the SMMU device probe flow:
  arm_smmu_probe_device+0x15c/0x4c0
  __iommu_probe_device+0x150/0x4f8
  probe_iommu_group+0x44/0x80
  bus_for_each_dev+0x7c/0x100
  bus_iommu_probe+0x48/0x1a8
  iommu_device_register+0xb8/0x178
  arm_smmu_device_probe+0x1350/0x1db0
which then fails the entire SMMU driver probe:
  pci 0008:06:00.0: Adding to iommu group 21
  pci 0008:07:00.0: stream 67328 already in tree
  arm-smmu-v3 arm-smmu-v3.9.auto: Failed to register iommu
  arm-smmu-v3 arm-smmu-v3.9.auto: probe with driver arm-smmu-v3 failed with error -22

Since SMMU driver had been already expecting a potential duplicated Stream
ID in arm_smmu_install_ste_for_dev(), change the arm_smmu_insert_master()
routine to ignore a duplicated ID from the fwspec->sids array as well.

Note: this has been failing the iommu_device_probe() since 2021, although a
recent iommu commit in v6.15-rc1 that moves iommu_device_probe() started to
fail the SMMU driver probe. Since nobody has cared about DMA Alias support,
leave that as it was but fix the fundamental iommu_device_probe() breakage.

Fixes: cdf315f907d4 ("iommu/arm-smmu-v3: Maintain a SID->device structure")
Cc: stable@vger.kernel.org
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Link: https://lore.kernel.org/r/20250415185620.504299-1-nicolinc@nvidia.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 2cab4798e7a0d..f2260f45728e7 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2597,6 +2597,7 @@ static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
 	mutex_lock(&smmu->streams_mutex);
 	for (i = 0; i < fwspec->num_ids; i++) {
 		struct arm_smmu_stream *new_stream = &master->streams[i];
+		struct rb_node *existing;
 		u32 sid = fwspec->ids[i];
 
 		new_stream->id = sid;
@@ -2607,10 +2608,20 @@ static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
 			break;
 
 		/* Insert into SID tree */
-		if (rb_find_add(&new_stream->node, &smmu->streams,
-				arm_smmu_streams_cmp_node)) {
-			dev_warn(master->dev, "stream %u already in tree\n",
-				 sid);
+		existing = rb_find_add(&new_stream->node, &smmu->streams,
+				       arm_smmu_streams_cmp_node);
+		if (existing) {
+			struct arm_smmu_master *existing_master =
+				rb_entry(existing, struct arm_smmu_stream, node)
+					->master;
+
+			/* Bridged PCI devices may end up with duplicated IDs */
+			if (existing_master == master)
+				continue;
+
+			dev_warn(master->dev,
+				 "stream %u already in tree from dev %s\n", sid,
+				 dev_name(existing_master->dev));
 			ret = -EINVAL;
 			break;
 		}
-- 
2.39.5



