Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F8B1DE899;
	Wed, 19 Mar 2025 14:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395171; cv=none; b=TjSskN/A+mUKMrEUYlte3q7KTBq0/po46M2DKfn8ufREulYY+twctXB/+s0Ukciqj0PcSrlMaxtxN5K2poCfbTzqhs9duS9JzWx56Ant6R0+C4Uk5yVYLnOeoW9NwPXwAHJVY/mq9jp3oOSOBduTQ/9j2uf4/VtSoRZSXNCEiNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395171; c=relaxed/simple;
	bh=STe0VC9BsPwSU9ZRLTIS2b9s2UR2GgFF7+dH/F8XkUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9JarA1bcJf862/kaqjgnihJMUdkeNgdJihDoRxPP598GMdxYLzsc3bY1Yw6G7oe706Mlxpv2nAUezsn4hve/Zf0Rul7HreG9N5g04qQgXBkrxscQENJUfgXFCpu2TFwpdskr5He7wBonxA44bETSFbyRoKI9CKcJuWBsaBw0I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+OY1atp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+OY1atp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2DBC4CEE4;
	Wed, 19 Mar 2025 14:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395171;
	bh=STe0VC9BsPwSU9ZRLTIS2b9s2UR2GgFF7+dH/F8XkUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f+OY1atp3+i6f+tqJn2H1hgxGXiYuwzhQygrC4myneWdcjkRvWD0/T7gOAgW9WUtV
	 rhGwapSjRW+fjpmGOaT3ApeoKpzgBafhXBG7S0MfYg1ox12JptXw/Mv4lGq2goBwIC
	 KdMzaZoYggoPFBwUC/iDh7INN85oL7JNIXoDPnw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/166] drm/hyperv: Fix address space leak when Hyper-V DRM device is removed
Date: Wed, 19 Mar 2025 07:29:52 -0700
Message-ID: <20250319143020.558591215@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8026118c6e033..8a7933f5c6ebe 100644
--- a/drivers/gpu/drm/hyperv/hyperv_drm_drv.c
+++ b/drivers/gpu/drm/hyperv/hyperv_drm_drv.c
@@ -157,6 +157,7 @@ static int hyperv_vmbus_probe(struct hv_device *hdev,
 	return 0;
 
 err_free_mmio:
+	iounmap(hv->vram);
 	vmbus_free_mmio(hv->mem->start, hv->fb_size);
 err_vmbus_close:
 	vmbus_close(hdev->channel);
@@ -175,6 +176,7 @@ static void hyperv_vmbus_remove(struct hv_device *hdev)
 	vmbus_close(hdev->channel);
 	hv_set_drvdata(hdev, NULL);
 
+	iounmap(hv->vram);
 	vmbus_free_mmio(hv->mem->start, hv->fb_size);
 }
 
-- 
2.39.5



