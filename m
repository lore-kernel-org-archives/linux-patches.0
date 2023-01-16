Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E428F6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:49:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A131C433D2;
	Mon, 16 Jan 2023 16:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887741;
	bh=BYFRrPIp7shb0I3/3bO1VKD3v3gQoCweC9GQK7nmIOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ks7YefGd/h+Nh2dEh0cEZZEa8YyL/7XATMcli/JgWM21wWrvCvXFTwvBuQ4G6Zi8L
	 80QxBkxTOmscRYUOWxhBwQrZBRIHapHSRNPnlZ+hQ5aVZxjOFixLdzyByaWLgHZCLI
	 gIRM81/JjsShPPSKo2AweJbQbkIaU05+6Tc3w8vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Andrew Donnellan <ajd@linux.ibm.com>,
	Frederic Barrat <fbarrat@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 235/521] cxl: fix possible null-ptr-deref in cxl_guest_init_afu|adapter()
Date: Mon, 16 Jan 2023 16:48:17 +0100
Message-Id: <20230116154857.641296630@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

[ Upstream commit 61c80d1c3833e196256fb060382db94f24d3d9a7 ]

If device_register() fails in cxl_register_afu|adapter(), the device
is not added, device_unregister() can not be called in the error path,
otherwise it will cause a null-ptr-deref because of removing not added
device.

As comment of device_register() says, it should use put_device() to give
up the reference in the error path. So split device_unregister() into
device_del() and put_device(), then goes to put dev when register fails.

Fixes: 14baf4d9c739 ("cxl: Add guest-specific code")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Andrew Donnellan <ajd@linux.ibm.com>
Acked-by: Frederic Barrat <fbarrat@linux.ibm.com>
Link: https://lore.kernel.org/r/20221111145440.2426970-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/cxl/guest.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/cxl/guest.c b/drivers/misc/cxl/guest.c
index 08f4a512afad..3153cf1651a2 100644
--- a/drivers/misc/cxl/guest.c
+++ b/drivers/misc/cxl/guest.c
@@ -963,10 +963,10 @@ int cxl_guest_init_afu(struct cxl *adapter, int slice, struct device_node *afu_n
 	 * if it returns an error!
 	 */
 	if ((rc = cxl_register_afu(afu)))
-		goto err_put1;
+		goto err_put_dev;
 
 	if ((rc = cxl_sysfs_afu_add(afu)))
-		goto err_put1;
+		goto err_del_dev;
 
 	/*
 	 * pHyp doesn't expose the programming models supported by the
@@ -982,7 +982,7 @@ int cxl_guest_init_afu(struct cxl *adapter, int slice, struct device_node *afu_n
 		afu->modes_supported = CXL_MODE_DIRECTED;
 
 	if ((rc = cxl_afu_select_best_mode(afu)))
-		goto err_put2;
+		goto err_remove_sysfs;
 
 	adapter->afu[afu->slice] = afu;
 
@@ -1002,10 +1002,12 @@ int cxl_guest_init_afu(struct cxl *adapter, int slice, struct device_node *afu_n
 
 	return 0;
 
-err_put2:
+err_remove_sysfs:
 	cxl_sysfs_afu_remove(afu);
-err_put1:
-	device_unregister(&afu->dev);
+err_del_dev:
+	device_del(&afu->dev);
+err_put_dev:
+	put_device(&afu->dev);
 	free = false;
 	guest_release_serr_irq(afu);
 err2:
@@ -1139,18 +1141,20 @@ struct cxl *cxl_guest_init_adapter(struct device_node *np, struct platform_devic
 	 * even if it returns an error!
 	 */
 	if ((rc = cxl_register_adapter(adapter)))
-		goto err_put1;
+		goto err_put_dev;
 
 	if ((rc = cxl_sysfs_adapter_add(adapter)))
-		goto err_put1;
+		goto err_del_dev;
 
 	/* release the context lock as the adapter is configured */
 	cxl_adapter_context_unlock(adapter);
 
 	return adapter;
 
-err_put1:
-	device_unregister(&adapter->dev);
+err_del_dev:
+	device_del(&adapter->dev);
+err_put_dev:
+	put_device(&adapter->dev);
 	free = false;
 	cxl_guest_remove_chardev(adapter);
 err1:
-- 
2.35.1



