Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62022264A9C;
	Tue, 25 Mar 2025 12:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905515; cv=none; b=KOXWbqrQAmwT0QeU1f6SF/aVmNE154VUZ+R59EUmJn2Iu0P/D25iT4M+1OGcGeADl0AVPcuf6uMVfpLFKy35tYku9+s6YSge2tJvuwTfgf34oJl7c1A8p/xHMC8jQpXKU26EJvyCT1f2F4tQcNKUmQLb06sBPq91bl5qWqzT/a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905515; c=relaxed/simple;
	bh=qjg00AjKopgYsjYis2pM1T75WrufeKXRhRNWD2htHzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8AYjS9yd0rYTW/6jwDK3Edg19AUSgIe01uUhorHv50p8knDqpsp2sYQqeDW63wDLdW1/bFTVMJk3Fc4mRA0l7Afs1EX0VH0ROBpXtUOSW+Gpc3z6h2grJ7MwSPCZc3sluD/lsNhK6qjzmjaTCRiK27CQ67yVrgDobEGGTioYVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=czRDl6dI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="czRDl6dI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C3AC4CEE4;
	Tue, 25 Mar 2025 12:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905515;
	bh=qjg00AjKopgYsjYis2pM1T75WrufeKXRhRNWD2htHzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=czRDl6dI9ge9C2Fs2agHe8RmA5OjVT09/BbP+dtZXm+eFXPWzf+ChHs9x/XScMe4X
	 FMNdaj9IERl9QdtkTo8SDyNrAsTuvPq+8iTJI9O+/si5SfjVGkUZ3CImRnvLMPyl9G
	 427+SiMIbCd0B19UqUIAaiLjBf+unlzkzNZHc2rY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/198] drm/hyperv: Fix address space leak when Hyper-V DRM device is removed
Date: Tue, 25 Mar 2025 08:19:39 -0400
Message-ID: <20250325122157.092602103@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Kelley <mhklinux@outlook.com>

[ Upstream commit aed709355fd05ef747e1af24a1d5d78cd7feb81e ]

When a Hyper-V DRM device is probed, the driver allocates MMIO space for
the vram, and maps it cacheable. If the device removed, or in the error
path for device probing, the MMIO space is released but no unmap is done.
Consequently the kernel address space for the mapping is leaked.

Fix this by adding iounmap() calls in the device removal path, and in the
error path during device probing.

Fixes: f1f63cbb705d ("drm/hyperv: Fix an error handling path in hyperv_vmbus_probe()")
Fixes: a0ab5abced55 ("drm/hyperv : Removing the restruction of VRAM allocation with PCI bar size")
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Tested-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Link: https://lore.kernel.org/r/20250210193441.2414-1-mhklinux@outlook.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20250210193441.2414-1-mhklinux@outlook.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/hyperv/hyperv_drm_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/hyperv/hyperv_drm_drv.c b/drivers/gpu/drm/hyperv/hyperv_drm_drv.c
index 68050409dd26c..499c7c8916df2 100644
--- a/drivers/gpu/drm/hyperv/hyperv_drm_drv.c
+++ b/drivers/gpu/drm/hyperv/hyperv_drm_drv.c
@@ -157,6 +157,7 @@ static int hyperv_vmbus_probe(struct hv_device *hdev,
 	return 0;
 
 err_free_mmio:
+	iounmap(hv->vram);
 	vmbus_free_mmio(hv->mem->start, hv->fb_size);
 err_vmbus_close:
 	vmbus_close(hdev->channel);
@@ -175,6 +176,7 @@ static int hyperv_vmbus_remove(struct hv_device *hdev)
 	vmbus_close(hdev->channel);
 	hv_set_drvdata(hdev, NULL);
 
+	iounmap(hv->vram);
 	vmbus_free_mmio(hv->mem->start, hv->fb_size);
 
 	return 0;
-- 
2.39.5



