Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2ED79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:19:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002E4C433EF;
	Thu, 12 Jan 2023 14:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533179;
	bh=WrmNzmCWQgPwurDwRUeODuIezq3oBw0XM0H7b6bdXuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJfJA1S5kETeYs/KXFjEJLb+M5I3ZXyujiA4UboarwpDQXFpdn6ZsGXSO9Aob3NFD
	 MyWo4s6ukoFQHmpBsk8Jul8zjXaRucbqbcdEn3QKtVUj3MIeo+XW71BvSrGZdMndkz
	 FiuyLrPlyVvclX7n+SM54dZvXYwMNi9sAbKWnyck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 395/783] fbdev: pm2fb: fix missing pci_disable_device()
Date: Thu, 12 Jan 2023 14:51:51 +0100
Message-Id: <20230112135542.627828255@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

[ Upstream commit ed359a464846b48f76ea6cc5cd8257e545ac97f4 ]

Add missing pci_disable_device() in error path of probe() and remove() path.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/pm2fb.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/pm2fb.c b/drivers/video/fbdev/pm2fb.c
index c12d46e28359..87b6a929a6b3 100644
--- a/drivers/video/fbdev/pm2fb.c
+++ b/drivers/video/fbdev/pm2fb.c
@@ -1529,8 +1529,10 @@ static int pm2fb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	info = framebuffer_alloc(sizeof(struct pm2fb_par), &pdev->dev);
-	if (!info)
-		return -ENOMEM;
+	if (!info) {
+		err = -ENOMEM;
+		goto err_exit_disable;
+	}
 	default_par = info->par;
 
 	switch (pdev->device) {
@@ -1711,6 +1713,8 @@ static int pm2fb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	release_mem_region(pm2fb_fix.mmio_start, pm2fb_fix.mmio_len);
  err_exit_neither:
 	framebuffer_release(info);
+ err_exit_disable:
+	pci_disable_device(pdev);
 	return retval;
 }
 
@@ -1737,6 +1741,7 @@ static void pm2fb_remove(struct pci_dev *pdev)
 	fb_dealloc_cmap(&info->cmap);
 	kfree(info->pixmap.addr);
 	framebuffer_release(info);
+	pci_disable_device(pdev);
 }
 
 static const struct pci_device_id pm2fb_id_table[] = {
-- 
2.35.1



