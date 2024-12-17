Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9DE1F869F;
	Tue, 17 Dec 2024 17:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456418; cv=none; b=Scl3EFJ5YfiTnKYnYD3Q/x1T22AyXQL1bXlYlBCQYmCvto3sEwo07FJ5/A/leK7qDalaPsJxSzfdL3n655d4M7ZxhGyDe6oXFh+HKNdYbJFNptJKq3VvK7YDrrf9HZINIeQwRcpYNKaaa3t5SfDfpuqm8jcF4slPAYbY6X4ndNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456418; c=relaxed/simple;
	bh=uI+QaZm3L+ijbyXiBGLCnvuEC3wqYxUmb1Np4PvYb0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QEtEKBN/UGLnQDr+kq3k3FXsfOhxgjmqkIi4d2UFINBYp/7wOxN7uvYKe2HXgLilrtBzjyodWqwWkuJ2fSmTJ4VZ7HU15qHiteuQAu8hIIq1Adm+nhtqqxOsAdp2tt0xTp4PaEG3ZmctRVI4/mg8ffLG0gt/fb/WF+EabY3rGbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0C8Ay+Ux; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0C8Ay+Ux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9329C4CED7;
	Tue, 17 Dec 2024 17:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456418;
	bh=uI+QaZm3L+ijbyXiBGLCnvuEC3wqYxUmb1Np4PvYb0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0C8Ay+UxnTVwIn/gKTAT/uNBnFai8t9rGgNQRJtXZN7/h9sv9XNWH9EnR16Y0B17D
	 vCwxmRfgxCpriAtxQwgxlBsImQTQy9OYdZnXZ+Q/8xH3Ep7LugYvHY1p7QqQdyHINR
	 gFmGrWPfcWXn6XMIGxMJjaEMIdLbLx5UDbkdU9Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.12 054/172] iommu/vt-d: Remove cache tags before disabling ATS
Date: Tue, 17 Dec 2024 18:06:50 +0100
Message-ID: <20241217170548.511056011@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

commit 1f2557e08a617a4b5e92a48a1a9a6f86621def18 upstream.

The current implementation removes cache tags after disabling ATS,
leading to potential memory leaks and kernel crashes. Specifically,
CACHE_TAG_DEVTLB type cache tags may still remain in the list even
after the domain is freed, causing a use-after-free condition.

This issue really shows up when multiple VFs from different PFs
passed through to a single user-space process via vfio-pci. In such
cases, the kernel may crash with kernel messages like:

 BUG: kernel NULL pointer dereference, address: 0000000000000014
 PGD 19036a067 P4D 1940a3067 PUD 136c9b067 PMD 0
 Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
 CPU: 74 UID: 0 PID: 3183 Comm: testCli Not tainted 6.11.9 #2
 RIP: 0010:cache_tag_flush_range+0x9b/0x250
 Call Trace:
  <TASK>
  ? __die+0x1f/0x60
  ? page_fault_oops+0x163/0x590
  ? exc_page_fault+0x72/0x190
  ? asm_exc_page_fault+0x22/0x30
  ? cache_tag_flush_range+0x9b/0x250
  ? cache_tag_flush_range+0x5d/0x250
  intel_iommu_tlb_sync+0x29/0x40
  intel_iommu_unmap_pages+0xfe/0x160
  __iommu_unmap+0xd8/0x1a0
  vfio_unmap_unpin+0x182/0x340 [vfio_iommu_type1]
  vfio_remove_dma+0x2a/0xb0 [vfio_iommu_type1]
  vfio_iommu_type1_ioctl+0xafa/0x18e0 [vfio_iommu_type1]

Move cache_tag_unassign_domain() before iommu_disable_pci_caps() to fix
it.

Fixes: 3b1d9e2b2d68 ("iommu/vt-d: Add cache tag assignment interface")
Cc: stable@vger.kernel.org
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20241129020506.576413-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/iommu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3372,6 +3372,9 @@ void device_block_translation(struct dev
 	struct intel_iommu *iommu = info->iommu;
 	unsigned long flags;
 
+	if (info->domain)
+		cache_tag_unassign_domain(info->domain, dev, IOMMU_NO_PASID);
+
 	iommu_disable_pci_caps(info);
 	if (!dev_is_real_dma_subdevice(dev)) {
 		if (sm_supported(iommu))
@@ -3388,7 +3391,6 @@ void device_block_translation(struct dev
 	list_del(&info->link);
 	spin_unlock_irqrestore(&info->domain->lock, flags);
 
-	cache_tag_unassign_domain(info->domain, dev, IOMMU_NO_PASID);
 	domain_detach_iommu(info->domain, iommu);
 	info->domain = NULL;
 }


