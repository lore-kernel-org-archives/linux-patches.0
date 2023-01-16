Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D625733F0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B802C433EF;
	Mon, 16 Jan 2023 16:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886085;
	bh=EpxBNJwcm9a8nfr5KG8vZQngwl1afZwch0/a3FladsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XX5XgUgbDIB1XyLyF05pM9OthGlPX+H5aMYSgbye8ykbdX7et4el97qLGS8iq7Aoc
	 hxJ2W4nS+4jSHZ0PSSm55OwcKHVVlRf3kslmRsTooQV7eowHAbWXmu5laZU8Dd2dPS
	 OwnptMG1BBGzwEjvDL437JDqzVUW/YgllAzclWCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Frederic Barrat <fbarrat@linux.ibm.com>,
	Andrew Donnellan <ajd@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 297/658] cxl: fix possible null-ptr-deref in cxl_pci_init_afu|adapter()
Date: Mon, 16 Jan 2023 16:46:25 +0100
Message-Id: <20230116154923.185213247@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 02cd3032b154fa02fdf90e7467abaeed889330b2 ]

If device_register() fails in cxl_pci_afu|adapter(), the device
is not added, device_unregister() can not be called in the error
path, otherwise it will cause a null-ptr-deref because of removing
not added device.

As comment of device_register() says, it should use put_device() to give
up the reference in the error path. So split device_unregister() into
device_del() and put_device(), then goes to put dev when register fails.

Fixes: f204e0b8cedd ("cxl: Driver code for powernv PCIe based cards for userspace access")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Frederic Barrat <fbarrat@linux.ibm.com>
Acked-by: Andrew Donnellan <ajd@linux.ibm.com>
Link: https://lore.kernel.org/r/20221111145440.2426970-2-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/cxl/pci.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/cxl/pci.c b/drivers/misc/cxl/pci.c
index 2ba899f5659f..0ac3f4cb88ac 100644
--- a/drivers/misc/cxl/pci.c
+++ b/drivers/misc/cxl/pci.c
@@ -1164,10 +1164,10 @@ static int pci_init_afu(struct cxl *adapter, int slice, struct pci_dev *dev)
 	 * if it returns an error!
 	 */
 	if ((rc = cxl_register_afu(afu)))
-		goto err_put1;
+		goto err_put_dev;
 
 	if ((rc = cxl_sysfs_afu_add(afu)))
-		goto err_put1;
+		goto err_del_dev;
 
 	adapter->afu[afu->slice] = afu;
 
@@ -1176,10 +1176,12 @@ static int pci_init_afu(struct cxl *adapter, int slice, struct pci_dev *dev)
 
 	return 0;
 
-err_put1:
+err_del_dev:
+	device_del(&afu->dev);
+err_put_dev:
 	pci_deconfigure_afu(afu);
 	cxl_debugfs_afu_remove(afu);
-	device_unregister(&afu->dev);
+	put_device(&afu->dev);
 	return rc;
 
 err_free_native:
@@ -1667,23 +1669,25 @@ static struct cxl *cxl_pci_init_adapter(struct pci_dev *dev)
 	 * even if it returns an error!
 	 */
 	if ((rc = cxl_register_adapter(adapter)))
-		goto err_put1;
+		goto err_put_dev;
 
 	if ((rc = cxl_sysfs_adapter_add(adapter)))
-		goto err_put1;
+		goto err_del_dev;
 
 	/* Release the context lock as adapter is configured */
 	cxl_adapter_context_unlock(adapter);
 
 	return adapter;
 
-err_put1:
+err_del_dev:
+	device_del(&adapter->dev);
+err_put_dev:
 	/* This should mirror cxl_remove_adapter, except without the
 	 * sysfs parts
 	 */
 	cxl_debugfs_adapter_remove(adapter);
 	cxl_deconfigure_adapter(adapter);
-	device_unregister(&adapter->dev);
+	put_device(&adapter->dev);
 	return ERR_PTR(rc);
 
 err_release:
-- 
2.35.1



