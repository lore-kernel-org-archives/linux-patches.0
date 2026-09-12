Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352672E06E4;
	Sat, 12 Sep 2026 12:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215552; cv=none; b=rUKJVQfQK7LTrg6oDoNU93o/P5a20XHiSPySpwiTuWv8dGcnnp+ckN6ufx6AXpg3bn30iuDTbWtRO02N+XV+Rapfziy3I7sgUHLWa7hnnpO26wx606j5DuC/nO0b75VoCDzJb4msvH2VC6UtXnBbo65KPXXuhjnbKtbSSRC4X04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215552; c=relaxed/simple;
	bh=FAh7v2b00wMfOgIfuHj+FfH0l+/xS+0GIG4jLoL+P1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGE7a6mWVACKIw4atgO1mRAwCGBry/0Cz1VbpUK8uDeKbe1jpKykp/S7nah1wist933iICeGKyHfUXzBDzzMSBS5vfe3MoFMblLH562iWG0qSPHp9H5SqzYLkybkKIcqLCoJQjZT7xODHPeFt0SnEuMDLoHOlHFcjpJUjo74L7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WD3rihYl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WD3rihYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C041F000FF;
	Sat, 12 Sep 2026 12:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215551;
	bh=xWqXNumCEqV/3WRdppn31Xd2J1+ce1/q+wqhADHM29I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WD3rihYlCJ871yLouKvsmggieJuseTYky9DZqoXrHoBAdIUv9yPFO+eT7hZWJ9k9s
	 FRRRqwnJiHWMI+ONXgAEEzobkP4xTIL5W4NaFE8BG7IhHwXJ1PDnnLSwliNZOVvk1I
	 /OrYJEcqearY1GjzzlMtnte8kutVVgGXKtOv3Tp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0553/1376] media: ipu6: Do not free aux device pdata after init
Date: Sat, 12 Sep 2026 08:49:39 +0200
Message-ID: <20260912065619.862003137@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 40566b652b2de..8b45ff0c22b65 100644
--- a/drivers/media/pci/intel/ipu6/ipu6.c
+++ b/drivers/media/pci/intel/ipu6/ipu6.c
@@ -399,7 +399,6 @@ ipu6_isys_init(struct pci_dev *pdev, struct device *parent,
 				       &ipdata->hw_variant);
 	if (IS_ERR(isys_adev->mmu)) {
 		put_device(&isys_adev->auxdev.dev);
-		kfree(pdata);
 		return dev_err_cast_probe(dev, isys_adev->mmu,
 				"ipu6_mmu_init(isys_adev->mmu) failed\n");
 	}
@@ -407,10 +406,8 @@ ipu6_isys_init(struct pci_dev *pdev, struct device *parent,
 	isys_adev->mmu->dev = &isys_adev->auxdev.dev;
 
 	ret = ipu6_bus_add_device(isys_adev);
-	if (ret) {
-		kfree(pdata);
+	if (ret)
 		return ERR_PTR(ret);
-	}
 
 	return isys_adev;
 }
@@ -443,7 +440,6 @@ ipu6_psys_init(struct pci_dev *pdev, struct device *parent,
 				       &ipdata->hw_variant);
 	if (IS_ERR(psys_adev->mmu)) {
 		put_device(&psys_adev->auxdev.dev);
-		kfree(pdata);
 		return dev_err_cast_probe(&pdev->dev, psys_adev->mmu,
 				"ipu6_mmu_init(psys_adev->mmu) failed\n");
 	}
@@ -451,10 +447,8 @@ ipu6_psys_init(struct pci_dev *pdev, struct device *parent,
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



