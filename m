Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3735340A47
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300997; cv=none; b=IpWL9z/AubP0kdnV9QDAtanTFODhtMNGUMAbhIVDCiRsl5ZFi2SjZvFmm+DE9PecdVG89OjBdjBDYVKbLXHrIyUEIX5jhSs8OKE+25Udi4RWgcxtl21nMMU+2UEUpHywGVd1cpuIV350MZM7yX09mOaPukePts7AddOKFH3/S/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300997; c=relaxed/simple;
	bh=9GxiGJy6sVbb2FkSLTxe0naSBLEQzs4+zoaRU05ZPKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gAKPGXOsmmAfLtSR/iTB6MbSnRr/gLvQLWDwt7f8Q4RQ75AolkuGq5/OpI7Cd0fktQlDxA2F8NW4cYv5lbhI9tt2vpBgMVuUliYrJ2kLjM1EALx2R4bq6Jh9slfCGP97p5T1/Q2H19KfcwMpGBIuR8aQnm8icKeQsyQ6IAEWynI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t2zdtM8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t2zdtM8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED01AC19425;
	Sat, 28 Feb 2026 17:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300997;
	bh=9GxiGJy6sVbb2FkSLTxe0naSBLEQzs4+zoaRU05ZPKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t2zdtM8MVE5EVcXBU1y5a5/icsrCRm5uh+NfJ+lZWcvpEBdR3aRGsgAwwqBAQ7o1L
	 mhCjpNNWfHpzAvf/FoZJvRGorS9ydi9UzShn1FZel5U9jdyXVE1vjLS84WOl7xhfup
	 IJKepNgBUyPiBfGsJrTAC5e3KrICj9dbhY1vnu7my7tTn1VXaWEzeg7xT8XEIts5/e
	 xvZO34u8jQ1tS9hcVTyYPoeMkXA31kw19SDxMDlbaU6iOQBquqBYcdybuoDlBkCI67
	 hOseg/976/TvphLigD+GsOiu92gFE2ATA4IjPuOwCAslkf3jxst8Ld0GBpjN6F/ThM
	 KVckhnYh9/buA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Xiaolei Wang <xiaolei.wang@windriver.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 129/752] drm/v3d: Set DMA segment size to avoid debug warnings
Date: Sat, 28 Feb 2026 12:37:20 -0500
Message-ID: <20260228174750.1542406-129-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Xiaolei Wang <xiaolei.wang@windriver.com>

[ Upstream commit 9eb018828b1b30dfba689c060735c50fc5b9f704 ]

When using V3D rendering with CONFIG_DMA_API_DEBUG enabled, the
kernel occasionally reports a segment size mismatch. This is because
'max_seg_size' is not set. The kernel defaults to 64K. setting
'max_seg_size' to the maximum will prevent 'debug_dma_map_sg()'
from complaining about the over-mapping of the V3D segment length.

DMA-API: v3d 1002000000.v3d: mapping sg segment longer than device
 claims to support [len=8290304] [max=65536]
WARNING: CPU: 0 PID: 493 at kernel/dma/debug.c:1179 debug_dma_map_sg+0x330/0x388
CPU: 0 UID: 0 PID: 493 Comm: Xorg Not tainted 6.12.53-yocto-standard #1
Hardware name: Raspberry Pi 5 Model B Rev 1.0 (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : debug_dma_map_sg+0x330/0x388
lr : debug_dma_map_sg+0x330/0x388
sp : ffff8000829a3ac0
x29: ffff8000829a3ac0 x28: 0000000000000001 x27: ffff8000813fe000
x26: ffffc1ffc0000000 x25: ffff00010fdeb760 x24: 0000000000000000
x23: ffff8000816a9bf0 x22: 0000000000000001 x21: 0000000000000002
x20: 0000000000000002 x19: ffff00010185e810 x18: ffffffffffffffff
x17: 69766564206e6168 x16: 74207265676e6f6c x15: 20746e656d676573
x14: 20677320676e6970 x13: 5d34303334393134 x12: 0000000000000000
x11: 00000000000000c0 x10: 00000000000009c0 x9 : ffff8000800e0b7c
x8 : ffff00010a315ca0 x7 : ffff8000816a5110 x6 : 0000000000000001
x5 : 000000000000002b x4 : 0000000000000002 x3 : 0000000000000008
x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff00010a315280
Call trace:
 debug_dma_map_sg+0x330/0x388
 __dma_map_sg_attrs+0xc0/0x278
 dma_map_sgtable+0x30/0x58
 drm_gem_shmem_get_pages_sgt+0xb4/0x140
 v3d_bo_create_finish+0x28/0x130 [v3d]
 v3d_create_bo_ioctl+0x54/0x180 [v3d]
 drm_ioctl_kernel+0xc8/0x140
 drm_ioctl+0x2d4/0x4d8

Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Link: https://patch.msgid.link/20251203130323.2247072-1-xiaolei.wang@windriver.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/v3d/v3d_drv.c b/drivers/gpu/drm/v3d/v3d_drv.c
index c5a3bbbc74c5c..f4da7a94e4016 100644
--- a/drivers/gpu/drm/v3d/v3d_drv.c
+++ b/drivers/gpu/drm/v3d/v3d_drv.c
@@ -377,6 +377,8 @@ static int v3d_platform_drm_probe(struct platform_device *pdev)
 	if (ret)
 		goto clk_disable;
 
+	dma_set_max_seg_size(&pdev->dev, UINT_MAX);
+
 	v3d->va_width = 30 + V3D_GET_FIELD(mmu_debug, V3D_MMU_VA_WIDTH);
 
 	ident1 = V3D_READ(V3D_HUB_IDENT1);
-- 
2.51.0

