Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4898A1F4FAD;
	Mon, 21 Oct 2024 10:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507319; cv=none; b=tYWFaSRM8D08Hppsi7jnoTuz7K6yXtQi/dwziyHSXD07eGxwBLnjonMvI0DcJCPxfmrRH/QMEzj5zJwUR5r+FuLr6KHCu3ILFdYzhZ+65otGXCrLJNoP3H0X/uRSpkmLQA3bgVzbPJEibka8LSJ2cYjv9NznRc4qJOMcx5KyiGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507319; c=relaxed/simple;
	bh=OxMS2PUOZO5Al9gRhC+v2p8KnghMj+JmLx2PQtGk5Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7x3YOko42Pr4EGKd/7YdL6EL93A4K5TslWrccz2OrsBJjThvtkIXQ/nIGZdfjH+xtlCF2r3eXNdqLfvw1WRnsxZzLJw17X8Qsa+O36FaY8nYcSx4FoRAOVIIsvKCgHpANioZfsh041ZiquolzDn00IMSNK1sFErDLBPAbdfbxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KVbq3CPI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVbq3CPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E74C4CEC3;
	Mon, 21 Oct 2024 10:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507318;
	bh=OxMS2PUOZO5Al9gRhC+v2p8KnghMj+JmLx2PQtGk5Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KVbq3CPIc7KpckeYUEBxeqCZXRk0TpNXXIs4gkzK4ceWQiOo3wdCvzfX4yeedOPsA
	 Ld4dBFp75tfl2bRnbEl625Gm/tdp3TEvvzEWpzHrCw0+aDS4PrIxN+ThTxfy8AMyBJ
	 NeAi1nVuQIMvMhlFyNLSf0bYjR1twGaR6VErQGTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Todd Brandt <todd.e.brandt@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.1 38/91] iommu/vt-d: Fix incorrect pci_for_each_dma_alias() for non-PCI devices
Date: Mon, 21 Oct 2024 12:24:52 +0200
Message-ID: <20241021102251.310143361@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

commit 6e02a277f1db24fa039e23783c8921c7b0e5b1b3 upstream.

Previously, the domain_context_clear() function incorrectly called
pci_for_each_dma_alias() to set up context entries for non-PCI devices.
This could lead to kernel hangs or other unexpected behavior.

Add a check to only call pci_for_each_dma_alias() for PCI devices. For
non-PCI devices, domain_context_clear_one() is called directly.

Reported-by: Todd Brandt <todd.e.brandt@intel.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219363
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219349
Fixes: 9a16ab9d6402 ("iommu/vt-d: Make context clearing consistent with context mapping")
Cc: stable@vger.kernel.org
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20241014013744.102197-2-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/iommu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4090,8 +4090,10 @@ static int domain_context_clear_one_cb(s
  */
 static void domain_context_clear(struct device_domain_info *info)
 {
-	if (!dev_is_pci(info->dev))
+	if (!dev_is_pci(info->dev)) {
 		domain_context_clear_one(info, info->bus, info->devfn);
+		return;
+	}
 
 	pci_for_each_dma_alias(to_pci_dev(info->dev),
 			       &domain_context_clear_one_cb, info);


