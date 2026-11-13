Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591621;
	b=I00GARrHdeYCIQy0hXpvQKjWj0poticM+7wJFOk3xr8gCW7rJQewqnnNytjt4Mdk9Iuu
	 HRPNyxBDCDdfUHLlBm4XWGMT+9AkItP7xvKF9NsYQ/AD5itiTS0SZAPfVOGqAPOKbucsM
	 7YpeFsjTVaxVGtHxlogZgwV+J+fztQShKer06rpsx7YQdyMYi/nD1FpJkboN7351Qg+wA
	 2ffD+VYLY1+9iq4lYU5lrhVBZGY4YbxyyS5ek95FUpbuT3nNnnwGvs5I7X6zh3J8putj0
	 qZIcL+m9zX8neV+1lw1TGBrfW4fjx+vjkkmYNBZQEk91Qm0L1Ivs19UXgvY3JhicE9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UMqFRg4okrVV+pN1xXDG2paMuhh0Hw/aeKPp6Jss5bc=;
	b=n5Cntc2i0lymCw4tQiQvnrtflsSrdp9Z1HzbYcAmnD+jrKOY0LvLEvO4GsTpAqfnQh2L
	 TsT71lcH0yuhue/IW7qZ/FeZCK3t4yAxXtGTR+Tm62jl3H/CeFirp9EOlDJpO6bhEedTF
	 5elvTcDwDqaOtX5ULfI+kCxmJhj4Ipo6n8W2rEVd9ju7dw9tlzW2kHO2UstgrVlQRnChd
	 CzK8Sj+tCXtXGTglb9etRNTx3yb0azXp0iGU+I4tfvPYhqdR74+CmkyUIm8xd+wJ6UO2l
	 2AV5A6NZgZEqG7IRSYEYG4Tt8z3yqxtXw819g+wDOMc5ZPTLy+aa3UuyNWu6sFiSWqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q3fxQQ5t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A3E606B460;
	Fri, 13 Nov 2026 17:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q3fxQQ5t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533D81F000C4;
	Fri, 13 Nov 2026 17:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591621;
	bh=UMqFRg4okrVV+pN1xXDG2paMuhh0Hw/aeKPp6Jss5bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q3fxQQ5tm4vuXp61guso/dVJB/Yby0gsjT5eXa5f2c9kCZTwONepZFMpfpyWAGzu8
	 QkEsF+oW/BhwRFfp+++9bc8KfLgv21wlhaN9cc1FSZjmxDA01pYtugL2ac7kvZeDzw
	 nT1tOwwSR6jDZ+qoglhnX3JtKUdO0NTB06aze+x0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 662/670] fbdev: nvidia: Convert to managed PCI and ioremap API
Date: Fri, 13 Nov 2026 10:53:46 -0500
Message-ID: <20261113153834.330527499@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shixiong Ou <oushixiong@kylinos.cn>

[ Upstream commit a41961f364bc7aee1611796e7ab5bd687708d770 ]

Fix missing pci_disable_device() in probe and remove.

Use pcim_enable_device(), pcim_request_all_regions(),
devm_ioremap() and devm_ioremap_wc() to replace manual resource
management. Remove all pci_release_regions() and iounmap() calls.

Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Stable-dep-of: 8710af6a3520 ("fbdev: nvidia: Release write-combining handle on probe failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/nvidia/nvidia.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/video/fbdev/nvidia/nvidia.c b/drivers/video/fbdev/nvidia/nvidia.c
index 5f61d953e4c76..d298ba71ee0e3 100644
--- a/drivers/video/fbdev/nvidia/nvidia.c
+++ b/drivers/video/fbdev/nvidia/nvidia.c
@@ -1288,7 +1288,7 @@ static int nvidiafb_probe(struct pci_dev *pd, const struct pci_device_id *ent)
 	NVTRACE_ENTER();
 	assert(pd != NULL);
 
-	if (pci_enable_device(pd)) {
+	if (pcim_enable_device(pd)) {
 		printk(KERN_ERR PFX "cannot enable PCI device\n");
 		return -ENODEV;
 	}
@@ -1301,7 +1301,7 @@ static int nvidiafb_probe(struct pci_dev *pd, const struct pci_device_id *ent)
 	nvidiafb_fix.mmio_start = pci_resource_start(pd, 0);
 	nvidiafb_fix.mmio_len = pci_resource_len(pd, 0);
 
-	REGS = ioremap(nvidiafb_fix.mmio_start, nvidiafb_fix.mmio_len);
+	REGS = devm_ioremap(&pd->dev, nvidiafb_fix.mmio_start, nvidiafb_fix.mmio_len);
 	if (!REGS) {
 		printk(KERN_ERR PFX "cannot ioremap MMIO base\n");
 		return -ENODEV;
@@ -1329,7 +1329,7 @@ static int nvidiafb_probe(struct pci_dev *pd, const struct pci_device_id *ent)
 	if (info->pixmap.addr == NULL)
 		goto err_out_kfree;
 
-	if (pci_request_regions(pd, "nvidiafb")) {
+	if (pcim_request_all_regions(pd, "nvidiafb")) {
 		printk(KERN_ERR PFX "cannot request PCI regions\n");
 		goto err_out_enable;
 	}
@@ -1354,7 +1354,7 @@ static int nvidiafb_probe(struct pci_dev *pd, const struct pci_device_id *ent)
 	sprintf(nvidiafb_fix.id, "NV%x", (pd->device & 0x0ff0) >> 4);
 
 	if (NVCommonSetup(info))
-		goto err_out_free_base0;
+		goto err_out_enable;
 
 	par->FbAddress = nvidiafb_fix.smem_start;
 	par->FbMapSize = par->RamAmountKBytes * 1024;
@@ -1374,8 +1374,8 @@ static int nvidiafb_probe(struct pci_dev *pd, const struct pci_device_id *ent)
 	par->ScratchBufferStart = par->FbUsableSize - par->ScratchBufferSize;
 	par->CursorStart = par->FbUsableSize + (32 * 1024);
 
-	info->screen_base = ioremap_wc(nvidiafb_fix.smem_start,
-				       par->FbMapSize);
+	info->screen_base = devm_ioremap_wc(&pd->dev, nvidiafb_fix.smem_start,
+					    par->FbMapSize);
 	info->screen_size = par->FbUsableSize;
 	nvidiafb_fix.smem_len = par->RamAmountKBytes * 1024;
 
@@ -1419,19 +1419,15 @@ static int nvidiafb_probe(struct pci_dev *pd, const struct pci_device_id *ent)
 	return 0;
 
 err_out_iounmap_fb:
-	iounmap(info->screen_base);
 	fb_destroy_modelist(&info->modelist);
 err_out_free_base1:
 	fb_destroy_modedb(info->monspecs.modedb);
 	nvidia_delete_i2c_busses(par);
-err_out_free_base0:
-	pci_release_regions(pd);
 err_out_enable:
 	kfree(info->pixmap.addr);
 err_out_kfree:
 	framebuffer_release(info);
 err_out:
-	iounmap(REGS);
 	return -ENODEV;
 }
 
@@ -1446,11 +1442,8 @@ static void nvidiafb_remove(struct pci_dev *pd)
 	unregister_framebuffer(info);
 
 	arch_phys_wc_del(par->wc_cookie);
-	iounmap(info->screen_base);
 	fb_destroy_modedb(info->monspecs.modedb);
 	nvidia_delete_i2c_busses(par);
-	iounmap(par->REGS);
-	pci_release_regions(pd);
 	kfree(info->pixmap.addr);
 	framebuffer_release(info);
 	NVTRACE_LEAVE();
-- 
2.53.0



