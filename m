Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A562918030
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 22:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DIlc2BhC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52EE4C433C8;
	Wed, 15 Nov 2023 22:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700085891;
	bh=KFb1G6+NVkVdizHvbfhE/5KIBRx5u3cVWCmSHnMbC/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DIlc2BhCfVeylthtBlx6UQyV4+GTS0EcJ830tEhHPvq/bz+HWLxZ1sZYQt7LqMVeu
	 DICfw/wju7+KDdYGwaq/0BO0JV+eVmxmkGKedbzFNLFDQge8lXhFDI1XrMpW73ZZIy
	 z6sjodsmHE83PggybHPOT6dlg5ZgtUDhp1akerWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 116/119] fbdev: imsttfb: fix a resource leak in probe
Date: Wed, 15 Nov 2023 17:01:46 -0500
Message-ID: <20231115220136.267431432@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115220132.607437515@linuxfoundation.org>
References: <20231115220132.607437515@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit aba6ab57a910ad4b940c2024d15f2cdbf5b7f76b ]

I've re-written the error handling but the bug is that if init_imstt()
fails we need to call iounmap(par->cmap_regs).

Fixes: c75f5a550610 ("fbdev: imsttfb: Fix use after free bug in imsttfb_probe")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/imsttfb.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/video/fbdev/imsttfb.c b/drivers/video/fbdev/imsttfb.c
index 0c8b72702ce59..3155424cca6bd 100644
--- a/drivers/video/fbdev/imsttfb.c
+++ b/drivers/video/fbdev/imsttfb.c
@@ -1489,8 +1489,8 @@ static int imsttfb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	if (!request_mem_region(addr, size, "imsttfb")) {
 		printk(KERN_ERR "imsttfb: Can't reserve memory region\n");
-		framebuffer_release(info);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto release_info;
 	}
 
 	switch (pdev->device) {
@@ -1507,36 +1507,39 @@ static int imsttfb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			printk(KERN_INFO "imsttfb: Device 0x%x unknown, "
 					 "contact maintainer.\n", pdev->device);
 			ret = -ENODEV;
-			goto error;
+			goto release_mem_region;
 	}
 
 	info->fix.smem_start = addr;
 	info->screen_base = (__u8 *)ioremap(addr, par->ramdac == IBM ?
 					    0x400000 : 0x800000);
 	if (!info->screen_base)
-		goto error;
+		goto release_mem_region;
 	info->fix.mmio_start = addr + 0x800000;
 	par->dc_regs = ioremap(addr + 0x800000, 0x1000);
 	if (!par->dc_regs)
-		goto error;
+		goto unmap_screen_base;
 	par->cmap_regs_phys = addr + 0x840000;
 	par->cmap_regs = (__u8 *)ioremap(addr + 0x840000, 0x1000);
 	if (!par->cmap_regs)
-		goto error;
+		goto unmap_dc_regs;
 	info->pseudo_palette = par->palette;
 	ret = init_imstt(info);
 	if (ret)
-		goto error;
+		goto unmap_cmap_regs;
 
 	pci_set_drvdata(pdev, info);
-	return ret;
+	return 0;
 
-error:
-	if (par->dc_regs)
-		iounmap(par->dc_regs);
-	if (info->screen_base)
-		iounmap(info->screen_base);
+unmap_cmap_regs:
+	iounmap(par->cmap_regs);
+unmap_dc_regs:
+	iounmap(par->dc_regs);
+unmap_screen_base:
+	iounmap(info->screen_base);
+release_mem_region:
 	release_mem_region(addr, size);
+release_info:
 	framebuffer_release(info);
 	return ret;
 }
-- 
2.42.0



