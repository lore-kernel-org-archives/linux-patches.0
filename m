Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578E9248BA6;
	Wed, 15 Jan 2025 10:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938048; cv=none; b=rDod8emIcdsGlAjiJ7Jen3LbmaN46V9gxiJFqjGxDrUztRWoFbYeDdQuIViGuQN7N2mgKzjS7gaHKxJ3JUjecjQtyaAOBTMS6b6liCu+U72bP16BLZKJHBmQYRn96XzKZX+qZIqSFyppT1t19FwOicZ7e6JRSwkEwHqyP/11544=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938048; c=relaxed/simple;
	bh=CXk1HFZG3MPDZmSou1Mt+lqABGCcFsq/KDSfmqArv7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGr2qdZlBVXD5Ji1wTNhVKbSxqyWXJCHsZfiQdrIM5EHeorQbeszBWGPMwxxllMVYFinG7j+fPD7DFVHQvyRolCTAGp91QGMT2Pm3pHEjpdoXIFdezvNQVYm46GuPsoj0IKgE/OzN7tBMntXP7eviWcOqaGtF12DCz/ZIzO/xgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2hZ54uRv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2hZ54uRv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CA5C4CEDF;
	Wed, 15 Jan 2025 10:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938048;
	bh=CXk1HFZG3MPDZmSou1Mt+lqABGCcFsq/KDSfmqArv7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2hZ54uRvEKI6CcbjW2jfwLcqoCtRuWD0UsGPOJkp+13rt0JSgqIJsMYRX01cA5Ney
	 +rhkfGCvme89eXqT6d31bUrxwKQWJeZcYP101D4FMKhclmLx5/FZRxr7wNDxRfYS5K
	 +ab6WJANBeqb5AkclOWoAAb88qOEp1d2VS19dxTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoqing Jiang <guoqing.jiang@canonical.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 060/189] drm/mediatek: Set private->all_drm_private[i]->drm to NULL if mtk_drm_bind returns err
Date: Wed, 15 Jan 2025 11:35:56 +0100
Message-ID: <20250115103608.754349287@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoqing Jiang <guoqing.jiang@canonical.com>

[ Upstream commit 36684e9d88a2e2401ae26715a2e217cb4295cea7 ]

The pointer need to be set to NULL, otherwise KASAN complains about
use-after-free. Because in mtk_drm_bind, all private's drm are set
as follows.

private->all_drm_private[i]->drm = drm;

And drm will be released by drm_dev_put in case mtk_drm_kms_init returns
failure. However, the shutdown path still accesses the previous allocated
memory in drm_atomic_helper_shutdown.

[   84.874820] watchdog: watchdog0: watchdog did not stop!
[   86.512054] ==================================================================
[   86.513162] BUG: KASAN: use-after-free in drm_atomic_helper_shutdown+0x33c/0x378
[   86.514258] Read of size 8 at addr ffff0000d46fc068 by task shutdown/1
[   86.515213]
[   86.515455] CPU: 1 UID: 0 PID: 1 Comm: shutdown Not tainted 6.13.0-rc1-mtk+gfa1a78e5d24b-dirty #55
[   86.516752] Hardware name: Unknown Product/Unknown Product, BIOS 2022.10 10/01/2022
[   86.517960] Call trace:
[   86.518333]  show_stack+0x20/0x38 (C)
[   86.518891]  dump_stack_lvl+0x90/0xd0
[   86.519443]  print_report+0xf8/0x5b0
[   86.519985]  kasan_report+0xb4/0x100
[   86.520526]  __asan_report_load8_noabort+0x20/0x30
[   86.521240]  drm_atomic_helper_shutdown+0x33c/0x378
[   86.521966]  mtk_drm_shutdown+0x54/0x80
[   86.522546]  platform_shutdown+0x64/0x90
[   86.523137]  device_shutdown+0x260/0x5b8
[   86.523728]  kernel_restart+0x78/0xf0
[   86.524282]  __do_sys_reboot+0x258/0x2f0
[   86.524871]  __arm64_sys_reboot+0x90/0xd8
[   86.525473]  invoke_syscall+0x74/0x268
[   86.526041]  el0_svc_common.constprop.0+0xb0/0x240
[   86.526751]  do_el0_svc+0x4c/0x70
[   86.527251]  el0_svc+0x4c/0xc0
[   86.527719]  el0t_64_sync_handler+0x144/0x168
[   86.528367]  el0t_64_sync+0x198/0x1a0
[   86.528920]
[   86.529157] The buggy address belongs to the physical page:
[   86.529972] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff0000d46fd4d0 pfn:0x1146fc
[   86.531319] flags: 0xbfffc0000000000(node=0|zone=2|lastcpupid=0xffff)
[   86.532267] raw: 0bfffc0000000000 0000000000000000 dead000000000122 0000000000000000
[   86.533390] raw: ffff0000d46fd4d0 0000000000000000 00000000ffffffff 0000000000000000
[   86.534511] page dumped because: kasan: bad access detected
[   86.535323]
[   86.535559] Memory state around the buggy address:
[   86.536265]  ffff0000d46fbf00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   86.537314]  ffff0000d46fbf80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   86.538363] >ffff0000d46fc000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   86.544733]                                                           ^
[   86.551057]  ffff0000d46fc080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   86.557510]  ffff0000d46fc100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   86.563928] ==================================================================
[   86.571093] Disabling lock debugging due to kernel taint
[   86.577642] Unable to handle kernel paging request at virtual address e0e9c0920000000b
[   86.581834] KASAN: maybe wild-memory-access in range [0x0752049000000058-0x075204900000005f]
...

Fixes: 1ef7ed48356c ("drm/mediatek: Modify mediatek-drm for mt8195 multi mmsys support")
Signed-off-by: Guoqing Jiang <guoqing.jiang@canonical.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20241223023227.1258112-1-guoqing.jiang@canonical.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_drv.c b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
index 2c1cb335d862..4e93fd075e03 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -673,6 +673,8 @@ static int mtk_drm_bind(struct device *dev)
 err_free:
 	private->drm = NULL;
 	drm_dev_put(drm);
+	for (i = 0; i < private->data->mmsys_dev_num; i++)
+		private->all_drm_private[i]->drm = NULL;
 	return ret;
 }
 
-- 
2.39.5



