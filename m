Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3CC332610;
	Sat, 12 Sep 2026 07:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198689; cv=none; b=OTlNRjd4bivkLHc1aILC7GljYwpklcHbbyQ5mS7d3qF5osXZaPjBDfHGNF29jLlnlIgbslOvHFLaxr399H4+kOPr+QZ+aHolFLIAda8lILbx65iMoGSAAPD//nOCJ6ElMfgEh2BhRNIFOG0ZW3gsAviHWkx0JIrbBBsQp69AjMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198689; c=relaxed/simple;
	bh=K7bG7jPYf73eeBpf++mRwdV8sx6KL7RZjkK0gpot23I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oh+Q0y1OVMW9CXzPogjUQIukB+HZ+pOgs0kf6W1+GMN6hLYNoutk4FbUNLaaG2XRFZgZqdmkgv8GEkMdFECh59xmF/ZJpDIrC3SE5XcNNOBgJhKHDG8gRmc0Ym7a1WWasVj9mWjqDjMjY4DcBbd72q2OPPkWRN3JgWCPHOQXjtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bbamy2o/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bbamy2o/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DB61F000FF;
	Sat, 12 Sep 2026 07:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198687;
	bh=oQBQ3BUiGk9Ojm/pR0nlygdQTLxJHe5Zafpx2hNDCEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bbamy2o/zNhyIbGraRNKvbpJNbYCpoq+U3s7TuidUp76lkMEiM/73etDxaTM4YvxA
	 P9Ukzg+dFtjRr8B/IfUPOOOAtjI9Wf+NGAHyxVRFqBZacfk7ldTIscMrz0sCAJWcCN
	 Pp+CYmRvvX/Oe8/apjL460KhH5qdXFnzKrbB2e+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0432/1815] media: ipu6: Do not free aux device pdata after init
Date: Sat, 12 Sep 2026 08:36:22 +0200
Message-ID: <20260912065659.037119380@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 9be07216af4cfc4813e1a46ce26407d31ea845de ]

ipu6_bus_initialize_device() stores the isys/psys pdata pointer in
struct ipu6_bus_device and initializes the auxiliary device. After that
point, error unwinding must drop the auxiliary device reference and let
ipu6_bus_release() free both the bus device and adev->pdata.

The isys and psys init paths already call put_device() when MMU
initialization fails, and ipu6_bus_add_device() calls
auxiliary_device_uninit() on auxiliary_device_add() failure. Both paths
therefore run the bus release callback. The extra kfree(pdata) in the
callers can release the same object a second time.

Remove the manual pdata frees after the auxiliary device has been
initialized.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: cb3117b074ae ("media: intel/ipu6: add IPU auxiliary devices")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/intel/ipu6/ipu6.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/intel/ipu6/ipu6.c b/drivers/media/pci/intel/ipu6/ipu6.c
index d033d46181692..5449a2006bcce 100644
--- a/drivers/media/pci/intel/ipu6/ipu6.c
+++ b/drivers/media/pci/intel/ipu6/ipu6.c
@@ -400,7 +400,6 @@ ipu6_isys_init(struct pci_dev *pdev, struct device *parent,
 				       &ipdata->hw_variant);
 	if (IS_ERR(isys_adev->mmu)) {
 		put_device(&isys_adev->auxdev.dev);
-		kfree(pdata);
 		return dev_err_cast_probe(dev, isys_adev->mmu,
 				"ipu6_mmu_init(isys_adev->mmu) failed\n");
 	}
@@ -408,10 +407,8 @@ ipu6_isys_init(struct pci_dev *pdev, struct device *parent,
 	isys_adev->mmu->dev = &isys_adev->auxdev.dev;
 
 	ret = ipu6_bus_add_device(isys_adev);
-	if (ret) {
-		kfree(pdata);
+	if (ret)
 		return ERR_PTR(ret);
-	}
 
 	return isys_adev;
 }
@@ -444,7 +441,6 @@ ipu6_psys_init(struct pci_dev *pdev, struct device *parent,
 				       &ipdata->hw_variant);
 	if (IS_ERR(psys_adev->mmu)) {
 		put_device(&psys_adev->auxdev.dev);
-		kfree(pdata);
 		return dev_err_cast_probe(&pdev->dev, psys_adev->mmu,
 				"ipu6_mmu_init(psys_adev->mmu) failed\n");
 	}
@@ -452,10 +448,8 @@ ipu6_psys_init(struct pci_dev *pdev, struct device *parent,
 	psys_adev->mmu->dev = &psys_adev->auxdev.dev;
 
 	ret = ipu6_bus_add_device(psys_adev);
-	if (ret) {
-		kfree(pdata);
+	if (ret)
 		return ERR_PTR(ret);
-	}
 
 	return psys_adev;
 }
-- 
2.53.0



