Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AA21C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:22:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A174DC433EF;
	Wed, 28 Dec 2022 16:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244545;
	bh=SzcUNELs8EVr24QcRJ18nd+cPbQCAYgJOWh5yzdJPu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2DfpDL5gZJ5U9gcS3NmhINz/1ujaCQkEF16YumRTw+6U/W4GFjmHtyu9sMLayGPhA
	 5PldmYiUJlDm60ChrxdGoYAQ60hBfN1hb/sU1jOH5N9JRgLu1Ld2p/yXbcsJ/c6Ama
	 mlTi6gg2qWiikQu4ZuqVAgKg0GTznmozwnw5KV0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0730/1073] fbdev: pm2fb: fix missing pci_disable_device()
Date: Wed, 28 Dec 2022 15:38:38 +0100
Message-Id: <20221228144347.850903098@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 8fd79deb1e2a..94f1f33f88f9 100644
--- a/drivers/video/fbdev/pm2fb.c
+++ b/drivers/video/fbdev/pm2fb.c
@@ -1528,8 +1528,10 @@ static int pm2fb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
@@ -1710,6 +1712,8 @@ static int pm2fb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	release_mem_region(pm2fb_fix.mmio_start, pm2fb_fix.mmio_len);
  err_exit_neither:
 	framebuffer_release(info);
+ err_exit_disable:
+	pci_disable_device(pdev);
 	return retval;
 }
 
@@ -1734,6 +1738,7 @@ static void pm2fb_remove(struct pci_dev *pdev)
 	fb_dealloc_cmap(&info->cmap);
 	kfree(info->pixmap.addr);
 	framebuffer_release(info);
+	pci_disable_device(pdev);
 }
 
 static const struct pci_device_id pm2fb_id_table[] = {
-- 
2.35.1



