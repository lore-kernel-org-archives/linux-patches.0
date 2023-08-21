Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B655B11707
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:53:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B9EC433C8;
	Mon, 21 Aug 2023 19:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647616;
	bh=//nJYTYJUnwSL99cVb4JvsdfQfoZ/sf/e2bQkA1UuLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FFpyOi0ZjYjVz/v27slPNa+bskp/AB4iq0XoOmp/Y7oaTj5D7qr9Y6N+/7MU2WSXL
	 wRg3jJbsQaQj/HHxCwV0vMxIwRQd9uenqh8qLrjPHJ6OSllwQUMOLZAThcJnHSZS50
	 WtpM8V2QPUrQBBbtx35IWyekEnW5ZsxcLf5v5y5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Michael Kelley <mikelley@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/194] fbdev/hyperv-fb: Do not set struct fb_info.apertures
Date: Mon, 21 Aug 2023 21:40:57 +0200
Message-ID: <20230821194126.194540572@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 81d2393485f0990cf6566b0c9e0697c199f68ae5 ]

Generic fbdev drivers use the apertures field in struct fb_info to
control ownership of the framebuffer memory and graphics device. Do
not set the values in hyperv-fb.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221219160516.23436-9-tzimmermann@suse.de
Stable-dep-of: 5ae3716cfdcd ("video/aperture: Only remove sysfb on the default vga pci device")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/hyperv_fb.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv_fb.c
index 4ff25dfc865d9..d3d643cf7506c 100644
--- a/drivers/video/fbdev/hyperv_fb.c
+++ b/drivers/video/fbdev/hyperv_fb.c
@@ -995,13 +995,10 @@ static int hvfb_getmem(struct hv_device *hdev, struct fb_info *info)
 	struct pci_dev *pdev  = NULL;
 	void __iomem *fb_virt;
 	int gen2vm = efi_enabled(EFI_BOOT);
+	resource_size_t base, size;
 	phys_addr_t paddr;
 	int ret;
 
-	info->apertures = alloc_apertures(1);
-	if (!info->apertures)
-		return -ENOMEM;
-
 	if (!gen2vm) {
 		pdev = pci_get_device(PCI_VENDOR_ID_MICROSOFT,
 			PCI_DEVICE_ID_HYPERV_VIDEO, NULL);
@@ -1010,8 +1007,8 @@ static int hvfb_getmem(struct hv_device *hdev, struct fb_info *info)
 			return -ENODEV;
 		}
 
-		info->apertures->ranges[0].base = pci_resource_start(pdev, 0);
-		info->apertures->ranges[0].size = pci_resource_len(pdev, 0);
+		base = pci_resource_start(pdev, 0);
+		size = pci_resource_len(pdev, 0);
 
 		/*
 		 * For Gen 1 VM, we can directly use the contiguous memory
@@ -1034,8 +1031,8 @@ static int hvfb_getmem(struct hv_device *hdev, struct fb_info *info)
 		}
 		pr_info("Unable to allocate enough contiguous physical memory on Gen 1 VM. Using MMIO instead.\n");
 	} else {
-		info->apertures->ranges[0].base = screen_info.lfb_base;
-		info->apertures->ranges[0].size = screen_info.lfb_size;
+		base = screen_info.lfb_base;
+		size = screen_info.lfb_size;
 	}
 
 	/*
@@ -1077,9 +1074,7 @@ static int hvfb_getmem(struct hv_device *hdev, struct fb_info *info)
 	info->screen_size = dio_fb_size;
 
 getmem_done:
-	aperture_remove_conflicting_devices(info->apertures->ranges[0].base,
-					    info->apertures->ranges[0].size,
-					    false, KBUILD_MODNAME);
+	aperture_remove_conflicting_devices(base, size, false, KBUILD_MODNAME);
 
 	if (gen2vm) {
 		/* framebuffer is reallocated, clear screen_info to avoid misuse from kexec */
-- 
2.40.1



