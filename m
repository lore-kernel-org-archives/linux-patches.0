Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44133D4120;
	Thu, 15 Jan 2026 17:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499576; cv=none; b=QpEDyvbByF0kPoaAUFPd/tPV1UlWdrEt1GzHYn5u/A48LqUwaDRNA8xvKn45+j+Uh9hix+d0Q8Z0UFhaBPTyU8t76nQF0IiL8TrioCWTqueCy8DyJbsmdtIaTR7jEKE/64yXBCmfQNbIpA13IrqQIeKafpdToyRHjua88eF+qBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499576; c=relaxed/simple;
	bh=nhE+vBNWinvRgL79SpfdkwdYx1vOTb7z2YduHY8OLVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elpweCK10a/CFGqfk58bJMA1qpsnoUOXDj3VpgwSOXN/gE7A/L+RBM5zW2ktpF6jgJ1awiODz8BmH7TaOq3IbTfUX3r/5m3Xkh0ctTSoRyuhcwD+xTJNOEyVvdM0OfgbCG8AlciwPi82JSv7kiz4bL4kvTy1443ZQIZ6kiu7Aec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RMx2dewM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RMx2dewM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F821C19423;
	Thu, 15 Jan 2026 17:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499576;
	bh=nhE+vBNWinvRgL79SpfdkwdYx1vOTb7z2YduHY8OLVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RMx2dewMNauGTbjotWRHXLPe3pxhxVXqS4zMng8vdwENSXIkvXFgQ4CysZDublBrM
	 IPYgzJEK5RoPIlDfxSb1sYMMTgOAqULx7W/x46HmIKD7QDJ6/cGXg0SqLUPcIvp9Cs
	 ZBZ/I4FL9/Z9VVQ/Sc59+ZpNhQJv8b9kR4pI7bU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.10 268/451] i2c: amd-mp2: fix reference leak in MP2 PCI device
Date: Thu, 15 Jan 2026 17:47:49 +0100
Message-ID: <20260115164240.581743716@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit a6ee6aac66fb394b7f6e6187c73bdcd873f2d139 upstream.

In i2c_amd_probe(), amd_mp2_find_device() utilizes
driver_find_next_device() which internally calls driver_find_device()
to locate the matching device. driver_find_device() increments the
reference count of the found device by calling get_device(), but
amd_mp2_find_device() fails to call put_device() to decrement the
reference count before returning. This results in a reference count
leak of the PCI device each time i2c_amd_probe() is executed, which
may prevent the device from being properly released and cause a memory
leak.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 529766e0a011 ("i2c: Add drivers for the AMD PCIe MP2 I2C controller")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20251022095402.8846-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-amd-mp2-pci.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-amd-mp2-pci.c
+++ b/drivers/i2c/busses/i2c-amd-mp2-pci.c
@@ -461,13 +461,16 @@ struct amd_mp2_dev *amd_mp2_find_device(
 {
 	struct device *dev;
 	struct pci_dev *pci_dev;
+	struct amd_mp2_dev *mp2_dev;
 
 	dev = driver_find_next_device(&amd_mp2_pci_driver.driver, NULL);
 	if (!dev)
 		return NULL;
 
 	pci_dev = to_pci_dev(dev);
-	return (struct amd_mp2_dev *)pci_get_drvdata(pci_dev);
+	mp2_dev = (struct amd_mp2_dev *)pci_get_drvdata(pci_dev);
+	put_device(dev);
+	return mp2_dev;
 }
 EXPORT_SYMBOL_GPL(amd_mp2_find_device);
 


