Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34A13DAAC8;
	Fri,  4 Sep 2026 05:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499783; cv=none; b=NmF2MPYCz0EXMh+PTx6s2Dkb3xHFzKQekPwZKMNwUr1RCVOTWFa1gxDqa5IZDREdcWwIE/2qQaY4IOWPjV7h3qyQ4YRBd4S1LA9wHHfgIr2mxffCyOJ78w6+pg6O7mxDwnTvSk4ovHqygttxgkPDR4nnzNs9sLyjzSFT+mipSxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499783; c=relaxed/simple;
	bh=+5jqoS4LHYXPGyZnnW4ubPy83qGblg0daomF9uPBqjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDAfdq2gY8W138KUhiihKJRU+o3fbnT7eYwgJePXf807O5tcMMcM52oe0pCDUJWlurxNQ92F6Gne3A6h9BnZKgdTeZaxLezgcZ3f2R/AXbKn7s+1WYSVRz9q4DC50l1NtrUveLSyWtTCET3Fir7WDTeiLDiP/ARKQ//Ibg+PdbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WSrV6MMY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WSrV6MMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D042A1F00A3D;
	Fri,  4 Sep 2026 05:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499782;
	bh=DypFRJaMGmsXiGXq7Kthhra2ySIb2pVGGrckgfH77Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WSrV6MMYBpw0ZD6xBgl3R4ZKZozphL3g2CBmVOQWYRBYILVkzKiIULZ7oe4PH+u4W
	 oeqSzwZRSVxo/cK8ekRsIXwigglv+lHBYQOVlhdqWdLsGg74dmYg3NZr6XZ5tY7G2O
	 x713rg14VztovzgIVHodzoenIhoj4fOa/CPRH2G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7.2 537/713] iommu/amd: Put PCI device after handling PPR faults
Date: Fri,  4 Sep 2026 06:58:25 +0200
Message-ID: <20260904045815.857821616@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuai Xue <xueshuai@linux.alibaba.com>

commit af3b69b16383fbc8fe5f61b5b0150d2e41ede71f upstream.

iommu_call_iopf_notifier() looks up the requester with
pci_get_domain_bus_and_slot(), which returns a PCI device with its
reference count incremented.

Neither the successful iommu_report_device_fault() path nor the abort
path drops that reference, so every handled PPR request leaks a PCI
device reference.

This is the same ownership rule that was fixed for the old iommu_v2
ppr_notifier() path by commit 6cf0981c2233 ("iommu/amd: Fix pci device
refcount leak in ppr_notifier()"), but iommu_call_iopf_notifier() was
added later as a separate PPR/IOPF notifier path.

Drop the PCI device reference after handling the PPR entry.

Fixes: 978d626b8f1a ("iommu/amd: Add IO page fault notifier handler")
Cc: stable@vger.kernel.org
Assisted-by: Qoder:Qwen-3.8-MAX-Preview
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/ppr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iommu/amd/ppr.c
+++ b/drivers/iommu/amd/ppr.c
@@ -151,7 +151,7 @@ static void iommu_call_iopf_notifier(str
 
 	/* Submit event */
 	iommu_report_device_fault(&pdev->dev, &event);
-
+	pci_dev_put(pdev);
 	return;
 
 out:
@@ -159,6 +159,7 @@ out:
 	amd_iommu_complete_ppr(&pdev->dev, PPR_PASID(raw[0]),
 			       IOMMU_PAGE_RESP_FAILURE,
 			       PPR_TAG(raw[0]) & 0x1FF);
+	pci_dev_put(pdev);
 }
 
 void amd_iommu_poll_ppr_log(struct amd_iommu *iommu)


