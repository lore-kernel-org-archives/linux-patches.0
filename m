Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BC21E5B71;
	Mon, 23 Jun 2025 21:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714162; cv=none; b=pDzPj09CQ0adOR0Kkpj+csWquv1u4El16wgUach2UtOwErDBXbG6h8acuu/qZKnccEyk6SSq8BmNiTz3t8PiEL63f4sG9ZxtogZBDbUJ3A9Cf5SjJDzYfxOlWfYH29+0ZicVy90wIpKm022OxnmRBiXI4kEFsx6EduWyGNkI8rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714162; c=relaxed/simple;
	bh=y2SwAuqS59DC+D72qtupKg83xM0vGa28qtqKdEChbwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4kDoVLGjm/Auz0Rg1TuoOSYKStjpS9jfcB0pNus/5NXB99hsfRDHOJl0GbtQFszXnJGudWUcw3+RUPlGDZWRfbqvRWe2F4JJC2XY7nwNT73K9c8gz7sghFlNughRkO7bwW9aaUf02DtmNG4kgKQoqrn7fRsFOyl53y7C8S+HEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=przDQkPw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="przDQkPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA15C4CEEA;
	Mon, 23 Jun 2025 21:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714162;
	bh=y2SwAuqS59DC+D72qtupKg83xM0vGa28qtqKdEChbwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=przDQkPwwuvjFvj6+HwL72/V4+RL20cPh236U7NMkQ1k3oLcHiaTgdis13QKNLYGk
	 7/6NcyEZTej0DLjk/K7hyPkK8N7mkLxS/CVlpJtmW6ipr74XNft/aX/fPQ+N+2V6kA
	 M6q1Txunp1Z5RMe17tl/wZMFopo9BZZvTriPpDho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.12 106/414] iommu/vt-d: Restore context entry setup order for aliased devices
Date: Mon, 23 Jun 2025 15:04:03 +0200
Message-ID: <20250623130644.747441925@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Lu Baolu <baolu.lu@linux.intel.com>

commit 320302baed05c6456164652541f23d2a96522c06 upstream.

Commit 2031c469f816 ("iommu/vt-d: Add support for static identity domain")
changed the context entry setup during domain attachment from a
set-and-check policy to a clear-and-reset approach. This inadvertently
introduced a regression affecting PCI aliased devices behind PCIe-to-PCI
bridges.

Specifically, keyboard and touchpad stopped working on several Apple
Macbooks with below messages:

 kernel: platform pxa2xx-spi.3: Adding to iommu group 20
 kernel: input: Apple SPI Keyboard as
 /devices/pci0000:00/0000:00:1e.3/pxa2xx-spi.3/spi_master/spi2/spi-APP000D:00/input/input0
 kernel: DMAR: DRHD: handling fault status reg 3
 kernel: DMAR: [DMA Read NO_PASID] Request device [00:1e.3] fault addr
 0xffffa000 [fault reason 0x06] PTE Read access is not set
 kernel: DMAR: DRHD: handling fault status reg 3
 kernel: DMAR: [DMA Read NO_PASID] Request device [00:1e.3] fault addr
 0xffffa000 [fault reason 0x06] PTE Read access is not set
 kernel: applespi spi-APP000D:00: Error writing to device: 01 0e 00 00
 kernel: DMAR: DRHD: handling fault status reg 3
 kernel: DMAR: [DMA Read NO_PASID] Request device [00:1e.3] fault addr
 0xffffa000 [fault reason 0x06] PTE Read access is not set
 kernel: DMAR: DRHD: handling fault status reg 3
 kernel: applespi spi-APP000D:00: Error writing to device: 01 0e 00 00

Fix this by restoring the previous context setup order.

Fixes: 2031c469f816 ("iommu/vt-d: Add support for static identity domain")
Closes: https://lore.kernel.org/all/4dada48a-c5dd-4c30-9c85-5b03b0aa01f0@bfh.ch/
Cc: stable@vger.kernel.org
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Link: https://lore.kernel.org/r/20250514060523.2862195-1-baolu.lu@linux.intel.com
Link: https://lore.kernel.org/r/20250520075849.755012-2-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/iommu.c  |   11 +++++++++++
 drivers/iommu/intel/iommu.h  |    1 +
 drivers/iommu/intel/nested.c |    4 ++--
 3 files changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1970,6 +1970,7 @@ static int dmar_domain_attach_device(str
 		return ret;
 
 	info->domain = domain;
+	info->domain_attached = true;
 	spin_lock_irqsave(&domain->lock, flags);
 	list_add(&info->link, &domain->devices);
 	spin_unlock_irqrestore(&domain->lock, flags);
@@ -3381,6 +3382,10 @@ void device_block_translation(struct dev
 	struct intel_iommu *iommu = info->iommu;
 	unsigned long flags;
 
+	/* Device in DMA blocking state. Noting to do. */
+	if (!info->domain_attached)
+		return;
+
 	if (info->domain)
 		cache_tag_unassign_domain(info->domain, dev, IOMMU_NO_PASID);
 
@@ -3393,6 +3398,9 @@ void device_block_translation(struct dev
 			domain_context_clear(info);
 	}
 
+	/* Device now in DMA blocking state. */
+	info->domain_attached = false;
+
 	if (!info->domain)
 		return;
 
@@ -4406,6 +4414,9 @@ static int device_set_dirty_tracking(str
 			break;
 	}
 
+	if (!ret)
+		info->domain_attached = true;
+
 	return ret;
 }
 
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -776,6 +776,7 @@ struct device_domain_info {
 	u8 ats_supported:1;
 	u8 ats_enabled:1;
 	u8 dtlb_extra_inval:1;	/* Quirk for devices need extra flush */
+	u8 domain_attached:1;	/* Device has domain attached */
 	u8 ats_qdep;
 	struct device *dev; /* it's NULL for PCIe-to-PCI bridge */
 	struct intel_iommu *iommu; /* IOMMU used by this device */
--- a/drivers/iommu/intel/nested.c
+++ b/drivers/iommu/intel/nested.c
@@ -27,8 +27,7 @@ static int intel_nested_attach_dev(struc
 	unsigned long flags;
 	int ret = 0;
 
-	if (info->domain)
-		device_block_translation(dev);
+	device_block_translation(dev);
 
 	if (iommu->agaw < dmar_domain->s2_domain->agaw) {
 		dev_err_ratelimited(dev, "Adjusted guest address width not compatible\n");
@@ -62,6 +61,7 @@ static int intel_nested_attach_dev(struc
 		goto unassign_tag;
 
 	info->domain = dmar_domain;
+	info->domain_attached = true;
 	spin_lock_irqsave(&dmar_domain->lock, flags);
 	list_add(&info->link, &dmar_domain->devices);
 	spin_unlock_irqrestore(&dmar_domain->lock, flags);


