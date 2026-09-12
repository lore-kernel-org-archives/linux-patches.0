Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E216D246BCD;
	Sat, 12 Sep 2026 10:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207391; cv=none; b=klNZmTDzUOOLssKPTcN2KbntySTZ0pcFxXP7hPD8zR3FaYglcqR/lUs4iRqQFckAw0KTzmqsDqfzTqp8it6ipqfID8D9t3u9ut9rmgbuAfaSa8uLKGqPQd7YHS7ovEwD/MgQ/O84aSHCBqs9JO7IpGkSO5bMqI6nvliCZ45c11I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207391; c=relaxed/simple;
	bh=xcg+CRYbpW4ATghvjMGCRdvdGcO1i9FvzIlJHhQxhdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/p05qGdnqpKAQs04TE/o844LRjUeIjEwzN8YLBzIi3lI5cBNLA3Gby1ApAJK1HV89dNVSAQh01o0m9SItr6EEh1uypN/piUd4kLmR4nKQnTpCCspPnzKpc4brJLVaHTqWoiD226WLmmBpQnevRjxvVrT59Mx5NQDOTZKda/STY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VKKJdLN7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VKKJdLN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE901F000FF;
	Sat, 12 Sep 2026 10:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207389;
	bh=xSchLxym3JutF+CbNZ5zCMcD9oym5rC77Axyx9pWWrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VKKJdLN7xzJlhSDkOlrzMQ2uUZzfFE++ASy/IKS7eqcFB9F2VGWg4Lc18DRWkLLjv
	 gPxwpIIAV7/pRGT199K00nSuv08o4apECr86esxmhet6IHV4NN4Qyk85aqPBY+KCDT
	 AxK9ZIGxCAqIP0X1sKtYzrNsirTyqXW5bTA9I8n0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0402/1518] media: ipu6: Do not free aux device pdata after init
Date: Sat, 12 Sep 2026 08:42:51 +0200
Message-ID: <20260912065632.548883761@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index fab7783c664b9..f900de14ba600 100644
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



