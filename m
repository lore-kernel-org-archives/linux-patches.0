Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C361C2561C5;
	Mon, 24 Feb 2025 14:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408010; cv=none; b=p2ht53RlH3WgeW7URQSf64xCsKxMJhTxrSmzE5+LFAE6WGJfSkaMSzCrwN70uc2l3uvZBJYMrWsPLaQUVSA6dPsReAyDQGtiUUBhpxP6ARLuT2nlTwxFRtEBYjjXk5r5oCNj9cjj0HKopn4aSLS37HWivqztUI3uY4TOQ/HgTl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408010; c=relaxed/simple;
	bh=LhFGchTbkFROj1loHdovCT6IqA9d/I6jGD/Pqzj/3zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7ZQpabTJmbVW5YuKhzAcrnjVULiQFyhYCEEKWi+3IeEs5eaiqv06GP1YC61CgTgvKTHvMb4pz+TCcWEE4On+Nilj1/Z+dP5gVaGAcztJEMnIhYVvnZetVMcaUyDOEWO5DEdUQajoXYc7iN+/MHjGxT+g3OYnKv4+1tJSPZE3eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sMoN2FfR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sMoN2FfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4E9C4CED6;
	Mon, 24 Feb 2025 14:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408010;
	bh=LhFGchTbkFROj1loHdovCT6IqA9d/I6jGD/Pqzj/3zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sMoN2FfRy1bgKbrx1CGEwz+TFbCDxuF3Dg1rDYa9eXfJxtuoVgiTjOr2hKPUUcUoi
	 ol3aIQWVKHa+rufiNrEVifrVUOtiZGKTMWq2DfXK1P52+Ni7MZLuCtOxeOMTrG1ehG
	 1AB7DyXxtSEqYWq0Oot7mK8A1ak7dyjgfhrBLGDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Julian Ruess <julianr@linux.ibm.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/140] s390/ism: add release function for struct device
Date: Mon, 24 Feb 2025 15:34:33 +0100
Message-ID: <20250224142605.915406919@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

From: Julian Ruess <julianr@linux.ibm.com>

[ Upstream commit 915e34d5ad35a6a9e56113f852ade4a730fb88f0 ]

According to device_release() in /drivers/base/core.c,
a device without a release function is a broken device
and must be fixed.

The current code directly frees the device after calling device_add()
without waiting for other kernel parts to release their references.
Thus, a reference could still be held to a struct device,
e.g., by sysfs, leading to potential use-after-free
issues if a proper release function is not set.

Fixes: 8c81ba20349d ("net/smc: De-tangle ism and smc device initialization")
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Signed-off-by: Julian Ruess <julianr@linux.ibm.com>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250214120137.563409-1-wintera@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/ism_drv.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index f6a0626a6b3ec..af0d90beba638 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -611,6 +611,15 @@ static int ism_dev_init(struct ism_dev *ism)
 	return ret;
 }
 
+static void ism_dev_release(struct device *dev)
+{
+	struct ism_dev *ism;
+
+	ism = container_of(dev, struct ism_dev, dev);
+
+	kfree(ism);
+}
+
 static int ism_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct ism_dev *ism;
@@ -624,6 +633,7 @@ static int ism_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	dev_set_drvdata(&pdev->dev, ism);
 	ism->pdev = pdev;
 	ism->dev.parent = &pdev->dev;
+	ism->dev.release = ism_dev_release;
 	device_initialize(&ism->dev);
 	dev_set_name(&ism->dev, dev_name(&pdev->dev));
 	ret = device_add(&ism->dev);
@@ -660,7 +670,7 @@ static int ism_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	device_del(&ism->dev);
 err_dev:
 	dev_set_drvdata(&pdev->dev, NULL);
-	kfree(ism);
+	put_device(&ism->dev);
 
 	return ret;
 }
@@ -706,7 +716,7 @@ static void ism_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 	device_del(&ism->dev);
 	dev_set_drvdata(&pdev->dev, NULL);
-	kfree(ism);
+	put_device(&ism->dev);
 }
 
 static struct pci_driver ism_driver = {
-- 
2.39.5



