Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA2A78C75;
	Mon, 15 Apr 2024 14:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191319; cv=none; b=Lwb5JinmA/Ash6Ct2pJ31XZlptHHdzk54Lx0DKSLSXKe0nHFyqJTVU6dzxYJPPSC/HtIzEIX3ae3k2xf+Ihyoco1s3gSq9LMGP+BndAHbxYAs02iDdYiC8BUYuJ7kjVum0dX6oWqMLnRJuq7QBpuetqWBdz8EZfv6aJOhroPqIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191319; c=relaxed/simple;
	bh=WABjaK6JEEJbcR8I1w6quI90lH47hsqsqRsU1VWeyGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htH0k9qITfFlYj0ohYlVevMgM+cFiMZE4jwfjxZ/OmM1RyDuEpDJaucOP9l1OpMnu3816xRjg3f77irXcqEpVfHQrUTR9F+flWptL0EHK2ftBkQ3r/e7NDMUxEzn1ugIXFCXlY4FX2vb3c/kaS7QOUSA7CDh9Ukzw5fBk+xIVQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eSaJYYjr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eSaJYYjr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A907C2BD10;
	Mon, 15 Apr 2024 14:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191318;
	bh=WABjaK6JEEJbcR8I1w6quI90lH47hsqsqRsU1VWeyGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eSaJYYjrZojKeXbBDQtLYiTfs0S7XksEMhv3fj6pguK7jnIHvNVA2fD/RbbP2mOZX
	 OkZse9CK2CR4JJRUCcxucdRowgh+3/w+B4p1Kkex1j8ylf9MlmIx2P/ITKm8Prcprp
	 3jZvSXmV84ZQjS2gE2Tw5NffrpycsJV3VVfgHam0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 105/172] iommu/vt-d: Fix WARN_ON in iommu probe path
Date: Mon, 15 Apr 2024 16:20:04 +0200
Message-ID: <20240415142003.582669584@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 89436f4f54125b1297aec1f466efd8acb4ec613d ]

Commit 1a75cc710b95 ("iommu/vt-d: Use rbtree to track iommu probed
devices") adds all devices probed by the iommu driver in a rbtree
indexed by the source ID of each device. It assumes that each device
has a unique source ID. This assumption is incorrect and the VT-d
spec doesn't state this requirement either.

The reason for using a rbtree to track devices is to look up the device
with PCI bus and devfunc in the paths of handling ATS invalidation time
out error and the PRI I/O page faults. Both are PCI ATS feature related.

Only track the devices that have PCI ATS capabilities in the rbtree to
avoid unnecessary WARN_ON in the iommu probe path. Otherwise, on some
platforms below kernel splat will be displayed and the iommu probe results
in failure.

 WARNING: CPU: 3 PID: 166 at drivers/iommu/intel/iommu.c:158 intel_iommu_probe_device+0x319/0xd90
 Call Trace:
  <TASK>
  ? __warn+0x7e/0x180
  ? intel_iommu_probe_device+0x319/0xd90
  ? report_bug+0x1f8/0x200
  ? handle_bug+0x3c/0x70
  ? exc_invalid_op+0x18/0x70
  ? asm_exc_invalid_op+0x1a/0x20
  ? intel_iommu_probe_device+0x319/0xd90
  ? debug_mutex_init+0x37/0x50
  __iommu_probe_device+0xf2/0x4f0
  iommu_probe_device+0x22/0x70
  iommu_bus_notifier+0x1e/0x40
  notifier_call_chain+0x46/0x150
  blocking_notifier_call_chain+0x42/0x60
  bus_notify+0x2f/0x50
  device_add+0x5ed/0x7e0
  platform_device_add+0xf5/0x240
  mfd_add_devices+0x3f9/0x500
  ? preempt_count_add+0x4c/0xa0
  ? up_write+0xa2/0x1b0
  ? __debugfs_create_file+0xe3/0x150
  intel_lpss_probe+0x49f/0x5b0
  ? pci_conf1_write+0xa3/0xf0
  intel_lpss_pci_probe+0xcf/0x110 [intel_lpss_pci]
  pci_device_probe+0x95/0x120
  really_probe+0xd9/0x370
  ? __pfx___driver_attach+0x10/0x10
  __driver_probe_device+0x73/0x150
  driver_probe_device+0x19/0xa0
  __driver_attach+0xb6/0x180
  ? __pfx___driver_attach+0x10/0x10
  bus_for_each_dev+0x77/0xd0
  bus_add_driver+0x114/0x210
  driver_register+0x5b/0x110
  ? __pfx_intel_lpss_pci_driver_init+0x10/0x10 [intel_lpss_pci]
  do_one_initcall+0x57/0x2b0
  ? kmalloc_trace+0x21e/0x280
  ? do_init_module+0x1e/0x210
  do_init_module+0x5f/0x210
  load_module+0x1d37/0x1fc0
  ? init_module_from_file+0x86/0xd0
  init_module_from_file+0x86/0xd0
  idempotent_init_module+0x17c/0x230
  __x64_sys_finit_module+0x56/0xb0
  do_syscall_64+0x6e/0x140
  entry_SYSCALL_64_after_hwframe+0x71/0x79

Fixes: 1a75cc710b95 ("iommu/vt-d: Use rbtree to track iommu probed devices")
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/10689
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20240407011429.136282-1-baolu.lu@linux.intel.com
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 5dba58f322f03..d7e10f1311aaf 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4381,9 +4381,11 @@ static struct iommu_device *intel_iommu_probe_device(struct device *dev)
 	}
 
 	dev_iommu_priv_set(dev, info);
-	ret = device_rbtree_insert(iommu, info);
-	if (ret)
-		goto free;
+	if (pdev && pci_ats_supported(pdev)) {
+		ret = device_rbtree_insert(iommu, info);
+		if (ret)
+			goto free;
+	}
 
 	if (sm_supported(iommu) && !dev_is_real_dma_subdevice(dev)) {
 		ret = intel_pasid_alloc_table(dev);
@@ -4410,7 +4412,8 @@ static void intel_iommu_release_device(struct device *dev)
 	struct intel_iommu *iommu = info->iommu;
 
 	mutex_lock(&iommu->iopf_lock);
-	device_rbtree_remove(info);
+	if (dev_is_pci(dev) && pci_ats_supported(to_pci_dev(dev)))
+		device_rbtree_remove(info);
 	mutex_unlock(&iommu->iopf_lock);
 
 	if (sm_supported(iommu) && !dev_is_real_dma_subdevice(dev) &&
-- 
2.43.0



