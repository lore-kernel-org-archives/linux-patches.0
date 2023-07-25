Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBE61ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B48C433C7;
	Tue, 25 Jul 2023 11:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284941;
	bh=mLok0lgFzqMy5OD9rfgcmUUUh6zOX1fBIK1SQuSe8ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xj2oZuuv8DfdpH0m4eMr4j2wLM9ejJDayriW9CI6rDjfoHWV6eCh+6f5AHkzdmMvP
	 rVzvEicsOIo32t0dq874DDzrFbv3XIPUNJkWos7QodXRrJGUcRUREAr1Wyyk6dpre6
	 mb8VAGwefZj89U+R6R4mE59OjDGw8UgyxoGQf54o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Thain <fthain@telegraphics.com.au>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Rob Herring <robh@kernel.org>
Subject: [PATCH 5.4 003/313] video: imsttfb: check for ioremap() failures
Date: Tue, 25 Jul 2023 12:42:36 +0200
Message-ID: <20230725104521.334233844@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 13b7c0390a5d3840e1e2cda8f44a310fdbb982de upstream.

We should check if ioremap() were to somehow fail in imsttfb_probe() and
handle the unwinding of the resources allocated here properly.

Ideally if anyone cares about this driver (it's for a PowerMac era PCI
display card), they wouldn't even be using fbdev anymore.  Or the devm_*
apis could be used, but that's just extra work for diminishing
returns...

Cc: Finn Thain <fthain@telegraphics.com.au>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-68-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/imsttfb.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/drivers/video/fbdev/imsttfb.c
+++ b/drivers/video/fbdev/imsttfb.c
@@ -1469,6 +1469,7 @@ static int imsttfb_probe(struct pci_dev
 	struct imstt_par *par;
 	struct fb_info *info;
 	struct device_node *dp;
+	int ret = -ENOMEM;
 	
 	dp = pci_device_to_OF_node(pdev);
 	if(dp)
@@ -1504,23 +1505,37 @@ static int imsttfb_probe(struct pci_dev
 		default:
 			printk(KERN_INFO "imsttfb: Device 0x%x unknown, "
 					 "contact maintainer.\n", pdev->device);
-			release_mem_region(addr, size);
-			framebuffer_release(info);
-			return -ENODEV;
+			ret = -ENODEV;
+			goto error;
 	}
 
 	info->fix.smem_start = addr;
 	info->screen_base = (__u8 *)ioremap(addr, par->ramdac == IBM ?
 					    0x400000 : 0x800000);
+	if (!info->screen_base)
+		goto error;
 	info->fix.mmio_start = addr + 0x800000;
 	par->dc_regs = ioremap(addr + 0x800000, 0x1000);
+	if (!par->dc_regs)
+		goto error;
 	par->cmap_regs_phys = addr + 0x840000;
 	par->cmap_regs = (__u8 *)ioremap(addr + 0x840000, 0x1000);
+	if (!par->cmap_regs)
+		goto error;
 	info->pseudo_palette = par->palette;
 	init_imstt(info);
 
 	pci_set_drvdata(pdev, info);
 	return 0;
+
+error:
+	if (par->dc_regs)
+		iounmap(par->dc_regs);
+	if (info->screen_base)
+		iounmap(info->screen_base);
+	release_mem_region(addr, size);
+	framebuffer_release(info);
+	return ret;
 }
 
 static void imsttfb_remove(struct pci_dev *pdev)


