Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA041F9F70;
	Thu, 12 Mar 2026 20:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346695; cv=none; b=OJakBh0+zJuUKyziX17MIlKJcoKxxIMVk/o/pvndV590PPCI+E6Tn87pJLXQNAeK2Xif/H693G1YVr6YyiMzFmFhrSEhPXagMQO71sN+SQpRssT5PB7jYylCQvsQQQx2X3SZKw6pE9Ll0EzORoOkOLCvhvOJSzri2F9T4xAh0CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346695; c=relaxed/simple;
	bh=sepHpV/1aTI13tM2P6Vxwf3ulyxrhznEOaZeVRx9E/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T/G44NpCXFxpTrd8jcT7/Ocm6XbS6hVm4oEyG2MuaxQ33dC51BbbDmo6tdAK6bcC/lp/gE2YJ9MbjMN6fhQO2AvAgLTHCzsTU85B0SsfifXB2uvjdVdihbob9ei4wTTYCcInrBZRJkGVzUF+eIgKobMiFn8sdYu0TVmC1QfKLtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1Q2LxBn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1Q2LxBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFBD4C4CEF7;
	Thu, 12 Mar 2026 20:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346695;
	bh=sepHpV/1aTI13tM2P6Vxwf3ulyxrhznEOaZeVRx9E/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E1Q2LxBnn9nQfz6Yw5MF1AgBRRSPTq14CdDkhXIO6XQsqgotl/gGUPsQm3dtmmBge
	 jo4lnMRRctHWPnyPte+dXEhBdMMP8GfarVKjuDhjhAv+OzJl7UE5Z47JunYpBadPJd
	 MF7W6nXFEabiUYLhc1UzilXSJFdv0TlPPNFoFk4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinhui Guo <guojinhui.liam@bytedance.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/265] iommu/vt-d: Skip dev-iotlb flush for inaccessible PCIe device without scalable mode
Date: Thu, 12 Mar 2026 21:07:51 +0100
Message-ID: <20260312201021.253967071@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinhui Guo <guojinhui.liam@bytedance.com>

[ Upstream commit 42662d19839f34735b718129ea200e3734b07e50 ]

PCIe endpoints with ATS enabled and passed through to userspace
(e.g., QEMU, DPDK) can hard-lock the host when their link drops,
either by surprise removal or by a link fault.

Commit 4fc82cd907ac ("iommu/vt-d: Don't issue ATS Invalidation
request when device is disconnected") adds pci_dev_is_disconnected()
to devtlb_invalidation_with_pasid() so ATS invalidation is skipped
only when the device is being safely removed, but it applies only
when Intel IOMMU scalable mode is enabled.

With scalable mode disabled or unsupported, a system hard-lock
occurs when a PCIe endpoint's link drops because the Intel IOMMU
waits indefinitely for an ATS invalidation that cannot complete.

Call Trace:
 qi_submit_sync
 qi_flush_dev_iotlb
 __context_flush_dev_iotlb.part.0
 domain_context_clear_one_cb
 pci_for_each_dma_alias
 device_block_translation
 blocking_domain_attach_dev
 iommu_deinit_device
 __iommu_group_remove_device
 iommu_release_device
 iommu_bus_notifier
 blocking_notifier_call_chain
 bus_notify
 device_del
 pci_remove_bus_device
 pci_stop_and_remove_bus_device
 pciehp_unconfigure_device
 pciehp_disable_slot
 pciehp_handle_presence_or_link_change
 pciehp_ist

Commit 81e921fd3216 ("iommu/vt-d: Fix NULL domain on device release")
adds intel_pasid_teardown_sm_context() to intel_iommu_release_device(),
which calls qi_flush_dev_iotlb() and can also hard-lock the system
when a PCIe endpoint's link drops.

Call Trace:
 qi_submit_sync
 qi_flush_dev_iotlb
 __context_flush_dev_iotlb.part.0
 intel_context_flush_no_pasid
 device_pasid_table_teardown
 pci_pasid_table_teardown
 pci_for_each_dma_alias
 intel_pasid_teardown_sm_context
 intel_iommu_release_device
 iommu_deinit_device
 __iommu_group_remove_device
 iommu_release_device
 iommu_bus_notifier
 blocking_notifier_call_chain
 bus_notify
 device_del
 pci_remove_bus_device
 pci_stop_and_remove_bus_device
 pciehp_unconfigure_device
 pciehp_disable_slot
 pciehp_handle_presence_or_link_change
 pciehp_ist

Sometimes the endpoint loses connection without a link-down event
(e.g., due to a link fault); killing the process (virsh destroy)
then hard-locks the host.

Call Trace:
 qi_submit_sync
 qi_flush_dev_iotlb
 __context_flush_dev_iotlb.part.0
 domain_context_clear_one_cb
 pci_for_each_dma_alias
 device_block_translation
 blocking_domain_attach_dev
 __iommu_attach_device
 __iommu_device_set_domain
 __iommu_group_set_domain_internal
 iommu_detach_group
 vfio_iommu_type1_detach_group
 vfio_group_detach_container
 vfio_group_fops_release
 __fput

pci_dev_is_disconnected() only covers safe-removal paths;
pci_device_is_present() tests accessibility by reading
vendor/device IDs and internally calls pci_dev_is_disconnected().
On a ConnectX-5 (8 GT/s, x2) this costs ~70 µs.

Since __context_flush_dev_iotlb() is only called on
{attach,release}_dev paths (not hot), add pci_device_is_present()
there to skip inaccessible devices and avoid the hard-lock.

Fixes: 37764b952e1b ("iommu/vt-d: Global devTLB flush when present context entry changed")
Fixes: 81e921fd3216 ("iommu/vt-d: Fix NULL domain on device release")
Cc: stable@vger.kernel.org
Signed-off-by: Jinhui Guo <guojinhui.liam@bytedance.com>
Link: https://lore.kernel.org/r/20251211035946.2071-2-guojinhui.liam@bytedance.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/pasid.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 90fdfa5f7d1d6..3d1d43675bf22 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -867,6 +867,14 @@ static void __context_flush_dev_iotlb(struct device_domain_info *info)
 	if (!info->ats_enabled)
 		return;
 
+	/*
+	 * Skip dev-IOTLB flush for inaccessible PCIe devices to prevent the
+	 * Intel IOMMU from waiting indefinitely for an ATS invalidation that
+	 * cannot complete.
+	 */
+	if (!pci_device_is_present(to_pci_dev(info->dev)))
+		return;
+
 	qi_flush_dev_iotlb(info->iommu, PCI_DEVID(info->bus, info->devfn),
 			   info->pfsid, info->ats_qdep, 0, MAX_AGAW_PFN_WIDTH);
 
-- 
2.51.0



